import numpy as np
from flask import Flask, request, jsonify
import torch
from facenet_pytorch import MTCNN, InceptionResnetV1
from PIL import Image
import io

app = Flask(__name__)

#  (якщо є відеокарта — використовуємо її, інакше CPU)
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print(f"[INFO] Використовується девайс для ШІ: {device}")

# Ініціалізуємо моделі на правильному девайсі
mtcnn = MTCNN(image_size=160, margin=20, device=device)
resnet = InceptionResnetV1(pretrained='vggface2').eval().to(device)

def calculate_cosine_similarity(v1, v2):
    """
    Формула косинусної схожості: (A * B) / (||A|| * ||B||)
    """
    dot_product = np.dot(v1, v2)
    norm_v1 = np.linalg.norm(v1)
    norm_v2 = np.linalg.norm(v2)

    if norm_v1 == 0 or norm_v2 == 0:
        return 0.0

    return float(dot_product / (norm_v1 * norm_v2))

def get_embedding(image_bytes):
    try:
        # Безпечно відкриваємо зображення
        img = Image.open(io.BytesIO(image_bytes)).convert('RGB')

        # Крок 1: MTCNN детектує та вирізає обличчя
        face_tensor = mtcnn(img)
        if face_tensor is None:
            print("[WEB-WARNING] Обличчя на фотокартці не знайдено.")
            return None

        # Крок 2: Переносимо тензор на девайс і генеруємо вектор (embedding)
        # Використовуємо torch.no_grad(), щоб не накопичувати градієнти і не забивати пам'ять
        with torch.no_grad():
            face_tensor = face_tensor.to(device)
            embedding = resnet(face_tensor.unsqueeze(0)).detach().cpu().numpy()[0]

        return embedding
    except Exception as e:
        print(f"[CRITICAL ERROR] Помилка обробки нейромережею: {e}")
        return None

@app.route('/api/ai/compare', methods=['POST'])
def compare_faces():
    print("\n========== [PYTHON AI SERVICE] ОТРИМАНО ЗАПИТ НА ВЕРИФІКАЦІЮ ==========")

    if 'passport' not in request.files or 'selfie' not in request.files:
        print("[REJECT] У запиті відсутні Multipart ключі 'passport' або 'selfie'")
        return jsonify({"error": "Відсутні файли passport або selfie"}), 400

    try:
        passport_file = request.files['passport'].read()
        selfie_file = request.files['selfie'].read()

        # Генерація біометричних векторів
        vector_passport = get_embedding(passport_file)
        vector_selfie = get_embedding(selfie_file)

        if vector_passport is None or vector_selfie is None:
            print("[REJECT -> JAVA] Не вдалося згенерувати вектори (обличчя не розпізнано).")
            return jsonify({
                "verified": False,
                "similarity": 0.0,
                "error": "Нейромережа не змогла розпізнати обличчя на одному з фото."
            }), 200

        # Обчислюємо схожість
        similarity = calculate_cosine_similarity(vector_passport, vector_selfie)
        print(f"[PYTHON AI] Обчислена косинусна схожість: {similarity:.4f}")

        # Оптимальний емпіричний поріг для моделі FaceNet (vggface2)
        threshold = 0.58
        is_verified = similarity >= threshold
        print(f"[PYTHON AI] Вердикт: Verified={is_verified} (Поріг: {threshold})")

        return jsonify({
            "verified": is_verified,
            "similarity": round(similarity, 2),
            "threshold": threshold
        }), 200

    except Exception as e:
        print(f"[SERVER ERROR] Загальний збій обробки запиту: {str(e)}")
        return jsonify({"verified": False, "similarity": 0.0, "error": str(e)}), 500

if __name__ == '__main__':
    print("Сервер ШІ успішно запущено локально!")
    # Запускаємо threaded=True, щоб Flask міг обробляти запити паралельно від Heroku
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)