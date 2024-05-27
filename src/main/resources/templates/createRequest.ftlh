<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />
<#import "parts/formMacros.ftlh" as form>

<!DOCTYPE html>
<html lang="en">
<@c.head>
    <link rel="stylesheet" href="/css/dropzone.css">
    <link rel="stylesheet" href="/css/basic.css">
    <link rel="stylesheet" href="/css/countrySelect.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="//geodata.solutions/includes/countrystatecity.js"></script>
    <script src="/js/parsley.js"></script>
</@c.head>
<@c.body true true>
    <div class="content_crtpr">

        <p class="maintxt">Create request for help</p>
        <form action="/upload-image" class="dropzone needsclick dz-clickable" id="demo-upload" enctype="multipart/form-data" method="POST">
            <div class="dz-default dz-message">
                <button class="dz-button" type = "button" onchange="updateSize()">Drag & drop photos here</button>
               <#-- <input type="hidden" name = "_csrf" value="${_csrf.token}"/>-->
            </div>
        </form>
        <br/>

        <form action="/create-request" class="create_pr_form1" method="post">

            <div class="wr2">
                <div class="create_pr_wrap">
                    <div class="create_proj">
                        <div class="basicinf">
                            <p class="h-text ">Basic information:</p>
                            <div class="pr_name">
                                <div class="proj_name">
                                    <#--<input type="text" name="name" id="name" placeholder="Project name">-->
                                    <@spring.bind "request.title"/>
                                    <input id="name" value="" type="text" name="${spring.status.expression}" placeholder="Request title">
                                </div>
                                <@form.showErrors "<br>","error"/>
                                <div class = "details_wrap">
                                    <@spring.bind "request.description"/>
                                    <textarea id="details" name="${spring.status.expression}" class="validate[required,length[6,300]] details" placeholder="Write short description" rows="7"></textarea>
                                </div>
                                <@form.showErrors "<br>","error"/>
                            </div>
                        </div>

                        <div class="moreinf">
                            <p class="h-text ">Additional details:</p>

                            <div class="wrap_select">
                                <!-- в дів нижче class="select" -->
                                <@spring.bind "request.section"/>
                                <div class="categ_slct">
                                    <select id="slct" name="${spring.status.expression}">
                                        <option selected disabled>Choose the category</option>
                                        <option value="Disaster">Disaster</option>
                                        <option value="Education">Education</option>
                                        <option value="Hunger">Hunger</option>
                                        <option value="Environment">Environment</option>
                                        <option value="Health">Health</option>
                                        <option value="Animals">Animals</option>
                                    </select>
                                    <@form.showErrors "<br>","error"/>
                                </div>

                            </div>


                            <#--<@spring.bind "request.country"/>
                            <input type="text" id="country" name="${spring.status.expression}" />
                            <input type="hidden" id="country_code" />
                            <@form.showErrors "<br>","error"/>-->

                            <div class="region">
                                <p class="h3-text ">Choose your region:</p>
                                <@spring.bind "request.country"/>
                                <select name="${spring.status.expression}" class="countries" id="countryId">
                                    <option value="">Select Country</option>
                                </select>
                                <@form.showErrors "<br>","error"/>
                                <@spring.bind "request.state"/>
                                <select name="${spring.status.expression}" class="states" id="stateId">
                                    <option value="">Select State</option>
                                </select>
                                <@form.showErrors "<br>","error"/>
                                <@spring.bind "request.city"/>
                                <select name="${spring.status.expression}" class="cities" id="cityId">
                                    <option value="">Select City</option>
                                </select>
                                <@form.showErrors "<br>","error"/>
                            </div>




                            <p class="h3-text ">The amount of money <br> to be collected:</p>
                            <div class="create_sum">
                                <@spring.bind "request.requiredSum"/>
                                <input type='number' class="currency_input" placeholder="" value="500.0" min="0.0" name="${spring.status.expression}">
                                <@form.showErrors "<br>","error"/>
                            </div>

                        </div>
                    </div>
                </div>

            </div>


            <div class="wrapview">
                <a>
                    <input type="submit" value="Create project" class="button_proj">
                    <#--<input class="button_proj" type="submit" value="Create project">-->
                </a>
            </div>

            <div class="wrapview">
                <a href="/main" id = "cancelButton">
                    <div class="cancel">Cancel</div>
                </a>
            </div>

            <#--<input type="hidden" name = "_csrf" value="${_csrf.token}"/>-->
        </form>
       <#-- <form action="/create-request" id="leavePage" method="post"></form>
-->

        <@c.footer></@c.footer>

    </div>
<@c.scripts>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="/js/parsley.js"></script>
    <script src="/js/currency.js"></script>
    <script src="/js/dropzone-amd-module.js"></script>
    <script src="/js/dropzone.js"></script>
    <script src="/js/dropzone.js.map"></script>
    <script src="/js/search-countries.js"></script>
    <script src="/js/countrySelect.min.js"></script>

    <script>
        $("#country").countrySelect({
            defaultCountry: "ua",
            preferredCountries: ['us', 'gb', 'ua'],
            responsiveDropdown: true
        });
    </script>
    <script class="jsbin" src="https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>


    <script>
        function updateSize() {
            var nBytes = 0,
                oFiles = document.getElementById("fileInput").files,
                nFiles = oFiles.length;
            for (var nFileId = 0; nFileId < nFiles; nFileId++) {
                nBytes += oFiles[nFileId].size;
            }

            var sOutput = nBytes + " bytes";
            // optional code for multiples approximation
            for (var aMultiples = ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"], nMultiple = 0, nApprox = nBytes / 1024; nApprox > 1; nApprox /= 1024, nMultiple++) {
                sOutput = nApprox.toFixed(3) + " " + aMultiples[nMultiple] + " (" + nBytes + " bytes)";
            }
            // end of optional code

            document.getElementById("fileNum").innerHTML = nFiles;
            document.getElementById("fileSize").innerHTML = sOutput;
        }
    </script>
    <script>
        var select = document.querySelector("#slct");
        var selectOption = select.options[select.selectedIndex];
        var lastSelected = localStorage.getItem('select');

        if (lastSelected) {
            select.value = lastSelected;
        }

        select.onchange = function () {
            lastSelected = select.options[select.selectedIndex].value;
            console.log(lastSelected);
            localStorage.setItem('select', lastSelected);
        }

        // var detaiils = document.getElementById("details").value ;
        //     localStorage.setItem("details", detaiils) ;
        var elements = document.querySelectorAll('#name, #details');

        function checkValidity() { };

        for (i = 0; i < elements.length; i++) {
            (function (element) {
                var id = element.getAttribute('id');
                element.value = localStorage.getItem(id);
                element.oninput = function () {
                    localStorage.setItem(id, element.value);
                    checkValidity();
                };
            })(elements[i]);
        }
        $(window).on("beforeunload", function () {

            return "Are you sure you want to leave the page?";

        });

        $(document).on("submit", "form", function (event) {
            $(window).off("beforeunload");
            localStorage.clear();
        });
        $("#cancelButton").click(function () {
            $(window).off("beforeunload");
            localStorage.removeItem('select');
            localStorage.removeItem('name');
            localStorage.removeItem('details');
            window.location.reload();
        });



        $(window).on("beforeunload", function() {

            return "Are you sure you want to leave the page?";

        });
        $(document).on("submit", "form", function(event) {

            $(window).off("beforeunload");

        });

    </script>


</@c.scripts>

</@c.body>
</html>