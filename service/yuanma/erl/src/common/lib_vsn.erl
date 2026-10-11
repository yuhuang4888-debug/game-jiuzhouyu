%% ---------------------------------------------------------------------------
%% @doc lib_vsn
%% @author ming_up@foxmail.com
%% @since  2018-04-09
%% @deprecated （语言/地区）版本管理 库函数
%% ---------------------------------------------------------------------------
-module(lib_vsn).

-include("common.hrl").
-include("record.hrl").

-export([
        is_cn/0
        , is_tw/0
        , is_en/0
        , is_hw/0
        , is_jp/0
        , is_th/0
        , is_id/0
        , is_ar/0
        , name_len/0
        , guild_name_len/0
        , is_chat_monitor/0
        , is_word_prehandle/0
        , is_ignore_goods/0
        , is_personal_exclusivity_recharge/1
        , is_pay_product_verify/0
        , is_check_game_maintain/0
        , get_url/0  %% 获取礼包卡的地址
        , get_register_url/0  %% 获取礼包卡的地址
        , utc_zone/0
        , get_server_log_url/0
    ]).

%% util 工具函数
-export([
        is_sy_internal_devp/0
        , is_sy_kf_devp/0
    ]).

%% ----------------------------------------
%% 版本处理
%% ----------------------------------------

is_cn() -> ?GAME_VER == ?GAME_VER_NORMAL.
is_tw() -> ?GAME_VER == ?GAME_VER_TW.
is_en() -> ?GAME_VER == ?GAME_VER_EN.
is_hw() -> ?GAME_VER == ?GAME_VER_HW.
is_jp() -> ?GAME_VER == ?GAME_VER_JP.
is_th() -> ?GAME_VER == ?GAME_VER_TH.
is_id() -> ?GAME_VER == ?GAME_VER_ID.
is_ar() -> ?GAME_VER == ?GAME_VER_AR.

%% 角色名长度
name_len() ->
    case ?GAME_VER of
        ?GAME_VER_EN -> 20;
        ?GAME_VER_ID -> 20;
        ?GAME_VER_TH -> 50;
        _ -> 12
    end.

%% 帮派名称长度
guild_name_len()->
    case ?GAME_VER of
         ?GAME_VER_EN -> 20;
         ?GAME_VER_ID -> 20;
         ?GAME_VER_TH -> 16;
        _       -> 10
    end.

%% 是否启动聊天监控
is_chat_monitor() ->
    case ?GAME_VER of
        ?GAME_VER_NORMAL -> true;
        ?GAME_VER_TW -> true;
        ?GAME_VER_JP -> true;
        _ -> false
    end.

%% 是否预处理
is_word_prehandle() ->
    case ?GAME_VER of
        ?GAME_VER_EN -> true;
        ?GAME_VER_ID -> true;
        _ -> false
    end.

%% 是否对物品格式的传输忽略
is_ignore_goods() ->
    true.

is_personal_exclusivity_recharge(ProduceId) ->
    case ?GAME_VER of
        ?GAME_VER_EN when ProduceId == 0 -> %% 英文并且商品id为0：是专属充值
            true;
        _ -> false
    end.

%% 是否能充值审核类型
is_pay_product_verify() ->
    case ?GAME_VER of
        ?GAME_VER_EN -> true;
        ?GAME_VER_TW -> true;
        _ -> false
    end.

%% 是否检查服务器维护时间
is_check_game_maintain() ->
    is_jp().

%% 注册系统地址.每新增一个版本需要跟运维确认关键字和链接(因为不一定是跟svn的关键字一样)
get_url() ->
    if
        ?IS_DEV_SERVER == true ->
            % 头像系统(多个项目可复用yyhx，注意"注册系统"不可以复用)
            "http://register.yy25dlaya.suyougame.com/api/api.php?";
        true ->
            case ?GAME_VER of  %% 国内地址
                ?GAME_VER_NORMAL ->
                    "http://admin.userpic.suyougame.com/api/api.php?";
                ?GAME_VER_TW ->
                    "http://regtwjzy.goldenb.cc/api/api.php?";
                ?GAME_VER_TH ->
                    "http://regthjzy.goldenb.cc/api/api.php?";
                ?GAME_VER_JP ->
                    "http://regjpjzy.goldenb.cc/api/api.php?";
                ?GAME_VER_ID ->
                    "http://regidnjzy.goldenb.cc/api/api.php?";
                ?GAME_VER_HW ->
                    "http://regkrjzy.goldenb.cc/api/api.php?";
                ?GAME_VER_AR ->
                    "http://regmejzy.goldenb.cc/api/api.php?";
	            ?GAME_VER_RU ->
		            "http://regrujzy.goldenb.cc/api/api.php?";
                _ -> %% 外服地址  英文
                    "http://regenyzjzy.goldenb.cc/api/api.php?"
            end
    end.

get_register_url() ->
    if
        ?IS_DEV_SERVER == true ->
            "http://register.yy25dlaya.suyougame.com/api/api.php?";
        true ->
            "http://regcnjzy.suyougame.cn/api/api.php?"
    end.

%% 获取本地时区（带夏令时）- ram api
utc_zone() ->
    case ?GAME_VER of
        % ?GAME_VER_NORMAL -> ?DEFAULT_UTC_ZONE;
        % ?GAME_VER_TW -> ?DEFAULT_UTC_ZONE;
        _ -> utime:get_skv_utc_zone()
    end.

%% 服务端报错URL
get_server_log_url() ->
    case ?GAME_VER of
        _ -> %%
            case is_sy_internal_devp() of %% 是否速游内部版本
                true -> "http://register.yy25dlaya.sydevlop.cn/index.php?c=api&f=get_server_errors&";
                false -> "http://admin.userpic.suyougame.com/api/api.php?"
            end
    end.

%% ----------------------------------------
%% util 工具函数
%% ----------------------------------------

%% 内网开发版本标志
is_sy_internal_devp() ->
    %% 只有内网才配置sy_internal_devp参数
    config:get_sy_internal_devp() == 1.

%% 开发版本标志
is_sy_kf_devp() ->
    %% config:get_sy_internal_devp()：同于欺骗dialyzer分析器
    config:get_sy_internal_devp() == 1 andalso ?IS_DEV_SERVER.

%% ----------------------------------------
%% 其他
%% ----------------------------------------