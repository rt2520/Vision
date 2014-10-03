function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
if strcmp(mode , 'blend')
    dtranss = bwdist(~logical(masks));
    dtransd = bwdist(~logical(maskd));
    dtranss = dtranss ./ max(dtranss(:));
    dtransd = dtransd ./ max(dtransd(:));
    %figure;imshow(dtranss);
    %do the following only where dtranss + dtransd != 0
    %alpha1 = dtranss ./ (dtranss + dtransd);
    %alpha2 = 1-alpha;
    dtrans_sum = dtranss + dtransd;
    non_zero_ind = find(dtrans_sum > 0);
    wrapped_imgs = double(wrapped_imgs);
    wrapped_imgd = double(wrapped_imgd);
    out_img = zeros(size(wrapped_imgs));
    for i = 1 : 3
        out_img(: , : , i) = wrapped_imgs(: , : , i) .* dtranss + wrapped_imgd(: , : , i) .* dtransd;
    end
    red_channel = out_img(: , : , 1);
    green_channel = out_img(: , : , 2);
    blue_channel = out_img(: , : , 3);
    red_channel(non_zero_ind) = red_channel(non_zero_ind) ./ dtrans_sum(non_zero_ind);
    green_channel(non_zero_ind) = green_channel(non_zero_ind) ./ dtrans_sum(non_zero_ind);
    blue_channel(non_zero_ind) = blue_channel(non_zero_ind) ./ dtrans_sum(non_zero_ind);
    out_img(: , : , 1) = red_channel;
    out_img(: , : , 2) = green_channel;
    out_img(: , : , 3) = blue_channel;
    out_img = uint8(out_img);
end



if strcmp(mode , 'overlay')
    out_img = wrapped_imgs;
    maskd = logical(maskd);
    maskd = ~maskd;
    out_img = double(out_img) .* cat(3, maskd, maskd, maskd) + double(wrapped_imgd);
    out_img = uint8(out_img);
end
