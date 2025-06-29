# Charitable – Вебплатформа для збору благодійних пожертвувань

## Опис проєкту

Charitable — це вебплатформа, створена для організації зручного та безпечного збору благодійних пожертв. Вона дозволяє користувачам створювати власні збори, підтримувати існуючі ініціативи, вести персональну статистику, а також взаємодіяти через гейміфікацію. Проєкт розроблено у рамках кваліфікаційної роботи бакалавра Львівського національного університету імені Івана Франка.

---

Основні можливості

-  Реєстрація та авторизація з розмежуванням ролей: **PHILANTHROPIST** (донор) та **HELP_SEEKER** (організатор).
-  Створення зборів з описом, категорією, зображенням і цільовою сумою.
-  Донати через інтеграцію з **LiqPay**.
-  Візуалізація прогресу зборів за допомогою **Google Charts**.
-  Система досягнень та гейміфікація.
-  Підтримка двох мов: **українська** та **англійська**.
-  Перемикач теми: **світла/темна**.
-  Завантаження зображень через **Dropzone.js**, зберігання у **Amazon S3**.
-  Адаптивний дизайн для мобільних пристроїв.

---

## Технології

### Серверна частина
- Java 17
- Spring Boot, Spring Security, Spring Data JPA
- PostgreSQL
- Apache Maven
- Amazon S3 (AWS SDK)
- LiqPay API

### Клієнтська частина
- Apache FreeMarker
- HTML5, CSS3 (Flexbox, Grid, Media Queries)
- JavaScript
- Dropzone.js
- Google Charts

### Розгортання
- **Heroku** – автоматичний деплой з Git
- Інтеграція з GitHub

---

## Архітектура

Платформа побудована за архітектурним шаблоном **MVC**:

- **Model** — сутності JPA, що відображають таблиці БД (Users, Donations, тощо).
- **View** — шаблони FreeMarker (`.ftlh`), які формують HTML-сторінки.
- **Controller** — обробка HTTP-запитів, взаємодія з сервісами.

---

## Як запустити локально

1. Клонувати репозиторій:
   ```bash
   git clone https://github.com/krasnogurskiy/charitable.git
   cd charitable
2. Заповнити application.properties
3. Запустити проект
4. Перейти за адресою: http://localhost:8080
