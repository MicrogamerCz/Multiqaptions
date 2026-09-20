# Multiqaptions

Multiqaptions lets you translate subtitles from any media you play - whether it's in browser\*, locally-played, from a streaming app\* or even a game!

(\* - not likely to work with DRM-ed media)

The app records a window of your choice, OCR reads the area of the window you select (entire window by default) and translator module translates the read text into a language you (may or may not) understand.

## Modules

### OCR

| | Tesseract | RapidOCR | LLM |
| --- | --- | --- | --- |
| HW requirements\* | Very low | High | None |
| Output quality\*\* | Rarely recognizes characters | Very accurate, has issues with punctuation | Very accurate |
| Speed | Very fast | Fast | Unpredictable response latency |

*\* HW requirements apply only for local processing, but not local LLMs. Both can run on laptops, but RapidOCR manages ~1 FPS of text recognition*

*\*\* Heavily depends on used model and configuration, the default configuration is close to the backend defaults. LLMs using chat responses frequently hallucinate even with primitive text recognition tasks or otherwise are unable or returning only the correct text. More expensive models are likely to have larger latency and higher inference costs*

### Image processing (planned)

By default there is no image processing to improve OCR output

### Translation

| | Argos Translate | LLM (without memory) | LLM (with memory) |
| --- | --- | --- | --- |
| HW requirements\* | Very low | None | None |
| Speed | Very fast | Unpredictable response latency | Unpredictable response latency |
| Output quality\*\* | Pretty good | Accurate | Very accurate |

*\* HW requirements apply only for local processing, but not local LLMs*

*\*\* LLMs using chat responses frequently hallucinate even with primitive text recognition tasks or otherwise are unable or returning only the correct text. More expensive models or history are likely to have larger latency and higher inference costs*

## Running locally

```sh
python -m venv env/ # Optionally add '--use-system-site-packages' to avoid duplicate dependencies
source env/bin/activate # Change the suffix or name based on your shell to activate
pip install -r requirements.txt
python -m multiqaptions
```

## Dependencies

Python dependencies:
```
pyside6
```

System dependencies:
```
qt6-declarative
```

```sh
# Arch Linux
sudo pacman -S qt6-declarative
```
