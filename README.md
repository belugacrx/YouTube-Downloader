YouTube Downloader (Batch Script)
A simple and user-friendly YouTube downloader batch script for Windows. Download videos, audio, or specific clips quickly and easily with customizable options.
________________________________________
Features
•	Basic Mode: Quick download in best available quality.
•	Advanced Mode:
o	Single video download
o	Multiple videos from a file (links.txt)
o	Resume last download
•	Video/audio options: Video only, Audio only (MP3), Combined (video + audio
•	Partial downloads: Download specific sections of a video
•	Custom download folder
•	Automatic merging of video + audio
•	Retry support for interrupted downloads
________________________________________

Requirements
•	Windows OS
•	yt-dlp.exe in the same folder as the script
•	ffmpeg.exe in a folder named ffmpeg\bin inside the script folder

Tip: Place both executables in the same folder as the script for portability.

________________________________________

Usage:

1.	Clone or download this repository.
2.	Ensure yt-dlp.exe and ffmpeg.exe are in the same folder.
3.	Run YouTubeDownloader.bat.
4.	Follow the menu to choose Basic or Advanced mode.
5.	Enter URLs and options as prompted.
________________________________________

Partial Downloads:

When prompted for a specific part:
- Enter start and end times in hh:mm:ss format
- Example: 00:00:10 to 00:00:30
________________________________________

Multi-Video Download
•	Place YouTube links in links.txt (one URL per line).
•	Choose the multi-video download option in Advanced Mode.
________________________________________


Notes
•	Default download folder is %USERPROFILE%\Downloads.
•	Last download info is saved in last_download.txt for easy resuming.
________________________________________

Author Beluga (macrocortex@gmail.com)
