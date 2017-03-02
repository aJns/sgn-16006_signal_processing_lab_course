function processedImage = nn_interpolation(R, G, B)

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