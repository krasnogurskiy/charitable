//package com.example.charitable.controller;
//
//import com.example.charitable.domain.User;
//import com.example.charitable.repos.UserRepo;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.stereotype.Controller;
//import org.springframework.transaction.annotation.Transactional;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import javax.persistence.EntityManager;
//import javax.persistence.PersistenceContext;
//
//@Controller
//public class VerificationController {
//
//    @Autowired
//    private UserRepo userRepo;
//
//    // Впроваджуємо менеджер сутностей для примусового скидання кешу Hibernate
//    @PersistenceContext
//    private EntityManager entityManager;
//
//    /**
//     * Фінальний тригер, який викликається асинхронно через AJAX на Кроці 3.
//     */
//    @PostMapping("/profile/verify")
//    @ResponseBody
//    @Transactional // Фіксує COMMIT транзакції у PostgreSQL
//    public String handleVerification(@RequestParam("userId") long userId) {
//        System.out.println("========== [AI KYC] МЕТОД КОНТРОЛЕРА ЗАПУЩЕНО ==========");
//        System.out.println("[AI KYC] Отримано залізобетонний ID з фронтенду: " + userId);
//
//        try {
//            // 1. Спочатку повністю вичищаємо таблицю user_role для цього користувача
//            userRepo.clearUserRoles(userId);
//            System.out.println("[AI KYC] Старі ролі успішно видалено з бази даних.");
//
//            // 2. Записуємо одну єдину нову роль
//            userRepo.insertHelpSeekerRole(userId);
//            System.out.println("[AI KYC] Нову роль HELP_SEEKER успішно записано.");
//
//            // 3. Змиваємо кеш Hibernate, щоб він побачив чисту таблицю в БД
//            entityManager.flush();
//            entityManager.clear();
//
//            // 4. Оновлюємо поточний об'єкт користувача, дістаючи його з БД через твій метод findById
//            User dbUser = userRepo.findById(userId);
//
//            if (dbUser != null) {
//                System.out.println("[AI KYC] Користувача знайдено в базі після апдейту. Ролей: " + dbUser.getRoles().size());
//
//                // 5. Формуємо нову сесію Spring Security, щоб права оновилися "на льоту"
//                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//                Object credentials = (auth != null) ? auth.getCredentials() : null;
//
//                Authentication newAuth = new UsernamePasswordAuthenticationToken(
//                        dbUser,
//                        credentials,
//                        dbUser.getAuthorities()
//                );
//                SecurityContextHolder.getContext().setAuthentication(newAuth);
//
//                System.out.println("[SUCCESS] Базу даних та сесію користувача успішно оновлено!");
//                return "SUCCESS";
//            } else {
//                System.out.println("[AI KYC ERROR] Не вдалося знайти користувача з ID " + userId + " після апдейту ролі!");
//            }
//        } catch (Exception e) {
//            System.out.println("[AI KYC CRITICAL ERROR] Сталася помилка під час виконання транзакції!");
//            e.printStackTrace();
//            return "ERROR";
//        }
//
//        return "FAILED";
//    }
//}

package com.example.charitable.controller;

import com.example.charitable.domain.User;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
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

    @PostMapping("/profile/verify")
    @ResponseBody
    @Transactional // фіксує COMMIT транзакції у PostgreSQL
    public String handleVerification(
            @RequestParam("userId") long userId,
            @RequestParam(value = "passport", required = false) MultipartFile passportFile,
            @RequestParam(value = "selfie", required = false) MultipartFile selfieFile) {

        System.out.println("========== [JAVA BACKEND] МЕТОД КОНТРОЛЕРА ЗАПУЩЕНО ==========");
        System.out.println("[JAVA] Користувач ID: " + userId);

        // 1. ПЕРЕВІРКА ТА НАДСИЛАННЯ ФАЙЛІВ НА PYTHON ШІ-МІКРОСЕРВІС
        if (passportFile != null && !passportFile.isEmpty() && selfieFile != null && !selfieFile.isEmpty()) {
            System.out.println("[JAVA] Файли отримано з фронтенду. Пересилаємо на Python Flask...");

            try {
                RestTemplate restTemplate = new RestTemplate();
                String pythonUrl = "http://localhost:5000/api/ai/compare";

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
                        System.out.println("[JAVA] Верифікацію відхилено ШІ: обличчя не збігаються.");
                        return "FAILED_AI";
                    }
                }
            } catch (Exception e) {
                System.out.println("[JAVA WARNING] Python сервер недоступний. Автономний режим (пропуск верифікації).");
                e.printStackTrace();
            }
        } else {
            System.out.println("[JAVA WARNING] Файли не передані в запиті. Використовується дефолтне схвалення.");
        }

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
            }
        } catch (Exception e) {
            System.out.println("[AI KYC CRITICAL ERROR] Сталася помилка під час виконання транзакції!");
            e.printStackTrace();
            return "ERROR";
        }

        return "FAILED";
    }
}