function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
tmp = (H_3x3 * [src_pts_nx2'; ones(1 , size(src_pts_nx2 , 1))]);
dest_pts_nx2 = [(tmp(1 , :) ./ tmp(3 , :))' (tmp(2 , :) ./ tmp(3 , :))'];

