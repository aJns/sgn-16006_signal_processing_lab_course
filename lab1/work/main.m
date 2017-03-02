%% method1
imSize = [1008 1018];
imType = 'int16';
filename = fullfile('data', 'image2.raw');

[R, G, B] = readimagefile(filename, imSize, imType);
figure;
subplot(1, 2, 1); imshow(cat(3, R, G, B));
processedImage = nn_interpolation(R, G, B);
subplot(1, 2, 2); imshow(processedImage);

%% method2

%% method3