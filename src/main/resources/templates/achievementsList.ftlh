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
        <#assign achTitle = springMacroRequestContext.getMessage("achievementsUr.message")!"[відсутнє повідомлення]">
        <#assign href = "/profile">
        <#else>
            <#assign achTitle = (springMacroRequestContext.getMessage("achievementsOf.message")! "[відсутнє повідомлення]") + " " + userObj.firstName>
            <#assign href = "/profile/${userObj.id}">
    </#if>
    <p class="maintxtreq helpr back"><a href = ${href}>&#8592; ${springMacroRequestContext.getMessage("goBack.message")!"[відсутнє повідомлення]"}</a></p>
    <p class="maintxtreq helpr">${achTitle}</p>
    <#--<div class="achievements">

&lt;#&ndash;        <#list achievements as ach,ifGot>
        <div class="awrap ${ifGot}">
            <img src="/img/achievements/${ach.getSrc()}" class="round" alt="">
            <p class="${ach.getClassName()}"></p>
        </div>
        </#list>&ndash;&gt;

        <#list achievements as ach,ifGot>
            <div class="awrap ${ifGot}" style="background-image: url('/img/achievements/${ach.getSrc()}');">
                <img src="/img/achievements/${ach.getSrc()}" class="round" alt="${ach.name()}">
                <span class="ach-text">
      <@spring.message code="achievement.${ach.getClassName()}.message" />
    </span>
            </div>
        </#list>

    </div>-->


    <div class="achievements">
        <#list achievements as ach,ifGot>
            <div>
                <div class="awrap ${ifGot}" style="background-image: url('/img/achievements/${ach.getSrc()}'); background-size: cover;">
                    <img class="round" src="/img/achievements/${ach.getSrc()}" alt="${ach.name()}"/>
                </div>
                <div class="ach-text">
                    <@spring.message code="achievement.${ach.getClassName()}.message" />
                </div>
            </div>
        </#list>
    </div>


    <@c.footer></@c.footer>
</div>
<@c.scripts></@c.scripts>

</@c.body>
</html>