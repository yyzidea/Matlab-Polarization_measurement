load('data/2018_09/1_0.mat');

centers = FindPoints(data);

temp = QDPLTraceExtraction(data,centers);
