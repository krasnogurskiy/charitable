<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<@c.head>
    <link href="/css/achievements.css" rel="stylesheet"/>
    <style>
        .profile-image{
            width: 168px;
            height: 168px;
            background-image: url(${"https://charitable-upload-2.s3.amazonaws.com/avatar/" + userObj.avatar});
            background-position: center;
            background-size: cover;
            border-radius: 50%;
        }
    </style>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
</@c.head>
<@c.body isLogged isVerified>
    <div class="content profil">
        <!-- <div id="top_x_div" style="width: 100%; height: 300px;"></div> -->
        <div class = "wrapts">
        <div class="top-section">
            <div class="img-edit">
                <div class="profile-image"></div>
                <div class="edit">
                        <span class="editspan">
                            <#if isOwnProfile>
                            <img src="/img/edit.svg" alt="">
                            <a href="/profile/edit">Edit profile</a>
                            </#if>
                        </span>
                </div>
            </div>
            <div class="profile-info">
                <div class="ab-pr">
                    <div class="total2">
                        <div class = "name-role">
                        <p class="maintxtprof">${userObj.firstName + " " + userObj.surname}
                            <#if isVerified>
                            <span class="checkmark"><img src="/img/verified.svg" alt="" ></span>
                            </#if>
                        </p>
                        <p class="lighttxt">${userObj.role?replace("_","-")?remove_beginning("[")?remove_ending("]")?capitalize}</p>
                        </div>
                        <#if !isVerified>
                            <#if isOwnProfile>
                                <div class="verify-button"><a href="/profile/upgradeForm"><div class="inner-ver">Upgrade your profile</div></a></div>
                            </#if>
                        </#if>
                    </div>

                </div>
                <#if achToDisplay?has_content>
                <div class="badges">
                    <#list achToDisplay as item>
                            <div class="ach ${item.getClassName()}"></div>
                    </#list>
                    <#--<div class="ach tenthousand"></div>
                    <div class="ach animal"></div>
                    <div class="ach topweek"></div>
                    <div class="ach education"></div>-->
                        <#if isOwnProfile><div class="seeall"><a href="/profile/achievements">See all</a></div>
                        <#else><div class="seeall"><a href="/profile/achievements/${userObj.id}">See all</a></div></#if>

                </div>
                </#if>
                    <#--<div class="total">
                        <p class="maintxtprof">Total donated</p>
                        <p class="lighttxt">$ ${userObj.getTotalDonations()}</p>
                    </div>-->
                </div>
                <div class = "overall">
                    <div class="ab-pr">
                        <div class="total">
                            <p class="lighttxt">Total donated</p>
                            <p class="maintxtprof suma">$ ${userObj.getTotalDonations()}</p>
                        </div>
                    </div>
                <div class="date-donate">
                    <#--<div class="today">
                        <p class="lighttxt">Today</p>
                        <p class="maintxtprof mb0">+ $ ${userObj.getTodayDonations()}</p>
                    </div>-->
                    <div class="week">
                        <p class="lighttxt">This week</p>
                        <p class="maintxtprof mb0">+ $ ${userObj.getWeekDonations()}</p>
                    </div>
                    <div class="month">
                        <p class="lighttxt">This month</p>
                        <p class="maintxtprof mb0">+ $ ${userObj.getMonthDonations()}</p>
                    </div>
                </div>
                </div>
            </div>
            <#if isVerified || isAnotherProfileVerified??>
            <div class="arrow">
                <div class="arrdown"><img src="/img/arrow.svg" alt="" class="rotate rt0"></div>
                <div class="hiddeninfo">
                    <div class="irow">
                        <p class="txtinfo">${userObj.username}</p>
<#--                        <p class="txtinfo"><#if userObj.country?has_content>${userObj.city}, ${userObj.country}<#else>No geo specified</#if></p>-->
                        <p class="txtinfo">Joined ${userObj.timestamp?date}</p>
                    </div>
                </div>
            </div>
            </div>
            </#if>
            <#if isVerified || isAnotherProfileVerified??>
            <div class="bottom-section">
                <div class="prwraprecent">
                    <div class="prrecent">
                        <div class="calls pad">Last calls for help</div>

                        <#if allReq?has_content>
                            <#list allReq as req>
                                <div class="person aic pad">
                                    <div class="left">
                                        <div class="name prof"><a href="/request/${req.id}">${req.getTitle()}</a></div>
                                    </div>
                                    <div class="summ">${req.getTimestampString()}</div>
                                </div>
                            </#list>
                        <#else>
                            <p class="description">No request has been created</p>
                        </#if>
                    </div>
                </div>

                <div class="activity">
                    <div class="calls">Activity</div>
                    <div id="top_x_div"></div>
                </div>
                </div>
                <#else>
                <div class="bottom-section">
                    <div class="prwraprecent">
                        <div class="prrecent ph">
                            <div class="calls">About user</div>
                            <div class="user-row">${userObj.username}</div>
<#--                            <div class="user-row"><#if userObj.country?has_content>${userObj.city}, ${userObj.country}<#else>No geo specified</#if></div>-->
                            <div class="user-row">Joined ${userObj.timestamp?date}</div>
                        </div>
                    </div>

                    <div class="activity">
                    <div class="calls">Activity</div>
                    <div id="top_x_div"></div>
                    </div>
                </div>
                    </#if>


        <@c.footer></@c.footer>
    </div>
    <@c.scripts>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', { 'packages': ['bar'] });
        google.charts.setOnLoadCallback(drawStuff);

        function drawStuff() {
            var data = new google.visualization.arrayToDataTable([
                ['Donation activity by months', '$'],
                ['Jan', Number(${userObj.getDonationsByMonths(0)?c})],
                ['Feb', Number(${userObj.getDonationsByMonths(1)?c})],
                ['Mar', Number(${userObj.getDonationsByMonths(2)?c})],
                ['Apr', Number(${userObj.getDonationsByMonths(3)?c})],
                ['May', Number(${userObj.getDonationsByMonths(4)?c})],
                ['Jun', Number(${userObj.getDonationsByMonths(5)?c})],
                ['Jul', Number(${userObj.getDonationsByMonths(6)?c})],
                ['Aug', Number(${userObj.getDonationsByMonths(7)?c})],
                ['Sep', Number(${userObj.getDonationsByMonths(8)?c})],
                ['Oct', Number(${userObj.getDonationsByMonths(9)?c})],
                ['Nov', Number(${userObj.getDonationsByMonths(10)?c})],
                ['Dec', Number(${userObj.getDonationsByMonths(11)?c})],

            ]);

            var options = {
                legend: { position: 'none' },
                fontName: 'GilroyMedium',
                fontSize: '18',
                titleTextStyle: {
                    fontName: 'GilroyBold',
                    fontSize: '24',
                },
                bar: { groupWidth: "30%"},
            };
            var chart = new google.charts.Bar(document.getElementById('top_x_div'));
            // Convert the Classic options to Material options.
            chart.draw(data, google.charts.Bar.convertOptions(options));
        }
    </script>
        <script>
            $(document).ready(function () {
                $(".arrdown").click(function () {
                    $(".hiddeninfo").animate({ height: 'toggle', marginBottom: '0' }, 300);
                    $('.rotate').toggleClass('rt180');
                    $('.rotate').toggleClass('rt0');
                });
            });
        </script>
    </@c.scripts>

</@c.body>
</html>