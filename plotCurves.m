function plotCurves(Params, polymer, EGDE)

	% GPC Plot
	



	params = find(Params(1,:));
	plot(Params(end,1:params(end)),Params(1:end-2,1:params(end)));
end
