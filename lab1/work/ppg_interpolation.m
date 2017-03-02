function processedImage = ppg_interpolation(R, G, B)
beforeR = R;
beforeG = G;
beforeB = B;

pad = 2;
imgSize = size(R);

padR = zeros([imgSize(1)+2*pad imgSize(2)+2*pad]);
padG = zeros([imgSize(1)+2*pad imgSize(2)+2*pad]);
padB = zeros([imgSize(1)+2*pad imgSize(2)+2*pad]);

padR(1+pad:end-pad, 1+pad:end-pad) = R;
padG(1+pad:end-pad, 1+pad:end-pad) = G;
padB(1+pad:end-pad, 1+pad:end-pad) = B;

inputR = zeros(2*pad+1);
inputG = zeros(2*pad+1);
inputB = zeros(2*pad+1);
inputRB = zeros(2*pad+1);

result = 0;
resultB = 0;
resultR = 0;
        
% green computations
for i = 1+pad:imgSize(1)+pad
    for j = 1+pad:imgSize(2)+pad
        
        if mod(i-pad,2) && mod(j-pad,2)
            % both odd == blue
            inputRB = padB(i-pad:i+pad, j-pad:j+pad);
        elseif ~mod(i-pad,2) && ~mod(j-pad,2)
            % both even == red
            inputRB = padR(i-pad:i+pad, j-pad:j+pad);
        else
            % one even, other odd == green, skip
            continue;
        end
        inputG = padG(i-pad:i+pad, j-pad:j+pad);
        
        dN = abs(inputRB(3, 3)-inputRB(1, 3))*2 + abs(inputG(2, 3)-inputG(4, 3));
        dE = abs(inputRB(3, 3)-inputRB(3, 5))*2 + abs(inputG(3, 2)-inputG(3, 4));
        dW = abs(inputRB(3, 3)-inputRB(3, 1))*2 + abs(inputG(3, 2)-inputG(3, 4));
        dS = abs(inputRB(3, 3)-inputRB(5, 3))*2 + abs(inputG(2, 3)-inputG(4, 3));
        
        switch min([dN dE dW dS])
            case dN
                result = (inputG(2, 3)*3 + inputG(4, 3) + inputRB(3, 3) - inputRB(1, 3))/4;
            case dE
                result = (inputG(3, 4)*3 + inputG(3, 2) + inputRB(3, 3) - inputRB(3, 5))/4;
            case dW
                result = (inputG(3, 2)*3 + inputG(3, 4) + inputRB(3, 3) - inputRB(3, 1))/4;
            case dS
                result = (inputG(4, 3)*3 + inputG(2, 3) + inputRB(3, 3) - inputRB(5, 3))/4;
        end
        
        % computing done, set the computed values
        G(i-pad, j-pad) = result;
    end
end
padG(1+pad:end-pad, 1+pad:end-pad) = G;

% red and blue computations
for i = 1+pad:imgSize(1)+pad
    for j = 1+pad:imgSize(2)+pad
        inputR = padR(i-pad:i+pad, j-pad:j+pad);
        inputG = padG(i-pad:i+pad, j-pad:j+pad);
        inputB = padB(i-pad:i+pad, j-pad:j+pad);
        
        if mod(i-pad,2) && mod(j-pad,2)
            % both odd == blue
            reds = abs(inputR(2,4)-inputR(4,2));
            blues = abs(inputB(1,5)-inputB(3,3)) + abs(inputB(3,3)-inputB(5,1));
            greens = abs(inputG(2,4)-inputG(3,3)) + abs(inputG(3,3)-inputG(4,2));
            dNE = reds + blues + greens;
            
            reds = abs(inputR(2,2)-inputR(4,4));
            blues = abs(inputB(1,1)-inputB(3,3)) + abs(inputB(3,3)-inputB(5,5));
            greens = abs(inputG(2,2)-inputG(3,3)) + abs(inputG(3,3)-inputG(4,4));
            dNW = reds + blues + greens;
            
            if dNE < dNW
                R(i-pad, j-pad) = hue_transit(inputG(2, 4), inputG(3, 3), inputG(4, 2), inputR(2, 4), inputR(4, 2));
            else
                R(i-pad, j-pad) = hue_transit(inputG(2, 2), inputG(3, 3), inputG(4, 4), inputR(2, 2), inputR(4, 4));
            end
        elseif ~mod(i-pad,2) && ~mod(j-pad,2)
            % both even == red
            blues = abs(inputB(2,4)-inputB(4,2));
            reds = abs(inputR(1,5)-inputR(3,3)) + abs(inputR(3,3)-inputR(5,1));
            greens = abs(inputG(2,4)-inputG(3,3)) + abs(inputG(3,3)-inputG(4,2));
            dNE = reds + blues + greens;
            
            blues = abs(inputB(2,2)-inputB(4,4));
            reds = abs(inputR(1,1)-inputR(3,3)) + abs(inputR(3,3)-inputR(5,5));
            greens = abs(inputG(2,2)-inputG(3,3)) + abs(inputG(3,3)-inputG(4,4));
            dNW = reds + blues + greens;
            
            if dNE < dNW
                B(i-pad, j-pad) = hue_transit(inputG(2, 4), inputG(3, 3), inputG(4, 2), inputB(2, 4), inputB(4, 2));
            else
                B(i-pad, j-pad) = hue_transit(inputG(2, 2), inputG(3, 3), inputG(4, 4), inputB(2, 2), inputB(4, 4));
            end
        else
            % one even, other odd == green
            if mod(i-pad,2)
                % row odd => col even == blue vertically, red horizontally
                resultB = hue_transit(inputG(3, 2), inputG(3, 3), inputG(3, 4), inputB(3, 2), inputB(3, 4));
                resultR = hue_transit(inputG(2, 3), inputG(3, 3), inputG(4, 3), inputR(2, 3), inputR(4, 3));
            else
                % row even => col odd == blue horizontally, red vertically
                resultR = hue_transit(inputG(3, 2), inputG(3, 3), inputG(3, 4), inputR(3, 2), inputR(3, 4));
                resultB = hue_transit(inputG(2, 3), inputG(3, 3), inputG(4, 3), inputB(2, 3), inputB(4, 3));
            end
            R(i-pad, j-pad) = resultR;
            B(i-pad, j-pad) = resultB;
        end
    end
end

function result = hue_transit(l1, l2, l3, v1, v3)
    if (l1 < l2 && l2 < l3) || (l1 > l2 && l2 > l3)
        result = v1 + (v3 - v1) * (l2 - l1)/(l3 - l1);
    else
        result = (v1 + v3)/2 + (l2*2 - l1 - l3)/4;
    end
end

fullImage = cat(3, R, G, B);

processedImage = uint8(255*fullImage);
end