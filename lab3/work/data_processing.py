# functions for loading and processing the data, ie extracting the wanted features

import numpy as np
import soundfile as sf

def get_features(data, Fs, frameDurationMs, frameOverlapMs, kHzFreqBands, bins):

    # data, Fs = sf.read(filename)
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
        if frameEnd >= dataLength:
            frameCount = i+1
            break
        frameDiff = frameEnd-frameStart
        frameArray[i,:] = data[frameStart:frameEnd]*hann

    fftFrequencies = np.fft.fftfreq(bins, 1/Fs)
    bandCount = max(kHzFreqBands.shape)

    frameBandEnergyRatios = np.zeros([frameCount, bandCount])

    for i in range(frameCount):
        frameDFT = np.fft.fft(frameArray[i,:], bins)
        totalEnergy = np.sum(np.power(np.abs(frameDFT[0:np.int(bins/2)]),2))

        binFreqRatio = (bins/Fs)
        binIndices = (kHzFreqBands*(binFreqRatio*1000)).astype(int)

        bandEnergyRatios = np.zeros(bandCount)

        for j in range(bandCount):
            start = binIndices[j, 0]
            end = binIndices[j, 1]
            bandEnergy = np.sum(np.power(np.abs(frameDFT[start:end]), 2))
            if totalEnergy == 0:
                bandEnergyRatios[j] = 0
            else:
                bandEnergyRatios[j] = bandEnergy/totalEnergy

        frameBandEnergyRatios[i, :] = bandEnergyRatios

    return np.mean(frameBandEnergyRatios, axis=0)
