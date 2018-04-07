function D_of_T = compute_angle_measure_D(MDG_of_r_img, MDG_of_f_img, mag_MDG_of_r_img, mag_MDG_of_f_img)

    D_of_T = sum(abs((sum(MDG_of_r_img.*MDG_of_f_img, 2)./(mag_MDG_of_r_img(:) .* mag_MDG_of_r_img(:)))));

end