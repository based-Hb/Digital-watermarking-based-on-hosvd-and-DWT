% 自定义类
classdef myData < handle
    %定义默认量
    properties
        alpha = 0.1;               %水印嵌入强度
        insetType = '低频';        %嵌入频段
        dwtName = 'haar';          %小波基名称
        extractType = 1;           %水印提取模式，正常提取1，攻击后提取2，jpg压缩后提取3
    end
end
