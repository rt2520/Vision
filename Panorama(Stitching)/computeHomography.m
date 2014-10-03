function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
A = [];
for i = 1 : size(src_pts_nx2 , 1)
    A = [A ; src_pts_nx2(i,1) src_pts_nx2(i,2) 1 0 0 0 -dest_pts_nx2(i,1) * src_pts_nx2(i,1) -dest_pts_nx2(i,1) * src_pts_nx2(i,2) -dest_pts_nx2(i,1)];
    A = [A ; 0 0 0 src_pts_nx2(i,1) src_pts_nx2(i,2) 1 -dest_pts_nx2(i,2) * src_pts_nx2(i,1) -dest_pts_nx2(i,2) * src_pts_nx2(i,2) -dest_pts_nx2(i,2)];
end
pseudo_inv_A = A' * A;
[V , D] = eig(pseudo_inv_A);
H_3x3 = [V(1:3 , 1)' ; V(4:6 , 1)' ; V(7:9 , 1)'];

