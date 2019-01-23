function DistributionFit(Counts,SampleNumber,BinsNumber)
	syms theta phi theta0 b r x y z v phiv phi0;

	v = sym('v_',[3,1]);
	a = sym('a_',[3,1]);

	R_x(theta) = [1,0,0;0,cos(theta),-sin(theta);0,sin(theta),cos(theta)];
	R_y(theta) = [cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
	R_z(theta) = [cos(theta),-sin(theta),0;sin(theta),cos(theta),0;0,0,1];

	M(x,y,z,theta) = [cos(theta)+(1-cos(theta))*x^2, (1-cos(theta))*x*y-sin(theta)*z, (1-cos(theta))*x*z+sin(theta)*y;...
					  (1-cos(theta))*y*x+sin(theta)*z,cos(theta)+(1-cos(theta))*y^2,(1-cos(theta))*y*z-sin(theta)*x;...
					  (1-cos(theta))*z*x-sin(theta)*y,(1-cos(theta))*z*y+sin(theta)*x,cos(theta)+(1-cos(theta))*z^2];


	WaveFunctionStart = [a_1;a_2;a_3];
	WaveFunctionEndSym = M(x,y,z,theta0)*R_z(phi)*R_y(theta)*WaveFunctionStart;

	% WaveFunctionEndSym = R_z(r)*R_x(b)*R_z(a)*WaveFunctionStart;

	Anisotropy(a,b,r,a_1,a_2,a_3) = (WaveFunctionEnd(1)^2-WaveFunctionEnd(2)^2)/(WaveFunctionEnd(1)^2+WaveFunctionEnd(2)^2);

	tx = linspace(0,2*pi,SampleNumber+1);
	tx(end) = [];
	ty = linspace(0,2*pi,SampleNumber+1);
	ty(end) = [];
	tz = linspace(0,2*pi,SampleNumber+1);
	tz(end) = [];
	[X,Y,Z] = meshgrid(tx,ty,tz);

	fo = fitoptions('Method','NonlinearLeastSquares',...
			'Lower',[0,0,0],...
			'Upper',[1,1,1],...
			'StartPoint',[1/sqrt(3),1/sqrt(3),1/sqrt(3)]);

	g2CurveFitType = fittype('func(BinIndex,a_1,a_2,a_3))','independent','BinIndex','options',fo,'coefficients',{'a_1','a_2','a_3'});
	% g2CurveFitTypeLeft = fittype('a(1-b*exp(r1*t))(1-1*exp(r2*t))','independent','t','options',fo,'coefficients',{'a','b'},'problem',{'r1','r2'});
	sfit = fit(Delay',Count',g2CurveFitType);
	% g2CurveFitLeft = fit(Delay(ceil(length(Delay)/2):end)'*IntegeralTime,tempCount(ceil(length(Delay)/2):end)',g2CurveFitTypeLeft,'problem',{gamma_d,1/Lifetime+PumpRate});

	function count = func(BinIndex,a_1,a_2,a_3)
		N = histcounts(double(Anisotropy(X,Y,Z,a_1,a_2,a_3)));
		count = N(BinIndex);
	end

end

