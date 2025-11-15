FROM python:3.12-slim

# Install yt-dlp safely
RUN pip install --no-cache-dir yt-dlp

# Install ffmpeg safely (needed for best quality)
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user for safety
RUN useradd -m downloader
USER downloader

# Set working directory
WORKDIR /home/downloader

# Create internal downloads folder
RUN mkdir downloads
WORKDIR /home/downloader/downloads

# Default command
CMD ["yt-dlp", "--version"]
