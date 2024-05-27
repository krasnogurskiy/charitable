
<#macro requestItem request>
    <div class="home-card" onclick="location.href='/request/${request.id}'">
                <div class="home-card-image" style="background-image: url(${"https://charitable-upload.s3.amazonaws.com/" + request.getImageNames()[0]})"></div> <#--url(${"uploadingDir/" + request.getImageNames()[0]})-->
                <div class="home-card-text">
                    <h2>${request.title}<#--Post One--></h2>
                    <span class="topic-home">
                    <img src="/img/Pinned(E840).svg" alt=""> <#--Pinned(E840).svg-->
                    <a href="#"> ${request.section}<#--Accidents & Emergencies--></a>
                    </span>
                    <p>${request.description}<#--Excepteur sunt eiusmod pariatur nulla consectetur adipisicing laborum voluptate commodo officia id. Nostrud amet ullamco id officia laboris.-->
                    </p>
                </div>
                <div class="home-card-stats">
                    <div class="home-card-stat">
                        <div class="home-card-value">${(request.collectedSum)?floor}$<#--3450$--></div>
                        <div class="home-card-type">raised</div>
                    </div>
                    <div class="home-card-stat border">
                        <div class="home-card-value">${((request.collectedSum/request.requiredSum)*100)?floor}%</div>
                        <div class="home-card-type">progress</div>
                    </div>
                    <div class="home-card-stat">
                        <div class="home-card-value">${(request.requiredSum - request.collectedSum)?floor}$</div>
                        <div class="home-card-type">left</div>
                    </div>
                </div>
</div>
</#macro>


<#macro requestNewLine>
<div class="home-card-wrapper">
<#nested>
</div>
</#macro>