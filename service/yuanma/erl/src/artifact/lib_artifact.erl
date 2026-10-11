%%-----------------------------------------------------------------------------
%% @Module  :       lib_artifact.erl
%% @Author  :       Fwx
%% @Email   :
%% @Created :       2017-11-8
%% @Description:    神器
%%-----------------------------------------------------------------------------
-module(lib_artifact).

-include("server.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("artifact.hrl").
-include("attr.hrl").
-include("scene.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("skill.hrl").
-include("figure.hrl").
-include("def_module.hrl").

-export([
   login/1,
   get_artifact_gift/2,
   check_upgrade_lv/2,
   get_chance_max_times/0,
   sum_artifact_attr/1,
   refresh_artifact_attr/1,
   check_enchant/2,
   active_artifact/2,
   active_enchant_attr/5,
   get_ac_arti_num/1,
   get_arti_sum_lv/1,
   get_ench_sum_num/1
    ]).

-compile(export_all).

%% 登录处理数据
login(Player) ->
    #player_status{id = RoleId} = Player,

    Sql1 = io_lib:format(?sql_player_artifact_select, [RoleId]),

    F = fun([Id, Lv, Count, PercentStr], {TmpL, TmpAttr}) ->
            %% 强化属性
            {GiftAttr, GiftIds} = get_artifact_gift(Id, Lv),
            Percent = util:bitstring_to_term(PercentStr),
            LvAttr = get_cfg_lv_attr(Id, Lv),
             %% 附灵属性
            EnchAttr = case Percent of
                            [{_,_}|_] ->
                                    F1 = fun({AttrId, AttrPec}, AttrSum) ->
                                            %% 配置的属性最大值
                                            AttrMax = get_cfg_attr_max(Id, AttrId),
                                            [{AttrId, round(AttrMax * AttrPec / 100)} | AttrSum]
                                        end,
                                    lists:foldl(F1, [], Percent);
                            _ -> []
                         end,
            %% 插入神器列表
            TmpR = #artifact_info{id = Id, up_lv = Lv, lv_attr = LvAttr,
                        gift = GiftIds, gift_attr = GiftAttr, ench_time = Count,
                        ench_percent = Percent, ench_attr = EnchAttr},
            NewArInfo = refresh_artifact_attr(TmpR),
            {[NewArInfo|TmpL],  NewArInfo#artifact_info.attr ++ TmpAttr}
        end,
    {ArtiList, Attr} = lists:foldl(F, {[], []}, db:get_all(Sql1)),
    LastAttr = util:combine_list(Attr),
    NewStatusArti = #status_artifact{
        artifact_list = ArtiList,
        attr = LastAttr
       },
    Player#player_status{status_artifact = NewStatusArti}.

%% 激活神器
%% Id: 神器id
%% return: #player_status{}
active_artifact(Player, Id) ->
    #player_status{id = RoleId, figure = #figure{name = Name}, status_artifact = StatusArti} = Player,
    ArtiList = StatusArti#status_artifact.artifact_list,
    LvAttr = get_cfg_lv_attr(Id, ?ARTIFACT_MIN_LV),
    {GiftAttr, GiftIds} = lib_artifact:get_artifact_gift(Id, ?ARTIFACT_MIN_LV),
    ArtiInfo = #artifact_info{id = Id, up_lv = ?ARTIFACT_MIN_LV, lv_attr = LvAttr, gift = GiftIds, gift_attr = GiftAttr},
    NewArtiInfo = lib_artifact:refresh_artifact_attr(ArtiInfo),
    NewArtiList = [NewArtiInfo|ArtiList],
     %%--db--
    db:execute(io_lib:format(?sql_update_artifact_info, [RoleId, Id, ?ARTIFACT_MIN_LV, ?ARTIFACT_MIN_TIME, util:term_to_string(?ARTIFACT_MIN_PERCENT)])),
    NewStatusArti = lib_artifact:sum_artifact_attr(StatusArti#status_artifact{artifact_list = NewArtiList}),
    %% 成就
    {ok, TmpPlayer} = lib_achievement_api:artifact_acti_event(Player, Id),
    #artifact_active_cfg{name = ArtiName} = data_artifact:get_active_cfg(Id),
    lib_chat:send_TV({all}, ?MOD_ARTIFACT, 1, [Name, RoleId, ArtiName]),
    NewPlayer = TmpPlayer#player_status{status_artifact = NewStatusArti},
    lib_player:count_player_attribute(NewPlayer).

%% 在已有属性上加附灵百分比
%% retuen: {新的附灵百分比列表， 新的附灵百分比属性列表}
plus_own_attr_pec(Id, EnchPec, EnchAttr) ->
     %% 附灵提升百分比区间
    case data_artifact:get_percent_cfg(Id) of
        #enchant_percent_cfg{percent_range = [MinPec, MaxPec]} -> skip;
        _ -> MinPec = MaxPec = 0
    end,
     %% 随机出要增加的百分比
     PecPlus = urand:rand(MinPec, MaxPec),
     %% 过滤已满百分百的
     UnFullPec = [{AId, Pec} ||{AId, Pec} <- EnchPec, Pec < 100],
     FUllPec   = [{AId, Pec} ||{AId, Pec} <- EnchPec, Pec >= 100],
     %% 总权值
     PecSum = lists:foldl(fun({_, Pec}, Sum)-> Sum + 100 - Pec end, 0, UnFullPec),
     %% 算新的百分比
     F =  fun({AttrId, Pec}) ->
                case Pec == PecSum of   %% 只有一个属性的情况
                    false -> {AttrId, min((Pec + round(((100 - Pec) / PecSum) * PecPlus)), 100)};
                    true ->  {AttrId, min((Pec + PecPlus), 100)}
                end
          end,
     TmpUnfullPec = lists:map(F, UnFullPec),
     NewEnchPec = FUllPec ++ TmpUnfullPec,
     %% 根据新的百分比更新属性
     F1 = fun({AttrId, _}) ->
                AttrMax = lib_artifact:get_cfg_attr_max(Id, AttrId),
                {_, TmpVal} = lists:keyfind(AttrId, 1, NewEnchPec),
                {AttrId, round(AttrMax *  TmpVal / 100)}
            end,
     NewEnchAttr = lists:map(F1, EnchAttr),
     {NewEnchPec, NewEnchAttr}.



%% 获取神器天赋属性
get_artifact_gift(Id, Lv) ->
    GiftIds = data_artifact:get_all_gift_ids(Id),
    do_get_artifact_gift(GiftIds, Lv, [], []).

do_get_artifact_gift([], _Lv, UnlockGiftIds, GiftAttr) ->
    {GiftAttr, UnlockGiftIds};
do_get_artifact_gift([GiftId|L], Lv, UnlockGiftIds, GiftAttr) ->
    case data_artifact:get_gift_cfg(GiftId) of
        #artifact_gift_cfg{need_lv = UnlockLv, attr = Attr} -> ok;
        _ -> UnlockLv = 0, Attr = []
    end,
    case Lv >= UnlockLv of
        true ->
            do_get_artifact_gift(L, Lv, [GiftId|UnlockGiftIds], GiftAttr ++ Attr);
        false ->
            do_get_artifact_gift(L, Lv, UnlockGiftIds, GiftAttr)
    end.

%% 获取新激活天赋属性
get_active_gift(Id, Lv) ->
    GiftIds = data_artifact:get_all_gift_ids(Id),
    do_get_active_gift(GiftIds, Lv, 0, []).

do_get_active_gift([], _Lv, UnlockGiftId, GiftAttr) ->
    {GiftAttr, UnlockGiftId};
do_get_active_gift([GiftId|L], Lv, UnlockGiftId, GiftAttr) ->
    case data_artifact:get_gift_cfg(GiftId) of
        #artifact_gift_cfg{need_lv = UnlockLv, attr = Attr} -> ok;
        _ -> UnlockLv = 0, Attr = []
    end,
    case Lv == UnlockLv of
        true ->
            {Attr, GiftId};
        false ->
            do_get_active_gift(L, Lv, UnlockGiftId, GiftAttr)
    end.

%% 神器强化升级检测
check_upgrade_lv(StatusArti, Id) ->
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    ArtifactInfo = lists:keyfind(Id, #artifact_info.id, ArtiList),
    if
        ArtifactInfo == false -> {fail, ?ERRCODE(err171_not_active)};
        true ->
            Lv = ArtifactInfo#artifact_info.up_lv,
            LvCfg = data_artifact:get_lv_cfg(Id, Lv),
            NextLvCfg = data_artifact:get_lv_cfg(Id, Lv + 1),
            if
                is_record(LvCfg, artifact_upgrate_cfg) == false -> {fail, ?ERRCODE(err_config)};
                is_record(NextLvCfg, artifact_upgrate_cfg) == false -> {fail, ?ERRCODE(err171_max_lv)};  %% 已满级
                true -> {ok, LvCfg, ArtifactInfo}
            end
    end.


%% 神器列表属性求和
sum_artifact_attr(StatusArti) ->
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    F = fun(#artifact_info{attr = Attr}, TmpAttr) ->
              Attr ++ TmpAttr
         end,
    AttrList =  lists:foldl(F, [], ArtiList),
    NewAttr = util:combine_list(AttrList),
    StatusArti#status_artifact{attr = NewAttr}.

%% 刷新单个神器总属性
refresh_artifact_attr(ArtiInfo) ->
    #artifact_info{lv_attr = LvAttr, gift_attr = GiftAttr, ench_attr = EnchAttr} = ArtiInfo,
    %% 百分比属性 只对 等级属性起作用
    TmpAttr = case lists:keyfind(?PARTIAL_WHOLE_ADD_RATIO, 1, EnchAttr) of
                {?PARTIAL_WHOLE_ADD_RATIO, WholeAddRatio} when WholeAddRatio > 0 ->
                    Attr1 = lib_player_attr:partial_attr_convert([{?PARTIAL_WHOLE_ADD_RATIO, WholeAddRatio}] ++ LvAttr),
                    Attr2 = lists:keydelete(?PARTIAL_WHOLE_ADD_RATIO, 1, EnchAttr),
                    Attr1 ++ Attr2;
                _ -> LvAttr ++ EnchAttr
            end,
    NewAttr = util:combine_list(TmpAttr ++ GiftAttr),
    NewAttrR = lib_player_attr:to_attr_record(NewAttr),
    NewCombat = lib_player:calc_all_power(NewAttrR),
    ArtiInfo#artifact_info{attr = NewAttr, combat = NewCombat}.

%%神器附灵检测
check_enchant(StatusArti, Id) ->
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    ArtifactInfo = lists:keyfind(Id, #artifact_info.id, ArtiList),
    if
        ArtifactInfo == false -> {fail, ?ERRCODE(err171_not_active)};
        true ->
             ActiveAttr =  ArtifactInfo#artifact_info.ench_percent,
             ActiveCfg = data_artifact:get_active_cfg(Id),
             PercentCfg = data_artifact:get_percent_cfg(Id),
             AttrTmp = data_artifact:get_all_ench_attr(Id),
             AllAttr = lists:flatten(AttrTmp),
             if
                is_record(ActiveCfg, artifact_active_cfg) == false -> {fail, ?ERRCODE(err_config)};
                is_record(PercentCfg, enchant_percent_cfg) == false -> {fail, ?ERRCODE(err_config)};
                true ->
                    %% 所有属性已满百分百
                    case lists:all(fun({_, Val}) -> Val >= 100 end, ActiveAttr) andalso length(AllAttr) == length(ActiveAttr) of
                        true -> {fail, ?ERRCODE(err171_max_enchant)};
                        _ -> {ok, ArtifactInfo}
                     end
            end
    end.

%% 激活新的附灵属性
active_enchant_attr(Id, EnchPec, EnchAttr, EnchTime, Attr) ->
    WeightList = lists:map(fun({AttrId, AttrVal})->
                             case data_artifact:get_enchant_cfg(Id, AttrId) of
                                #artifact_enchant_cfg{active_weight = ActiveWeight, base_percent = TmpPercent} -> skip;
                                _ -> ActiveWeight = 0, TmpPercent = 0
                             end,
                             {ActiveWeight,{AttrId, AttrVal, TmpPercent}}
                             end, Attr),
    case urand:rand_with_weight(WeightList) of  %% 随机出要激活的属性｛id,val｝
        {NewAttrId, NewAttrVal, BasePercent}  ->
            ActAttr = {NewAttrId, round(NewAttrVal * BasePercent / 100)},
            NewEnchPec = [{NewAttrId, BasePercent} | EnchPec],
            NewEnchAttr = [ActAttr | EnchAttr],
            NewEnchTime = 0,    %% 重置附灵次数
            {NewEnchPec, NewEnchAttr, NewEnchTime, ActAttr};
        false ->
            {EnchPec, EnchAttr, EnchTime, []}
    end.

%% 获取配置附灵属性最大激活概率
get_chance_max_times() ->
    get_chance_cfg(1).

get_chance_cfg(Time) ->
    ChanceCfg = data_artifact:get_chance_cfg(Time),
    case is_record(ChanceCfg, enchant_chance_cfg) of
        true -> get_chance_cfg(Time + 1);
        false -> Time - 1
    end.

%% 获取配置等级属性
%% Id: 神器Id  Lv: 神器等级
%% return: [{属性id, 值}...]
get_cfg_lv_attr(Id, Lv) ->
    case data_artifact:get_lv_cfg(Id, Lv) of
        #artifact_upgrate_cfg{attr = LvAttr} -> LvAttr;
        _ ->[]
    end.

%% 获取配置最大附灵属性
%% Id: 神器Id  AttrId: 属性id
%% return: integer()
get_cfg_attr_max(Id, AttrId) ->
    case data_artifact:get_enchant_cfg(Id, AttrId) of
        #artifact_enchant_cfg{attr = [{_,  AttrMax}]} -> AttrMax;
        _ -> 0
    end.


%%------给成就用接口--------

%% 已激活神器数量
get_ac_arti_num(StatusArti) ->
    #status_artifact{artifact_list = ArtiList} = StatusArti,
    length(ArtiList).

%% 神器总等级
get_arti_sum_lv(StatusArti) ->
     #status_artifact{artifact_list = ArtiList} = StatusArti,
     F = fun(#artifact_info{up_lv = Lv}, Sum) ->
            Sum + Lv
         end,
     lists:foldl(F, 0, ArtiList).

%% 神器激活附灵属性数量
get_ench_sum_num(StatusArti) ->
      #status_artifact{artifact_list = ArtiList} = StatusArti,
      F = fun(#artifact_info{ench_percent = EnchPec}, Sum) ->
            Sum + length(EnchPec)
          end,
     lists:foldl(F, 0, ArtiList).











