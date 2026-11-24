<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en" dir="ltr">
<@c.head>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <style>
        .tinyavatar1{
            width: 28px;
            height: 28px;
            background-position: center;
            background-size: cover;
            box-shadow: 0px 0px 31.19px rgba(54, 54, 54, 0.04), 0px 2.77px 27.72px rgba(0, 0, 0, 0.04);
        }
    </style>
</@c.head>

<@c.body isLogged isVerified>
<div class="content req">
    <p class="maintxtreq helpr back"><a href="/request/${request.id}">&#8592; ${springMacroRequestContext.getMessage("goBack.message")!"[відсутнє повідомлення]"} </a></p>
    <div class="donations">
        <div class="thelist">
            <div class="wraprecent">
                <div class="recent">
                    <p class="h-text listof">${springMacroRequestContext.getMessage("historylist.message")!"[відсутнє повідомлення]"} ${request.getTitle()}</p>
                    <#list request.getRecentDonate() as person>
                        <div class="person aic">
                            <div class="left">
                                <#if person.user??>
                                    <a href="/profile/${person.user.id?c}" style="display: flex; align-items: center; color: inherit;">
                                        <div class="tinyavatar1" style="background-image: url(${"https://charitable-upload-2.s3.amazonaws.com/avatar/" + ((person.user.avatar)!"")});"></div>
                                        <div class="name">${(person.user.firstName)!""} ${(person.user.surname)!""}</div>
                                    </a>
                                <#else>
                                    <div class="tinyavatar1" style="background-image: url(/img/anon.png);"></div>
                                    <div class="name">${springMacroRequestContext.getMessage("anonymousUser.message")!"Анонімний користувач"}</div>
                                </#if>
                            </div>
                            <div class="summ">$${person.getDonatedSum()}</div>
                        </div>
                    </#list>
                </div>
            </div>
        </div>
        <div class="detailed">
            <div class="innerdet">
                <p class="maintxtprof suma">$${request.getCollectedSum()} ${springMacroRequestContext.getMessage("wraised.message")!"[відсутнє повідомлення]"}</p>
                <p class="lighttxt"><#assign result = request.getAnonymousDonationsCount()> <#list request.getTopDonaters()?keys as key> <#assign result++> </#list> ${result} ${springMacroRequestContext.getMessage("pdon.message")!"[відсутнє повідомлення]"}</p>
                <a href="">
                    <div class="button_proj">${springMacroRequestContext.getMessage("resp.message")!"[відсутнє повідомлення]"}</div>
                </a>
            </div>
        </div>
    </div>
    <@c.footer></@c.footer>
</div>
<@c.scripts></@c.scripts>
</@c.body>
</html>
