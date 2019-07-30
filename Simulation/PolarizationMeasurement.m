function I = PolarizationMeasurement(DipoleVector,v_alpha)
	% Experiment parameters.
	n_1 = 1.5;
	n_2 = 1;
	NA = 1.46;
	D = 1;
	d = 50*10^-9;
	lambda = 620*10^-9;

	theta_1_critical = asin(n_2/n_1);
	theta_1_max = asin(NA/n_1);

	% Conversion of the coordinates of DipoleVector
	Theta = acos(DipoleVector(3));
	Psi = atan2(DipoleVector(2),DipoleVector(1));
	Psi(Psi<0) = Psi(Psi<0)+pi*2;

	PowerFun = @(x,y) arrayfun(@(theta_1,phi) abs(sum(E(theta_1,phi).*v_alpha))^2*n_1*sin(theta_1),x,y);
	
	I = integral2(PowerFun,0,theta_1_critical,0,2*pi)+integral2(PowerFun,theta_1_critical,theta_1_max,0,2*pi);

	function FieldVector = E(theta_1,phi)
		Es = sin(Theta)*sin(phi-Psi);
		Epa = -cos(Theta)*sin(theta_1);
		Epb = sin(Theta)*cos(theta_1)*cos(Psi-phi);
		
		delta = 4*pi*n_1*d*cos(theta_1)/lambda;
		cos_theta_2 = sqrt(1-(n_1*sin(theta_1)/n_2)^2);
		r_s = (n_1*cos(theta_1)-n_2*cos_theta_2)/(n_1*cos(theta_1)+n_2*cos_theta_2);
		r_p = (n_2*cos(theta_1)-n_1*cos_theta_2)/(n_1*cos_theta_2+n_2*cos(theta_1));

		vs = [sin(phi);-cos(phi);0];
		vp = [cos(phi);sin(phi);0];

		fs = 1+r_s*exp(1i*delta);
		fpa = 1+r_p*exp(1i*delta);
		fpb = 1-r_p*exp(1i*delta);

		FieldVector = D*(Es*fs*vs+(Epa*fpa+Epb*fpb)*vp);
	end
end

