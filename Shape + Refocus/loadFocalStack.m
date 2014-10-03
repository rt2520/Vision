function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
 cd(focal_stack_dir);
 img = imread('frame1.jpg');
 rgb_stack = zeros(size(img , 1) , size(img , 2) , 75);
 gray_stack = zeros(size(img , 1) , size(img , 2) , 25);
 rgb_stack(: , : , 1 : 3) = img;
 gray_stack(: , : , 1) = rgb2gray(img);
 for i = 2 : 25
     img = imread(sprintf('frame%d.jpg' , i));
     rgb_stack(: , : , 3 * i - 2 : 3 * i) = img;
     gray_stack(: , : , i) = rgb2gray(img);
 end
cd('..');