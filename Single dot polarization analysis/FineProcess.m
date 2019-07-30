function sfit = FineProcess(ROI,axes_handle,SystemResponseFit,varargin)
	if nargin == 3
		StartPoint_phi_c = [pi/2,0.5];
	elseif nargin == 4
		StartPoint_phi_c = varargin{1};
	end
	
	axes(axes_handle)
	hold on;

	if ~isempty(SystemResponseFit)
		coefficients = coeffvalues(SystemResponseFit);
	end
	
	ROISeries = [];
	rotationSeries = [];
	for rotationIndex = 0:15
		len = length(ROISeries);
		ROISeries = horzcat(ROISeries,ROI{rotationIndex+1}(ROI{rotationIndex+1}>(max(ROI{rotationIndex+1})+min(ROI{rotationIndex+1}))/2));
		
		if ~isempty(SystemResponseFit)
			ROISeries = ROISeries*(coefficients(3)*cos(2*rotationIndex*22.5/180*pi+coefficients(2))+1);
		end

		len = length(ROISeries)-len;
		rotationSeries = horzcat(rotationSeries,ones(1,len)*(rotationIndex+1)*22.5/180*pi);
	end

	ft = fittype('A*(C*cos(2*r+phi)+1)','coefficients',{'A','phi','C'},'independent','r');
	fo = fitoptions('Method','NonlinearLeastSquares','StartPoint',[mean(ROISeries),StartPoint_phi_c(1),StartPoint_phi_c(2)],'Lower',[min(ROISeries),0,0],'Upper',[max(ROISeries),2*pi,1]);
	sfit = fit(rotationSeries',ROISeries',ft,fo)

	theta = linspace(0,2*pi,100);
	polarplot(theta,feval(sfit,theta));

	polarplot(rotationSeries,ROISeries,'LineStyle','none','Marker','.');

	hold off;
end