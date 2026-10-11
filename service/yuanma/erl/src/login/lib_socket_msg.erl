%%% @author root <root@localhost.localdomain>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 16 Nov 2017 by root <root@localhost.localdomain>
-module(lib_socket_msg).
-export([send_msg/1, net_close/1, print_flow/1]).

%% 流量显示
-define(PRINT_FLOW, false). %% true|false
-define(DO_PRINT_FLOW(Bin), case ?PRINT_FLOW orelse get(switch) == 1 of true -> print_flow(Bin); false -> void end).
%% 秘籍查看流量,发到私聊 1:重置流量计算;2:获得流量值;其他:关闭流量计算
-define(PRINT_FLOW_SWITCH(Switch), case Switch of 1 -> put(switch, 1), erase(send_bin_len), erase(send_bin_cmd); 2 -> true; _ -> put(switch, 0) end).

%% 次模块不做热更,不要加任何代码
%% 发消息
send_msg(Socket)->
    receive
        {send, close} ->
            if
                Socket == none -> ok;
                true -> net_close(Socket), ok
            end;
        {send, Bin} when is_binary(Bin) ->
            case gen_tcp:send(Socket, Bin) of
                {error, _} -> net_close(Socket);
                _ -> send_msg(Socket)
            end;
        {print_flow_switch, Switch, Pid} -> %% 计算流量的秘籍
            ?PRINT_FLOW_SWITCH(Switch),
            Pid ! {'print_flow_switch', Switch, get(send_bin_len), get(send_bin_cmd)},
            send_msg(Socket);
        _ ->
            send_msg(Socket)
    end.

net_close(Socket) ->
    Bin = gsrv_ws:pack(close),
    gen_tcp:send(Socket, Bin),
    gen_tcp:close(Socket).

print_flow(Bin) ->
    KeyLen = send_bin_len,
    KeyCmd = send_bin_cmd,
    <<Len:32, Cmd:16, _/binary>> = Bin,
    case get(KeyLen) of
        undefined -> put(KeyLen, Len);
        BinLen ->
            NewLen = Len+BinLen,
            io:format("mod_login:print_flow NowCmd:~p, NowBinLen:~pbyte, TotalFlow:~pk~n", [Cmd, Len, NewLen div 1024]),
            put(KeyLen, NewLen)
    end,
    case get(KeyCmd) of
        undefined ->
            D = dict:new(),
            D2 = dict:store(Cmd, {Cmd, 1, Len}, D),
            put(KeyCmd, D2);
        D ->
            case dict:find(Cmd, D) of
                error -> NewCmdNum = 1, NewCmdBinLen = Len;
                {ok, {_Cmd, CmdNum, CmdBinLen}} -> NewCmdNum = CmdNum + 1, NewCmdBinLen = CmdBinLen + Len
            end,
            D2 = dict:store(Cmd, {Cmd, NewCmdNum, NewCmdBinLen}, D),
            put(KeyCmd, D2)
    end.

%% 次模块不做热更,不要做任何修改
