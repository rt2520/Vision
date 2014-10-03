function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
xmin = 1; xmax = size(src_img , 2);
ymin = 1; ymax = size(src_img , 1);
src_pts = [xmin, ymin ; xmax, ymin ; xmax, ymax ; xmin, ymax];
srcToResult_H = inv(resultToSrc_H);
bg_pts = applyHomography(srcToResult_H , src_pts);
mask = poly2mask((bg_pts(:,1))' , (bg_pts(:,2))' , dest_canvas_width_height(2) , dest_canvas_width_height(1));
[r,c] = find(mask > 0);
bg_points_of_interest = [c,r];
src_points_of_interest = uint32(applyHomography(resultToSrc_H , bg_points_of_interest));
src_points_of_interest(src_points_of_interest == 0) = 1;
cols = src_points_of_interest(: , 1);
rows = src_points_of_interest(: , 2);
cols(cols > size(src_img , 2)) = size(src_img , 2);
rows(rows > size(src_img , 1)) = size(src_img , 1);
src_points_of_interest = [cols , rows];
result_img = zeros(dest_canvas_width_height(2) , dest_canvas_width_height(1) , 3);
for i = 1 : size(src_points_of_interest , 1)
    %for color = 1 : 3
        result_img(bg_points_of_interest(i , 2) , bg_points_of_interest(i , 1) , :)...
                = src_img(src_points_of_interest(i , 2) , src_points_of_interest(i , 1) , :);
    %end
end