%% method1
imSize = [1008 1018];
imType = 'int16';
filename = fullfile('data', 'image5.raw');

[R, G, B] = readimagefile(filename, imSize, imType);
close all;
figure;
subplot(1, 3, 1); imshow(cat(3, R, G, B));
processedImage = nn_interpolation(R, G, B);
subplot(1, 3, 2); imshow(processedImage);

%% method2
processedImage2 = bilinear_interpolation(R, G, B);
subplot(1, 3, 3); imshow(processedImage2);


%% method3
imSize = [1008 1018];
imType = 'int16';
filename = fullfile('data', 'image5.raw');

[R, G, B] = readimagefile(filename, imSize, imType);
close all;
figure;
subplot(1, 2, 1); imshow(cat(3, R, G, B));
processedImage = ppg_interpolation(R, G, B);
subplot(1, 2, 2); imshow(processedImage);