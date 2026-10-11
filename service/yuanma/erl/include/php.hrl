%% 一定要在 common.hrl 下面,使用了 common 中的 DEV_SERVER

-ifdef(DEV_SERVER).
-define(URL, "http://gamecenter.yyhx_kf.suyougame.com/api/api.php?"). %% 开发##头像系统(多个项目可复用yyhx，注意"注册系统"不可以复用)
-else.
-define(URL, "http://admin.userpic.suyougame.com/api/api.php?"). %% 外网
-endif.

-define(VERSION,    "cn").
-define(GAME,     "jzy").
-define(APPKEY,   "#LMfJyNQUKhLVLmpJ%WBo4@k^VdTEB5m").

%% php 请求时保存的数据进程字典
-define(PHP_REQUEST(RequestId), {php_request, RequestId}).

%% php 请求的保留数据结构
-record(php_request, {
        request_id = 0          % ref()
        , role_id = 0           % 请求的玩家
        , mfa = undefined       % 函数
        , data = undefined      % 数据,模块自己使用
    }).