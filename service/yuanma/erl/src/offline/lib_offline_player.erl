%% ---------------------------------------------------------------------------
%% @doc 离线玩家信息
%% @author hek
%% @since  2016-11-30
%% @deprecated
%% ---------------------------------------------------------------------------

-module(lib_offline_player).
-include("server.hrl").
-include("figure.hrl").
-include("attr.hrl").
-include("predefine.hrl").
-include("rec_offline.hrl").
-include("title.hrl").
-include("guild.hrl").
-include("partner.hrl").

-export ([login/1]).
-export ([
          get_player_info/2
         , update_offline_ps/2
         , clear_player_info/1
         ]).

%% @doc 玩家上线从ets表中移除离线数据
login(Id) -> clear_player_info(Id).

%% ---------------------------------------------------------------------------
%% @doc 按格式(ResultForm)返回#player_status{}中的字段值集合
-spec get_player_info(Id, ResultForm) -> Result when
      Id            :: integer(),              %% 玩家id
      ResultForm  :: integer() | list() | all, %% #player_status.xx | [#player_status.xx, ...] | all | not_exist(玩家不存在)
      Result      :: term().                   %% 对应上面的参数的返回值：记录中某个字段的值|记录中某些字段组成的列表|全记录
%% @end
%% ---------------------------------------------------------------------------
get_player_info(Id, ResultForm) ->
    SerId = config:get_server_id(),
    case mod_player_create:get_real_serid_by_id(Id) of
        SerId -> %% 非本服的玩家直接跳过
            NowTime = utime:unixtime(),
            case ets:lookup(?ETS_OFFLINE_PLAYER, Id) of
                [#player_status{} = PS] ->
                    [EtsOffline] = ets:lookup(?ETS_OFFLINE_ACCESS, Id),
                    #ets_offline{access_ref = AccessRef} = EtsOffline,
                    NewEtsOffline = EtsOffline#ets_offline{access_time = NowTime, access_ref = AccessRef + 1},
                    ets:insert(?ETS_OFFLINE_ACCESS, NewEtsOffline),
                    util:record_return_form(PS, ResultForm);
                [] ->
                    case lib_player:is_id_exists(Id) of
                        true ->
                            clear_player_info(),
                            EtsOffline = make(ets_offline, [Id, NowTime, 1]),
                            PS = lib_offline_login:load_player_info(Id),
                            ets:insert(?ETS_OFFLINE_ACCESS, EtsOffline),
                            ets:insert(?ETS_OFFLINE_PLAYER, PS),
                            util:record_return_form(PS, ResultForm);
                        false ->
                            not_exist
                    end
            end;
        _ -> not_exist
    end.

update_offline_ps(Id, ValueList) ->
    NowTime = utime:unixtime(),
    case ets:lookup(?ETS_OFFLINE_PLAYER, Id) of
        [#player_status{} = PS] ->
            [EtsOffline] = ets:lookup(?ETS_OFFLINE_ACCESS, Id),
            #ets_offline{access_ref = AccessRef} = EtsOffline,
            NewEtsOffline = EtsOffline#ets_offline{access_time = NowTime, access_ref = AccessRef + 1},
            ets:insert(?ETS_OFFLINE_ACCESS, NewEtsOffline),
            NewPs = do_update_offline_ps(PS, ValueList),
            ets:insert(?ETS_OFFLINE_PLAYER, NewPs),
            ok;
        [] ->
            ok
    end.

do_update_offline_ps(Ps, []) -> Ps;
do_update_offline_ps(Ps, [{Key,Value}|List]) ->
    #player_status{figure=Figure}=Ps,
    NewPs=case Key of
              guild_id ->
                  Ps#player_status{figure=Figure#figure{guild_id=Value}};
              guild_name ->
                  Ps#player_status{figure=Figure#figure{guild_name=Value}};
              turn ->
                  Ps#player_status{figure=Figure#figure{turn=Value}};
              name ->
                  Ps#player_status{figure=Figure#figure{name =Value}};
              camp ->
                  Ps#player_status{figure=Figure#figure{camp =Value}};
              figure ->
                  Ps#player_status{figure=Figure};
              _ ->
                  Ps
          end,
    do_update_offline_ps(NewPs, List);

do_update_offline_ps(_Ps, NewPS) when is_record(NewPS, player_status) ->
    NewPS;

do_update_offline_ps(Ps, _) ->
    Ps.



make(ets_offline, [Id, AccessTime, AccessRef]) ->
    #ets_offline{
       id               = Id,
       access_time  = AccessTime,
       access_ref       = AccessRef
      };
make(_, _) -> no_match.


%% 移除超过阀值的热点数据
clear_player_info() ->
    Size  = ets:info(?ETS_OFFLINE_ACCESS, size),
    Third = round(Size/3),
    if
        Size>?HOT_OFFLINE_COUNT ->
            FactorList = [{Ets#ets_offline.id, calc_factor(Ets)} ||Ets <-ets:tab2list(?ETS_OFFLINE_ACCESS)],
            FactorList2 = lists:keysort(2, FactorList),
            spawn(fun() -> clear_player_info_helper(FactorList2, 1, Third) end);
        true -> skip
    end.

clear_player_info_helper(_L, Index, Third) when Index>Third ->
    ok;
clear_player_info_helper([{Id, _Factor}|T], Index, Third) ->
    clear_player_info(Id),
    clear_player_info_helper(T, Index+1, Third).

clear_player_info(Id) ->
    ets:delete(?ETS_OFFLINE_ACCESS, Id),
    ets:delete(?ETS_OFFLINE_PLAYER, Id),
    ok.

%% 超过一个小时未访问，最后忽视最后访问时间因子
calc_factor(#ets_offline{access_time = AccessTime, access_ref = AccessRef}) ->
    NowTime = utime:unixtime(),
    Time    = (60*60) div (max(1, NowTime - AccessTime)),
    round(Time*?ACCESS_TIME_FACTOR) + (AccessRef*?ACCESS_REF_FACTOR).