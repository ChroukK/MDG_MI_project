%% Patient 001 Images
% mr_t1_img_001_header  = helperReadHeaderRIRE('header_rectified_mr_t1_001.ascii');
% mr_t1_img_001  = multibandread('image_mr_t1_001_rectified.bin',...
%                             [mr_t1_img_001_header.Rows, mr_t1_img_001_header.Columns, mr_t1_img_001_header.Slices],...
%                             'int16=>single', 0, 'bsq', 'ieee-be' );
% %figure
% %imshow3D(mr_t1_img_001);
% mr_t1_001_centre= round(size(mr_t1_img_001)/2);
% 
% ct_img_001_header  = helperReadHeaderRIRE('header_ct_001.ascii');
% ct_img_001  = multibandread('image_ct_001.bin',...
%                             [ct_img_001_header.Rows, ct_img_001_header.Columns, ct_img_001_header.Slices],...
%                             'int16=>single', 0, 'bsq', 'ieee-be' );
% ct_img_001_ref  = imref3d(size(ct_img_001),ct_img_001_header.PixelSize(2),ct_img_001_header.PixelSize(1),ct_img_001_header.SliceThickness);
% mr_t1_img_001_ref = imref3d(size(mr_t1_img_001),mr_t1_img_001_header.PixelSize(2),mr_t1_img_001_header.PixelSize(1),mr_t1_img_001_header.SliceThickness);
% %figure
% %imshow3D(ct_img_001);
% ct_img_001_centre = round(size(ct_img_001)/2);
% %figure
% %imshowpair(ct_img_001(:,:,ct_img_001_centre(3)), mr_t1_img_001(:,:,mr_t1_001_centre(3)));
% 
% [optimizer,metric] = imregconfig('multimodal');
% optimizer.InitialRadius = 0.004;
% 
% prealigned_ct_img_001 = imregister(ct_img_001,ct_img_001_ref, mr_t1_img_001, mr_t1_img_001_ref, 'rigid', optimizer, metric);
% prealigned_mr_t1_img_001 = imregister(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref,'rigid', optimizer, metric);
% %geomtform = imregtform(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref, 'rigid', optimizer, metric);
% % figure
% % imshowpair(ct_img_001(:,:,mr_t1_001_centre(3)), prealigned_mr_t1_img_001(:,:,mr_t1_001_centre(3)));
% % figure
% % imshow3D(prealigned_mr_t1_img_001); 
% % 
% % figure
% % imshowpair(prealigned_ct_img_001(:,:,ct_img_001_centre(3)), mr_t1_img_001(:,:,ct_img_001_centre(3)));
% % figure
% % imshow3D(prealigned_ct_img_001); 
% %% 4 Levels of Lower Resolution Gaussain Pyramid 
% tic
% 
% r_img_lv_0 = prealigned_mr_t1_img_001(:,:,1:2:26);%512
% r_img_lv_1 = impyramid(r_img_lv_0, 'reduce'); %256 
% r_img_lv_2 = impyramid(r_img_lv_1, 'reduce'); %128
% r_img_lv_3 = impyramid(r_img_lv_2, 'reduce'); %64
% r_img_lv_4 = impyramid(r_img_lv_3, 'reduce'); %32
% 
% %floating image
% f_img_lv_0 =  ct_img_001(:,:,1:2:26); %512
% f_img_lv_1 = impyramid(f_img_lv_0, 'reduce'); %256 
% f_img_lv_2 = impyramid(f_img_lv_1, 'reduce'); %128
% f_img_lv_3 = impyramid(f_img_lv_2, 'reduce'); %64
% f_img_lv_4 = impyramid(f_img_lv_3, 'reduce'); %32
% 
% r_img = r_img_lv_3; 
% f_img = f_img_lv_3;
% bins = 16; 
% [r_img_signed_MDG_field r_img_mag_signed_MDG_field] = compute_MDG_vector_field(r_img);
% %% Translation in x-axis
% MI4d_x_trans = [];
% MI_x_trans = []; 
% D_of_T_x_trans = []; 
% S_x_trans = [];
% x_min = -60;
% x_max = 60;
% for x=x_min:x_max
%     translated_f_img = imtranslate(f_img, [x 0], 'FillValues', mode(f_img(:)));
%     [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
%     MI4d_x_trans = [MI4d_x_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, bins)]; 
%     D_of_T_x_trans = [D_of_T_x_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
%     MI_x_trans = [MI_x_trans mi(translated_f_img, r_img)]; 
%     fprintf('translation x: %d\n', x);
% end
% fprintf('Finished x translations\n'); 
% S_x_trans = MI4d_x_trans.*D_of_T_x_trans;
save([pwd '\output\probing_plots_workspace']);
figure
plot(x_min:x_max,S_x_trans)
title("MI4D*cos Similarity Measure for x translations"); 
figure
plot(x_min:x_max,MI_x_trans)
title("Conventional MI Measure for x translations"); 

saveas(figure(1),[pwd '\output\S_at_level_3_x_trans_prob_plot.fig']); 
saveas(figure(2),[pwd '\output\MI_at_level_3_x_trans_prob_plot.fig']); 
%% Translation in y-axis 
MI4d_y_trans = [];
MI_y_trans = []; 
D_of_T_y_trans = []; 
S_y_trans = []; 
y_min = -60; 
y_max = 60;
for y=y_min:y_max
    translated_f_img = imtranslate(f_img, [0 y], 'FillValues', mode(f_img(:)));
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
    MI4d_y_trans = [MI4d_y_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, bins)]; 
    D_of_T_y_trans = [D_of_T_y_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
    MI_y_trans = [MI_y_trans mi(translated_f_img, r_img)]; 
    fprintf('translation y: %d\n', y);
end
fprintf('Finished y translations\n'); 
S_y_trans = MI4d_y_trans.*D_of_T_y_trans;
save([pwd '\output\probing_plots_workspace']);
figure
plot(y_min:y_max,S_y_trans)
title("MI4D*cos Similarity Measure for y translations"); 
figure
plot(y_min:y_max,MI_y_trans)
title("Conventional MI Measure for y translations"); 

saveas(figure(3),[pwd '\output\S_at_level_3_y_trans_16_bins_prob_plots.fig']); 
saveas(figure(4),[pwd '\output\MI_at_level_3_y_trans_16_bins_prob_plots.fig']); 

%% Translations in Z-axis 
MI4d_z_trans = [];
MI_z_trans = []; 
D_of_T_z_trans = []; 
S_z_trans = [];
[X Y Z] = size(f_img); 
displacement_matrix = zeros(X, Y, Z, 3); 
z_min = -12; 
z_max = 12;
for z=z_min:z_max
    displacement_matrix(:,:,:,3) = z; 
    translated_f_img = imwarp(f_img, displacement_matrix, 'linear', 'FillValues', mode(f_img(:)));
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
    MI4d_z_trans = [MI4d_z_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, bins)]; 
    D_of_T_z_trans = [D_of_T_z_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
    MI_z_trans = [MI_z_trans mi(translated_f_img, r_img, 64)]; 
    fprintf('translation z: %d\n', z);
end
fprintf('Finished z translations\n'); 
S_z_trans = MI4d_z_trans.*D_of_T_z_trans;
save([pwd '\output\probing_plots_workspace']);
figure
plot(z_min:z_max,S_z_trans)
title("MI4D*cos Similarity Measure for z translations"); 
figure
plot(z_min:z_max,MI_z_trans)
title("Conventional MI Measure for z translations"); 

saveas(figure(5),[pwd '\output\S_at_level_3_z_trans_16_bins_prob_plot.fig']); 
saveas(figure(6),[pwd '\output\MI_at_level_3_z_trans_16_bins_prob_plot.fig']); 

%% Rotation in x-axis
MI4d_x_rot = [];
MI_x_rot = []; 
D_of_T_x_rot = []; 
S_x_rot = [];

r_x_min = -60; 
r_x_max = 60;
for r_x=r_x_min:r_x_max
    rotated_f_img = imrotate3(f_img, r_x, [1 0 0], 'crop', 'FillValues', mode(f_img(:))); 
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
    MI4d_x_rot = [MI4d_x_rot compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, bins)];
    D_of_T_x_rot = [D_of_T_x_rot compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)];
    MI_x_rot = [MI_x_rot mi(rotated_f_img, r_img, 64)];
    fprintf('Rotation on x-axis: %d\n', r_x);
