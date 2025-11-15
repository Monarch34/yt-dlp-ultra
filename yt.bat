@echo off
docker run --rm ^
  --security-opt no-new-privileges ^
  --cap-drop ALL ^
  --pids-limit 200 ^
  --network=bridge ^
  --memory=512m ^
  -v "C:\yt-dlp-downloads:/home/downloader/downloads:rw" ^
  yt-dlp-ultra yt-dlp %*
