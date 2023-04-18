function inset(fig, configs)
    alpha = inputdlg('输入水印嵌入强度(0 ~ 1):');
    disp('------------嵌入水印中-------------');
    %输入值规范判断
    alpha =  str2double(alpha);                                          %嵌入强度,字符串转双精度类型
    if(alpha >=1 || alpha <=0 || isnan(alpha))
        disp('输入数值不符合规范');
        return
    end

    configs.alpha = alpha;                                               %更改数据对象中的嵌入强度
    disp(['你输入的水印强度值是：' num2str(configs.alpha)]);
    dwtName = configs.dwtName;     %设置小波基名称
    
    %% 分层
    IMG = imread('./assets/origin.png');                                 %载入载体图像

    % 提取色彩通道
    S1 = IMG(:, :, 1);
    S2 = IMG(:, :, 2);
    S3 = IMG(:, :, 3);

    %% DWT小波变换

    %获取低频、高频水平、高频垂直、高频对角图片
    [CA_R,CH_R,CV_R,CD_R] = dwt2(S1, dwtName);               
    [CA_G,CH_G,CV_G,CD_G] = dwt2(S2, dwtName);               
    [CA_B,CH_B,CV_B,CD_B] = dwt2(S3, dwtName);            

    %% 合层
    switch configs.insetType
        case '低频'
                %将三张灰度图像合并成一张图片 
                img = cat(3, CA_R, CA_G, CA_B);
        case '高频水平'
                % 将三张灰度图像合并成一张图片
                img = cat(3, CH_R, CH_G, CH_B);
        case '高频垂直'
                % 将三张灰度图像合并成一张图片
                img = cat(3, CV_R, CV_G, CV_B);
        case '高频对角'
                % 将三张灰度图像合并成一张图片
                img = cat(3, CD_R, CD_G, CD_B);
    end


    
    %% HOSVD

    % 对载体图片HOSVD
    X = tensor(img);                                                     % 转换为张量
    T = hosvd(X, 0.01);                                                  % 进行HOSVD
    core = double(T.core);                                               % 转为普通矩阵

    % 正交矩阵
    U1 = T.U{1};
    U2 = T.U{2};
    U3 = T.U{3};              

    %% 分层
    S1 = core(:, :, 1);
    S2 = core(:, :, 2);
    S3 = core(:, :, 3);           
    
    %% 嵌入水印

    sign = imread('./assets/sign.bmp');                                  %载入水印图像
    sign = rgb2gray(double(sign));                                       %转为灰度图
    %调整大小
    img_size = size(S1);                                                 %获得正交矩阵的维度
    sign = imresize(sign, img_size);                                     %将水印图调整为正交矩阵的维度
    [U, S, V] = svd(sign);                                               %水印图SVD


    [U_R, S_R, V_R] = svd(S1);                                           % 图层S1奇异值分解
    [U_G, S_G, V_G] = svd(S2);                                           % 图层S2奇异值分解
    [U_B, S_B, V_B] = svd(S3);                                           % 图层S3奇异值分解


    S1 = U_R * (S_R + alpha * S) * V_R';                                
    S2 = U_G * (S_G + alpha * S) * V_G';
    S3 = U_B * (S_B + alpha * S) * V_B';

    %% 合层
    img = cat(3, S1, S2, S3);                                            %新的核张量

    %% 逆HOSVD
    img = ttm(tensor(img),{U1, U2, U3});                                 %用核张量、三个正交矩阵还原     

    %% 分层
    img = double(img);
    S1 = img(:, :, 1);
    S2 = img(:, :, 2);
    S3 = img(:, :, 3);         

    %% IDWT
     %逆小波变换得到三个新的图像
     switch configs.insetType
        case '低频'
            R = idwt2(S1,CH_R,CV_R,CD_R, dwtName);              
            G = idwt2(S2,CH_G,CV_G,CD_G, dwtName);             
            B = idwt2(S3,CH_B,CV_B,CD_B, dwtName);     
        case '高频水平'
            R = idwt2(CA_R,S1,CV_R,CD_R, dwtName);              
            G = idwt2(CA_G,S2,CV_G,CD_G, dwtName);             
            B = idwt2(CA_B,S3,CV_B,CD_B, dwtName);   
        case '高频垂直'
            R = idwt2(CA_R,CH_R,S1,CD_R, dwtName);              
            G = idwt2(CA_G,CH_G,S2,CD_G, dwtName);             
            B = idwt2(CA_B,CH_B,S3,CD_B, dwtName);  
        case '高频对角'
            R = idwt2(CA_R,CH_R,CV_R,S1, dwtName);              
            G = idwt2(CA_G,CH_G,CV_G,S2, dwtName);             
            B = idwt2(CA_B,CH_B,CV_B,S3, dwtName);  
    end
        


    
    %% 合层
    marked_img = cat(3, R, G, B);
    marked_img = uint8(marked_img);
    disp('水印嵌入完成');
    
    ax3 = subplot(223,'Parent',fig);                                    % 创建第3个子图
    imshow(marked_img,'Parent',ax3);
    alpha = num2str(configs.alpha);                                             %数字转字符串
    titleName = ['含水印图 嵌入强度:' alpha];
    title(titleName,'Parent',ax3);

    imwrite(marked_img, './assets/marked_img.png');                     %向本地写入含水印图
    
end