%% ---------------------------------------------------------
%% 客服信息
%% ----------------------------------------------------------  

-define(DISPLAY, 1).
-define(HIDE, 0).

%% 客服信息配置
-record(base_customer_service, {
    id = 0,            %% id
    display = 0,       %% 1：显示 0：隐藏
    display_code = 0,  %% 是否显示二维码
    keyword = "",      %% 关键字
    medium  = "",      %% 渠道
    link_info_1 = "",  %% 联系方式1 
    link_info_2 = "",  %% 联系方式2 
    work_time = ""     %% 工作时间   
    }).

%% 超级vip客服信息配置
-record(base_customer_service_vip, {
    id = 0,            %% id
    display = 0,       %% 1：显示 0：隐藏
    keyword = "",      %% 关键字
    medium  = "",      %% 渠道
    menu_gold = 0,     %% 界面显示所需金额
    qq_gold = 0,       %% qq显示所需金额
    qq = ""            %% qq   
    }).

%% 登录报错信息配置
-record(base_login_tips, {
    id = 0,            %% id
    display = 0,       %% 1：显示 0：隐藏
    keyword = "",      %% 关键字
    platform  = "",    %% 渠道
    link_info = ""     %% 联系方式   
    }).
