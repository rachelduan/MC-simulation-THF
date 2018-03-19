function [centroid,radius] = getCentroid(coordinates)
	Rthf = 3;
	Regde = 4;
	Mthf = 72;
	Megde = 174;
	centroid = zeros(3,1);
	len = size(coordinates, 2);
	Mx = 0;
	My = 0;
	Mz = 0;
	M = 0;
	for i = 1:len
		if(coordinates(4,i)==4)
			mi = Megde;
		else
			mi = Mthf;
		end	 	 
		Mx = Mx+mi*coordinates(1,i);
		My = My+mi*coordinates(2,i);
		Mz = Mz+mi*coordinates(3,i);
		M = M+mi;
	end
	centroid(1,1) = Mx/M;
	centroid(2,1) = My/M;
	centroid(3,1) = Mz/M;
	maxr_sqr = 0;
	r = Regde;

	repCentroid = repmat(centroid, 1, len);

	subSquare = (coordinates(1:3, :) - repCentroid) .* 2;
	radiusSquare = [1 1 1] * subSquare;
	[maxSquare, row] = max(radiusSquare');

	radius = sqrt(maxSquare) + coordinates(4, row);

end



