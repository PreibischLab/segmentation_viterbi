% Label to contour gets a binary image (annotated image) of the nucleous contour
% it also gets sample - how ofter to sample the full contour in the returned contour
% returns Xs and Ys values of the contour in the label image

function nucContour = label2contour(labelImg, sample)

    % Find first contour pixel in nuc
    [tempX, tempY] = find(labelImg,1);
    % Trace the contour
    nucContour = bwtraceboundary(labelImg, [tempX tempY],'N');
    % Delete the last pixel in contour (since it's equal to first)
    nucContour = nucContour(1:end-1,:);

    % Sample the contour:
    nucContour = [nucContour(1:sample:end, 1), nucContour(1:sample:end, 2)];
    nucContour(end,:) = [];

end