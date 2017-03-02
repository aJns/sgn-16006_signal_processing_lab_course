%% method1
imSize = [1008 1018];
imType = 'int16';
filename = fullfile('data', 'image2.raw');

[R, G, B] = readimagefile(filename, imSize, imType);
figure;
subplot(1, 3, 1); imshow(cat(3, R, G, B));
processedImage = nn_interpolation(R, G, B);
subplot(1, 3, 2); imshow(processedImage);

%% method2
processedImage2 = bilinear_interpolation(R, G, B);
subplot(1, 3, 3); imshow(processedImage2);


%% method3