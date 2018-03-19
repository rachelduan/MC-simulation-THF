%index_st: former EGDE unit
%index_nd: latter EGDE unit
%num: the number of THF before the latter EDGE unit
%在最尾端断裂的情况
function [MatPoly_st, MatV_st, MatPoly_nd, MatV_nd] = depoly(MatPoly,MatV,index_st,index_nd,num)

	root_st = find(MatPoly(:,index_st))
	root_nd = find(MatPoly(:,index_nd))

    rear = locate(MatPoly,MatV,root_st,root_nd,index_nd)

	len = length(MatPoly);
	Mat2_len = rear-index_nd+2;
	MatPoly_nd = zeros(Mat2_len);
	MatPoly_nd(2:end,2:end) = MatPoly(index_nd:rear,index_nd:rear);


	MatV_nd = zeros(2,Mat2_len);
	MatV_nd(:,2:end) = MatV(:,index_nd:rear);
	MatV_nd(:,1) = [MatV(1,1);num];

	
	pos = find(MatPoly(root_nd,index_nd:rear));
	MatPoly_nd(1,2) = num;
	for i = 1:length(pos)
		MatPoly_nd(1,pos(i)-index_nd+2) = MatPoly(root_nd,pos(i))-MatPoly(root_nd,index_nd)+num; 
	end

	
	MatPoly_st = zeros(len-rear+index_nd-1);
	MatPoly_st(1:index_nd-1,1:index_nd-1) = MatPoly(1:index_nd-1,1:index_nd-1);
	MatPoly_st(1:index_nd-1,index_nd:end) = MatPoly(1:index_nd-1,rear+1:len);
	MatPoly_st(index_nd:end,index_nd:end) = MatPoly(rear+1:len,rear+1:len);

	MatV_st = zeros(2,len-rear+index_nd-1);
	MatV_st(:,index_nd-1) = MatV(:,index_nd-1);
	MatV_st(:,index_nd:end) = MatV(:,rear+1:end);
	pos_st = find(MatPoly(index_st,:));
	if length(pos_st) == 0
		MatV_st(2,index_st) = MatV(2,index_st) - num;
	else
		MatV_st(2,index_st) = MatPoly(index_st,pos_st(1)) - num;
	end


end

function rear = locate(MatPoly,MatV,root_st,root_nd,index_nd)
	len = length(MatPoly);
	rear = [];
	
	%如果root_st = []，说明index_st为第一个
	if length(root_st) == 0
		rear = len;
		return;
	end
	if root_st == root_nd && root_st == 1
		rear = len;
		return;
	end
	if root_st == root_nd && root_st ~= 1
		root = find(MatPoly(:,root_st));
		ptr = root_st;
		pos = find(MatPoly(root,ptr+1:end));
	else
		root = root_st;
		ptr = index_nd;
		pos = find(MatPoly(root,ptr+1:end));
	end
	while root ~= 1 && length(pos) == 0
		root = find(MatPoly(:,root));
		ptr = root;
		pos = find(MatPoly(root,ptr+1:end));
	end
	if length(pos) == 0
		rear = len;
	else
		rear = pos+ptr-1;
	end

end



















