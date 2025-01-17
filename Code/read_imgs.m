
%% Patient 109 Images
% mr_t1_img_109_header  = helperReadHeaderRIRE('header_mr_t1_109.ascii');
% mr_t1_img_109  = multibandread('image_mr_t1_109.bin',...
%                             [mr_t1_img_109_header.Rows, mr_t1_img_109_header.Columns, mr_t1_img_109_header.Slices],...
%                             'int16=>single', 0, 'bsq', 'ieee-be' );
% figure
% imshow3D(mr_t1_img_109);
% mr_t1_109_centre= round(size(mr_t1_img_109)/2);
% 
% ct_img_109_header  = helperReadHeaderRIRE('header_ct_109.ascii');
% ct_img_109  = multibandread('image_ct_109.bin',...
%                             [ct_img_109_header.Rows, ct_img_109_header.Columns, ct_img_109_header.Slices],...
%                             'int16=>single', 0, 'bsq', 'ieee-be' );
% figure
% imshow3D(ct_img_109);
% ct_img_109_centre = round(size(ct_img_109)/2);
% figure
% imshowpair(ct_img_109(:,:,ct_img_109_centre(3)), mr_t1_img_109(:,:,mr_t1_109_centre(3)));

%% Patient 001 Images
mr_t1_img_001_header  = helperReadHeaderRIRE('header_rectified_mr_t1_001.ascii');
mr_t1_img_001  = multibandread('image_mr_t1_001_rectified.bin',...
                            [mr_t1_img_001_header.Rows, mr_t1_img_001_header.Columns, mr_t1_img_001_header.Slices],...
                            'int16=>single', 0, 'bsq', 'ieee-be' );
%figure
%imshow3D(mr_t1_img_001);
mr_t1_001_centre= round(size(mr_t1_img_001)/2);

ct_img_001_header  = helperReadHeaderRIRE('header_ct_001.ascii');
ct_img_001  = multibandread('image_ct_001.bin',...
                            [ct_img_001_header.Rows, ct_img_001_header.Columns, ct_img_001_header.Slices],...
                            'int16=>single', 0, 'bsq', 'ieee-be' );
ct_img_001_ref  = imref3d(size(ct_img_001),ct_img_001_header.PixelSize(2),ct_img_001_header.PixelSize(1),ct_img_001_header.SliceThickness);
mr_t1_img_001_ref = imref3d(size(mr_t1_img_001),mr_t1_img_001_header.PixelSize(2),mr_t1_img_001_header.PixelSize(1),mr_t1_img_001_header.SliceThickness);
%figure
%imshow3D(ct_img_001);
ct_img_001_centre = round(size(ct_img_001)/2);
figure
imshowpair(ct_img_001(:,:,ct_img_001_centre(3)), mr_t1_img_001(:,:,mr_t1_001_centre(3)));

[optimizer,metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.004;

%prealigned_ct_img_001 = imregister(ct_img_001,ct_img_001_changed, mr_t1_img_001, mr_t1_img_001_changed, 'rigid', optimizer, metric);
prealigned_mr_t1_img_001 = imregister(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref,'rigid', optimizer, metric);
geomtform = imregtform(mr_t1_img_001, mr_t1_img_001_ref, ct_img_001,ct_img_001_ref, 'rigid', optimizer, metric);
figure
imshowpair(ct_img_001(:,:,ct_img_001_centre(3)), prealigned_mr_t1_img_001(:,:,mr_t1_001_centre(3)));
figure
imshow3D(prealigned_mr_t1_img_001); 
%% Manual Reads
% 
% fileID = fopen('image_ct_001.bin');
% ct_img_001 = fread(fileID, '*int16');
% ct_img_001 = vec2mat(ct_img_001, 512);
% ct_img_001 = permute(reshape(ct_img_001, 512, 28, 512), [1 3 2]);
% imshow3D(ct_img_001);
%imshow(ct_img_001(:,:,1));

% fileID = fopen('image_mr_t1.bin');
% mr_T1_img = fread(fileID, '*int16');
% mr_T1_img = vec2mat(mr_T1_img, 256);
% mr_T1_img = permute(reshape(mr_T1_img, 256, 52, 256), [1 3 2]);
% figure
% %imshow3D(mr_T1_img);
% imshow(mr_T1_img(:,:, 26));

% fileID = fopen('image.bin');
% ct_img = fread(fileID, 'int16=>single');
% ct_img = vec2mat(ct_img, 512);
% ct_img = permute(reshape(ct_img, 512, 29, 512), [1 3 2]);
% imshow3D(ct_img);