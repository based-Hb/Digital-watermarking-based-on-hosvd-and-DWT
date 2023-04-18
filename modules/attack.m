function attack(configs)

%判断是否有含水印图存在
disp('----------进入攻击模式中-----------');
filename = './assets/marked_img.png'; 
if exist(filename,'file') == 2
    img = imread('./assets/marked_img.png'); % 读取水印图
    imwrite(img, './assets/attack_img.png'); % 复制一份用于攻击的图像
    img1 = imread('./assets/attack_img.png'); 
    disp('含水印图存在，准许进入攻击模式');
else
   disp('含水印图不存在，不允许进入攻击模式');
   return;
end

%创建窗口并设置名称、高度、位置
alpha = num2str(configs.alpha);
fig = uifigure;
fig.Name = ['图像攻击模式 | 水印嵌入强度:' alpha];
fig.Position(4) = 700; 
movegui(fig,'center');
fig.AutoResizeChildren = 'off'; % 关闭自动调整子组件

ax1 = subplot(221,'Parent',fig); % 创建第一个子图
imshow(img1,'Parent',ax1); % 显示第一个图片
title('攻击前-含水印图片','Parent',ax1); % 添加标题

attackList = {'高斯噪声','剪切','旋转','缩放','jpg压缩'}; % 创建按钮列表
length = numel(attackList); %列表长度
for i = 1:length % 循环创建按钮
    btn = uibutton(fig); % 创建按钮
    btn.Text = attackList{i}; % 设置按钮文本
    btn.Position = [i*90 30 80 30]; % 设置按钮位置
    switch btn.Text % 根据按钮文本设置不同的功能
        case '高斯噪声'
            btn.ButtonPushedFcn = @(btn,event) grj_gs(img1, fig, configs);
        case '剪切'
            btn.ButtonPushedFcn = @(btn,event) grj_jq(img1, fig, configs);
        case '旋转'
            btn.ButtonPushedFcn = @(btn,event) grj_xz(img1, fig, configs);
        case '缩放'
            btn.ButtonPushedFcn = @(btn,event) grj_sf(img1, fig, configs);
        case 'jpg压缩'
            btn.ButtonPushedFcn = @(btn,event) grj_jpg(img1, fig, configs);
    end
end

%提取水印
btn = uibutton(fig); % 创建按钮
btn.Text = '提取水印'; 
btn.Position = [10 30 80 30]; % 设置按钮位置
btn.ButtonPushedFcn = @(btn,event) extract(fig, configs);  

