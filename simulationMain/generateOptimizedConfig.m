function [coordinates,E] = generateOptimizedConfig(MatPoly, MatV)

    if length(find(MatPoly(:,1))) ~= 0
        circlePos = find(MatPoly(:,1));
        circleTHF = MatPoly(circlePos,1); 
        circleSeq = find(MatPoly(circlePos, :) > MatPoly(circlePos, 1));
        if length(circleSeq) == 0
            circleNum = length(circlePos);
        else
            circleNum = find(find(MatPoly(circlePos, :))==circleSeq(1)) - 1;
        end
        MatPoly(circlePos,1) = 0;
    else
        circlePos = 0; circleTHF = 0; circleSeq = []; 
        circleNum = 0;
    end

    


	Rthf = 3;
    Regde = 4;
    %检查输入矩阵维度是否正确，不正确则退出函数
    num = size(MatV,2);
    [row, col] = size(MatPoly);
    if(row ~= col || num ~= row)
        return;
    end

    %预分配坐标矩阵空间,mole_num记录整个分子一共有几个节点
    %1，2，3行存储x，y，z坐标，第4行存储该节点半径，第5行存储前一个节点下标，第6、7行存储后一个节点下标
    mole_num = num;
    for i = 1:num
        mole_num = mole_num + MatV(2,i);
    end
    coordinates = zeros(5,mole_num);
    %tail_coordinates：坐标矩阵最后一个元素的下标
    tail_coordinates = 1;
    coordinates(4,1) = Regde;


    %Q：一个行数为2的矩阵，模拟队列
    %Q第一行是该节点在Vertex矩阵中的下标，第二行记录在Coordinates中的下标，用来索引弹出节点的坐标
    [m,n] = size(MatPoly);
    Q = zeros(2,m*n);   
    h = 1; %Q的head
    t = 0; %Q的tail，初始为空队列

    %将第一个元素入队 
    t = t+1;  
    Q(1,t) = 1;
    Q(2,t) = 1;

    %当队列不为空时，进行循环
    flag = 0;
    while(h<=t)
        %root：表示现在正在生成的节点坐标都是从root这个egde上长出来的
        %root为一个2*1矩阵，root(1,1)记录该节点在MatV中下标，root(2,1)记录该节点坐标在coordinates中下标
        %将队列中最前面的元素弹出
        root = Q(:,h);
        h = h+1;

        if circlePos == root(1,1)
            flag = tail_coordinates;
        end

        %pos：root这个egde连着的所有egde在vertex矩阵中的位置
        %len：表示这个egde下面连着几个egde
        %cnt：记录已经生成的thf节点数量，目的是生成最后一段thf，当这个root下面所有egde坐标和edge之间的thf都生成好了之后，生成剩下的thf坐标
        pos = find(MatPoly(root(1,1),:));
        len = length(pos);
        cnt = 1;

        %生成第一个thf点坐标  
        theta = unifrnd(0,2*pi);
        phi = unifrnd(0,2*pi);
        coordinates(1:3,tail_coordinates+1) = generateCoorVector(coordinates,root(2,1),theta,phi,Rthf);
        
        coordinates(4,tail_coordinates+1) = Rthf;
        tail_coordinates = tail_coordinates+1;
        cnt = cnt+1;
                
            
        
        coordinates(5,tail_coordinates) = root(2,1); 



        %通过pos_index从1到len来生成这个root下面最后一个egde以前的所有节点坐标
        for pos_index = 1:len
            

            %生成thf坐标，直到遇到下一个egde
            plusNum = length(find(MatPoly(root(1,1),1:pos(pos_index))));
            if pos_index < circleNum
                plusNum = plusNum - 1;
            end

            while(cnt < MatPoly(root(1,1),pos(pos_index))+plusNum)
                
                theta = unifrnd(0,2*pi);
                phi = unifrnd(0,2*pi);

                coordinates(1:3,tail_coordinates+1) = generateCoorVector(coordinates,tail_coordinates,theta,phi,Rthf);
                coordinates(4,tail_coordinates+1) = Rthf;               
            
                coordinates(5,tail_coordinates+1) = tail_coordinates;
                tail_coordinates = tail_coordinates+1;
                cnt = cnt+1;
                
            end

            %将这个egde入队
            t = t+1;
            Q(1,t) = pos(pos_index);
            Q(2,t) = tail_coordinates+1;

            theta = unifrnd(0,2*pi);
            phi = unifrnd(0,2*pi);

            coordinates(1:3,tail_coordinates+1) = generateCoorVector(coordinates,tail_coordinates,theta,phi,Regde);
            coordinates(4,tail_coordinates+1) = Regde;

            coordinates(5,tail_coordinates+1) = tail_coordinates;
            tail_coordinates = tail_coordinates+1;
            cnt = cnt+1;
            
                
        end
        %生成最后一段thf坐标
        while(cnt<MatV(2,root(1,1))+len+1)
            
            theta = unifrnd(0,2*pi);
            phi = unifrnd(0,2*pi);

            coordinates(1:3,tail_coordinates+1) = generateCoorVector(coordinates,tail_coordinates,theta,phi,Rthf);
            coordinates(4,tail_coordinates+1) = Rthf;
            
            coordinates(5,tail_coordinates+1) = tail_coordinates;
            tail_coordinates = tail_coordinates+1;
            cnt = cnt+1;
            
                    
        end

        if circlePos == root(1,1)
            
            coordinates(5, 1) = flag+circleNum+circleTHF-1;
            coordinates(5, 1);
            coordinates(5, flag+circleNum+circleTHF) = 1;
        end

    end


    [coordinates,E] = metropolis(coordinates);
   
    %plot(E(:,1),E(:,2));


    %d = zeros(mole_num);
    %for i = 1:mole_num
    %    t = coordinates(1:3,:)-coordinates(1:3,i);
    %    t = t.^2;
    %    d(:,i) = t'*[1;1;1];
    %end


    
end

function current_co = generateCoorVector(coordinates,parent,theta,phi,R)
    dist = coordinates(4,parent)+R;
    current_co = zeros(3,1);
    current_co(1,1) = coordinates(1,parent)+sin(theta)*cos(phi)*dist;
    current_co(2,1) = coordinates(2,parent)+sin(theta)*sin(phi)*dist;
    current_co(3,1) = coordinates(3,parent)+cos(theta)*dist;
end

