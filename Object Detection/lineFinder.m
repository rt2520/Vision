function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
[r,c] = size(orig_img);
rho_max = sqrt((r * r) + (c *c));
rho = -rho_max : 0.15 : rho_max;
theta = 0 : 0.04 : pi - 0.04;
thresh = hough_threshold * max(hough_img(:));
bw_img = hough_img >= thresh;
[labeled, labels] = bwlabel(bw_img);

line_detected_img = figure;
imshow(orig_img);
hold on
for i = 1:labels
    conn_comp = (labeled == i) .* double(hough_img);
    [row_index_of_max,col_index_of_max] = find(conn_comp == max(conn_comp(:)));
    th = theta(1,1)+(col_index_of_max(1,1)-1) * 0.04;
    rh = rho(1,1)+(row_index_of_max(1,1)-1) * 0.15;
    if (hough_threshold == 0.04)
        x1 = 0;
        y1 = -rh/cos(th);
        x2 = c;
        y2 = (x2 * sin(th) - rh) / cos(th);        
    else
        y1 = 0;
        x1 = rh/sin(th);
        y2 = r;
        x2 = (rh + y2 * cos (th)) / sin(th);
    end
    line ([x1,x2],[y1,y2]);
end
hold off
end