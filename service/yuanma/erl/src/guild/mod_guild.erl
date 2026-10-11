%% ---------------------------------------------------------------------------
%% @doc mod_guild.erl

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 公会进程
%% ---------------------------------------------------------------------------
-module(mod_guild).

-export([
        create_guild/2
        , search_guild_by_name_upper/1
        , apply_call/4
        , apply_cast/3
    ]).

-export([
        search_guild_list/4
        , apply_join_guild/3
        , apply_join_guild_multi/2
        , send_guild_info/4
        , approve_guild_apply/4
        , get_all_guild/0
    ]).


-export([
        day_clear/2
    ]).

-compile(export_all).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("guild.hrl").
-include("common.hrl").
-include("errcode.hrl").

%% ---------------------- call -------------------------------

%% 创建公会
create_guild(Guild, GuildMember) ->
    case catch gen_server:call(?GUILD_PID, {'create_guild', Guild, GuildMember}) of
        {ok, NewGuild} -> {ok, NewGuild};
        {false, ErrorCode} -> {false, ErrorCode};
        _ -> {false, ?FAIL}
    end.

%% 根据公会大写名字查公会
search_guild_by_name_upper(NameUpper) ->
    case catch apply_call(lib_guild_data, match_guild, [{name_upper, NameUpper}], 7000) of
        Reply when is_map(Reply) -> Reply;
        _ -> false
    end.

%% 是否有该权限
is_have_permission(RoleId, PermissionType) ->
    case catch gen_server:call(?GUILD_PID, {'is_have_permission', RoleId, PermissionType}) of
        Bool when is_boolean(Bool) -> Bool;
        _ -> false
    end.

%% 检测放入公会仓库
check_move_to_depot(RoleId, DonateList) ->
    gen_server:call(?GUILD_PID, {'check_move_to_depot', RoleId, DonateList}).

%% 获取指定排名的公会信息
get_specify_ranking_guild(Ranking) ->
    gen_server:call(?GUILD_PID, {'get_specify_ranking_guild', Ranking}, 500).

%% 获取前几名的公会信息
get_some_top_ranking_guild(MinRanking) ->
    gen_server:call(?GUILD_PID, {'get_some_top_ranking_guild', MinRanking}, 500).

apply_call(Moudle, Method, Args, Timeout) ->
    gen_server:call(?GUILD_PID, {'apply_call', Moudle, Method, Args}, Timeout).

%% ---------------------- cast -------------------------------

%% 搜索公会列表
search_guild_list(RoleId, GuildName, PageSize, PageNo) ->
    gen_server:cast(?GUILD_PID, {'search_guild_list', RoleId, GuildName, PageSize, PageNo}).

%% 申请加入公会
apply_join_guild(RoleId, RoleInfoMap, GuildId) ->
    gen_server:cast(?GUILD_PID, {'apply_join_guild', RoleId, RoleInfoMap, GuildId}).

%% 批量申请
apply_join_guild_multi(RoleId, RoleInfoMap) ->
    gen_server:cast(?GUILD_PID, {'apply_join_guild_multi', RoleId, RoleInfoMap}).

%% 获取公会信息界面-基础信息
send_guild_info(RoleId, GuildId, SalaryStatus, JoinTime) ->
    gen_server:cast(?GUILD_PID, {'send_guild_info', RoleId, GuildId, SalaryStatus, JoinTime}).

%% 获取公会信息界面-成员列表
send_guild_member_short_info(RoleId, GuildId, SortType, SortFlag, MemberType, SpecialType) ->
    gen_server:cast(?GUILD_PID, {'send_guild_member_short_info', RoleId, GuildId, SortType, SortFlag, MemberType, SpecialType}).

do_result_guild_person_rank(DesignationMap, BelongSanctuaryList) ->
    gen_server:cast(?GUILD_PID, {'do_result_guild_person_rank', DesignationMap, BelongSanctuaryList}).

get_guild_rank_info_with_guild_id(RoleId, GuildId, DesignationMap) ->
    gen_server:cast(?GUILD_PID, {'get_guild_rank_info_with_guild_id', RoleId, GuildId, DesignationMap}).

get_guild_rank_info_with_sanctuary_id(RoleId, SanctuaryId, BelongGuild, DesignationMap) ->
    gen_server:cast(?GUILD_PID, {'get_guild_rank_info_with_sanctuary_id', RoleId, SanctuaryId, BelongGuild, DesignationMap}).

