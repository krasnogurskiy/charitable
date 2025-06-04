<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />
<#import "parts/formMacros.ftlh" as form>

<!DOCTYPE html>
<html lang="en">
<@c.head>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="//geodata.solutions/includes/countrystatecity.js"></script>
    <style>
        .e .profile-image{
            width: 168px;
            height: 168px;
            background-position: center;
            background-size: cover;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            overflow: hidden;
            cursor: pointer;
            border: 3px solid #ffffff ;
            background-image:url(${"https://charitable-upload-2.s3.amazonaws.com/avatar/" + userObj.avatar});
        }
    </style>
</@c.head>
<@c.body isLogged isVerified>
    <div class="content profil e">
        <form action="/edit-profile" method="post" enctype="multipart/form-data">
            <div class="wrapts">
                <div class="top-section">
                    <div class="img-edit">
                        <div class="profile-image " id="pr">
                            <!-- <div id="holder" class="holder_default">
                              <img src="" id="image_droped" width="200" style="border: 3px dashed #7A97FC;" class=" hidden"/>
                              <input type="file" id="fileInput" />
                            </div> -->
                            <div class="eclipse"></div>

                            <img id="myImg" src="#"  alt="your image">
                            <span class="editspan">

                                <img src="/img/lightedit.svg" alt="">
                                <a href="#">${springMacroRequestContext.getMessage("upl.message")!"[відсутнє повідомлення]"}</a>
                            </span>

                            <input type='file' name="file" class="editimg"/>
                        </div>

                    </div>
                    <div class="profile-info">
                        <div class="ab-pr">
                            <div class="total2">
                                <div class="name-role edt">
                                    <div class="names">
                                        <div class = "name1">
                                    <p class="lighttxt">${springMacroRequestContext.getMessage("name1.message")!"[відсутнє повідомлення]"}</p>
                                    <input type="text" name="firstName" id="name" placeholder="Edit name" value="${userObj.firstName}">
                                        </div>
                                        <div class = "name2">
                                            <p class="lighttxt">${springMacroRequestContext.getMessage("surname1.message")!"[відсутнє повідомлення]"}</p>
                                            <input type="text" name="surname" id="name" placeholder="Edit surname" value="${userObj.surname}">
                                        </div>
                                    </div>
                                    <div class = "name3">
                                    <p class="lighttxt">E-mail</p>
                                   <input type="email" name="" id="email" placeholder="Edit e-mail" value="${userObj.username}" disabled>
                                    </div>
                                    </div>
                            </div>
                        </div>
                    </div>
                    <div class="overall">

                    </div>
                </div>
            </div>
            <div class="bottom-section">
                <div class="create_proj">
                    <div class="basicinf">
                        <p class="h-text ">${springMacroRequestContext.getMessage("editpas.message")!"[відсутнє повідомлення]"}</p>
                        <div class="pr_name">
                            <div class="proj_name">
                                <input type="password" name="" id="" placeholder="Enter old password">
                                <input type="password" name="" id="" placeholder="Enter new password">
                                <input type="password" name="" id="" placeholder="Confirm new password">
                            </div>
                        </div>
                    </div>
<#--                    <div class="moreinf">-->
<#--                        <p class="h-text ">Edit your region:</p>-->
<#--                        <div class="wrap_select">-->
<#--                        </div>-->

<#--                        <div class="region edit">-->
<#--                            <select name="country" class="countries" id="countryId">-->
<#--                                <option value=""><#if userObj.country?has_content>${userObj.country}<#else>Select Country</#if></option>-->
<#--                            </select>-->
<#--                            <select name="state" class="states" id="stateId">-->
<#--                                <option value=""><#if userObj.state?has_content>${userObj.state}<#else>Select State</#if></option>-->
<#--                            </select>-->
<#--                            <select name="city" class="cities" id="cityId">-->
<#--                                <option value=""><#if userObj.city?has_content>${userObj.city}<#else>Select City</#if></option>-->
<#--                            </select>-->

<#--                            -->

<#--                        </div>-->
<#--                    </div>-->
                    <input type="hidden" name="userID" value="${userObj.id}" id="">
                </div>
            </div>
            <div class="wrapview">
                    <input type="submit" value="Submit" class="save">
                    <#--<div class="button_proj">Save</div>-->
            </div>
            <div class="wrapview">
                <a href="/profile">
                    <div class="cancel" id="cancel">Cancel</div>
                </a>
            </div>
        </form>
        <@c.footer></@c.footer>
    </div>
    <@c.scripts>
        <script>
            window.addEventListener('load', function() {
                document.querySelector('input[type="file"]').addEventListener('change', function() {
                    if (this.files && this.files[0]) {
                        var img = document.querySelector('img');
                        img.src = URL.createObjectURL(this.files[0]);
                        img.onload = imageIsLoaded;
                    }

                });
            });

            function imageIsLoaded() {
                document.getElementById("myImg").style.display = "block";
                var element = document.getElementById("pr");
                element.classList.add("dropped");
                // update width and height ...
            }
            $(document).ready(function() {
                var holder = document.getElementById('pr');
                holder.ondragover = function () { this.className = 'hover'; return false; };
            });

        </script>
    </@c.scripts>

</@c.body>
</html>

