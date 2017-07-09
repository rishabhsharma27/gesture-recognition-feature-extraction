function [ feature ] = FeatureExtraction( data )


% clearvars; close all; clc; rng(0);
%K:\Studies\SEM4\data\dataset_rdf\dataset



%% Load and display a depth image example

b=data; 
% depth = uint16(data(:,:,3)) + bitsll(uint16(data(:,:,2)), 8);
% labels = data(:,:,1) > 0;
[x,y,z9]=size(data);


theta=zeros(x,y);
theta1=zeros(x,y);
theta2=zeros(x,y);



%% acquiring the centre of the hand/palm
tic
B = round(imgaussfilt(b,40),4);
imshow(B)
% a=rgb2gray(a);
[m,n]=(find(B==max(max(B))));
 m=round(mean(m));
 n=round(mean(n));



%% clearing out the areas besides the hand region

d2=zeros(x,y); 
dist=zeros(x,y);    
[x1,y1]=size(b);
    for i=1:x1  
      for j=1:y1
         d2(i,j)=sqrt(((m-i).^2+(n-j).^2));
         if (b(i,j)==1 && d2(i,j)<100 )
           b(i,j)=1;
           else 
           b(i,j)=0;
         end
      end
     end


BW1 = edge(b,'Canny');
imshow(BW1)


d3=0;
i3=0;
j3=0;
i4=0;
j4=0;
[x2,y2]=size(BW1);

%% this loop is for dividing the segmented hand image into 4
%  different axis
for i=1:x2  
     for j=1:y2
         if (BW1(i,j)==1 )
           for i1=1:x2  
            for j1=1:y2
            if (BW1(i1,j1)==1) 
                
                if(i1>m && j1<n)
                theta2(i1,j1)=90+atan((n-j1)/(m-i1))*180/pi; %red
%                 theta(i1,j1)=270+atan((n-j1)/(m-i1))*180/pi; %red

                elseif(i1<m && j1<n)
                 theta1(i1,j1)=90+(atan((n-j1)/(m-i1))*180/pi); %green
%                  theta(i1,j1)=90+atan((n-j1)/(m-i1))*180/pi;

                elseif(i1< m && j1>n)
                 theta1(i1,j1)=90+atan((n-j1)/(m-i1))*180/pi; %yellow
%                  theta(i1,j1)=90+atan((n-j1)/(m-i1))*180/pi;
                 

                elseif(i1>m && j1>n)    
                 theta2(i1,j1)=90+(atan((n-j1)/(m-i1))*180/pi); %blue
%                  theta(i1,j1)=270+atan((n-j1)/(m-i1))*180/pi;


                end
             end
            end
           end
         end
     end
end
 theta1=round(theta1); 
 theta2=round(theta2);

%% This loop is to find the max distance between the point 
%  on the edges of the hand passing through the center of the hand
 

for i=1:x2  
     for j=1:y2  
         if (theta1(i,j)>0 )
           for i1=1:x2  
             for j1=1:y2
                if (theta2(i1,j1)>1 )     
                 if(theta1(i,j)==theta2(i1,j1))
                 d4=sqrt(((i-i1).^2+(j-j1).^2));
                    if(d4>=d3)
                        d3=d4;
                        i3=i;
                        j3=j;
                        i4=i1;
                        j4=j1;
                    else
                        d3=d3;
                        i3=i3;
                        j3=j3;
                        i4=i4;
                        j4=j4;
                    end
                end
                end 
              end
            end
          end
     end
 end

 %% drawing line and marking the points on the image

 
 Lx=[j4 j3];

 Ly=[i4 i3];
 
figure
imshow(BW1)
hold on;
plot(n, m, 'r+', 'MarkerSize', 5, 'LineWidth', 3);

hold on;
line(Lx,Ly)
plot(j4,i4, 'g+', 'MarkerSize', 5, 'LineWidth', 3);
plot(j3,i3, 'y+', 'MarkerSize', 5, 'LineWidth', 3);


