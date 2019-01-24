% Plot_AnisoAnalysis(ROI1,ROI2,6);
% bins = linspace(-1,1,10);
% psd_1D = @(A) 1./(pi*sqrt(1-A.^2));


% A = -1:0.01:1;
% phi = rand(1,60000)*2*pi;

% subplot(2,1,1);
% plot(A,-2/pi*(0.5*acos(A)-0.5*acos(-1)));

% subplot(2,1,2);
% ylim([-1,1]);
% yyaxis left;
% histogram(cos(2*phi),bins);
% hold on;

% yyaxis right;
% plot(A,feval(psd_1D,A));

% p_bins = zeros(1,length(bins)-1);
% for i = 1:length(p_bins)
% 	p_bins(i) = integral(psd_1D,bins(i),bins(i+1));
% end

% A = (1-tan(phi).^2)/(1+tan(phi).^2+2*tan(phi));

%%%%%% Block1 %%%%%%
	figure(7);
	clf(7);
	% SampleNumber = floor(1000/pi*6);
	% x0 = rand(1,SampleNumber)*2-1;
	% % x0(end) = [];
	% y0 = rand(1,SampleNumber)*2-1;
	% % y0(end) = [];
	% z0 = rand(1,SampleNumber)*2-1;
	% % z0(end) = [];
	% % [Y,Z] = meshgrid(y0,z0);
	% index = x0.^2+y0.^2+z0.^2<=1;
	% x0 = x0(index);
	% y0 = y0(index);
	% z0 = z0(index);

	% phi1 = rand(1,1000)*2*pi;
	% theta1 = rand(1,1000)*pi;
	% x1 = cos(phi1).*sin(theta1);
	% y1 = sin(phi1).*sin(theta1);
	% z1 = cos(theta1);
	% phiv1 = rand(1,length(x1))*2*pi;


	% phiv = rand(1,length(x0))*2*pi;
	% Excitation = 1/sqrt(2)*[1,1*exp(1i*pi/2)];


	% SampleNumber = length(x0);

	aniso_1D_3 = zeros(1,1000);
	tic;
	t0 = toc;
	for i = 1:SampleNumber
		% aniso_1D_1(i) = Anisotropy([x0(i);y0(i);z0(i)],phiv(i),[0;0;1],Excitation);
		aniso_1D_3(i) = Anisotropy([x1(i);y1(i);z1(i)],phiv(i),[0;0;1],Excitation);
		
		if mod(i,10) == 0
			fprintf('Completed: %d/%d Elapse Time:%.2f/%.2f\n',i,SampleNumber,toc-t0,(toc-t0)/i*(SampleNumber-i));
		end
	end

	% subplot(1,2,1);
	histogram(aniso_1D_3*ScaleRatio,linspace(-1,1,10));
	xlim([-1,1]);

	% % at = cell2mat(arrayfun(@(x0,y0,z0,theta0) WavefunctionEnd([x0;y0;z0],theta0,[0;0;1]),x0,y0,z0,phiv,'UniformOutput',false));
	% at = cell2mat(arrayfun(@(x0,y0,z0,theta0) WavefunctionEnd([x0;y0;z0],theta0,[0;0;1]),x1,y1,z1,phiv1,'UniformOutput',false));

	% subplot(1,2,2);
	% plot3(at(1,:).*aniso_2D_2*ScaleRatio,at(2,:).*aniso_2D_2*ScaleRatio,at(3,:).*aniso_2D_2*ScaleRatio,'o');
	% axis equal;

% %%%%%% Block2 %%%%%%
	% phi = 0:0.01:2*pi;
	% theta = 0:0.01:pi;
	% [phi,theta] = meshgrid(phi,theta);

	% a = [1;0;0];
	
% 	f_I_x = @(phi,theta) (a(1).*(cos(theta) - sin(phi).^2.*(cos(theta) - 1)) + a(3).*cos(phi).*sin(-theta) + a(2).*cos(phi).*sin(phi).*(cos(theta) - 1)).^2;
% 	f_I_y = @(phi,theta) (a(2).*(cos(theta) - cos(phi).^2.*(cos(theta) - 1)) + a(3).*sin(phi).*sin(-theta) + a(1).*cos(phi).*sin(phi).*(cos(theta) - 1)).^2;

% 	I_x = f_I_x(phi,theta);
% 	I_y = f_I_y(phi,theta);

% 	I_x0 = integral2(@(phi,theta) f_I_x(phi,theta).*sin(theta),0,2*pi,0,asin(1.25/1.52));
% 	I_y0 = integral2(@(phi,theta) f_I_y(phi,theta).*sin(theta),0,2*pi,0,asin(1.25/1.52));
% 	fprintf('%f\n',(I_x0-I_y0)./(I_x0+I_y0));

