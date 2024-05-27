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
    <p class="maintxtreq helpr back"><a href="/request/${request.id}">&#8592; go back </a></p>
    <div class="donations">
        <div class="thelist">
            <div class="wraprecent">
                <div class="recent">
                    <p class="h-text listof">List of donators to ${request.getTitle()}</p>
                    <#list request.getRecentDonate() as person>
                        <div class="person aic">
                            <div class="left">
                                <div class="tinyavatar1" style="background-image: url(${"https://charitable-upload-2.s3.amazonaws.com/avatar/" + person.getUser().avatar});"></div>
                                <div class="name">${person.getUser().getFirstName() +  " " + person.getUser().getSurname()}</div>
                            </div>
                            <div class="summ">$${person.getDonatedSum()}</div>
                        </div>
                    </#list>
                </div>
            </div>
        </div>
        <div class="detailed">
            <div class="innerdet">
                <p class="maintxtprof suma">$${request.getCollectedSum()} was raised</p>
                <p class="lighttxt"><#assign result = 0> <#list request.getTopDonaters()?keys as key> <#assign result++> </#list> ${result} people donated</p>
                <a href="">
                    <div class="button_proj">Respond to help</div>
                </a>
            </div>
        </div>
    </div>
    <@c.footer></@c.footer>
</div>
<@c.scripts></@c.scripts>
</@c.body>
</html>
