%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2018, root
%%% @doc
%%%
%%% @end
%%% Created : 18 May 2018 by root <root@localhost.localdomain>

-module(lib_shenhe_api).

-include("predefine.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("figure.hrl").
-include("fashion.hrl").
-include("common.hrl").
-include("def_event.hrl").

-compile(export_all).

%% 审核服玩家登录配置
get_shenhe_config(Ps)->
    #player_status{id = RoleId, source = Source, figure = #figure{lv = OldLv} = Figure} = Ps,
    case check_is_shenhe_ios(Source) of
        true -> %% 包匹配到
            ?MYLOG("hjhshenhe", "RoleId:~p Source:~p ~n", [RoleId, Source]),
            SQL = <<"select scene, x, y, lv, fashion_list from shenhe_ios_config where source = '~s';">>,
            case db:get_row(io_lib:format(SQL, [Source])) of
                [DbScene, DbX, DbY, Lv, FashionBin] ->
                    case util:bitstring_to_term(FashionBin) of
                        undefined -> FashionModelList = [];
                        FashionList ->  %% WearFashionId是时装id WearColorId是颜色id PosId是位置id ModelId是 模型id
                            #figure{sex = Sex, career = Career} = Figure,
                            F = fun({PosId, WearFashionId, WearColorId}, L) ->
                                case data_fashion:get_fashion_model_con(PosId, WearFashionId, Career, Sex, 0) of
                                    #fashion_model_con{model_id = ModelId}-> [{PosId, ModelId, WearColorId}|L];
                                    _ -> L
                                end
                            end,
                            FashionModelList = lists:foldl(F, [], FashionList)
                    end,
                    if
                        Figure#figure.lv >= Lv -> %% 
                            Ps#player_status{figure = Figure#figure{fashion_model = FashionModelList}};
                        true ->
                            self() ! {'alpha_finish_lv_task'},
                            ExpLimit = data_exp:get(Lv),
                            NewFigure = Figure#figure{lv = Lv, fashion_model = FashionModelList},
                            db:execute(io_lib:format(<<"update `player_low` set lv = ~w where id=~w ">>, [Lv, RoleId])),
                            %% 
                            case data_scene:get(DbScene) of 
                                #ets_scene{type = ?SCENE_SHENHE_IOS, width = Width, height = Height} ->
                                    RX = urand:rand(10, Width-10), RY = urand:rand(10, Height-10);
                                _ ->
                                    RX = DbX, RY = DbY
                            end,
                            NewPs = Ps#player_status{figure = NewFigure, scene = DbScene, x = RX, y = RY, exp = ExpLimit-100, exp_lim = ExpLimit},
                            %% 派发升级事件
                            case OldLv =/= Lv of
                                true ->
                                    {ok, NewPs2} = lib_player_event:dispatch(NewPs, ?EVENT_LV_UP),
                                    NewPs2;
                                false ->
                                    NewPs
                            end
                    end;
                _ ->
                    Ps
            end;
        false ->
            Ps
    end.

%% 审核服进入场景
shenhe_change_scene_op(_LastTaskId, ChangeSceneId, X, Y) -> {ChangeSceneId, X, Y}.
    % NChangeSceneId = if ChangeSceneId == 0 -> ?BORN_SCENE; true -> ChangeSceneId end,
    % if
    %     NChangeSceneId == ?BORN_SCENE andalso LastTaskId < ?BORN_SPECAIL_TASK ->
    %         {DbX, DbY} = ?BORN_SCENE_COORD;
    %     NChangeSceneId == ?BORN_SCENE  andalso LastTaskId == ?BORN_SPECAIL_TASK ->
    %         {DbX, DbY} = ?BORN_SCENE_COORD1;
    %     %% 新手飞船范围内
    %     NChangeSceneId == ?BORN_SCENE  andalso X < 3110 andalso Y > 4200 ->
    %         {DbX, DbY} = ?BORN_SCENE_COORD1;
    %     true ->
    %         if 
    %             X == 0 andalso Y == 0 -> [DbX, DbY] = lib_scene:get_born_xy(NChangeSceneId);
    %             true -> [DbX, DbY] = [X, Y]
    %         end
    % end,
    % {NChangeSceneId, DbX, DbY}.
    

%% 审核属性加成
%% 审核服属性
%% 攻击:0<等级<=200     攻击=等级*60+12000
%%     200<等级<=500   攻击=（等级-200）*800+24000
%%     等级>500        攻击=（等级-500）*10000+264000
%% 气血:攻击*40
%% 破甲:攻击/2
%% 防御:攻击/2
get_shenhe_attr(Source, Lv) ->
    case check_is_shenhe_ios(Source) of
        true ->
            Att = round(get_shenhe_ios_att(Lv)),
            Hp = Att * 40,
            Wreck = round(Att / 2),
            [{1, Att}, {2, Hp+100000}, {3, Wreck}, {4,  Wreck+1000000}];
        _ ->
            []
    end.

%% 获取审核服ios战斗属性
get_shenhe_ios_att(Lv) when Lv =< 200 -> Lv*60+12000;
get_shenhe_ios_att(Lv) when Lv =< 500 -> (Lv-200)*800+24000;
get_shenhe_ios_att(Lv) -> (Lv-500)*10000+264000.

%% 判断是不是IOS审核服
check_is_shenhe_ios(_Source) ->
    % case re:run(Source, "alpha") of
    % %% case re:run(Source, "qhbgd") of
    %     {match, _} -> true;
    %     _ -> false
    % end.
    config:get_is_shenhe().

