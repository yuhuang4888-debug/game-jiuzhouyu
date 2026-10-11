%% ---------------------------------------------------------------------------
%% @doc pp_push_gift.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated 推送礼包
%% ---------------------------------------------------------------------------
-module(pp_push_gift).
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("errcode.hrl").
-include("push_gift.hrl").


%% 当前激活的礼包简略信息
handle(19101, PS, []) ->
	#player_status{push_gift_status = #push_gift_status{active_list = ActiveList}} = PS,
    lib_push_gift:send_gift_list(PS, ActiveList, 1);

%% 当前激活的礼包详细信息
handle(19102, PS, [GiftId, SubId]) ->
    lib_push_gift:send_gift_detail(PS, GiftId, SubId);

%% 购买礼包
handle(19103, PS, [GiftId, SubId, GradeId]) ->
    lib_push_gift:buy_gift(PS, GiftId, SubId, GradeId);

%% 发送离线过期礼包
handle(19104, PS, _Data) -> 
    #player_status{push_gift_status = PushGiftStatus} = PS, 
    lib_push_gift:send_gift_list(PS, PushGiftStatus#push_gift_status.expired_list, 3),
    NewPS = PS#player_status{push_gift_status = PushGiftStatus#push_gift_status{expired_list = []}},
    {ok, NewPS};

handle(_Cmd, _Player, _Data) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.