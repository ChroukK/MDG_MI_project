% Calculation of MI using normalized joint histograms
function [joint_4D_hist, MI] = compute_4D_MI(d1_vector, d2_vector, d3_vector, d4_vector, bins)
tic
d1_size = length(d1_vector(:));
d2_size = length(d2_vector(:));
d3_size = length(d3_vector(:));
d4_size = length(d4_vector(:));

data_size = max([d1_size, d2_size, d3_size, d4_size]);

if(d1_size == data_size)
    [X Y Z] = size(d1_vector);
elseif(d2_size == data_size)
    [X Y Z] = size(d2_vector);
elseif(d3_size == data_size)
    [X Y Z] = size(d3_vector);
else
    [X Y Z] = size(d4_vector);
end

[d1_X d1_Y d1_Z] = size(d1_vector);
d1_X_factor = X/d1_X;
d1_Y_factor = Y/d1_Y;
d1_Z_factor = Z/d1_Z;

[d2_X d2_Y d2_Z] = size(d2_vector);
d2_X_factor = X/d2_X;
d2_Y_factor = Y/d2_Y;
d2_Z_factor = Z/d2_Z;

[d3_X d3_Y d3_Z] = size(d3_vector);
d3_X_factor = X/d3_X;
d3_Y_factor = Y/d3_Y;
d3_Z_factor = Z/d3_Z;

[d4_X d4_Y d4_Z] = size(d4_vector);
d4_X_factor = X/d4_X;
d4_Y_factor = Y/d4_Y;
d4_Z_factor = Z/d4_Z;

d1_step = (max(d1_vector(:)) - min(d1_vector(:)))/ bins;
d2_step = (max(d2_vector(:)) - min(d2_vector(:)))/ bins;
d3_step = (max(d3_vector(:)) - min(d3_vector(:)))/ bins;
d4_step = (max(d4_vector(:)) - min(d4_vector(:)))/ bins;

joint_4D_hist(bins, bins, bins, bins) = 0;
joint_2D_hist_1(bins, bins) = 0; 
joint_2D_hist_2(bins, bins) = 0; 

i = 0;
for z=1:Z
    for y=1:Y
        for x =1:X
            d1_bin = ceil((d1_vector(ceil(x/d1_X_factor), ceil(y/d1_Y_factor), ceil(z/d1_Z_factor)) - min(d1_vector(:))) / d1_step);
            if(d1_bin == 0)
                d1_bin = 1;
            end
            d2_bin = ceil((d2_vector(ceil(x/d2_X_factor), ceil(y/d2_Y_factor), ceil(z/d2_Z_factor)) - min(d2_vector(:))) / d2_step);
            if(d2_bin == 0)
                d2_bin = 1;
            end
            d3_bin = ceil((d3_vector(ceil(x/d3_X_factor), ceil(y/d3_Y_factor), ceil(z/d3_Z_factor)) - min(d3_vector(:))) / d3_step);
            if(d3_bin == 0)
                d3_bin = 1;
            end
            d4_bin = ceil((d4_vector(ceil(x/d4_X_factor), ceil(y/d4_Y_factor), ceil(z/d4_Z_factor)) - min(d4_vector(:))) / d4_step);
            if(d4_bin == 0)
                d4_bin = 1;
            end
            joint_4D_hist(d1_bin, d2_bin, d3_bin, d4_bin) = joint_4D_hist(d1_bin, d2_bin, d3_bin, d4_bin) + 1;
            joint_2D_hist_1(d1_bin, d2_bin) = joint_2D_hist_1(d1_bin, d2_bin) + 1;
            joint_2D_hist_2(d3_bin, d4_bin) = joint_2D_hist_2(d3_bin, d4_bin) + 1;
        end
    end
end
joint_4D_prob = joint_4D_hist/data_size;
joint_2D_prob_1 = joint_2D_hist_1/data_size; 
joint_2D_prob_2 = joint_2D_hist_2/data_size; 

MI = find_entropy(joint_2D_prob_1) + find_entropy(joint_2D_prob_2) - find_entropy(joint_4D_prob);

exec_time = toc
end