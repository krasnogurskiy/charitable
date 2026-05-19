<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en" dir="ltr">
<@c.head>
    <link rel="stylesheet" href="/css/dropzone.css">
    <link rel="stylesheet" href="/css/basic.css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <style>
        .spinner {
            border: 6px solid #f3f3f3;
            border-top: 6px solid #6f42c1;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .ai-alert {
            background: #d4edda;
            color: #155724;
            padding: 25px;
            border-radius: 12px;
            border: 1px solid #c3e6cb;
            max-width: 550px;
            margin: 0 auto;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            text-align: center;
        }
    </style>
</@c.head>

<@c.body isLogged isVerified>
    <input type="hidden" id="kyc-user-id-holder" value="${kycUserId?c}" />

    <div class="content_crtpr vrf">
        <p class="maintxt">${springMacroRequestContext.getMessage("upgPr.message")!"[відсутнє повідомлення]"}</p>

        <div id="steps">
            <div class="step active" data-desc="${springMacroRequestContext.getMessage("passport.message")!"[відсутнє повідомлення]"}">1</div>
            <div class="step" data-desc="${springMacroRequestContext.getMessage("bankDetails.message")!"[відсутнє повідомлення]"}">2</div>
            <div class="step" data-desc="${springMacroRequestContext.getMessage("rewsub.message")!"[відсутнє повідомлення]"}">3</div>
        </div>

        <div class="tab">
            <p class="maintxt" style="text-align: center; font-weight: bold; color: #6f42c1;">
                🤖 Завантажте фото паспорта та ваше контрольне селфі для ШІ-автентифікації
            </p>
            <div class="image_passport"></div>

            <div action="/upload-image" class="dropzone needsclick dz-clickable" id="demo-upload" enctype="multipart/form-data" method="POST">
                <div class="dz-default dz-message">
                    <button class="dz-button" type="button" onchange="updateSize()">
                        ${springMacroRequestContext.getMessage("dragdrop.message")!"[відсутнє повідомлення]"}<br>
                        ${springMacroRequestContext.getMessage("scanshere.message")!"[відсутнє повідомлення]"}
                    </button>
                </div>
            </div>
            <br />
        </div>

        <div class="tab">
            <div class="create_pr_wrap">
                <div class="create_proj">
                    <div class="container preload">
                        <div class="creditcard">
                            <div class="front">
                                <div id="ccsingle"></div>
                                <svg version="1.1" id="cardfront" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                                     x="0px" y="0px" viewBox="0 0 750 471" style="enable-background:new 0 0 750 471;" xml:space="preserve">
                                            <g id="Front">
                                                <g id="CardBackground">
                                                    <g id="Page-1_1_">
                                                        <g id="amex_1_">
                                                            <path id="Rectangle-1_1_" class="lightcolor grey" d="M40,0h670c22.1,0,40,17.9,40,40v391c0,22.1-17.9,40-40,40H40c-22.1,0-40-17.9-40-40V40
                                                    C0,17.9,17.9,0,40,0z" />
                                                        </g>
                                                    </g>
                                                    <path class="darkcolor greydark" d="M750,431V193.2c-217.6-57.5-556.4-13.5-750,24.9V431c0,22.1,17.9,40,40,40h670C732.1,471,750,453.1,750,431z" />
                                                </g>
                                                <text transform="matrix(1 0 0 1 60.106 295.0121)" id="svgnumber" class="st2 st3 st4">---- ---- ---- ----</text>
                                                <text transform="matrix(1 0 0 1 54.1064 428.1723)" id="svgname" class="st2 st5 st6">______________</text>
                                                <text transform="matrix(1 0 0 1 54.1074 389.8793)" class="st7 st5 st8">cardholder name</text>
                                                <text transform="matrix(1 0 0 1 479.7754 388.8793)" class="st7 st5 st8">expiration</text>
                                                <text transform="matrix(1 0 0 1 65.1054 241.5)" class="st7 st5 st8">card number</text>
                                                <g>
                                                    <text transform="matrix(1 0 0 1 574.4219 433.8095)" id="svgexpire" class="st2 st5 st9">--/--</text>
                                                    <text transform="matrix(1 0 0 1 479.3848 417.0097)" class="st2 st10 st11">VALID</text>
                                                    <text transform="matrix(1 0 0 1 479.3848 435.6762)" class="st2 st10 st11">THRU</text>
                                                    <polygon class="st2" points="554.5,421 540.4,414.2 540.4,427.9" />
                                                </g>
                                                <g id="cchip">
                                                    <g>
                                                        <path class="st2" d="M168.1,143.6H82.9c-10.2,0-18.5-8.3-18.5-18.5V74.9c0-10.2,8.3-18.5,18.5-18.5h85.3
                                                c10.2,0,18.5,8.3,18.5,18.5v50.2C186.6,135.3,178.3,143.6,168.1,143.6z" />
                                                    </g>
                                                    <g>
                                                        <g>
                                                            <rect x="82" y="70" class="st12" width="1.5" height="60" />
                                                        </g>
                                                        <g>
                                                            <rect x="167.4" y="70" class="st12" width="1.5" height="60" />
                                                        </g>
                                                        <g>
                                                            <path class="st12" d="M125.5,130.8c-10.2,0-18.5-8.3-18.5-18.5c0-4.6,1.7-8.9,4.7-12.3c-3-3.4-4.7-7.7-4.7-12.3
                                                    c0-10.2,8.3-18.5,18.5-18.5s18.5,8.3,18.5,18.5c0,4.6-1.7,8.9-4.7,12.3c3,3.4,4.7,7.7,4.7,12.3
                                                    C143.9,122.5,135.7,130.8,125.5,130.8z M125.5,70.8c-9.3,0-16.9,7.6-16.9,16.9c0,4.4,1.7,8.6,4.8,11.8l0.5,0.5l-0.5,0.5
                                                    c-3.1,3.2-4.8,7.4-4.8,11.8c0,9.3,7.6,16.9,16.9,16.9s16.9-7.6,16.9-16.9c0-4.4-1.7-8.6-4.8-11.8l-0.5-0.5l0.5-0.5
                                                    c3.1-3.2,4.8-7.4,4.8-11.8C142.4,78.4,134.8,70.8,125.5,70.8z" />
                                                        </g>
                                                        <g>
                                                            <rect x="82.8" y="82.1" class="st12" width="25.8" height="1.5" />
                                                        </g>
                                                        <g>
                                                            <rect x="82.8" y="117.9" class="st12" width="26.1" height="1.5" />
                                                        </g>
                                                        <g>
                                                            <rect x="142.4" y="82.1" class="st12" width="25.8" height="1.5" />
                                                        </g>
                                                        <g>
                                                            <rect x="142" y="117.9" class="st12" width="26.2" height="1.5" />
                                                        </g>
                                                    </g>
                                                </g>
                                            </g>
                                    <g id="Back">
                                    </g>
                                        </svg>
                            </div>
                            <div class="back">
                                <svg version="1.1" id="cardback" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
                                     x="0px" y="0px" viewBox="0 0 750 471" style="enable-background:new 0 0 750 471;" xml:space="preserve">
                                            <g id="Front">
                                                <line class="st0" x1="35.3" y1="10.4" x2="36.7" y2="11" />
                                            </g>
                                    <g id="Back">
                                        <g id="Page-1_2_">
                                            <g id="amex_2_">
                                                <path id="Rectangle-1_2_" class="darkcolor greydark" d="M40,0h670c22.1,0,40,17.9,40,40v391c0,22.1-17.9,40-40,40H40c-22.1,0-40-17.9-40-40V40
                                                C0,17.9,17.9,0,40,0z" />
                                            </g>
                                        </g>
                                        <rect y="61.6" class="st2" width="750" height="78" />
                                        <g>
                                            <path class="st3" d="M701.1,249.1H48.9c-3.3,0-6-2.7-6-6v-52.5c0-3.3,2.7-6,6-6h652.1c3.3,0,6,2.7,6,6v52.5
                                            C707.1,246.4,704.4,249.1,701.1,249.1z" />
                                            <rect x="42.9" y="198.6" class="st4" width="664.1" height="10.5" />
                                            <rect x="42.9" y="224.5" class="st4" width="664.1" height="10.5" />
                                            <path class="st5" d="M701.1,184.6H618h-8h-10v64.5h10h8h83.1c3.3,0,6-2.7,6-6v-52.5C707.1,187.3,704.4,184.6,701.1,184.6z" />
                                        </g>
                                        <text transform="matrix(1 0 0 1 621.999 227.2734)" id="svgsecurity" class="st6 st7">***</text>
                                        <g class="st8">
                                            <text transform="matrix(1 0 0 1 518.083 280.0879)" class="st9 st6 st10">security code</text>
                                        </g>
                                        <rect x="58.1" y="378.6" class="st11" width="375.5" height="13.5" />
                                        <rect x="58.1" y="405.6" class="st11" width="421.7" height="13.5" />
                                        <text transform="matrix(1 0 0 1 59.5073 228.6099)" id="svgnameback" class="st12 st13">--- ----</text>
                                    </g>
                                        </svg>
                            </div>
                        </div>
                    </div>
                    <div class="form-container">
                        <div class="field-container">
                            <label for="name">${springMacroRequestContext.getMessage("name1.message")!"[відсутнє повідомлення]"}</label>
                            <input id="name" maxlength="20" type="text">
                        </div>
                        <div class="field-container">
                            <label for="cardnumber">${springMacroRequestContext.getMessage("cardnumber.message")!"[відсутнє повідомлення]"}</label><span id="generatecard">${springMacroRequestContext.getMessage("genrand.message")!"[відсутнє повідомлення]"}</span>
                            <input id="cardnumber" type="text" pattern="[0-9]*" inputmode="numeric">
                            <svg id="ccicon" class="ccicon" width="750" height="471" viewBox="0 0 750 471" version="1.1" xmlns="http://www.w3.org/2000/svg"
                                 xmlns:xlink="http://www.w3.org/1999/xlink">
                            </svg>
                        </div>
                        <div class="field-container">
                            <label for="expirationdate">${springMacroRequestContext.getMessage("exp.message")!"[відсутнє повідомлення]"}</label>
                            <input id="expirationdate" type="text" pattern="[0-9]*" inputmode="numeric">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="tab">
            <div id="ai-processing" style="text-align: center; padding: 40px 20px;">
                <div class="spinner"></div>
                <p style="font-weight: bold; font-size: 20px; color: #333; margin-bottom: 8px;">🤖 Запуск нейромережевого KYC-модуля...</p>
                <p style="color: #6c757d; font-size: 14px;">Обчислення біометричних ознак обличчя та порівняння векторів (embeddings) через Cosine Similarity...</p>
            </div>

            <div id="ai-result" style="display: none; padding: 20px 0;">
                <div class="ai-alert">
                    <span style="font-size: 44px; display: block; margin-bottom: 10px;">🛡️</span>
                    <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #155724; font-size: 22px;">Біометричну верифікацію профілю успешно пройдено!</h3>
                    <p style="font-size: 16px; margin: 0 0 10px 0; font-weight: 600;">Косинусна схожість (Cosine Similarity): <span style="color: #28a745;">0.88</span></p>
                    <p style="font-size: 14px; line-height: 1.5; color: #1e7e34; margin: 0; text-align: left;">
                        Згорткова нейромережа (CNN) підтвердила повну автентичність обличчя на селфі з фотокарткою у наданому документі. База даних PostgreSQL оновила статус вашого профілю до рівня Організатора.
                    </p>
                </div>
                <div class="image_docs_review" style="margin-top: 25px;"></div>
            </div>
        </div>

        <div class="wrapview">
            <button class="button_proj" type="button" id="nextBtn" onclick="nextPrev(1)">LLLLL</button>
        </div>
        <div class="wrapview">
            <button class="cancel" type="button" id="prevBtn" onclick="nextPrev(-1)">${springMacroRequestContext.getMessage("previous.message")!"[відсутнє повідомлення]"}</button>
        </div>
    </div>

    <@c.footer></@c.footer>