%% to find the angle between the image X-axis and the perpendicular axis(horizontal and vertical axis)


thetaP=theta1(i3,j3);
thetaD=theta1(i3,j3);
if(thetaP>90)
    thetaP=thetaP-90;
    thetaD=thetaD-90;
elseif(thetaP<90)
     thetaP=(90+thetaP);
     thetaD=-(90-thetaD);
else thetaP=0; 
end   


%% the variables are used to find the approx. angle of the pixel if the exact angle does not exist 


thetaPmin=thetaP-5;
if (thetaPmin<=0)
    thetaPmin=1;
else 
     thetaPmin=thetaPmin;
end     
thetaPmax=thetaP+5;
 
%% the points of the orthogonal axis of the image
 

 [row1,col1] = find (theta1<thetaPmax & theta1>thetaPmin);
 [row2,col2] = find (theta2<thetaPmax & theta2>thetaPmin);
 row1=mean(row1);
 row2=mean(row2);
 col1=mean(col1);
 col2=mean(col2);
 
 Lx=[col2 col1];

 Ly=[row2 row1];
 
hold on;
line(Lx,Ly)
plot(col2,row2, 'g+', 'MarkerSize', 5, 'LineWidth', 3);
plot(col1,row1, 'y+', 'MarkerSize', 5, 'LineWidth', 3);


%% separating the finger region from the rest of the hand 


d1=sqrt(((col1-col2).^2+(row1-row2).^2));
r=mean(d1)/2;
r=r+5;
d=r*2;
px = n-r;
py = m-r;
h = rectangle('Position',[px py d d],'Curvature',[1,1]);
set(h,'edgecolor','b')
daspect([1,1,1])

%% Making a circlr of the acqired radius to remove the palm region for the image

radius=r;
x1=m;
y1=n;
do=sqrt((x1-(x1-radius))^2+(y1-y1)^2);
for i=1:x2
for j=1:y2
if(sqrt((x1-(i))^2+(y1-j)^2)<do)
a(i,j)=1;
else
a(i,j)=0;
end
end
end


a2=BW1-a;
 imshow(a2)

%% Using the above image as a mask calculating the distance 
%  and angle between centre and ever point in the edge image


for i=1:x2  
     for j=1:y2
         if (a2(i,j)==1 )
           for i1=1:x2  
            for j1=1:y2
            if (a2(i1,j1)==1) 
                
                if(i1>=m && j1<=n)
                
                theta(i1,j1)=270+atan((n-j1)/(m-i1))*180/pi; %red
                dist(i1,j1)=sqrt(((i-i1).^2+(j-j1).^2));
                   
                elseif(i1<=m && j1<n)
                 dist(i1,j1)=sqrt(((i-i1).^2+(j-j1).^2));
                 theta(i1,j1)=90+atan((n-j1)/(m-i1))*180/pi; %green
                 

                elseif(i1<m && j1>=n)
                 dist(i1,j1)=sqrt(((i-i1).^2+(j-j1).^2));   %yellow
                 theta(i1,j1)=90+atan((n-j1)/(m-i1))*180/pi;
                 

                elseif(i1>m && j1>n)    
                 dist(i1,j1)=sqrt(((i-i1).^2+(j-j1).^2));
                 theta(i1,j1)=270+atan((n-j1)/(m-i1))*180/pi;  %blue
                 

                end
             end
            end
           end
         end
     end
end

dist=round(dist);
theta=round(theta);


%% Eliminating the region below the fingers using the angle between 0-210 and 330-360

for i=1:x2
    for j=1:y2
        if(theta(i,j)>210 && theta(i,j)<330)
       
        theta(i,j)=0;
        else 
        theta(i,j)=theta(i,j);
        end
    end
end
    
