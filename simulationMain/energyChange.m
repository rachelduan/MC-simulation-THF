function deltaEnergy = energyChange(coordinates,moleIndex,new_pos)
	len = size(coordinates,2);
	deltaEnergy = 0;
	

	if moleIndex ~= -1
		coordinates_t = coordinates;
		coordinates_t(1:3,moleIndex) = new_pos;
		for i = 1:len
			if i ~= moleIndex
				
		        deltaEnergy = deltaEnergy + molecularForce(coordinates_t,i,moleIndex)...
		          -molecularForce(coordinates,i,moleIndex);
		    end
	    end
	else
		return;
	end

end