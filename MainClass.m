%% 1
data1 = imread(['name.png']);              %read a depth image for the folder(replace 'name' by the image name)
[ z1] = SEG1( data1 );                     %get back the segmented image back from the depth image
[ feature1 ] = FeatureExtraction( z1 );    %get back the feature back from the segmented image

%just for your reference i have separated the 2 features
%the description of these features is given in the document. 

distance_features = feature1(1:72);         
 
curvature_features = feature1(73:99);