# sgn-16006 lab course, lab3: Auditory Scene Recognition
# Jonas Nikula & Vili Saura
# 240497       & 240264

# lib imports
import matplotlib.pyplot as plt
import soundfile as sf
import numpy as np

# imports from other script files
import data_processing as dp




if __name__ == "__main__":

    filename = "signal.wav"
    frameDurationMs = 30
    frameOverlapMs = 15

    data, Fs = sf.read(filename)
    dataLength = data.size

    frameLength = np.int((frameDurationMs/1000)*Fs);
    frameOffset = np.int((frameOverlapMs/1000)*Fs);
    frameCount = np.int(np.floor(dataLength/(frameLength-frameOffset)))
    frameArray = np.zeros((frameCount, frameLength));
    hann = np.hanning(frameLength)

    frameStart = 0
    frameEnd = 0

    for i in range(frameCount):
        frameStart = max(frameEnd - frameOffset, 0)
        frameEnd = frameStart + frameLength
        if frameEnd >= dataLength: break
        frameDiff = frameEnd-frameStart
        frameArray[i,:] = data[frameStart:frameEnd]*hann
    
    plt.plot(frameArray[50,:])













