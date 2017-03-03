function processedImage = nn_interpolation(rawImage)
R = rawImage(:, :, 1);
G = rawImage(:, :, 2);
B = rawImage(:, :, 3);

fullImage = zeros([size(R) 3]);

B(1:2:end, 2:2:end) = B(1:2:end, 1:2:end);
B(2:2:end, 1:2:end) = B(1:2:end, 1:2:end);
B(2:2:end, 2:2:end) = B(1:2:end, 1:2:end);

R(2:2:end, 1:2:end) = R(2:2:end, 2:2:end);
R(1:2:end, 1:2:end) = R(2:2:end, 2:2:end);
R(1:2:end, 2:2:end) = R(2:2:end, 2:2:end);

G(1:2:end, 1:2:end) = G(1:2:end, 2:2:end);
G(2:2:end, 2:2:end) = G(2:2:end, 1:2:end);

fullImage = cat(3, R, G, B);

processedImage = uint8(255*fullImage);