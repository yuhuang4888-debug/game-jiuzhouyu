%% ---------------------------------------------------------------------------
%% @doc 离线玩家信息api
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------

-module (lib_offline_api).
-export ([login/1]).
-export ([get_player_info/2]).
-export ([apply_cast/4, apply_cast/3]).

%% 查看内存玩家数据
-export([
         send_player_info_view/2
        , update_offline_ps/2
        , handle_event/2
        ]).

-include("server.hrl").
-include("partner.hrl").
-include("rec_offline.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("relationship.hrl").
-include("marriage.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("figure.hrl").

%% ---------------------------------------------------------------------------
%% @doc 玩家上线从ets表中移除离线数据
-spec login(Id) -> Result when
      Id            :: integer(),                %% 玩家id
      Result      :: ok.
%% @end
%% ---------------------------------------------------------------------------
login(Id) ->
    lib_offline_player:login(Id).

%% ---------------------------------------------------------------------------
%% @doc 按格式(ResultForm)返回#player_status{}中的字段值集合
-spec get_player_info(Id, ResultForm) -> Result when
      Id            :: integer(),              %% 玩家id
      ResultForm  :: integer() | list() | all, %% #player_status.xx | [#player_status.xx, ...] | all | not_exist(玩家不存在)
      Result      :: term().                   %% 对应上面的参数的返回值：记录中某个字段的值|记录中某些字段组成的列表|全记录
%% @end
%% ---------------------------------------------------------------------------
get_player_info(Id, ResultForm) ->
    lib_offline_player:get_player_info(Id, ResultForm).


%% ---------------------------------------------------------------------------
%% @doc 按格式(ValueList)更新#player_status{}中的字段  ets中不存在，则不处理
-spec update_offline_ps(Id, ValueList) -> ok when
      Id          :: integer(),                %% 玩家id
      ValueList   :: list() | tuple().         %% [{key,value}] | #player_status{}
%% @end
%% ---------------------------------------------------------------------------
update_offline_ps(Id, ValueList) ->
    lib_offline_player:update_offline_ps(Id, ValueList).

apply_cast(PlayerId, lib_player_event, dispatch, [EventTypeId, Data]) ->
    lib_player_event:dispatch(PlayerId, EventTypeId, Data),
    ok;
%% @doc mod_offline_player进程cast方式执行FA
apply_cast(PlayerId, Moudle, Method, Args) ->
    mod_offline_player:apply_cast(PlayerId, Moudle, Method, Args).

apply_cast(Moudle, Method, Args) ->
    mod_offline_player:apply_cast(Moudle, Method, Args).

%% ----------------------------------------------------
%% @doc 查看角色信息
%% ----------------------------------------------------

%% 查看玩家信息界面
send_player_info_view(MySid, Id) ->
    case get_player_info(Id, all) of
        not_exist -> List = [];
        Player -> List = [Player#player_status.id, Player#player_status.figure,
                          Player#player_status.battle_attr, Player#player_status.hightest_combat_power]
    end,
    %% List = lib_player:make_player_info_view(Player),
    {ok, BinData} = pt_130:write(13004, List),
    lib_server_send:send_to_sid(MySid, BinData),
    ok.

handle_event(Ps, #event_callback{type_id = ?EVENT_RENAME}) when is_record(Ps, player_status) ->
    #player_status{
       id = RoleId,
       figure = Figure
      } = Ps,
    #figure{
       name = Name
      } = Figure,
    update_offline_ps(RoleId, [{name, Name}]),
    {ok, Ps};

handle_event(Ps, _) ->
    {ok, Ps}.
