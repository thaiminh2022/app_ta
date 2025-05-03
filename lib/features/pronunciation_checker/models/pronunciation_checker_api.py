from flask import Flask, request, jsonify
from flask_cors import CORS
from pronunciation_checker import fetch_example_sentences, similarity
import speech_recognition as sr

app = Flask(__name__)
CORS(app)

@app.route('/check_pronunciation', methods=['POST'])
def check_pronunciation():
    data = request.get_json()
    
    if 'target_text' in data and 'user_text' in data:
        # Compare target and user text
        accuracy = similarity(data['target_text'], data['user_text']) * 100
        return jsonify({
            'success': True,
            'accuracy': accuracy,
            'feedback': 'Good pronunciation' if accuracy > 70 else 'Keep practicing'
        })
    elif 'target_text' in data and 'audio_data' in data:
        try:
            recognizer = sr.Recognizer()
            audio_data = sr.AudioData(data['audio_data'])
            user_text = recognizer.recognize_google(audio_data)
            accuracy = similarity(data['target_text'], user_text) * 100
            return jsonify({
                'success': True,
                'accuracy': accuracy,
                'recognized_text': user_text,
                'feedback': 'Good pronunciation' if accuracy > 70 else 'Keep practicing'
            })
        except Exception as e:
            return jsonify({
                'success': False,
                'error': str(e)
            }), 400
    
    return jsonify({
        'success': False,
        'error': 'Invalid request data'
    }), 400

@app.route('/example_sentence', methods=['GET'])
def get_example_sentence():
    word = request.args.get('word')
    if not word:
        return jsonify({'error': 'Word parameter is required'}), 400
    
    sentences = fetch_example_sentences(word)
    if sentences:
        return jsonify({'sentence': sentences[0]})  # Return the first example sentence
    return jsonify({'error': 'No example sentences found'}), 404

if __name__ == '__main__':
    app.run(debug=True)
