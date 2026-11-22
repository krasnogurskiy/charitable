<#import "parts/common.ftlh" as c>
<#import "/spring.ftl" as spring />

<!DOCTYPE html>
<html lang="en" dir="ltr">
<@c.head>
    <link rel="stylesheet" href="/css/dropzone.css">
    <link rel="stylesheet" href="/css/basic.css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

    <!-- MediaPipe для розпізнавання обличчя в браузері (Active Liveness) -->
    <script src="https://cdn.jsdelivr.net/npm/@mediapipe/camera_utils/camera_utils.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh/face_mesh.js" crossorigin="anonymous"></script>

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

        /* Стилі для камери Liveness */
        #liveness-container { display: none; margin-top: 20px; text-align: center; }
        .camera-viewport {
            position: relative;
            width: 100%;
            max-width: 480px;
            height: 360px;
            margin: 0 auto;
            background: #0f172a;
            border-radius: 14px;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        #webcam-video { width: 100%; height: 100%; object-fit: cover; transform: scaleX(-1); }
        .oval-overlay {
            position: absolute;
            width: 220px;
            height: 280px;
            border: 4px solid #38bdf8;
            border-radius: 50%;
            box-shadow: 0 0 0 9999px rgba(15, 23, 42, 0.7);
            transition: border-color 0.3s ease;
            pointer-events: none;
        }
        .oval-overlay.oval-valid { border-color: #22c55e; }
        .instruction-banner { margin-top: 14px; padding: 12px; border-radius: 8px; background: #e0f2fe; color: #0284c7; font-weight: 600; font-size: 16px; }
        #liveness-success { display: none; color: #155724; background: #d4edda; padding: 15px; border-radius: 8px; margin-top: 15px; font-weight: bold; border: 1px solid #c3e6cb;}
    </style>
</@c.head>

<@c.body isLogged isVerified>
    <input type="hidden" id="kyc-user-id-holder" value="${kycUserId?c}" />

    <!-- Передаємо дані з бази Java у приховані поля за допомогою правильного об'єкта userObj -->
    <input type="hidden" id="currentUserName" value="${(userObj.firstName)!''}" />
    <input type="hidden" id="currentUserSurname" value="${(userObj.surname)!''}" />

    <div class="content_crtpr vrf">
        <p class="maintxt">${springMacroRequestContext.getMessage("upgPr.message")!"[відсутнє повідомлення]"}</p>

        <div id="steps">
            <div class="step active" data-desc="${springMacroRequestContext.getMessage("passport.message")!"[відсутнє повідомлення]"}">1</div>
            <div class="step" data-desc="${springMacroRequestContext.getMessage("bankDetails.message")!"[відсутнє повідомлення]"}">2</div>
            <div class="step" data-desc="${springMacroRequestContext.getMessage("rewsub.message")!"[відсутнє повідомлення]"}">3</div>
        </div>

        <!-- ТАБ 1: ПАСПОРТ ТА ACTIVE LIVENESS -->
        <div class="tab">
            <p class="maintxt" style="text-align: center; font-weight: bold; color: #6f42c1;">
                🤖 Крок 1. Завантажте фото паспорта
            </p>

            <!-- Зона для паспорта -->
            <div id="dropzone-container">
                <div action="/upload-image" class="dropzone needsclick dz-clickable" id="demo-upload" enctype="multipart/form-data" method="POST">
                    <div class="dz-default dz-message">
                        <button class="dz-button" type="button" onchange="updateSize()">
                            ${springMacroRequestContext.getMessage("dragdrop.message")!"Перетягніть сюди"}<br>
                            скан вашого паспорта (1 файл)
                        </button>
                    </div>
                </div>
            </div>

            <!-- Зона вебкамери (з'явиться після завантаження паспорта) -->
            <div id="liveness-container">
                <p class="maintxt" style="text-align: center; font-weight: bold; color: #6f42c1; margin-bottom: 10px; font-size: 18px;">
                    📷 Крок 2. Перевірка Liveness (Біометрія)
                </p>
                <div class="camera-viewport">
                    <video id="webcam-video" autoplay playsinline muted></video>
                    <div id="face-oval" class="oval-overlay"></div>
                </div>
                <!-- Прихований canvas для генерації Blob -->
                <canvas id="capture-canvas" width="640" height="480" style="display: none;"></canvas>

                <div id="liveness-instruction" class="instruction-banner">Запуск камери...</div>
                <div id="liveness-success">✅ Обличчя успішно зафіксовано! Stateless-обробка (в RAM). Можете переходити далі.</div>
            </div>
            <br />
        </div>

        <!-- ТАБ 2: БАНКІВСЬКА КАРТКА -->
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
                                                        <g><rect x="82" y="70" class="st12" width="1.5" height="60" /></g>
                                                        <g><rect x="167.4" y="70" class="st12" width="1.5" height="60" /></g>
                                                        <g>
                                                            <path class="st12" d="M125.5,130.8c-10.2,0-18.5-8.3-18.5-18.5c0-4.6,1.7-8.9,4.7-12.3c-3-3.4-4.7-7.7-4.7-12.3
                                                    c0-10.2,8.3-18.5,18.5-18.5s18.5,8.3,18.5,18.5c0,4.6-1.7,8.9-4.7,12.3c3,3.4,4.7,7.7,4.7,12.3
                                                    C143.9,122.5,135.7,130.8,125.5,130.8z M125.5,70.8c-9.3,0-16.9,7.6-16.9,16.9c0,4.4,1.7,8.6,4.8,11.8l0.5,0.5l-0.5,0.5
                                                    c-3.1,3.2-4.8,7.4-4.8,11.8c0,9.3,7.6,16.9,16.9,16.9s16.9-7.6,16.9-16.9c0-4.4-1.7-8.6-4.8-11.8l-0.5-0.5l0.5-0.5
                                                    c3.1-3.2,4.8-7.4,4.8-11.8C142.4,78.4,134.8,70.8,125.5,70.8z" />
                                                        </g>
                                                        <g><rect x="82.8" y="82.1" class="st12" width="25.8" height="1.5" /></g>
                                                        <g><rect x="82.8" y="117.9" class="st12" width="26.1" height="1.5" /></g>
                                                        <g><rect x="142.4" y="82.1" class="st12" width="25.8" height="1.5" /></g>
                                                        <g><rect x="142" y="117.9" class="st12" width="26.2" height="1.5" /></g>
                                                    </g>
                                                </g>
                                            </g>
                                    <g id="Back"></g>
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

        <!-- ТАБ 3: ПРОЦЕСИНГ ТА РЕЗУЛЬТАТ ШІ -->
        <div class="tab">
            <div id="ai-processing" style="text-align: center; padding: 40px 20px;">
                <div class="spinner"></div>
                <p style="font-weight: bold; font-size: 20px; color: #333; margin-bottom: 8px;">🤖 Запуск нейромережевого KYC-модуля...</p>
                <p style="color: #6c757d; font-size: 14px;">Аналіз Liveness, перевірка документа та порівняння векторів FaceNet...</p>
            </div>

            <div id="ai-result" style="display: none; padding: 20px 0;">
                <!-- Тут буде динамічно заповнюватися результат через JS -->
            </div>
        </div>

        <div class="wrapview">
            <button class="button_proj" type="button" id="nextBtn" onclick="nextPrev(1)">Далі</button>
        </div>
        <div class="wrapview">
            <button class="cancel" type="button" id="prevBtn" onclick="nextPrev(-1)">${springMacroRequestContext.getMessage("previous.message")!"[відсутнє повідомлення]"}</button>
        </div>
    </div>

    <@c.footer></@c.footer>

<@c.scripts>
    <script>
        // Глобальні змінні для Liveness
        window.liveSelfieBlob = null;
        var cameraInstance = null;
    </script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="/js/dropzone.js"></script>

    <script>
        // Жорстко вимикаємо автовиявлення ПІСЛЯ завантаження dropzone.js
        Dropzone.autoDiscover = false;

        // Якщо Dropzone вже встиг автоматично прикріпитися - знищуємо його перед нашою ініціалізацією
        if (Dropzone.instances.length > 0) {
            Dropzone.instances.forEach(dz => dz.destroy());
        }

        // Ініціалізуємо Dropzone тільки для 1 файлу (Паспорт)
        var myDropzone = new Dropzone("#demo-upload", {
            url: "/upload-image", // autoProcessQueue вимкнено, тому url ролі не грає
            autoProcessQueue: false,
            maxFiles: 1,
            acceptedFiles: "image/*",
            init: function() {
                this.on("addedfile", function(file) {
                    if (this.files.length > 1) {
                        this.removeFile(file);
                        alert("Дозволено завантажити лише 1 файл (фото паспорта).");
                        return;
                    }

                    // Блокуємо кнопку "Далі", поки не пройдена вебкамера
                    if(document.getElementById("nextBtn")) {
                        document.getElementById("nextBtn").disabled = true;
                        document.getElementById("nextBtn").style.opacity = "0.5";
                    }

                    // Ховаємо Dropzone, відкриваємо Liveness-камеру
                    document.getElementById("dropzone-container").style.display = "none";
                    document.getElementById("liveness-container").style.display = "block";

                    startActiveLivenessCamera();
                });
            }
        });

        // Скінченний автомат для Liveness
        const LivenessState = { WAIT_CENTER: 0, WAIT_TURN: 1, RETURN_CENTER: 2, CAPTURED: 3 };
        let currentState = LivenessState.WAIT_CENTER;
        let centerFrames = 0, turnFrames = 0;

        function startActiveLivenessCamera() {
            const videoElement = document.getElementById('webcam-video');
            const faceMesh = new FaceMesh({
                locateFile: (file) => "https://cdn.jsdelivr.net/npm/@mediapipe/face_mesh/" + file
            });

            faceMesh.setOptions({
                maxNumFaces: 1,
                refineLandmarks: true,
                minDetectionConfidence: 0.6,
                minTrackingConfidence: 0.6
            });
            faceMesh.onResults(onFaceMeshResults);

            cameraInstance = new Camera(videoElement, {
                onFrame: async () => {
                    if (currentState !== LivenessState.CAPTURED) {
                        await faceMesh.send({ image: videoElement });
                    }
                },
                width: 640,
                height: 480
            });
            cameraInstance.start();
        }

        function onFaceMeshResults(results) {
            if (currentState === LivenessState.CAPTURED) return;

            const instruction = document.getElementById('liveness-instruction');
            const oval = document.getElementById('face-oval');

            if (!results.multiFaceLandmarks || results.multiFaceLandmarks.length === 0) {
                instruction.innerText = 'Обличчя не знайдено. Помістіть обличчя в овал';
                oval.classList.remove('oval-valid');
                return;
            }

            const landmarks = results.multiFaceLandmarks[0];
            const nose = landmarks[1];
            const leftEdge = landmarks[234];
            const rightEdge = landmarks[454];

            // Перевіряємо чи обличчя в межах овалу
            if (nose.x < 0.35 || nose.x > 0.65 || nose.y < 0.25 || nose.y > 0.75) {
                instruction.innerText = 'Тримайте обличчя по центру овалу';
                oval.classList.remove('oval-valid');
                return;
            }

            oval.classList.add('oval-valid');

            // Обчислення повороту голови
            const faceWidth = Math.abs(rightEdge.x - leftEdge.x);
            const noseOffset = (nose.x - leftEdge.x) / faceWidth; // ~0.50 в анфас

            if (currentState === LivenessState.WAIT_CENTER) {
                instruction.innerText = 'Дивіться прямо в камеру...';
                if (noseOffset > 0.42 && noseOffset < 0.58) {
                    if (++centerFrames > 10) {
                        currentState = LivenessState.WAIT_TURN;
                    }
                }
            } else if (currentState === LivenessState.WAIT_TURN) {
                instruction.innerText = 'Поверніть голову ліворуч або праворуч';
                if (noseOffset > 0.65 || noseOffset < 0.35) {
                    if (++turnFrames > 5) {
                        currentState = LivenessState.RETURN_CENTER;
                    }
                }
            } else if (currentState === LivenessState.RETURN_CENTER) {
                instruction.innerText = 'Чудово! Тепер подивіться прямо для знімка';
                if (noseOffset > 0.44 && noseOffset < 0.56) {
                    currentState = LivenessState.CAPTURED;
                    captureFrameAndStop();
                }
            }
        }

        function captureFrameAndStop() {
            const videoElement = document.getElementById('webcam-video');
            const canvasElement = document.getElementById('capture-canvas');
            const ctx = canvasElement.getContext('2d');

            // Знімок кадру
            ctx.drawImage(videoElement, 0, 0, canvasElement.width, canvasElement.height);

            if (cameraInstance) {
                cameraInstance.stop();
            }

            // Конвертація в Blob (Stateless, зберігається в пам'яті)
            canvasElement.toBlob((blob) => {
                window.liveSelfieBlob = blob;

                document.getElementById('liveness-instruction').style.display = 'none';
                document.getElementById('liveness-success').style.display = 'block';
                document.getElementById('face-oval').style.display = 'none';
                document.querySelector('.camera-viewport').style.display = 'none';

                // Активуємо кнопку Далі
                var nextBtn = document.getElementById("nextBtn");
                if(nextBtn) {
                    nextBtn.disabled = false;
                    nextBtn.style.opacity = "1";
                }
            }, 'image/jpeg', 0.95);
        }
    </script>

    <script src="/js/verification.js"></script>
    <script src="/js/credit-card.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/imask/3.4.0/imask.min.js"></script>

    <script>
        var originalNextPrev = nextPrev;

        nextPrev = function(n) {
            originalNextPrev(n);

            if (typeof currentTab !== 'undefined' && currentTab === 2) {
                if(document.getElementById("prevBtn")) document.getElementById("prevBtn").style.display = "none";
                if(document.getElementById("nextBtn")) {
                    document.getElementById("nextBtn").innerHTML = "Аналіз ШІ...";
                    document.getElementById("nextBtn").disabled = true;
                }

                setTimeout(function() {
                    console.log("Готуємо Multipart-запит (Паспорт + Liveness Selfie)...");

                    var currentUserId = $("#kyc-user-id-holder").val();
                    var token = $("input[name='_csrf']").val() || "";

                    // Зчитуємо ім'я та прізвище з прихованих полів
                    var userName = $("#currentUserName").val() || "";
                    var userSurname = $("#currentUserSurname").val() || "";

                    var formData = new FormData();
                    formData.append("userId", currentUserId);
                    if (token) {
                        formData.append("_csrf", token);
                    }
                    // Додаємо імена до форми
                    formData.append("userName", userName);
                    formData.append("userSurname", userSurname);

                    var files = myDropzone.getAcceptedFiles();

                    // СТРОГА ПЕРЕВІРКА НА ФРОНТЕНДІ: 1 ФАЙЛ ПАСПОРТА ТА 1 BLOB З ВЕБКАМЕРИ
                    if (files.length !== 1 || !window.liveSelfieBlob) {
                        console.warn("[AJAX REJECT] Не пройдено Liveness або не завантажено паспорт.");

                        if (document.getElementById("ai-processing")) {
                            document.getElementById("ai-processing").style.display = "none";
                        }

                        if (document.getElementById("ai-result")) {
                            document.getElementById("ai-result").innerHTML = `
                                <div class="ai-alert" style="background: #fff3cd; color: #856404; border-color: #ffeeba;">
                                    <span style="font-size: 44px; display: block; margin-bottom: 10px;">⚠️</span>
                                    <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #856404; font-size: 22px;">Помилка завантаження даних</h3>
                                    <p style="font-size: 14px; line-height: 1.5; margin: 0; text-align: center;">
                                         Для проходження перевірки потрібно завантажити документ і пройти перевірку обличчя на камері.
                                    </p>
                                </div>`;
                            document.getElementById("ai-result").style.display = "block";
                        }

                        var nextBtn = document.getElementById("nextBtn");
                        if (nextBtn) {
                            nextBtn.innerHTML = "Почати заново";
                            nextBtn.disabled = false;
                            nextBtn.onclick = function() { window.location.reload(); };
                        }
                        return;
                    }

                    // Пакуємо файли у форму для Java Multipart-контролера
                    formData.append("passport", files[0]); // файл з Dropzone
                    formData.append("selfie", window.liveSelfieBlob, "live_selfie.jpg"); // кадр з камери
                    formData.append("livenessPassed", "true");

                    console.log("Відправка асинхронного Multipart AJAX на сервер...");

                    $.ajax({
                        type: "POST",
                        url: "/profile/verify",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function(response) {
                            console.log("Успішна відповідь від сервера: ", response);

                            if (response === "SUCCESS") {
                                if (document.getElementById("ai-processing")) document.getElementById("ai-processing").style.display = "none";

                                if (document.getElementById("ai-result")) {
                                    document.getElementById("ai-result").innerHTML = `
                                        <div class="ai-alert">
                                            <span style="font-size: 44px; display: block; margin-bottom: 10px;">🛡️</span>
                                            <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #155724; font-size: 22px;">Біометричну верифікацію успішно пройдено!</h3>
                                            <p style="font-size: 16px; margin: 0 0 10px 0; font-weight: 600;">Вердикт ШІ: <span style="color: #28a745;">Особу підтверджено</span></p>
                                            <p style="font-size: 14px; line-height: 1.5; color: #1e7e34; margin: 0; text-align: left;">
                                                Anti-Spoofing перевірку пройдено. Нейромережа (CNN) підтвердила автентичність обличчя з паспортом. Роль оновлено до Help Seeker.
                                            </p>
                                        </div>`;
                                    document.getElementById("ai-result").style.display = "block";
                                }

                                var nextBtn = document.getElementById("nextBtn");
                                if (nextBtn) {
                                    nextBtn.innerHTML = "Завершити";
                                    nextBtn.disabled = false;
                                    nextBtn.onclick = function() { window.location.href = "/profile"; };
                                }
                            } else if (response === "FAILED_AI") {
                                if (document.getElementById("ai-processing")) document.getElementById("ai-processing").style.display = "none";

                                if (document.getElementById("ai-result")) {
                                    document.getElementById("ai-result").innerHTML = `
                                        <div class="ai-alert" style="background: #f8d7da; color: #721c24; border-color: #f5c6cb;">
                                            <span style="font-size: 44px; display: block; margin-bottom: 10px;">❌</span>
                                            <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #721c24; font-size: 22px;">ШІ-верифікацію відхилено!</h3>
                                            <p style="font-size: 14px; line-height: 1.5; margin: 0; text-align: center;">
                                                Виявлено незбіг осіб на документі та вебкамері, або спрацював захист від спуфінгу. Спробуйте ще раз із вашим справжнім документом.
                                            </p>
                                        </div>`;
                                    document.getElementById("ai-result").style.display = "block";
                                }

                                var nextBtn = document.getElementById("nextBtn");
                                if (nextBtn) {
                                    nextBtn.innerHTML = "Спробувати знову";
                                    nextBtn.disabled = false;
                                    nextBtn.onclick = function() { window.location.reload(); };
                                }
                            } else {
                                if (document.getElementById("ai-processing")) document.getElementById("ai-processing").style.display = "none";

                                if (document.getElementById("ai-result")) {
                                    document.getElementById("ai-result").innerHTML = `
                                        <div class="ai-alert" style="background: #f8d7da; color: #721c24; border-color: #f5c6cb;">
                                            <span style="font-size: 44px; display: block; margin-bottom: 10px;">🔌</span>
                                            <h3 style="margin: 0 0 10px 0; font-weight: bold; color: #721c24; font-size: 22px;">Сервіс ШІ тимчасово недоступний</h3>
                                            <p style="font-size: 14px; line-height: 1.5; margin: 0; text-align: center;">
                                                Автономний пропуск заблоковано з міркувань безпеки. Будь ласка, спробуйте пройти перевірку пізніше.
                                            </p>
                                        </div>`;
                                    document.getElementById("ai-result").style.display = "block";
                                }

                                var nextBtn = document.getElementById("nextBtn");
                                if (nextBtn) {
                                    nextBtn.innerHTML = "Повернутися в профіль";
                                    nextBtn.disabled = false;
                                    nextBtn.onclick = function() { window.location.href = "/profile"; };
                                }
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error("Помилка запиту!", error);
                            alert("Помилка зв'язку з сервером. Статус HTTP: " + xhr.status);
                        }
                    });
                }, 1500);
            }
        }
    </script>
</@c.scripts>
</@c.body>
</html>