%%通知公会成员圣域结算结果
send_to_guild_member_sanctuary_settlement(GuildId, Rank) ->
    gen_server:cast(?GUILD_PID, {'send_to_guild_member_sanctuary_settlement', GuildId, Rank}).
% %% 获取成员列表界面
% send_guild_member_info(RoleId, Figure, GuildId, PageSize, PageNo, SortType, SortFlag, MemberType, SpecialType) ->
%     gen_server:cast(?GUILD_PID, {'send_guild_member_info', RoleId, Figure, GuildId, PageSize, PageNo, SortType, SortFlag, MemberType, SpecialType}).

%% 退出公会
quit_guild(RoleId) ->
    gen_server:cast(?GUILD_PID, {'quit_guild', RoleId}).

%% 申请列表
send_guild_apply_list(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_guild_apply_list', RoleId, GuildId}).

%% 审批公会请求
approve_guild_apply(RoleId, ApplyRoleId, ApplyRoleInfoMap, Type) ->
    gen_server:cast(?GUILD_PID, {'approve_guild_apply', RoleId, ApplyRoleId, ApplyRoleInfoMap, Type}).

%% 审批设置界面
send_approve_setting_view(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_approve_setting_view', RoleId, GuildId}).

%% 设置审批
setting_approve(RoleId, ApproveType, AutoApproveLv, AutoApprovePower) ->
    gen_server:cast(?GUILD_PID, {'setting_approve', RoleId, ApproveType, AutoApproveLv, AutoApprovePower}).

%% 编辑宣言
modify_tenet(RoleId, Tenet) ->
    gen_server:cast(?GUILD_PID, {'modify_tenet', RoleId, Tenet}).

%% 公告编辑界面
send_announce_view_info(Sid, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_announce_view_info', Sid, GuildId}).

%% 编辑公告
modify_announce(RoleId, SaveType, Announce) ->
    gen_server:cast(?GUILD_PID, {'modify_announce', RoleId, SaveType, Announce}).

%% 职位管理界面
send_position_manage_view(RoleId, GuildId, PageSize, PageNo) ->
    gen_server:cast(?GUILD_PID, {'send_position_manage_view', RoleId, GuildId, PageSize, PageNo}).

%% 任命职位
appoint_position(RoleId, AppointeeId, Position) ->
    gen_server:cast(?GUILD_PID, {'appoint_position', RoleId, AppointeeId, Position}).

%% 踢出公会
kick_out_guild(RoleId, LeaveId) ->
    gen_server:cast(?GUILD_PID, {'kick_out_guild', RoleId, LeaveId}).

%% 重新命名职位名称
rename_position(RoleId, Position, PositionName) ->
    gen_server:cast(?GUILD_PID, {'rename_position', RoleId, Position, PositionName}).

%% 职位权限界面
send_position_permission_list(RoleId, Position) ->
    gen_server:cast(?GUILD_PID, {'send_position_permission_list', RoleId, Position}).

%% 取消申请加入公会
cancel_apply(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'cancel_apply', RoleId, GuildId}).

%% 发送职位数量列表
send_position_num_list(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_position_num_list', RoleId, GuildId}).

%% 修改职位权限
modify_position_permission(RoleId, Position, PermissionType, IsAllow) ->
    gen_server:cast(?GUILD_PID, {'modify_position_permission', RoleId, Position, PermissionType, IsAllow}).

%% 清空申请列表
clean_all_guild_apply_on_this_guild(RoleId) ->
    gen_server:cast(?GUILD_PID, {'clean_all_guild_apply_on_this_guild', RoleId}).

%% 全部批准入会
approve_all_guild_apply_on_this_guild(RoleId) ->
    gen_server:cast(?GUILD_PID, {'approve_all_guild_apply_on_this_guild', RoleId}).

%% 玩家拥有的权限列表
send_role_permission_list(RoleId) ->
    gen_server:cast(?GUILD_PID, {'send_role_permission_list', RoleId}).

%% 更新圣域公会前三名
update_sanctuary_top3_guild_list(GuildIdList) ->
    gen_server:cast(?GUILD_PID, {'update_sanctuary_top3_guild_list', GuildIdList}).

% %% 发送公会资金信息
% send_gfunds_info(RoleId, GuildId) ->
%     gen_server:cast(?GUILD_PID, {'send_gfunds_info', RoleId, GuildId}).

%% 获取公会资金
get_gfunds(GuildId) ->
    gen_server:call(?GUILD_PID, {'get_gfunds', GuildId}, 1000).

get_guild_name(GuildId) ->
    gen_server:call(?GUILD_PID, {'get_guild_name', GuildId}, 1000).

get_guild_chief(GuildId) ->
    gen_server:call(?GUILD_PID, {'get_guild_chief', GuildId}, 1000).

get_guild_member_id_list(GuildId) ->
    gen_server:call(?GUILD_PID, {'get_guild_member_id_list', GuildId}, 1000).

get_guild_member_capacity(GuildId) ->
    gen_server:call(?GUILD_PID, {'get_guild_member_capacity', GuildId}, 1000).

get_guild_average_lv(GuildId, Num) ->
    gen_server:call(?GUILD_PID, {'get_guild_average_lv', GuildId, Num}, 1000).

get_all_guild_average_lv(Num) ->
    gen_server:call(?GUILD_PID, {'get_all_guild_average_lv', Num}, 5000).

%% 增加资金
%% @param RoleId 玩家id(可以为空)
%% @param Type 产出类型 见 data_goods:get_produce_type/1
add_gfunds(RoleId, GuildId, AddGfunds, Type) ->
    gen_server:cast(?GUILD_PID, {'add_gfunds', RoleId, GuildId, AddGfunds, Type}).

%% 增加贡献
add_donate(RoleId, Donate, ProduceType, Extra) ->
    gen_server:cast(?GUILD_PID, {'add_donate', RoleId, Donate, ProduceType, Extra}).

%% 增加公会成长值
%% @param RoleId 玩家id(可以为空)
add_growth(RoleId, GuildId, AddGrowth, ProduceType, Extra) ->
    gen_server:cast(?GUILD_PID, {'add_growth', RoleId, GuildId, AddGrowth, ProduceType, Extra}).

%% 增加公会活跃度
add_gactivity(RoleId, GuildId, GActivity, ProduceType) ->
    gen_server:cast(?GUILD_PID, {'add_gactivity', RoleId, GuildId, GActivity, ProduceType}).

%% 增加公会副本积分
add_guild_dun_score(RoleId, GuildId, DunScore, ProduceType) ->
    gen_server:cast(?GUILD_PID, {'add_guild_dun_score', RoleId, GuildId, DunScore, ProduceType}).

%% 更新公会成员属性
update_guild_member_attr(RoleId, AttrList) ->
    gen_server:cast(?GUILD_PID, {'update_guild_member_attr', RoleId, AttrList}).

%% 所有职位权限的信息
send_all_position_permission_list(RoleId) ->
    gen_server:cast(?GUILD_PID, {'send_all_position_permission_list', RoleId}).

%% 自动任命为会长
auto_appoint_to_chief(DelaySec) ->
    gen_server:cast(?GUILD_PID, {'auto_appoint_to_chief', DelaySec}).

%% 自动任命为会长
auto_appoint_to_chief_by_guild_id(GuildId) ->
    gen_server:cast(?GUILD_PID, {'auto_appoint_to_chief_by_guild_id', GuildId}).

%% 解散公会
disband_guild(DisbandType, GuildId) ->
    gen_server:cast(?GUILD_PID, {'disband_guild', DisbandType, GuildId}).

%% 升级公会
upgrade_guild(RoleId) ->
    gen_server:cast(?GUILD_PID, {'upgrade_guild', RoleId}).

%% 检测是否需要解散帮派
check_auto_disband_guild(GuildId) ->
    gen_server:cast(?GUILD_PID, {'check_auto_disband_guild', GuildId}).

%% @doc 定制活动定时奖励发放
%% @param ModuleSub:定制活动ID
%% @param AcSub:定制活动子项
%% @param GuildList:[{guild_id, rank}|...]
%% @return Map:{rank=>[{role_id, job, create_time}|...]}
%% job:帮会最高职务。
%% enter_time:入帮时间
ac_custom_timer_reward(ModuleSub, AcSub, GuildList) ->
    gen_server:cast(?GUILD_PID, {'ac_custom_timer_reward', ModuleSub, AcSub, GuildList}).

%% 更新玩家战力
update_guild_member_power(RoleId, CombatPower) ->
    gen_server:cast(?GUILD_PID, {'update_guild_member_power', RoleId, CombatPower}).

%% cast到副本
apply_cast(Moudle, Method, Args) ->
    gen_server:cast(?GUILD_PID, {'apply_cast', Moudle, Method, Args}).

%% 指定帮派id的成员cast方式执行MFA
%% @param  MemberType 0: 所有成员 1: 在线成员 2: 离线成员
apply_cast_guild_member(GuildId, MemberType, Module, Method, Args) ->
    gen_server:cast(?GUILD_PID, {'apply_cast_guild_member', GuildId, MemberType, Module, Method, Args}).

%% 改名检查
check_rename_guild(GuildId, RoleId, RenameArgs) ->
    gen_server:cast(?GUILD_PID, {check_rename_guild, GuildId, RoleId, RenameArgs}).

%% 是否有免费改名次数
check_rename_guild_free(GuildId, RoleId) ->
    gen_server:cast(?GUILD_PID, {check_rename_guild_free, GuildId, RoleId}).

%% 帮派改名
rename_guild(GuildId, RoleId, RenameArgs) ->
    gen_server:cast(?GUILD_PID, {rename_guild, GuildId, RoleId, RenameArgs}).

chief_disband_guild(RoleId) ->
    gen_server:cast(?GUILD_PID, {chief_disband_guild, RoleId}).

%% 公会合并请求列表
send_guild_merge_requests(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {send_guild_merge_requests, RoleId, GuildId}).

%% 公会合并申请
apply_guild_merge(RoleId, ApplyGId, TargetGId) ->
    gen_server:cast(?GUILD_PID, {apply_guild_merge, RoleId, ApplyGId, TargetGId}).

%% 响应公会合并申请
response_guild_merge(RoleId, OpType, ApplyGId, TargetGId) ->
    gen_server:cast(?GUILD_PID, {response_guild_merge, RoleId, OpType, ApplyGId, TargetGId}).

%% 公会合并
guild_merge() ->
    gen_server:cast(?GUILD_PID, {guild_merge}).

%% ====================
%% 接口
%% ====================

%% 发送公会邮件
send_guild_mail_by_role_id(RoleId, Title, Content, CmAttachment, ExcludeIdList) ->
    gen_server:cast(?GUILD_PID, {'send_guild_mail_by_role_id', RoleId, Title, Content, CmAttachment, ExcludeIdList}).

%% 发送公会邮件
send_guild_mail_by_guild_id(GuildId, Title, Content, CmAttachment, ExcludeIdList) ->
    gen_server:cast(?GUILD_PID, {'send_guild_mail_by_guild_id', GuildId, Title, Content, CmAttachment, ExcludeIdList}).

%% 小红点
send_red_point(GuildId, RoleId, Type) ->
    gen_server:cast(?GUILD_PID, {'send_red_point', GuildId, RoleId, Type}).

%% 获得公会成员的最高等级
get_guild_member_max_lv(RoleId) ->
    gen_server:call(?GUILD_PID, {'get_guild_member_max_lv', RoleId}).

%% 扣除公会资金
cost_gfunds(RoleId, CostGfunds) ->
    gen_server:call(?GUILD_PID, {'cost_gfunds', RoleId, CostGfunds}).

%% 根据公会id获得公会领袖信息
get_guild_chief_info_by_id(GuildId) ->
    case catch apply_call(lib_guild_data, get_guild_chief_info_by_id, [GuildId], 5000) of
        {ChiefId, ChiefName} -> {ChiefId, ChiefName};
        _ -> {0, ""}
    end.

%% 获取所有公会
get_all_guild()->
    gen_server:call(?GUILD_PID, {'get_all_guild'}).

%% 获取前几名公会
get_top_guild(GuildNum) ->
    gen_server:call(?GUILD_PID, {'get_top_guild', GuildNum}).

%% 根据公会id列表获取公会
get_guild_by_id(GuildIdList) ->
    gen_server:call(?GUILD_PID, {'get_guild_by_id', GuildIdList}).

%% 清理
day_clear(Clock, DelaySec) ->
    RandTime = urand:rand(1, 1000),
    spawn(fun() -> timer:sleep(RandTime), gen_server:cast(?GUILD_PID, {'day_clear', Clock, DelaySec}) end).

%% 更新公会的创建时间
update_guild_create_time(GuildId, CreateTime) ->
    gen_server:cast(?GUILD_PID, {'update_guild_create_time', GuildId, CreateTime}).

%% 获取公会人数
get_guild_member_num(GuildId) ->
    gen_server:call(?GUILD_PID, {'get_guild_member_num', GuildId}).

%% 获取公会人数列表[{guild_id,member_num}]
get_guild_member_num_list() ->
    gen_server:call(?GUILD_PID, {'get_guild_member_num_list'}).

%% 计算公会战力
count_guild_combat_power() ->
    gen_server:cast(?GUILD_PID, {'count_guild_combat_power'}).

%% 发送招募列表
send_recruit_list(RoleId, GuildId, DunId, DunLv, EquipCountType, MaxCount) ->
    gen_server:cast(?GUILD_PID, {'send_recruit_list', RoleId, GuildId, DunId, DunLv, EquipCountType, MaxCount}).

%% 队员招募列表
send_recruit_list(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_recruit_list', RoleId, GuildId}).

%%3v3招募列表
send_recruit_3v3_list(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_recruit_3v3_list', RoleId, GuildId}).

join_sea_camp(Args) ->
    gen_server:cast(?GUILD_PID, {'join_sea_camp', Args}).

auto_join_sea_camp(List) ->
    gen_server:cast(?GUILD_PID, {'auto_join_sea_camp', List}).

%% ================ 公会仓库 =====================

send_guild_depot_info(RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_guild_depot_info', RoleId, GuildId}).

add_to_depot(RoleId, RoleName, GoodsInfo, Num) -> % 弃用
    gen_server:cast(?GUILD_PID, {'add_to_depot', RoleId, RoleName, GoodsInfo, Num}).

add_to_depot(RoleId, RoleName, GoodsInfoL) ->
    gen_server:cast(?GUILD_PID, {'add_to_depot', RoleId, RoleName, GoodsInfoL}).

exchange_depot_goods(RoleId, RoleName, DepotGoodsId, GoodsTypeId, Num) ->
    gen_server:cast(?GUILD_PID, {'exchange_depot_goods', RoleId, RoleName, DepotGoodsId, GoodsTypeId, Num}).

destory_depot_goods(RoleId, RoleName, OpType, Args) ->
    gen_server:cast(?GUILD_PID, {'destory_depot_goods', RoleId, RoleName, OpType, Args}).

send_auto_destroy_setting(RoleId) ->
    gen_server:cast(?GUILD_PID, {'send_auto_destroy_setting', RoleId}).

%% ================ 公会仓库 =====================

%% ================ 公会技能 =====================

send_guild_skill_list(RoleId, GuildId, PlayerGSkillMap, SkillType, OriginalAttr, RoleLv) ->
    gen_server:cast(?GUILD_PID, {'send_guild_skill_list', RoleId, GuildId, PlayerGSkillMap, SkillType, OriginalAttr, RoleLv}).

research_skill(RoleId, SkillId) ->
    gen_server:cast(?GUILD_PID, {'research_skill', RoleId, SkillId}).

%% Call操作 避免异步造成玩家身上的技能数据不同步
learn_skill(RoleId, SkillId, ExtraData) ->
    gen_server:call(?GUILD_PID, {'learn_skill', RoleId, SkillId, ExtraData}, 500).

%% ================ 公会技能 =====================

%% ================ 公会晚宴 =====================

give_gfeast_red_envelopes(GuildId, RankNo, RedEnvelopesCfgId) ->
    gen_server:cast(?GUILD_PID, {'give_gfeast_red_envelopes', GuildId, RankNo, RedEnvelopesCfgId}).

summon_guild_feast_dragon(MonId, GuildId, RoleId) ->
    gen_server:cast(?GUILD_PID, {'summon_guild_feast_dragon', MonId, GuildId, RoleId}).

%% ================ 公会晚宴 =====================

%% ================ 公会战 =====================

sync_guild_list_to_gwar() ->
    gen_server:cast(?GUILD_PID, {'sync_guild_list_to_gwar'}).

update_guild_division(DivisionIndexMap) ->
    gen_server:cast(?GUILD_PID, {'update_guild_division', DivisionIndexMap}).

%% ================ 公会战 =====================

%% ================ 公会榜单结算逻辑 =====================

send_guild_rank_reward(PreFirGuildId, CurFirGuildId, DesignationId) ->
    gen_server:cast(?GUILD_PID, {'send_guild_rank_reward', PreFirGuildId, CurFirGuildId, DesignationId}).

%% ================ 公会榜单结算逻辑 =====================

%% ================ 跨服公会战 =====================

send_seas_dominator_info(Node, RoleId, GuildId) ->
    gen_server:cast(?GUILD_PID, {'send_seas_dominator_info', Node, RoleId, GuildId}).

send_chief_figure_info(Node, RoleId, GuildId, ArgsMap) ->
    gen_server:cast(?GUILD_PID, {'send_chief_figure_info', Node, RoleId, GuildId, ArgsMap}).

%% ================ 跨服公会战 =====================

%% ================ 领地夺宝 =====================
get_guild_rank_info(CopyId) ->
    gen_server:cast(?GUILD_PID, {'get_guild_rank_info', CopyId}).
%% ================ 领地夺宝 =====================

%% ================ 四海争霸/怒海争霸 ================
update_guild_realm(GuildCampList) ->
    gen_server:cast(?GUILD_PID, {'update_guild_realm', GuildCampList}).

update_guild_realm(Realm, OldRealm, GuildId) ->
    gen_server:cast(?GUILD_PID, {'update_guild_realm', Realm, OldRealm, GuildId}).

gm_send_reawrd(Ranking, LimitLv) ->
    gen_server:cast(?GUILD_PID, {'get_guild_member', Ranking, LimitLv}).
%% ================ 四海争霸/怒海争霸 ================、

%% ================ GM相关秘籍 ===================

%% GM编辑公告
modify_announce_by_gm(GuildId, Announce) ->
    gen_server:call(?GUILD_PID, {'modify_announce_by_gm', GuildId, Announce}).

%% GM改公会名字
modify_name_by_gm(GuildId, Name) ->
    gen_server:call(?GUILD_PID, {'modify_name_by_gm', GuildId, Name}).

%% GM解散公会
disband_guild_by_gm(GuildId) ->
    gen_server:call(?GUILD_PID, {'disband_guild', ?DISBAND_REASON_GM, GuildId}).

%% 公会成员的声望增加
add_role_prestige(RoleId, NewPrestige, AddNum) ->
    gen_server:cast(?GUILD_PID, {'add_role_prestige', RoleId, NewPrestige, AddNum}).

%% 工会职位声望限制同步
sync_position_prestige() ->
    gen_server:cast(?GUILD_PID, {'sync_position_prestige'}).

update_members_prestige(GuildId, PrestigeList) ->
    gen_server:cast(?GUILD_PID, {'update_members_prestige', GuildId, PrestigeList}).

gm_flush_member_info() ->
    gen_server:cast(?GUILD_PID, {'gm_flush_member_info'}).

gm_set_chief(GuildId, RoleId) ->
    gen_server:cast(?GUILD_PID, {'gm_set_chief', GuildId, RoleId}).

%% 婚礼一键宴请宾客时拿去对应公会的会员列表
get_guild_member_join_wedding(Args) ->
    gen_server:cast(?GUILD_PID, {'get_guild_member_join_wedding', Args}).

%% 触发公会合并
gm_guild_merge() ->
    gen_server:cast(?GUILD_PID, {'gm_guild_merge'}).

%% 清理公会合并
gm_clear_guild_merge() ->
    gen_server:cast(?GUILD_PID, {'gm_clear_guild_merge'}).

%% 清理公会合并(申请时间在Timestamp前)
gm_clear_guild_merge(Timestamp) ->
    gen_server:cast(?GUILD_PID, {'gm_clear_guild_merge', Timestamp}).

%% ================ GM相关秘籍 ===================

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit, true),
    lib_guild_mod:init(),
    {ok, []}.

handle_call(Request, From, State) ->
    case catch mod_guild_call:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("mod_guild_call error: ~p, Reason=~p~n",[Request, Reason]),
            {reply, error, State}
    end.

handle_cast(Msg, State) ->
    case catch mod_guild_cast:handle_cast(Msg, State)of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("mod_guild_cast error: ~p, Reason:=~p~n",[Msg, Reason]),
            {noreply, State}
    end.

handle_info(Info, State) ->
    case catch mod_guild_info:handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("mod_guild_info error: ~p, Reason:=~p~n",[Info, Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    %% ?ERR("~p is terminate:~p", [?MODULE, _Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
