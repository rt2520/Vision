function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
[r1,c] = size(orig_img);
rho_max = sqrt(r1^2 + c^2);
total = size(hough_img,1);
rho_delta =  2 * rho_max / (total-1);
rho = -rho_max:rho_delta:rho_max;

theta = 0:0.04:pi - 0.04;
bw = hough_img >= (hough_threshold*max(hough_img(:)));
[labeled_img, num] = bwlabel(bw);

labeled = edge(orig_img, 'canny', 0.15);
labeled = bwmorph(labeled, 'dilate', 2);

cropped_line_img=figure;
imshow(orig_img);
hold on

%x1 = [];
%y1 = [];

for n = 1:num
    conn_comp = (labeled_img == n) .* double(hough_img);
    
    [maxval, row_index_of_max] = max(conn_comp);
    [val12, max_col] = max(maxval);
    t = theta(1,1)+(max_col(1,1)-1)*0.04;
    tmp = row_index_of_max(max_col);
    rh = rho(1,1)+(tmp-1)*0.15;
    x = [];
    y = [];
    dist = [];
    if (hough_threshold ~= 0.04)
        for j = 1:1:size(orig_img,2)
            yt = (j*sin(t)-rh)/cos(t);
            tmp = round(yt);
            if (j >= 1 && j <= size(labeled,2) && tmp >= 1 && tmp <= size(labeled,1))
                if (labeled(tmp,j) > 0 )
                    x = [x j];
                    y = [y tmp];
                    dist = [dist tmp^2+j^2];
                    plot(j,tmp,'yo');
                end
            end
        end
    else
        for j = 1:1:size(orig_img,2)
            yt = (j*sin(t)-rh)/cos(t);
            tmp = round(yt);
            if (j >= 1 && j <= size(labeled,2) && tmp >= 1 && tmp <= size(labeled,1))
                if (labeled(tmp,j) > 0 )
                    x = [x j];
                    y = [y tmp];
                    dist = [dist j^2+tmp^2];
                end
            end
        end
        for i = 1:1:size(orig_img,1)
        xt = (rh+i*cos(t))/sin(t);
        tmp1 = round(xt);
        if (i >= 1 && i <= size(labeled,1) && tmp1 >= 1 && tmp1 <= size(labeled,2))
                if (labeled(i,tmp1) > 0 )
                    y = [y i];
                    x = [x tmp1];
                    dist = [dist tmp1^2+i^2];
                end
        end
        end
    if (size(x,2) == size(y,2) && size(x,2) > 80)
        [val_min, ind_min] = min(dist);
        [val_max, ind_max] = max(dist);
        line([x(ind_min),x(ind_max)],[y(ind_min), y(ind_max)]);
    end
    end
end
hold off
end