<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />
<#import "parts/formMacros.ftlh" as form>

<!DOCTYPE html>
<html lang="en">
<@c.head>
<#--STYLE FOR ERROR MESSAGE-->
    <style>
        .error{
            color: red;
        }
    </style>
</@c.head>
<@c.body false false>

    <div class="content">
        <div class="wraplog">
            <div class="log">
                <p class="h-text">${springMacroRequestContext.getMessage("sinupto.message")!"[відсутнє повідомлення]"} Charitable</p>
                <form class="login" action="/registration" method="post">
                    <div class="inputrow">
                        <div class="inp">

                            <@spring.bind "user.firstName"/>
                            <input type="text" name="${spring.status.expression}" placeholder="${springMacroRequestContext.getMessage("name1.message")!"[відсутнє повідомлення]"}">
                            <@form.showErrors "","error"/>

                        </div>
                        <div class="inp">
                            <@spring.bind "user.surname"/>
                            <input type="text" name="${spring.status.expression}" placeholder="${springMacroRequestContext.getMessage("surname1.message")!"[відсутнє повідомлення]"}">
                            <@form.showErrors "","error"/>
                        </div>
                    </div>

                    <@spring.bind "user.username"/>
                    <input type="text" name="${spring.status.expression}" placeholder="E-mail">
                    <@form.showErrors "","error"/>
                    <#if ifExists??><span class="error">${springMacroRequestContext.getMessage("alrExist.message")!"[відсутнє повідомлення]"}</span></#if>

                    <@spring.bind "user.password"/>
                    <input type="password" name="${spring.status.expression}" placeholder="${springMacroRequestContext.getMessage("password2.message")!"[відсутнє повідомлення]"}">
                    <@form.showErrors "","error"/>
                    <#if errorValidPassword??><span class="error">${springMacroRequestContext.getMessage("notval.message")!"[відсутнє повідомлення]"}</span></#if>
                    <span class="warning">${springMacroRequestContext.getMessage("warning.message")!"[відсутнє повідомлення]"} </span>


                  <#--  <input type="hidden" name = "_csrf" value="${_csrf.token}"/>
-->

                    <input type="submit" style="margin-top:15px" value="${springMacroRequestContext.getMessage("signup.message")!"[відсутнє повідомлення]"}">

                </form>
            </div>
        </div>
        <@c.footer></@c.footer>
    </div>
    <@c.scripts></@c.scripts>

</@c.body>

