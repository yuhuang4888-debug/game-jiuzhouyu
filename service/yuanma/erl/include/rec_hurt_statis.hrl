%%%---------------------------------------------------------------------
%%% 伤害统计相关record定义
%%%---------------------------------------------------------------------

%% ---------------------- #hurt_statis_state.type ----------------------
-define (TYPE_1V1_WITH_PARTNER, 1). 	%% 统计类型：1带伙伴出战的1v1伤害统计

-record (hurt_statis_state, {
	type 			= 0, 				%% 统计类型 
	data 			= undefined,   		%% 统计数据 term()
	other 			= undefined, 		%% 扩展数据
	ref 			= none 				%% 定时器ref
}).

%% 带伙伴出战的1v1伤害统计
-record (statis_1v1_object, {
	id 				= 0, 				%% 唯一id
	sign 			= 0,				%% 对象类型
	hurt 			= 0 				%% 伤害
}).
