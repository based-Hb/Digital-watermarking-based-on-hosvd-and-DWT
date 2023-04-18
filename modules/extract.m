function extract(fig, configs)
    disp('------------提取水印中-------------');

    %水印提取模式
    extractType = configs.extractType;
    %% 判断文件存在
    if extractType == 1                                                              %正常模式提取
           filename = './assets/marked_img.png'; 
           if exist(filename,'file') == 2
                marked_img = imread(filename);                                %载入含水印图像
                disp('含水印图存在，开始提取');
           else
               disp('含水印图不存在，请先嵌入');
               return;
           end
    elseif extractType == 2                                                          %攻击模式提取
           filename = './assets/attack_img.png'; 
           if  exist(filename,'file') ==2
                marked_img = imread(filename);                                %载入攻击后的含水印图像
                disp('含水印图存在(png)，开始提取');
           else
               disp('含水印图不存在，请先嵌入');
               return;
           end
    elseif extractType == 3                                                           %攻击模式jpg压缩提取
            filename1 = './assets/attack_img.jpg'; 
            if exist(filename1,'file') == 2 
                marked_img = imread(filename1);                               %载入攻击后的含水印图像
                disp('含水印图存在(jpg)，开始提取');
              else
               disp('含水印图不存在，请先嵌入');
               return;
            end
    end
    origin = imread('./assets/origin.png');                                   %载入原图
    alpha = configs.alpha;    %双精度类型
    disp(['检测水印嵌入强度：' num2str(configs.alpha)]);     %打印需要转换成字符类型
    disp(['水印提取模式：' num2str(configs.extractType)]);     
    dwtName = configs.dwtName;        %设置小波基名称
    
    %% 分层
    
    % 含水印图像提取色彩通道
    R = marked_img(:, :, 1);
    G = marked_img(:, :, 2);
    B = marked_img(:, :, 3);

    % 原图像提取色彩通道
    R1 = origin(:, :, 1);
    G1 = origin(:, :, 2);
    B1 = origin(:, :, 3);

    %% DWT小波变换

    %获取含水印图像 低频、高频水平、高频垂直、高频对角图片
    [CA_R,CH_R,CV_R,CD_R] = dwt2(R, dwtName);               
    [CA_G,CH_G,CV_G,CD_G] = dwt2(G, dwtName);               
    [CA_B,CH_B,CV_B,CD_B] = dwt2(B, dwtName);      

    %获取原图 低频、高频水平、高频垂直、高频对角图片
    [CA_R1,CH_R1,CV_R1,CD_R1] = dwt2(R1, dwtName);               
    [CA_G1,CH_G1,CV_G1,CD_G1] = dwt2(G1, dwtName);               
    [CA_B1,CH_B1,CV_B1,CD_B1] = dwt2(B1, dwtName);       

    %% 合层
    
    % 将三张灰度图像合并成一张图片
    switch configs.insetType
        case '低频'
                img = cat(3, CA_R, CA_G, CA_B);
                img1 = cat(3, CA_R1, CA_G1, CA_B1);
        case '高频水平'
                img = cat(3, CH_R, CH_G, CH_B);
                img1 = cat(3, CH_R1, CH_G1, CH_B1);
        case '高频垂直'
                img = cat(3, CV_R, CV_G, CV_B);
                img1 = cat(3, CV_R1, CV_G1, CV_B1);
        case '高频对角'
                img = cat(3, CD_R, CD_G, CD_B);
                img1 = cat(3, CD_R1, CD_G1, CD_B1);
    end
    
    %% HOSVD

    % 对含水印图片HOSVD
    X = tensor(img);                                                         % 转换为张量
    T = hosvd(X, 0.01);                                                      % 进行HOSVD
    core = double(T.core);                                                   % 转为普通矩阵

    % 对原图HOSVD
    X1 = tensor(img1);                                                       % 转换为张量
    T1 = hosvd(X1, 0.01);                                                    % 进行HOSVD
    core1 = double(T1.core);                                                 % 转为普通矩阵

    %% 分层                            

    % 含水印图像提取色彩通道
    S1 = core(:, :, 1);
    S2 = core(:, :, 2);
    S3 = core(:, :, 3);

    % 原图像提取色彩通道
    S11 = core1(:, :, 1);
    S22 = core1(:, :, 2);
    S33 = core1(:, :, 3);
    

    %% 提取水印
    
    %调整大小
    img_size = size(S1);                                                 %获得正交矩阵的维度
    S1 = imresize(S1, img_size); 
    S2 = imresize(S2, img_size); 
    S3 = imresize(S3, img_size); 
    S11 = imresize(S11, img_size); 
    S22 = imresize(S22, img_size); 
    S33 = imresize(S33, img_size); 

    
    %水印图SVD
    sign = imread('./assets/sign.bmp');                                      %载入水印图像,并转换成双精度型矩阵
    sign = rgb2gray(double(sign));                                           %转为灰度图
    sign = imresize(sign, img_size);                                         %调整大小
    [U, S, V] = svd(sign);                                                   %水印图SVD


    %奇异值分解
    [U_R, S_R, V_R] = svd(S1);                                   
    [U_G, S_G, V_G] = svd(S2);                                    
    [U_B, S_B, V_B] = svd(S3);                                   
    [U_R1, S_R1, V_R1] = svd(S11);                                  
    [U_G2, S_G2, V_G2] = svd(S22);                                   
    [U_B3, S_B3, V_B3] = svd(S33);                                  

    %逆运算
    S1 = (S_R - S_R1) / alpha;                                
    S2 = (S_G - S_G2) / alpha;     
    S3 = (S_B - S_B3) / alpha;     
    sign_R = U * S1 * V';                                   
    sign_G = U * S2 * V';   
    sign_B = U * S3 * V';   

    %% 合层
    sign = cat(3, sign_R, sign_G, sign_B);
    disp('水印提取完成');
    
    ax4 = subplot(224,'Parent',fig);    % 创建第4个子图
    imshow(sign,'Parent',ax4);
    title('提取的水印图','Parent',ax4);  % 添加标题
    configs.extractType = 1;            % 更改为正常提取模式

