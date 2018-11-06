function [deviation,varargout] = PointTrace(centers1,centers2,offset)
	PointMatrixRowLen = max(vertcat(centers1(:,1),centers2(:,1)))+offset;
	PointMatrixColLen = max(vertcat(centers1(:,2),centers2(:,2)))+offset;

	PointMatrix1 = zeros(PointMatrixRowLen,PointMatrixColLen);
	PointMatrix2 = PointMatrix1;

	PointMatrix1 = MultiElementsAssign(PointMatrix1,centers1,1);
	PointMatrix2 = MultiElementsAssign(PointMatrix2,centers2,1);

	PointMatrix1 = conv2(PointMatrix1,ones(offset),'same');
	PointMatrix2 = conv2(PointMatrix2,ones(offset),'same');

	C = xcorr2(PointMatrix1,PointMatrix2);

	[Row,Col] = find(C == max(max(C)),1);

	deviation = -([Row,Col] - [size(PointMatrix1,1),size(PointMatrix1,2)]);

	if nargout == 2
		varargout{1} = [];
		for i = 1:size(centers1,1)
			err = centers2 - repmat(centers1(i,:)+deviation,[size(centers2,1),1]);
			k = find(abs(err(:,1))<=offset/2&abs(err(:,2))<=offset/2);
			if ~isempty(k)
				varargout{1}(end+1,:) = [i,k];
			end
		end
	end
end