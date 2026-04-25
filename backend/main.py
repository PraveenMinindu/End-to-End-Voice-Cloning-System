from fastapi import FastAPI, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse, FileResponse
import shutil
import os

# model.py එකෙන් function එක ගෙන්වා ගැනීම
from model import clone_voice_model

app = FastAPI()

# 1. CORS Update: Flutter Web සඳහා මෙය අනිවාර්යයි
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"], 
)

# Folder සකස් කිරීම
os.makedirs("uploads", exist_ok=True)
os.makedirs("outputs", exist_ok=True)

# Static files mount කිරීම
app.mount("/outputs", StaticFiles(directory="outputs"), name="outputs")

# ngrok මගින් ලැබෙන URL එක ගබඩා කිරීමට
PUBLIC_URL = "https://written-crave-chop.ngrok-free.dev"

@app.post("/clone/")
async def clone_voice(
    voice: UploadFile = File(...),
    song: UploadFile = File(...),
    pitch: int = Form(0),
):
    try:
        voice_path = f"uploads/{voice.filename}"
        song_path = f"uploads/{song.filename}"
        
        # Audio file එක play වීමට පහසු වන සේ නම සරල කිරීම
        output_filename = "final_output.wav"
        output_path = f"outputs/{output_filename}"

        # Upload වන files save කිරීම
        with open(voice_path, "wb") as f:
            shutil.copyfileobj(voice.file, f)

        with open(song_path, "wb") as f:
            shutil.copyfileobj(song.file, f)

        # 2. RVC Model Processing
        # ඔබේ model.py එකේ තිබෙන function එක මෙතැනදී ක්‍රියාත්මක වේ
        clone_voice_model(voice_path, song_path, output_path, pitch)

        # 3. FIX: සම්පූර්ණ URL එක සකස් කිරීම
        # මෙතැනදී /outputs/folder එක හරහා file එකට access ලබා දේ
        final_url = f"{PUBLIC_URL}/outputs/{output_filename}?ngrok-skip-browser-warning=true"

        return {
            "status": "success",
            "outputUrl": final_url
        }

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"status": "error", "message": str(e)}
        )

# Audio එක කෙලින්ම download කර ගැනීමට අවශ්‍ය නම් මෙම endpoint එක භාවිතා කළ හැක
@app.get("/download")
async def download_output():
    file_path = "outputs/final_output.wav"
    if os.path.exists(file_path):
        return FileResponse(path=file_path, filename="cloned_voice.wav", media_type='audio/wav')
    return JSONResponse(status_code=404, content={"message": "File not found"})