<#macro logout>
    <form action="/logout" method="post">
    <input type="hidden" name = "_csrf" value="${_csrf.token}"/>
    <input type="submit" value="Sign Out"/>
    </form>
</#macro>

<#macro showErrors separator classOrStyle="">
    <#list spring.status.errorMessages as error>
        <#assign errorFixed = error>
        <#if errorFixed?contains("requiredSum")><#assign errorFixed = "Input required sum."></#if>
        <#if classOrStyle == "">
            <b>${error}</b>
        <#else>
            <#if classOrStyle?index_of(":") == -1><#assign attr="class"><#else><#assign attr="style"></#if>
            <div ${attr}="${classOrStyle}">${errorFixed}</div>
        </#if>
        <#if error_has_next>${separator?no_esc}</#if>
    </#list>
</#macro>

<#macro formInput path attributes="" fieldType="text">
    <@spring.bind path/>
    <#assign path_new = path>
    <#if path_new?contains("username")><#assign path_new = "Email"></#if>
    <#if path_new?contains("firstName")><#assign path_new = "Name"></#if>
    <input type="${fieldType}" id="${spring.status.expression?replace('[','')?replace(']','')}"  placeholder="${path_new?remove_beginning("user.")?capitalize}" name="${spring.status.expression}" value="<#if fieldType!="password">${spring.stringStatusValue}</#if>" ${attributes?no_esc}<@spring.closeTag/>
</#macro>