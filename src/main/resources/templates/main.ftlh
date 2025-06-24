<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />
<#import "parts/requestItem.ftlh" as request>

<!DOCTYPE html>
<html lang="en">
<@c.head>
    <#--   <link id="theme-link" rel="stylesheet" href="/css/light-theme.css">
    -->

    <script class="jsbin" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
</@c.head>
<@c.body isLogged isVerified>
<div class="content">
    <#--  <button id="toggle-theme-btn">Toggle Theme</button> тема -->

    <div class="w100">





        <div class="img-wrapper-home">

            <div class="main-text-home">
                <p>${springMacroRequestContext.getMessage("make1.message")!"[відсутнє повідомлення]"}</p>
            </div>

            <div class="donate-button-wrap-home">
                <div></div>
                <a href="/requests" class="donate-button-home">
                    <p>${springMacroRequestContext.getMessage("donate.message")!"[відсутнє повідомлення]"}</p>
                </a>
                <div></div>
            </div>

        </div>


        <p class="header-text-home-2">${springMacroRequestContext.getMessage("categories.message")!"[відсутнє повідомлення]"}</p>
        <div class="category-wrapper-home">
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Military&country=">
                    <p class="military-button-home">${springMacroRequestContext.getMessage("military.message")!"[відсутнє повідомлення]"}</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Education&country=">
                    <p class="education-button-home">${springMacroRequestContext.getMessage("education.message")!"[відсутнє повідомлення]"}</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Hunger&country=">
                    <p class="hunger-button-home">${springMacroRequestContext.getMessage("hunger.message")!"[відсутнє повідомлення]"}</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Environment&country=">
                    <p class="environment-button-home">${springMacroRequestContext.getMessage("environment.message")!"[відсутнє повідомлення]"}</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Health&country=">
                    <p class="health-button-home">${springMacroRequestContext.getMessage("health.message")!"[відсутнє повідомлення]"}</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Animals&country=">
                    <p class="animals-button-home">${springMacroRequestContext.getMessage("animals.message")!"[відсутнє повідомлення]"}</p>
                </a>
            </div>
        </div>

        <p class="header-text-home-2">
            ${springMacroRequestContext.getMessage("gotit.message")!"[відсутнє повідомлення]"}
        </p>


        <@request.requestNewLine>
            <#list requests as item>
                <@request.requestItem item></@request.requestItem>
            </#list>
        </@request.requestNewLine>

        <#if achToDisplay??>
        <#list achToDisplay as ach>
        <div class="content req">
            <div class="bts-popup" role="alert">
                <div class="bts-popup-container">
                    <p class="h-text">${springMacroRequestContext.getMessage("congrat.message")!"[відсутнє повідомлення]"}</p>
                    <img src="/img/achievements/${ach.getSrc()}" alt="" width="80%" />
                    <p>${springMacroRequestContext.getMessage("newachiev.message")!"[відсутнє повідомлення]"}</p>
                    <div class="bts-popup-button">
                        <button class="btn" onclick="location.href='/profile/achievements'">${springMacroRequestContext.getMessage("showmeall.message")!"[відсутнє повідомлення]"}</button>
                    </div>
                    <a href="#0" class="bts-popup-close img-replace">${springMacroRequestContext.getMessage("close1.message")!"[відсутнє повідомлення]"}</a>
                </div>
            </div>
        </div>
        </#list>
        </#if>


        <@c.footer></@c.footer>

</div>
    <@c.scripts>
    <script>

        jQuery(document).ready(function($){

            window.onload = function (){
                $(".bts-popup").delay(1000).addClass('is-visible');
                /*window.addEventListener('scroll', noScroll);*/
            }

            //open popup
            $('.bts-popup-trigger').on('click', function(event){
                event.preventDefault();
                $('.bts-popup').addClass('is-visible');
            });

            //close popup
            $('.bts-popup').on('click', function(event){
                if( $(event.target).is('.bts-popup-close') || $(event.target).is('.bts-popup') ) {
                    event.preventDefault();
                    $(this).removeClass('is-visible');
                   /* window.removeEventListener('scroll', noScroll);*/
                }
            });
            //close popup when clicking the esc keyboard button
            $(document).keyup(function(event){
                if(event.which=='27'){
                    $('.bts-popup').removeClass('is-visible');
                }
            });
        });

        function noScroll() {
            window.scrollTo(0, 0);
        }
    </script>
    </@c.scripts>
</@c.body>
</html>