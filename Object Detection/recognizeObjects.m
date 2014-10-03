function output_img = recognizeObjects(orig_img, labeled_img, obj_db, name)
[img_db, out_img] = compute2DProperties(orig_img, labeled_img);
%new_labeled_img = zeros(size(labeled_img));
%save(name, 'img_db');
found = zeros(size(img_db,2));
for to_find_ind = 1 : size(obj_db , 2)
    for find_ind = 1 : size(img_db , 2)
        if ( (abs(obj_db(6 , to_find_ind) - img_db(6 , find_ind)) / obj_db(6 , to_find_ind)) < 0.05...
             && (abs(obj_db(7 , to_find_ind) - img_db(7 , find_ind)) / obj_db(7 , to_find_ind)) < 0.05)
            %new_labeled_img(labeled_img == find_ind) = to_find_ind;
            found(find_ind) = 1;
            fprintf('%d matches %d\n', to_find_ind, find_ind);
        end
    end
end
img_db = img_db(: , logical(found));
fh1 = figure;
imshow(orig_img);
hold on
plot((img_db(3,:))', (img_db(2,:))','ws', 'MarkerFaceColor', [1 0 1]);
line_endsx = img_db(2 , :) + 40 .* cos(img_db(5 , :));
line_endsy = img_db(3 , :) + 40 .* sin(img_db(5 , :));
for i = 1 : size(img_db , 2)
    line([img_db(3,i), line_endsy(i)], [img_db(2,i), line_endsx(i)],...
            'LineWidth',4, 'Color', [0, 1, 0]);
end
output_img = saveAnnotatedImg(fh1);

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


