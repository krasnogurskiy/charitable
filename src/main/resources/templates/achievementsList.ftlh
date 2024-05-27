<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en" dir="ltr">
<@c.head>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <link href="/css/achievements.css" rel="stylesheet"/>
</@c.head>

<@c.body isLogged isVerified>
<div class="content req">
    <#if isOwnProfile>
        <#assign achTitle = "Your achievements">
        <#assign href = "/profile">
        <#else>
            <#assign achTitle = "Achievements of ${userObj.firstName}">
            <#assign href = "/profile/${userObj.id}">
    </#if>
    <p class="maintxtreq helpr back"><a href = ${href}>&#8592; go back</a></p>
    <p class="maintxtreq helpr">${achTitle}</p>
    <div class="achievements">

        <#list achievements as ach,ifGot>
        <div class="awrap ${ifGot}">
            <img src="/img/achievements/${ach.getSrc()}" class="round" alt="">
            <p class="${ach.getClassName()}"></p>
        </div>
        </#list>

    </div>
    <@c.footer></@c.footer>
</div>
<@c.scripts></@c.scripts>

</@c.body>
</html>