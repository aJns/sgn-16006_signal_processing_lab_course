function processedImage = bilinear_interpolation(rawImage)
R = rawImage(:, :, 1);
G = rawImage(:, :, 2);
B = rawImage(:, :, 3);

%Added zeros to fill the "missing" pixels
Rpad = padarray(R, [1 1]);
Gpad = padarray(G, [1 1]);
Bpad = padarray(B, [1 1]);
fullImage = zeros([size(R) 3]);

%Notice that padding adds 2 rows and 2 columns,
%so Gpad(2,2) corresponds to G(1,1)
%Same thing happens with all color channels

%Green computations
%Both even and odd rows compute the green value the same way, but their column
%indexes start from different points
for i = 2:size(Gpad,1)-1
    %Even rows
    if(mod(i,2)== 0)
    for a = 2:2:size(Gpad,2)-1
        G(i-1,a-1) = (Gpad(i,a+1)+Gpad(i,a-1)+ Gpad(i-1,a)+Gpad(i+1,a))/4;
    end
    %Odd rows
    else
     for b = 3:2:size(Gpad,2)-1
        G(i-1,b-1) = (Gpad(i,b+1)+Gpad(i,b-1)+ Gpad(i-1,b)+Gpad(i+1,b))/4;
     end
    end
end

%Blue computations
for i = 2:size(Bpad,1)-1
    %Even rows compute the value from 2 other values
    if(mod(i,2)== 0)
        for a = 3:2:size(Bpad,2)-1
            B(i-1,a-1) = (Bpad(i,a+1)+Bpad(i,a-1))/2;
        end
    %Odd rows compute the value from 2 or 4 other values, depending on the
    %column index
    else
         for b = 2:2:size(Bpad,2)-1
             B(i-1,b-1) = (Bpad(i+1,b)+Bpad(i-1,b))/2;
         end
        for c = 3:2:size(Bpad,2)-1
            B(i-1,c-1) = (Bpad(i+1,c+1)+Bpad(i+1,c-1)+Bpad(i-1,c+1)+Bpad(i-1,c-1))/4;
        end
    end
end

%Red computations
%Similar to blue computations, but the rows are exchanged, i.e. Even rows
%use different functions depending on the column index and odd rows compute
%the value from 2 other values
for i = 2:size(Rpad,1)-1
    if(mod(i,2)== 0)
        for a = 2:2:size(Rpad,2)-1
            R(i-1,a-1) = (Rpad(i+1,a+1)+Rpad(i+1,a-1)+Rpad(i-1,a+1)+Rpad(i-1,a-1))/4;
         end
        for b = 3:2:size(Rpad,2)-1
           R(i-1,b-1) = (Rpad(i+1,b)+Rpad(i-1,b))/2;
        end
    else
       for c = 2:2:size(Rpad,2)-1
            R(i-1,c-1) = (Rpad(i,c+1)+Rpad(i,c-1))/2;
        end
    end
end

fullImage(:, :, 1) = R;
fullImage(:, :, 2) = G;
fullImage(:, :, 3) = B;

processedImage = uint8(255*fullImage);
