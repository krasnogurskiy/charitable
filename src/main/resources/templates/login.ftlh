<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<@c.head></@c.head>
<@c.body isLogged isVerified>
<div class="content">
    <div class="wraplog">
        <div class="log">
            <p class="h-text">${springMacroRequestContext.getMessage("title1.message")!"[відсутнє повідомлення]"}</p>
            <form action="/login?lang=${.locale?string}" class="login" method="post">
                <input type="text" name="username" placeholder="${springMacroRequestContext.getMessage("email.message")!"[відсутнє повідомлення]"}"/> <#--id="email" placeholder="Enter your e-mail"-->
                <input type="password" name="password" placeholder="${springMacroRequestContext.getMessage("password1.message")!"[відсутнє повідомлення]"}"/> <!--id="password" placeholder="Enter your password">-->
                <#-- <input type="hidden" name="lang" value="${.locale?string}"/>  <!-- мова &ndash;&gt;  -->
                <#-- <input type="hidden" name = "_csrf" value="${_csrf.token}"/>-->
                <input type="submit" style="cursor:pointer;" value="${springMacroRequestContext.getMessage("signin.message")!"[відсутнє повідомлення]"}"/>
            </form>
            <#if errorMessage??>
                <p class="error">${springMacroRequestContext.getMessage("error1.message")!"[відсутнє повідомлення]"}</p>
            </#if>
            <p>${springMacroRequestContext.getMessage("noaccount.message")!"[відсутнє повідомлення]"} <span class="cl"><a href="/registration">${springMacroRequestContext.getMessage("signup.message")!"[відсутнє повідомлення]"}</a></span></p>
        </div>
        </div>
        <@c.footer></@c.footer>
    </div>
    <@c.scripts></@c.scripts>

</@c.body>
</html>




