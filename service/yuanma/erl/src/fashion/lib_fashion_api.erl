%% ---------------------------------------------------------------------------
%% @doc lib_fashion_api

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2020/7/8
%% @deprecated  时装接口函数
%% ---------------------------------------------------------------------------
-module(lib_fashion_api).

%% API
-compile([export_all]).

-include("common.hrl").
-include("fashion.hrl").
-include("goods.hrl").
-include("def_fun.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").

%% 取消正在穿戴的时装
cancel_illusion(Ps, PosId) ->
    illusion_default(Ps, PosId).
illusion_default(Ps, PosId) ->
    #player_status{id = RoleId} = Ps,
    GS = lib_goods_do:get_goods_status(),
    #goods_status{fashion = Fashion} = GS,
    #fashion{position_list = PositionList} = Fashion,
    case lists:keyfind(PosId, #fashion_pos.pos_id, PositionList) of
        false -> skip;
        FashionPos ->
            #fashion_pos{wear_fashion_id = WearFashionId} = FashionPos,
            case WearFashionId of
                0 ->  skip;
                _ ->
                    NewFashionPos = FashionPos#fashion_pos{
                        wear_fashion_id = 0,
                        wear_color_id = 0
                    },
                    lib_fashion:sql_fashion_base(NewFashionPos, RoleId),
                    NewPositionList = lists:keyreplace(PosId, #fashion_pos.pos_id, PositionList, NewFashionPos),
                    NewFashion = Fashion#fashion{position_list = NewPositionList},
                    NewGS = GS#goods_status{fashion = NewFashion},
                    lib_goods_do:set_goods_status(NewGS)
            end,
            Args = [?SUCCESS, PosId, WearFashionId],
            lib_server_send:send_to_sid(Ps#player_status.sid, pt_413, 41303, Args)
    end,
    {ok, Ps}.

%% 脱掉其它时装
take_off_other(PutType, PS) ->
    % 新穿戴的类型
    case PutType of
        % 时装（暂时可以和神兵兼容）
        fashion ->
            % 脱掉神殿、套装、天启
            TemPS = take_off_temple(PS),
            SuitCltPS = take_off_suit(TemPS),
            LastPS = take_off_revelation(SuitCltPS);
        % 神殿（暂时可以和神兵兼容）
        temple ->
            % 脱掉时装、套装、天启
            FashionPS = take_off_fashion(PS),
            SuitCltPS = take_off_suit(FashionPS),
            LastPS = take_off_revelation(SuitCltPS);
            % LastPS = take_off_holyorgan(RevelPS);
        % 套装（暂时可以和神兵兼容）
        suit_clt ->
            % 脱掉时装、神殿、天启
            FashionPS = take_off_fashion(PS),
            TemPS = take_off_temple(FashionPS),
            LastPS = take_off_revelation(TemPS);
            %% LastPS = take_off_holyorgan(RevelPS);
        % 天启（暂时可以和神兵兼容）
        revelation ->
            % 脱掉时装、神殿、套装
            FashionPS = take_off_fashion(PS),
            TemPS = take_off_temple(FashionPS),
            LastPS = take_off_suit(TemPS);
        % 神兵（暂时可以和套装、时装、神殿、天启兼容）
        holyorgan ->
            % 脱掉套装
            % TemPS = take_off_temple(PS),
            % LastPS = take_off_suit(PS)
            LastPS = PS
    end,
    {ok, LastPS}.

%% 脱掉普通时装
take_off_fashion(PS) ->
    F = fun(PosId, NewPS) ->
            {ok, LastPS} = lib_fashion_api:cancel_illusion(NewPS, PosId),
            LastPS
        end,
    RetPS = lists:foldl(F, PS, [1,3]),
    RetPS.

%% 脱掉神殿时装
take_off_temple(PS) ->
    F = fun(PosId, NewPS) ->
            {ok, LastPS} = lib_temple_awaken_api:cancel_chapter_fashion(NewPS, PosId),
            LastPS
        end,
    RetPS = lists:foldl(F, PS, [1,3]),
    RetPS.

%% 脱掉套装时装
take_off_suit(PS) ->
    {ok, RetPS} = lib_suit_collect_api:cancel_suit_fashion(PS),
    RetPS.

%% 脱掉天启套装
take_off_revelation(PS) ->
    #player_status{figure = #figure{revelation_suit = RltSuit}} = PS,
    if
        RltSuit =/= 0 -> 
            {true, RetPS} = lib_revelation_equip:change_figure_id(PS, 0);
        true -> 
            RetPS = PS
    end,
    RetPS.

%% 脱掉神兵
take_off_holyorgan(PS) ->
    case pp_mount:handle(16003, PS, [5,1,0,0]) of
        {ok, RetPS} -> RetPS;
        _ -> PS
    end.