function at = WavefunctionEnd(v,phiv,a0)
	v = v./sqrt(v(1).^2+v(2).^2+v(3).^2);
	
	theta0 = acos(v(3));
	phi0 = atan2(v(2),v(1));
	phi0(phi0<0) = phi0(phi0<0)+pi*2;

	% x = a0(1)*cos(phi)*cos(theta) - a0(2)*sin(phi) + a0(3)*cos(phi)*sin(theta);
	% y = a0(2)*cos(phi) + a0(1)*cos(theta)*sin(phi) + a0(3)*sin(phi)*sin(theta);
	% z = a0(3)*cos(theta) - a0(1)*sin(theta);

	at = zeros(3,1);
	at(1) = a0(1)*(cos(theta0)*(cos(phi0)*((1 - cos(phiv))*v(1)^2 + cos(phiv)) - sin(phi0)*(v(3)*sin(phiv) + v(1)*v(2)*(cos(phiv) - 1))) - sin(theta0)*(v(2)*sin(phiv) - v(1)*v(3)*(cos(phiv) - 1))) + a0(3)*(sin(theta0)*(cos(phi0)*((1 - cos(phiv))*v(1)^2 + cos(phiv)) - sin(phi0)*(v(3)*sin(phiv) + v(1)*v(2)*(cos(phiv) - 1))) + cos(theta0)*(v(2)*sin(phiv) - v(1)*v(3)*(cos(phiv) - 1))) - a0(2)*(cos(phi0)*(v(3)*sin(phiv) + v(1)*v(2)*(cos(phiv) - 1)) + sin(phi0)*((1 - cos(phiv))*v(1)^2 + cos(phiv)));
	at(2) = a0(1)*(cos(theta0)*(cos(phi0)*(v(3)*sin(phiv) - v(1)*v(2)*(cos(phiv) - 1)) + sin(phi0)*((1 - cos(phiv))*v(2)^2 + cos(phiv))) + sin(theta0)*(v(1)*sin(phiv) + v(2)*v(3)*(cos(phiv) - 1))) + a0(3)*(sin(theta0)*(cos(phi0)*(v(3)*sin(phiv) - v(1)*v(2)*(cos(phiv) - 1)) + sin(phi0)*((1 - cos(phiv))*v(2)^2 + cos(phiv))) - cos(theta0)*(v(1)*sin(phiv) + v(2)*v(3)*(cos(phiv) - 1))) + a0(2)*(cos(phi0)*((1 - cos(phiv))*v(2)^2 + cos(phiv)) - sin(phi0)*(v(3)*sin(phiv) - v(1)*v(2)*(cos(phiv) - 1)));
	at(3) = a0(2)*(cos(phi0)*(v(1)*sin(phiv) - v(2)*v(3)*(cos(phiv) - 1)) + sin(phi0)*(v(2)*sin(phiv) + v(1)*v(3)*(cos(phiv) - 1))) - a0(3)*(sin(theta0)*(cos(phi0)*(v(2)*sin(phiv) + v(1)*v(3)*(cos(phiv) - 1)) - sin(phi0)*(v(1)*sin(phiv) - v(2)*v(3)*(cos(phiv) - 1))) - cos(theta0)*((1 - cos(phiv))*v(3)^2 + cos(phiv))) - a0(1)*(cos(theta0)*(cos(phi0)*(v(2)*sin(phiv) + v(1)*v(3)*(cos(phiv) - 1)) - sin(phi0)*(v(1)*sin(phiv) - v(2)*v(3)*(cos(phiv) - 1))) + sin(theta0)*((1 - cos(phiv))*v(3)^2 + cos(phiv)));

	% x = a0(1)*(cos(a)*cos(r) - cos(b)*sin(a)*sin(r)) - a0(2)*(sin(a)*cos(r) + cos(a)*cos(b)*sin(r)) + a0(3)*sin(b)*sin(r);
	% y = a0(1)*(cos(a)*sin(r) + cos(b)*sin(a)*cos(r)) - a0(2)*(sin(a)*sin(r) - cos(a)*cos(b)*cos(r)) - a0(3)*sin(b)*cos(r);
	% z = a0(3)*cos(b) + a0(2)*cos(a)*sin(b) + a0(1)*sin(a)*sin(b);
end