end
fprintf('Finished x-axis rotations\n'); 
S_x_rot = MI4d_x_rot.*D_of_T_x_rot;
save([pwd '\output\probing_plots_workspace']);
figure
plot(r_x_min:r_x_max,S_x_rot)
title("MI4D*cos Similarity Measure for x-axis rotations"); 
figure
plot(r_x_min:r_x_max,MI_x_rot)
title("Conventional MI Measure for x-axis rotations"); 

saveas(figure(7),[pwd '\output\S_at_level_3_x_rot_16_bins_prob_plot.fig']); 
saveas(figure(8),[pwd '\output\MI_at_level_3_x_rot_16_bins_prob_plot.fig']); 
%% Rotation in y-axis
MI4d_y_rot = [];
MI_y_rot = []; 
D_of_T_y_rot = []; 
S_y_rot = [];

r_y_min = -60; 
r_y_max = 60;
for r_y=r_y_min:r_y_max
    rotated_f_img = imrotate3(f_img, r_y, [0 1 0], 'crop', 'FillValues', mode(f_img(:))); 
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
    MI4d_y_rot = [MI4d_y_rot compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, bins)]; 
    D_of_T_y_rot = [D_of_T_y_rot compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
    MI_y_rot = [MI_y_rot mi(rotated_f_img, r_img, 64)]; 
    fprintf('Rotation on y-axis: %d\n', r_y);
end
fprintf('Finished y-axis rotations\n'); 
S_y_rot = MI4d_y_rot.*D_of_T_y_rot;
save([pwd '\output\probing_plots_workspace']);
figure
plot(r_y_min:r_y_max,S_y_rot)
title("MI4D*cos Similarity Measure for y-axis rotations"); 
figure
plot(r_y_min:r_y_max,MI_y_rot)
title("Conventional MI Measure for y-axis rotations"); 

saveas(figure(9),[pwd '\output\S_at_level_3_y_rot_16_bins_prob_plot.fig']); 
saveas(figure(10),[pwd '\output\MI_at_level_3_y_rot_16_bins_prob_plot.fig']); 
%% Rotations in z-axis
MI4d_z_rot = [];
MI_z_rot = []; 
D_of_T_z_rot = []; 
S_z_rot = [];

r_z_min = -60; 
r_z_max = 60;
for r_z=r_z_min:r_y_max
    rotated_f_img = imrotate3(f_img, r_z, [0 0 1], 'crop', 'FillValues', mode(f_img(:))); 
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
    MI4d_z_rot = [MI4d_z_rot compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, bins)]; 
    D_of_T_z_rot = [D_of_T_z_rot compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
    MI_z_rot = [MI_z_rot mi(rotated_f_img, r_img, 64)]; 
    fprintf('Rotation on z-axis: %d\n', r_z);
end
fprintf('Finished z-axis rotations\n'); 
S_z_rot = MI4d_z_rot.*D_of_T_z_rot;
save([pwd '\output\probing_plots_workspace']);
figure
plot(r_z_min:r_y_max,S_z_rot)
title("MI4D*cos Similarity Measure for z-axis rotations"); 
figure
plot(r_z_min:r_y_max,MI_z_rot)
title("Conventional MI Measure for z-axis rotations"); 

saveas(figure(11),[pwd '\output\S_at_level_3_z_rot_16_bins_prob_plot.fig']); 
saveas(figure(12),[pwd '\output\MI_at_level_3_z_rot_16_bins_prob_plot.fig']); 

probing_exec_time = toc 