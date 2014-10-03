function [center, radius] = findSphere(img)
char_fn = logical(im2bw(img, 0.000001));
area = sum(char_fn(:));
[r,c] = find(char_fn > 0);
cent_x = sum(c)/area;
cent_y = sum(r)/area;
%fh1 = figure;
%imshow(img);
%hold on
%plot(cent_x, cent_y,'ws', 'MarkerFaceColor', [1 0 1]);
center = [cent_x cent_y];
radius = sqrt(area / pi);