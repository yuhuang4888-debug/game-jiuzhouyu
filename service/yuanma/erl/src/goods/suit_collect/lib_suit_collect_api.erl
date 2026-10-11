%%%---------------------------------------
%%% @Module         : suit_collect_event
%%% @Author          : kuangyaode
%%% @Created         : 2020.08.05
%%% @Description   :  套装收集接口
%%%---------------------------------------

-module(lib_suit_collect_api).

-include("equip_suit.hrl").
-include("server.hrl").
-include("figure.hrl").
-include("errcode.hrl").
-include("task.hrl").
-include("def_goods.hrl").
-include("goods.hrl").

-export([cancel_suit_fashion/1, get_all_suit_clt/1, trigger_task/1, is_suit_clt_task/1, reload_suit_clt_info/1]).

%% 把玩家套装收集的时装形象去除/脱掉
cancel_suit_fashion(PS) ->
    #player_status{figure = #figure{suit_clt_figure = SuitId}} = PS,
    case SuitId of
        0 -> NewPS = PS;
        _ -> 
            {ok, NewPS} = lib_suit_collect:wear_model(PS, SuitId, ?UNWEAR),
            Args = [?SUCCESS, 0, 0],
            lib_server_send:send_to_sid(NewPS#player_status.sid, pt_152, 15259, Args)
    end,
    {ok, NewPS}.

%% 获取套装收集情况
get_all_suit_clt(PS) ->
    #player_status{suit_collect = #suit_collect{clt_list = CltList}} = PS,
    F = fun(SuitCltItem, List) ->
                #suit_clt_item{suit_id = SuitId, cur_stage = CurStage} = SuitCltItem,
                [{SuitId, CurStage}|List]
            end,
    AllSuitClt = lists:foldl(F, [], CltList),
    AllSuitClt.

%% 重加载玩家的套装信息
reload_suit_clt_info(PS) ->
    ReloadPS = lib_suit_collect:login(PS),                          % 调用登录处理来重新加载数据库内容
    GS = lib_goods_do:get_goods_status(),
    #goods_status{dict = GoodsDict} = GS,
    EquipList = lib_goods_util:get_goods_list(ReloadPS#player_status.id, ?GOODS_LOC_EQUIP, GoodsDict),
    NewPS = lib_suit_collect:auto_activate(ReloadPS, EquipList, ?SEND),    % 通过自动点亮发送新的点亮信息给玩家
    NewPS.

trigger_task(PS) ->
    lib_task_api:suit_ctl(PS, get_all_suit_clt(PS)),
    PS.

is_suit_clt_task(Task) ->
    Fun = fun
        ({Stage, Cid}, Flag) ->
            case data_task:get_content(Task#task.id, Stage, Cid) of
                #task_content{ctype = ?TASK_CONTENT_SUIT_CLT} -> true;
                _ -> Flag
            end;
        (_, Flag) -> Flag
    end,
    lists:foldl(Fun, false, Task#task.content).