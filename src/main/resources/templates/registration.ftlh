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
                <p class="h-text">Sign Up to Charitable</p>
                <form class="login" action="/registration" method="post">
                    <div class="inputrow">
                        <div class="inp">

                            <@spring.bind "user.firstName"/>
                            <input type="text" name="${spring.status.expression}" placeholder="Name">
                            <@form.showErrors "","error"/>

                        </div>
                        <div class="inp">
                            <@spring.bind "user.surname"/>
                            <input type="text" name="${spring.status.expression}" placeholder="Surname">
                            <@form.showErrors "","error"/>
                        </div>
                    </div>

                    <@spring.bind "user.username"/>
                    <input type="text" name="${spring.status.expression}" placeholder="E-mail">
                    <@form.showErrors "","error"/>
                    <#if ifExists??><span class="error">User with that e-mail already exists!</span></#if>

                    <@spring.bind "user.password"/>
                    <input type="password" name="${spring.status.expression}" placeholder="Password">
                    <@form.showErrors "","error"/>
                    <#if errorValidPassword??><span class="error">Not valid.</span></#if>
                    <span class="warning">Make sure password has 8-20 characters and it contains at least one letter and one digit </span>


                  <#--  <input type="hidden" name = "_csrf" value="${_csrf.token}"/>
-->

                    <input type="submit" style="margin-top:15px" value="Sign Up">

                </form>
            </div>
        </div>
        <@c.footer></@c.footer>
    </div>
    <@c.scripts></@c.scripts>

</@c.body>

