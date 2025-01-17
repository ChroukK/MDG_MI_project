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
% geomtform_ct = imregtform(ct_img_001,ct_img_001_ref, mr_t1_img_001, mr_t1_img_001_ref, 'rigid', optimizer, metric);
% prealigned_mr_t1_img_001 = imregister(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref,'rigid', optimizer, metric);
% geomtform_mr = imregtform(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref, 'rigid', optimizer, metric);
% figure
% imshowpair(ct_img_001(:,:,mr_t1_001_centre(3)), prealigned_mr_t1_img_001(:,:,mr_t1_001_centre(3)));
% figure
% imshow3D(prealigned_mr_t1_img_001); 
% 
% figure
% imshowpair(prealigned_ct_img_001(:,:,ct_img_001_centre(3)), mr_t1_img_001(:,:,ct_img_001_centre(3)));
% figure
% imshow3D(prealigned_ct_img_001); 
%% Perturb image
perturbed_mr_t1_img_001 = imtranslate(prealigned_mr_t1_img_001, [0 0], 'FillValues', mode(prealigned_mr_t1_img_001(:)));
%perturbed_mr_t1_img_001 = imrotate3(perturbed_mr_t1_img_001, 16, [1 0 0], 'crop', 'FillValues', mode(prealigned_mr_t1_img_001(:)));
perturbed_mr_t1_img_001 = imrotate3(perturbed_mr_t1_img_001, -8, [0 1 0], 'crop', 'FillValues', mode(prealigned_mr_t1_img_001(:)));
%perturbed_mr_t1_img_001 = imrotate3(perturbed_mr_t1_img_001, -8, [0 0 1], 'crop', 'FillValues', mode(prealigned_mr_t1_img_001(:)));
% perturbed_z_disp_matrix = zeros(512, 512, 28, 3); 
% perturbed_z_disp_matrix(:,:,:,3) = 4; 
% perturbed_mr_t1_img_001 = imwarp(perturbed_mr_t1_img_001, perturbed_z_disp_matrix, 'linear', 'FillValues', mode(perturbed_mr_t1_img_001(:)));
figure
imshow3D(perturbed_mr_t1_img_001); 

f_img = perturbed_mr_t1_img_001(:,:,1:2:28); 
r_img = ct_img_001(:,:,1:2:28);
levels = 4; 

x_trans_region = [1 -20]; 
y_trans_region = [1 -20];
z_trans_region = [1 -11];
r_x_trans_region = [1 -22]; 
r_y_trans_region = [1 -40]; 
r_z_trans_region = [1 -22]; 
S_x_trans_max_I = 0;
S_y_trans_max_I = 0;
S_z_trans_max_I = 0;
S_x_trans_max_I_v = [];
S_y_trans_max_I_v = [];
S_z_trans_max_I_v = [];
S_r_x_trans_max_I = 0;
S_r_y_trans_max_I = 0;
S_r_z_trans_max_I = 0;
S_r_x_trans_max_I_v = [];
S_r_y_trans_max_I_v = [];
S_r_z_trans_max_I_v = [];

for l=1:levels
    if (l == 3)
        break;
    end
    low_res_f_img = impyramid(f_img, 'reduce');
    low_res_r_img = impyramid(r_img, 'reduce');
    for i =1:levels-l
        low_res_f_img = impyramid(low_res_f_img, 'reduce');
        low_res_r_img = impyramid(low_res_r_img, 'reduce');
    end
    [r_img_signed_MDG_field r_img_mag_signed_MDG_field] = compute_MDG_vector_field(low_res_r_img);
