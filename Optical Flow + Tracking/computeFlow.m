function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
    img1 = double(img1);
    img2 = double(img2);
    img1_pad = padarray(img1 , [template_radius, template_radius]);
    img2_pad = padarray(img2 , [win_radius, win_radius]);
    step_size = size(img1) ./ grid_MN;
    step_size_x = floor(step_size(2));
    step_size_y = floor(step_size(1));
    pts_to_compute_x = 1 : step_size_x : size(img1, 2);
    pts_to_compute_y = 1 : step_size_y : size(img1, 1);    
    x = zeros(1, size(pts_to_compute_x, 2) * size(pts_to_compute_y, 2));
    y = zeros(size(x));
    u = zeros(size(x));
    v = zeros(size(x));
    index = 1;
    for i1 = 1 : size(pts_to_compute_y, 2)
        i = pts_to_compute_y(i1);
        for j1 = 1 : size(pts_to_compute_x, 2)
            j = pts_to_compute_x(j1);
            template = img1_pad(i : i + 2 * template_radius , j : j + 2 * template_radius);
            target = img2_pad(i : i + 2 * win_radius , j : j + 2 * win_radius);
            corr_mat = normxcorr2(template, target);
            %To account for normxcorr2 padding
            corr_mat = corr_mat(template_radius + 1 : size(corr_mat, 1) - template_radius , template_radius + 1 : size(corr_mat, 2) - template_radius);
            [max_y_v , max_x_v] = find(corr_mat == max(corr_mat(:)));
            %Many possible points of matches, Taking the approx center of
            %those
            max_y = floor(mean(max_y_v));
            max_x = floor(mean(max_x_v));
            
            %i_target = max_y - size(template, 1) + 1;
            %j_target = max_x - size(template, 2) + 1;
            i_dash = max_y - win_radius + i - 1;
            j_dash = max_x - win_radius + j - 1;
            x(index) = j;
            y(index) = i;
            u(index) = j_dash - j;
            %u(index) = 0;
            v(index) = i_dash - i;
            %v(index) = 3;
            index = index + 1;
        end
    end
    fh = figure();
    imshow(uint8(img1));
    hold on
    quiver(x,y,u,v,0);
    result = saveAnnotatedImg(fh);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;
end