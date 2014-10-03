function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
comb_img = [orig_img warped_img];
[rs , cs , channels] = size(orig_img);
dest_pts_translated = [(dest_pts_nx2(: , 1) + cs) dest_pts_nx2(: , 2)];
%comb_pts = [src_pts_nx2 ; dest_pts_translated];
fh1 = figure();
imshow(comb_img);
hold on
for i = 1 : size(src_pts_nx2 , 1)
    line([src_pts_nx2(i , 1) , dest_pts_translated(i , 1)] , [src_pts_nx2(i , 2) , dest_pts_translated(i , 2),],...
        'LineWidth',1, 'Color', [1, 0, 0]);
end
result_img = saveAnnotatedImg(fh1);


function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;