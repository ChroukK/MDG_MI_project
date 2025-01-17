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
% %prealigned_ct_img_001 = imregister(ct_img_001,ct_img_001_ref, mr_t1_img_001, mr_t1_img_001_ref, 'rigid', optimizer, metric);
% prealigned_mr_t1_img_001 = imregister(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref,'rigid', optimizer, metric);
% geomtform = imregtform(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref, 'rigid', optimizer, metric);
% figure
% imshowpair(ct_img_001(:,:,ct_img_001_centre(3)), prealigned_mr_t1_img_001(:,:,mr_t1_001_centre(3)));
% figure
% imshow3D(prealigned_mr_t1_img_001); 
%%
perturbed_mr_t1_img_001 = imtranslate(prealigned_mr_t1_img_001, [-40 90], 'FillValues', mode(prealigned_mr_t1_img_001(:)));
figure
imshow3D(perturbed_mr_t1_img_001); 
%%
multi_res_rigid_trans_registeration(perturbed_mr_t1_img_001(:,:,1:2:28), ct_img_001(:,:,1:2:28), 4);