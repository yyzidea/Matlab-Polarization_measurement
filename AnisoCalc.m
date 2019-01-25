function [aniso,varargout] = AnisoCalc(I_1,I_2,varargin)
	R = I_1./I_2;

	if nargin == 3 && varargin{1}
		r = fzero(@(r) mean((r*R-1)./(r*R+1)),1);
		fprintf('The anisotropy distribution is calibrated by factor %.3f, corresponding to overall polarization degree: %.3f.\n',r,abs((r-1)/(r+1)));
	elseif nargin == 2
		r = 1;
	else
		error('Too many or too less input arguments!');
	end

	if nargout == 2
		varargout{1} = r;
	end

	aniso = (r*R-1)./(r*R+1);
end