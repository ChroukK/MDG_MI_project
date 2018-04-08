function scaled_img = image_scale(img, X_dim, Y_dim, Z_dim)
[X Y Z] = size(img);
for z=1:Z
    scaled_img(:,:,z) = imresize(img(:,:,z), [X_dim Y_dim]); 
end
%slices = (Z_dim - Z) / 2; 
%scaled_img = scaled_img(:,:,1+slices:Z-slices); 
end 
