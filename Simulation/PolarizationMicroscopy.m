function I = PolarizationMicroscopy(v,phiv,a,Excitation)
	if ~sum(a)
		error('The probability array ''a'' is zero!');
	elseif sum(a) ~= 1
		warning('The total emission probability is not equal to one: [%f,%f,%f]!',a(1),a(2),a(3));
	end
	theta_a = asin(1.4/1.5);
	% theta_a = 0.001;
	dipole = zeros(3);
	dipole(:,1) = WavefunctionEnd(v,phiv,[1;0;0]);
	dipole(:,2) = WavefunctionEnd(v,phiv,[0;1;0]);
	dipole(:,3) = WavefunctionEnd(v,phiv,[0;0;1]);
	% p = ExcitationIntensity(a1,a2,a3,Excitation);
	p = 1/3*[1,1,1];

	I = [0,0];
	for i = 1:3
		if a(i)
			I(1) = I(1)+PolarizationMeasurement(dipole(:,i),[1;0;0])*a(i)*p(i);
			I(2) = I(2)+PolarizationMeasurement(dipole(:,i),[0;1;0])*a(i)*p(i);
		end
	end

	% I = PolarizationProjector(dipole(:,1),theta_a)*a(1)*p(1)+PolarizationProjector(dipole(:,2),theta_a)*a(2)*p(2)+PolarizationProjector(dipole(:,3),theta_a)*a(3)*p(3);
end

function I = PolarizationProjector(a,u)
	theta_d = acos(a(3));
	phi_d = atan2(a(2),a(1));

	f_I_x = @(phi,theta) (a(1).*(cos(theta) - sin(phi).^2.*(cos(theta) - 1)) + a(3).*cos(phi).*sin(-theta) + a(2).*cos(phi).*sin(phi).*(cos(theta) - 1)).^2.*sin(theta);
	f_I_y = @(phi,theta) (a(2).*(cos(theta) - cos(phi).^2.*(cos(theta) - 1)) + a(3).*sin(phi).*sin(-theta) + a(1).*cos(phi).*sin(phi).*(cos(theta) - 1)).^2.*sin(theta);

	I_x = integral2(f_I_x,0,2*pi,0,u);
	I_y = integral2(f_I_y,0,2*pi,0,u);

	I = [I_x,I_y];
end

function p = ExcitationIntensity(a1,a2,a3,Excitation)
	p = ones(1,3);
	dp_x = [1;0;0];
	dp_y = [0;1;0];

	p(1) = abs(sum(a1.*dp_x)*Excitation(1)+sum(a1.*dp_y)*Excitation(2))^2;
	p(2) = abs(sum(a2.*dp_x)*Excitation(1)+sum(a2.*dp_y)*Excitation(2))^2;
	p(3) = abs(sum(a3.*dp_x)*Excitation(1)+sum(a3.*dp_y)*Excitation(2))^2;

end
