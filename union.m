%  If next reaction is a polymer 'randnumAdding' adding to another polymer 'polymerToBeAdded'
%  then   1) combine their MatPoly and MatV matrices
%         2) set MatPoly and MatV matrices of polymer 'randnumadding' to []
%         3) set EGDE(randnumadding) to 0 
%

function [polymer,EGDE] = union(polymer, Mat1, Mat2,index_added,EGDE)
%function [insert_loc] = Union(polymer, Mat1, Mat2,index_added,EGDE)
    if Mat1 == Mat2
    	% form a ring 
    	polymer(Mat1).MatPoly(index_added,1) = polymer(Mat1).MatV(2,index_added);

    	EGDE(Mat1) = -EGDE(Mat1);
    else
		%locate where to insert the second matrix
		insert_loc = locate(polymer(Mat1).MatPoly,polymer(Mat1).MatV,index_added);
		
		[polymer(Mat1).MatPoly,polymer(Mat1).MatV] = matUnion(polymer(Mat1).MatPoly, polymer(Mat1).MatV,...
			polymer(Mat2).MatPoly, polymer(Mat2).MatV, insert_loc, index_added);
		polymer(Mat2).MatPoly = [];
		polymer(Mat2).MatV = [];

		EGDE(Mat2) = 0;
	end

	
end

function [MatPoly_added,MatV_added] = matUnion(MatPoly_added,MatV_added,MatPoly_adding,MatV_adding,insert_loc,index_added)
	

	len_added = length(MatV_added(1,:));
	len_adding = length(MatV_adding(1,:));

	MatPoly_added(len_added+1:len_added+len_adding,1:len_added) = 0;
	MatPoly_added(:,len_added+1:len_added+len_adding) = 0;

	%modify Mat according to insertion location
	if(insert_loc == len_added+1)
		MatV_added = [MatV_added MatV_adding];
		
		MatPoly_added(len_added+1:len_added+len_adding,len_added+1:len_added+len_adding) = MatPoly_adding;
		MatPoly_added(index_added,insert_loc) = MatV_added(2,index_added);
	else
		MatV_added(:,insert_loc+len_adding:len_added+len_adding) = MatV_added(:,insert_loc:len_added);
		MatV_added(:,insert_loc:insert_loc+len_adding-1) = MatV_adding;

	    %modify MatPoly according to insertion location
	    %record thf num between "index_added" egde and adding egde in the matrix
	    MatPoly_added(:,insert_loc+len_adding:len_added+len_adding) = MatPoly_added(:,insert_loc:len_added);
	    MatPoly_added(:,insert_loc:insert_loc+len_adding-1) = 0;
	    MatPoly_added(insert_loc+len_adding:len_added+len_adding,:) = MatPoly_added(insert_loc:len_added,:);
	    MatPoly_added(insert_loc:insert_loc+len_adding-1,:) = 0;
	   
	    MatPoly_added(index_added,insert_loc) = MatV_added(2,index_added);
	    MatPoly_added(insert_loc:insert_loc+len_adding-1,insert_loc:insert_loc+len_adding-1) = MatPoly_adding;
	    
	end

end


function insert_loc = locate(MatPoly,MatV,index_added)
	col = index_added;
	len = length(MatV(1,:));
	if col == len
		insert_loc = col + 1;
		return;
	end
	row = find(MatPoly(:,index_added));
	if length(row) == 0
		insert_loc = len + 1;
		return;
	end
	if index_added == 1
		insert_loc = len + 1;
		return
	end
	insert_loc = -1;
	while row ~= 1
		pos = find(MatPoly(row,index_added+1:len));
		if length(pos) ~= 0
			insert_loc = index_added+pos(1,1);
			return;
		end
		col = row;
		row = find(MatPoly(:,col));
	end
	pos = find(MatPoly(row,index_added+1:len));
	if length(pos) ~= 0
		insert_loc = index_added+pos(1,1);		
	else 
		insert_loc = len+1;
	end
end











