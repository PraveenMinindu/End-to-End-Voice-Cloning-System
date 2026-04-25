import os
import shutil

# TODO: replace with real Applio import later
# from applio import infer

MODEL_NAME = "myvoice"

def clone_voice_model(voice_path, song_path, output_path, pitch):
    print(" Running voice cloning...")

    #  TEMP (until we integrate Applio properly)
    shutil.copy(song_path, output_path)

    print(" Done")