%% ---------------------------------------------------------------------------
%% @doc player_behavior

%% @author  lzh
%% @email   lu13824949032@gmail.com
%% @since   2021/11/3 0003
%% @desc  
%% ---------------------------------------------------------------------------

%% 玩家行为状态信息
-record(player_behavior, {
      is_stop = 1
    , state = idle  :: idle | behavior | dead
    , tree_id = undefined
    , warning_range = 1000
    , object_map = #{}
    , user_map = #{}
    , drop_map = #{}
    , battle = undefined
    , pet_battle = undefined
    , att = undefined
    , collect_att = undefined
    , drop_att = undefined
    , walk_path = []
    , walk_point = {0, 0}
}).

-record(player_behavior_battle, {
      skill_cd = []
    , last_skill_id = 0
    , next_att_time = 0
    , skill_link = []
    , release_skill_map = #{}
    , selected_skill = #{}
    , skill_combo = []
    , track_ref = []
    , share_pre_ref = []
    , god_status = undefined
}).

-record(pet_behavior_battle, {
    skill_cd = []
    , next_att_time = 0
    , skill_link = []
    , release_skill_map = #{}
    , selected_skill = #{}
    , skill_combo = []
}).

-record(behavior_battle_god, {
      is_auto = 0               %% 是否自动变身
    , is_god = 0                %% 是否变身状态中
    , god_ref = undefined       %% 变身定时器
    , next_time = 0             %% 下次变身时间
}).

