function output = ErrorAnalysis(DebugLog,varargin)
	output = zeros(1,length(DebugLog));

	for i = 1:length(DebugLog)
		ROI1 = DebugLog(i).ROI1;
		ROI2 = DebugLog(i).ROI2;

		result = vertcat((ROI1-ROI2)./(ROI1+ROI2),(ROI1+ROI2));

		result(:,result(2,:)<max(result(2,:)/2)) = [];

		m = mean(result(1,:));
		s = std(result(1,:));
		n = size(result,2);

		z = abs(icdf('T',0.025,n));
		output(i) = 2*s/sqrt(n)*z;

	end

	if nargin == 2
		figure(varargin{1});
		clf(varargin{1});
		plot(output);
	elseif nargin > 3
		error('Too many input arguments!');
	end

	% m = mean(output);
	% range = max(output)-min(output);
	% output(abs(output-m))
end