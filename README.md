# KRNL UI Bootstrapper

![GitHub repo size](https://img.shields.io/github/repo-size/azuriondeve/krnl-ui)
![GitHub stars](https://img.shields.io/github/stars/azuriondeve/krnl-ui?style=social)
![GitHub forks](https://img.shields.io/github/forks/azuriondeve/krnl-ui?style=social)
![GitHub issues](https://img.shields.io/github/issues/azuriondeve/krnl-ui)
![GitHub license](https://img.shields.io/github/license/azuriondeve/krnl-ui)
![Latest release](https://img.shields.io/github/v/release/azuriondeve/krnl-ui)
![Downloads](https://img.shields.io/github/downloads/azuriondeve/krnl-ui/total)
![Windows](https://img.shields.io/badge/platform-Windows-blue)
![Made with](https://img.shields.io/badge/made%20with-Python-yellow)

---

## ✨ Features

- 🔍 Automatically detects the latest GitHub release
- 📦 Downloads the newest version (`bootstrapper.exe`)
- ⚡ Fast and lightweight
- 🔄 Always up-to-date
- 🛠 Minimal setup required

---

## 🚀 How It Works

1. Connects to the GitHub API  
2. Fetches latest release data  
3. Parses version/tag info  
4. Finds `bootstrapper.exe`  
5. Downloads and executes it  

---

## 📥 API Endpoint Used


[https://api.github.com/repos/azuriondeve/krnl-ui/releases/latest](https://api.github.com/repos/azuriondeve/krnl-ui/releases/latest)


---

## 🧠 Auto Detection

The bootstrapper extracts:

- `tag_name` → latest version  
- `assets[]` → release files  
- `browser_download_url` → direct download  

---

## 📂 Execution Flow

```

Start
↓
Request GitHub API
↓
Parse latest release
↓
Find bootstrapper.exe
↓
Download file
↓
Execute

```

---

## ⚙️ Requirements

- Windows OS  
- Internet connection  
- Execution permissions  

---

## 🔐 Security

Only downloads from the official repository:

https://github.com/azuriondeve/krnl-ui

---

## 📌 Notes

- Requires a valid release with assets  
- File name must match `bootstrapper.exe`  
- Stops if no release is found  
- Network issues may interrupt process  

---

## ⭐ Support

If you like this project, consider giving it a star!
