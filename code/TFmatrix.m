function T= TFmatrix(pattern, frame, method)
    switch method
        case 'SURF'
            % 尋找特徵點
            pts_pattern = detectSURFFeatures(pattern);
            [features_pattern, valid_pts_pattern] = extractFeatures(pattern, pts_pattern);
            
            pts_frame = detectSURFFeatures(frame);
            [features_frame, valid_pts_frame] = extractFeatures(frame, pts_frame);
                       
            % 尋找匹配點
            
            matches = matchFeatures(features_pattern,features_frame, 'method', 'Approximate', 'MatchThreshold', 1);
            
%             showMatchedFeatures(pattern,frame,valid_pts_pattern(matches(:,1)),valid_pts_frame(matches(:,2)),'montage');
            
            % RANSAC and calculate transformation matrix
            
            transform_matrix = RANSACFit(pts_pattern.Location, pts_frame.Location, matches);
            
            T = transform_matrix(1:2, :);
            
        case 'SIFT'
            % 尋找特徵點
            [f_pattern, d_pattern] = vl_sift(single(pattern)) ;
            
            [f_frame, d_frame] = vl_sift(single(frame)) ;
            
            % 尋找匹配點
            
            matches = vl_ubcmatch(d_pattern, d_frame, 2) ;
            
%             showMatchedFeatures(pattern,image,f_pattern(1:2, matches(1,:))',f_image(1:2, matches(2,:))','montage');
            
            % RANSAC and calculate transformation matrix
            
            transform_matrix = RANSACFit(f_pattern(1:2, :)', f_frame(1:2, :)', matches.');
            
            T = transform_matrix(1:2, :);
    end
end
    