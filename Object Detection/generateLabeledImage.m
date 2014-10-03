function labeled_img = generateLabeledImage(gray_img, threshold)
bw_img = im2bw(gray_img, threshold);
labeled_img = bwlabel(logical(bw_img), 8);