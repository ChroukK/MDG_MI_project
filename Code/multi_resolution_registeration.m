tic
r_img_lv_0 = ct_img_001(:,:,1:2:26); %512
r_img_lv_1 = impyramid(r_img_lv_0, 'reduce'); %256 
r_img_lv_2 = impyramid(r_img_lv_1, 'reduce'); %128
r_img_lv_3 = impyramid(r_img_lv_2, 'reduce'); %64
r_img_lv_4 = impyramid(r_img_lv_3, 'reduce'); %32

f_img_lv_0 = mr_t1_img_001(:,:,1:2:26); %512
f_img_lv_1 = impyramid(f_img_lv_0, 'reduce'); %256 
f_img_lv_2 = impyramid(f_img_lv_1, 'reduce'); %128
f_img_lv_3 = impyramid(f_img_lv_2, 'reduce'); %64
f_img_lv_4 = impyramid(f_img_lv_3, 'reduce'); %32

r_img = r_img_lv_3; 
f_img = f_img_lv_2;

MI4d = [];
MI = []; 
D_of_T = []; 
S = []; 
[r_img_signed_MDG_field r_img_mag_signed_MDG_field] = compute_MDG_vector_field(r_img);

for x=-50:50
    translated_f_img = imtranslate(f_img, [x 0], 'FillValues', mode(f_img(:)));
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
    MI4d = [MI4d compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, 32)]; 
    D_of_T = [D_of_T compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
    MI = [MI mi(translated_f_img, r_img)]; 
end
fprintf('Finished x translations'); 
S = MI4d.*D_of_T;
figure
plot(-50:50,S)
title("MI4D*cos Similarity Measure for x translations"); 
figure
plot(-50:50,MI)
title("Conventional MI Measure for x translations"); 

saveas(figure(1),[pwd '\output\S_at_level_3_x_trans.fig']); 
saveas(figure(2),[pwd '\output\MI_at_level_3_x_trans.fig']); 

MI4d = [];
MI = []; 
D_of_T = []; 
S = []; 
for y=-50:50
    translated_f_img = imtranslate(f_img, [0 y], 'FillValues', mode(f_img(:)));
    [f_img_signed_MDG_field f_img_mag_signed_MDG_field] = compute_MDG_vector_field(translated_f_img);
    MI4d = [MI4d compute_4D_MI(translated_f_img, f_img_mag_signed_MDG_field, r_img, r_img_mag_signed_MDG_field, 32)]; 
    D_of_T = [D_of_T compute_angle_measure_D(r_img_signed_MDG_field, f_img_signed_MDG_field, r_img_mag_signed_MDG_field, f_img_mag_signed_MDG_field)]; 
    MI = [MI mi(translated_f_img, r_img)]; 
end
fprintf('Finished y translations'); 
S = MI4d.*D_of_T;
figure
plot(-50:50,S)
title("MI4D*cos Similarity Measure for y translations"); 
figure
plot(-50:50,MI)
title("Conventional MI Measure for y translations"); 

saveas(figure(1),[pwd '\output\S_at_level_3_y_trans.fig']); 
saveas(figure(2),[pwd '\output\MI_at_level_3_y_trans.fig']); 

registeration_exec_time = toc 