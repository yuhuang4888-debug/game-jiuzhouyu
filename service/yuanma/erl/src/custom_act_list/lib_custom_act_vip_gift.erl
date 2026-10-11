%% ---------------------------------------------------------------------------
%% @doc lib_custom_act_vip_gift.erl

%% @author  lxl
%% @email  
%% @since  
%% @deprecated vip特惠礼包
%% ---------------------------------------------------------------------------
-module(lib_custom_act_vip_gift).
-export([]).

-compile(export_all).

-include("server.hrl").
-include("figure.hrl").
-include("custom_act.hrl").
-include("errcode.hrl").
-include("common.hrl").
-include("def_fun.hrl").
-include("goods.hrl").

-define(DATA_KEY_REWARD_STATE,                 1).        %% 奖励id状态
-define(DATA_KEY_REWARD_TIME,                 2).        %% 时间

send_reward_status(PS, ActInfo) ->
	#act_info{key = {Type, SubType}} = ActInfo,
    {NewPS, CustomActData} = get_custom_data(PS, ActInfo),
	GradeIds = lib_custom_act_util:get_act_reward_grade_list(Type, SubType),
	F = fun(GradeId, Acc) ->
        case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, GradeId) of
            #custom_act_reward_cfg{
                name = Name,
                desc = Desc,
                condition = Condition,
                format = Format,
                reward = Reward
            } = RewardCfg ->
                %% 计算奖励的领取状态
                Status = count_reward_status(CustomActData, ActInfo, RewardCfg),
                ReceiveTimes = 0,
                ExtraInfo = get_extra_info(CustomActData, ActInfo, RewardCfg),
                ConditionStr = util:term_to_string(Condition++ExtraInfo),
                RewardStr = util:term_to_string(Reward),
                [{GradeId, Format, Status, ReceiveTimes, Name, Desc, ConditionStr, RewardStr} | Acc];
            _ -> Acc
        end
    end,
    PackList = lists:foldl(F, [], GradeIds),
    %?PRINT("reward_status:~p~n", [PackList]),
    {ok, BinData} = pt_331:write(33104, [Type, SubType, PackList]),
    lib_server_send:send_to_sid(PS#player_status.sid, BinData),
    {ok, NewPS}.

get_custom_data(PS, ActInfo) ->
	#act_info{key = {Type, SubType}, stime = STime, etime = ETime} = ActInfo,
	#player_status{status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    case maps:get({Type, SubType}, DataMap, 0) of 
        #custom_act_data{data = Data} = CustomActData -> 
        	{_, UTime} = ulists:keyfind(?DATA_KEY_REWARD_TIME, 1, Data, {?DATA_KEY_REWARD_TIME, 0}),
        	NeedNew = ?IF(UTime>=STime andalso UTime=<ETime, false, true);
        _ ->
            NeedNew = true, CustomActData = undefined
    end,
    case NeedNew of 
    	true ->
    		NewData = [{?DATA_KEY_REWARD_STATE, []}, {?DATA_KEY_REWARD_TIME, STime}],
    		NewCustomActData = #custom_act_data{id = {Type, SubType}, type = Type, subtype = SubType, data = NewData},
    		NewPS = lib_custom_act:save_act_data_to_player(PS, NewCustomActData),
    		{NewPS, NewCustomActData};
    	_ ->
    		{PS, CustomActData}
    end.

count_reward_status(CustomActData, _ActInfo, RewardCfg) ->
	#custom_act_reward_cfg{grade = RewardId} = RewardCfg,
	#custom_act_data{data = Data} = CustomActData,
	{_, RewardListState} = ulists:keyfind(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, []}),
	case lists:keyfind(RewardId, 1, RewardListState) of 
		{RewardId, RewardSt, _DiscountNo} -> RewardSt;
		_ -> 0
	end.

get_extra_info(CustomActData, _ActInfo, RewardCfg) ->
	#custom_act_reward_cfg{grade = RewardId, condition = Condition} = RewardCfg,
	#custom_act_data{data = Data} = CustomActData,
	{_, RewardListState} = ulists:keyfind(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, []}),
	{_, NormalCost} = lists:keyfind(gold, 1, Condition),
	case lists:keyfind(RewardId, 1, RewardListState) of 
		{RewardId, _RewardSt, DiscountNo} -> 
			{_, DiscountList} = ulists:keyfind(discount, 1, Condition, {discount, []}),
			case ulists:find(fun({_Cost, No, _W, _P}) -> DiscountNo == No end, DiscountList) of 
				{ok, {NowCost, _, _, _}} ->
					[{now_cost, NowCost}];
				_ ->
					[{now_cost, NormalCost}]
			end;
		_ -> [{now_cost, NormalCost}]
	end.

