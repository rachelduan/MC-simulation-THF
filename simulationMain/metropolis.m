function [coordinates,E] = metropolis(coordinates)
    
	k = 8.314;
	T = 25+273;
	num = size(coordinates,2);
	step = 10;
	new_pos = zeros(3,1);
    
	originalEnergy = systemEnergy(coordinates);
	currentEnergy = originalEnergy;
    cntend = 1000;
    output = cntend/10;
    E = [];
    accepted = 0;
	for cnt = 1:cntend
		moleIndex = unidrnd(num);
		%step = currentEnergy/originalEnergy*step;
        step = unifrnd(0,10);
		theta = unifrnd(0,2*pi);
        phi = unifrnd(0,2*pi);

        new_pos = coordinates(1:3,moleIndex)+step*[sin(theta)*cos(phi);sin(theta)*sin(phi);cos(theta)];


        deltaEnergy = energyChange(coordinates,moleIndex,new_pos);

        %deltaEnergy


        if deltaEnergy<0
        	coordinates(1:3,moleIndex) = new_pos;
        	currentEnergy = currentEnergy+deltaEnergy;
        else
            randnum = unifrnd(0,1);
            if randnum <= exp(-deltaEnergy*1000/(k*T));
                coordinates(1:3,moleIndex) = new_pos;
                currentEnergy = currentEnergy+deltaEnergy;
                accepted = accepted+1;
                %disp('accepted.');
            end
            
        end

        if mod(cnt,output) == 0
            E = [E;[cnt,currentEnergy]];
            cnt;
        end
        
    end
end

function sysE = systemEnergy(coordinates)
    len = size(coordinates,2);
    sysE = 0;
    for i = 1:len
        for j = i+1:len
            sysE = sysE + molecularForce(coordinates,i,j);
        end
    end
    
end




