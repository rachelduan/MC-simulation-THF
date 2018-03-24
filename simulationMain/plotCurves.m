function plotCurves(Params, polymer, EGDE)

	params = find(Params(1,:));
	subplot(2,2,1);
	plot(Params(end,1:params(end)),Params(1,1:params(end)));
	subplot(2,2,2);
	plot(Params(end,1:params(end)),Params(2:3,1:params(end)));
	subplot(2,2,3);
	plot(Params(end,1:params(end)),Params(4,1:params(end)));
end
