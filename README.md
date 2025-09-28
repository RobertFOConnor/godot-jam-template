# Godot Jam Template

A lightweight template project for quickly starting game jam entries with Godot 4.  
It comes with common essentials already set up so you can focus on making the game.

---

## Features

- **Main Menu**
  - Start Game
  - Settings
  - Quit to Desktop

- **Settings Screen**
  - Audio volume control
  - V-Sync toggle
  - Resolution / fullscreen options (if supported)

- **Pause Menu**
  - Resume
  - Settings (in-game)
  - Quit to Main Menu

## Subtitles with Audacity Labels

You can use **Audacity** to create subtitles/timing data for dialogue lines:

1. Open your audio file in Audacity.  
2. Press `Ctrl+B` (or `⌘B` on Mac) to insert a **label track** and mark subtitle start points.  
3. Type the text of each subtitle in the labels.  
4. When finished, go to **File → Export → Export Labels…**  
   - Save the `.txt` file in the **same directory** as the audio file.  
   - Use the **same base filename** as the audio (e.g. `voice.ogg` → `voice.txt`).  
