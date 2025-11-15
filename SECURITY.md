# Security Policy

## Supported Versions

This project is a lightweight, portable, and security-focused environment for running `yt-dlp` inside an isolated Docker container.  
Only the latest version is officially supported.

| Version | Supported |
|---------|-----------|
| Latest  | ✅ Yes    |
| Older   | ❌ No     |

Once you update `Dockerfile`, rebuild the container to apply fixes:

```powershell
docker build -t yt-dlp-ultra .
```

---

## Reporting a Vulnerability

If you discover a potential security issue related to:

- Dockerfile configuration  
- Isolation parameters  
- Permission scoping  
- Dependency updates  
- Non-root execution  
- File-system exposure  
- Network exposure  

Please open a **GitHub Issue** with the label `security` or message me privately via GitHub.

When reporting:

1. Provide a clear description of the issue  
2. Include steps to reproduce  
3. Include any logs or outputs  
4. DO NOT include personal data or downloaded files  

All security concerns will be addressed with high priority.

---

## Container Isolation Model

This environment is intentionally designed to run yt-dlp **without access to the host system**.

### The Docker container enforces:

- ✔ Non-root user (`downloader`)
- ✔ Dropped Linux capabilities (`--cap-drop ALL`)
- ✔ No privilege escalation (`--security-opt no-new-privileges`)
- ✔ Memory limits (`--memory=512m`)
- ✔ Process limits (`--pids-limit 200`)
- ✔ Isolated network (`--network=bridge`)
- ✔ Single controlled bind mount (`C:\yt-dlp-downloads`)
- ✔ Ephemeral execution (`--rm` auto-cleanup)

### The container *cannot*:

- ❌ Write to any folder except the mounted `downloads` directory  
- ❌ Modify Windows registry  
- ❌ Access host files, Desktop, Documents, etc.  
- ❌ Persist data on the host  
- ❌ Gain system privileges  
- ❌ Read environment variables outside the container  
- ❌ Access host network directly  
- ❌ Run after the command finishes  

This sandboxed design dramatically minimizes risk, even if yt-dlp or ffmpeg contained a vulnerability.

---

## Recommended User Practices

To maintain a secure environment:

- Always rebuild the image for updates:
  ```powershell
  docker build -t yt-dlp-ultra .
  ```
- Do not mount sensitive folders into the container
- Keep Docker Desktop updated
- Prefer “Read Only” mounted folders unless writing is required
- Validate URLs before downloading
- Never store personal or private content inside this repository

---

## Dependency Updates

yt-dlp and ffmpeg versions get updated when the Docker image is rebuilt.  
To ensure security patches:

```powershell
cd C:\yt-dlp-ultra
docker build -t yt-dlp-ultra .
```

This pulls:

- Latest Python base image  
- Latest yt-dlp  
- Latest ffmpeg  
- Latest OS security patches from Debian Slim  

---

## Disclaimer

This project provides strong sandboxing, but **no security system is perfect**.  
Users are responsible for verifying URLs and complying with local laws.

If you find improvements or have concerns, please open a GitHub Issue.

