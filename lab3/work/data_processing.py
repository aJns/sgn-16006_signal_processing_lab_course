# functions for loading and processing the data, ie extracting the wanted features

import numpy as np
import soundfile as sf

def get_features(filename):
    frameLength = 30
    frameOverlap = 15
    data, Fs = sf.read(filename)
    return filename

