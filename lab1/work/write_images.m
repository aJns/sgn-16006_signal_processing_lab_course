run main.m;

%%
imgPath = fullfile('..', 'report', 'images');

nnCrop2 = nnImage2(corner2:corner2+areaSize, corner2:corner2+areaSize, :);
blCrop2  = blImage2(corner2:corner2+areaSize, corner2:corner2+areaSize, :);
ppgCrop2 = ppgImage2(corner2:corner2+areaSize, corner2:corner2+areaSize, :);

nnCrop5 =   nnImage5(corner5:corner5+areaSize, corner5:corner5+areaSize, :);
blCrop5 =   blImage5(corner5:corner5+areaSize, corner5:corner5+areaSize, :);
ppgCrop5 = ppgImage5(corner5:corner5+areaSize, corner5:corner5+areaSize, :);

nnCropTest =   nnTestImage(cornerT:cornerT+areaSize, cornerT:cornerT+areaSize, :);
blCropTest =   blTestImage(cornerT:cornerT+areaSize, cornerT:cornerT+areaSize, :);
ppgCropTest = ppgTestImage(cornerT:cornerT+areaSize, cornerT:cornerT+areaSize, :);

imwrite(nnCrop2, fullfile(imgPath, 'nnCrop2.png'));
imwrite(blCrop2, fullfile(imgPath, 'blCrop2.png'));
imwrite(ppgCrop2, fullfile(imgPath, 'ppgCrop2.png'));

imwrite(nnCrop5, fullfile(imgPath, 'nnCrop5.png'));
imwrite(blCrop5, fullfile(imgPath, 'blCrop5.png'));
imwrite(ppgCrop5, fullfile(imgPath, 'ppgCrop5.png'));

imwrite(nnCropTest, fullfile(imgPath, 'nnCropTest.png'));
imwrite(blCropTest, fullfile(imgPath, 'blCropTest.png'));
imwrite(ppgCropTest, fullfile(imgPath, 'ppgCropTest.png'));
