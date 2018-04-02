function Rv = plotGPC(polymer, EGDE)
	Mthf = 72;
	Megde = 174;

	pos = find(EGDE);

	% M stores the paired information of molecular weight for each molecule
	Mlength = length(pos);
	M = zeros(1,Mlength);
	

	% Calculate molecular weights
	for i = 1:Mlength
		len = size(polymer(pos(i)).MatV, 2);
		M(i) =  len * Megde + polymer(pos(i)).MatV(2, :) * ones(len, 1) * Mthf;
	end
	

	% sort M into sortM which stores molecular weights' information ascendingly, index
	% is the original place for that sorted value in lnM
	% lnM is a row vector
	% sortM, index are column vectors
	lnM = log(M);
	[sortM, index] = sortrows(lnM',1);
	

	interval = 10;
	
	% selectNum = zeros(1, intervalNum);
	% selectMolecule is a column vector
	% selectMoleculeM, selectMoleculeV are row vectors
	selectedMolecule = index(1:interval:end, 1);
	selectedMoleculeM = lnM(selectedMolecule);
	selectedMoleculeV = zeros(1,length(selectedMoleculeM));

	total = length(selectedMoleculeM)

	selected = unidrnd(total);

	for i = 1:length(selectedMoleculeM)
		mol = pos(selectedMolecule(i));
		[coordinates, ~] = generateOptimizedConfig(polymer(mol).MatPoly, polymer(mol).MatV);
		% Save coordinates matrix to csv.­
		filenameAll = ['/Users/Rachel/Documents/MATLAB/MC-simulation-THF/MC_simulation_drawAllMol_spin/coordinates' num2str(i-1) '.csv'];
		csvwrite(filenameAll,coordinates);
		if i == selected
			filenameSelected = ['/Users/Rachel/Documents/MATLAB/MC-simulation-THF/MC_simulation_drawSelectedMol_spin/coordinates.csv'];
			csvwrite(filenameSelected,coordinates);
		end
		i
		[~, r] = getCentroid(coordinates);

		selectedMoleculeV(1, i) = pi * r * r;
	end

	

	% Assume the standard curve is y = 1000 - x
	Rv = 1000 - selectedMoleculeV; 


	histfit(Rv,10);

	




end