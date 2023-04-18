function  grj_xz(IMG, fig, configs)
   disp('旋转攻击');
   IMG = imrotate(IMG,90,'nearest','crop');
   configs.extractType = 2;      % 更改提取模式
   disp('旋转攻击完成');
   
   ax2 = subplot(222,'Parent',fig);                                         % 创建第一个子图
   imshow(IMG,'Parent',ax2);                                                % 显示第一个图片
   title('旋转攻击后','Parent',ax2);                                         % 添加标题
   imwrite(IMG,'./assets/attack_img.png');                                   % 向本地写入攻击后的图像，用于提取