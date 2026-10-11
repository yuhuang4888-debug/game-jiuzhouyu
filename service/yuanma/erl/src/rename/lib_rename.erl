%%%--------------------------------------
%%% @Module  : lib_rename
%%% @Author  : zengzy
%%% @Created : 2017-06-03
%%% @Description:  角色名相关函数
%%%--------------------------------------
-module(lib_rename).
-compile(export_all).
-export([

    ]).
-include("server.hrl").
-include("figure.hrl").
-include("relationship.hrl").
-include("rename.hrl").
-include("errcode.hrl").
-include("predefine.hrl").
-include("common.hrl").
-include("def_goods.hrl").
-include("scene.hrl").
-include("def_module.hrl").
-include("def_daily.hrl").
-include("attr.hrl").
-include("def_event.hrl").
-include("rec_event.hrl").
-include("language.hrl").

get_old_name(RoleId) ->
    case get({?MODULE, player_old_name}) of
    	undefined ->
    		NameList = init_old_name(RoleId),
    		set_old_name(NameList),
    		NameList;
    	NameList ->
    		NameList
    end.

set_old_name(NameList) ->
    put({?MODULE, player_old_name}, NameList),
    ok.

%%登录获取曾用名
% login(PS)->
% 	#player_status{id = RoleId} = PS,

init_old_name(_RoleId) ->
	% Sql = io_lib:format(?SQL_SELECT_PLAYER_RENAME, [RoleId]),
	% case db:get_all(Sql) of
	% 	[]->
	% 		[];
	% 	ReNameList ->
	% 		F = fun([Name,Time],Rlist)->
	% 			[{Name,Time}|Rlist]
	% 		end,
	% 		Rlists = lists:foldr(F,[],ReNameList),
	% 		Rlists
	% 		% set_old_name(Rlists)
	% end.
	[].

%%离线登录
offline_login(_Id) ->
	% Sql = io_lib:format(?SQL_SELECT_PLAYER_RENAME, [Id]),
	% case db:get_all(Sql) of
	% 	[]->
	% 		[];
	% 	ReNameList ->
	% 		F = fun([Name,Time],Rlist)->
	% 			[{Name,Time}|Rlist]
	% 		end,
	% 		lists:foldr(F,[],ReNameList)
	% end.
	[].

