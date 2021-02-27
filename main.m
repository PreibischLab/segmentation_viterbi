%% mainSnake
% Script that sets the parameters
% and iterates over all stack images through all of their slices, while propagating the contour
% The amount of imput stacks are the total of nuclei 2d annotations. 
% meaning that if a nucleous was annotated in 3 slices there will be 3 stacks of it:
% each stack with the 11th slice as an annotation to start the propagation from.
% each input stack is 21 slices - where the 1st, 11th, and 21st are annotated.
% The propagation happens from middle slice to both directions: a. 11th to 1st b. 11th to 21st

clc;    % Clear the command window.
clear; % Clear workspace variables.
close all;  % Close all figures

% Parameters:
% Contour sample defines.. well, the sample frequency of the contour curve
sample = 4;
% How many points are on the norm:
m = 10;
% norm length
normLength = 5;
% lambda defines the normalization in DP minimazation between curvature and and pixal intensity
lambda = 0.7;
% Start propagation plane:
% Should be 11 as this is the annotated one:
startSlice = 11;

% input images dir:
dirPath = 'data/';
% output images dir:
outputDirPath = 'data/viterbi/';


% Get all input images:
% The images are the results of a RF classifier (pixel-wise) to detect the edges of the nuclei
% Each image belongs to one classifier and prediction
% Each 3D image is the 10 before and 10 after slices of a manually segmented 2D contour
imgsPaths=dir([dirPath 'pred*.tif']);
imgsNames = {imgsPaths(:).name};
inputNums = cellfun(@(x) x(6:end-4),imgsNames,'UniformOutput',false);

% Iterate over all input stacks:
for i=1:length(inputNums)

	inputNum = inputNums{i}

	inputPath = ['data/pred_' inputNum '.tif'];

	img = imread(inputPath, startSlice);
	% imshow(img1);impixelinfo;

	% The manually annotated contour is on the 11th slice:
	% The rest are empty (besides 1st and 21st) as they are not annotated
	contourImg = imread(['data/GT_contour_' inputNum '.tif'], startSlice);
	% imshow(img2);impixelinfo;

	% get  contour indecies:
	contour = label2contour(contourImg, sample);
	% 
	% % Plot image with contour overlay:
	% figure;imshow(img2,[]);hold on;
	% plot(contour(:,2),contour(:,1),'--*');

	sizeImg = size(img);

	% Begin propagating back:
	beginPropagate(inputNum, inputPath, startSlice, -1, contour, sizeImg, lambda, normLength, m, sample, outputDirPath);
	% Begin propagating forward:
	beginPropagate(inputNum, inputPath, startSlice, 1, contour, sizeImg, lambda, normLength, m, sample, outputDirPath);

end