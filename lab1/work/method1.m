imSize = [1008 1018];
imType = 'int16';
filename = fullfile('data', 'image2.raw');

[R, G, B] = readimagefile(filename, imSize, imType);

close all;
figure;
subplot(1, 3, 1);
imshow(R);

subplot(1, 3, 2);
imshow(G);

subplot(1, 3, 3);
imshow(B);