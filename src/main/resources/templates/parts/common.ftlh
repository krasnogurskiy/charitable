Андрій, [22.06.2025 20:47]
<#macro head>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta charset="utf-8">
        <title>Charitable</title>

        <link rel="apple-touch-icon" sizes="180x180" href="/img/icons/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="/img/icons/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="/img/icons/favicon-16x16.png">
        <link rel="manifest" href="/img/icons/site.webmanifest">
        <link rel="mask-icon" href="/img/icons/safari-pinned-tab.svg" color="#5bbad5">
        <link rel="shortcut icon" href="/img/icons/favicon.ico">
        <meta name="msapplication-TileColor" content="#2d89ef">
        <meta name="msapplication-config" content="/img/icons/browserconfig.xml">
        <meta name="theme-color" content="#ffffff">

        <link href="/css/sss.css" rel="stylesheet" >
        <link href="/css/style.css" rel="stylesheet"/>
        <link id="theme-link" rel="stylesheet" href="/css/light-theme.css">

        <script src="/js/scroll.js"></script>
        <script src="/js/fastclick.js"></script>
        <#nested>
    </head>
</#macro>

<#macro body isLogged isVerified>
    <body>
    <div class="wrap-header">
        <header>
            <form id="demo-2">
                <a href="/main" class="logotype">Charitable</a>

                <button id="toggle-theme-btn" class="theme-switch">
                    <span class="icon sun">☀️</span>
                    <span class="icon moon">🌙</span>
                    <span class="toggle-circle"></span>
                </button>

                <select id="language-select" class="language-select" data-current-lang="${.locale?string}">
                    <option value="en" <#if .locale?string?starts_with("en")>selected</#if>>EN</option>
                    <option value="uk" <#if .locale?string?starts_with("uk")>selected</#if>>UA</option>
                </select>
            </form>

            <nav class="nav-collapse">
                <ul>
                    <#if isVerified>
                        <li class="menu-item pr0">
                            <a href="/create-request">
                                <div class="plus">+</div><span class="mobile">Create a request</span>
                            </a>
                        </li>
                    </#if>
                    <li class="menu-item"><a href="/requests">${springMacroRequestContext.getMessage("requests.message")!"[відсутнє повідомлення]"}</a></li>
                    <#if isLogged>
                        <li class="menu-item"><a href="/profile">${springMacroRequestContext.getMessage("profile.message")!"[відсутнє повідомлення]"}</a></li>
                        <li class="menu-item pr0"><a href="/logout">${springMacroRequestContext.getMessage("logout.message")!"[відсутнє повідомлення]"}</a></li>
                    <#else>
                        <li class="menu-item pr0"><a href="/login">${springMacroRequestContext.getMessage("login.message")!"[відсутнє повідомлення]"}</a></li>
                    </#if>
                </ul>
            </nav>
        </header>
    </div>
    <#nested>
    </body>
</#macro>

Андрій, [22.06.2025 20:47]
<#macro footer>
    <footer>
        <div class="links">
            <div class="block1">
                <div class="row hr"><a href="#">${springMacroRequestContext.getMessage("legal.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("terms.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("privacy.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("cookie.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("gdrp.message")!"[відсутнє повідомлення]"}</a></div>
            </div>
            <div class="block2">
                <div class="row hr"><a href="#">${springMacroRequestContext.getMessage("company.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("blog.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("career.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("privacy2.message")!"[відсутнє повідомлення]"}</a></div>
                <div class="row"><a href="#">${springMacroRequestContext.getMessage("about1.message")!"[відсутнє повідомлення]"}</a></div>
            </div>
        </div>
        <div class="block3">
            Copyright © 2025 . Designed by Andrii Krasnogurskiy <br>
            All rights reserved.
        </div>
    </footer>
</#macro>

<#--
<#macro scripts>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="/js/responsive-nav.js"></script>
    <script src="/js/fixed-responsive-nav.js"></script>

    <script>
        // Тема
        const toggleBtn = document.getElementById("toggle-theme-btn");
        const themeLink = document.getElementById("theme-link");
        if (toggleBtn && themeLink) {
            toggleBtn.addEventListener("click", () => {
                const currentTheme = themeLink.getAttribute("href");
                const newTheme = currentTheme.includes("light") ? "/css/dark-theme.css" : "/css/light-theme.css";
                themeLink.setAttribute("href", newTheme);
                localStorage.setItem("savedTheme", newTheme);
            });
            const savedTheme = localStorage.getItem("savedTheme");
            if (savedTheme) {
                themeLink.setAttribute("href", savedTheme);
            }
        }
    </script>

    <script>
        // Мова
        const languageSelect = document.getElementById("language-select");
        if (languageSelect) {
            const urlParams = new URL(window.location.href).searchParams;
            const urlLang = urlParams.get("lang");
            const currentLang = urlLang || languageSelect.dataset.currentLang;

            languageSelect.value = currentLang;

            languageSelect.addEventListener("change", function() {
                const selectedLang = this.value;
                const url = new URL(window.location.href);
                url.searchParams.set("lang", selectedLang);
                window.location.href = url.toString();
            });
        }
    </script>
    <#nested>
</#macro>-->

<#macro scripts>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="/js/responsive-nav.js"></script>
    <script src="/js/fixed-responsive-nav.js"></script>

    <script>
        // Тема
        const toggleBtn = document.getElementById("toggle-theme-btn");
        const themeLink = document.getElementById("theme-link");
        if (toggleBtn && themeLink) {
            toggleBtn.addEventListener("click", () => {
                const currentTheme = themeLink.getAttribute("href");
                const newTheme = currentTheme.includes("light") ? "/css/dark-theme.css" : "/css/light-theme.css";
                themeLink.setAttribute("href", newTheme);
                localStorage.setItem("savedTheme", newTheme);
            });
            const savedTheme = localStorage.getItem("savedTheme");
            if (savedTheme) {
                themeLink.setAttribute("href", savedTheme);
            }
        }
    </script>

    <script>
        // Мова
        const languageSelect = document.getElementById("language-select");
        if (languageSelect) {
            const urlParams = new URL(window.location.href).searchParams;
            const urlLang = urlParams.get("lang");
            const currentLang = urlLang || languageSelect.dataset.currentLang;
            languageSelect.value = currentLang;

            languageSelect.addEventListener("change", function() {
                const selectedLang = this.value;
                const url = new URL(window.location.href);
                url.searchParams.set("lang", selectedLang);
                window.location.href = url.toString();
            });

            // Додаємо lang до форм логіну та реєстрації
            const loginForm = document.querySelector('form[action="/login"]');
            const registrationForm = document.querySelector('form[action="/registration"]');

            function updateFormLangAction(form) {
                if (form) {
                    const selectedLang = languageSelect.value;
                    const actionUrl = new URL(form.action, window.location.origin);
                    actionUrl.searchParams.set("lang", selectedLang);
                    form.action = actionUrl.pathname + '?lang=' + selectedLang;
                }
            }

            updateFormLangAction(loginForm);
            updateFormLangAction(registrationForm);
        }
    </script>

    <#nested>
</#macro>

