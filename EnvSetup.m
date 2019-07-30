function EnvSetup(flag)
	if flag
		addpath(genpath(pwd));
	else
		rmpath(genpath(pwd));
	end
end