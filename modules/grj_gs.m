function  grj_gs(IMG, fig, configs)
   disp('高斯噪声攻击');
   IMG = imnoise(IMG, 'gaussian', 0, 0.01);
   disp('高斯噪声攻击完成');
   configs.extractType = 2;      % 更改提取模式
   ax2 = subplot(222,'Parent',fig);                                         % 创建第一个子图
   imshow(IMG,'Parent',ax2);                                                % 显示第一个图片
   title('高斯噪声攻击后','Parent',ax2);                                     % 添加标题
   imwrite(IMG,'./assets/attack_img.png');                                   % 向本地写入攻击后的图像，用于提取