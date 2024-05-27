<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />


<!DOCTYPE html>
<html lang="en" dir="ltr">
<@c.head>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
    <script src="/js/sss.min.js" type="text/javascript"></script>

    <script>jQuery(function($) {$('.slider').sss();});</script>
    <style>
        .img-wrapper{
            background-image: url(${"https://charitable-upload.s3.amazonaws.com/" + request.getImageNames()[0]});
            background-position: center;
            background-size: cover;
            height: 220px;
            box-shadow: 0 0 31.19px rgba(54, 54, 54, 0.04), 0 10.77px 27.72px rgba(0, 0, 0, 0.15);
            border-radius: 11px;
            width: 100%;
        }
        .avatar{
            width: 47px;
            height: 47px;
            background-image: url(${"https://charitable-upload.s3.amazonaws.com/avatar/" + user.avatar});
            background-position: center;
            background-size: cover;
            border-radius: 50%
        }

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


    <div class="content">


        <p class="h-text w100 ht">${request.title}</p>
        <#--NOT APPLYING IMAGE -->
        <div class="img-wrapper dn"></div>

        <div class="progresswrap">


            <div class="progress">
                <p class="ac pr">Progress $${request.getCollectedSum()?floor}</p>
                <p class="raised">Raised by <#assign result = 0> <#list request.getTopDonaters()?keys as key> <#assign result++> </#list> ${result} people</p>
                <!-- <img src="..//static/img/diag.png" alt="" class="wa"> -->
                <div id="donutchart" style="width: 100%; height: 300px;"></div>
                <div class="percentage"><#if (request.getCollectedSum() / request.getRequiredSum() * 100) < 1> ${(request.getCollectedSum() / request.getRequiredSum() * 100)?ceiling} </#if> <#if 1 < (request.getCollectedSum() / request.getRequiredSum() * 100) > ${(request.getCollectedSum() / request.getRequiredSum() * 100)?floor} </#if>%</div>
                <div class="donators">
                    <#assign enter = 0>
                    <#assign top_donate = 0>
                    <#list request.getTopDonaters()?keys as key>
                        <#if enter < 3>
                            <div class="person">
                                <div class="left">
                                    <div class="${"box" +  (enter + 1)  + " olbox"}"></div>
                                    <div class="name">${key.getFirstName() + " " + key.getSurname()}</div>
                                </div>
                                <#assign atmoment = 0>
                                <#list request.getTopDonaters()?values as value>
                                    <#if atmoment != enter>
                                        <#assign atmoment++>
                                        <#continue>
                                    </#if>
                                    <#if enter < 3>
                                        <#assign top_donate += value>
                                    </#if>
                                    <div class="summ">$${value}</div>
                                    <#assign enter++>
                                    <#break>
                                </#list>
                            </div>
                        </#if>
                    </#list>
                    <#if (request.getCollectedSum() - top_donate) != 0>
                        <div class="person">
                            <div class="left">
                                <div class="box4 olbox"></div>
                                <div class="name">Others</div>
                            </div>
                            <div class="summ">$${request.getCollectedSum() - top_donate}</div>
                        </div>
                    </#if>
                </div>
                <div class="button-wrap">
                    <#if request.active>
                    <a href="/payment/${request.id}">
                        <div class="button">
                            <p>Become a sponsor</p>
                        </div>
                    </a>
                    <#else>
                    <a href="">
                        <div class="button">
                            <p>Completed!</p>
                        </div>
                    </a>
                    </#if>
                </div>
            </div>
            <div class="infowrap">
                <div class="info">
                    <div class="top">
                        <div class="leftside">
                            <div class="avatar"></div>
                            <div class="txtinfo">
                                <div class="nameinfo">${user.getFirstName() + " " + user.getSurname()}</div>
                                <div class="organizer">Organizer</div>
                            </div>
                        </div>
                        <a href="/profile/${user.id}">
                            <div class="contact">View profile</div>
                        </a>
                    </div>
                    <div class="date">
                        <img src="/img/DateTime(EC92).svg" alt="">
                        Created ${request.getCreatedTimeRequest()}
                    </div>
                    <div class="topic">
                        <img src="/img/Pinned(E840).svg" alt="">
                        <a href="#">${request.getSection()}</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="wr">

            <div class="img-wrapper fordesktop"></div>
            <p class="description">${request.getDescription()}</p>

            <div class="wrapslider">
                <div class="slider">
                    <#list request.getImageNames() as img>
                        <#if img?is_first>
                            <#continue>
                        </#if>
                        <img src="${"https://charitable-upload.s3.amazonaws.com/" + img}" alt=""/>
                    </#list>
                </div>
            </div>

            <div class="wraprecent">
                <div class="recent">
                    <p class="h-text">Recent donations</p>
                    <#assign counter = 0>
                    <#list request.getRecentDonate() as person>
                        <#assign donation_title = "View all">
                        <#assign href = "/request/donations/${request.id}">
                        <#if counter < 5>
                            <div class="person aic">
                                <div class="left">
                                    <div class="tinyavatar1" style="background-image: url(${"https://charitable-upload.s3.amazonaws.com/avatar/" + person.getUser().avatar});"></div>
                                    <div class="name">${person.getUser().getFirstName() +  " " + person.getUser().getSurname()}</div>
                                </div>
                                <div class="summ">$${person.getDonatedSum()}</div>
                            </div>
                        </#if>
                        <#assign  counter++>
                    <#else>
                        <p class="description">No donation made yet</p>
                        <#assign donation_title = "Become the first one">
                        <#assign href = "/payment/${request.id}">
                    </#list>
                    <div class="wrapview">
                        <a href=${href}>
                            <div class="view">${donation_title}</div>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <@c.footer></@c.footer>

    </div>

