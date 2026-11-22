import numpy as np
import cv2
from flask import Flask, request, jsonify
import torch
from facenet_pytorch import MTCNN, InceptionResnetV1
from PIL import Image
import io
import easyocr
import difflib
import re

app = Flask(__name__)

# (якщо є відеокарта — використовуємо її, інакше CPU)
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
reader = easyocr.Reader(['en', 'uk'], gpu=(device.type == 'cuda'))
print(f"[INFO] Використовується девайс для ШІ: {device}")

# Ініціалізуємо моделі на правильному девайсі
mtcnn = MTCNN(image_size=160, margin=20, device=device)
resnet = InceptionResnetV1(pretrained='vggface2').eval().to(device)


def normalize_homoglyphs(text):

    mapping = {
        'A': 'А', 'B': 'В', 'C': 'С', 'E': 'Е', 'H': 'Н',
        'I': 'І', 'K': 'К', 'M': 'М', 'O': 'О', 'P': 'Р',
        'T': 'Т', 'X': 'Х', 'Y': 'У', '0': 'О'
    }
    return "".join(mapping.get(c, c) for c in text.upper())


def is_word_in_ocr(target_word, full_text, base_threshold=0.8):
    if not target_word:
        return True

    target_word = target_word.upper().strip()


    threshold = 0.74 if len(target_word) <= 4 else base_threshold

    target_norm = normalize_homoglyphs(target_word)

    clean_text = re.sub(r'[^А-ЯІЇЄҐA-Z]', ' ', full_text.upper())
    clean_norm = normalize_homoglyphs(clean_text)

    words = clean_norm.split()
    for word in words:
        if difflib.SequenceMatcher(None, target_norm, word).ratio() >= threshold:
            return True

    text_no_spaces = clean_norm.replace(" ", "")
    window_len = len(target_norm)

    if len(text_no_spaces) >= window_len:
        for i in range(len(text_no_spaces) - window_len + 1):
            chunk = text_no_spaces[i: i + window_len]
            if difflib.SequenceMatcher(None, target_norm, chunk).ratio() >= threshold:
                return True

    return False


def validate_passport_document(image_bytes, target_name="", target_surname=""):

    try:
        np_arr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
        if img is None:
            return False, "Пошкоджений файл зображення документа"

        max_dimension = 1024
        h, w, _ = img.shape
        if max(h, w) > max_dimension:
            scale = max_dimension / max(h, w)
            img = cv2.resize(img, (int(w * scale), int(h * scale)), interpolation=cv2.INTER_AREA)

        # 1. OCR-розпізнавання тексту за допомогою EasyOCR
        print("[AI OCR] Сканування документа на наявність текстів та MRZ-зони...")
        results = reader.readtext(img)

        # Об'єднуємо весь знайдений текст у єдиний рядок у верхньому регістрі
        full_text = " ".join([res[1] for res in results]).upper()
        print(f"[AI OCR] Знайдений текст (фрагмент): {full_text[:150]}...")

        # 2. Сувора перевірка наявності слова PASSPORT/ПАСПОРТ
        if "PASSPORT" not in full_text and "ПАСПОРТ" not in full_text:
            return False, "Документ відхилено: не знайдено слово PASSPORT або ПАСПОРТ"

        # 3. Перевірка збігу імені та прізвища (параметр base_threshold береться за замовчуванням 0.8)
        if target_surname and not is_word_in_ocr(target_surname, full_text):
            return False, f"Прізвище на документі не збігається з профілем (потрібно 80% збігу для: {target_surname})"

        if target_name and not is_word_in_ocr(target_name, full_text):
            return False, f"Ім'я на документі не збігається з профілем (потрібно 80% збігу для: {target_name})"

        # 4. Перевірка наявності фотографії (обличчя) на самому документі через MTCNN
        pil_img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
        boxes, _ = mtcnn.detect(pil_img)

        if boxes is None or len(boxes) == 0:
            return False, "Документ відхилено: на бланку не знайдено фотографії власника"

        print("[AI OCR] Документ успішно пройшов текстову та біометричну валідацію!")
        return True, "OK"

    except Exception as e:
        print(f"[DOCUMENT CHECK ERROR] {e}")
        return False, f"Помилка OCR-аналізу документа: {str(e)}"


def check_passive_liveness(image_bytes):

    try:
        np_arr = np.frombuffer(image_bytes, np.uint8)
        img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
        if img is None:
            return False, "Помилка декодування кадру з камери"

        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # 1. Аналіз текстури (Laplacian variance)
        laplacian_var = cv2.Laplacian(gray, cv2.CV_64F).var()
        if laplacian_var < 20.0:
            return False, "Виявлено розмиту проекцію (Passive Liveness Failed)"
        if laplacian_var > 5000.0:
            return False, "Виявлено піксельну сітку екрана (Moire Spoofing)"

        # 2. Пошук відблисків від екрана чи глянцю
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        _, s, v = cv2.split(hsv)
        glare_mask = (v > 250) & (s < 15)
        glare_ratio = np.sum(glare_mask) / (img.shape[0] * img.shape[1])

        if glare_ratio > 0.15:
            return False, "Виявлено екранний відблиск (Anti-Spoofing Triggered)"

        return True, "OK"
    except Exception as e:
        print(f"[LIVENESS ERROR] {e}")
        return False, "Помилка перевірки Liveness"



