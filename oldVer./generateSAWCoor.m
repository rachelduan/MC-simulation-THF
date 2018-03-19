
%函数输入两个个矩阵
%MatPoly：连接图
%Vertex：节点矩阵，第一行存储该edge的编号（感觉这个可以不存储直接用下标索引），第二行存储聚合到该edge上的thf总数
%返回coordinates：坐标矩阵
%
%PS: MatPoly矩阵只能为无环图
%
function coordinates = generateSAWCoor(MatPoly,Vertex)
    %设置thf和edge半径大小
    Rthf = 3;
    Regde = 4;
    %检查输入矩阵维度是否正确，不正确则退出函数
    [~,num] = size(Vertex);
    [row, col] = size(MatPoly);
    if(row ~= col || num ~= row)
        return;
    end

    %预分配坐标矩阵空间,mole_num记录整个分子一共有几个节点
    %1，2，3行存储x，y，z坐标，第4行存储该节点半径
    mole_num = num;
    for i = 1:num
        mole_num = mole_num + Vertex(2,i);
    end
    coordinates = zeros(5,mole_num);

    %tail_coordinates：坐标矩阵最后一个元素的下标
    tail_coordinates = 1;
    coordinates(1,1) = 0;
    coordinates(2,1) = 0;
    coordinates(3,1) = 0;
    coordinates(4,1) = Regde;
    coordinates(5,1) = 0;


    %Q：一个行数为2的矩阵，模拟队列
    %Q第一行是该节点在Vertex矩阵中的下标，第二行记录在Coordinates中的下标，用来索引弹出节点的坐标
    [m,n] = size(MatPoly);
    Q = zeros(2,m*n);   
    h = 1; %Q的head
    t = 0; %Q的tail

    %将第一个元素入队 
    t = t+1;  
    Q(1,t) = 1;
    Q(2,t) = 1;

    %当队列不为空时，进行循环
    while(h<=t)
        %root：表示现在正在生成的节点坐标都是从root这个edge上长出来的
        %root为一个2*1矩阵，root(1,1)记录该节点在MatV中下标，root(2,1)记录该节点坐标在coordinates中下标
        %将队列中最前面的元素弹出
        root = Q(:,h)
        h = h+1;

        %pos：root这个edge连着的所有edge在vertex矩阵中的位置
        %len：表示这个edge下面连着几个edge
        %cnt：记录已经生成的thf节点数量，目的是生成最后一段thf，当这个root下面所有edge坐标和edge之间的thf都生成好了之后，生成剩下的thf坐标
        pos = find(MatPoly(root(1,1),:));
        len = length(pos);
        cnt = 1;
        %while循环生成第一个与root（edge）连接的thf坐标
        while 1
            
            theta = unifrnd(0,2*pi);
            phi = unifrnd(0,2*pi);
            coordinates(1:3,tail_coordinates+1) = generate_co(coordinates,root(2,1),theta,phi,Rthf);
            
            %若生成的坐标并未冲突，记录该坐标，退出循环
            if(conflict(coordinates,tail_coordinates+1,root(2,1))~=1)
                coordinates(4,tail_coordinates+1) = Rthf;
                tail_coordinates = tail_coordinates+1;
                cnt = cnt+1;
                break;
            end
        end
        %把parent的下标改为从0开始是因为读数据用的是Processing，下标从0开始
        coordinates(5,tail_coordinates) = root(2,1)-1; 

        %通过pos_index从1到len来生成这个root下面最后一个egde以前的所有节点坐标
        for pos_index = 1:len
            %生成thf坐标，直到遇到下一个egde
            while(cnt<MatPoly(root(1,1),pos(pos_index))+length(find(MatPoly(root(1,1),1:pos(pos_index)))))
                
                theta = unifrnd(0,2*pi);
                phi = unifrnd(0,2*pi);

                coordinates(1:3,tail_coordinates+1) = generate_co(coordinates,tail_coordinates,theta,phi,Rthf);
                coordinates(4,tail_coordinates+1) = Rthf;
                %若生成的坐标不冲突，则记录该坐标
                if(conflict(coordinates,tail_coordinates+1,tail_coordinates)~=1)
                    coordinates(5,tail_coordinates+1) = tail_coordinates-1;
                    tail_coordinates = tail_coordinates+1;
                    cnt = cnt+1;
                end
            end

            %将这个edge入队
            t = t+1;
            Q(1,t) = pos(pos_index);
            Q(2,t) = tail_coordinates+1;
            %while循环生成这个edge的坐标
            while 1
                
                theta = unifrnd(0,2*pi);
                phi = unifrnd(0,2*pi);

                coordinates(1:3,tail_coordinates+1) = generate_co(coordinates,tail_coordinates,theta,phi,Regde);
                coordinates(4,tail_coordinates+1) = Regde;

                if(conflict(coordinates,tail_coordinates+1,tail_coordinates)~=1)
                    coordinates(5,tail_coordinates+1) = tail_coordinates-1;
                    tail_coordinates = tail_coordinates+1;
                    cnt = cnt+1;
                   break;
                end 
            end
        end
        %生成最后一段thf坐标
        while(cnt<Vertex(2,root(1,1))+len+1)
            
            theta = unifrnd(0,2*pi);
            phi = unifrnd(0,2*pi);

            coordinates(1:3,tail_coordinates+1) = generate_co(coordinates,tail_coordinates,theta,phi,Rthf);
            coordinates(4,tail_coordinates+1) = Rthf;
            
            if(conflict(coordinates,tail_coordinates+1,tail_coordinates)~=1)
                coordinates(5,tail_coordinates+1) = tail_coordinates-1;
                tail_coordinates = tail_coordinates+1;
                cnt = cnt+1;
            end
        end

    end

    %将coordinates矩阵的数据导出到csv文件中¸­
    filename = '/Users/Rachel/Documents/Processing/MC_simulation_drawMol__/coordinates.csv';
    csvwrite(filename,coordinates);
end

%判断生成的最后一个节点与他之前的除了父节点之外的所有节点是否冲突
function judge = conflict(coordinates,tail,parent)
    judge = 0;
    for i = 1:tail-1
        if i==parent
            continue;
        end
        x_sqr = (coordinates(1,i)-coordinates(1,tail)).^2;
        y_sqr = (coordinates(2,i)-coordinates(2,tail)).^2;
        z_sqr = (coordinates(3,i)-coordinates(3,tail)).^2;
        dist_sqr = (coordinates(4,i)+coordinates(4,tail)+1).^2;
        if(x_sqr+y_sqr+z_sqr<=dist_sqr)
            judge = 1;
            break;
        end
    end
end

function current_co = generate_co(coordinates,parent,theta,phi,R)
    dist = coordinates(4,parent)+R;
    current_co = zeros(3,1);
    current_co(1,1) = coordinates(1,parent)+sin(theta)*cos(phi)*dist;
    current_co(2,1) = coordinates(2,parent)+sin(theta)*sin(phi)*dist;
    current_co(3,1) = coordinates(3,parent)+cos(theta)*dist;
end








