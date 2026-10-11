%% ---------------------------------------------------------------------------
%% @doc login.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2022-7-7
%% @deprecated 登陆
%% ---------------------------------------------------------------------------

%% 登陆
-record(login_params, {
        id = 0
        , server_name = ""      % 服名字
        , accid = 0
        , accname = ""
        , accname_sdk = ""
        , reg_server_id = 0     % 注册的server_id
        , ids = []
        , c_source = ""         % 如果等于none 就取注册来源
        , ip = {0, 0, 0, 0}
        , socket = none
        , trans_mod = undefined  % 网络模块
        , proto_mod = undefined  % 协议解析模块
        , ta_guest_id = <<>>     % TA系统的访客id
        , ta_device_id = <<>>    % TA系统的设备id
        , is_simulator = false   % 是否模拟器登录
        , wx_scene = 0           % 微信小程序渠道登录场景（非微信渠道发0） https://developers.weixin.qq.com/miniprogram/dev/framework/app-service/scene.html
    }).