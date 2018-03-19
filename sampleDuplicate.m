function [polymerDup,EGDEDup,THF_num,originalTHFnum] = sampleDuplicate(polymer,EGDE,THF_num,originalTHFnum,multiple)

	disp('start duplication.');

	% Duplicate current THF_num and originalTHFnum
	originalTHFnum = originalTHFnum * multiple; 

	THF_num = THF_num * multiple;
	

    % Duplicate 'polymer' struct
	EGDElen = size(EGDE,2);
	polymerDup = struct('MatPoly',cell(1,EGDElen*multiple),'MatV',cell(1,EGDElen*multiple));

    for i = 1:EGDElen
	    polymerDup(i).MatPoly = polymer(i).MatPoly;
	    polymerDup(i).MatV = polymer(i).MatV;
    end


    for j = 2:multiple
    	for i = EGDElen*(j-1)+1:EGDElen*j
    		if length(polymerDup(i - EGDElen).MatPoly) == 0
    			polymerDup(i).MatPoly = []; polymerDup(i).MatV = [];
    			continue;
    		end
    		polymerDup(i).MatPoly = polymerDup(i-EGDElen).MatPoly;
    		polymerDup(i).MatV = polymerDup(i-EGDElen).MatV;
    		polymerDup(i).MatV(1,:) = polymerDup(i).MatV(1,:) + EGDElen;
    	end
    end


    % Duplicate EGDE array
    EGDEDup = EGDE;
    pos_positive = find(EGDE>0);
    pos_negative = find(EGDE<0);

    for i = 2:multiple
    	tmp = zeros(size(EGDE));

		tmp(pos_positive) = EGDE(pos_positive) + EGDElen * (i - 1);
		tmp(pos_negative) = -(-EGDE(pos_negative) + EGDElen * (i - 1));
		EGDEDup = [EGDEDup tmp];
	end	

	disp('duplication finished.');
end

