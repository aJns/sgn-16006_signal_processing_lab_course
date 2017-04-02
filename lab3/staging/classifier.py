# sgn-16006 lab course, lab3: Auditory Scene Recognition
# Jonas Nikula & Vili Saura
# 240497       & 240264

import numpy as np
import scipy


class NearestNeighbor:

    def __init__(self, k):
        self.neighbors = k


    def train(self, data, labels):
        self.data = data
        self.labels = labels
        self.sampleCount = labels.size

    def predict(self, data):
        dataLength = data.shape[0]
        labels = np.zeros(dataLength)

        for i in range(dataLength):
            distances = np.zeros(self.labels.size)
            nearest = np.zeros(self.neighbors)
            for j in range(self.sampleCount):
                distance = self.distance(data[i, :], self.data[j])
                distances[j] = distance

            indices = np.argsort(distances, axis=0)
            indices = indices[0:self.neighbors]

            for counter, k in enumerate(indices):
                nearest[counter] = self.labels[k]

            temp = scipy.stats.mode(nearest)
            labels[i] = temp[0][0]

        return labels


    def distance(self, a, b):
        return np.sqrt(np.sum(np.power(a-b, 2)))













