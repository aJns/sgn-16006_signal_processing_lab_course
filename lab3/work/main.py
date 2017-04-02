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

    bins = 1024
    kHzFreqBands = np.array([
        [0,   0.5],
        [0.5, 1],
        [1,   2],
        [2,   4]
        ])

    fftFrequencies = np.fft.fftfreq(bins, 1/Fs)

    frame50DFT = np.fft.fft(frameArray[50,:], bins)
    
    plt.figure()
    plt.plot(frameArray[50,:])

    plt.figure()
    plt.plot(fftFrequencies, np.abs(frame50DFT))

    totalEnergy = np.sum(np.power(np.abs(frame50DFT[0:np.int(bins/2)]),2))

    binFreqRatio = (bins/Fs)

    binIndices = (kHzFreqBands*(binFreqRatio*1000)).astype(int)

    bandCount = 4
    bandEnergyRatios = np.zeros(bandCount)

    for i in range(bandCount):
        start = binIndices[i, 0]
        end = binIndices[i, 1]
        bandEnergy = np.sum(np.power(np.abs(frame50DFT[start:end]), 2))
        bandEnergyRatios[i] = bandEnergy/totalEnergy

    plt.figure()
    plt.bar(range(4), bandEnergyRatios, tick_label=["0 - 0.5 kHz", "0.5 - 1 kHz", "1 - 2 kHz", "2 - 4 kHz"])












