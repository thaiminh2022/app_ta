import speech_recognition as sr
import requests
from bs4 import BeautifulSoup
from difflib import SequenceMatcher
from colorama import init, Fore, Style

# Khởi tạo colorama
init()

def fetch_example_sentences(word):
    """Lấy các câu ví dụ từ Cambridge Dictionary cho một từ"""
    url = f"https://dictionary.cambridge.org/dictionary/english/{word}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, "html.parser")
        examples = soup.find_all("span", class_="eg")
        sentences = [example.get_text().strip() for example in examples]
        
        # Lọc câu ngắn gọn (3-10 từ)
        sentences = [s for s in sentences if 3 <= len(s.split()) <= 10]
        
        if not sentences:
            print(Fore.YELLOW + f"Không tìm thấy câu ví dụ cho từ '{word}'." + Style.RESET_ALL)
            return []
        
        return sentences  # Trả về danh sách các câu ví dụ
    except requests.RequestException as e:
        print(Fore.RED + f"Lỗi khi lấy dữ liệu từ Cambridge Dictionary: {e}" + Style.RESET_ALL)
        return []

def similarity(a, b):
    """Tính tỷ lệ tương đồng giữa hai chuỗi văn bản"""
    return SequenceMatcher(None, a.lower(), b.lower()).ratio()

def get_color(accuracy):
    """Trả về màu dựa trên độ chính xác"""
    if accuracy < 33:
        return Fore.RED
    elif accuracy <= 70:
        return Fore.YELLOW
    else:
        return Fore.GREEN

def check_pronunciation(target_text):
    """Kiểm tra phát âm và hiển thị độ chính xác từng từ"""
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        print("Hãy đọc câu: ", target_text)
        recognizer.adjust_for_ambient_noise(source)
        audio = recognizer.listen(source, timeout=5)
    
    try:
        user_text = recognizer.recognize_google(audio, language="en-US")
        print("Bạn đã nói: ", user_text)
        
        target_words = target_text.split()
        user_words = user_text.split()
        
        print("\nĐộ chính xác từng từ:")
        for i in range(min(len(target_words), len(user_words))):
            word_accuracy = similarity(target_words[i], user_words[i]) * 100
            color = get_color(word_accuracy)
            print(f"Từ '{target_words[i]}': {color}{word_accuracy:.2f}%{Style.RESET_ALL}")
        
        if len(user_words) < len(target_words):
            print(Fore.RED + "Bạn nói thiếu từ!" + Style.RESET_ALL)
        elif len(user_words) > len(target_words):
            print(Fore.YELLOW + "Bạn nói thừa từ!" + Style.RESET_ALL)
        
        return True
    
    except sr.UnknownValueError:
        print(Fore.RED + "Không nhận diện được giọng nói. Vui lòng thử lại." + Style.RESET_ALL)
        return False
    except sr.RequestError:
        print(Fore.RED + "Lỗi kết nối với dịch vụ nhận diện giọng nói." + Style.RESET_ALL)
        return False

def main():
    """Hàm chính để chạy chương trình"""
    word = input("Nhập từ để lấy câu ví dụ từ Cambridge Dictionary: ").strip()
    if not word:
        print(Fore.RED + "Vui lòng nhập một từ!" + Style.RESET_ALL)
        return
    
    # Lấy các câu ví dụ
    example_sentences = fetch_example_sentences(word)
    
    if not example_sentences:
        print(Fore.RED + "Không thể lấy câu ví dụ. Vui lòng thử lại sau." + Style.RESET_ALL)
        return
    
    print(Fore.GREEN + "Các câu ví dụ được tìm thấy:" + Style.RESET_ALL)
    for idx, sentence in enumerate(example_sentences, start=1):
        print(f"{idx}. {sentence}")
    
    while True:
        try:
            choice = int(input("\nNhập số thứ tự câu để kiểm tra phát âm (0 để thoát): "))
            if choice == 0:
                print(Fore.CYAN + "Thoát chương trình." + Style.RESET_ALL)
                break
            if 1 <= choice <= len(example_sentences):
                target_sentence = example_sentences[choice - 1]
                print(Fore.GREEN + f"Kiểm tra phát âm cho câu: {target_sentence}" + Style.RESET_ALL)
                check_pronunciation(target_sentence)
            else:
                print(Fore.RED + "Lựa chọn không hợp lệ. Vui lòng thử lại." + Style.RESET_ALL)
        except ValueError:
            print(Fore.RED + "Vui lòng nhập một số hợp lệ." + Style.RESET_ALL)

# Chạy chương trình
if __name__ == "__main__":
    main()
