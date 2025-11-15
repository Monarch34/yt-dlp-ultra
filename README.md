# yt-dlp-ultra (Safe Docker Setup for Windows 11)

This is a fully isolated, hardened setup for using yt-dlp on Windows 11. Everything runs inside a locked-down Docker container so yt-dlp cannot access your system, files, registry, or network outside one folder. This README explains every step, how to use it, how to update it, and how to delete everything safely.

---

## 1. Folder Structure (Create These)

You need two folders:

### 1. Docker workspace (contains Dockerfile, yt.bat, README)
```
C:\yt-dlp-safe
```

### 2. Download output (only place container can write)
```
C:\yt-dlp-downloads
```

Everything yt-dlp downloads goes here. It cannot access anything else.

---

## 2. Requirements

- Windows 11  
- Docker Desktop installed  
- Docker Desktop running  
- Recommended: WSL2 backend enabled  

---

## 3. Build the Docker Image

Open **PowerShell** and run:

```powershell
cd C:\yt-dlp-safe
docker build -t yt-dlp-ultra .
```

This creates a container environment with:

- Python 3.12 slim (official)  
- yt-dlp (installed via pip from official source)  
- ffmpeg (from Debian repo)  
- Non-root user named `downloader`  

Rebuild only when you want updates.

---

## 4. yt.bat (Shortcut Command)

Create a file named `yt.bat` inside `C:\yt-dlp-safe`:

```bat
@echo off
docker run --rm ^
  --security-opt no-new-privileges ^
  --cap-drop ALL ^
  --pids-limit 200 ^
  --network=bridge ^
  --memory=512m ^
  -v "C:\yt-dlp-downloads:/home/downloader/downloads:rw" ^
  yt-dlp-ultra yt-dlp %*
```

### Security Flags Explained

- `--rm` → container deletes itself after use  
- `--security-opt no-new-privileges` → blocks privilege escalation  
- `--cap-drop ALL` → removes all Linux kernel capabilities  
- `--pids-limit 200` → prevents fork bombs  
- `--network=bridge` → isolates network access  
- `--memory=512m` → prevents memory abuse  
- `-v ...` → ONLY allows writing to `C:\yt-dlp-downloads`  

This setup ensures maximum isolation.

---

## 5. How to Use (Actual Commands)

### 5.1. Run from inside the folder

```powershell
cd C:\yt-dlp-safe
.\yt "https://www.youtube.com/watch?v=VIDEO_ID"
```

### 5.2. Run from anywhere using full path

```powershell
"C:\yt-dlp-safe\yt.bat" "https://www.youtube.com/watch?v=VIDEO_ID"
```

All downloaded files appear in:

```
C:\yt-dlp-downloads
```

---

## 6. Common Examples

### Download best video+audio
```powershell
.\yt "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Download MP3 audio
```powershell
.\yt -x --audio-format mp3 "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Download WAV audio
```powershell
.\yt -x --audio-format wav "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Custom filename
```powershell
.\yt -o "myfile.%(ext)s" "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Download playlist
```powershell
.\yt --yes-playlist "PLAYLIST_URL"
```

---

## 7. Updating yt-dlp & ffmpeg

Just rebuild:

```powershell
cd C:\yt-dlp-safe
docker build -t yt-dlp-ultra .
```

This fetches the latest Python, yt-dlp, and ffmpeg.

---

## 8. Deleting / Cleaning Everything

### Delete Docker image:
```powershell
docker image rm yt-dlp-ultra
```

### Delete folders:
```powershell
Remove-Item -Recurse -Force C:\yt-dlp-safe
Remove-Item -Recurse -Force C:\yt-dlp-downloads
```

Everything is now erased safely.

---

## 9. Troubleshooting

### "yt-dlp-ultra not found"
You forgot to build:

```powershell
cd C:\yt-dlp-safe
docker build -t yt-dlp-ultra .
```

### "yt is not recognized" in PowerShell
Use:

```powershell
.\yt ...
```

or full path:

```powershell
"C:\yt-dlp-safe\yt.bat" ...
```

### Downloads not appearing?
Check that this folder exists:

```
C:\yt-dlp-downloads
```

---

## DONE 🎉  
You now have the safest possible yt-dlp setup on Windows 11 — fully isolated, secure, and simple to use.
