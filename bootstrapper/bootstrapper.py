import os
import requests
import pyzipper
import shutil
import subprocess


REPO_API = "https://api.github.com/repos/azuriondeve/krnl-ui/releases/latest"

def kill_processes():
    log("Checking for running processes...")

    targets = ["krnl.exe", "Decompiler.exe", "VelocityAPI-Tauri.exe", "erto3e4rortoergn.exe"]

    for proc in targets:
        try:
            subprocess.run(
                ["taskkill", "/f", "/im", proc],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            log(f"Killed {proc} (if running)")
        except:
            pass

def log(msg):
    print(f"[BOOTSTRAPPER] {msg}")

def cleanup():
    kill_processes()

    if os.path.exists("krnl.exe"):
        log("Removing old krnl.exe...")
        os.remove("krnl.exe")

    if os.path.exists("Bin"):
        log("Removing old Bin folder...")
        shutil.rmtree("Bin", ignore_errors=True)

def get_latest_release():
    log("Checking for latest release...")
    r = requests.get(REPO_API, headers={"User-Agent": "python"})
    data = r.json()

    for asset in data["assets"]:
        if asset["name"].lower() == "krnl.zip":
            log(f"Latest version: {data['tag_name']}")
            return asset["browser_download_url"], asset["name"]

    log("ERROR: krnl.zip not found")
    return None, None

def download(url, filename):
    log("Downloading krnl.zip...")

    with requests.get(url, stream=True) as r:
        total = int(r.headers.get("content-length", 0))
        downloaded = 0
        start_time = time.time()

        with open(filename, "wb") as f:
            for chunk in r.iter_content(8192):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)

                    # MB conversion
                    downloaded_mb = downloaded / (1024 * 1024)
                    total_mb = total / (1024 * 1024) if total else 0

                    # speed
                    elapsed = time.time() - start_time
                    speed = downloaded / elapsed if elapsed > 0 else 0  # bytes/sec

                    # ETA
                    if total and speed > 0:
                        remaining = total - downloaded
                        eta = remaining / speed
                    else:
                        eta = 0

                    eta_str = time.strftime("%M:%S", time.gmtime(eta))

                    print(
                        f"\r[BOOTSTRAPPER] {downloaded_mb:.2f}/{total_mb:.2f} MB | ETA: {eta_str}",
                        end=""
                    )

    print("\n[BOOTSTRAPPER] Download complete")

def extract(zip_path):
    log("Preparing update...")

    # remove antigos ANTES de extrair
    cleanup()

    log("Extracting files...")

    try:
        with pyzipper.AESZipFile(zip_path) as z:
            z.pwd = b"puthereprealpassword"
            z.extractall()

        log("Replacing files...")
        log("Extracting DLLs...")
        log("Extracting injector...")
        log("Finalizing setup...")

        os.remove(zip_path)
        log("Cleaning up...")

        log("Update complete. Ready.")
    except Exception as e:
        log("ERROR: Extraction failed")
        print(e)

def main():
    url, name = get_latest_release()
    if not url:
        return

    download(url, name)
    extract(name)

if __name__ == "__main__":
    main()
