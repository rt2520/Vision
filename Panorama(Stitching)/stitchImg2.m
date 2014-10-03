function stitched_img = stitchImg2(varargin)
%function stitched_img = stitchImg(imgc , imgl , imgr)

ransac_n = 300;
ransac_eps = 1;

if (~isempty(varargin))
    argc = length(varargin);
    imgc = varargin{1};
else
    display('Zero arguments');
end

xmin = 1; xmax = size(imgc , 2);
ymin = 1; ymax = size(imgc , 1);
imgc_bound_pts = [xmin, ymin ; xmax, ymin ; xmax, ymax ; xmin, ymax];

all_points = [imgc_bound_pts];
H_arr = zeros(3 , 3 , argc);
H_arr(: , : , 1) = eye(3);
for i = 2 : argc
    imgl = varargin{i};
    imgc = varargin{i - 1};
    [xl, xc] = genSIFTMatches(imgl, imgc);
    xmin = 1; xmax = size(imgl , 2);
    ymin = 1; ymax = size(imgl , 1);
    imgl_bound_pts = [xmin, ymin ; xmax, ymin ; xmax, ymax ; xmin, ymax];
    [inliers_id, H_l_c] = runRANSAC(xl, xc, ransac_n, ransac_eps);
    H_arr(: , : , i) = H_arr(: , : , i - 1) * H_l_c;
    imgl_bound_pts_conv = applyHomography(H_arr(: , : , i) , imgl_bound_pts);
    all_points = [all_points ; imgl_bound_pts_conv];
end

%[xr, xc] = genSIFTMatches(imgr, imgc);
%xmin = 1; xmax = size(imgr , 2);
%ymin = 1; ymax = size(imgr , 1);
%imgr_bound_pts = [xmin, ymin ; xmax, ymin ; xmax, ymax ; xmin, ymax];
%[inliers_id, H_r_c] = runRANSAC(xr, xc, ransac_n, ransac_eps);
%imgr_bound_pts_conv = applyHomography(H_r_c , imgr_bound_pts);

%xmin = 1; xmax = size(imgc , 2);
%ymin = 1; ymax = size(imgc , 1);
%imgc_bound_pts = [xmin, ymin ; xmax, ymin ; xmax, ymax ; xmin, ymax];

%all_points = [imgl_bound_pts_conv ; imgc_bound_pts ; imgr_bound_pts_conv];
xmin = min(all_points(:,1));
xmax = max(all_points(:,1));
ymin = min(all_points(:,2));
ymax = max(all_points(:,2));
canvas = zeros(floor(ymax - ymin) + 1, floor(xmax - xmin) + 1, 3);
tx = 1 - xmin; ty = 1 - ymin;
T = [1 0 tx ; 0 1 ty ; 0 0 1];
dest_canvas_width_height = [size(canvas, 2), size(canvas, 1)];

results = cell(1 , argc);
masks = cell(1 , argc);
for i = 1 : argc
    imgl = varargin{i};
    [maskl, dest_imgl] = backwardWarpImg(imgl, inv(T * H_arr(: , : , i)), dest_canvas_width_height);
    masks{i} = ~maskl;
    results{i} = canvas .* cat(3, masks{i}, masks{i}, masks{i}) + dest_imgl;
    fprintf('%d' , i);
    figure, imshow(results{i});
end

stitched_img = im2uint8(results{1});
mask_blend = (~masks{1}) .* 255;
for i = 2: argc
    results{i} = im2uint8(results{i});
    maski = (~masks{i}) .* 255;
    stitched_img = blendImagePair(stitched_img, mask_blend, results{i}, maski, 'blend');
    mask_blend = (logical(mask_blend) | (~masks{i})) .* 255;
end


%[maskr, dest_imgr] = backwardWarpImg(imgr, inv(T * H_r_c), dest_canvas_width_height);
%maskr = ~maskr;
%resultr = canvas .* cat(3, maskr, maskr, maskr) + dest_imgr;
%figure, imshow(resultr);

% 
% [maskc, dest_imgc] = backwardWarpImg(imgc, inv(T), dest_canvas_width_height);
% maskc = ~maskc;
% resultc = canvas .* cat(3, maskc, maskc, maskc) + dest_imgc;
% figure; imshow(resultc);
% 
% resultl = im2uint8(resultl);
% resultc = im2uint8(resultc);
% masklb = (~maskl) .* 255;
% maskcb = (~maskc) .* 255;
% blended_result = blendImagePair(resultl, masklb, resultc, maskcb,...
%     'blend');
% figure, imshow(blended_result);
% 
% resultr = im2uint8(resultr);
% maskrb = (~maskr) .* 255;
% comb_mask = logical(masklb) | logical(maskcb);
% comb_mask = comb_mask .* 255;
% blended_result2 = blendImagePair(resultr, maskrb, blended_result, comb_mask,...
%     'blend');
% figure, imshow(blended_result2);