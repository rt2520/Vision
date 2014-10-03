function refocusApp(rgb_stack, depth_map)
%Using imagesc to provide some padding around the image so that the user
%can terminate the prog by clicking outside the bounds
imagesc(uint8(rgb_stack(: , : , 1 : 3)));
curr_img = 1;
while (1)
    [r , c] = ginput(1);
    if (r < 1 || r > size(depth_map , 2) || c < 1 || c > size(depth_map , 1))
        break;
    else
        r = round(r);
        c = round(c);
        foc_img = depth_map(c , r);
        if (foc_img > curr_img)
            for i = curr_img : foc_img
                pause(0.07);
                imagesc(uint8(rgb_stack(: , : , 3 * i - 2 : 3 * i)));
            end
        else
            for i = curr_img : -1 : foc_img
                pause(0.07);
                imagesc(uint8(rgb_stack(: , : , 3 * i - 2 : 3 * i)));
            end
        end
        curr_img = foc_img;
    end
end
close all;