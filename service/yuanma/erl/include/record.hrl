%%%------------------------------------------------
%%% File    : record.hrl
%%% Author  : xyao
%%% Created : 2011-06-13
%%% Description: 只存在公共常用的record
%%%------------------------------------------------
%% 网络参数
-record(net_args, {
    ip=""               %% IP/域名
    , port=0            %% tcp/http 端口
    , sslport=0         %% ssl/https 端口
    , line=0            %% 线路标识
    , lburl=""          %% 腾讯调度系统服务器地址
}).

-define(ETS_NODE,           ets_node).
-define(WORLD_LV_LEN,              5).   %% 全服等级榜前5名玩家的长度

%% 所有线路记录
-record(node, {
        id,
        ip,
        port,
        sslport,
        node,
        cookie,
        num = 0,
        state = 0,                     %% 是否开放 0开放 1关闭
        lburl
    }).


-define(ETS_SERVER_KV, ets_server_kv).   %% 全局共用的ets kv表(仅限全服使用的但没有地方存储的键值)
%% 服务器信息ets ?ETS_SERVER_KV 的key值
-define(SKV_OPEN_CUR_TIME,  1).         %% 服务器准确开服时间戳
-define(SKV_OPEN_DATE_TIME, 2).         %% 服务器开服当天0点的时间戳
-define(SKV_MERGE_TIME,     3).         %% 服务器合服时间戳
-define(SKV_MERGE_COUNT,    4).         %% 服务器合服次数
-define(SKV_WORLD_LV,       5).         %% 服务器等级
-define(SKV_SERVER_NAME,    6).         %% 服务器名字##在base_game中取
-define(SKV_REG_SERVER_ID,  7).         %% 选择服务器的服id##在base_game中取
-define(SKV_FILTER_WORD_CHANNEL,  8).   %% 屏蔽字渠道##在 base_game.cfg_name=filter_word_channel 中取
-define(SKV_FILTER_WORD_NUM, 9).        %% 屏蔽词次数
-define(SKV_FILTER_LOAD_WORD_NUM, 10).  %% 屏蔽词加载次数
-define(SKV_UTC_ZONE,       11).        %% 时区##根据本地时间获取时区
-define(SKV_IGNORE_WORD_MP, 12).        %% 可忽略词语正则式
-define(SKV_C_SERVER_MSG,   13).        %% 客户端展示的服信息(二进制)##具体看运营填写，如 中文，数字，英文都能支持; 从 base_game.cfg_name=c_server_msg 中取
-define(SKV_MERGE_WLV,      14).        %% 服务器合服时的世界等级
-define(SKV_SERVER_TYPE,    15).        %% 服类型##1:正式服；2:审核服；3:测试服
-define(SKV_REG_PLAYER_NUM, 16).        %% 全服已注册玩家数
-define(SKV_SERVER_ACTIVE_TYPE, 17).    %% 服务器活跃类型## 1:跃服务器; 0:非活跃

%% 服务器全局kv信息
-record(server_kv, {
        key   = 0,                     %% KEY
        value = undefined,             %% VALUE
        time  = 0                      %% 更新时间戳
    }).
