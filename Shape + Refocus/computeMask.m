function mask = computeMask(img_cell)
mask = zeros(size(img_cell{1}));
for i = 1 : size(img_cell , 1)
    mask = mask | im2bw(img_cell{i} , 0.00001);
end