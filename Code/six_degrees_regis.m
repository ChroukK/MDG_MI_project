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
perturbed_mr_t1_img_001 = imrotate3(perturbed_mr_t1_img_001, 16, [1 0 0], 'crop', 'FillValues', mode(prealigned_mr_t1_img_001(:)));
%perturbed_mr_t1_img_001 = imrotate3(perturbed_mr_t1_img_001, 4, [0 1 0], 'crop', 'FillValues', mode(prealigned_mr_t1_img_001(:)));
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
r_y_trans_region = [1 -22];
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
%%
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
    %% Rotations on y-axis
    MI4d_r_y_trans = [];
    D_of_T_r_y_trans = [];
    MI_r_y_trans = [];
    S_r_y_tran = [];
    for r_y = round((S_r_y_trans_max_I+r_y_trans_region(l) -1)+(r_y_trans_region(2)/2^(l-1))):round((S_r_y_trans_max_I+r_y_trans_region(l) -1)-(r_y_trans_region(2)/2^(l-1)))
        rotated_f_img = imrotate3(rotated_f_img, r_y, [0 1 0], 'crop', 'FillValues', mode(rotated_f_img(:)));
        MI4d_r_x_trans = [];
        D_of_T_r_x_trans = [];
        MI_r_x_trans = [];
        S_r_x_tran = [];
        for r_x = round((S_r_x_trans_max_I+r_x_trans_region(l) -1)+(r_x_trans_region(2)/2^(l-1))):round((S_r_x_trans_max_I+r_x_trans_region(l) -1)-(r_x_trans_region(2)/2^(l-1)))
            rotated_f_img = imrotate3(rotated_f_img, r_x, [1 0 0], 'crop', 'FillValues', mode(rotated_f_img(:)));
            [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(rotated_f_img);
            MI4d_r_x_trans = [MI4d_r_x_trans compute_4D_MI(rotated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)];
            D_of_T_r_x_trans = [D_of_T_r_x_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)];
            MI_r_x_trans = [MI_r_x_trans mi(rotated_f_img, low_res_r_img)];
            fprintf('Rotations on x-axis: %d at level :%d\n', r_x, l);
        end
        S_r_x_tran = MI4d_r_x_trans.*D_of_T_r_x_trans;
    end
end