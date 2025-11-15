# yt-dlp-ultra  
### Ultra-Secure yt-dlp Setup Using Docker (Windows 11)

This project provides a **fully isolated**, **high-security**, **zero-risk** environment for running `yt-dlp` on Windows.  
Everything runs inside a locked-down Docker container with **no access** to your system, registry, or files — only a single download folder.

This setup is ideal if you:
- Don’t want to trust unknown binaries  
- Want maximum sandboxing  
- Use multiple devices and want a portable setup  
- Want instant rebuilding and isolation on every run  

---

## 📁 Folder Structure

You need **two** folders:

### 1️⃣ Docker workspace (this repository)
Contains:
- `Dockerfile`
- `yt.bat`
- `README.md`

Example:
```
C:\yt-dlp-ultra
```

### 2️⃣ Download output folder (NOT in repo)
Create manually on each device:

```
C:\yt-dlp-downloads
```

This is the **only folder the container can write to**.

---

## 🛠 Requirements

- Windows 11  
- Docker Desktop installed  
- Docker running  
- (Optional but recommended) WSL2 backend enabled  

---

## 🧱 Building the Docker Image

Open PowerShell:

```powershell
cd C:\yt-dlp-ultra
docker build -t yt-dlp-ultra .
```

This builds a secure container with:
- Python 3.12 slim (official)
- yt-dlp (via pip from official repo)
- ffmpeg (from Debian repo)
- A non-root user (`downloader`)
- Minimal attack surface  

Rebuild when you want the latest yt-dlp/ffmpeg.

---

## ⚡ yt.bat — Easy Command Wrapper

Place this file in the same folder as the Dockerfile:

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

### 🔐 Security Features

| Option | Protection |
|-------|------------|
| `--rm` | Auto-delete container after use |
| `--security-opt no-new-privileges` | No privilege escalation allowed |
| `--cap-drop ALL` | Removes all Linux capabilities |
| `--pids-limit 200` | Prevents fork-bomb attacks |
| `--network=bridge` | Container isolated from host |
| `--memory=512m` | Memory abuse protection |
| `-v …` | ONLY allows writing to downloads folder |

This is maximum isolation.

---

## 🚀 How to Use

### ▶ Option A — Run from inside the folder:
```powershell
cd C:\yt-dlp-ultra
.\yt "https://www.youtube.com/watch?v=VIDEO_ID"
```

### ▶ Option B — Run from anywhere:
```powershell
"C:\yt-dlp-ultra\yt.bat" "https://www.youtube.com/watch?v=VIDEO_ID"
```

Downloads always appear in:

```
C:\yt-dlp-downloads
```

---

## 🎧 Common Commands

### Best video+audio:
```powershell
.\yt "https://www.youtube.com/watch?v=VIDEO_ID"
```

### MP3 audio:
```powershell
.\yt -x --audio-format mp3 "https://www.youtube.com/watch?v=VIDEO_ID"
```

### WAV audio:
```powershell
.\yt -x --audio-format wav "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Custom filename:
```powershell
.\yt -o "myfile.%(ext)s" "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Playlist:
```powershell
.\yt --yes-playlist "PLAYLIST_URL"
```

---

## 🔄 Updating yt-dlp / ffmpeg

Rebuild the image:

```powershell
cd C:\yt-dlp-ultra
docker build -t yt-dlp-ultra .
```

This fetches the latest versions automatically.

---

## 🗑 Cleaning / Removing Everything

### Remove Docker image:
```powershell
docker image rm yt-dlp-ultra
```

### Remove local folders:
```powershell
Remove-Item -Recurse -Force C:\yt-dlp-ultra
Remove-Item -Recurse -Force C:\yt-dlp-downloads
```

---

## 🧰 Troubleshooting

### ❗ `yt-dlp-ultra` not found  
You forgot to build the image:

```powershell
cd C:\yt-dlp-ultra
docker build -t yt-dlp-ultra .
```

### ❗ PowerShell: `yt is not recognized`  
Use:
```powershell
.\yt ...
```
or full path:
```powershell
"C:\yt-dlp-ultra\yt.bat" ...
```

### ❗ Downloads not appearing  
Ensure this exists:
```
C:\yt-dlp-downloads
```

---

## ✅ Done  
You now have a fully portable, ultra-secure yt-dlp environment you can use on **any device** via your GitHub repo.

