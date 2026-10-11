

-define(LEVEL_NUM_ONE_AREA,     10).   %% 一个区间的层数

%% 游戏服state
-record(rdungeon_state, {
		role_map = #{}            %% role_id => #rdungeon_role{}
    }).

%% 跨服state
-record(kf_rdungeon_state, {
        role_map = #{}    %% 玩家列表 role_id => #kf_rdungeon_role{}
        , level_map = #{}    %% level => [{role_id,go_time}]
        , challenger = #{}    %% 擂主列表 level => #level_challenger{}
    }).


-record(rdungeon_role, {
        role_id = 0
        , start_level = 1
        , rw_state = 0
        , time = 0 
        , ldungeon_list = []    %% [{level, go_time, time}]      
    }).

-record(kf_rdungeon_role, {
        role_id = 0        % 擂主id
        , name = <<>>
        , server_id = 0
        , server_num = 0
        , lv = 0
        , career = 0
        , sex = 0
        , turn = 0
        , pic = ""
        , pic_ver = 0
        , ldungeon_list = []      % [{level, go_time, time}]    
    }).

-record(level_challenger, {
		level = 0
        , role_id = 0        % 擂主id
        , go_time = 0 
        , time = 0  
    }).



%%%%%%%%%%%%%%%%% local
-define(SQL_RANK_DUN_ROLE_SELECT, 		<<"select role_id, start_level, rw_state, time, ldungeon_list from `rank_dun_role`">>).
-define(SQL_RANK_DUN_ROLE_REPLACE, 		<<"replace `rank_dun_role` set role_id=~p, start_level=~p, rw_state=~p, time=~p, ldungeon_list='~s' ">>).

-define(SQL_KF_RANK_DUN_ROLE_SELECT, 		<<"select role_id, name, server_id, server_num, role_lv, career, sex, turn, pic, pic_ver, ldungeon_list from `kf_rank_dun_role`">>).
-define(SQL_KF_RANK_DUN_ROLE_REPLACE, 		<<"replace `kf_rank_dun_role` set role_id=~p, name='~s', server_id=~p, server_num=~p, role_lv=~p, career=~p, sex=~p, turn=~p, pic='~s', pic_ver=~p, ldungeon_list='~s' ">>).
-define(SQL_KF_RANK_DUN_ROLE_TRUNCATE, 		<<"truncate table `kf_rank_dun_role`">>).

-record(base_rank_dungeon, {
		level = 0
        , dungeon_id = 0        % 
        , reward = [] 
        , challenger_reward = []
        , resource = ""
    }).

-record(base_rank_dungeon_daily, {
		level = 0
        , reward = [] 
    }).