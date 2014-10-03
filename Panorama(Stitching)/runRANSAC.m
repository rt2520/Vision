function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
max_count = 0;
inliers_id = [];
H = [];
for iter = 1 : ransac_n
    rand_ind = randperm(size(Xs , 1) , 4);
    src_pts = Xs(rand_ind , :);
    dest_pts = Xd(rand_ind , :);
    H1 = computeHomography(src_pts , dest_pts);
    Xd_calc = applyHomography(H1 , Xs);
    dist = (Xd(:,1) - Xd_calc(:,1)).^2 + (Xd(:,2) - Xd_calc(:,2)).^2;
    tmp_inliers = find(dist < eps * eps);
    if (size(tmp_inliers , 1) > max_count)
        max_count = size(tmp_inliers , 1);
        inliers_id = tmp_inliers;
        H = H1;
    end
end
