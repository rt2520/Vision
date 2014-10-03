function index_map = generateIndexMap(gray_stack, w_size)
sml_values = zeros(size(gray_stack));
win_filter = ones(2 * w_size + 1);
smooth_filter = ones(25) / 625;
for k = 1 : size(gray_stack , 3)
    mod_f2x = abs(imfilter(gray_stack(: , : , k), [-1 2 -1], 'replicate'));
    mod_f2y = abs(imfilter(gray_stack(: , : , k), [-1 ; 2 ; -1], 'replicate'));
    ml = mod_f2x + mod_f2y;
    sml_values(: , : , k) = imfilter(ml, win_filter, 'replicate');
    %Reducing noise
    sml_values(: , : , k) = imfilter(sml_values(: , : , k) , smooth_filter, 'replicate');
end
%I tried smoothing the focus measure along the third dimension but it makes
%the prog very slow and even without doing it the results were no
%different.
%     for r = 1 : size(gray_stack , 1)
%         for c = 1 : size(gray_stack , 2)
%             v = sml_values(r , c , :);
%             v = imfilter(v, ones(3 , 1)/3, 'replicate');    
%             sml_values(r , c , :) = v;
%         end
%     end
[max_val , index_map] = max(sml_values , [] , 3);




