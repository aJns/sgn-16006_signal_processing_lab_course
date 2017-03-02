function MAE = mean_absolute_error(realImage, compiledImage)

MAE = 0;
for i = 1:numel(realImage)
    MAE = MAE + abs(double(realImage(i)) - double(compiledImage(i)));
end
MAE = MAE/i;


end