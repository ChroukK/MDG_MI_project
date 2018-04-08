function multi_res_rigid_trans_registeration(r_img, f_img)

for l=1:levels
    low_res_f_img = impyramid(f_img, 'reduce');
    low_res_r_img = impyramid(r_img, 'reduce');
    for i =1:3-l
        low_res_f_img = impyramid(low_res_f_img, 'reduce');
        low_res_f_img = impyramid(low_res_f_img, 'reduce');
    end
    [r_img_signed_MDG_field r_img_mag_signed_MDG_field] = compute_MDG_vector_field(low_res_r_img);
    MI4d_r = [];
    D_of_T_r = [];
    MI_r = []; 
    for r = -40/2^(l-1):40/2^(l-1)
        rotated_f_img = imrotate3(low_res_f_img, r, [0 0 1], 'crop', 'FillValues', mode(low_res_f_img(:))); 
        [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
        MI4d_r = [MI4d_r compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
        D_of_T_r = [D_of_T_r compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
        MI_r = [MI_r mi(translated_f_img, low_res_r_img)]; 
    end
    save('registration'); 
    
    MI4d_x_trans = [];
    D_of_T_x_trans = [];
    MI_x_trans = []; 
    for x = -40/2^(l-1):40/2^(l-1)
        translated_f_img = imtranslate(low_res_f_img, [x 0], 'FillValues', mode(low_res_f_img(:)));
        [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
        MI4d_x_trans = [MI4d_x_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
        D_of_T_x_trans = [D_of_T_x_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
        MI_x_trans = [MI_x_trans mi(translated_f_img, low_res_r_img)]; 
    end
    save('registration'); 

    MI4d_y_trans = [];
    D_of_T_y_trans = [];
    MI_y_trans = []; 
    for y = -40/2^(l-1):40/2^(l-1)
        translated_f_img = imtranslate(low_res_f_img, [0 y], 'FillValues', mode(low_res_f_img(:)));
        [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
        MI4d_y_trans = [MI4d_y_trans compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, low_res_r_img, r_img_mag_signed_MDG_field, 32)]; 
        D_of_T_y_trans = [D_of_T_y_trans compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
        MI_y_trans = [MI_y_trans mi(translated_f_img, low_res_r_img)]; 
    end
    save('registration'); 

end
