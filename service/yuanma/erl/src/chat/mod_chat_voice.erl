%%%------------------------------------
%%% @Module  : mod_chat_voice
%%% @Author  : ming_up@foxmail.com
%%% @Created : 2014.2.25
%%% @Description: 语音/图片聊天存储
%%%------------------------------------
-module(mod_chat_voice).
-behaviour(gen_server).
-compile(export_all).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {voice_dict = dict:new(), picture_dict = dict:new()}).

-include("errcode.hrl").

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 发送语音和语音文字的聊天
send_voice(PlayerId, ClientAutoId, DataSend, VoiceText) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {'voice_data', PlayerId, ClientAutoId, DataSend, VoiceText}).

%% 获取语音内容
get_voice_data(PlayerId, ClientAutoId, Sid) -> 
     gen_server:cast(misc:get_global_pid(?MODULE), {'get_voice_data', PlayerId, ClientAutoId, Sid}).

%% 清空玩家语音信息
clear_voice_data(RoleId) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {'clear_voice_data', RoleId}).

%% 发送图片
send_picture(AutoId, DataSend) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {'picture_data', AutoId, DataSend}).

%% 获取图片内容
get_picture_data(AutoId, Sid) -> 
     gen_server:cast(misc:get_global_pid(?MODULE), {'get_picture_data', AutoId, Sid}).

%% 清空玩家图片信息
clear_picture_data(RoleId) -> 
    gen_server:cast(misc:get_global_pid(?MODULE), {'clear_picture_data', RoleId}).

 %% 发送语音文字聊天
send_voice_text(PlayerId, ClientAutoId, Sid, DataTextSend) ->
    gen_server:cast(misc:get_global_pid(?MODULE), {'voice_text_data', PlayerId, ClientAutoId, Sid, DataTextSend}).

%% 获取语音文字内容
get_voice_text_data(PlayerId, ClientAutoId, Sid) -> 
     gen_server:cast(misc:get_global_pid(?MODULE), {'get_voice_text_data', PlayerId, ClientAutoId, Sid}).

