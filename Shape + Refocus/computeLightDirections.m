function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)
light_dirs_5x3 = zeros(size(img_cell , 1) , 3);
for i = 1 : size(img_cell , 1)
    I_max = max(img_cell{i}(:));
    [r , c] = find(img_cell{i} == I_max);
    s_x = mean(c);
    s_y = mean(r);
    %Please read the readme for explaination of this formula
    s_z = sqrt(radius ^ 2 - (s_x - center(1)) ^ 2 - (s_y - center(2)) ^ 2);
    N = [s_x - center(1) s_y - center(2) s_z];
    %N = [s_x - center(1) s_y - center(2) 1];
    light_dirs_5x3(i , :) = (N / norm(N)) * double(I_max);
    %fh1 = figure;
    %imshow(img_cell{i});
    %hold on;
    %plot(s_x , s_y , 'yo' , 'MarkerFaceColor' , [1 0 0]);
end