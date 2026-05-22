import numpy as np
from flask import Flask, request, jsonify
from facenet_pytorch import MTCNN, InceptionResnetV1
from PIL import Image
import io

app = Flask(__name__)

# Ініціалізуємо MTCNN (пошук облич) та FaceNet (генерація векторів)
# Модель автоматично завантажить переднавчені ваги при першому запуску
mtcnn = MTCNN(image_size=160, margin=20)
resnet = InceptionResnetV1(pretrained='vggface2').eval()

def calculate_cosine_similarity(v1, v2):
    """
    ТВОЯ МАТЕМАТИЧНА ФУНКЦІЯ ПОРІВНЯННЯ ВЕКТОРІВ
    Формула косинусної схожості: (A * B) / (||A|| * ||B||)
    """
    dot_product = np.dot(v1, v2)
    norm_v1 = np.linalg.norm(v1)
    norm_v2 = np.linalg.norm(v2)
    return float(dot_product / (norm_v1 * norm_v2))

def get_embedding(image_bytes):
    try:
        img = Image.open(io.BytesIO(image_bytes)).convert('RGB')

        # Крок 1: MTCNN вирізає обличчя з фотокартки
        face_tensor = mtcnn(img)
        if face_tensor is None:
            return None

        # Крок 2: FaceNet перетворює обличчя на вектор з 512 чисел
        embedding = resnet(face_tensor.unsqueeze(0)).detach().numpy()[0]
        return embedding
    except Exception as e:
        print(f"Помилка обробки: {e}")
        return None

@app.route('/api/ai/compare', methods=['POST'])
def compare_faces():
    print("\n========== [PYTHON AI SERVICE] ОТРИМАНО ЗАПИТ НА ВЕРИФІКАЦІЮ ==========")

    if 'passport' not in request.files or 'selfie' not in request.files:
        return jsonify({"error": "Відсутні файли passport або selfie"}), 400

    passport_file = request.files['passport'].read()
    selfie_file = request.files['selfie'].read()

    # Генерація біометричних векторів
    vector_passport = get_embedding(passport_file)
    vector_selfie = get_embedding(selfie_file)

    if vector_passport is None or vector_selfie is None:
        return jsonify({
            "verified": False,
            "error": "Нейромережа не змогла розпізнати обличчя на фото."
        }), 200

    # Обчислюємо схожість через авторську функцію
    similarity = calculate_cosine_similarity(vector_passport, vector_selfie)
    print(f"[PYTHON AI] Обчислена косинусна схожість: {similarity:.4f}")

    # Твій авторський поріг чутливості
    threshold = 0.75
    is_verified = similarity >= threshold

    return jsonify({
        "verified": is_verified,
        "similarity": round(similarity, 2),
        "threshold": threshold
    })

if __name__ == '__main__':
    print("Сервер ШІ запускається на http://localhost:5000")
    app.run(host='0.0.0.0', port=5000, debug=False)