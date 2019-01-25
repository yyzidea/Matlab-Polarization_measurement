function r = DipoleGeometryRatio(StdWidth)
	if exist('AnisoStdFit.mat','file')
		load('AnisoStdFit.mat');
	else
		error('AnisoStdFit.mat doesn''t exist!');
	end

	if StdWidth == 0
		r = [1,1];
	else
		r1 = fzero(@(a) feval(sfit1,a)-StdWidth,[0,1]);
		r2 = fzero(@(a) feval(sfit2,a)-StdWidth,[1,10]);
		r = [r1,r2];
	end

end