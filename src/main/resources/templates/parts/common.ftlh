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
                <input type="search" placeholder="Search">
                <a href="/main" class="logotype">Charitable</a>
            </form>
            <nav class="nav-collapse">
                <ul>
                    <#if isVerified>
                        <li class="menu-item pr0">
                            <a href="/create-request">
                                <div class="plus">+</div><span class="mobile">Create a request</span>
                            </a></li>
                    </#if>
                    <li class="menu-item"><a href="/requests">Requests</a></li>
                    <#if isLogged>
                        <li class="menu-item"><a href="/profile">Profile</a></li>
                        <li class="menu-item pr0"><a href="/logout">Log out</a></li>
                    <#else>
                        <li class="menu-item pr0"><a href="/login">Log In</a></li>
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
                <div class="row hr"><a href="#">Legal</a></div>
                <div class="row"><a href="#">Terms of Service</a></div>
                <div class="row"><a href="#">Privacy Policy</a></div>
                <div class="row"><a href="#">Cookie Information</a></div>
                <div class="row"><a href="#">GDPR Commitment</a></div>
            </div>
            <div class="block2">
                <div class="row hr"><a href="#">Company</a></div>
                <div class="row"><a href="#">Blog</a></div>
                <div class="row"><a href="#">Career</a></div>
                <div class="row"><a href="#">Privacy</a></div>
                <div class="row"><a href="#">About</a></div>
            </div>
        </div>
        <div class="block3">
            <p class="hr">System Carnival</p>
            Copyright © 2024 . Designed by Andrii Krasnogurskiy <br>
            All rights reserved.
        </div>
    </footer>
</#macro>


<#macro scripts>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="/js/responsive-nav.js"></script>
    <script src="/js/fixed-responsive-nav.js"></script>


    <#nested>
</#macro>