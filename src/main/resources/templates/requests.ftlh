<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en">
<@c.head>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script type="text/javascript"
            src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
</@c.head>
<@c.body isLogged isVerified>

    <div class="content req">
        <p class="maintxtreq helpr">${springMacroRequestContext.getMessage("allrequests.message")!"[відсутнє повідомлення]"}</p>
        <#if buttonPressed??>
            <#assign recent = buttonPressed == "recent">
            <#assign mostPopular = buttonPressed == "most-popular">
            <#assign almostCollected = buttonPressed == "almost-collected">
            <div class="myBtnContainer">
                <button class="btn ${recent?then('active', '')}"><a href="/requests/recent">${springMacroRequestContext.getMessage("recent.message")!"[відсутнє повідомлення]"}</a></button>
                <button class=" btn ${mostPopular?then('active', '')}"><a href="/requests/most-popular">${springMacroRequestContext.getMessage("popular.message")!"[відсутнє повідомлення]"}</a></button>
                <button class="btn ${almostCollected?then('active', '')}"><a href="/requests/almost-collected">${springMacroRequestContext.getMessage("almostcollected.message")!"[відсутнє повідомлення]"}</a></button>
            </div>
        <#else>
            <div class="myBtnContainer">
                <button class="btn"><a href="/requests/recent">${springMacroRequestContext.getMessage("recent.message")!"[відсутнє повідомлення]"}</a></button>
                <button class=" btn"><a href="/requests/most-popular">${springMacroRequestContext.getMessage("popular.message")!"[відсутнє повідомлення]"}</a></button>
                <button class="btn"><a href="/requests/almost-collected">${springMacroRequestContext.getMessage("almostcollected.message")!"[відсутнє повідомлення]"}</a></button>
            </div>
        </#if>
        <div class=" filters">
            <div class="reqrow">
                <p class="filt">${springMacroRequestContext.getMessage("filters.message")!"[відсутнє повідомлення]"}</p>
                <img src="img/imgfilter.svg" alt="" class="open">
            </div>
            <form action="/requests/filter" class="hide">
                <input type="search" name="title" placeholder="${springMacroRequestContext.getMessage("searchplaceholder.message")!"[відсутнє повідомлення]"}" class="innersearch">

                <div class="demo">
                    <p>
                        <label for="percent">${springMacroRequestContext.getMessage("amneed.message")!"[відсутнє повідомлення]"}</label>
                        <input type="text" id="percent" class="numbers" />
                    </p>
                    <div id="slider-range2"></div>
                </div>
                <div class="demo">
                    <p>
                        <label for="amount">${springMacroRequestContext.getMessage("percentcollected.message")!"[відсутнє повідомлення]"} </label>
                        <input type="text" id="amount" class="numbers" />
                    </p>
                    <div id="slider-range"></div>
                </div>
                <select name="section" id="">
                    <option value="">${springMacroRequestContext.getMessage("allcategories.message")!"[відсутнє повідомлення]"}</option>
                    <#list sections as section>
                        <option value="${section}">${section}</option>
                    </#list>
                </select>
<#--                <select name="country" id="" class="bottom-select">-->
<#--                    <option value="">All countries</option>-->
<#--                    <#list countries as country>-->
<#--                        <option value="${country}">${country}</option>-->
<#--                    </#list>-->
<#--                </select>-->
                <button class="btn active">${springMacroRequestContext.getMessage("applyfilters.message")!"[відсутнє повідомлення]"}</button>
            </form>
        </div>
        <div class="requests" id="requests">
            <#list requests as item>
                <a href="/request/${item.id}">
                    <div class="request-block" data-price="${item.getRequiredSum()?c}" data-percents="${(item.getCollectedSum() / item.getRequiredSum() * 100)?string("0")}">
                        <div class="r-img" style="background-image: url(${"https://charitable-upload-2.s3.amazonaws.com/" + item.getImageNames()[0]})"></div>
                        <div class="rbcontent">
                            <div class="headerblock">
                                <div class="tog">
                                    <p class="rbheader">${item.getTitle()}</p>
                                    <div class="topic2">
                                        <div class="ls"><img src="/img/Pinned(E840).svg" alt="">
                                            ${item.section}</div>
                                        <div class="rs">${item.city}, ${item.country}</div>
                                    </div>
                                </div>
                                <p class="raisedof">${springMacroRequestContext.getMessage("raised.message")!"[відсутнє повідомлення]"} <span>$${item.getCollectedSum()} ${springMacroRequestContext.getMessage("of1.message")!"[відсутнє повідомлення]"} $${item.getRequiredSum()}</span></p>
                            </div>
                            <div class="rb-desc">${item.getDescription()}</div>
                            <div class="percentleft">
                                <div class="prcnt">${(item.getCollectedSum() / item.getRequiredSum() * 100)?string("0")}%</div>
                                <div class="leftto">$${item.requiredSum - item.getCollectedSum()} ${springMacroRequestContext.getMessage("left.message")!"[відсутнє повідомлення]"}</div>
                            </div>
                        </div>
                    </div>
                </a>
            </#list>
        </div>

        <@c.footer></@c.footer>
    </div>

    <@c.scripts>
    <script src="/js/slider.js"></script>
    </@c.scripts>
</@c.body>
</html>