%%%-----------------------------------
%%% @Module  : lib_mon
%%% @Author  : zzm
%%% @mail    : ming_up@163.com
%%% @Created : 2010.05.08
%%% @Description: 怪物接口，封装了lib_scene_object接口
%%%-----------------------------------
-module(lib_mon).

-include("scene.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("common.hrl").

%% 对外接口
-export([
        sync_create_mon/9                %% 同步创建怪物
        , async_create_mon/9             %% 异步创建怪物
        , get_scene_mon/4                %% 获取场景内所有怪物属性
        , get_scene_mon_by_ids/4         %% 根据怪物id获取属性
        , get_scene_mon_by_mids/5        %% 根据怪物资源id获取属性
        , get_scene_mon_battle_attr_by_ids/4
        , clear_scene_mon/4              %% 清理场景所有怪物
        , clear_scene_mon_by_ids/4       %% 根据怪物id清理怪物
        , clear_scene_mon_by_mids/5      %% 根据怪物资源id清理怪物
        , create_mon_on_user/7           %% 在玩家位置上创建怪
        , mon_init_model/0               %% 怪物模式
]).

%% 对场景怪物模块内部接口
-export([
        get_name_by_mon_id/1,
        get_hplim_by_mon_id/1,
        get_lv_by_mon_id/1,
        send_msg_to_mon_by_id/4
    ]).

%% 同步创建怪物
%% MonId 怪物资源ID
%% Scene 场景ID
%% ScenePoolId 场景进程id
%% X 坐标
%% X 坐标
%% Type       怪物战斗类型（0被动，1主动）
%% CopyId     房间号ID 为0时，普通房间，非0值切换房间。值相同，在同一个房间。
%% BroadCast  是否出生时广播（0不广播，1广播）
%% Args       其余动态创建属性
%%            = list() = [Tuple1, Tuple2...]
%%     Tuple1 = tuple(), {auto_lv, V} | {group, V}

%%  @returne MonAutoId 怪物自增ID，每个怪物唯一
sync_create_mon(MonId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args) -> 
    lib_scene_object:sync_create_object(?BATTLE_SIGN_MON, MonId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args).

%% 异步创建怪物
async_create_mon(MonId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args) ->
    lib_scene_object:async_create_object(?BATTLE_SIGN_MON, MonId, Scene, ScenePoolId, X, Y, Type, CopyId, BroadCast, Args).


%% 按格式返回怪物属性
%% SceneId    = int()              场景id
%% ScenePoolId = int()             场景进程id
%% CopyId     = [] | int() | pid() 房间id
%% ResultForm = list()             [#scene_object.xx1, #scene_object.xx2...] | all | #scene_object.xx1 属性组装列表或者单项属性, 复合属性暂不支持
get_scene_mon(SceneId, ScenePoolId, CopyId, ResultForm) -> 
    mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_object_agent, get_scene_object, [CopyId, ResultForm]).

%% 按格式返回怪物属性
%% SceneId    = int()           场c景id
%% Ids        = list()          怪物唯一Id列表
%% ResultForm = list()          同get_scene_mon/4
get_scene_mon_by_ids(SceneId, ScenePoolId, Ids, ResultForm) ->
    mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_object_agent, get_scene_object_by_ids, [Ids, ResultForm]).

%% 按格式返回怪物属性
%% SceneId    = int()              场景id
%% CopyId     = [] | int() | pid() 房间id
%% Mids       = list()             怪物类型id
%% ResultForm = list()|int()       同get_scene_mon/4
get_scene_mon_by_mids(SceneId, ScenePoolId, CopyId, Mids, ResultForm) -> 
    mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_object_agent, get_scene_mon_by_mids, [CopyId, Mids, ResultForm]).

%% 按格式返回怪物战斗属性
%% SceneId    = int()           场景id
%% Ids        = list()          怪物唯一Id列表
%% ResultForm = list()          [#battle_attr.xx1, #battle_attr.xx2...] | all | #battle_attr.xx1 属性组装列表或者单项属性, 复合属性暂不支持
get_scene_mon_battle_attr_by_ids(SceneId, ScenePoolId, Ids, ResultForm) ->
    mod_scene_agent:apply_call(SceneId, ScenePoolId, lib_scene_object_agent, get_scene_object_battle_attr_by_ids, [Ids, ResultForm]).

%% 清除全场景的怪物
%% SceneId    = int()                 场景ID
%% ScenePoolId= int()
%% CopyId     = int() | pid()         房间id,不分房间清理时置为 []
%% BroadCast  = 0 | 1                 是否需要在清除的时候广播(0不广播，1广播)
clear_scene_mon(SceneId, ScenePoolId, CopyId, BroadCast) ->
    lib_scene_object:clear_scene_object(?BATTLE_SIGN_MON, SceneId, ScenePoolId, CopyId, BroadCast),
    ok.

%% 清除id怪物
%% SceneId    = int()                 场景ID
%% BroadCast  = 0 | 1                 是否需要在清除的时候广播(0不广播，1广播)
%% Ids        = list()                怪物唯一Id列表 #scene_object.id
clear_scene_mon_by_ids(SceneId, ScenePoolId, BroadCast, Ids) ->
    lib_scene_object:clear_scene_object_by_ids(SceneId, ScenePoolId, BroadCast, Ids),
    ok.

%% 清除场景相同mid的怪物
%% SceneId    = int()                 场景ID
%% CopyId     = int() | pid()         房间id,不分房间清理时置为 []
%% BroadCast  = 0 | 1                 是否需要在清除的时候广播(0不广播，1广播)
%% Mids       = list()                怪物资源Id列表 #scene_object.mon#scene_mon.mid
clear_scene_mon_by_mids(SceneId, ScenePoolId, CopyId, BroadCast, Mids) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object_agent, clear_scene_mon_by_mids, [CopyId, BroadCast, Mids]),
    ok.
%% 在玩家的位置上创建怪
%% Mid 怪物id IsActive是否主动 OtherArgs怪物参数
create_mon_on_user(SceneId, ScenePoolId, CopyId, Data, Mid, IsActive, OtherArgs) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_agent, create_mon_on_user, [CopyId, Data, Mid, IsActive, OtherArgs]),
    ok.

mon_init_model() ->
    %behavior.
    statem.

%% 获取怪物名称 MonId:怪物配置id
get_name_by_mon_id(MonId)->
    case data_mon:get(MonId) of
        [] -> <<>>;
        Mon -> util:make_sure_binary(Mon#mon.name)
    end.

get_hplim_by_mon_id(MonId)->
    case data_mon:get(MonId) of
        [] -> 0;
        Mon -> Mon#mon.hp_lim
    end.

%% 获取怪物名称 MonId:怪物配置id
get_lv_by_mon_id(MonId) ->
    case data_mon:get(MonId) of
        [] -> 0;
        Mon -> Mon#mon.lv
    end.

send_msg_to_mon_by_id(SceneId, ScenePoolId, Id, Msg) ->
    mod_scene_agent:apply_cast(SceneId, ScenePoolId, lib_scene_object, send_msg_to_mon_by_id, [Id, Msg]),
    ok.