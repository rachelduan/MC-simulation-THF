function [Mn,Mw,B] = retrieve(polymer, EGDE)
    Mn = 0;
    Mw = 0;
    B = 0;
    pos = find(EGDE);
    for i = 1:size(pos,2)
        [M, Bi] = retrievePara(polymer(pos(i)).MatPoly,polymer(pos(i)).MatV);
        Mn = Mn + M;
        Mw = Mw + M*M;
        B = B + Bi;
    end

    Mw = Mw / Mn ;
    Mn = Mn / sum(EGDE~=0);
end

function [M, Bi] = retrievePara(MatPoly,MatV,EGDE)
	Mthf = 72;
	Megde = 174;
	Nthf = sum(MatV(2,:));
    Negde = length(MatPoly);

    M = Mthf*Nthf+Megde*Negde;
    Bi = size(MatV, 2);
    if(length(find(MatPoly(:, 1))) == 0)
    	Bi = Bi-1;
    end
end