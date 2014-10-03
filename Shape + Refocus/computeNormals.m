function [normals, albedo_img] = ...
    computeNormals(light_dirs, img_cell, mask)
S = zeros(size(img_cell , 1) , 3);
I = zeros(size(img_cell , 1) , 1);
normals = zeros(size(img_cell{1} , 1) , size(img_cell{1} , 2) , 3);
albedo_img = zeros(size(img_cell{1} ,  1) , size(img_cell{1} ,  2));
I_max = zeros(size(img_cell , 1) , 1);
for i = 1 : size(img_cell , 1)
    I_max(i) = double(max(img_cell{i}(:)));
end
for r = 1 : size(img_cell{1} , 1)
    for c = 1 : size(img_cell{1} , 2)
        if (mask(r , c) ~= 0)
            for i = 1 : size(img_cell , 1)
                %directional ligt
                %S(i , :) = light_dirs(i , :);
                %Divide the light dir by the max intensity to get unit
                %direction
                S(i , :) = light_dirs(i , :) / I_max(i);
                %Divide the intensity at a pixel by max intensity to
                %accomodate for different intensity of the light sources
                I(i) = double(img_cell{i}(r , c)) / I_max(i);
                %I(i) = double(img_cell{i}(r , c));
            end
            %[I , ind] = sort(I , 'descend');
            %I_top3 = [I(1) ; I(2) ; I(3)];
            %S_top3 = [S(ind(1) , :) ; S(ind(2) , :) ; S(ind(3) , :)];
            %N = S_top3 \ I_top3;
            %Computing the solution by finding the pseudo inverse solution
            %using all the light sources
            N = S \ I;
            two_norm = norm(N);
            albedo_img(r , c) = two_norm;
            if (two_norm ~= 0)
                normals(r , c , :) = N / two_norm;
            end
        else
            %Where mask = 0 or at background points, I assume the normal is
            %looking along the z axis towards the image plane
            albedo_img(r , c) = 0;
            normals(r , c , :) = [0 , 0 , 1];
        end
    end
end
albedo_img = albedo_img / max(albedo_img(:));