% 	figure(1);
% 	clf(1);
% 	subplot(2,2,1);
% 	surf(cos(phi).*sin(theta).*I_x,sin(phi).*sin(theta).*I_x,cos(theta).*I_x,I_x,'LineStyle','none');
% 	colorbar;
% 	axis equal;
% 	hold on;
% 	quiver3(0,0,0,a(1)*2,a(2)*2,a(3)*2,'k');

% 	subplot(2,2,2);
% 	surf(cos(phi).*sin(theta).*I_y,sin(phi).*sin(theta).*I_y,cos(theta).*I_y,I_y,'LineStyle','none');
% 	colorbar;
% 	axis equal;
% 	hold on;
% 	quiver3(0,0,0,a(1)*2,a(2)*2,a(3)*2,'k');

% 	subplot(2,2,3);
% 	A = (I_x-I_y)./(I_x+I_y);
% 	surf(cos(phi).*sin(theta).*A,sin(phi).*sin(theta).*A,cos(theta).*A,A,'LineStyle','none');
% 	colorbar;
% 	axis equal;
% 	hold on;
% 	quiver3(0,0,0,a(1)*2,a(2)*2,a(3)*2,'k');

% 	subplot(2,2,4);
% 	A = I_x+I_y;
% 	surf(cos(phi).*sin(theta).*A,sin(phi).*sin(theta).*A,cos(theta).*A,A,'LineStyle','none');
% 	colorbar;
% 	axis equal;
% 	hold on;
% 	quiver3(0,0,0,a(1)*2,a(2)*2,a(3)*2,'k');
	

% %%%%%% Block3 %%%%%%
% 	figure(3);
% 	clf(3);

% 	x1 = 0;
% 	y1 = 0;
% 	z1 = 1;

% 	theta_d1 = acos(z1);
% 	phi_d1 = atan2(y1,x1);

% 	x2 = 0;
% 	y2 = 1;
% 	z2 = 0;

% 	theta_d2 = acos(z2);
% 	phi_d2 = atan2(y2,x2);

% 	phi = 0:0.01:2*pi;
% 	theta = 0:0.01:pi;
% 	[phi,theta] = meshgrid(phi,theta);

% 	r1 = (sin(theta_d1).^2.*cos(phi-phi_d1).^2.*cos(theta).^2+cos(theta_d1).^2.*sin(theta).^2-2.*sin(theta_d1).*cos(theta_d1).*cos(phi-phi_d1).*sin(theta).*cos(theta)+sin(theta_d1).^2.*sin(phi-phi_d1).^2);
% 	r2 = (sin(theta_d2).^2.*cos(phi-phi_d2).^2.*cos(theta).^2+cos(theta_d2).^2.*sin(theta).^2-2.*sin(theta_d2).*cos(theta_d2).*cos(phi-phi_d2).*sin(theta).*cos(theta)+sin(theta_d2).^2.*sin(phi-phi_d2).^2)+r1;

% 	subplot(1,2,1);
% 	surf(r1.*cos(phi).*sin(theta),r1.*sin(phi).*sin(theta),r1.*cos(theta),r1,'LineStyle','none');
% 	colorbar;
% 	axis equal;

% 	subplot(1,2,2);
% 	surf(r2.*cos(phi).*sin(theta),r2.*sin(phi).*sin(theta),r2.*cos(theta),r2,'LineStyle','none');
% 	colorbar;
% 	axis equal;


% %%%%% Block4 %%%%%%
% 	figure(5);
% 	clf(5);
% 	box on;
% 	axis equal;
% 	hold on;

% 	v = [1,1,1];

% 	theta0 = acos(v(3));
% 	phi0 = atan2(v(2),v(1));
% 	phi0(phi0<0) = phi0(phi0<0)+pi*2;

% 	pos = [1,0,0;0,1,0;0,0,1];

