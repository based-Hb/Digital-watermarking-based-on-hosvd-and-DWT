function grj_jpg(IMG, fig, configs)
   disp('jpg压缩攻击');
   imwrite(IMG, './assets/attack_img.jpg', 'Quality', 10);                   % 写入 jpg 文件，设置压缩质量为 50
   IMG = imread('./assets/attack_img.jpg');
   configs.extractType = 3;
   disp('jpg压缩攻击完成');
   
   ax2 = subplot(222,'Parent',fig);                                         % 创建第一个子图
   imshow(IMG,'Parent',ax2);                                                % 显示第一个图片
   title('jpg压缩攻击攻击后','Parent',ax2);                                  % 添加标题       