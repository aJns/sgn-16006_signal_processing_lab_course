# functions for loading and processing the data, ie extracting the wanted features

import numpy as np
import soundfile as sf

def get_features(filename):
    frameDurationMs = 30
    frameOverlapMs = 15
    data, Fs = sf.read(filename)

    frameLength = (frameDurationMs/1000)*Fs;
    frameOffset = (frameOverlapMs/1000)*Fs;

    hann = np.hanning()
    return filename

