function acc = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
rho_bins = -rho_num_bins : 0.15 : rho_num_bins;
theta_bins = 0 : 0.04 : pi - 0.04;
acc = zeros(size(rho_bins , 2) , size(theta_bins , 2));
[r , c] = find(img > 0);
acc_rows = size(acc,1);
acc_cols = size(acc,2);
for i = 1 : size(r , 1)
    for theta_ind = 1 : size(acc, 2)
        rho_ind = round(((c(i) * sin(theta_bins(theta_ind)) - r(i) * cos(theta_bins(theta_ind))) + rho_num_bins)/0.15 + 1) ;
%         for row = -rho_ind : 1 : rho_ind
%             for col = -theta_ind : 1 : theta_ind
%                 if (row > 1 && row < acc_rows && col > 1 && col < acc_cols)
%                     acc(row , col) = acc(row,col) + 1;
%                 end
%             end
%         end
        acc(rho_ind,theta_ind) = acc(rho_ind,theta_ind) + 1;
    end
end
acc = (acc ./ max(acc(:))) .* 255;
