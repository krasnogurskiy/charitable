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

        <#--   theme   -->
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
<#--
                <input type="search" placeholder="Search">
-->
<#--
                <input type="search" name="title" placeholder="${springMacroRequestContext.getMessage("searchplaceholder.message")!"[відсутнє повідомлення]"}" class="innersearch">
-->

                <a href="/main" class="logotype">Charitable</a>

                <#-- theme  -->
                <button id="toggle-theme-btn" class="theme-switch">
                    <span class="icon sun">☀️</span>
                    <span class="icon moon">🌙</span>
                    <span class="toggle-circle"></span>
                </button>

                <#assign lang = (parameters.lang[0])!'en'>

                <select id="language-select" class="language-select">
                    <option value="en" <#if lang == "en">selected</#if>>EN</option>
                    <option value="uk" <#if lang == "uk">selected</#if>>UA</option>
                </select>



            </form>








<#--

<h1>${springMacroRequestContext.getMessage("welcome.message")!"[відсутнє повідомлення]"}</h1>
-->




            <nav class="nav-collapse">
                <ul>
                    <#if isVerified>
                        <li class="menu-item pr0">
                            <a href="/create-request">
                                <div class="plus">+</div><span class="mobile">Create a request</span>
                            </a></li>
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
            Copyright © 2024 . Designed by Andrii Krasnogurskiy <br>
            All rights reserved.
        </div>
    </footer>
</#macro>


<#macro scripts>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="/js/responsive-nav.js"></script>
    <script src="/js/fixed-responsive-nav.js"></script>

    <script>
        const toggleBtn = document.getElementById("toggle-theme-btn");
        const themeLink = document.getElementById("theme-link");

        if (toggleBtn && themeLink) {
            toggleBtn.addEventListener("click", () => {
                const currentTheme = themeLink.getAttribute("href");
                const newTheme = currentTheme.includes("light") ? "/css/dark-theme.css" : "/css/light-theme.css";
                themeLink.setAttribute("href", newTheme);
                localStorage.setItem("savedTheme", newTheme);
            });

            // Load saved theme on page load
            const savedTheme = localStorage.getItem("savedTheme");
            if (savedTheme) {
                themeLink.setAttribute("href", savedTheme);
            }
        }
    </script>
    <script>
        document.getElementById("language-select").addEventListener("change", function () {
            const selectedLang = this.value;

            const url = new URL(window.location.href);
            url.searchParams.set("lang", selectedLang);

            // Перехід на оновлений URL
            window.location.href = url.toString();
        });

        // Встановлюємо правильне значення в селекті при завантаженні
        window.addEventListener("DOMContentLoaded", () => {
            const url = new URL(window.location.href);
            const lang = url.searchParams.get("lang") || "en"; // за замовчуванням англійська
            document.getElementById("language-select").value = lang;
        });
    </script>


    <#nested>
</#macro>