% %% Rotations on x-axis
%     MI4d_r_x_trans = [];
%     D_of_T_r_x_trans = [];
%     MI_r_x_trans = []; 
%     S_r_x_tran = [];
%     for r_x = round((S_r_x_trans_max_I+r_x_trans_region(l) -1)+(r_x_trans_region(2)/2^(l-1))):round((S_r_x_trans_max_I+r_x_trans_region(l) -1)-(r_x_trans_region(2)/2^(l-1)))
%         rotated_f_img = imrotate3(low_res_f_img, r_x, [1 0 0], 'crop', 'FillValues', mode(low_res_f_img(:)));
%         [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
%         MI4d_r_x_trans = [MI4d_r_x_trans compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
%         D_of_T_r_x_trans = [D_of_T_r_x_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
%         MI_r_x_trans = [MI_r_x_trans mi(rotated_f_img, low_res_r_img)]; 
%         fprintf('Rotations on x-axis: %d at level :%d\n', r_x, l);
%     end
%     r_x_trans_region = [r_x_trans_region round((S_r_x_trans_max_I+r_x_trans_region(l) -1)+(r_x_trans_region(2)/2^(l-1)))];    
%     S_r_x_tran = MI4d_r_x_trans.*D_of_T_r_x_trans;
%     if(l ==1)
%     r_x_trans_fig_1 = figure
%     else
%     r_x_trans_fig_2 = figure
%     end
%     plot(round((S_r_x_trans_max_I+r_x_trans_region(l) -1)+(r_x_trans_region(2)/2^(l-1))):round((S_r_x_trans_max_I+r_x_trans_region(l) -1)-(r_x_trans_region(2)/2^(l-1))), S_r_x_tran);
%     title(['Level ' num2str(l) ' for x-axis rotations'])
%     %savefig(r_x_trans_fig, [pwd '/registration/level_' num2str(l) '_regis_x_rot']);
%     [S_x_tran_max S_r_x_trans_max_I] = max(S_r_x_tran);
%     S_r_x_trans_max_I_v = [S_r_x_trans_max_I_v S_r_x_trans_max_I];
%     save([pwd '\registration\trial_9_registration_workspace']); 
%     
%% Rotations on y-axis
   MI4d_r_y_trans = [];
    D_of_T_r_y_trans = [];
    MI_r_y_trans = []; 
    S_r_y_tran = [];
    for r_y = round((S_r_y_trans_max_I+r_y_trans_region(l) -1)+(r_y_trans_region(2)/2^(l-1))):round((S_r_y_trans_max_I+r_y_trans_region(l) -1)-(r_y_trans_region(2)/2^(l-1)))
        rotated_f_img = imrotate3(low_res_f_img, r_y, [0 1 0], 'crop', 'FillValues', mode(low_res_f_img(:)));
        [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
        MI4d_r_y_trans = [MI4d_r_y_trans compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
        D_of_T_r_y_trans = [D_of_T_r_y_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
        MI_r_y_trans = [MI_r_y_trans mi(rotated_f_img, low_res_r_img)]; 
        fprintf('Rotations on y-axis: %d at level :%d\n', r_y, l);
    end
    r_y_trans_region = [r_y_trans_region round((S_r_y_trans_max_I+r_y_trans_region(l) -1)+(r_y_trans_region(2)/2^(l-1)))];    
    S_r_y_tran = MI4d_r_y_trans.*D_of_T_r_y_trans;
    if(l==1)
        r_y_trans_fig_1 = figure
    else
        r_y_trans_fig_2 = figure
    end
    plot(round((S_r_y_trans_max_I+r_y_trans_region(l) -1)+(r_y_trans_region(2)/2^(l-1))):round((S_r_y_trans_max_I+r_y_trans_region(l) -1)-(r_y_trans_region(2)/2^(l-1))), S_r_y_tran);
    title(['Level ' num2str(l) ' for y-axis rotations'])
    %savefig(r_y_trans_fig, [pwd '/registration/level_' num2str(l) '_regis_y_rot']);
    [S_x_rot_max S_r_y_trans_max_I] = max(S_r_y_tran);
    S_r_y_trans_max_I_v = [S_r_y_trans_max_I_v S_r_y_trans_max_I];
    save([pwd '\registration\trial_10_registration_workspace']); 

% % Rotations on z-axis
%     MI4d_r_z_trans = [];
%     D_of_T_r_z_trans = [];
%     MI_r_z_trans = []; 
%     S_r_z_tran = [];
%     for r_z = round((S_r_z_trans_max_I+r_z_trans_region(l) -1)+(r_z_trans_region(2)/2^(l-1))):round((S_r_z_trans_max_I+r_z_trans_region(l) -1)-(r_z_trans_region(2)/2^(l-1)))
%         rotated_f_img = imrotate3(low_res_f_img, r_z, [0 0 1], 'crop', 'FillValues', mode(low_res_f_img(:)));
%         [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
%         MI4d_r_z_trans = [MI4d_r_z_trans compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
%         D_of_T_r_z_trans = [D_of_T_r_z_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
%         MI_r_z_trans = [MI_r_z_trans mi(rotated_f_img, low_res_r_img)]; 
%         fprintf('Rotations on z-axis: %d at level :%d\n', r_z, l);
%     end
%     r_z_trans_region = [r_z_trans_region round((S_r_z_trans_max_I+r_z_trans_region(l) -1)+(r_z_trans_region(2)/2^(l-1)))];    
%     S_r_z_tran = MI4d_r_z_trans.*D_of_T_r_z_trans;
%     if(l==1)
%     r_z_trans_fig_1 = figure
%     else
%     r_z_trans_fig_2 = figure
%     end
%     plot(round((S_r_z_trans_max_I+r_z_trans_region(l) -1)+(r_z_trans_region(2)/2^(l-1))):round((S_r_z_trans_max_I+r_z_trans_region(l) -1)-(r_z_trans_region(2)/2^(l-1))), S_r_z_tran);
%     title(['Level ' num2str(l) ' for z-axis rotations'])
%     savefig(r_z_trans_fig, [pwd '/registration/level_' num2str(l) '_regis_z_rot']);
%     [S_z_rot_max S_r_z_trans_max_I] = max(S_r_z_tran);
%     S_r_z_trans_max_I_v = [S_r_z_trans_max_I_v S_r_z_trans_max_I];
%     save([pwd '\registration\trial_8_registration_workspace']); 
%     
%% x-axis translations 
%     MI4d_x_trans = [];
%     D_of_T_x_trans = [];
%     MI_x_trans = []; 
%     S_x_tran = [];
%     for x = round((S_x_trans_max_I+x_trans_region(l) -1)*2^(l-1)+(x_trans_region(2)/2^(l-1))):round((S_x_trans_max_I+x_trans_region(l) -1)*2^(l-1)-(x_trans_region(2)/2^(l-1)))
%         translated_f_img = imtranslate(low_res_f_img, [x 0], 'FillValues', mode(low_res_f_img(:)));
%         [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
%         MI4d_x_trans = [MI4d_x_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
%         D_of_T_x_trans = [D_of_T_x_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
%         MI_x_trans = [MI_x_trans mi(translated_f_img, low_res_r_img)]; 
%         fprintf('Translation on x-axis: %d at level :%d\n', x, l);
%     end
%     x_trans_region = [x_trans_region round((S_x_trans_max_I+x_trans_region(l) -1)*2^(l-1)+(x_trans_region(2)/2^(l-1)))];    
%     S_x_tran = MI4d_x_trans.*D_of_T_x_trans;
%     figure
%     plot(round((S_x_trans_max_I+x_trans_region(l) -1)*2^(l-1)+(x_trans_region(2)/2^(l-1))):round((S_x_trans_max_I+x_trans_region(l) -1)*2^(l-1)-(x_trans_region(2)/2^(l-1))), S_x_tran);
%     title(['Level ' num2str(l) ' for x translations'])
%     %savefig(x_trans_fig, [pwd '/registration/level_' num2str(l) '_regis_x_trans']);
%     [S_x_tran_max S_x_trans_max_I] = max(S_x_tran);
%     S_x_trans_max_I_v = [S_x_trans_max_I_v S_x_trans_max_I];
%     save([pwd '\registration\trans_z_axis_registration_workspace']); 
%     
% %% y-axis translations
%     MI4d_y_trans = [];
%     D_of_T_y_trans = [];
%     MI_y_trans = []; 
%     S_y_tran = [];
%     for y = round((S_y_trans_max_I+y_trans_region(l) -1)*2^(l-1)+(y_trans_region(2)/2^(l-1))):round((S_y_trans_max_I+y_trans_region(l) -1)*2^(l-1)-(y_trans_region(2)/2^(l-1)))
%         translated_f_img = imtranslate(low_res_f_img, [0 y], 'FillValues', mode(low_res_f_img(:)));
%         [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
%         MI4d_y_trans = [MI4d_y_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
%         D_of_T_y_trans = [D_of_T_y_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
%         MI_y_trans = [MI_y_trans mi(translated_f_img, low_res_r_img)]; 
%         fprintf('Translation on y-axis: %d at level :%d\n', y, l);
%     end
%     y_trans_region = [y_trans_region round((S_y_trans_max_I+y_trans_region(l) -1)*2^(l-1)+(y_trans_region(2)/2^(l-1)))];
%     S_y_tran = MI4d_y_trans.*D_of_T_y_trans;
%     figure
%     plot(round((S_y_trans_max_I+y_trans_region(l) -1)*2^(l-1)+(y_trans_region(2)/2^(l-1))):round((S_y_trans_max_I+y_trans_region(l) -1)*2^(l-1)-(y_trans_region(2)/2^(l-1))), S_y_tran);
%     title(['Level ' num2str(l) ' for y translations'])
%     %savefig(y_trans_fig, [pwd '/registration/level_' num2str(l) '_regist_y_trans']);
%     [S_y_tran_max S_y_trans_max_I] = max(S_y_tran);
%     S_y_trans_max_I_v = [S_y_trans_max_I_v S_y_trans_max_I];
%     save([pwd '\registration\trans_z_axis_registration_workspace']); 
%     
%% Z-axis translations
%    
%     MI4d_z_trans = [];
%     D_of_T_z_trans = [];
%     MI_z_trans = []; 
%     S_z_tran = [];
%     [X Y Z] = size(low_res_f_img); 
%     displacement_matrix = zeros(X, Y, Z, 3); 
%     for z = round((S_z_trans_max_I+z_trans_region(l) -1)*2^(l-1)+(z_trans_region(2)/2^(l-1))):round((S_z_trans_max_I+z_trans_region(l) -1)*2^(l-1)-(z_trans_region(2)/2^(l-1)))
%         displacement_matrix(:,:,:,3) = z; 
%         translated_f_img = imwarp(low_res_f_img, displacement_matrix, 'linear', 'FillValues', mode(low_res_f_img(:)));
%         [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
%         MI4d_z_trans = [MI4d_z_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
%         D_of_T_z_trans = [D_of_T_z_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
%         MI_z_trans = [MI_z_trans mi(translated_f_img, low_res_r_img)];
%         fprintf('Translation on z-axis: %d at level :%d\n', z, l);
%     end
%     
%     z_trans_region = [z_trans_region round((S_z_trans_max_I+z_trans_region(l) -1)*2^(l-1)+(z_trans_region(2)/2^(l-1)))];    
%     S_z_tran = MI4d_z_trans.*D_of_T_z_trans;
%     figure
%     plot(round((S_z_trans_max_I+z_trans_region(l) -1)*2^(l-1)+(z_trans_region(2)/2^(l-1))):round((S_z_trans_max_I+z_trans_region(l) -1)*2^(l-1)-(z_trans_region(2)/2^(l-1))), S_z_tran);
%     title(['Level ' num2str(l) ' for z translations'])
%     %savefig(z_trans_fig, [pwd '/registration/level_' num2str(l) '_regis_z_trans']);
%     [S_z_tran_max S_z_trans_max_I] = max(S_z_tran);
%     S_z_trans_max_I_v = [S_z_trans_max_I_v S_z_trans_max_I];
%     save([pwd '\registration\trans_z_axis_registration_workspace']); 
%     
end
