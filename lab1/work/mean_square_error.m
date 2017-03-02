function MSE = mean_square_error(realImage, compiledImage)

MSE = 0;
for i = 1:numel(realImage)
    MSE = MSE + (double(realImage(i)) - double(compiledImage(i)))^2;
end
MSE = MSE/i;
    
end