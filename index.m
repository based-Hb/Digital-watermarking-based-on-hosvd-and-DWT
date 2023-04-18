%% 开始界面
    clear; clc;
    fig = figure;
    fig.Name = '开始界面';
    %  保存数据以及配置用的对象 
    configs = myData();
    %获取窗口高度
    figHeight = fig.Position(4);
    
    
    %  小波基选择标题
    text1 = uicontrol('Style','text','String','选择小波基类型:',...
                     'Position',[20 figHeight - 250 200 50],'FontSize',17);
    % 小波基类型选择下拉菜单
    ops = uicontrol(fig,'Style','popupmenu','FontSize',16);
    ops.Callback = {@ops_callback,configs};
    ops.Position = [290 figHeight - 218 100 20];
    ops.String = {'haar','db1','db2','coif2','sym2'};
    
    
    % 频段选择按钮组
    bg = uibuttongroup(fig, 'SelectionChangedFcn', {@bg_callback,configs},'FontSize',17);
    bg.Position = [0.05 0.59 0.90 0.4];
    bg.Title = '选择水印嵌入的频段';

    % 在按钮组中添加单选按钮
    rb1 = uicontrol(bg,'Style','radiobutton','String','低频',...
                    'Position',[260 110 100 35],'FontSize',14);
    rb2 = uicontrol(bg,'Style','radiobutton','String','高频水平',...
                    'Position',[260 75 100 35],'FontSize',14);
    rb3 = uicontrol(bg,'Style','radiobutton','String','高频垂直',...
                    'Position',[260 40 100 35],'FontSize',14);
    rb3 = uicontrol(bg,'Style','radiobutton','String','高频对角',...
                    'Position',[260 5 100 35],'FontSize',14);

    % 进入按钮
    button = uicontrol('Style','pushbutton','String','就绪，开始探索',...
                   'Position',[160 20 250 50],'Callback',{@start_callback,configs},'FontSize',16);
               
    %单选按钮回调
    function bg_callback(source,event,configs)
        configs.insetType = event.NewValue.String;  %更改嵌入频段
        disp(configs.insetType);
    end
    
    % 进入按钮回调
    function start_callback(source,event,configs)
         main(configs);
    end

    % 下拉菜单回调
    function ops_callback(source,event,configs)
        val = source.Value;
        str = source.String;
        configs.dwtName = str{val};  %更改小波基
        disp(configs.dwtName);
    end