function [MDG_field_dir, sources_ind, I_v_bar, signed_MDG_feature_field, mag_signed_MDG_field] = compute_MDG_vector_field(img)

I_source = img;
[X Y Z] = size(img);

dist_matrix = []; 
sources_ind = [];

for v_z_dist=1:Z
    for v_y_dist=1:Y
        for v_x_dist=1:X
            dist_matrix = [dist_matrix ;[v_x_dist v_y_dist v_z_dist]];
        end
    end
end
fprintf('Generated the distance Matrix\n');

for v_z=1:Z
    for v_y=1:Y
        for v_x=1:X
            int_diff =  abs(I_source - img(v_x,v_y,v_z));% |I(v') - I(v)| 
            dist_diff= bsxfun(@minus,dist_matrix, [v_x v_y v_z]);
            dist_mag = sqrt(sum(dist_diff.^2,2));
            dist_mag = reshape(dist_mag, [X Y Z]); 

            source_matrix = int_diff./dist_mag;
            [I_v_bar_max x_ind] = max(source_matrix);
            [I_v_bar_max y_ind] = max(I_v_bar_max);
            [I_v_bar_max z_ind] = max(I_v_bar_max);
            x_src = x_ind(1,y_ind(z_ind),z_ind);
            y_src = y_ind(1,1,z_ind);
            z_src = z_ind;
            I_v_bar(v_x, v_y, v_z) = img(x_src, y_src, z_src);
            sources_ind = [sources_ind ;[x_src, y_src, z_src]];
        end
    end
    fprintf('Finished slice=%d\n', v_z);
end


dist_direction =  sources_ind - dist_matrix ; %(v' - v)
direction_mag = sqrt(sum(dist_direction.^2, 2)); % |v' -v|
dist_denom = reshape(direction_mag, [X Y Z]); 
MDG_field_dir = dist_direction ./ repmat(direction_mag,1, 3); % norm
abs_mag_signed_MDG_field = abs(I_v_bar - img)./ dist_denom; % |I_v_bar - I_v|/|v' -v|

mag_signed_MDG_field = sign(I_v_bar - img).*abs_mag_signed_MDG_field; 
signed_MDG_feature_field =  MDG_field_dir .* repmat(mag_signed_MDG_field(:), 1, 3);

img_centre = round(size(img)/2);
x_dir_grad = reshape(signed_MDG_feature_field(X*Y*(img_centre(3)-1)+1:(img_centre(3)*X*Y),1), X, Y);
y_dir_grad = reshape(signed_MDG_feature_field(X*Y*(img_centre(3)-1)+1:(img_centre(3)*X*Y),2), X, Y);

figure
quiver(1:X,1:Y, x_dir_grad, y_dir_grad);

end