%% making an array of the angle(index of the array) and the distance(from centre to relavant pixel)
dist2=zeros(x,y);
for c=1:360
     [a1,b1]=find(theta==c);
     for i=1:size(a1)
     dist2=(dist(a1(i),b1(i)));
     
     end
     dist1(c)=max(max(dist2));
    
end  


%%changing the origin by 15 degree to compensate for the start 345 degree

distemp=dist1;
t=15;
for c=1:360
        if (t>359)
        dist1(c)=distemp(t-359);
        else 
        dist1(c)=distemp(t);
        end
        t=t+1;
end

%% making a histogram (chosing maximum value for every 5 degree)

% distMax=zeros(72);
count=1;
i=1;
for c=1:360
    if(c==count)
    tempdis=[dist1(c) dist1(c+1) dist1(c+2) dist1(c+3) dist1(c+4)  ];
    distMax(i)=max(tempdis);
    
     count=count+5;
    i=i+1;
    end
end 

%% normalising the finger length with maximum finger length 
Lmax=max(distMax);
distMax=(((distMax-r)/Lmax));
for i=1:72
    if(distMax(i)>0)
    distMax(i)=distMax(i);
    else
     distMax(i)=0;   
    
    end
end 

figure
plot(distMax)

dist=round(dist);
theta=round(theta);


%% Eliminating the region below the fingers using the angle between 0-210 and 330-360

% for i=1:x2
%     for j=1:y2
%         if(theta(i,j)>210 && theta(i,j)<330)
%        
%         theta(i,j)=0;
%         else 
%         theta(i,j)=theta(i,j);
%         end
%     end
% end

thetaC=zeros(x2,y2);
for i=1:x2
    for j=1:y2
        if(theta(i,j)>0)
       
        thetaC(i,j)=1;
        else 
        thetaC(i,j)=0;
        end
    end
end

%% 
r1=5;
r2=7;
r3=10;
area1=69;
area2=145;
area3=305;
num=0;
 c1=zeros(x2,y2);
 c2=zeros(x2,y2);
 c3=zeros(x2,y2);
%  cur_1=zeros(900);
%  cur_2=zeros(900);
%  cur_3=zeros(900);
 for i=1:x2
     for j=1:y2
     if (BW1(i,j)==1)
        num=num+1;
       
 
        for i1=1:x2
        for j1=1:y2
        if(sqrt((i-(i1))^2+(j-j1)^2)<r1) %&& sqrt((x1-(i1))^2+(y1-j1)^2)>r3-1)
            c1(i1,j1)=0;
            else
            c1(i1,j1)=1;
        end
        if(sqrt((i-(i1))^2+(j-j1)^2)<r2) %&& sqrt((x1-(i1))^2+(y1-j1)^2)>r3-1)
            c2(i1,j1)=0;
            else
            c2(i1,j1)=1;
        end
        if(sqrt((i-(i1))^2+(j-j1)^2)<r3) %&& sqrt((x1-(i1))^2+(y1-j1)^2)>r3-1)
            c3(i1,j1)=0;
            else
            c3(i1,j1)=1;
        end
        end
        end
       dif1=b-c1;
        dif2=b-c2;
        dif3=b-c3;
         areadif1  = regionprops(dif1, 'area');
         areadif2  = regionprops(dif2, 'area');
         areadif3  = regionprops(dif3, 'area');
         
         cur_1(num)= (areadif1(1).Area)/(area1);
         cur_2(num)= (areadif2(1).Area)/(area2);
         cur_3(num)= (areadif3(1).Area)/(area3);
        
     end
   
     end
 end
figure
 bin=0.1:0.1:0.9;
% curl=[cur_1,cur_2,cur_3];
%  hisT=hist(curl,bin);
%  hist(curl,bin);
hist1=hist(cur_1,bin);
 
hist2=hist(cur_2,bin);
 
hist3=hist(cur_3,bin);
%  hist(curl,bin);
hisT=[hist1,hist2,hist3];
hist(hisT);
feature=[distMax,hisT];

