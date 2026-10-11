%%%-----------------------------------
%%% @Module  : pt_100
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.04.29
%%% @Description: 注册登录系统
%%%-----------------------------------
-module(pt_100).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%%登陆
read(10000, <<AccId:32, Tstamp:32, Bin/binary>>) ->
    {AccName, Bin1} = pt:read_string(Bin),
    {Ticket, _} = pt:read_string(Bin1),
    {ok, [AccId, AccName, Tstamp, Ticket]};

%%退出
read(10001, _) ->
    {ok, logout};

%%创建角色
read(10003, <<Realm:8, Career:8, Sex:8, Bin/binary>>) ->
    {Name, Bin1} = pt:read_string(Bin),
    {Source, <<InviteeId:64, Bin2/binary>>} = pt:read_string(Bin1),
    {AccNameSdk, Bin3} = pt:read_string(Bin2),
    {TaGuestId, Bin4} = pt:read_string_binary(Bin3),
    <<SimulatorFlag:8, Bin5/binary>> = Bin4,
    {TaDeviceId, Bin6} = pt:read_string_binary(Bin5),
    <<IschangeCareer:8, IsChangeName:8, _RestBin/binary>> = Bin6,
    {ok, [Realm, Career, Sex, Name, Source, InviteeId, AccNameSdk, TaGuestId, SimulatorFlag, TaDeviceId, IschangeCareer, IsChangeName]};

%%选择角色进入游戏
read(10004, <<Id:64, Bin/binary>>) ->
    {ServerName, <<Time:32, Bin1/binary>>} = pt:read_string(Bin),
    {Ticket, <<RegSId:32, Bin2/binary>>} = pt:read_string(Bin1),
    {CSource, Bin3} = pt:read_string(Bin2),
    {AccNameSdk, <<IsWhite: 8, Bin4/binary>>} = pt:read_string(Bin3),
    {TaGuestId, Bin5} = pt:read_string_binary(Bin4),
    <<SimulatorFlag:8, Bin6/binary>> = Bin5,
    {TaDeviceId, <<WxScene:16, _RestBin/binary>>} = pt:read_string_binary(Bin6),
    {ok, [Id, ServerName, Time, Ticket, RegSId, CSource, AccNameSdk, IsWhite, TaGuestId, SimulatorFlag, TaDeviceId, WxScene]};

%%删除角色
read(10005, <<Id:64>>) ->
    {ok, Id};

%%心跳包
read(10006, _) ->
    {ok, heartbeat};

%%随机姓名验证
read(10007, <<Bin/binary>>) ->
    {Name, _} = pt:read_string(Bin),
    {ok, [Name]};

%%账号封测信息
read(10008, <<Bin/binary>>) ->
    {Source, _} = pt:read_string(Bin),
    {ok, [Source]};

read(_Cmd, _R) ->
    io:format("pt_100 no_match ~p~n", [{_Cmd, _R}]),
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%登陆返回
write(10000, [Career, Time, OpenTime, RegPlayerNum, L]) ->
    N = length(L),
    F = fun([Id, Status, Figure, TodayLoginRewardId]) ->
            FigureBin = pt:write_figure(Figure),
            <<Id:64, Status:8, FigureBin/binary, TodayLoginRewardId:8>>
    end,
    LB = list_to_binary([F(X) || X <- L]),
    {ok, pt:pack(10000, <<Career:8, Time:64, OpenTime:32, N:16, RegPlayerNum:32, LB/binary>>)};

%%登陆退出
write(10001, _) ->
    Data = <<>>,
    {ok, pt:pack(10001, Data)};

%%创建角色
write(10003, [Code, Id]) ->
    Data = <<Code:8, Id:64>>,
    {ok,  pt:pack(10003, Data)};

%%选择角色进入游戏
write(10004, Code) ->
    Data = <<Code:8>>,
    {ok, pt:pack(10004, Data)};

%%删除角色
write(10005, Code) ->
    Data = <<Code:16>>,
    {ok, pt:pack(10005, Data)};

%%心跳包
write(10006, _) ->
    {ok, pt:pack(10006, <<>>)};

%%随机名验证
write(10007, [Code]) ->
    Data = <<Code:8>>,
    {ok, pt:pack(10007, Data)};

%%账号封测信息
write(10008, [HadReturn, RechargeGold, ReturnGold]) ->
    Data = <<HadReturn:8, RechargeGold:32, ReturnGold:32>>,
    {ok, pt:pack(10008, Data)};

write(_Cmd, _R) ->
    ?DEBUG("error cmd ~w R:~p~n", [_Cmd, _R]),
    {ok, pt:pack(0, <<>>)}.
