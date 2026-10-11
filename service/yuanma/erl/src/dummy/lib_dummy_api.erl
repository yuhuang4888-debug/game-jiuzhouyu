%%-----------------------------------------------------------------------------
%% @Module  :       lib_dummy_api.erl
%% @Author  :       J
%% @Email   :       j-som@foxmail.com
%% @Created :       2018-01-12
%% @Description:    假人接口
%%-----------------------------------------------------------------------------

-module (lib_dummy_api).
-include ("figure.hrl").
-include ("server.hrl").
-include ("attr.hrl").

-export ([change_figure/2, get_skill_list/1, change_battle_attr/2]).

change_figure(Figure, [rand_wing|T]) ->
    Wing = urand:list_rand(data_wing:get_all_figure_ids()),
    change_figure(Figure#figure{wing_figure = Wing}, T);

change_figure(Figure, [rand_name|T]) ->
    change_figure(Figure#figure{name = ""}, T); %% 客户端有名字库，传空字符串给客户端，让客户端去随机

change_figure(Figure, [rand_fashion|T]) ->
    #figure{career = Career, sex = Sex} = Figure,
    FashionList = lib_fashion:get_rand_fashion_model_list(Career, Sex),
    change_figure(Figure#figure{fashion_model = FashionList}, T);

change_figure(Figure, [create_name|T]) ->   %% 有些名字要跨好几个系统使用，所以服务端生成一个固定的
    #figure{sex = Sex} = Figure,
    FirstName = urand:list_rand(data_role_name:first_name_list(Sex)),
    LastName = urand:list_rand(data_role_name:last_name_list(Sex)),
    Name = util:make_sure_binary(FirstName ++ LastName),
    change_figure(Figure#figure{name = Name}, T);

change_figure(Figure, [_|T]) ->
    change_figure(Figure, T);

change_figure(Figure, []) -> %% 最后清掉一些社交信息
    Figure#figure{
        picture = "",
        picture_ver = 0,
        guild_id = 0,
        guild_name = <<>>,
        position = 0,
        position_name = "",
        marriage_type = 0,
        lover_role_id = 0,
        lover_name = ""
    }.

change_battle_attr(BattleAttr, [{hp_r, R}|T]) ->
    Hp = trunc(BattleAttr#battle_attr.hp_lim * R),
    change_battle_attr(BattleAttr#battle_attr{hp = Hp, hp_lim = Hp}, T);

change_battle_attr(BattleAttr, [{att_r, R}|T]) ->
    Attr = BattleAttr#battle_attr.attr,
    Att = trunc(Attr#attr.att * R),
    change_battle_attr(BattleAttr#battle_attr{attr = Attr#attr{att = Att}}, T);

change_battle_attr(BattleAttr, [{attr_r, R}|T]) ->
    Hp = trunc(BattleAttr#battle_attr.hp_lim * R),
    Attr = BattleAttr#battle_attr.attr,
    NewAttr = lib_player_attr:to_attr_record([{K,trunc(V*R)}||{K, V}<-lib_player_attr:to_kv_list(Attr)]),
    change_battle_attr(BattleAttr#battle_attr{hp = Hp, hp_lim = Hp, attr = NewAttr}, T);

change_battle_attr(BattleAttr, [_|T]) ->
    change_battle_attr(BattleAttr, T);

change_battle_attr(BattleAttr, []) ->
    BattleAttr.

get_skill_list(Player) when is_record(Player, player_status) ->
    #player_status{quickbar = QuickBar} = Player,
    [{SkillId, 1} || {_, 2, SkillId, _} <- QuickBar];

get_skill_list(QuickBar) when is_list(QuickBar) ->
    [{SkillId, 1} || {_, 2, SkillId, _} <- QuickBar].

