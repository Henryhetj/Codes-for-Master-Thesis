clc
clear all

tic

n=293;
step=300;
times=50;

% distance matrix of small network
pos=xlsread('total_network.xlsm','connection_matrix_full','C6:D298');
dist=zeros(n,n);
for i=1:n
    for j=i+1:n
        D=(pos(i,1)-pos(j,1)).^2+(pos(i,2)-pos(j,2)).^2;
        dist(i,j)=D^(0.5);
        dist(j,i)=dist(i,j);
    end
end
dist=1./dist;
dist(1:(n+1):end)=0

% matrix for loss degree
Evaluation=xlsread('total_network.xlsm','f_inf_matrix','B2:KH294'); 

% Integration and normalize
Integration=dist.*Evaluation;
Int_norm=mapminmax(Integration,0,1);

% initialize all the parameters
load = xlsread('total_network.xlsm','failure_rate_full','F3:M295');%load failure rates
grastep = zeros(4,step+1,times);
risk=zeros(times,n);
column=size(load,2);
risk_num=zeros(column,n);

h = waitbar(0,'Processing now...');

% iteration for each risk
for q=1:column
    
    alpha = load(:,q); % H to S
    rand('seed',1);
    % In spite of different random numbers every time, it has the same
    % trend with the majorities.
    beta= rand(n,1); %S to D
    delta = rand(n,1);%D to I
    gamma = rand(n,1);%S to I
    
    iter=1;
    while iter<= times

       % initialize the simulation
       t = 0 ;
       sta = 'H';
       save_status=sta(ones(step,n,times));
       sumH=zeros(1,step);
       sumD=zeros(1,step);
       sumS=zeros(1,step);
       sumI=zeros(1,step);
       connection=zeros(n,n,t+1);
       old_status = sta(:,ones(1,n));

       while t <= step % each step in one iteration

          new_status = old_status;

          % Spreading
          for node=1:n
              if old_status(node) == 'D' || t == 0
              % status trasmissiom
                for i=1:n
                % every adjacent nodes
                  if Int_norm(node,i) > 0 & rand(1) < Int_norm(node,i)
                    connection(node,i)=1;
                    connection(i,node)=1;

                  % if connected, update the status
                     if old_status(i) == 'H' & rand(1) < alpha(i)
                        new_status(i)='S';
                     end
                   end
                 end
              end
              sum_D=length(find(new_status=='D')); %sum of D

             % update status for each node
               if old_status(node)=='H'& rand(1) < alpha(node)
                  new_status(node)='S' ;
               elseif old_status(node)== 'S' & rand(1) < beta(node)
                  new_status(node) = 'D';
               elseif old_status(node)== 'S' & rand(1) < gamma(node)
                  new_status(node) = 'I';
               elseif old_status(node)== 'D' & rand(1) < delta(node)
                  new_status(node) = 'I';
               %when network has 20% D, it turns back to S
               elseif old_status(node)== 'I'& sum_D>=60
                  new_status(node) = 'S';
               end
              old_status = new_status; %return old status      
          end

          sumH(t+1)=length(find(old_status=='H'));
          sumD(t+1)=length(find(old_status=='D'));
          sumI(t+1)=length(find(old_status=='I'));
          sumS(t+1)=length(find(old_status=='S')); 

          %deposit the status for each step
          save_status(t+1,:,iter)=old_status;
          break_down(:,:,t+1)=connection;

          t=t+1; 
       end

       grastep(:,:,iter)=[sumH;sumD;sumS;sumI];%numbers in each step

       for col=1:n 
           risk(iter,col)=length(find(save_status(:,col,iter)=='D'|save_status(:,col,iter)=='S'));
       end

       iter=iter+1;   
    end

    %capture the risk number
    risk_num(q,:) = sum(risk,1)/iter;
    
    waitbar(q/column,h) % show the process
    
    q=q+1;
end

risk_num= risk_num';
avg_risk_num = sum(risk_num,2)/column;
xlswrite('total_network_or.csv',risk_num,'risk_num','B2')
xlswrite('total_network_or.csv',grastep(:,:,40),'grad_step','B2')
toc

% plot the nodes and lines
x=pos(:,1);
y=pos(:,2);
plot(x,y,'bo','MarkerSize',5);
for count = 1:n
    c = num2str(count);
    text(x(count)+0.01,y(count)-0.01,c);
end
figure(1);
xlabel('Longtitude');
ylabel('Latitude');
title('Small Network Plot');
axis([40.3 41.0 -75.4 -74.0]);
for i = 1:n
    for j=i+1:n
        if connection(i,j)==1
           A = pos(i,:);
           B = pos(j,:);
           line([A(1) B(1)],[A(2) B(2)], 'color','r','LineWidth',2)
        end
    end
end