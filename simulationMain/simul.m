% Monte Carlo simulation - branched polymer 

%  Instruction
%  -----------
%  This file contains code that simulate the process of a Janus polymerization
%  Reaction monomer : THF
%  Initializer : EGDE, EGDE can also polymerized to a THF unit, which generates  
%                a branchable site
%  

%% Initialization
clear ; close all; clc

%% Set initial parameters for simulation   
pi1 = 1; pi2 = 0.3;             % Reaction rates for two types of reactions
								% pi1 is the rate of a THF unit adding to a reaction site
								% pi2 is the rate of a EGDE chain adding to a reaction site

SetConversion = 0.6;            % When conversion reaches SetConversion, reaction terminates
k = 10;                         % Feed ratio
t = 0;                          % Reaction time (initialzed to be 0)
EGDE = [1:20];                  % 1*n row vector storing the number of different EGDE units
originalTHFnum = size(EGDE,2)*k;% Original number of THF monomers
THF_num = originalTHFnum;       % Current number of THF monomers

%% Struct array contains paired information of MatPoly and MatV
polymer = struct('MatPoly',cell(1,size(EGDE,2)),'MatV',cell(1,size(EGDE,2)));

% Initialize each polymer 
for i = 1:size(EGDE,2)
	polymer(i).MatPoly = [0];
	polymer(i).MatV = [i;1];
end
THF_num = THF_num - size(EGDE,2);


% THFadded, EGDEadded denotes next reaction type
% 1 means the next reaction will be a THF adding to a polymer chain
% 0 means the next rection will be a EGDE adding to a polymer chain
THFadded = 1;
EGDEadded = 0;

conversion = 0;

% Params is a 5*2000 matrix, each column stores current time and current conversion, Mn, Mw, B
% ed denotes the last column of Params to store current parameters, the initial column is column 1
% dupTimes is the number of times that the sample is duplicated
% multiple is a multiplier used to multiply the number of samples
Params = zeros(5,2000);
ed = 1;
dupTimes = 0;
multiple = 2;

count = 0;

while conversion <= SetConversion
	% The number of non-zero EGDE
	% If the EGDE unit has added to another chain, its number will be set to zero
	% If the EGDE forms a ring, its number will be set nagative (times -1)
	polymer_num = sum(EGDE~=0);  

	%% 
	a1 = pi1*THF_num*polymer_num / power(multiple,dupTimes);
	a2 = pi2*polymer_num*size(EGDE,2) / power(multiple,dupTimes);
	a0 = a1+a2;
	r1 = unifrnd(0,1);
	dt = -1/a0*log(r1);
	r2 = unifrnd(0,1);
	if a0*r2<=a1
		reactionType = 1;
	else
		reactionType = 0;
	end

	%  Generate the EGDE chain to be added by either another EGDE chain or a THF unit
	pos = find(EGDE);                       % non-zero EGDE array
	randnum = unidrnd(length(pos));        
	polymerToBeAdded = pos(randnum);        % choose polymer 
	EGDEadded = unidrnd(size(polymer(polymerToBeAdded).MatV,2)); % EGDEadded is an index

	
	if reactionType == THFadded
		polymer(polymerToBeAdded).MatV(2,EGDEadded) = polymer(polymerToBeAdded).MatV(2,EGDEadded)+1;
		THF_num = THF_num-1;
	else
		pos = find(EGDE>0);
		if length(pos) > 0
			randnumAdding = unidrnd(length(pos));
			polymerAdding = pos(randnumAdding);

			% randnum and randnumAdding are both index
			[polymer,EGDE] = union(polymer,polymerToBeAdded,polymerAdding,EGDEadded,EGDE);
		end
		
	end


	[Mn, Mw, B] = retrieve(polymer, EGDE);
	Params(:,ed) =  [conversion;Mn;Mw;B;t];


	conversion = (originalTHFnum - THF_num) / originalTHFnum;
	p = (originalTHFnum - THF_num) / (originalTHFnum + size(EGDE,2));
	t = t+dt;

	
	if abs(p - 0.5) < 0.000001
		[polymer,EGDE,THF_num,originalTHFnum] = sampleDuplicate(polymer,EGDE,THF_num,originalTHFnum,multiple); 
		dupTimes = dupTimes + 1;
	end
	
	
	if ed >= size(Params,2)
		newP = zeros(size(Params));
		Params = [Params,newP];
	end
	ed = ed+1;

	%pause;
	if conversion >= 0.01 + count*0.05
		disp(conversion);
		count = count + 1;
	end
end


plotCurves(Params, polymer, EGDE);
subplot(2,2,4)
Rv = plotGPC(polymer, EGDE);


	






