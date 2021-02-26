% This function runs tha viterbi with a starting point of the previous contour
% Then sets the new contour that will be propagated to the next layer
% And saves a binary image of the resulted segmentation

function beginPropagate(inputNum, inputPath, startSlice, direction, contour, sizeImg, lambda, normLength, m, sample, outputDirPath)

    for sliceNum= (startSlice+direction): direction: (startSlice+((startSlice-1)*direction))
    % the first slice is the slice closest to the middle (annotated slice)
    % the last slice is either 1 or the last slice

        if (size(contour,1) > 4)

            img = imread(inputPath, sliceNum);

            % run viterbi:
            % to find best match to the nucs in this slice
            % starting location of contour is the contour from the previous slice
            
            [Xs, Ys] = addNormThenViterbi(img, contour, lambda, normLength, m);
            contour = resampleContour(size(img), Xs, Ys, sample);
            
            % Save slice image:
            polyg = double(poly2mask(Ys, Xs, sizeImg(1), sizeImg(2)));
            imwrite(polyg, [outputDirPath 'vit_' inputNum '_' num2str(sliceNum) '.tif']);
            
        end
    end
end