% 	post = zeros(3);
% 	% post(1,:) = double(M(v(1),v(2),v(3),phiv)*R_z(phi0)*R_y(theta0)*pos(1,:)');
% 	% post(2,:) = double(M(v(1),v(2),v(3),phiv)*R_z(phi0)*R_y(theta0)*pos(2,:)');
% 	% post(3,:) = double(M(v(1),v(2),v(3),phiv)*R_z(phi0)*R_y(theta0)*pos(3,:)');
% 	% WavefunctionEndSym(v,phiv,phi0,theta0,a) = M(v(1),v(2),v(3),phiv)*R_z(phi0)*R_y(theta0)*a;
% 	% post(:,1) = WavefunctionEnd(v,phiv(1),pos(:,1));
% 	% post(:,2) = WavefunctionEnd(v,phiv(1),pos(:,2));
% 	% post(:,3) = WavefunctionEnd(v,phiv(1),pos(:,3));

% 	quiver3(0,0,0,pos(1,1),pos(2,1),pos(3,1),'r');
% 	quiver3(0,0,0,pos(1,2),pos(2,2),pos(3,2),'g');
% 	quiver3(0,0,0,pos(1,3),pos(2,3),pos(3,3),'b');
% 	% quiver3(0,0,0,post(1,1),post(2,1),post(3,1),'r--');
% 	% quiver3(0,0,0,post(1,2),post(2,2),post(3,2),'g--');
% 	% quiver3(0,0,0,post(1,3),post(2,3),post(3,3),'b--');
% 	% quiver3(0,0,0,v(1),v(2),v(3),'k');
% 	view(37.5,30);

% 	d_phi = 0;
% 	d_theta = pi/2;

% 	k_phi = pi/4;
% 	k_theta = pi/6;

% 	quiver3(0,0,0,cos(d_phi)*sin(d_theta),sin(d_phi)*sin(d_theta),cos(d_theta),'r--');
% 	quiver3(0,0,0,-cos(d_phi)*sin(d_theta),-sin(d_phi)*sin(d_theta),-cos(d_theta),'r--');

% 	quiver3(0,0,0,cos(k_phi)*sin(k_theta),sin(k_phi)*sin(k_theta),cos(k_theta),0,'k');
% 	quiver3(0,0,0,-sin(k_phi),cos(k_phi),0,'k--');

% 	kt = double(M(-sin(k_phi),cos(k_phi),0,k_theta)*[cos(d_phi)*sin(d_theta);sin(d_phi)*sin(d_theta);cos(d_theta)]);
 	
% 	quiver3(0,0,0,kt(1),kt(2),kt(3),'b--');

% figure(2);
% subplot(2,2,1);
% set(gca,'FontSize',14);
% title('1D dipole with excitation polarization dependency');
% subplot(2,2,2);
% set(gca,'FontSize',14);
% title('2D dipole with excitation polarization dependency');
% subplot(2,2,3);
% set(gca,'FontSize',14);
% title('1D dipole without excitation polarization dependency');
% subplot(2,2,4);
% set(gca,'FontSize',14);
% title('2D dipole without excitation polarization dependency');

%%%%%% Block5 %%%%%%
	% tic;
	% SampleNumber = floor(100000/pi*6);
	% % x0 = rand(1,SampleNumber)*2-1;
	% % % x0(end) = [];
	% % y0 = rand(1,SampleNumber)*2-1;
	% % % y0(end) = [];
	% % z0 = rand(1,SampleNumber)*2-1;
	% % % z0(end) = [];
	% % % [Y,Z] = meshgrid(y0,z0);
	% % index = x0.^2+y0.^2+z0.^2<=1;
	% % x0 = x0(index);
	% % y0 = y0(index);
	% % z0 = z0(index);
	% % phiv = rand(1,length(x0))*2*pi;
	% % phivt = linspace(0,2*pi,500);

	% % SampleNumber = length(phivt)-1;

	% % Ix = zeros(2,SampleNumber);
	% % Iy = zeros(2,SampleNumber);

	% % t0 = toc;
	% % for i = 1:SampleNumber
	% % 	Ix(:,i) = PolarizationMicroscopy([x0(i);y0(i);z0(i)],phiv(i),[0;0;1],[1,0])';
	% % 	Iy(:,i) = PolarizationMicroscopy([x0(i);y0(i);z0(i)],phiv(i),[0;0;1],[0,1])';

	% % 	if mod(i,10) == 0
	% % 		fprintf('Completed: %d/%d Elapse Time:%.2f/%.2f\n',i,SampleNumber,toc-t0,(toc-t0)/i*(SampleNumber-i));
	% % 	end
	% % end

	% % X = (Ix(1,:)+Ix(2,:))./(Iy(1,:)+Iy(2,:));
	% % Y = (Ix(1,:)+Iy(1,:))./(Ix(2,:)+Iy(2,:));

	% figure(3);
	% clf(3);
	% % bins = linspace(-4,4,41);
	% % [N,~] = histcounts(log10(X),bins);
	% % N = N/length(X);
	% % plot(bins(1:40)+(bins(2)-bins(1))/2,N,'ro');
	% % ylim([0,max(N)]);

	% theta_d = acos(z0);
	% phi_d = atan2(y0,x0);

	% a = [10000;0;0.4];
	% % a = 100000;
	% for i = 1:length(a)
	% 	X_paper = (sin(phi_d).^2+(a(i).*sin(theta_d).*cos(phi_d)).^2+(cos(theta_d).*cos(phi_d)).^2)./(cos(phi_d).^2+(a(i).*sin(theta_d).*sin(phi_d)).^2+(cos(theta_d).*sin(phi_d)).^2);
	% 	% X_paper = (sin(phi_d).^2+(cos(theta_d).*cos(phi_d)).^2)./(cos(phi_d).^2+(cos(theta_d).*sin(phi_d)).^2);
	% 	% X_paper = 1./tan(0:0.001:2*pi).^2;
	% 	bins = linspace(-4,4,41);
	% 	[N,~] = histcounts(log10(X_paper),bins);
	% 	N = N/length(X_paper);
	% 	hold on;
	% 	plot(bins(1:40)+(bins(2)-bins(1))/2,N,'o-');
	% 	ylim([0,0.3]);
	% end