judge_goods(#player_status{c_rename = 0}, _) ->
	[];

%%获取消耗物品
judge_goods(PS,Type) ->
	#player_status{gold=Gold} = PS,
	case Type of
		% ?FREE->
		% 	if
		% 		CReName =:= 1 ->
		% 			[];
		% 		true ->
		% 			{false,?ERRCODE(not_have_free_card)}
		% 	end;
		?GOLD_TYPE->
			GoldSum = data_rename:get_cfg(?GOLD_NUM_TYPE),
			if
				% BGold >= GoldSum ->
				% 	[{?TYPE_BGOLD,0,GoldSum}];
				% BGold+Gold >= GoldSum andalso BGold > 0 ->
				% 	[{?TYPE_BGOLD,0,BGold},{?TYPE_GOLD,0,GoldSum-BGold}];
				Gold >= GoldSum ->
					[{?TYPE_GOLD,0,GoldSum}];
				true->
					{false,?ERRCODE(gold_not_enough)}
			end;
		?CHANGE_CARD_TYPE->
			Good_id = data_rename:get_cfg(?CARD_TYPE),
			[{_,Num}] = lib_goods_api:get_goods_num(PS,[Good_id]),
			case Num >0 of
				true->
					[{?TYPE_GOODS,Good_id,1}];
				false->
					{false,?ERRCODE(not_have_free_card)}
			end;
		_ ->
			{false, ?FAIL}
	end.

%%修改角色名
change_name(RoleId,Name, _Figure) ->
	% OldName = Figure#figure.name,
	Now = utime:unixtime(),
	NewNameSql  = io_lib:format(?SQL_UPDATE_PLAYER_LOW_NAME, [Name, Now, RoleId]),
	% OldNameSql = io_lib:format(?SQL_INSERT_PLAYER_RENAME, [RoleId,OldName,Now]),
 	F = fun() ->
        db:execute(NewNameSql),
        case lib_login:judge_name_in_db(RoleId) of
            false -> ?INFO("role_name_can_not_save_in_db:~p~n",[Name]), skip;
            _ -> skip
        end,
        % db:execute(OldNameSql),
        true
    end,
    db_execute(F).

%%增加曾用名
add_old_name(PS, _Name)->
	#player_status{id=RoleId, figure=Figure} = PS,
	OldName = Figure#figure.name,
	Now = utime:unixtime(),
	ReNameList = get_old_name(RoleId),
	NewNameList = [{OldName,Now}|ReNameList],
	SortList = lists:keysort(2,NewNameList),
	set_old_name(sort_reverse(SortList,?MAX_NAME)).

%%改名消耗物品
use_good(PS,GList) ->
	?PRINT("~p~n",[GList]),
	case GList =:= [] of
		true->
			PS;
		false->
			case lib_goods_api:cost_object_list_with_check(PS, GList, change_name, "change_name") of
				{true, NewPs} ->
					NewPs;
				{false, _, _} ->
					PS
			end
			% F = fun({Type,Gid,Num},TempPS)->
			% 	%%判断类型
			% 	case Type of
			% 		?TYPE_GOODS->
			% 			lib_goods_api:cost_object_list(PS, [{?TYPE_GOODS, Gid, 1}], change_name, "change_name"),
			% 			TempPS;
			% 		?TYPE_GOLD->
			% 			case lib_goods_api:cost_object_list(PS, [{?TYPE_GOLD, 0, Num}], change_name, "change_name") of
			% 				{true, NewPs} ->
			% 					NewPs;
			% 				{false,_,_}->
			% 					TempPS
			% 			end;
			% 		?TYPE_BGOLD->
			% 			case lib_goods_api:cost_object_list(PS, [{?TYPE_BGOLD, 0, Num}], change_name, "change_name") of
			% 				{true, NewPs} ->
			% 					NewPs;
			% 				{false,_,_}->
			% 					TempPS
			% 			end;
			% 		_->
			% 			TempPS
			% 	end
			% end,
			% lists:foldl(F,PS,GList)
	end.

%%修改ps状态
change_ps(PS,Name) ->
 	OldFigure = PS#player_status.figure,
	NewPS = PS#player_status{figure=OldFigure#figure{name=Name}, c_rename = 1, c_rename_time = utime:unixtime()},
	NewPS.

%%发送邮件
send_email(RList,Tid,Cid,Name,OldName)->
	Title = ?LAN_MSG(Tid),
	Content = uio:format(?LAN_MSG(Cid), [OldName, Name]),
	F = fun(#rela{other_rid=To_id},Rids)->
		[To_id|Rids]
	end,
	RIdLists = lists:foldl(F,[],RList),
	lib_mail_api:send_sys_mail(RIdLists, Title, Content, []).

%%db操作
db_execute(F)->
    case db:transaction(F) of
        true  ->
        	1;
        Error ->?PRINT("error~p~n",[Error]),
            ?ERR("~p ~p Error:~p~n", [?MODULE, ?LINE, Error]),
            0
    end.

%%倒排序
sort_reverse(List, N) ->
	sort_reverse(List, N, []).

sort_reverse([], _, List)->
	List;
sort_reverse(L, N, List) ->
	case length(List) < N of
		true->
			sort_reverse(lists:droplast(L), N, List++[lists:last(L)]);
		false->
			List
	end.

gm_change_role_name(PlayerStatus, Name) when is_record(PlayerStatus, player_status) ->
	#player_status{id=RoleId, sid = Sid, figure=Figure, scene = SceneId, scene_pool_id=PoolId,copy_id = CopyId,x = X,y = Y} = PlayerStatus,
    case pp_rename:validate_name(Name) of  %% 角色名合法性检测
        {false, Msg} ->
            {{error, Msg}, PlayerStatus};
        true ->	
            case lib_rename:change_name(RoleId, Name, Figure) of
                1  ->?PRINT("is ok~n",[]),
                    NameBin = util:make_sure_binary(Name),

                    OldName = Figure#figure.name,
                    NewPS = lib_rename:change_ps(PlayerStatus,NameBin),
                    %%通知场景
                    mod_scene_agent:update(SceneId,PoolId,RoleId,[{name,NameBin}]),
                    %%给场景九宫格发送
                    {ok, BinData} = pt_120:write(12086, [RoleId,NameBin]),
                    lib_server_send:send_to_area_scene(SceneId, PoolId, CopyId, X, Y, BinData),
                    %%派发事件
                    lib_player_event:dispatch(NewPS, ?EVENT_RENAME, NameBin),
                    %%通知好友
                    Friends = lib_relationship:get_relas_by_types(RoleId,?RELA_TYPE_FRIEND),
                    lib_rename:send_email(Friends, ?LAN_TITLE_RENAME, ?LAN_CONTENT_FRIEND_RENAME, ulists:list_to_bin(Name), ulists:list_to_bin(OldName)),
                    %%通知仇人
                    % Enemy =  lib_relationship:get_relas_by_types(RoleId,?RELA_TYPE_ENEMY),
                    % lib_rename:send_email(Enemy, ?LAN_TITLE_RENAME, ?LAN_CONTENT_ENEMY_RENAME, ulists:list_to_bin(Name), ulists:list_to_bin(OldName)),
                    %lib_chat:send_TV({all}, ?MOD_PLAYER, 1, [Figure#figure.name, NameBin, RoleId]),
                    {ok, BinData1} = pt_426:write(42601, [1, Name]),
                    lib_server_send:send_to_sid(Sid, BinData1),
                    %%加日志
                    lib_log_api:log_rename(RoleId,Figure#figure.name,NameBin,Figure#figure.lv,[]),
                    {ok, NewPS};
                _Err ->
                    {{error, _Err}, PlayerStatus}
            end
    end;
gm_change_role_name(_E, _) ->skip.

%% 合服的名字冲突发送改名卡道具
%% ==============================
%% 原来的c_rename为0（表示可以免费改名），冲突了则修改为3（服务端根据这个数据重置为0）
%% 原来的c_rename为1（表示不免费改名），冲突了则修改为4（服务端根据这个数据重置为1）
%% ==============================
conflict_send_rename_card(Ps) ->
	#player_status{id = RoleId, c_rename = CName} = Ps,
	if
		CName == 3 -> %% 合服前没有改过名字，发送改名卡，玩家有两次改名的机会（免费改名 + 改名卡）
			NewCName = 0,
			NeedSend = true;
		CName == 4 -> %% 合服前改过名字，发送改名卡，玩家只有一次改名的机会（改名卡）
			NewCName = 1,
			NeedSend = true;
		true -> %% 正常情况
			NewCName = CName,
			NeedSend = false
	end,
	if
		NeedSend -> %% 修改数据库 + 发送邮件
			Title = data_language:get(4260001),
			Content = data_language:get(4260002),
			Reward = [{0,38210001,1}], %% 改名卡
			Sql = io_lib:format(<<"update player_low set c_rename = ~p WHERE id = ~p">>, [NewCName, RoleId]),
			db:execute(Sql),
			lib_mail_api:send_sys_mail([RoleId], Title, Content, Reward);
		true ->
			skip
	end,
	Ps#player_status{c_rename = NewCName}.