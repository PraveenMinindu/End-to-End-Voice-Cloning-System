

# End-to-End Voice Conversion Platform with RVC & Flutter

## Project Overview

This project is a high-performance AI system designed to clone specific human vocal characteristics and apply them to any song or speech. Unlike simple scripts, this platform integrates a modern Flutter Web interface with a FastAPI backend and an RVC (Retrieval-based Voice Conversion) inference engine.

## Key Engineering Highlights

### End-to-End Integration

Built the complete pipeline from frontend to backend to AI model inference, ensuring seamless communication between all components.

### Hybrid Infrastructure

Connected a local Flutter environment with cloud-based GPU resources using Ngrok tunneling, enabling real-time interaction with remote AI services.

### Optimized Processing

Reduced voice transformation time from approximately 90 minutes (CPU-based processing) to around 15 minutes using NVIDIA T4/L4 GPU acceleration.

### Bypassing Intermediaries

Configured custom headers to manage CORS policies and Ngrok browser warnings, enabling a smooth and uninterrupted API workflow.

## System Architecture

The platform follows a multi-layer architecture:

### Client Layer (Flutter Web)

Provides an intuitive user interface for uploading audio files and receiving processed results.

### Tunneling Layer (Ngrok)

Exposes the private cloud-based backend to the public internet securely.

### Processing Layer (FastAPI & RVC)

* **Demucs**: Performs vocal and instrumental separation from input audio
* **RVC Engine**: Applies trained voice characteristics to the extracted vocal track

### Delivery Layer

Reconstructs the processed audio by merging cloned vocals with the original instrumental track and returns the final output to the user.

## Results and Demonstration

To validate the accuracy of the voice cloning system, the following outputs are generated:

* **Original Reference**: Voice samples used to train the model
* **Source Vocals**: Extracted vocals from the original song
* **Cloned Output**: Final audio where the song is rendered using the trained voice

 inputs and output--> assets/audio 

## Technical Stack

* **Frontend**: Flutter Web
* **Backend**: FastAPI (Python)
* **AI Models**: RVC (Retrieval-based Voice Conversion), Demucs
* **Infrastructure**: Google Colab (GPU), Ngrok, Firebase

## How It Works

1. **Model Training**
   A voice model is trained using selected voice samples.

2. **Vocal Extraction**
   The system separates vocals from background music using Demucs.

3. **Inference**
   The RVC model maps the target voice characteristics onto the extracted vocals.

4. **Merging**
   The transformed vocals are merged with the original instrumental track to produce the final output.

## Conclusion

The Full-Stack AI Voice Cloner demonstrates the practical application of deep learning in a production-oriented environment. It addresses real-world challenges such as network tunneling, large audio processing, and cross-platform system integration.

## Author

Developed by: Praveen Minindu 
              Sahan sandeepa



