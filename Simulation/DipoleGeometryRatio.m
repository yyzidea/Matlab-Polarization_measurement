function r = DipoleGeometryRatio(StdWidth)
	if exist('AnisoStdFit.mat','file')
		load('AnisoStdFit.mat');
	else
		error('AnisoStdFit.mat doesn''t exist!');
	end

	if StdWidth == 0
		r = [1,1];
	else
		if StdWidth>feval(sfit1,0)
			r1 = -1;
			warning('The StdWidth is larger than that of dots with 2D dipole.');
		else
			r1 = fzero(@(a) feval(sfit1,a)-StdWidth,[0,1]);
		end
		if StdWidth>feval(sfit2,10)
			r2 = 10;
		else
			r2 = fzero(@(a) feval(sfit2,a)-StdWidth,[1,10]);
		end
		r = [r1,r2];
	end

end