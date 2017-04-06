# sgn-16006 lab course, lab3: Auditory Scene Recognition
# Jonas Nikula & Vili Saura
# 240497       & 240264

# lib imports
import matplotlib.pyplot as plt
import soundfile as sf
import numpy as np
import os
import scipy
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score

# imports from other script files
import data_processing as dp
from classifier import NearestNeighbor

# %%


if __name__ == "__main__":

    # %% Assigment 1
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

    frame50Index = 49
    frame50DFT = np.fft.fft(frameArray[frame50Index,:], bins)
    
    plt.figure()
    plt.plot(frameArray[frame50Index,:])

    plt.figure()
    plt.plot(fftFrequencies, np.abs(frame50DFT))

    totalEnergy = np.sum(np.power(np.abs(frame50DFT[0:np.int(bins/2)]),2))

    binFreqRatio = (bins/Fs)

    binIndices = (kHzFreqBands*(binFreqRatio*1000)).astype(int)

    bandCount = max(kHzFreqBands.shape)
    bandEnergyRatios = np.zeros(bandCount)

    for i in range(bandCount):
        start = binIndices[i, 0]
        end = binIndices[i, 1]
        bandEnergy = np.sum(np.power(np.abs(frame50DFT[start:end]), 2))
        bandEnergyRatios[i] = bandEnergy/totalEnergy

    plt.figure()
    plt.bar(range(bandCount), bandEnergyRatios, tick_label=["0 - 0.5 kHz", "0.5 - 1 kHz", "1 - 2 kHz", "2 - 4 kHz"])


    # %% Assigment 2
    frameDurationMs = 30
    frameOverlapMs = 15
    bins = 1024
    kHzFreqBands = np.array([
        [0,   0.5],
        [0.5, 1],
        [1,   2],
        [2,   4]
        ])


    dataDirectory = "noise_data"
    filenames = os.listdir(dataDirectory)
    sampleRate = 8000
    clipLengthS = 1
    clipLengthSamples = clipLengthS*sampleRate
    totalClipCount = 0
    
    for i, filename in enumerate(filenames):
        fullPath = dataDirectory + "/" + filename
        data, Fs = sf.read(fullPath)

        totalClipCount = totalClipCount + np.int(data.size/clipLengthSamples)

    clips = np.zeros([totalClipCount, clipLengthSamples])
    labels = np.zeros(totalClipCount)

    clipCounter = 0
    
    for i, filename in enumerate(filenames):
        fullPath = dataDirectory + "/" + filename
        data, Fs = sf.read(fullPath)

        clipCount = np.int(data.size/clipLengthSamples)

        for j in range(clipCount):
            start = j*clipLengthSamples
            end = start + clipLengthSamples
            clips[clipCounter, :] = data[start:end]
            labels[clipCounter] = i
            clipCounter = clipCounter + 1


    features = np.zeros([totalClipCount, max(kHzFreqBands.shape)])
    for i in range(clips.shape[0]):
        features[i,:] = dp.get_features(clips[i, :], sampleRate,
                frameDurationMs, frameOverlapMs, kHzFreqBands, bins)

    X_train, X_test, y_train, y_test = train_test_split(features, labels, test_size=0.20)

    # classification k=1
    k = 1
    clf = NearestNeighbor(k)
    clf.train(X_train, y_train)
    y_pred = clf.predict(X_test)

    conf_matrix = confusion_matrix(y_test, y_pred)
    # Show confusion matrix in a separate window
    plt.matshow(conf_matrix)
    # plt.title('Confusion matrix')
    plt.colorbar()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()

    print(accuracy_score(y_test, y_pred))


    # classification k=5
    k = 5
    clf = NearestNeighbor(k)
    clf.train(X_train, y_train)
    y_pred = clf.predict(X_test)

    conf_matrix = confusion_matrix(y_test, y_pred)

    # Show confusion matrix in a separate window
    plt.matshow(conf_matrix)
    # plt.title('Confusion matrix')
    plt.colorbar()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()

    print(accuracy_score(y_test, y_pred))
