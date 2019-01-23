function output = ErrorAnalysis(DebugLog,figure_handle)
	output = zeros(1,length(DebugLog));

	for i = 1:length(DebugLog)
		ROI1 = DebugLog(i).ROI1;
		ROI2 = DebugLog(i).ROI2;

		result = vertcat((ROI1-ROI2)./(ROI1+ROI2),(ROI1+ROI2));

		result(:,result(2,:)<max(result(2,:)/2)) = [];

		output(i) = mean(std(result(1,:)));
	end

	figure(figure_handle);
	clf(figure_handle);

	plot(output);
end