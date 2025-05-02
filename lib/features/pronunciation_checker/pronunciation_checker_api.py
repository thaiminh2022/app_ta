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
    elif 'target_text' in data:
        # Single text check
        # Add your pronunciation check logic here
        return jsonify({'success': True})

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