init([]) ->
    process_flag(trap_exit, true),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 语音聊天(采用dict存储每个玩家的语音信息，语音信息放在list中，采用先进先出原理，
%% list效率比较低，不能让list太长，目前是定义的是100长度)
handle_cast({'voice_data', PlayerId, ClientAutoId, DataSend, VoiceText}, #state{voice_dict=VoiceDict} = State) -> 
    case dict:find(PlayerId, VoiceDict) of
        error -> 
            VoiceList = {1, [{ClientAutoId, DataSend, VoiceText}]},
            NewVoiceDict = dict:store(PlayerId, VoiceList, VoiceDict);
        {ok, {OldLen, OldVoiceList}} -> 
            %%VoiceListLen = length(OldVoiceList),
            case OldLen >= 99 of
                true -> 
                    [_Tail|H] = lists:reverse(OldVoiceList),
                    NewVoiceList = [{ClientAutoId, DataSend, VoiceText} | lists:reverse(H)],
                    NewVoiceDict = dict:store(PlayerId, {OldLen, NewVoiceList}, VoiceDict);
                false -> 
                    NewVoiceList = [{ClientAutoId, DataSend, VoiceText} | OldVoiceList],
                    NewVoiceDict = dict:store(PlayerId, {OldLen+1, NewVoiceList}, VoiceDict)
            end
    end,
    {noreply, State#state{voice_dict=NewVoiceDict}};

%% 获取语音内容
handle_cast({'get_voice_data', PlayerId, ClientAutoId, Sid}, #state{voice_dict=VoiceDict} = State) -> 
    case dict:find(PlayerId, VoiceDict) of
        error -> ErrorCode = ?ERRCODE(err110_voice_lose_efficacy), VoiceBinData = <<>>;
        {ok, {_, OldVoiceList}} -> 
            case lists:keyfind(ClientAutoId, 1, OldVoiceList) of
                false -> ErrorCode = ?ERRCODE(err110_voice_lose_efficacy), VoiceBinData = <<>>;
                {_, VoiceBinData, _} -> ErrorCode = ?SUCCESS
            end
    end,
    {ok, BinData} = pt_110:write(11004, [ErrorCode, ClientAutoId, VoiceBinData]),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State};

%% 清空某玩家的语音
handle_cast({'clear_voice_data', PlayerId}, #state{voice_dict=VoiceDict} = State) -> 
    NewVoiceDict = dict:erase(PlayerId, VoiceDict),
    {noreply, State#state{voice_dict=NewVoiceDict}};

%% 存放图片数据
%% 规则 AutoId = 玩家id*100 + NewAutoId, 最多100张
handle_cast({'picture_data', AutoId, DataSend}, #state{picture_dict=PictureDict} = State) -> 
    NewPictureDict = dict:store(AutoId, DataSend, PictureDict),
    {noreply, State#state{picture_dict=NewPictureDict}};

%% 获取图片内容
handle_cast({'get_picture_data', AutoId, Sid}, #state{picture_dict=PictureDict} = State) -> 
    case dict:find(AutoId, PictureDict) of
        error -> skip;
        {ok, PictrueBinData} -> 
            {ok, BinData} = pt_110:write(11083, [AutoId, PictrueBinData]),
            lib_server_send:send_to_sid(Sid, BinData)
    end,
    {noreply, State};

%% 清空玩家图片信息
handle_cast({'clear_picture_data', RoleId}, #state{picture_dict=PictureDict} = State) -> 
    F = fun(Num, Dict) -> dict:erase(RoleId*100 + Num, Dict) end,
    List = lists:seq(1, 100),
    NewPictureDict = lists:foldl(F, PictureDict, List),
    {noreply, State#state{picture_dict=NewPictureDict}};

%% 存储语音文字信息
handle_cast({'voice_text_data', PlayerId, ClientAutoId, Sid, VoiceText}, #state{voice_dict=VoiceDict} = State) -> 
    case dict:find(PlayerId, VoiceDict) of
        error -> 
            NewVoiceDict = VoiceDict,
            Res = 2; % 没有找到该玩家的语音文字信息
        {ok, {OldLen, OldVoiceList}} -> 
            case lists:keyfind(ClientAutoId, 1, OldVoiceList) of
                false -> 
                    NewVoiceDict = VoiceDict,
                    Res = 2; % 没有找到该玩家的语音文字信息
                {_, VoiceBinData, _} -> 
                    NewVoiceList = lists:keyreplace(ClientAutoId, 1, OldVoiceList, {ClientAutoId, VoiceBinData, VoiceText}),
                    NewVoiceDict = dict:store(PlayerId, {OldLen, NewVoiceList}, VoiceDict),
                    Res = 1 % 成功写入该玩家的语音文字信息
            end
    end,
    {ok, BinData} = pt_110:write(11005, Res),
    lib_server_send:send_to_sid(Sid, BinData),
    {noreply, State#state{voice_dict=NewVoiceDict}};

%% 获取语音文字内容
handle_cast({'get_voice_text_data', PlayerId, ClientAutoId, Sid}, #state{voice_dict=VoiceDict} = State) -> 
    case dict:find(PlayerId, VoiceDict) of
        error -> skip;
        {ok, {_, OldVoiceList}} -> 
            case lists:keyfind(ClientAutoId, 1, OldVoiceList) of
                false -> skip;
                {_, _VoiceBinData, VoiceTextData} -> 
                    Res = case VoiceTextData of
                        [] -> 0; % 没有文字信息
                        _  -> 1  % 有文字信息
                    end,
                    {ok, BinData} = pt_110:write(11006, [Res, ClientAutoId, VoiceTextData]),
                    lib_server_send:send_to_sid(Sid, BinData)
            end
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
