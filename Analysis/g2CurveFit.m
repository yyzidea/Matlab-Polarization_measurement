function sfit = g2CurveFit(Resolution,Count,EstiRiseTime,EstiZeroPoint,EstiInfCount)
	Delay = (1:length(Count))*Resolution;

	[M,I] = min(Count);
	EstiZeroPoint = Delay(I);
	EstiInfCount = mean(Count);
	EstiRiseTime = Delay(find(Count(I:end)>=EstiInfCount,1)+I-1)-EstiZeroPoint;

	if nargin > 2
		if mod(nargin) ~= 0
			error('Illegal pair arguments input!');
		end

		for i = 1:nargin-2
			switch varargin{i*2-1}
				case 'EstiRiseTime'
					EstiRiseTime = varargin{i*2};
				case 'EstiZeroPoint'
					EstiZeroPoint = varargin{i*2};
				case 'EstiInfCount'
					EstiInfCount = varargin{i*2};
				otherwise
					error('Illegal pair arguments input!');
			end
		end
	end

	fo = fitoptions('Method','NonlinearLeastSquares',...
			'Lower',[min(Count),-inf,0,0],...
			'Upper',[max(Count),1,100e-9,max(Delay)],...
			'StartPoint',[EstiInfCount,1-M/EstiInfCount,EstiRiseTime,EstiZeroPoint]);

	g2CurveFitType = fittype('C*(1-b*exp(-1/r*abs(t-delta_t)))','independent','t','options',fo,'coefficients',{'C','b','r','delta_t'});
	% g2CurveFitTypeLeft = fittype('a(1-b*exp(r1*t))(1-1*exp(r2*t))','independent','t','options',fo,'coefficients',{'a','b'},'problem',{'r1','r2'});
	sfit = fit(Delay',Count',g2CurveFitType);
	% g2CurveFitLeft = fit(Delay(ceil(length(Delay)/2):end)'*IntegeralTime,tempCount(ceil(length(Delay)/2):end)',g2CurveFitTypeLeft,'problem',{gamma_d,1/Lifetime+PumpRate});
end