package com.example.charitable.controller;

import com.example.charitable.domain.User;
import com.example.charitable.repos.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Controller
public class VerificationController {

    @Autowired
    private UserRepo userRepo;

    // Впроваджуємо менеджер сутностей для примусового скидання кешу Hibernate
    @PersistenceContext
    private EntityManager entityManager;

    /**
     * Фінальний тригер, який викликається асинхронно через AJAX на Кроці 3.
     */
    @PostMapping("/profile/verify")
    @ResponseBody
    @Transactional // Фіксує COMMIT транзакції у PostgreSQL
    public String handleVerification(@RequestParam("userId") long userId) {
        System.out.println("========== [AI KYC] МЕТОД КОНТРОЛЕРА ЗАПУЩЕНО ==========");
        System.out.println("[AI KYC] Отримано залізобетонний ID з фронтенду: " + userId);

        try {
            // 1. Спочатку повністю вичищаємо таблицю user_role для цього користувача
            userRepo.clearUserRoles(userId);
            System.out.println("[AI KYC] Старі ролі успішно видалено з бази даних.");

            // 2. Записуємо одну єдину нову роль
            userRepo.insertHelpSeekerRole(userId);
            System.out.println("[AI KYC] Нову роль HELP_SEEKER успішно записано.");

            // 3. Змиваємо кеш Hibernate, щоб він побачив чисту таблицю в БД
            entityManager.flush();
            entityManager.clear();

            // 4. Оновлюємо поточний об'єкт користувача, дістаючи його з БД через твій метод findById
            User dbUser = userRepo.findById(userId);

            if (dbUser != null) {
                System.out.println("[AI KYC] Користувача знайдено в базі після апдейту. Ролей: " + dbUser.getRoles().size());

                // 5. Формуємо нову сесію Spring Security, щоб права оновилися "на льоту"
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