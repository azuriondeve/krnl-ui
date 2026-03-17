set name=bootstrapper-%RANDOM%
pyinstaller --onefile --icon=NONE --name %name% app.py
