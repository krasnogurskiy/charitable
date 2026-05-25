package com.example.charitable.controller;

import com.example.charitable.domain.User;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.Map;

@Controller
public class VerificationController {

    @Autowired
    private UserRepo userRepo;

    @PersistenceContext
    private EntityManager entityManager;

    // Підтягує посилання з Heroku (KEY: PYTHON_SERVICE_URL). Якщо його немає — бере localhost
    @Value("${PYTHON_SERVICE_URL:http://localhost:5000}")
    private String pythonServiceUrl;

    @PostMapping("/profile/verify")
    @ResponseBody
    @Transactional // Фіксує COMMIT транзакції у PostgreSQL
    public String handleVerification(
            @RequestParam("userId") long userId,
            @RequestParam(value = "passport", required = false) MultipartFile passportFile,
            @RequestParam(value = "selfie", required = false) MultipartFile selfieFile) {

        System.out.println("========== [JAVA BACKEND] МЕТОД КОНТРОЛЕРА ЗАПУЩЕНО ==========");
        System.out.println("[JAVA] Користувач ID: " + userId);

        // 1. СТРОГА ПЕРЕВІРКА НА НАЯВНІСТЬ ТА ПОРОЖНЕЧУ ФАЙЛІВ
        if (passportFile == null || passportFile.isEmpty() || selfieFile == null || selfieFile.isEmpty()) {
            System.out.println("[JAVA REJECT] Файли не передані, дорівнюють null або порожні! Відхилено.");
            return "FAILED_NO_FILES";
        }

        System.out.println("[JAVA] Файли успішно отримано. Пересилаємо на Python Flask...");

        // 2. НАДСИЛАННЯ ФАЙЛІВ НА PYTHON ШІ-МІКРОСЕРВІС
        try {
            RestTemplate restTemplate = new RestTemplate();

            // Збираємо повний URL на основі динамічної змінної оточення
            String pythonUrl = pythonServiceUrl + "/api/ai/compare";
            System.out.println("[JAVA] Запит прямує на URL: " + pythonUrl);

            // Формуємо заголовки для Multipart
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

            // Перетворюємо масив байтів файлів у ByteArrayResource із вказанням імені
            body.add("passport", new ByteArrayResource(passportFile.getBytes()) {
                @Override
                public String getFilename() { return "passport.jpg"; }
            });
            body.add("selfie", new ByteArrayResource(selfieFile.getBytes()) {
                @Override
                public String getFilename() { return "selfie.jpg"; }
            });

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            // Робимо синхронний HTTP POST запит до нашого Python мікросервісу
            ResponseEntity<Map> response = restTemplate.postForEntity(pythonUrl, requestEntity, Map.class);
            Map<String, Object> result = response.getBody();

            if (result != null) {
                boolean verified = (boolean) result.getOrDefault("verified", false);
                double similarity = ((Number) result.getOrDefault("similarity", 0.0)).doubleValue();
                System.out.println("[JAVA <- PYTHON] Вердикт ШІ: Verified=" + verified + ", Similarity=" + similarity);

                if (!verified) {
                    System.out.println("[JAVA REJECT] Верифікацію відхилено ШІ: обличчя не збігаються.");
                    return "FAILED_AI";
                }
            } else {
                System.out.println("[JAVA ERROR] Порожня відповідь (null body) від Python сервера.");
                return "SERVER_ERROR";
            }

        } catch (Exception e) {
            System.out.println("[JAVA CRITICAL ERROR] Python сервер недоступний! Блокуємо автономний пропуск.");
            e.printStackTrace();
            return "PYTHON_DOWN"; // Перериваємо виконання методу, роль у базі НЕ зміниться
        }

        // 3. ОНОВЛЕННЯ РОЛЕЙ У БАЗІ ДАНИХ ТА СЕСІЇ (Виконується лише за умови 100% успіху ШІ)
        try {
            userRepo.clearUserRoles(userId);
            System.out.println("[AI KYC] Старі ролі успішно видалено з бази даних.");

            userRepo.insertHelpSeekerRole(userId);
            System.out.println("[AI KYC] Нову роль HELP_SEEKER успішно записано.");

            entityManager.flush();
            entityManager.clear();

            User dbUser = userRepo.findById(userId);

            if (dbUser != null) {
                System.out.println("[AI KYC] Користувача знайдено в базі після апдейту. Ролей: " + dbUser.getRoles().size());

                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                Object credentials = (auth != null) ? auth.getCredentials() : null;

                Authentication newAuth = new UsernamePasswordAuthenticationToken(
                        dbUser,
                        credentials,
                        dbUser.getAuthorities()
                );
                SecurityContextHolder.getContext().setAuthentication(newAuth);

                System.out.println("[SUCCESS] Базу даних та сесію користувача успішно оновлено!");
                return "SUCCESS";
            } else {
                System.out.println("[AI KYC ERROR] Не вдалося знайти користувача з ID " + userId + " після апдейту ролі!");
                return "ERROR";
            }
        } catch (Exception e) {
            System.out.println("[AI KYC CRITICAL ERROR] Сталася помилка під час виконання транзакції у БД!");
            e.printStackTrace();
            return "ERROR";
        }
    }
}