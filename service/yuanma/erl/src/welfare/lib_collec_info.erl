-module(lib_collec_info).
-include("goods.hrl").
-include("errcode.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("common.hrl").

-export([
        make_record/4,
        login/1,
        do_get_reward/4
    ]).

-record(real_info, {
        role_id = 0,
        phone = 0,
        name = "",
        person_id = 0
    }).

-define(SQL_SELECT,  <<"select phone, name, person_id from player_real_info where role_id = ~p ">>).
-define(SQL_REPLACE, <<"REPLACE INTO player_real_info (role_id, phone, name, person_id) values(~p, ~p, '~s', ~p)">>).

make_record(RoleId, Phone, Name, ID) ->
    #real_info{role_id = RoleId, phone = Phone, name = Name, person_id = ID}.

login(RoleId) ->
    List = db:get_row(io_lib:format(?SQL_SELECT, [RoleId])),
    case List of
        [Phone, Namestr, ID] -> Name = util:bitstring_to_term(Namestr);
        _ -> Phone = 0, ID = 0, Name = ""
    end,
    make_record(RoleId, Phone, Name, ID).

do_get_reward(Player, Name, Number, Type) ->
    #player_status{id = RoleId, player_real_info = RealInfo, figure = #figure{lv = RoleLv}} = Player,
    OpenDay = util:get_open_day(),
    OpenDayCfg = get_cfg(3),
    OpenLv = get_cfg(4),
    case RoleLv >= OpenLv andalso OpenDay >= OpenDayCfg of
        true ->
            #real_info{phone = OPhone, name = OName, person_id = OID} = RealInfo,
            if
                Type == 1 andalso OPhone == 0 ->
                    Code = ?SUCCESS,
                    NewRealInfo = RealInfo#real_info{phone = Number, name = OName, person_id = OID},
                    {NewPlayer, Reward} = do_send_reward(Player#player_status{player_real_info = NewRealInfo}, Type);
                Type == 0 andalso OID == 0 ->
                    Code = ?SUCCESS,
                    NewRealInfo = RealInfo#real_info{phone = OPhone, name = Name, person_id = Number},
                    {NewPlayer, Reward} = do_send_reward(Player#player_status{player_real_info = NewRealInfo}, Type);
                true ->
                    Code = ?ERRCODE(err417_has_received),
                    NewPlayer = Player, Reward = []
            end;
        _ ->
            Code = ?ERRCODE(err417_limit_to_get),
            NewPlayer = Player, Reward = []
    end,
    {ok, BinData} = pt_417:write(41718, [Type, Code, Reward]),
    lib_server_send:send_to_uid(RoleId, BinData),
    {ok, NewPlayer}.

do_send_reward(Player, Type) ->
    case data_real_info:get_reward_by_type(Type) of
        Reward when is_list(Reward) -> 
            #player_status{id = RoleId, player_real_info = RealInfo, figure = #figure{name = RoleName}} = Player,
            #real_info{phone = Phone, name = Name, person_id = ID} = RealInfo,
            db:execute(io_lib:format(?SQL_REPLACE, [RoleId, Phone, util:term_to_string(Name), ID])),
            Produce = #produce{type = real_info, subtype = Type, reward = Reward, show_tips = ?SHOW_TIPS_0},
            lib_log_api:log_real_info(RoleId, RoleName, Type, Phone, Name, ID, Reward),
            {lib_goods_api:send_reward(Player, Produce), Reward};
        _ -> 
            {Player, []}
    end.
    
get_cfg(Type) ->
    case data_real_info:get_reward_by_type(Type) of
        Value when is_integer(Value) -> Value;
        _ -> 0
    end.