def calculate_cosine_similarity(v1, v2):
    dot_product = np.dot(v1, v2)
    norm_v1 = np.linalg.norm(v1)
    norm_v2 = np.linalg.norm(v2)
    if norm_v1 == 0 or norm_v2 == 0:
        return 0.0
    return float(dot_product / (norm_v1 * norm_v2))


def get_embedding(image_bytes):
    try:
        img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
        face_tensor = mtcnn(img)
        if face_tensor is None:
            return None

        with torch.no_grad():
            face_tensor = face_tensor.to(device)
            embedding = resnet(face_tensor.unsqueeze(0)).detach().cpu().numpy()[0]
        return embedding
    except Exception as e:
        print(f"[CRITICAL ERROR] Помилка нейромережі: {e}")
        return None


@app.route('/api/ai/compare', methods=['POST'])
def compare_faces():
    print("\n========== [PYTHON AI SERVICE] ОТРИМАНО ЗАПИТ НА ВЕРИФІКАЦІЮ ==========")

    if 'passport' not in request.files or 'selfie' not in request.files:
        print("[REJECT] У запиті відсутні файли 'passport' або 'selfie'")
        return jsonify({"verified": False, "error": "Відсутні файли passport або selfie"}), 400

    try:
        passport_file = request.files['passport'].read()
        selfie_file = request.files['selfie'].read()

        target_name = request.form.get('userName', '').strip()
        target_surname = request.form.get('userSurname', '').strip()

        # Перевірка наявності даних імені та прізвища
        print(f"[DEBUG] Отримано з фронтенду: Ім'я='{target_name}', Прізвище='{target_surname}'")
        if not target_name or not target_surname:
            print("[REJECT] Імена не надійшли на сервер.")
            return jsonify({"verified": False, "similarity": 0.0,
                            "error": "Системна помилка: ім'я або прізвище профілю відсутні!"}), 200

        # 0. Перевірка на два однакові файли (Spoofing)
        if passport_file == selfie_file:
            print("[SPOOFING] Виявлено два ідентичні файли.")
            return jsonify({
                "verified": False,
                "similarity": 0.0,
                "error": "Завантажено два ідентичні файли (Spoofing Blocked)"
            }), 200

        # 1. Етап Document Check
        doc_valid, doc_msg = validate_passport_document(passport_file, target_name, target_surname)
        if not doc_valid:
            print(f"[DOCUMENT REJECT] {doc_msg}")
            return jsonify({"verified": False, "similarity": 0.0, "error": doc_msg}), 200

        # 2. Етап Passive Liveness
        live_valid, live_msg = check_passive_liveness(selfie_file)
        if not live_valid:
            print(f"[LIVENESS REJECT] {live_msg}")
            return jsonify({"verified": False, "similarity": 0.0, "error": live_msg}), 200

        # 3. генерація біометричних векторів
        vector_passport = get_embedding(passport_file)
        vector_selfie = get_embedding(selfie_file)

        if vector_passport is None or vector_selfie is None:
            print("[REJECT -> JAVA] Обличчя не розпізнано.")
            return jsonify({
                "verified": False,
                "similarity": 0.0,
                "error": "Нейромережа не змогла розпізнати обличчя на одному з фото."
            }), 200

        # 4. обчислюємо схожість
        similarity = calculate_cosine_similarity(vector_passport, vector_selfie)
        print(f"[PYTHON AI] Обчислена косинусна схожість: {similarity:.4f}")

        # захист від завантаження дубліката (однакове фото з різним розміром/стисненням)
        if similarity > 0.98:
            print("[SPOOFING] Занадто висока схожість, це одне й те саме фото.")
            return jsonify({
                "verified": False,
                "similarity": round(similarity, 2),
                "error": "Анти-спуфінг: завантажено те саме фото замість живого селфі."
            }), 200

        threshold = 0.58
        is_verified = similarity >= threshold
        print(f"[PYTHON AI] Вердикт: Verified={is_verified}")

        # очищаємо RAM
        del passport_file, selfie_file

        return jsonify({
            "verified": bool(is_verified),
            "similarity": round(similarity, 2),
            "threshold": threshold,
            "error": "Обличчя не збігаються" if not is_verified else None
        }), 200

    except Exception as e:
        print(f"[SERVER ERROR] Загальний збій обробки: {str(e)}")
        return jsonify({"verified": False, "similarity": 0.0, "error": f"Внутрішня помилка: {str(e)}"}), 500


if __name__ == '__main__':
    print("Сервер ШІ успішно запущено локально!")
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)