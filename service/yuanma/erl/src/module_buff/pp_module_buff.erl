%%%--------------------------------------
%%% @Module  : pp_module_buff
%%% @Author  : lxl
%%% @Created : 2019.6.22
%%% @Description:  
%%%--------------------------------------

-module(pp_module_buff).

-export([handle/3]).

-include("server.hrl").
-include("def_module_buff.hrl").

%% 模块加成buff列表
handle(18401, PS, []) ->
    #player_status{sid = Sid, mod_buff = ModBuffList} = PS,
    SendList = [{Key, util:term_to_string(Data)} ||#module_buff{key = Key, data = Data} <- ModBuffList],
    lib_server_send:send_to_sid(Sid, pt_184, 18401, [SendList]);

handle(_Code, _Ps, _) ->
    {error, atom_to_list(?MODULE) ++ " no match"}.