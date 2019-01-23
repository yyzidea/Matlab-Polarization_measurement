function result = Anisotropy(v,phiv,a,Excitation)
	I = PolarizationMicroscopy(v,phiv,a,Excitation);
	result = (I(1)-I(2))/(I(1)+I(2));
end