clc
clear all

ITSet =[];
ITSet2 =[];
ITSet3 =[];
FirRun = [];
SecRun = [];
ThirRun = [];

%Slide example
d1 = [1 3 4 0];
d2 = [2 3 5 0];
d3 = [1 2 3 5];
d4 = [2 5 0 0];
data = [d1;d2;d3;d4];

% load WEKA data
% load datasetrevised
% data = table2array(datasetrevised);
% [row col] = size(data);
% 
% dataset = [];
% for i = 1:row
%     count = 0;
%     for j = 1:col
%         if data(i,j) ==1
%             count = count +1;
%             dataset(i,count) = j;
%         end
%     end
% end

%IBM data
load IBMdata.mat
for  j = 1:99
    temp = [];
    count = 0;
    for i = 1:length(data)
        
        if(data(i,1)==j)
            count = count+1;
            temp=[temp,data(i,2)];
        end
        
    end
    dataset(j,1:count) = [temp];
end


data = dataset;
MinSup = 10;

%% 1st Count the frequent itemset appeared
[C,ia,ic] = unique(data);
a_counts = accumarray(ic,1);
value_counts = [C, a_counts];

if value_counts(1,1)==0
    for i =1:length(value_counts)-1
    ITSet(i,:) = value_counts(i+1,:);
    end
end

%% 1st Sort  and Save the itemset heigh than itemset

sorted = 0;
k = 0;

while ~sorted
    sorted =1;
    k = k+1;
    for j = 1:length(ITSet)-k
        if( ITSet(j,2) < ITSet(j+1,2))
        temp = ITSet(j,:);
        ITSet(j,:) = ITSet(j+1,:);
        ITSet(j+1,:) = temp;
        sorted = 0;
        end
    end
end



for row = 1:length(ITSet)
    
    if(ITSet(row,2)>=MinSup)
        FirstRun(row,1) = ITSet(row,1);
    end
    
end


%% 2nd generate  itemset

v = unique(FirstRun(:,1));
ITSet2 = combnk(v,2);

% count= 1;
% for j =1:length(FistRun)-1
%     for k = j+1:length(FistRun)
%         ITSet2(count,1) = FistRun(j,1);
%         count = count+1;
%     end
% end
% 
% count= 1;
% for j =1:length(FistRun)
%     for k = j+1:length(FistRun)
%         ITSet2(count,2) = FistRun(k,1);
%         count = count+1;
%     end
% end

%% 2nd Count the frequent itemset appeared 

for itrow = 1:length(ITSet2)
    count = 0 ;
    for row = 1:length(data)
        r =intersect(data(row,:),ITSet2(itrow,1:2));
        if ismember(0,r) == 1
            t = r(2:end);
        else
            t = r;
        end
        
        if length(t) ==2
            count = count+1;
        end
        
        
    end
    ITSet2(itrow,3) = count;
end

if ITSet2(:,3)<MinSup
        FistRun
end

%% 2nd Sort  and Save the itemset heigh than itemset
sorted = 0;
k = 0;

while ~sorted
    sorted =1;
    k = k+1;
    for j = 1:length(ITSet2)-k
        if( ITSet2(j,3) < ITSet2(j+1,3))
        temp = ITSet2(j,:);
        ITSet2(j,:) = ITSet2(j+1,:);
        ITSet2(j+1,:) = temp;
        sorted = 0;
        end
    end
end

count = 0;
RunCount = 0;
for row = 1:length(ITSet2)
    
    if(ITSet2(row,3)>=MinSup)
        RunCount =RunCount+1;
        SecRun(RunCount,:) = ITSet2(row,:);
        
    else
        count = count+1;
        DeSet(count,:) =  ITSet2(row,1:2);
        
    end
    
end

%% 3rd Generate itemset

v = unique(SecRun(:,1:2));  %Problem
TempSet = combnk(v,3);

[row ~] = size(DeSet);

count =0;
for i =1:length(TempSet)
    flag=0;
    tic
    
    
    for j =1:row
        
        if (ismember(DeSet(j,:),TempSet(i,:)) == [1 1])
            flag = 1;
            break  
        end


    end
    
    
    if (flag ==0)
        count = count+1;
        ITSet3(count,1:3) = TempSet(i,1:3);
        
        toc
        
    end
    
end






%% 3rd Count the frequent itemset appeared 

% Problem
[itrow col] = size(ITSet3);
for itrow = 1:itrow
    count = 0 ;
    for row = 1:length(data)
        t =intersect(data(row,:),ITSet3(itrow,1:3));
       
        if length(t) ==3
            count = count+1;
        end    
        
    end
    
    ITSet3(itrow,4) = count;
end

if ITSet3(:,4)<MinSup
        SecRun
end

%% 3rd Save the itemset heigh than threshold

count = 0;
RunCount = 0;
DeSet2 = [];
for row = 1:length(ITSet3)
    
    if(ITSet3(row,4) >= MinSup)
        RunCount=RunCount+1;
        ThirRun(RunCount,:) = ITSet3(row,:);
        
    else
        count = count+1;
        DeSet3(count,:) =  ITSet3(row,1:3);
        
    end
    
end

%% 4th Generate itemset

v = unique(ThirRun(:,1:3));  %Problem
TempSet = combnk(v,4);

[row ~] = size(DeSet3);
count =0;

for i =1:length(TempSet)
    flag=0;
    
    for j =1:row
        
        if (ismember(DeSet3(j,:),TempSet(i,:)) == [1 1 1])
            
            flag=1;
            break
        end
        
    end
    
    if (flag ==0)
        count = count+1;
        ITSet4(count,1:3) = TempSet(i,1:3);
     end
   
    
end


%% 4th Count the frequent itemset appeared 

[itrow col] = size(ITSet3);
for itrow = 1:itrow
    count = 0 ;
    for row = 1:length(data)
        t =intersect(data(row,:),ITSet4(itrow,1:4));
       
        if length(t) ==3
            count = count+1;
        end    
        
    end
    
    ITSet4(itrow,5) = count;
end

% for itrow = 1:length(ITSet4)
%     count = 0 ;
%     for row = 1:length(data)
%         r =intersect(data(row,:),ITSet4(itrow,1:4));
%         if ismember(0,r) == 1
%             t = r(2:end);
%         else
%             t = r;
%         end
%         
%         if length(t) ==2
%             count = count+1;
%         end
%         
%         
%     end
%     ITSet4(itrow,5) = count;
% end

%% 4th Save the itemset heigh than threshold
count = 0;
RunCount = 0;
for row = 1:length(ITSet4)
    
    if(ITSet4(row,3)>=MinSup)
        RunCount =RunCount+1;
        FourRun(RunCount,:) = ITSet4(row,:);
        
    else
        count = count+1;
        DeSet4(count,:) =  ITSet4(row,1:2);
        
    end
    
end