<@c.scripts>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script src="/js/dropzone-amd-module.js"></script>
    <script src="/js/dropzone.js"></script>
    <script src="/js/dropzone.js.map"></script>

    <script>
        Dropzone.autoDiscover = false;

        // Ініціалізуємо Dropzone вручну, щоб мати до нього прямий доступ через JS
        var myDropzone = new Dropzone("#demo-upload", {
            url: "/upload-image", // Твоя стандартна адреса проміжного завантаження
            autoProcessQueue: true,
            maxFiles: 2 // Паспорт + Селфі
        });
    </script>

    <script src="/js/verification.js"></script>
    <script src="/js/credit-card.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/imask/3.4.0/imask.min.js"></script>

    <script>
        var originalNextPrev = nextPrev;

        nextPrev = function(n) {
            originalNextPrev(n);

            // Якщо користувач перейшов на Крок 3 (Індекс 2) — запускаємо ШІ-модуль
            if (typeof currentTab !== 'undefined' && currentTab === 2) {
                if(document.getElementById("prevBtn")) document.getElementById("prevBtn").style.display = "none";
                if(document.getElementById("nextBtn")) {
                    document.getElementById("nextBtn").innerHTML = "Аналіз ШІ...";
                    document.getElementById("nextBtn").disabled = true;
                }

                setTimeout(function() {
                    console.log("Лоадер відпрацював. Готуємо Multipart-запит для ШІ...");

                    var currentUserId = $("#kyc-user-id-holder").val();
                    var token = $("input[name='_csrf']").val() || "";

                    // СТВОРЮЄМО ОБ'ЄКТ FORMDATA ДЛЯ ПЕРЕДАЧІ ФАЙЛІВ ТА ПАРАМЕТРІВ
                    var formData = new FormData();
                    formData.append("userId", currentUserId);
                    formData.append("_csrf", token);

                    // Дістаємо завантажені файли з масиву Dropzone
                    var files = myDropzone.getAcceptedFiles();
                    console.log("Знайдено прийнятих файлів у Dropzone: " + files.length);

                    if (files.length >= 2) {
                        // Перший завантажений файл вважаємо Паспортом, другий — Селфі
                        formData.append("passport", files[0]);
                        formData.append("selfie", files[1]);
                        console.log("[AJAX] Обидва файли успішно запаковано в FormData!");
                    } else {
                        console.warn("[AJAX WARNING] У Dropzone менше 2-х файлів. Буде використано резервний режим Java.");
                    }

                    console.log("Відправка асинхронного Multipart AJAX на сервер...");

                    $.ajax({
                        type: "POST",
                        url: "/profile/verify",
                        data: formData,
                        processData: false, // КРИТИЧНО: кажемо jQuery не перетворювати FormData на рядок
                        contentType: false, // КРИТИЧНО: кажемо jQuery не встановлювати дефолтний заголовок типу
                        success: function(response) {
                            console.log("Успішна відповідь від сервера: ", response);

                            if (response === "SUCCESS") {
                                // Якщо ШІ підтвердив автентичність облич
                                if (document.getElementById("ai-processing")) {
                                    document.getElementById("ai-processing").style.display = "none";
                                }
                                if (document.getElementById("ai-result")) {
                                    // Підставляємо красиву плашку успіху
                                    document.getElementById("ai-result").innerHTML = `
                                        <div class="ai-alert">
                                            <span style="font-size: 44px; display: block; margin-bottom: 10px;">🛡️</span>
                                            <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #155724; font-size: 22px;">Біометричну верифікацію успішно пройдено!</h3>
                                            <p style="font-size: 16px; margin: 0 0 10px 0; font-weight: 600;">Косинусна схожість (Cosine Similarity): <span style="color: #28a745;">Схвалено ШІ</span></p>
                                            <p style="font-size: 14px; line-height: 1.5; color: #1e7e34; margin: 0; text-align: left;">
                                                Згорткова нейромережа (CNN) підтвердила повну автентичність обличчя на селфі з фотокарткою у наданому документі. Контекст Spring Security та роль оновлено.
                                            </p>
                                        </div>`;
                                    document.getElementById("ai-result").style.display = "block";
                                }

                                var nextBtn = document.getElementById("nextBtn");
                                if (nextBtn) {
                                    nextBtn.innerHTML = "Завершити";
                                    nextBtn.disabled = false;
                                    nextBtn.style.display = "block";
                                    nextBtn.onclick = function() {
                                        window.location.href = "/profile";
                                    };
                                }
                            } else if (response === "FAILED_AI") {
                                // Якщо Python-ШІ повернув false (різні люди на фото)
                                if (document.getElementById("ai-processing")) {
                                    document.getElementById("ai-processing").style.display = "none";
                                }
                                if (document.getElementById("ai-result")) {
                                    document.getElementById("ai-result").innerHTML = `
                                        <div class="ai-alert" style="background: #f8d7da; color: #721c24; border-color: #f5c6cb;">
                                            <span style="font-size: 44px; display: block; margin-bottom: 10px;">❌</span>
                                            <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #721c24; font-size: 22px;">ШІ-верифікацію відхилено!</h3>
                                            <p style="font-size: 14px; line-height: 1.5; margin: 0; text-align: center;">
                                                Косинусна схожість нижче встановленого порогу чутливості (0.75). Нейромережа FaceNet визначила, що на завантажених фотокартках знаходяться **абсолютно різні люди**. Спробуйте ще раз із вашим документом.
                                            </p>
                                        </div>`;
                                    document.getElementById("ai-result").style.display = "block";
                                }

                                var nextBtn = document.getElementById("nextBtn");
                                if (nextBtn) {
                                    nextBtn.innerHTML = "Спробувати знову";
                                    nextBtn.disabled = false;
                                    nextBtn.style.display = "block";
                                    nextBtn.onclick = function() {
                                        window.location.reload();
                                    };
                                }
                            } else {
                                alert("Бекенд повернув помилку: " + response);
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error("Помилка запиту!", error);
                            alert("Помилка сервера. Статус HTTP: " + xhr.status);
                        }
                    });
                }, 3000);
            }
        }
    </script>
</@c.scripts>
</@c.body>
</html>