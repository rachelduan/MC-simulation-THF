function GPC = plotGPC(polymer, EGDE, Params)
	Mthf = 72;
	Megde = 174;

	pos = find(EGDE>0);

	GPC = zeros(2,length(pos));

	for i = 1:length(pos)
		[coordinates, ~, ~] = generateOptimizedConfig(polymer(pos(i)).MatPoly, polymer(pos(i)).MatV)
		[~, r] = getCentroid(coordinates);

		GPC(1, i) = pi * r * r;
		GPC(2, i) = size(polymer(pos(i)).MatV, 2) * Megde + sum(polymer(pos(i)).MatV(2,:)) * Mthf;
	end

	plot(GPC(1,:), GPC(2,:), '*');
end