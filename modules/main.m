function main(configs)
    %% 主界面
    %创建窗口并设置名称、高度、位置
    fig = uifigure;
    fig.Name = ['基于HOSVD和SVD的数字水印嵌入实验 | ' configs.insetType ' - ' configs.dwtName];
    fig.Position(4) = 700; 
    movegui(fig,'center');
    fig.AutoResizeChildren = 'off';                                            % 关闭自动调整子组件
    
    disp('----------------------------------');
    disp(['开始' configs.insetType '频段' ' + 小波基为' configs.dwtName '的实验']);
    
    %原图显示
    ax1 = subplot(221,'Parent',fig);                                           % 创建第1个子图
    img1 = imread('./assets/origin.png'); 
    imshow(img1,'Parent',ax1); 
    title('原图','Parent',ax1);                                                % 添加标题

    %水印图显示
    ax2 = subplot(222,'Parent',fig);                                           % 创建第2个子图
    img2 = imread('./assets/sign.bmp');
    imshow(img2,'Parent',ax2);
    title('水印图','Parent',ax2);                                              % 添加标题

    %% 操作选项
    %批量生成操作按钮
    List = {'水印嵌入','进入攻击模式','正常提取水印'};                           % 创建按钮列表
    length = numel(List);                                                      % 列表长度
    for i = 1:length                                                           % 循环创建按钮
        btn = uibutton(fig);                                                   % 创建按钮
        btn.Text = List{i};                                                    % 设置按钮文本
        btn.Position = [i*100 30 80 30];                                       % 设置按钮位置
        switch btn.Text                                                        % 根据按钮文本设置不同的功能
            case '水印嵌入'
                btn.ButtonPushedFcn = @(btn,event) inset(fig, configs);        % 在主界面显示，传入窗口对象
            case '进入攻击模式'
                btn.ButtonPushedFcn = @(btn,event) attack(configs);            % 单独窗口,嵌入强度
            case '正常提取水印'
                btn.ButtonPushedFcn = @(btn,event) extract(fig, configs);   % 在主界面显示,传入窗口对象、正常提取模式标识1和嵌入强度
        end
    end
end