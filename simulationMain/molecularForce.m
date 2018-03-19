
function mF = molecularForce(coordinates_t,mole1,mole2)
	%k J/K
	kbonding = 300;
	knonbonding = 30;
	%% C-O键能量最低距离为1.43nm
	%  能量单位kcal/mol
	Rbonding = 7;
	Rnonbonding = 12;    
	mF = 0;
	dist_t = coordinates_t(1:3,mole1)-coordinates_t(1:3,mole2);
	dist = sqrt(dist_t'*dist_t);
	if coordinates_t(5,mole1) == mole2 || coordinates_t(5,mole2) == mole1
		mF = 0.5*kbonding*(dist-Rbonding)^2;
	else if dist >= Rnonbonding
		mF = 0;
	else
		mF = 0.5*knonbonding*(dist-Rnonbonding)^2;
	end
end