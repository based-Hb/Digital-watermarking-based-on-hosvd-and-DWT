function  grj_jq(IMG, fig, configs)
    disp('剪切攻击');
    % 提取色彩通道
    S1 = IMG(:, :, 1);
    S2 = IMG(:, :, 2);
    S3 = IMG(:, :, 3);
    
   S1(1:128,1:128)=255;
   S2(1:128,1:128)=255;
   S3(1:128,1:128)=255;
   
   IMG = cat(3,S1,S2,S3);
   configs.extractType = 2;      % 更改提取模式
   ax2 = subplot(222,'Parent',fig);                                         % 创建第一个子图
   imshow(IMG,'Parent',ax2);                                                % 显示第一个图片
   title('剪切攻击后','Parent',ax2);                                         % 添加标题
   imwrite(IMG,'./assets/attack_img.png');                                   % 向本地写入攻击后的图像，用于提取