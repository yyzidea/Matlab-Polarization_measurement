function m = ThresholdMean(ROI)
	m = zeros(1,size(ROI,1));
	for i = 1:size(ROI,1)
		temp = ROI(i,:);
		temp(temp<max(temp)/2) = [];
		[N,edges] = histcounts(temp,10);
		[~,I] = max(N);
		if I == 1 || I == 10
			m(i) = mean(temp(temp>=edges(I)&temp<=edges(I+1)));
			warning(sprintf('Some unexpected data distribution was detected: i = %d,m = %f',i,m(i)));
			% figure(3);
			% histogram(temp);
			% keyboard;
		else
			m(i) = mean(temp(temp>=edges(I-1)&temp<=edges(I+2)));
		end
	end
	m(isnan(m)) = 0;
end