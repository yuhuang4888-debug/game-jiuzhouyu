%% ---------------------------------------------------------------------------
%% @doc 玩家历史镜像(1个小时更新一次)
%% @author hek
%% @since  2016-11-14
%% @deprecated 
%% ---------------------------------------------------------------------------
-module (lib_player_mirror_mod).
%% -include ("attr.hrl").
%% -include ("battle.hrl").
%% -include ("partner.hrl").
%% -include ("skill.hrl").
%% -include ("figure.hrl").
%% -include ("server.hrl").
%% -include ("scene.hrl").
%% -include ("def_fun.hrl").
%% -include ("common.hrl").
%% -include ("rec_mirror.hrl").
%% -export ([
%%     timer_rank/2,                      %% 定时生成镜像排行
%%     timer_init_player_mirror_rank/4,   %% 定时生成镜像排行：分页加载player_mirror_rank
%%     server_init/0,                     %% 进程启动初始化
%% 	update_mirror_attr/1               %% 更新玩家镜像信息
%% ]).
%% -export ([
%%     gm_test/1,                         %% 方案性能测试(插入数据)
%%     gm_copy/0                          %% 方案性能测试(拷贝数据)
%% ]).
%% -compile (export_all).

%% % -define (DEBUG_CFG, true).
%% -ifdef  (DEBUG_CFG).
%% -define (DEBUG_PRINT(F, A),  util:errlog(F, A, ?MODULE, ?LINE)).
%% -else.
%% -define (DEBUG_PRINT(_F, _A),  skip).
%% -endif.
%% %% ------------------------------- 常量配置 -------------------------------
%% %% 【注】：以下常量以及代码中分批或分页处理中的睡眠时间，修改时请做性能测试
%% %% ------------------------------------------------------------------------
%% -define (RANK_MAX,          5000).      %% 镜像排行榜最大数量
%% -define (COPY_PAGE_COUNT,   100).       %% 分页拷贝数据，每页的数据量
%% -define (SELECT_PAGE_COUNT, 100).       %% 分页加载数据，每页的数据量

%% %% ------------------------------------------------------------------------
%% %% ------------------------------ timer_rank ------------------------------

