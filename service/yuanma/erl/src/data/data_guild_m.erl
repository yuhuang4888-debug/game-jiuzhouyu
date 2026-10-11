%% ---------------------------------------------------------------------------
%% @doc data_guild_m.erl(data_guild_manual)

%% @author  hjh
%% @email  hejiahua@163.com
%% @since  2016-12-15
%% @deprecated 手动配置
%% ---------------------------------------------------------------------------
-module(data_guild_m).
-export([]).

-compile(export_all).

-include("guild.hrl").
-include("common.hrl").

get_config(T) ->
    F = fun() ->
        case T of
            % % 默认的正式人员容量
            % regular_capacity_default -> 50;
            % % 默认的学徒人员容量
            % apprentice_capacity_default -> 10;
            % 默认公会成员容量
            member_capacity -> 50;
            % 公会申请列表的长度限制
            guild_apply_len_limit -> 20;
            % 海投手动申请的个数
            guild_apply_multi_len -> 5;
            guild_station_scene_id -> 4001;
            % 公告的长度
            announce_len -> 100;
            % 宣言的长度
            tenet_len -> 100;
            % 职位名字的长度
            position_name_max_len -> 8;
            % 捐献日志长度
            donate_log_max_len -> 30;
            % % 自动学徒转正的最小等级差
            % auto_apprentice_to_normal_min_server_lv_diff -> 20;
            % % 自动转成精英的最小贡献值
            % auto_to_elite_min_donate -> 0;
            % 其他成员能被自动任命会长的最长离线时间
            auto_to_chief_max_offline_time_lim -> 259200; % 86400*3
            % 在会长离线一定时间,自动任命领袖
            auto_to_chief_af_chief_leave_time -> 259200;  % 86400*3
            % % 清理公会的活跃度
            % disband_week_liveness_limit -> 3000;
            % % 清理公会的不活跃度次数
            % disband_not_liveness_num -> 2;
            % 申请加入公会等级限制
            apply_join_guild_lv -> 999;
            % 创建公会等级限制
            create_guild_lv -> 10;
            % 公会默认创建等级
            guild_default_lv -> 1;
            % % 公会名字长度
            % guild_name_len -> 10;
            % 公告每周免费修改次数
            free_modify_times -> 10;
            % 修改公告花费的元宝
            modify_announce_cost_gold -> 0;
            % 默认工资
            default_salary -> [];
            % 公会仓库默认格子数
            default_depot_cell -> 200;
            % 公会探索开启等级
            guild_dun_open_lv -> 2;
            % 公会探索人物开启等级
            guild_dun_role_lv -> 2;
            % 领取探索宝箱的最低积分
            dun_score_reward_need -> 10;
            prestige_limit_goods -> [];
            title_degrade_val -> 100;
            prestige_day_max -> [{3,2000},{5,2050},{4,2100},{2,2100},{1,2300}];
            day_assist_count -> 5;
            day_assist_extra_reward -> [];
            % 每天合并公会操作的时间(每天早上5点)
            % 注:修改此处要同步修改data_crontab里对应项
            guild_merge_time -> 5 * 3600
        end
    end,
    case data_guild:get_cfg(T) of
        false -> F();
        Val -> Val
    end.

%% 获得创建公会的消耗配置
get_create_guild_cost(1) ->
    get_config(create_guild_special_cost);
get_create_guild_cost(2) ->
    get_config(create_guild_normal_cost);
get_create_guild_cost(_) -> false.

%% 获得职位的排序大小
get_position_sort(?POS_NORMAIL) -> 0;
get_position_sort(?POS_ELITE) -> 1;
get_position_sort(?POS_BABY) -> 2;
get_position_sort(?POS_DUPTY_CHIEF) -> 3;
get_position_sort(?POS_CHIEF) -> 4;
get_position_sort(_) -> 0.

% %% 获得最大职位(删公会)
% get_max_position_sort(Position, SecPosition) ->
%     PositionNo = get_position_sort(Position),
%     SecPositionNo = get_position_sort(SecPosition),
%     max(PositionNo, SecPositionNo).

%% 获得职位的排名(用于操作低职位的权限等),领袖部分功能需要特殊处理
get_position_no(?POS_NORMAIL) -> 0;
get_position_no(?POS_ELITE) -> 1;
get_position_no(?POS_BABY) -> 2;
get_position_no(?POS_DUPTY_CHIEF) -> 3;
get_position_no(?POS_CHIEF) -> 4;
get_position_no(_) -> 0.

% %% 获得最大职位的排名
% get_max_position_no(Position, SecPosition) ->
%     PositionNo = get_position_no(Position),
%     SecPositionNo = get_position_no(SecPosition),
%     max(PositionNo, SecPositionNo).

% %% 获得最大职位
% get_max_position(Position, SecPosition) ->
%     PositionNo = get_position_no(Position),
%     SecPositionNo = get_position_no(SecPosition),
%     case PositionNo > SecPositionNo of
%         true -> Position;
%         false -> SecPosition
%     end.

%% 本职位是否能任命
is_enable_appoint_position(Position) ->
    EnableAppointList = [?POS_CHIEF],
    lists:member(Position, EnableAppointList).

%% 获得职位名字
get_position_name(_Position, PositionName, _Sex) when length(PositionName) > 0 -> PositionName;
get_position_name(_, _, _) -> "".

get_position_name(Position, _Sex) ->
    case data_guild:get_guild_pos_cfg(Position) of
        [] -> PositionName = "";
        #guild_pos_cfg{name = PositionName} -> ok
    end,
    PositionName.

%% 获取公会成员上限
get_guild_member_capacity(GuildLv) ->
    case data_guild:get_guild_lv_cfg(GuildLv) of
        #guild_lv_cfg{member_capacity = MemberCapacity} -> MemberCapacity;
        _ -> get_config(member_capacity)
    end.

%% 获取公会升级的邮件内容
get_upgrade_mail_content(GuildLv) ->
    case data_guild:get_guild_lv_cfg(GuildLv) of
        #guild_lv_cfg{upgrade_desc = UpgradeDesc} -> UpgradeDesc;
        _ -> ""
    end.

%% 获取公会职位的人数上限
get_position_max_num(Position) ->
    case data_guild:get_guild_pos_cfg(Position) of
        #guild_pos_cfg{num = Num} -> Num;
        _ ->
            case Position of
                ?POS_CHIEF ->           1;
                ?POS_DUPTY_CHIEF ->     2;
                ?POS_NORMAIL ->         99999;
                _ ->                    0
            end
    end.