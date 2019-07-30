% %% Generating the random orientation
% 	SampleNumber = 1000;
% 	SampleNumber = floor(SampleNumber/pi*6);
% 	x0 = rand(1,SampleNumber)*2-1;
% 	y0 = rand(1,SampleNumber)*2-1;
% 	z0 = rand(1,SampleNumber)*2-1;
% 	index = x0.^2+y0.^2+z0.^2<=1;
% 	x0 = x0(index);
% 	y0 = y0(index);
% 	z0 = z0(index);

% 	phiv = rand(1,length(x0))*2*pi;
% 	Excitation = 1/sqrt(2)*[1,1*exp(1i*pi/2)];

% 	SampleNumber = length(x0);

% 	aniso = zeros(3,SampleNumber);
% 	DipoleGeometry = [0,0,1;0.5,0.5,0;1/3,1/3,1/3]';
% 	at = cell2mat(arrayfun(@(x0,y0,z0,theta0) WavefunctionEnd([x0;y0;z0],theta0,[0;0;1]),x0,y0,z0,phiv,'UniformOutput',false));
% 	TitleArray = {'1D dipole','2D dipole','3D dipole'};

%% Main simulating routine.
	figure(1);
	clf(1);
	for j = 1:3
		% tic;
		% t0 = toc;
		% for i = 1:SampleNumber
		% 	aniso(j,i) = Anisotropy([x0(i);y0(i);z0(i)],phiv(i),DipoleGeometry(:,j),Excitation);
		% 	if mod(i,10) == 0
		% 		fprintf('Completed: %d/%d Elapse Time:%.2f/%.2f\n',i,SampleNumber,toc-t0,(toc-t0)/i*(SampleNumber-i));
		% 	end
		% end
		
		% Plotting results 
		subplot(2,3,j);
		histogram(aniso(j,:),linspace(-1,1,20));
		xlim([-1,1]);
		title(TitleArray{j});
		set(gca,'FontSize',14);

		subplot(2,3,3+j);
		plot3(at(1,:).*aniso(j,:),at(2,:).*aniso(j,:),at(3,:).*aniso(j,:),'o');
		fprintf('Completed: %s. Elapse Time:%.2f\n==========\n\n',TitleArray{j},toc-t0);
		axis equal;
		axis([-1,1,-1,1,-1,1]);
		set(gca,'FontSize',14);

	end

%% Estimate the distribution width change when the dipole geometry changes from 2D to 3D.
	% clength = horzcat(0.1:0.1:0.9,linspace(1,10,6));
	% AnisoStd = zeros(1,length(clength));

	% for j = 1:length(clength)
	% 	index = ceil(rand(1,100)*SampleNumber);
	% 	DipoleGeometry = [1,1,clength(j)]';
	% 	DipoleGeometry = DipoleGeometry/sum(DipoleGeometry);
	% 	temp = zeros(1,length(index));
	% 	tic;
	% 	t0 = toc;
	% 	for i = 1:length(index)
	% 		temp(i) = Anisotropy([x0(index(i));y0(index(i));z0(index(i))],phiv(index(i)),DipoleGeometry,Excitation);
	% 	end
	% 	AnisoStd(j) = std(temp);
	% 	fprintf('Completed: Geometry:1:1:%f Elapse Time:%.2f/%.2f\n',1/10*j,toc-t0,(toc-t0)*(10-j));
	% end

	figure(5);
	clf(5);
	box on;
	sfit1 = fit(horzcat(0,clength(1:10))',horzcat(std(aniso(2,:)),AnisoStd(1:10))'*2,'poly4');
	sfit2 = fit(clength(10:15)',AnisoStd(10:15)'*2,'poly4');
	
	plot(0:0.01:1,feval(sfit1,0:0.01:1),'k');
	hold on;
	plot(1:0.01:10,feval(sfit2,1:0.01:10),'k');
	plot(horzcat(0,clength),horzcat(std(aniso(2,:)),AnisoStd)*2,'o');
	ylim([0,0.6]);
	title('The relation between geometry ratio and anisotropy distribution width');
	set(gca,'FontSize',14);

