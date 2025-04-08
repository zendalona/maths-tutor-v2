import os
import time
import signal
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

MAIN_SCRIPT = "main.py"
process = None  # Track the running process

def start_app():
    global process
    if process:
        process.terminate()
        process.wait()  # Ensure it's fully stopped before restarting
    process = subprocess.Popen(["python3", MAIN_SCRIPT])  # Start a new process

class QMLReloadHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith(".qml"):
            print(f"{event.src_path} changed. Restarting app...")
            start_app()

if __name__ == "__main__":
    print("Watching all QML files for changes...")
    event_handler = QMLReloadHandler()
    observer = Observer()
    observer.schedule(event_handler, ".", recursive=True)  # Watch all files
    observer.start()

    try:
        start_app()  # Start app initially
        while True:
            time.sleep(1)
    except KeyboardInterrupt: #currenlty ctrl+c is used to stop the script
        print("\nStopping observer and killing app...")
        observer.stop()
        if process:
            process.terminate()
            process.wait()  # Ensure process is killed
    observer.join()