%% %% 步骤一：开始生成排行，将排行生成状态置为 1正在生成排行
%% %%         从玩家玩家镜像信息表（player_mirror），获取战力排行前5000玩家，其余删除
%% timer_rank(State, 1) ->  
%%     ?DEBUG_PRINT("timer_rank 1 start:~p~n", [utime:unixtime()]),
%%     case lib_player_mirror_api:get_mirror_rank_status() of
%%         0 ->
%%             ets:insert(?ETS_MIRROR, {rank_status, 1}),
%%             RankList = sort_player_mirror(),
%%             RankMap = sublist_player_mirror(RankList),
%%             ?DEBUG_PRINT("timer_rank 1 end:~p~n", [utime:unixtime()]),            
%%             {ok, State#mirror_state{rank_tmp_map = RankMap}};
%%         %% 镜像排行生成期间，不给再生成排行（比如服务器重启时在排行了，刚好也到了定时刷新排行）
%%         _ ->
%%             {ok, State}
%%     end;

%% %% 步骤二：清空玩家镜像战力排行信息表（player_mirror_rank）
%% %%         将player_mirror复制到player_mirror_rank表
%% timer_rank(State, 2) ->
%%     ?DEBUG_PRINT("timer_rank 2 start:~p~n", [utime:unixtime()]),
%%     spawn(fun() -> 
%%         db_truncate_player_mirror_rank(), 
%%         timer:sleep(300),
%%         db_copy_player_mirror_batch(), 
%%         ?DEBUG_PRINT("timer_rank 2 end:~p~n", [utime:unixtime()]),          
%%         lib_player_mirror_api:timer_rank(3) end),
%%     {ok, State};

%% %% 步骤三：更新player_mirror_rank表中玩家的排名
%% timer_rank(State, 3) ->
%%     ?DEBUG_PRINT("timer_rank 3 start:~p~n", [utime:unixtime()]),
%%     #mirror_state{rank_tmp_map = RankTmpMap} = State,
%%     RankList = maps:to_list(RankTmpMap),
%%     spawn(fun() -> 
%%         db_update_mirror_rank_batch(RankList, 0),        
%%         ?DEBUG_PRINT("timer_rank 3 end:~p~n", [utime:unixtime()]),
%%         lib_player_mirror_api:timer_rank(4)
%%     end),
%%     {ok, State};

%% %% 步骤四：加载玩家镜像战力排行信息表（player_mirror_rank）进内存 player_tmp_map字段
%% timer_rank(State, 4) ->
%%     #mirror_state{rank_tmp_map = RankTmpMap, ref = OldRef} = State,
%%     PageCount  = ?SELECT_PAGE_COUNT,   
%%     TotalCount = maps:size(RankTmpMap),
%%     Msg = {'timer_init_player_mirror_rank', 1, PageCount, TotalCount},
%%     Ref = util:send_after(OldRef, 10, self(), Msg),
%%     {ok, State#mirror_state{ref = Ref} };

%% %% 步骤五：结束生成排行，将排行生成状态置为 0空闲
%% timer_rank(State, 5) ->
%%     #mirror_state{
%%         player_tmp_map = PlayerMap, rank_tmp_map = RankMap} = State,
%%     NewState = State#mirror_state{
%%         player_map = PlayerMap, rank_map = RankMap, 
%%         player_tmp_map = #{}, rank_tmp_map = #{}},
%%     RankList = maps:to_list(RankMap),
%%     [ets:insert(?ETS_MIRROR_RANK, {RankId, PlayerId})|| {RankId, PlayerId}<- RankList],
%%     ets:insert(?ETS_MIRROR, {rank_status, 0}),
%%     ets:insert(?ETS_MIRROR, {rank_count, maps:size(RankMap)}),

%%     _OldMemory = erlang:process_info(self(), memory),
%%     erlang:garbage_collect(self()),
%%     _NewMemory = erlang:process_info(self(), memory),
%%     ?DEBUG_PRINT("mirror rank garbage_collect: endtime:~p ~n old:~p, new:~p~n", [utime:unixtime(), _OldMemory, _NewMemory]),
%%     {ok,  NewState}.

%% timer_init_player_mirror_rank(State, Page, PageCount, TotalCount) -> 
%%     #mirror_state{player_tmp_map = PlayerTmpMap, ref = OldRef} = State,
%%     util:cancel_timer(OldRef),
%%     PageStart = (Page - 1)*PageCount,
%%     PageCount2= ?IF(PageStart + PageCount > TotalCount, TotalCount - PageStart, PageCount),
%%     PlayerTmpMap2 = get_player_mirror_rank_page(PageStart, PageCount, PlayerTmpMap),
%%     case PageCount2==PageCount of
%%         true ->
%%             Msg = {'timer_init_player_mirror_rank', Page+1, PageCount, TotalCount},
%%             Ref = util:send_after(OldRef, 50, self(), Msg),
%%             {ok, State#mirror_state{player_tmp_map = PlayerTmpMap2, ref = Ref} };
%%         false -> 
%%             lib_player_mirror_api:timer_rank(5),
%%             {ok, State#mirror_state{player_tmp_map = PlayerTmpMap2, ref = none} }
%%     end.

%% get_player_mirror_rank_page(PageStart, PageCount, PlayerTmpMap) ->
%%     List = db_get_player_mirror_rank_page(PageStart, PageCount),
%%     init_player_mirror_rank(List, PlayerTmpMap).

%% sort_player_mirror() ->
%%     PlayerList = db_get_all_player_mirror_combatpower(),
%%     sort_player_mirror_helper(PlayerList).

%% sort_player_mirror_helper(PlayerList) ->
%%     F1 = fun([_PlayerIdA, CombatPowerA], [_PlayerIdB, CombatPowerB]) -> CombatPowerA>CombatPowerB end,
%%     NewList = lists:sort(F1, PlayerList),
%%     F2 = fun([PlayerId, _CombatPower], {RankId, RankList}) -> {RankId+1, [{RankId, PlayerId}|RankList] } end,
%%     {_, LastList} = lists:foldl(F2, {1, []}, NewList),
%%     lists:reverse(LastList).

%% sublist_player_mirror(RankList) ->
%%     RankLen  = length(RankList),
%%     case RankLen > ?RANK_MAX of
%%         true -> DeleteRankList = lists:nthtail(?RANK_MAX, RankList);
%%         false -> DeleteRankList = []
%%     end,
%%     %% 移除完超过5000名后的数据，进入步骤二
%%     spawn(fun() -> 
%%         db_delete_player_mirror_batch(DeleteRankList, 0), 
%%         lib_player_mirror_api:timer_rank(2) end),
%%     LastRankList = lists:sublist(RankList, ?RANK_MAX),
%%     lists:foldl(fun({RankId, PlayerId}, Map) -> maps:put(RankId, PlayerId, Map) end, #{}, LastRankList).

%% %% ---------------------------- gen_server init ---------------------------
%% server_init() ->
%%     case db_get_player_mirror_rankid_0_count() of
%%         %% 上次排行生成一半的时候，服务器关闭了，出现rank_id为0情况，重新生成排行
%%         Count when Count > 0->
%%             List = db_get_all_player_mirror_rank_combatpower(),
%%             SortList = sort_player_mirror_helper(List),
%%             RankTmpMap = init_rank_map(SortList),
%%             State = #mirror_state{rank_tmp_map = RankTmpMap},
%%             %% 从步骤三开始生成排行数据
%%             ets:insert(?ETS_MIRROR, {rank_status, 1}),
%%             lib_player_mirror_api:timer_rank(3),
%%             {ok, State};
%%         _->
%%             List = db_get_all_player_mirror_rank_combatpower(),
%%             SortList = sort_player_mirror_helper(List),
%%             RankTmpMap = init_rank_map(SortList),
%%             State = #mirror_state{rank_tmp_map = RankTmpMap},  
%%             %% 从步骤四开始生成排行数据
%%             ets:insert(?ETS_MIRROR, {rank_status, 1}),
%%             lib_player_mirror_api:timer_rank(4),
%%             {ok, State}

%%             % 注释方法：一次性加载全部字段出来，服务器启动占用比较多cpu
%%             % List = db_get_all_player_mirror_rank(),
%%             % PlayerMap = init_player_mirror_rank(List, #{}),
%%             % RankMap = init_rank_map(List),
%%             % State = #mirror_state{
%%             %     player_map = PlayerMap, rank_map = RankMap},
%%             % {ok, State}
%%     end.

%% init_player_mirror_rank(List, PlayerMap) ->
%%     F = fun([PlayerId, RankId, Lv, HightCombatPower, BattleAttr, SkillList, EmBattleList], Map) -> 
%%         NewBattleAttr = util:bitstring_to_term(BattleAttr),
%%         NewSkillList  = util:bitstring_to_term(SkillList),
%%         NewEmBattleList  = util:bitstring_to_term(EmBattleList),
%%         LastBattleAttr = set_battle_attr_args(NewBattleAttr, #battle_attr{}),
%%         NewEmBattleList2 = set_embattle_list_args(NewEmBattleList, []),
%%         LastEmBattleList = case NewEmBattleList2 of
%%             [] -> 
%%                 RecEmbattle = #rec_embattle{
%%                     pos=?PLAYER_EMBATTLE_POS, type=?BATTLE_SIGN_PLAYER, id=PlayerId, partner_id=0, lv=Lv},
%%                 [RecEmbattle];
%%             _ -> NewEmBattleList2
%%         end,
%%         MirrorPlayer =  #mirror_player{
%%             id = PlayerId, rank_id = RankId, lv = Lv, hightest_combat_power = HightCombatPower,
%%             battle_attr= LastBattleAttr, skill_list = NewSkillList, embattle_list = LastEmBattleList
%%         },
%%         maps:put(PlayerId, MirrorPlayer, Map)
%%     end,
%%     lists:foldl(F, PlayerMap, List).

%% init_rank_map(List) ->
%%     F = fun
%%         ([PlayerId, RankId|_], Map) -> maps:put(RankId, PlayerId, Map);
%%         ({RankId, PlayerId}, Map) -> maps:put(RankId, PlayerId, Map) 
%%         end,
%%     lists:foldl(F, #{}, List).

%% %% -------------------------- update_mirror_attr --------------------------

%% update_mirror_attr(PS) -> 
%%     PlayerId = PS#player_status.id,
%%     Lv = PS#player_status.figure#figure.lv,
%%     HightCombatPower = PS#player_status.hightest_combat_power,
%% 	BattleAttr= PS#player_status.battle_attr,
%% 	SkillList = PS#player_status.skill#status_skill.skill_list,
%% 	EmBattleList = lib_war_god:init_partner_list(),

%%     BattleAttr2 = battle_attr2tuplelist_args(BattleAttr),
%%     EmBattleList2 = embattle_list2tuplelist_args(EmBattleList),
%%     db_update_player_mirror(PlayerId, Lv, HightCombatPower, BattleAttr2, SkillList, EmBattleList2),
%% 	ok.

%% %% -------------------------- attr_args function --------------------------

%% embattle_list2tuplelist_args(EmBattleList) ->
%%     [embattle2tuplelist_args(EmBattle)||EmBattle <-EmBattleList].
    
%% embattle2tuplelist_args(EmBattle) ->
%%     #rec_embattle{
%%         pos       = Pos,
%%         type      = Type,
%%         id        = Id,
%%         partner_id= PartnerId,
%%         lv        = Lv,
%%         battle_attr = BattleAttr
%%     } = EmBattle,
%%     BattleAttr2 = battle_attr2tuplelist_args(lib_player_attr:attr_to_battle_attr(BattleAttr)),
%%     {Pos, [{type, Type}, {id, Id}, {partner_id, PartnerId}, {lv, Lv}, {battle_attr, BattleAttr2}] }.

%% battle_attr2tuplelist_args(BattleAttr) ->
%% 	#battle_attr{
%%         hp_lim    = HpLimA,
%% 		%% mp_lim 	  = MpLim,
%% 		%% anger_lim = AngerLim,
%%         %% att_speed = AttSpeedA,
%% 		attr  	  = Attr
%% 	} = BattleAttr,
%% 	#attr{
%%         att       = Att, 
%%         %% metal_att = MetalAtt, 
%%         %% wood_att  = WoodAtt, 
%%         %% water_att = WaterAtt,
%%         %% fire_att  = FireAtt, 
%%         %% earth_att = EarthAtt, 
%%         %% hp_lim    = HpLimB, 
%%         %% hp_ratio  = HpRatio, 
%%         %% physique  = Physique, 
%%         %% agile     = Agile, 
%%         %% forza     = Forza, 
%%         %% dexterous = Dexterous, 
%%         %% metal_resis = MetalResis, 
%%         %% wood_resis  = WoodResis, 
%%         %% water_resis = WaterResis, 
%%         %% fire_resis  = FireResis,  
%%         %% earth_resis = EarthResis, 
%%         %% all_resis   = AllResis, 
%%         %% all_resis_del = AllResisDel, 
%%         hit         = Hit, 
%%         dodge       = Dodge, 
%%        %% dodge_del   = DodgeDel, 
%%         crit        = Crit
%%         %% crit_hurt   = CritHurt, 
%%         %% crit_del    = CritDel, 
%%         %% crit_hurt_del = CritHurtDel, 
%%         %% hp_resume     = HpResume, 
%%         %% hp_resume_add = HpResumeAdd, 
%%         %% suck_blood  = SuckBlood, 
%%         %% att_speed   = AttSpeedB, 
%%         %% speed       = Speed
%%         %% hurt        = Hurt, 
%%         %% dizzy       = Dizzy, 
%%         %% slow        = Slow, 
%%         %% cripple     = Cripple, 
%%         %% paralysis   = Paralysis, 
%%         %% hurt_resis  = HurtResis, 
%%         %% dizzy_resis = DizzyResis, 
%%         %% slow_resis  = SlowResis, 
%%         %% cripple_resis = CrippleResis, 
%%         %% paralysis_resis = ParalysisResis, 
%%         %% effect      = Effect, 
%%         %% effect_resis= EffectResis, 
%%         %% hurt_time   = HurtTime, 
%%         %% dizzy_time  = DizzyTime, 
%%         %% slow_time   = SlowTime, 
%%         %% cripple_time        = CrippleTime, 
%%         %% paralysis_time      = ParalysisTime, 
%%         %% hurt_time_del       = HurtTimeDel, 
%%         %% dizzy_time_del      = DizzyTimeDel,
%%         %% slow_time_del       = SlowTimeDel, 
%%         %% cripple_time_del    = CrippleTimeDel, 
%%         %% paralysis_time_del  = ParalysisTimeDel, 
%%         %% effect_time         = EffectTime, 
%%         %% effect_time_del     = EffectTimeDel, 
%%         %% rebound_srd         = ReboundSrd, 
%%         %% rebound_rd          = ReboundRd,
%%         %% att_ratio           = AttRatio
%%     } = Attr,
%%     AttrList = 
%%     	[
%%     		{att, 		Att}, 
%%         	%% {metal_att, MetalAtt}, 
%%         	%% {wood_att, 	WoodAtt}, 
%%         	%% {water_att, WaterAtt},
%%         	%% {fire_att, 	FireAtt}, 
%%         	%% {earth_att, EarthAtt}, 
%%         	%% {hp_lim, 	HpLimB}, 
%%         	%% {hp_ratio, 	HpRatio}, 
%%         	%% {physique, 	Physique}, 
%%         	%% {agile, 	Agile}, 
%%         	%% {forza, 	Forza}, 
%%         	%% {dexterous, Dexterous}, 
%%         	%% {metal_resis, 	MetalResis}, 
%%         	%% {wood_resis, 	WoodResis}, 
%%         	%% {water_resis, 	WaterResis}, 
%%         	%% {fire_resis, 	FireResis},  
%%         	%% {earth_resis, 	EarthResis}, 
%%         	%% {all_resis, 	AllResis}, 
%%         	%% {all_resis_del, AllResisDel}, 
%%         	{hit, Hit}, 
%%         	{dodge, Dodge}, 
%%         	%% {dodge_del, DodgeDel}, 
%%         	{crit, Crit}
%%         	%% {crit_hurt, CritHurt}, 
%%         	%% {crit_del, CritDel}, 
%%         	%% {crit_hurt_del, CritHurtDel}, 
%%         	%% {hp_resume, HpResume}, 
%%         	%% {hp_resume_add, HpResumeAdd}, 
%%         	%% {suck_blood, SuckBlood}, 
%%         	%% {att_speed, AttSpeedB}, 
%%             %% {speed, Speed}
%%         	%% {hurt, Hurt}, 
%%         	%% {dizzy, Dizzy}, 
%%         	%% {slow, Slow}, 
%%         	%% {cripple, Cripple}, 
%%         	%% {paralysis, Paralysis}, 
%%         	%% {hurt_resis, HurtResis}, 
%%         	%% {dizzy_resis, DizzyResis}, 
%%         	%% {slow_resis, SlowResis}, 
%%         	%% {cripple_resis, CrippleResis}, 
%%         	%% {paralysis_resis, ParalysisResis}, 
%%         	%% {effect, Effect}, 
%%         	%% {effect_resis, EffectResis}, 
%%         	%% {hurt_time, HurtTime}, 
%%         	%% {dizzy_time, DizzyTime}, 
%%         	%% {slow_time, SlowTime}, 
%%         	%% {cripple_time, CrippleTime}, 
%%         	%% {paralysis_time, ParalysisTime}, 
%%         	%% {hurt_time_del, HurtTimeDel}, 
%%         	%% {dizzy_time_del, DizzyTimeDel},
%%         	%% {slow_time_del, SlowTimeDel}, 
%%         	%% {cripple_time_del, CrippleTimeDel}, 
%%         	%% {paralysis_time_del, ParalysisTimeDel}, 
%%         	%% {effect_time, EffectTime}, 
%%         	%% {effect_time_del, EffectTimeDel}, 
%%         	%% {rebound_srd, ReboundSrd}, 
%%         	%% {rebound_rd, ReboundRd},
%%         	%% {att_ratio, AttRatio}
%%         ],
%%     AttrList2 = ignore_zero_attr(AttrList, []),
%%     [{hp_lim, HpLimA}, {attr, AttrList2}].

%% ignore_zero_attr([], List) -> List;
%% ignore_zero_attr([Tuple|T], List) ->
%%     case Tuple of
%%         {_Key, 0} -> ignore_zero_attr(T, List);
%%         _ -> ignore_zero_attr(T, [Tuple|List])
%%     end.

%% set_embattle_list_args([], EmBattleList) -> EmBattleList;
%% set_embattle_list_args([{Pos, Args}|T], EmBattleList) ->
%%     RecEmbattle = set_embattle_args(Args, #rec_embattle{pos = Pos}),
%%     NewEmBattleList = lists:keystore(Pos, #rec_embattle.pos, EmBattleList, RecEmbattle),
%%     set_embattle_list_args(T, NewEmBattleList).

%% set_embattle_args([], EmBattle) -> EmBattle;
%% set_embattle_args([Tuple|T], EmBattle) ->
%%     NewEmBattle = case Tuple of
%%         {type, Type} -> EmBattle#rec_embattle{type = Type};             
%%         {id, Id}     -> EmBattle#rec_embattle{id = Id};
%%         {partner_id, PartnerId} -> EmBattle#rec_embattle{partner_id = PartnerId};
%%         {lv, Lv}                -> EmBattle#rec_embattle{lv = Lv};
%%         {battle_attr, BattleAttr} -> 
%%             NewBattleAttr = set_battle_attr_args(BattleAttr, #battle_attr{}),
%%             EmBattle#rec_embattle{battle_attr =  NewBattleAttr#battle_attr.attr };
%%         _ ->
%%             ?ERR("unkown embattle:~p~n", [Tuple]),
%%             EmBattle
%%     end,
%%     set_embattle_args(T, NewEmBattle).

%% set_battle_attr_args([], BattleAttr) -> 
%%     BattleAttr#battle_attr{hp = BattleAttr#battle_attr.hp_lim};
%% set_battle_attr_args([Tuple|T], BattleAttr) ->
%%     NewBattleAttr = case Tuple of
%%         {hp_lim, HpLim}         -> BattleAttr#battle_attr{hp_lim = HpLim};
%%         %% {att_speed, AttSpeedA}  -> BattleAttr#battle_attr{att_speed = AttSpeedA};
%%         %% {mp_lim, MpLim}         -> BattleAttr#battle_attr{mp_lim = MpLim};
%%         %% {anger_lim, AngerLim}   -> BattleAttr#battle_attr{anger_lim = AngerLim};
%%         {attr, AttrList}        -> BattleAttr#battle_attr{attr = set_attr_args(AttrList, #attr{}) };
%%         _ ->
%%             ?ERR("unkown battle_attr:~p~n", [Tuple]),
%%             BattleAttr
%%     end,
%%     set_battle_attr_args(T, NewBattleAttr).

%% set_attr_args([], Attr) -> Attr;
%% set_attr_args([Tuple|T], Attr) ->
%%     NewAttr = case Tuple of
%%         {att,       Att}        -> Attr#attr{att   = Att};
%%         %% {metal_att, MetalAtt}   -> Attr#attr{metal_att   = MetalAtt};
%%         %% {wood_att,  WoodAtt}    -> Attr#attr{wood_att   = WoodAtt};
%%         %% {water_att, WaterAtt}   -> Attr#attr{water_att   = WaterAtt};
%%         %% {fire_att,  FireAtt}    -> Attr#attr{fire_att   = FireAtt};
%%         %% {earth_att, EarthAtt}   -> Attr#attr{earth_att   = EarthAtt};
%%         %% {hp_lim,    HpLim}      -> Attr#attr{hp_lim   = HpLim};
%%         %% {hp_ratio,  HpRatio}    -> Attr#attr{hp_ratio   = HpRatio}; 
%%         %% {physique,  Physique}   -> Attr#attr{physique   = Physique};
%%         %% {agile,     Agile}      -> Attr#attr{agile   = Agile};
%%         %% {forza,     Forza}      -> Attr#attr{forza   = Forza};
%%         %% {dexterous, Dexterous}  -> Attr#attr{dexterous   = Dexterous};
%%         %% {metal_resis,   MetalResis}     -> Attr#attr{metal_resis   = MetalResis};
%%         %% {wood_resis,    WoodResis}      -> Attr#attr{wood_resis   = WoodResis};
%%         %% {water_resis,   WaterResis}     -> Attr#attr{water_resis   = WaterResis};
%%         %% {fire_resis,    FireResis}      -> Attr#attr{fire_resis   = FireResis}; 
%%         %% {earth_resis,   EarthResis}     -> Attr#attr{earth_resis   = EarthResis}; 
%%         %% {all_resis,     AllResis}       -> Attr#attr{all_resis   = AllResis}; 
%%         %% {all_resis_del, AllResisDel}    -> Attr#attr{all_resis_del   = AllResisDel};
%%         {hit, Hit}                  -> Attr#attr{hit   = Hit}; 
%%         {dodge, Dodge}              -> Attr#attr{dodge   = Dodge};
%%         %% {dodge_del, DodgeDel}       -> Attr#attr{dodge_del   = DodgeDel};
%%         {crit, Crit}                -> Attr#attr{crit   = Crit}; 
%%         %% {crit_hurt, CritHurt}       -> Attr#attr{crit_hurt   = CritHurt}; 
%%         %% {crit_del, CritDel}         -> Attr#attr{crit_del   = CritDel}; 
%%         %% {crit_hurt_del, CritHurtDel}    -> Attr#attr{crit_hurt_del   = CritHurtDel}; 
%%         %% {hp_resume, HpResume}           -> Attr#attr{hp_resume   = HpResume}; 
%%         %% {hp_resume_add, HpResumeAdd}    -> Attr#attr{hp_resume_add   = HpResumeAdd}; 
%%         %% {suck_blood, SuckBlood}         -> Attr#attr{suck_blood   = SuckBlood}; 
%%         %% {att_speed, AttSpeed}           -> Attr#attr{att_speed   = AttSpeed}; 
%%         %% {speed, Speed}                  -> Attr#attr{speed   = Speed}; 
%%         %% {hurt, Hurt}                    -> Attr#attr{hurt   = Hurt}; 
%%         %% {dizzy, Dizzy}                  -> Attr#attr{dizzy   = Dizzy}; 
%%         %% {slow, Slow}                    -> Attr#attr{slow   = Slow}; 
%%         %% {cripple, Cripple}              -> Attr#attr{cripple   = Cripple}; 
%%         %% {paralysis, Paralysis}          -> Attr#attr{paralysis   = Paralysis}; 
%%         %% {hurt_resis, HurtResis}         -> Attr#attr{hurt_resis   = HurtResis}; 
%%         %% {dizzy_resis, DizzyResis}       -> Attr#attr{dizzy_resis   = DizzyResis}; 
%%         %% {slow_resis, SlowResis}         -> Attr#attr{slow_resis   = SlowResis}; 
%%         %% {cripple_resis, CrippleResis}   -> Attr#attr{cripple_resis   = CrippleResis}; 
%%         %% {paralysis_resis, ParalysisResis}    -> Attr#attr{paralysis_resis   = ParalysisResis}; 
%%         %% {effect, Effect}                -> Attr#attr{effect   = Effect}; 
%%         %% {effect_resis, EffectResis}     -> Attr#attr{effect_resis   = EffectResis}; 
%%         %% {hurt_time, HurtTime}           -> Attr#attr{hurt_time   = HurtTime}; 
%%         %% {dizzy_time, DizzyTime}         -> Attr#attr{dizzy_time   = DizzyTime}; 
%%         %% {slow_time, SlowTime}           -> Attr#attr{slow_time   = SlowTime}; 
%%         %% {cripple_time, CrippleTime}     -> Attr#attr{cripple_time   = CrippleTime}; 
%%         %% {paralysis_time, ParalysisTime} -> Attr#attr{paralysis_time   = ParalysisTime}; 
%%         %% {hurt_time_del, HurtTimeDel}    -> Attr#attr{hurt_time_del   = HurtTimeDel}; 
%%         %% {dizzy_time_del, DizzyTimeDel}  -> Attr#attr{dizzy_time_del   = DizzyTimeDel};
%%         %% {slow_time_del, SlowTimeDel}    -> Attr#attr{slow_time_del   = SlowTimeDel}; 
%%         %% {cripple_time_del, CrippleTimeDel} -> Attr#attr{cripple_time_del   = CrippleTimeDel}; 
%%         %% {paralysis_time_del, ParalysisTimeDel} -> Attr#attr{paralysis_time_del   = ParalysisTimeDel}; 
%%         %% {effect_time, EffectTime}       -> Attr#attr{effect_time   = EffectTime}; 
%%         %% {effect_time_del, EffectTimeDel} -> Attr#attr{effect_time_del   = EffectTimeDel}; 
%%         %% {rebound_srd, ReboundSrd}       -> Attr#attr{rebound_srd   = ReboundSrd}; 
%%         %% {rebound_rd, ReboundRd}         -> Attr#attr{rebound_rd   = ReboundRd};
%%         %% {att_ratio, AttRatio}           -> Attr#attr{att_ratio   = AttRatio};
%%         _ ->
%%             ?ERR("unkown attr:~p~n", [Tuple]),
%%             Attr
%%     end,
%%     set_attr_args(T, NewAttr).

%% %% ------------------------------ db操作相关 ------------------------------

%% db_update_player_mirror(PlayerId, Lv, HightCombatPower, BattleAttr, SkillList, EmBattleList) ->
%%     Time = utime:unixtime(),
%%     BattleAttr2   = util:term_to_bitstring(BattleAttr),
%%     SkillList2    = util:term_to_bitstring(SkillList),
%%     EmBattleList2 = util:term_to_bitstring(EmBattleList),
%%     SqlInsert     = io_lib:format(?sql_player_mirror_insert, 
%%             [PlayerId, Lv, HightCombatPower, BattleAttr2, SkillList2, EmBattleList2, Time]),
%%     case db:execute(SqlInsert) of
%%         0 -> db:execute(io_lib:format(?sql_player_mirror_update, 
%%                 [Lv, HightCombatPower, BattleAttr2, SkillList2, EmBattleList2, Time, PlayerId]));
%%         _ -> skip
%%     end.

%% db_get_player_mirror_count() ->
%%     case db:get_one(?sql_player_mirror_count) of  Count when is_integer(Count) -> Count; _ -> 0 end.

%% db_get_all_player_mirror_combatpower() ->
%%     db:get_all(io_lib:format(?sql_player_mirror_combatpower_select, [])).

%% db_delete_player_mirror_batch([], _I) -> skip;
%% db_delete_player_mirror_batch([{_RankId, PlayerId}|T], I) ->
%%     case I rem 30 of 0 -> timer:sleep(200); _ -> skip end,
%%     db_delete_player_mirror(PlayerId),
%%     db_delete_player_mirror_batch(T, I+1).

%% db_delete_player_mirror(PlayerId) ->
%%     db:execute(io_lib:format(?sql_player_mirror_delete, [PlayerId]) ).

%% db_truncate_player_mirror_rank() ->
%%     db:execute(io_lib:format(?sql_player_mirror_rank_truncate, []) ).

%% %% 分页拷贝数据，每页的数据量
%% db_copy_player_mirror_batch() ->
%%     PageCount  = ?COPY_PAGE_COUNT,   
%%     TotalCount = db_get_player_mirror_count(),
%%     db_copy_player_mirror_helper(1, PageCount, TotalCount).

%% %% 如果计算出来本页数据量与每页基础数据量不一致，则表示到了页尾，结束递归
%% db_copy_player_mirror_helper(Page, PageCount, TotalCount) ->
%%     PageStart = (Page - 1)*PageCount,
%%     PageCount2= ?IF(PageStart + PageCount > TotalCount, TotalCount - PageStart, PageCount),
%%     db:execute(io_lib:format(?sql_player_mirror_rank_copy, [PageStart, PageCount2]) ),
%%     case PageCount2 =/=PageCount of
%%         true -> skip;
%%         false -> timer:sleep(200), db_copy_player_mirror_helper(Page+1, PageCount, TotalCount)
%%     end.

%% db_update_mirror_rank_batch([], _I) -> skip;
%% db_update_mirror_rank_batch([{RankId, PlayerId}|T], I) ->
%%     case I rem 100 of 0 -> timer:sleep(200); _ -> skip end,
%%     db_update_mirror_rank(PlayerId, RankId),
%%     db_update_mirror_rank_batch(T, I + 1).

%% db_update_mirror_rank(PlayerId, RankId) ->
%%     db:execute(io_lib:format(?sql_player_mirror_rank_update, [RankId, PlayerId]) ).

%% db_get_player_mirror_rank_page(PageStart, PageCount) ->
%%     db:get_all(io_lib:format(?sql_player_mirror_rank_select, [PageStart, PageCount]) ).

%% db_get_all_player_mirror_rank() ->
%%     db:get_all(io_lib:format(?sql_player_mirror_rank_select_all, []) ).

%% db_get_all_player_mirror_rank_combatpower() ->
%%     db:get_all(io_lib:format(?sql_player_mirror_rank_combatpower_select, [])).

%% db_get_player_mirror_rankid_0_count() ->
%%     case db:get_one(?sql_player_mirror_rankid_0_count) of  Count when is_integer(Count) -> Count; _ -> 0 end.

%% %% ----------------------------- 方案性能测试 -----------------------------
%% gm_test(N) ->
%%     PlayerId = 4294967297,
%%     Lv = 30,
%%     HightCombatPower = 13460,
%%     BattleAttr = [{mp_lim,50},{anger_lim,100},{attr,[{att,133262},{metal_att,0},{wood_att,0},{water_att,0},{fire_att,0},{earth_att,0},{hp_lim,263644},{hp_ratio,56},{physique,134},{agile,134},{forza,174},{dexterous,98},{metal_resis,80},{wood_resis,0},{water_resis,80},{fire_resis,0},{earth_resis,80},{all_resis,76},{all_resis_del,31},{hit,64},{dodge,280},{dodge_del,0},{crit,0},{crit_hurt,188},{crit_del,0},{crit_hurt_del,0},{hp_resume,0},{hp_resume_add,0},{suck_blood,0},{att_speed,200},{speed,900},{hurt,0},{dizzy,0},{slow,0},{cripple,0},{paralysis,0},{hurt_resis,26},{dizzy_resis,0},{slow_resis,0},{cripple_resis,0},{paralysis_resis,0},{effect,0},{effect_resis,0},{hurt_time,0},{dizzy_time,0},{slow_time,0},{cripple_time,0},{paralysis_time,0},{hurt_time_del,0},{dizzy_time_del,0},{slow_time_del,0},{cripple_time_del,0},{paralysis_time_del,0},{effect_time,0},{effect_time_del,0},{rebound_srd,0},{rebound_rd,0},{att_ratio,13}]}],
%%     SkillList = [{100501,1},{100001,1},{100601,1},{100401,1},{100301,1},{100201,1},{100104,1},{100103,1},{100102,1},{100101,1},{10001,1}],
%%     EmBattleList = [{4,[{type,3},{id,4294967492},{partner_id,213},{lv,1},{battle_attr,[{mp_lim,50},{anger_lim,100},{attr,[{att,0},{metal_att,0},{wood_att,0},{water_att,0},{fire_att,0},{earth_att,0},{hp_lim,1000},{hp_ratio,0},{physique,53},{agile,43},{forza,56},{dexterous,135},{metal_resis,120},{wood_resis,0},{water_resis,120},{fire_resis,0},{earth_resis,0},{all_resis,0},{all_resis_del,0},{hit,0},{dodge,0},{dodge_del,0},{crit,0},{crit_hurt,180},{crit_del,0},{crit_hurt_del,0},{hp_resume,0},{hp_resume_add,0},{suck_blood,0},{att_speed,200},{speed,300},{hurt,0},{dizzy,0},{slow,0},{cripple,0},{paralysis,0},{hurt_resis,0},{dizzy_resis,0},{slow_resis,0},{cripple_resis,0},{paralysis_resis,0},{effect,0},{effect_resis,0},{hurt_time,0},{dizzy_time,0},{slow_time,0},{cripple_time,0},{paralysis_time,0},{hurt_time_del,0},{dizzy_time_del,0},{slow_time_del,0},{cripple_time_del,0},{paralysis_time_del,0},{effect_time,0},{effect_time_del,0},{rebound_srd,0},{rebound_rd,0},{att_ratio,0}]}]}]},{3,[{type,3},{id,4294967495},{partner_id,215},{lv,1},{battle_attr,[{mp_lim,50},{anger_lim,100},{attr,[{att,100},{metal_att,0},{wood_att,0},{water_att,0},{fire_att,0},{earth_att,0},{hp_lim,1000},{hp_ratio,0},{physique,87},{agile,29},{forza,100},{dexterous,73},{metal_resis,0},{wood_resis,0},{water_resis,0},{fire_resis,0},{earth_resis,120},{all_resis,0},{all_resis_del,0},{hit,0},{dodge,0},{dodge_del,0},{crit,0},{crit_hurt,180},{crit_del,0},{crit_hurt_del,0},{hp_resume,0},{hp_resume_add,0},{suck_blood,0},{att_speed,200},{speed,300},{hurt,0},{dizzy,0},{slow,0},{cripple,0},{paralysis,0},{hurt_resis,0},{dizzy_resis,0},{slow_resis,0},{cripple_resis,0},{paralysis_resis,0},{effect,0},{effect_resis,0},{hurt_time,0},{dizzy_time,0},{slow_time,0},{cripple_time,0},{paralysis_time,0},{hurt_time_del,0},{dizzy_time_del,0},{slow_time_del,0},{cripple_time_del,0},{paralysis_time_del,0},{effect_time,0},{effect_time_del,0},{rebound_srd,0},{rebound_rd,0},{att_ratio,0}]}]}]},{2,[{type,3},{id,4294967494},{partner_id,216},{lv,1},{battle_attr,[{mp_lim,50},{anger_lim,100},{attr,[{att,0},{metal_att,0},{wood_att,0},{water_att,0},{fire_att,0},{earth_att,0},{hp_lim,1000},{hp_ratio,0},{physique,54},{agile,31},{forza,113},{dexterous,108},{metal_resis,0},{wood_resis,0},{water_resis,0},{fire_resis,0},{earth_resis,0},{all_resis,0},{all_resis_del,0},{hit,0},{dodge,0},{dodge_del,0},{crit,0},{crit_hurt,180},{crit_del,0},{crit_hurt_del,0},{hp_resume,0},{hp_resume_add,0},{suck_blood,0},{att_speed,220},{speed,300},{hurt,0},{dizzy,0},{slow,0},{cripple,0},{paralysis,0},{hurt_resis,0},{dizzy_resis,0},{slow_resis,0},{cripple_resis,0},{paralysis_resis,0},{effect,0},{effect_resis,0},{hurt_time,0},{dizzy_time,0},{slow_time,0},{cripple_time,0},{paralysis_time,0},{hurt_time_del,0},{dizzy_time_del,0},{slow_time_del,0},{cripple_time_del,0},{paralysis_time_del,0},{effect_time,0},{effect_time_del,0},{rebound_srd,0},{rebound_rd,0},{att_ratio,0}]}]}]},{1,[{type,3},{id,4294967497},{partner_id,402},{lv,1},{battle_attr,[{mp_lim,50},{anger_lim,100},{attr,[{att,0},{metal_att,0},{wood_att,0},{water_att,0},{fire_att,0},{earth_att,0},{hp_lim,1500},{hp_ratio,0},{physique,134},{agile,125},{forza,242},{dexterous,92},{metal_resis,0},{wood_resis,0},{water_resis,0},{fire_resis,0},{earth_resis,0},{all_resis,0},{all_resis_del,0},{hit,0},{dodge,0},{dodge_del,0},{crit,0},{crit_hurt,180},{crit_del,0},{crit_hurt_del,0},{hp_resume,0},{hp_resume_add,0},{suck_blood,0},{att_speed,200},{speed,300},{hurt,0},{dizzy,0},{slow,0},{cripple,0},{paralysis,0},{hurt_resis,0},{dizzy_resis,0},{slow_resis,0},{cripple_resis,0},{paralysis_resis,0},{effect,0},{effect_resis,0},{hurt_time,0},{dizzy_time,0},{slow_time,0},{cripple_time,0},{paralysis_time,0},{hurt_time_del,0},{dizzy_time_del,0},{slow_time_del,0},{cripple_time_del,0},{paralysis_time_del,0},{effect_time,0},{effect_time_del,0},{rebound_srd,0},{rebound_rd,0},{att_ratio,0}]}]}]},{5,[{type,2},{id,4294967297},{partner_id,0},{lv,0},{battle_attr,[{mp_lim,50},{anger_lim,100},{attr,[{att,0},{metal_att,0},{wood_att,0},{water_att,0},{fire_att,0},{earth_att,0},{hp_lim,0},{hp_ratio,0},{physique,0},{agile,0},{forza,0},{dexterous,0},{metal_resis,0},{wood_resis,0},{water_resis,0},{fire_resis,0},{earth_resis,0},{all_resis,0},{all_resis_del,0},{hit,0},{dodge,0},{dodge_del,0},{crit,0},{crit_hurt,0},{crit_del,0},{crit_hurt_del,0},{hp_resume,0},{hp_resume_add,0},{suck_blood,0},{att_speed,0},{speed,0},{hurt,0},{dizzy,0},{slow,0},{cripple,0},{paralysis,0},{hurt_resis,0},{dizzy_resis,0},{slow_resis,0},{cripple_resis,0},{paralysis_resis,0},{effect,0},{effect_resis,0},{hurt_time,0},{dizzy_time,0},{slow_time,0},{cripple_time,0},{paralysis_time,0},{hurt_time_del,0},{dizzy_time_del,0},{slow_time_del,0},{cripple_time_del,0},{paralysis_time_del,0},{effect_time,0},{effect_time_del,0},{rebound_srd,0},{rebound_rd,0},{att_ratio,0}]}]}]}],
%%     do_gm_test({PlayerId, Lv, HightCombatPower, BattleAttr, SkillList, EmBattleList}, N).

%% do_gm_test(_Args, 0) -> skip;
%% do_gm_test(Args, LeftNum) ->
%%     {PlayerId, Lv, HightCombatPower, BattleAttr, SkillList, EmBattleList} = Args,
%%     % put(PlayerId + 1, Args),
%%     db_update_player_mirror(PlayerId+1, Lv, HightCombatPower+urand:rand(1,10), BattleAttr, SkillList, EmBattleList),
%%     do_gm_test({PlayerId+1, Lv, HightCombatPower, BattleAttr, SkillList, EmBattleList}, LeftNum - 1).

%% %% 测试将player_mirror复制到player_mirror_rank表（两张表字段不完全相同）
%% %% @note 指标：硬盘最长活动时间
%% %% 【未做优化前】：3000数据量 最长活动时间占比25%  
%% %%                 5000数据量 最长活动时间占比40%                     
%% %% 【分页优化后】：分页复制，一页复制500条数据量，复制一页后休眠200毫秒
%% %%                 3000数据量 最长活动时间占比2%  
%% %%                 5000数据量 最长活动时间占比5%  
%% %% @result 分页复制优化后，性能满足产品一机/一核多服运行环境
%% gm_copy() ->
%%     db_truncate_player_mirror_rank(),
%%     spawn(fun() -> gm_select(10000) end),
%%     spawn(fun() -> db_copy_player_mirror_batch(), io:format("copy finish:~p~n", [{do}]) end),
%%     ok.

%% gm_select(0) -> 
%%     io:format("select finish:~p~n", [{do}]),
%%     skip;
%% gm_select(N) ->
%%     db:get_one(io_lib:format(<<"select cell_num from player_attr where id = 4294967297">>, []) ),
%%     gm_select(N-1).



