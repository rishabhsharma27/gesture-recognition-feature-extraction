function [ z6 ] = SEG1( depth )


[x,y]=size(depth);

z5=zeros(x,y,3);
z6=zeros(x,y);
theta1=zeros(x+2,y+2);
theta2=zeros(x+2,y+2);


ret2=0;
ret=0;
ret1=0;
minD=mean(min(min(depth(depth>0))));

%% Loop begins
while ret ==0
%     s = find(depth(:,:)> minD & depth(:,:) < minD+100 );
%     [s1,s2]=size(s);
    a58=((find(depth==minD)));
     if (size(a58) < 1200)
         minD=mean(min(min(depth(depth>minD))));
     else
         ret=1;
     end

end
minTh=minD+4;
% [f,g]=imhist(depth,1311);
% g1=max(find(g<=minD))+1;
% 
% if ((f(g1)-f(g1+1))<1000  )
%     minTh=minD+150;
% 
% elseif ((f(g1)-f(g1+1)>1000) && f(g1)-f(g1+1)<2000  )
%     
%     minTh=minD+150;
%     
% elseif (f(g1)-f(g1+1)>2000  )
%     
%     minTh=minD+150;
% end
while ret2==0
for i=1:x  
for j=1:y
if(depth(i,j)>0 && depth(i,j)<minD  )
% z5(i,j,1)=0;
% z5(i,j,2)=0;
% z5(i,j,3)=1;
z6(i,j)=0;
elseif(depth(i,j)>=minD-1 && depth(i,j)<=minTh )
% z5(i,j,1)=1;
% z5(i,j,2)=1;
% z5(i,j,3)=1;
z6(i,j)=1;
elseif(depth(i,j)>minTh)
% z5(i,j,1)=1;
% z5(i,j,2)=0;
% z5(i,j,3)=0;
z6(i,j)=0;

end
end
end

z78=(find(z6<1));
[z78,c]=size(z78);
z78=i*j-z78;
if (z78<1000)
    ret2=0;
    minTh=minTh+50;
else
    ret2=1;
end    
end

for i=1:x  
  for j=1:y
   if(i>= 350 )

    I(i,j)=0;

    else
    I(i,j)=1;


    end
   end
end

z6=z6.*I;
