%% setup

% load raw image files
dataFolder = '.';
imSize = [1008 1018];
imType = 'int16';

filename = fullfile(dataFolder, 'image2.raw');
[R, G, B] = readimagefile(filename, imSize, imType);
rawImage2 = cat(3, R, G, B);

filename = fullfile(dataFolder, 'image5.raw');
[R, G, B] = readimagefile(filename, imSize, imType);
rawImage5 = cat(3, R, G, B);


imSize = [512 512];
imType = 'uint8';
filename = fullfile(dataFolder, 'testikuva.raw');
[R, G, B] = readimagefile(filename, imSize, imType);
rawTestImage = cat(3, R, G, B);

% ground truth image
filename = fullfile(dataFolder, 'testikuva.tiff');
groundTruthImage = imread(filename);

computingTimes = [];
MSE = [];
MAE = [];

%% method1
tic
nnImage2 = nn_interpolation(rawImage2);
computingTimes(1) = toc;
nnImage5 = nn_interpolation(rawImage5);
nnTestImage = nn_interpolation(rawTestImage);

%% method2
tic
blImage2 = bilinear_interpolation(rawImage2);
computingTimes(2) = toc;
blImage5 = bilinear_interpolation(rawImage5);
blTestImage = bilinear_interpolation(rawTestImage);


%% method3
tic
ppgImage2 = ppg_interpolation(rawImage2);
computingTimes(3) = toc;
ppgImage5 = ppg_interpolation(rawImage5);
ppgTestImage = ppg_interpolation(rawTestImage);

%% MSE and MAE
MSE(1) = mean_square_error(groundTruthImage, nnTestImage);
MSE(2) = mean_square_error(groundTruthImage, blTestImage);
MSE(3) = mean_square_error(groundTruthImage, ppgTestImage);

MAE(1) = mean_absolute_error(groundTruthImage, nnTestImage);
MAE(2) = mean_absolute_error(groundTruthImage, blTestImage);
MAE(3) = mean_absolute_error(groundTruthImage, ppgTestImage);

%% Visualizations
close all;
corner2 = 450;
corner5 = 100;
cornerT = 200;
areaSize = 100;

figure;
h(1) = subplot(3, 3, 1); imshow(nnImage2(corner2:corner2+areaSize, corner2:corner2+areaSize, :));
h(2) = subplot(3, 3, 2); imshow(blImage2(corner2:corner2+areaSize, corner2:corner2+areaSize, :));
h(3) = subplot(3, 3, 3); imshow(ppgImage2(corner2:corner2+areaSize, corner2:corner2+areaSize, :));

h(4) = subplot(3, 3, 4); imshow(nnImage5(corner5:corner5+areaSize, corner5:corner5+areaSize, :));
h(5) = subplot(3, 3, 5); imshow(blImage5(corner5:corner5+areaSize, corner5:corner5+areaSize, :));
h(6) = subplot(3, 3, 6); imshow(ppgImage5(corner5:corner5+areaSize, corner5:corner5+areaSize, :));

h(7) = subplot(3, 3, 7); imshow(nnTestImage(cornerT:cornerT+areaSize, cornerT:cornerT+areaSize, :));
h(8) = subplot(3, 3, 8); imshow(blTestImage(cornerT:cornerT+areaSize, cornerT:cornerT+areaSize, :));
h(9) = subplot(3, 3, 9); imshow(ppgTestImage(cornerT:cornerT+areaSize, cornerT:cornerT+areaSize, :));

linkaxes(h, 'xy');


methods = { 'NN-interpolation', 'Bilinear interpolation', 'PPG interpolation' };
metrics = { 'MSE', 'MAE', 'ComputingTimes' };
resultsTable = table(MSE', MAE', computingTimes', 'RowNames', methods, 'VariableNames', metrics);









