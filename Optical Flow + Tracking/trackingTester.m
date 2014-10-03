function trackingTester(data_params, tracking_params)
    out_dir = strcat(data_params.data_dir, '_results');
    mkdir(out_dir);
    ref_img = im2double(imread(fullfile(data_params.data_dir,...
                        data_params.genFname(data_params.frame_ids(1)))));
    rect = tracking_params.rect;
    ref_img_dash = drawBox(ref_img, rect, [1 0 0], 3);
    cd (out_dir);
    imwrite(ref_img_dash, data_params.genFname(data_params.frame_ids(1)));
    cd ..;
    
    xmin = rect(1);
    ymin = rect(2);
    width = rect(3);
    height = rect(4);
    
    %Weighted histogram kernel
    p_x = 1 : width;
    p_y = 1 : height;
    %Works because width and height are odd
    W = (width - 1) / 2;
    H = (height - 1) / 2;
    c_x = 1 + W;
    c_y = 1 + H;
    x_bar = (p_x - c_x) ./ W;
    y_bar = (p_y - c_y) ./ H;
    ep_kernel = zeros(height , width, 3);
    for i = 1 : height
        for j = 1 : width
            norm_x_bar = x_bar(j) * x_bar(j) + y_bar(i) * y_bar(i);
            if (norm_x_bar < 1)
                ep_kernel(i , j , 1) = 1 - norm_x_bar;
            end
        end
    end
    ep_kernel(: , : , 2) = ep_kernel(: , : , 1);
    ep_kernel(: , : , 3) = ep_kernel(: , : , 1);        
       
    ref_obj = ref_img(ymin : ymin + height - 1 , xmin : xmin + width - 1, :);
    ref_obj = ref_obj .* ep_kernel;
    [hist_img , map] = rgb2ind(ref_obj, tracking_params.bin_n);
    [ref_hist , ~] = hist(double(hist_img(:)), tracking_params.bin_n);
    ref_hist = double(ref_hist);
    ref_mean = mean(ref_hist);
    mean_shifted_normalized_ref_hist = (ref_hist - ref_mean);
    mean_shifted_normalized_ref_hist = mean_shifted_normalized_ref_hist ./ sqrt(sum(mean_shifted_normalized_ref_hist .^ 2));
    
    for img_ind = 2 : size(data_params.frame_ids, 2)
    %for img_ind = 6 : 10
        target_img = im2double(imread(fullfile(data_params.data_dir,...
                        data_params.genFname(data_params.frame_ids(img_ind)))));
        wind_min_x = xmin + (width + 1)/2 - tracking_params.search_half_window_size(1);
        wind_min_y = ymin + (height + 1)/2 - tracking_params.search_half_window_size(2);
        best_match = -1;
        best_i = 0;
        best_j = 0;
        for i = 0 : 2 * tracking_params.search_half_window_size(2) - height + 1
            if ((wind_min_y + i) <= size(target_img,1) && (wind_min_y + i) > 0 ...
                && (wind_min_y + i + height - 1) <= size(target_img,1) && (wind_min_y + i + height - 1) > 0)
                for j = 0 : 2 * tracking_params.search_half_window_size(1) - width + 1
                    if ((wind_min_x + j + width - 1) <= size(target_img,2) && (wind_min_x + j + width - 1) > 0 ...
                            && (wind_min_x + j) <= size(target_img,2) && (wind_min_x + j) > 0)
                        target_obg = target_img(wind_min_y + i : wind_min_y + i + height - 1 , wind_min_x + j : wind_min_x + j + width - 1, :);
                        target_obg = target_obg .* ep_kernel;
                        [hist_img , ~] = rgb2ind(target_obg, map);
                        [target_hist , ~] = hist(double(hist_img(:)), tracking_params.bin_n);
                        target_hist = double(target_hist);
                        target_mean = mean(target_hist);
                        mean_shifted_normalized_target_hist = (target_hist - target_mean);
                        mean_shifted_normalized_target_hist = mean_shifted_normalized_target_hist ./ sqrt(sum(mean_shifted_normalized_target_hist .^ 2));
                        metric = sum(mean_shifted_normalized_target_hist .* mean_shifted_normalized_ref_hist);
                        if (metric > best_match)
                            best_match = metric;
                            best_i = i;
                            best_j = j;
                        end            
                    end
                end
            end
        end
        rect = [wind_min_x + best_j wind_min_y + best_i width height];
        xmin = rect(1);
        ymin = rect(2);
        width = rect(3);
        height = rect(4);
        
        %ref_obj = target_img(wind_min_y + best_i : wind_min_y + best_i + height - 1 , wind_min_x + best_j : wind_min_x + best_j + width - 1, :);
%         ref_obj = ref_obj .* ep_kernel;
%         [hist_img , map] = rgb2ind(ref_obj, tracking_params.bin_n);
%         [ref_hist , ~] = hist(double(hist_img(:)), tracking_params.bin_n);
%         ref_hist = double(ref_hist);
%         ref_mean = mean(ref_hist);
%         mean_shifted_normalized_ref_hist = (ref_hist - ref_mean);
%         mean_shifted_normalized_ref_hist = mean_shifted_normalized_ref_hist ./ sqrt(sum(mean_shifted_normalized_ref_hist .^ 2));
        
        
        target_img = drawBox(target_img, rect, [1 0 0], 3);
        %figure;
        %imshow(target_img);
        cd (out_dir);
        imwrite(target_img, data_params.genFname(data_params.frame_ids(img_ind)));
        cd ..;        
    end
end
