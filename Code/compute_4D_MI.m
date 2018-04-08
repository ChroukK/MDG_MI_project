% Calculation of MI using normalized joint histograms
function MI = compute_4D_MI(d1_vector, d2_vector, d3_vector, d4_vector, bins)
%tic
d1_size = length(d1_vector(:));
d2_size = length(d2_vector(:));
d3_size = length(d3_vector(:));
d4_size = length(d4_vector(:));

data_size = max([d1_size, d2_size, d3_size, d4_size]);

[X Y Z] = size(d1_vector); 

d1_step = (max(d1_vector(:)) - min(d1_vector(:)))/ bins;
d2_step = (max(d2_vector(:)) - min(d2_vector(:)))/ bins;
d3_step = (max(d3_vector(:)) - min(d3_vector(:)))/ bins;
d4_step = (max(d4_vector(:)) - min(d4_vector(:)))/ bins;

joint_4D_hist(bins, bins, bins, bins) = 0;
joint_2D_hist_1(bins, bins) = 0; 
joint_2D_hist_2(bins, bins) = 0; 

for z=1:Z
    for y=1:Y
        for x =1:X
            d1_bin = ceil((d1_vector(x, y, z) - min(d1_vector(:))) / d1_step);
            if(d1_bin == 0)
                d1_bin = 1;
            end
            d2_bin = ceil((d2_vector(x, y, z) - min(d2_vector(:))) / d2_step);
            if(d2_bin == 0)
                d2_bin = 1;
            end
            d3_bin = ceil((d3_vector(x, y, z) - min(d3_vector(:))) / d3_step);
            if(d3_bin == 0)
                d3_bin = 1;
            end
            d4_bin = ceil((d4_vector(x, y, z) - min(d4_vector(:))) / d4_step);
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

%exec_time = toc
end