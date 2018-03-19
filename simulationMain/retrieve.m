function [Mn,Mw,B] = retrieve(polymer, EGDE)
    Mn = 0;
    Mw = 0;
    B = 0;
    for i = 1:size(polymer,2)
        if length(polymer(i).MatPoly) ~= 0
            [M, Bi] = retrievePara(polymer(i).MatPoly,polymer(i).MatV);
            Mn = Mn + M;
            Mw = Mw + M*M;
            B = B + Bi;
        end
    end

    Mw = Mw / Mn ;
    Mn = Mn / sum(EGDE>0);
end

function [M, Bi] = retrievePara(MatPoly,MatV,EGDE)
	Mthf = 72;
	Megde = 174;
	Nthf = sum(MatV(2,:));
    Negde = length(MatPoly);

    M = Mthf*Nthf+Megde*Negde;
    Bi = length(MatV);
    if(size(find(MatPoly(:,1))) ~= 0)
    	Bi = Bi-1;
    end
end