<@c.scripts>
    <script type="text/javascript">
        google.charts.load("current", { packages: ["corechart"] });
        google.charts.setOnLoadCallback(drawChart);
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
                ['Task', 'Hours per Day'],
                <#--['top1', ${40.5?floor}],-->
                <#--['top2', 1],-->
                <#--['top3n', 4],-->
                <#--['Others', 5],-->
                <#--['Left to collect', 50]-->
                <#assign enter_google = 0>
                <#assign count_google = 0>
                <#list request.getTopDonaters()?keys as key> <#assign count_google++> </#list>
                <#if count_google == 0>
                ['top1', 0],
                ['top2', 0],
                ['top3n', 0],
                ['Others', 0],
                ['Left to collect', ${request.getRequiredSum()}]
                    </#if>
                    <#if count_google == 1>
                    <#list request.getTopDonaters()?keys as key>
                    <#list request.getTopDonaters()?values as value>
                    ['${key.getFirstName() + " " + key.getSurname()}',
                    <#if (value * 100 / request.getRequiredSum()) < 1 > ${(value * 100 / request.getRequiredSum())?ceiling} </#if>
                    <#if 1 <= (value * 100 / request.getRequiredSum()) > ${(value * 100 / request.getRequiredSum())?floor} </#if>
                    ],
                </#list>
                </#list>
                ['top2', 0],
                ['top3n', 0],
                ['Others', 0],
                ['Left to collect',
                    <#if request.getRequiredSum() != request.getCollectedSum()> ${((request.getRequiredSum() - request.getCollectedSum()) * 100 / request.getRequiredSum())?floor} </#if>
                    <#if request.getRequiredSum() <= request.getCollectedSum() > 0 </#if>
                ]
                    </#if>
                    <#if count_google == 2>
                    <#list request.getTopDonaters()?keys as key>
                    <#assign atmoment_google = 0>
                    <#list request.getTopDonaters()?values as value>
                    <#if atmoment_google != enter_google>
                    <#assign atmoment_google++>
                    <#continue>
                    </#if>
                    ['${key.getFirstName() + " " + key.getSurname()}',
                    <#if (value * 100 / request.getRequiredSum()) < 1 > ${(value * 100 / request.getRequiredSum())?ceiling} </#if>
                    <#if 1 <= (value * 100 / request.getRequiredSum()) > ${(value * 100 / request.getRequiredSum())?floor} </#if>
                    ],
                <#assign enter_google++>
                <#break>
                </#list>
                </#list>
                ['top3n', 0],
                ['Others', 0],
                ['Left to collect',
                    <#if request.getRequiredSum() != request.getCollectedSum()> ${((request.getRequiredSum() - request.getCollectedSum()) * 100 / request.getRequiredSum())?floor} </#if>
                    <#if request.getRequiredSum() <= request.getCollectedSum() > 0 </#if>
                ]
                    </#if>
                    <#if 2 < count_google>
                    <#assign time_to_produce = 0>
                    <#list request.getTopDonaters()?keys as key>
                    <#if time_to_produce < 3>
                    <#assign atmoment_google = 0>
                    <#list request.getTopDonaters()?values as value>
                    <#if atmoment_google != enter_google>
                    <#assign atmoment_google++>
                    <#continue>
                    </#if>
                    ['${key.getFirstName() + " " + key.getSurname()}',
                    <#if (value * 100 / request.getRequiredSum()) < 1 > ${(value * 100 / request.getRequiredSum())?ceiling} </#if>
                    <#if 1 <= (value * 100 / request.getRequiredSum()) > ${(value * 100 / request.getRequiredSum())?floor} </#if>
                    ],
                <#assign time_to_produce++>
                <#assign enter_google++>
                <#break>
                </#list>
                </#if>
                </#list>
                ['Others',
                    <#if (request.getCollectedSum() - top_donate) * 100 / request.getRequiredSum() < 1> ${((request.getCollectedSum() - top_donate) * 100 / request.getRequiredSum())?ceiling} </#if>
                    <#if 1 <    (request.getCollectedSum() - top_donate) * 100 / request.getRequiredSum()> ${((request.getCollectedSum() - top_donate) * 100 / request.getRequiredSum())?floor} </#if>
                ],
                ['Left to collect',
                    <#if request.getRequiredSum() != request.getCollectedSum()> ${((request.getRequiredSum() - request.getCollectedSum()) * 100 / request.getRequiredSum())?floor} </#if>
                    <#if request.getRequiredSum() <= request.getCollectedSum() > 0 </#if>
                ]
                </#if>
            ]);

            var options = {
                colors: ['#26C296', '#DE6944', '#F5AC18', '#C4C4C4', '#FFFFFF'],
                pieHole: 0.65,
                fontName: 'GilroyMedium',
                fontSize: '18',
                pieSliceText: "none",
                'legend': 'none',
            };

            var chart = new google.visualization.PieChart(document.getElementById('donutchart'));
            chart.draw(data, options);
        }
    </script>
</@c.scripts>
</@c.body>
</html>