set_discount(PS, ActInfo, RewardId) ->
	#player_status{figure = #figure{vip = _VipLv}} = PS,
	#act_info{key = {Type, SubType}} = ActInfo,
	{PS1, CustomActData} = get_custom_data(PS, ActInfo),
	#custom_act_data{data = Data} = CustomActData,
	{_, RewardListState} = ulists:keyfind(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, []}),
	case lists:keyfind(RewardId, 1, RewardListState) of 
		false ->
			case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
	            #custom_act_reward_cfg{
	                condition = Condition
	            } ->
	            	case lists:keyfind(vip, 1, Condition) of 
	            		{_, _VipNeed} ->
			                {_, DiscountList} = ulists:keyfind(discount, 1, Condition, {discount, []}),
			                {NowCost, DiscountNo, _, _} = util:find_ratio(DiscountList, 3),
			                case DiscountNo > 0 of 
			                	true ->
			                		NewRewardListState = [{RewardId, 1, DiscountNo}|RewardListState],
			                		NewData = lists:keystore(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, NewRewardListState}),
			                		NewCustomActData = CustomActData#custom_act_data{data = NewData},
			                		NewPS = lib_custom_act:save_act_data_to_player(PS1, NewCustomActData),
			                		{ok, NewPS, NowCost};
			                	_ ->
			                		{false, ?MISSING_CONFIG, PS1}
			                end;	
			            % {_, _} ->
			            % 	{false, ?VIP_LIMIT, PS1};
			            _ ->
			            	{false, ?MISSING_CONFIG, PS1}
			        end;
	            _ -> 
	            	{false, ?MISSING_CONFIG, PS1}
	        end;
		_ ->
			{false, ?ERRCODE(err332_vip_discount_set), PS1}
	end.

reveive_reward(PS, ActInfo, RewardId) ->
	#player_status{figure = #figure{vip = VipLv}} = PS,
	#act_info{key = {Type, SubType}} = ActInfo,
	{PS1, CustomActData} = get_custom_data(PS, ActInfo),
	#custom_act_data{data = Data} = CustomActData,
	{_, RewardListState} = ulists:keyfind(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, []}),
	case lists:keyfind(RewardId, 1, RewardListState) of 
		{RewardId, 1, DiscountNo} ->
			case lib_custom_act_util:get_act_reward_cfg_info(Type, SubType, RewardId) of
	            #custom_act_reward_cfg{
	                condition = Condition
	            } = RewardCfg ->
	            	case lists:keyfind(vip, 1, Condition) of 
	            		{_, VipNeed} when VipLv >= VipNeed ->
			                {_, DiscountList} = ulists:keyfind(discount, 1, Condition, {discount, []}),
			                {ok, {NowCost, _, _, _}} = ulists:find(fun({_A, B, _C, _D}) -> B == DiscountNo end, DiscountList),
			                case lib_goods_api:cost_object_list_with_check(PS1, NowCost, vip_gift_buy, "") of 
			                	{true, PSAfCost} ->
			                		lib_log_api:log_custom_act_cost(PS#player_status.id, Type, SubType, NowCost, [RewardId]),
			                		RewardList = lib_custom_act_util:count_act_reward(PSAfCost, ActInfo, RewardCfg),
			                		lib_log_api:log_custom_act_reward(PS#player_status.id, Type, SubType, RewardId, RewardList),
				            		NewRewardListState = [{RewardId, 2, DiscountNo}|lists:keydelete(RewardId, 1, RewardListState)],
				            		NewData = lists:keystore(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, NewRewardListState}),
				            		NewCustomActData = CustomActData#custom_act_data{data = NewData},
				            		NewPS = lib_custom_act:save_act_data_to_player(PSAfCost, NewCustomActData),
				            		{ok, PSAfReward} = lib_goods_api:send_reward_with_mail(NewPS, #produce{type = vip_gift_buy, reward = RewardList, show_tips = 3}),
				            		{ok, PSAfReward};	
				            	{false, Res, NewPS} ->
				            		{false, Res, NewPS}
				            end;
				        {_, _} ->
			            	{false, ?VIP_LIMIT, PS1};
			            _ ->
			            	{false, ?MISSING_CONFIG, PS1}
				    end;
	            _ -> 
	            	{false, ?MISSING_CONFIG, PS1}
	        end;
	    {RewardId, 2, _DiscountNo} ->
	    	{false, ?ERRCODE(err331_already_get_reward), PS1};
		_ ->
			{false, ?ERRCODE(err332_vip_discount_not_set), PS1}
	end.

gm_reset_gift_state(PS, Type, SubType) ->
	#player_status{status_custom_act = StatusCustomAct} = PS,
    #status_custom_act{data_map = DataMap} = StatusCustomAct,
    case maps:get({Type, SubType}, DataMap, 0) of 
        #custom_act_data{data = Data} = CustomActData -> 
        	NewData = lists:keyreplace(?DATA_KEY_REWARD_STATE, 1, Data, {?DATA_KEY_REWARD_STATE, []}),
        	NewCustomActData = CustomActData#custom_act_data{data = NewData},
		    NewPS = lib_custom_act:save_act_data_to_player(PS, NewCustomActData),
		    NewPS;
        _ ->
            PS
    end.