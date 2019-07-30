load('data/2018_09/1_0.mat');

ROI_center = [368,317];

% Firstly, find a rough peak point. Then, uncomment this block to choose the peak position.
ROI_size = 10;

sumFrame = squeeze(sum(data));
ROI_center = FindPeak2D(sumFrame,ROI_center,ROI_size,ROI_size/2)

FrameShow(data,0,ROI_center);