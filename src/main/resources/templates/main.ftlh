<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />
<#import "parts/requestItem.ftlh" as request>

<!DOCTYPE html>
<html lang="en">
<@c.head>
    <script class="jsbin" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
</@c.head>
<@c.body isLogged isVerified>
<div class="content">
    <div class="w100">





        <div class="img-wrapper-home">

            <div class="main-text-home">
                <p>Make a change</p>
            </div>

            <div class="donate-button-wrap-home">
                <div></div>
                <a href="/requests" class="donate-button-home">
                    <p>Donate</p>
                </a>
                <div></div>
            </div>

        </div>


        <p class="header-text-home-2">Categories</p>
        <div class="category-wrapper-home">
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Disaster&country=">
                    <p class="disaster-button-home">Disaster</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Education&country=">
                    <p class="education-button-home">Education</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Hunger&country=">
                    <p class="hunger-button-home">Hunger</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Environment&country=">
                    <p class="environment-button-home">Environment</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Health&country=">
                    <p class="health-button-home">Health</p>
                </a>
            </div>
            <div class="category-button-wrapper-home">
                <a href="/requests/filter?title=&section=Animals&country=">
                    <p class="animals-button-home">Animals</p>
                </a>
            </div>
        </div>

        <p class="header-text-home-2">
            Almost got it &#128526;
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
                    <p class="h-text">Congratulations!</p>
                    <img src="/img/achievements/${ach.getSrc()}" alt="" width="80%" />
                    <p>That's your new achievement!</p>
                    <div class="bts-popup-button">
                        <button class="btn" onclick="location.href='/profile/achievements'">Show me all!</button>
                    </div>
                    <a href="#0" class="bts-popup-close img-replace">Close</a>
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

