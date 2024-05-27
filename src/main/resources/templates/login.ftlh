<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<@c.head></@c.head>
<@c.body isLogged isVerified>
<div class="content">
    <div class="wraplog">
        <div class="log">
            <p class="h-text">Sign In to Charitable</p>
            <form action="/login" class="login"  method="post">
                <input type="text" name="username" placeholder="Enter your e-mail"/> <#--id="email" placeholder="Enter your e-mail"-->
                <input type="password" name="password" placeholder="Enter your password"/> <!--id="password" placeholder="Enter your password">-->
                <#-- <input type="hidden" name = "_csrf" value="${_csrf.token}"/>-->
                <input type="submit" style="cursor:pointer;" value="Sign In"/>
            </form>
            <#if errorMessage??>
                <p class="error">The e-mail or password is incorrect!</p>
            </#if>
            <p>Don't have an account? <span class="cl"><a href="/registration">Sign Up!</a></span></p>
        </div>
        </div>
        <@c.footer></@c.footer>
    </div>
    <@c.scripts></@c.scripts>

</@c.body>
</html>




