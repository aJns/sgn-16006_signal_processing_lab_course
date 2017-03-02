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
processedImage = ppg_interpolation(R, G, B);
figure;
subplot(1, 2, 1); imshow(cat(3, R, G, B));
subplot(1, 2, 2); imshow(processedImage);
%% MSE and MAE
filename = fullfile('data', 'testikuva.tiff');
image = imread(filename);

imSize = [512 512];
imType = 'uint8';
filename = fullfile('data', 'testikuva.raw');

[R, G, B] = readimagefile(filename, imSize, imType);
processedImage = nn_interpolation(R, G, B);
processedImage2 = bilinear_interpolation(R, G, B);
processedImage3 = ppg_interpolation(R, G, B);
figure;
subplot(2, 3, 1); imshow(cat(3, R, G, B));
subplot(2, 2, 2); imshow(processedImage);
subplot(2, 2, 3); imshow(processedImage2);
subplot(2, 2, 4); imshow(processedImage3);

MSE1 = mean_square_error(image, processedImage);
MSE2 = mean_square_error(image, processedImage2);
MSE3 = mean_square_error(image, processedImage3);

MAE1 = mean_absolute_error(image, processedImage);
MAE2 = mean_absolute_error(image, processedImage2);
MAE3 = mean_absolute_error(image, processedImage3);

MSE=[MSE1; MSE2; MSE3];
MAE=[MAE1; MAE2;MAE3];
%% Tic toc
imSize = [1008 1018];
imType = 'uint8';
filename = fullfile('data', 'image2.raw');

[R, G, B] = readimagefile(filename, imSize, imType);
%%

tic
processedImage = nn_interpolation(R, G, B);
time1 = toc;

tic
processedImage2 = bilinear_interpolation(R, G, B);
time2 = toc;

tic
processedImage3 = ppg_interpolation(R, G, B);
time3 = toc;

Time =[time1; time2; time3];
%%
methods = { 'NN-interpolation', 'Bilinear interpolation', 'PPG interpolation'};
T = table(MSE, MAE, Time, 'RowNames', methods)