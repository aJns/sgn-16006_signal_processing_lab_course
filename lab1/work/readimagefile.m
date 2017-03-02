function [R, G, B] = readimagefile(filename, imSize, imType)

fileID = fopen(filename);
rawImage = fread(fileID, imSize, imType);
fclose(fileID);

normalizingDivider = 1;

if strcmp(imType, 'int16')
    normalizingDivider = 2^10 - 1;
end

if strcmp(imType, 'uint8')
    normalizingDivider = 2^8 - 1;
end

rawImage = rawImage ./ normalizingDivider;
rawImage = rawImage';
imSize = size(rawImage);

R = zeros(imSize);
G = zeros(imSize);
B = zeros(imSize);

R(2:2:end, 2:2:end) = rawImage(2:2:end, 2:2:end);
B(1:2:end, 1:2:end) = rawImage(1:2:end, 1:2:end);
G(2:2:end, 1:2:end) = rawImage(2:2:end, 1:2:end);
G(1:2:end, 2:2:end) = rawImage(1:2:end, 2:2:end);