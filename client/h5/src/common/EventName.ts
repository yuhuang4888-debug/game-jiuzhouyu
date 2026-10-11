// TypeScript file
export class EventName {
	public static GAME_START: string = 'GAME_START';
	public static INIT_CONFIG: string = 'INIT_CONFIG';
	public static WINDOW_RESUME: string = 'WINDOW_RESUME'; //唤醒窗口
	public static WINDOW_PUSE: string = 'INIT_CONFIG'; //窗口切到后台
	public static WINDOW_FOCUS_OUT: string = 'INIT_CONFIG'; //失去焦点
	public static HIDE_HORSE_SUCCESS: string = 'HIDE_HORSE_SUCCESS';
	public static RIDE_HORSE_SUCCESS: string = 'RIDE_HORSE_SUCCESS';
	public static HIDE_OR_SHOW_CANVAS_LAYER: string = 'HIDE_OR_SHOW_CANVAS_LAYER';
	public static GAME_START_AFTER_LOAD_CONFIG: string =
		'GAME_START_AFTER_LOAD_CONFIG';
	public static SHOWRELIVEWINDOW: string = 'SHOWRELIVEWINDOW';
	public static DB_DATA_LOAD_COMPLETED: string = 'DB_DATA_LOAD_COMPLETED';
	public static LOADMAP_COMPLETE: string = 'LOADMAP_COMPLETE';
	public static SCENE_LOAD_VIEW_COMPLETE: string = 'SCENE_LOAD_VIEW_COMPLETE';
	public static TRIGGER_STORY_START: string = 'TRIGGER_STORY_START';
	public static HIDE_RIGHT_TOP_ICON: string = 'HIDE_RIGHT_TOP_ICON';
	public static BROADCAST_ROLE_WAY_POINT: string = 'BROADCAST_ROLE_WAY_POINT';
	public static FINDWAY_STARTED: string = 'FINDWAY_STARTED';
	public static SET_ERROR_VIEW: string = 'SET_ERROR_VIEW';
	public static GAME_DISCONNECT: string = 'GAME_DISCONNECT';
	public static GAME_CONNECT: string = 'GAME_CONNECT';
	public static CHECK_ALIVE_GAME_SENT: string = 'CHECK_ALIVE_GAME_SENT';
	public static CHECK_ALIVE_GAME_RESPONSE: string = 'CHECK_ALIVE_GAME_RESPONSE';
	public static STATE_RESET_SIZE: string = 'STATE_RESET_SIZE';
	public static SWITCH_MAIN_FUNC_VIEW: string = 'SWITCH_MAIN_FUNC_VIEW';
	public static UPDATE_BUFF_VIEW: string = 'UPDATE_BUFF_VIEW';
	public static EXECUTE_DELEY_FIGHT_INFO: string = 'EXECUTE_DELEY_FIGHT_INFO';
	public static MONSTER_ATTACK_MAIN_ROLE: string = 'MONSTER_ATTACK_MAIN_ROLE';
	public static REFRESH_MONSTER_HP: string = 'REFRESH_MONSTER_HP';
	public static INIT_MAINUI_EVENT: string = 'INIT_MAINUI_EVENT';
	public static SHOW_WAITFOR_OPENVIEW_LOADING: string =
		'SHOW_WAITFOR_OPENVIEW_LOADING';
	public static HIDE_WAITFOR_OPENVIEW_LOADING: string =
		'HIDE_WAITFOR_OPENVIEW_LOADING';
	public static GUI_JSON_FINISH: string = 'GUI_JSON_FINISH';
	public static HP_CHANGE_FROM_SCENE: string = 'HP_CHANGE_FROM_SCENE';
	public static REQUEST_CLIENTAUTOFIGHT_DROP_LIST: string =
		'REQUEST_CLIENTAUTOFIGHT_DROP_LIST';
	public static OPEN_DUNGEON_SHOW_VIEW: string = 'OPEN_DUNGEON_SHOW_VIEW';
	public static OPEN_REINCARNATION_ENTER_VIEW: string =
		'OPEN_REINCARNATION_ENTER_VIEW';
	public static OPEN_MEDAL_ENTER_VIEW: string = 'OPEN_MEDAL_ENTER_VIEW';
	public static PICKUP_CLIENTAUTOFIGHT_DROP_LIST: string =
		'PICKUP_CLIENTAUTOFIGHT_DROP_LIST';
	public static CHANGE_ACCOUNT: string = 'CHANGE_ACCOUNT';
	public static SWTICH_SERVER_ID: string = 'SWTICH_SERVER_ID';
	public static EXIT_PROGRAM: string = 'EXIT_PROGRAM';
	public static OPEN_CHEAT_CLIENT_VIEW: string = 'OPEN_CHEAT_CLIENT_VIEW';
	public static OPEN_INSTRUCTION_VIEW: string = 'OPEN_INSTRUCTION_VIEW';
	public static OPEN_PROPERTY_TIPS_VIEW: string = 'OPEN_PROPERTY_TIPS_VIEW';
	public static OPEN_DUNGEON_MAIN_LINE_VIEW: string =
		'OPEN_DUNGEON_MAIN_LINE_VIEW';
	public static CHANGE_LEVEL: string = 'CHANGE_LEVEL';
	public static UPDATE_MAIN_ROLE_INFO_VIEW: string =
		'UPDATE_MAIN_ROLE_INFO_VIEW';
	public static UPDATE_AUTO_REWARD_INFO: string = 'UPDATE_AUTO_REWARD_INFO';
	public static SHOW_HITER_BIG_BLOOD_VIEW: string = 'SHOW_HITER_BIG_BLOOD_VIEW';
	public static SWITCH_ROLE_SECOND_BUTTON: string = 'SWITCH_ROLE_SECOND_BUTTON';
	public static REFRESH_FUNCTION_ICON_RED_DOT: string =
		'REFRESH_FUNCTION_ICON_RED_DOT';
	public static OPEN_REBIRTN_WINDOWS_VIEW: string = 'OPEN_REBIRTN_WINDOWS_VIEW';
	public static UPDATE_KILL_OBJECT_NUM: string = 'UPDATE_KILL_OBJECT_NUM';
	public static TAB_BAR_BE_CLICK: string = 'TAB_BAR_BE_CLICK';
	public static SUB_TAB_BTN_BE_SELECTED: string = 'SUB_TAB_BTN_BE_SELECTED';
	public static TAB_BAR_REFRESH: string = 'TAB_BAR_REFRESH';
	public static OPEN_VIP_VIEW: string = 'OPEN_VIP_VIEW';
	public static OPEN_CHAT_VIEW: string = 'OPEN_CHAT_VIEW';
	public static CLOSE_CHAT_VIEW: string = 'CLOSE_CHAT_VIEW';
	public static OPEN_FRIEND_VIEW: string = 'OPEN_FRIEND_VIEW';
	public static OPEN_PLAYER_MESSAGE_VIEW: string = 'OPEN_PLAYER_MESSAGE_VIEW';
	public static STAGE_CLICK_EVENT: string = 'STAGE_CLICK_EVENT';
	public static OPEN_BOSS_ENTER_VIEW: string = 'OPEN_BOSS_ENTER_VIEW';
	public static UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE =
		'UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE';
	public static UPDATE_BASE_WINDOWS_COMPONENT_EFFECT_STATE =
		'UPDATE_BASE_WINDOWS_COMPONENT_EFFECT_STATE';
	public static UPDATE_RELIVE_INFO: string = 'UPDATE_RELIVE_INFO';
	public static REWARD_FLY: string = 'REWARD_FLY';
	public static OPEN_DIALOGUE_VIEW = 'OPEN_DIALOGUE_VIEW';
	public static CHECK_TO_PLAY_NEXT_DIALOGUE = 'CHECK_TO_PLAY_NEXT_DIALOGUE';
	public static SELECT_STORY_TARGET = 'SELECT_STORY_TARGET'; //选择剧情引导对象
	public static SHOW_FINGER = 'SHOW_FINGER';
	public static HIDE_FINGER = 'HIDE_FINGER';
	public static STORY_SHOW_ALL_FINGER  = 'STORY_SHOW_ALL_FINGER'; //是否隐藏所有的指引
	public static RESTORE_FINGER = 'RESTORE_FINGER';
	public static OPEN_BOSS_SCENE_VIEW: string = 'OPEN_BOSS_SCENE_VIEW';
	public static UPDATE_BOSS_OWNER_MSG: string = 'UPDATE_BOSS_OWNER_MSG';
	public static BOSS_OWNER_SHIP_CHANGE: string = 'BOSS_OWNER_SHIP_CHANGE';
	public static RELIVE_BY_TYPE: string = 'RELIVE_BY_TYPE';
	public static RELIVE_COMPLETE: string = 'RELIVE_COMPLETE';
	public static REQUEST_RELIVE_TIMES: string = 'REQUEST_RELIVE_TIMES';
	public static SWITCH_MAINUIACTIVITY_SECOND_BUTTON: string =
		'SWITCH_MAINUIACTIVITY_SECOND_BUTTON';
	public static OPEN_PRAY_VIEW: string = 'OPEN_PRAY_VIEW';
	public static OPEN_RANK_VIEW: string = 'OPEN_RANK_VIEW';
	public static OPEN_WORLD_BOSS_VIEW: string = 'OPEN_WORLD_BOSS_VIEW';
	public static SWITCH_MOUNT_PET_VIEW: string = 'SWITCH_MOUNT_PET_VIEW';
	public static OPEN_BAG_VIEW: string = 'OPEN_BAG_VIEW';
	public static OPEN_SMELTING_VIEW: string = 'OPEN_SMELTING_VIEW';
	public static OPEN_SHOP_MAIN_VIEW: string = 'OPEN_SHOP_VIEW'; //打开商店界面
	public static OPEN_VIEW: string = 'OPEN_VIEW'; //打开界面
	public static CLOSE_VIEW: string = 'CLOSE_VIEW'; //关闭界面
	public static BASEVIEW_OPEN_OR_CLOSE: string = 'BASEVIEW_OPEN_OR_CLOSE'; //baseview打开/关闭
	public static DELETE_VIEW: string = 'DELETE_VIEW'; //删除界面
	public static UPDATE_REDDOT: string = 'UPDATE_REDDOT'; //刷新红点
	public static OPEN_CALCULATOR_VIEW: string = 'OPEN_CALCULATOR_VIEW'; //数字选择面板
	public static CLOSE_CALCULATOR_VIEW: string = 'CLOSE_CALCULATOR_VIEW'; //关闭数字选择面板
	public static OPEN_WORLDBOSS_VIEW: string = 'OPEN_WORLDBOSS_VIEW';
	public static REFRESH_ACTIVITY_ICON_RED_DOT: string =
		'REFRESH_ACTIVITY_ICON_RED_DOT';
	public static START_TO_COLLECT: string = 'START_TO_COLLECT';
	public static COMPLETE_TO_COLLECT: string = 'COMPLETE_TO_COLLECT';
	public static COLLECT_MONSTER_X_Y: string = 'COLLECT_MONSTER_X_Y';
	public static CANCEL_TO_COLLECT: string = 'CANCEL_TO_COLLECT';
	public static SERVER_CANCEL_TO_COLLECT: string = 'SERVER_CANCEL_TO_COLLECT';
	public static REQUEST_TO_COLLECT: string = 'REQUEST_TO_COLLECT';
	public static TRY_TO_COLLECT: string = 'TRY_REQUEST_TO_COLLECT';
	public static BROADCAST_COLLECT_RESULT: string = 'BROADCAST_COLLECT_RESULT';
	public static OPEN_COLLECT_VIEW: string = 'OPEN_COLLECT_VIEW';
	public static RECEIVE_NEW_CHUANWEN: string = 'RECEIVE_NEW_CHUANWEN';
	public static SHOW_CHUANWEN: string = 'SHOW_CHUANWEN';
	public static UNDER_LINE_CLICK_EVENT: string = 'UNDER_LINE_CLICK_EVENT';
	public static MAIN_ROLE_CHANGE_ATTACK_TARGRT: string =
		'MAIN_ROLE_CHANGE_ATTACK_TARGRT';
	public static OPEN_BULLETIN_VIEW: string = 'OPEN_BULLETIN_VIEW';
	public static OPEN_SEVENDAY_VIEW: string = 'OPEN_SEVENDAY_VIEW';
	public static OPEN_RECHARGE_VIEW: string = 'OPEN_RECHARGE_VIEW';
	public static CONGRATULATION_VIEW_CLOSE: string = 'CONGRATULATION_VIEW_CLOSE';
	public static OPEN_ACT_VIEW: string = 'OPEN_ACT_VIEW';
	public static OPEN_FORESHOW_ICON_VIEW: string = 'OPEN_FORESHOW_ICON_VIEW';
	public static CLOSE_ACT_VIEW: string = 'CLOSE_ACT_VIEW';
	public static OPEN_WELFARE_VIEW: string = 'OPEN_WELFARE_VIEW';
	public static OPEN_WEAPON_RENTAL_VIEW: string = 'OPEN_WEAPON_RENTAL_VIEW';
	public static FLY_TO_ICON: string = 'FLY_TO_ICON';
	public static OPEN_COMPETELIST_ENTER_VIEW: string =
		'OPEN_COMPETELIST_ENTER_VIEW';
	public static FLY_TO_DIAMOND: string = 'FLY_TO_DIAMOND';
	public static EXCHANGEGIFT_ERROR: string = 'EXCHANGEGIFT_ERROR';
	public static OPEN_ITEM_USE_VIEW: string = 'OPEN_ITEM_USE_VIEW';
	public static UPDATE_ROLE_HEAD_ICON: string = 'UPDATE_ROLE_HEAD_ICON';
	public static SET_ROLE_HEAD_ICON: string = 'SET_ROLE_HEAD_ICON';
	public static SELECT_ROLE_HEAD_ICON_SUCCESS: string =
		'SELECT_ROLE_HEAD_ICON_SUCCESS';
	public static GET_ALL_MY_HEAD_ICON: string = 'GET_ALL_MY_HEAD_ICON';
	public static REQUEST_ROLE_PROTO: string = 'REQUEST_ROLE_PROTO';
	public static CAN_USE_THIS_NAME: string = 'CAN_USE_THIS_NAME';
	public static CHANGE_NAME_SUCCESS: string = 'CHANGE_NAME_SUCCESS';
	public static CHECK_ALERT_FRAMERATE: string = 'CHECK_ALERT_FRAMERATE';
	public static OPEN_YOYO_VIEW: string = 'OPEN_YOYO_VIEW';
	public static UPDATE_FIGHT_ENEERGY: string = 'UPDATE_FIGHT_ENEERGY';
	public static UPDATE_MAINUI_BUFF_COUNT: string = 'UPDATE_MAINUI_BUFF_COUNT';
	public static GET_ROLE_FIGURE_INFO_RETURN: string =
		'GET_ROLE_FIGURE_INFO_RETURN';
	public static CHANGE_CUR_VIEW_COUNT: string = 'CHANGE_CUR_VIEW_COUNT';
	public static CLOSE_TIPS_VIEW: string = 'CLOSE_TIPS_VIEW';
	public static OPEN_TIPS_VIEW: string = 'OPEN_TIPS_VIEW';
	public static OPEN_WEEKEND_ACTIVITY_VIEW: string =
		'OPEN_WEEKEND_ACTIVITY_VIEW';
	public static INTERRUPT_CONGRA: string = 'INTERRUPT_CONGRA';
	public static PLAY_DOWN_ICON_ANIMATION: string = 'PLAY_DOWN_ICON_ANIMATION';
	public static OPEN_ATTRIBUTEPOTION_VIEW: string = 'OPEN_ATTRIBUTEPOTION_VIEW';
	public static DELAY_SHOW_FIGHTUP: string = 'DELAY_SHOW_FIGHTUP';
	public static SHOW_EXP_FLY_TO_BOTTOM: string = 'SHOW_EXP_FLY_TO_BOTTOM';
	public static SHOW_MONSTER_DEAP_EXP_FLY_TO_BOTTOM: string =
		'SHOW_MONSTER_DEAP_EXP_FLY_TO_BOTTOM';
	public static OPEN_LOADING_VIEW: string = 'OPEN_LOADING_VIEW';
	public static PRELOAD_LOADING_COMPLETED: string = 'PRELOAD_LOADING_COMPLETED';
	public static LOAD_LOADING_OTHER_RES: string = 'LOAD_LOADING_OTHER_RES';
	public static EGRET_LIFE_CYCLE_CHANGE: string = 'EGRET_LIFE_CYCLE_CHANGE';
	public static EXP_CHANGE_WITHOUT_ANIMATION: string =
		'EXP_CHANGE_WITHOUT_ANIMATION';
	public static OPEN_MAINUI_VIP_TIP: string = 'OPEN_MAINUI_VIP_TIP';
	public static CLOSED_ONE_VIEW: string = 'CLOSED_ONE_VIEW';
	public static CLOSE_FORESHOWICON: string = 'CLOSE_FORESHOWICON';
	public static REFRESH_FORESHOWICON: string = 'REFRESH_FORESHOWICON';
	public static OPEN_STORY_ANIMATION_VIEW: string = 'OPEN_STORY_ANIMATION_VIEW';
	public static SIMULATE_FIGHT_RESULT: string = 'SIMULATE_FIGHT_RESULT';
	public static SNATCHING_OWNERSHIP: string = 'SNATCHING_OWNERSHIP';
	public static CHECK_OWNERSHIP: string = 'CHECK_OWNERSHIP';
	public static CHANGE_FIGHTING_STATE: string = 'CHANGE_FIGHTING_STATE';
	public static OPEN_MAP_VIEW: string = 'OPEN_MAP_VIEW';
	public static CLOSE_MAP_VIEW: string = 'CLOSE_MAP_VIEW';
	public static CONGRA_RARE_VIEW: string = 'CONGRA_RARE_VIEW';
	public static ADD_LIST_ITEM:string ='ADD_LIST_ITEM';
	public static CLOSE_DUNGEON_RESULT_VIEW: string = 'CLOSE_DUNGEON_RESULT_VIEW';
	public static UPDATE_BOSS_DAMAGE_DATA: string = 'UPDATE_BOSS_DAMAGE_DATA';
	public static ADD_BOSS_DAMAGE_DATA: string = 'ADD_BOSS_DAMAGE_DATA';
	public static REMOVE_BOSS_DAMAGE_DATA: string = 'REMOVE_BOSS_DAMAGE_DATA';
	public static UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE: string =
		'UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE';
	public static PLAY_BIG_EFFECT: string = 'PLAY_BIG_EFFECT';
	/**根据骑宠大类id  和幻型id跳转到对应的幻型*/
	public static OPEN_ILLUSION_VIEW: string = 'OPEN_ILLUSION_VIEW';
	public static OPEN_ICON_BOX_VIEW: string = 'OPEN_ICON_BOX_VIEW';
	public static CHECK_ITEM_USE = 'CHECK_ITEM_USE';
	public static MATERIAL_VIEW_CLOSE = 'MATERIAL_VIEW_CLOSE';
	public static CLOSE_ICON_BOX_VIEW = 'CLOSE_ICON_BOX_VIEW';
	public static REFRESH_TEAM_ICON_POS = 'REFRESH_TEAM_ICON_POS';
	public static ALPHA_STATE_CHANGE = 'ALPHA_STATE_CHANGE';
	public static GUIDE_STATE_CHANGE = 'GUIDE_STATE_CHANGE';
	public static OPEN_TOP_VIP_BASE_VIEW = 'OPEN_TOP_VIP_BASE_VIEW';
	public static SET_TREASURE_ICON_EFFECT = 'SET_TREASURE_ICON_EFFECT';
	public static CLICK_EFFECT = 'CLICK_EFFECT';
	public static SHOW_BAOJI_ANI = 'SHOW_BAOJI_ANI';
	public static CLOSE_MOUNTPET_VIEW = 'CLOSE_MOUNTPET_VIEW';
	public static UPDATE_PALYER_INFO: string = 'UPDATE_PALYER_INFO';
	public static HIDE_MAINUI_FIGHT_NUM: string = 'HIDE_MAINUI_FIGHT_NUM';
	public static OPEN_KF_CLOUD_PURCHASE_BASE_VIEW =
		'OPEN_KF_CLOUD_PURCHASE_BASE_VIEW';
	public static UPDATE_TEAM_INVITE_FLAG_POS = 'UPDATE_TEAM_INVITE_FLAG_POS';
	public static START_TO_FIGHT = 'START_TO_FIGHT';
	public static MAIN_ROLE_FIGHT = 'MAIN_ROLE_FIGHT'
	public static OPEN_QUESTIONNAIRE_VIEW = 'OPEN_QUESTIONNAIRE_VIEW';
	public static CHANGE_MAINROLE_CAREER = 'CHANGE_MAINROLE_CAREER';
	public static UPDATE_ASSIST_DATA = 'UPDATE_ASSIST_DATA';
	public static ADD_ASSIST_DATA = 'ADD_ASSIST_DATA';
	public static REMOVE_ASSIST_DATA = 'REMOVE_ASSIST_DATA';
	public static UPDATE_FLAG_DATA = 'UPDATE_FLAG_DATA';
	public static UPDATE_ASSIST_DAMAGE = 'UPDATE_ASSIST_DAMAGE';
	public static LOGIN_LOADING_VIEW_CLOSE = 'LOGIN_LOADING_VIEW_CLOSE';
	public static HIDE_GOD_ICON: string = 'HIDE_GOD_ICON';
	public static SHOW_GREEN_BG: string = 'SHOW_GREEN_BG';
	public static HIDE_OR_SHOW_ALL_UI_CANVAS_LAYER: string =
		'HIDE_OR_SHOW_ALL_UI_CANVAS_LAYER';
	public static UPDATE_OTHER_ROLE_HEAD = 'UPDATE_OTHER_ROLE_HEAD';
	public static OPEN_ROLE_VIEW = 'OPEN_ROLE_VIEW';
	public static STARTAUTOFIGHT = 'STARTAUTOFIGHT';
	public static STOPAUTOFIGHT = 'STOPAUTOFIGHT';
	public static USE_FLY_SHOE = 'USE_FLY_SHOE';
	public static FINDWAY_ENDED = 'FINDWAY_ENDED';
	public static CANCEL_SPEED_BUFF = 'CANCEL_SPEED_BUFF';
	public static STORY_FINISH = 'STORY_FINISH';
	public static STORY_START = 'STORY_START';
	public static CHANGE_ROLE = 'CHANGE_ROLE';

	public static TOOLTIPS_JUMP: any = 'TOOLTIPS_JUMP';
	public static UPDATE_NEWEST_TASK_ID: any = 'UPDATE_NEWEST_TASK_ID'; //更新最新完成的任务id
	public static UPDATE_NEWEST_TASK_ID_NOT_DELAY: any =
		'UPDATE_NEWEST_TASK_ID_NOT_DELAY'; //更新最新完成的任务id 不延迟派发事件
	public static STORY_PLAY_TRIGGER: any = 'STORY_PLAY_TRIGGER';
	public static SEND_TASK_ACCEPT: any = 'SEND_TASK_ACCEPT';
	public static SEND_TASK_FINISH: any = 'SEND_TASK_FINISH';
	public static STOP_AUTO_DO_TASK: any = 'STOP_AUTO_DO_TASK';
	public static SET_MONEY_TYPE: any = 'SET_MONEY_TYPE';
	public static SHOW_EFFECT = 'SHOW_EFFECT';
	public static REFRESH_BATTERY_LEVEL = 'REFRESH_BATTERY_LEVEL';
	public static UPDATE_WORLD_LEVEL_VIEW = 'UPDATE_WORLD_LEVEL_VIEW';
	public static PLAY_MONEYITEM_ANI = 'PLAY_MONEYITEM_ANI';
	public static ACTIVITY_ICON_FINGER = 'ACTIVITY_ICON_FINGER';
	public static CREATE_FINGER_SUCCESS = 'CREATE_FINGER_SUCCESS';
	public static ACTIVITY_ICON_EFFECT = 'ACTIVITY_ICON_EFFECT';
	public static UPDATE_AUTO_FIGHT_STATE = 'UPDATE_AUTO_FIGHT_STATE';
	public static AUTO_FIGHT_TEMP_MODE = 'AUTO_FIGHT_TEMP_MODE'
	public static QUIT_FIGHT_STATE: any = 'QUIT_FIGHT_STATE';
	public static FIND: string = 'FIND';
	public static GAME_SERVER_DISCONNECTED: any = 'GAME_SERVER_DISCONNECTED';
	public static ATTACK_CLICK_MON: any = 'ATTACK_CLICK_MON';
	public static SHOW_BOSS_WAY_PANEL = 'SHOW_BOSS_WAY_PANEL';
	public static SHOW_MAIN_UI_TASK = 'SHOW_MAIN_UI_TASK';
	public static GET_SKILL_SHORTCUT = 'GET_SKILL_SHORTCUT';
	public static ROLEHEAD_UPLOAD_SUCCEED = 'ROLEHEAD_UPLOAD_SUCCEED';
	public static MAINUI_TOP_LOAD_SUCCEED = 'MAINUI_TOP_LOAD_SUCCEED';
	public static DROP_ITEM_BE_CLICK: string = 'DROP_ITEM_BE_CLICK';
	public static DROP_ITEM_CLICK: string = 'DROP_ITEM_CLICK';
	public static HIDE_ALL_NOTIFICATION = 'HIDE_ALL_NOTIFICATION';
	public static SCENELOADVIEWE_CLOSE: string = 'SCENELOADVIEWE_CLOSE';
	public static CANCEL_NEXT_COLLECT: string = 'CANCEL_NEXT_COLLECT';
	public static REDUCE_PLAYER_BLOOD: string = 'REDUCE_PLAYER_BLOOD';
	public static CLOSE_REINCARNATION_ENTER_VIEW: string =
		'CLOSE_REINCARNATION_ENTER_VIEW';
	public static EXCHANGE_BASEWINDOW_BG_HEIGHT: string =
		'EXCHANGE_BASEWINDOW_BG_HEIGHT';
	public static GET_GOODS_VIEW_STOP_ANIMATION: string =
		'GET_GOODS_VIEW_STOP_ANIMATION'; //恭喜获得界面停止播放动画
	public static CHANGE_SUB_VIEW: string = 'CHANGE_SUB_VIEW';
	/**打开祭典 */
	public static OPEN_FESTIVAL_VIEW: string = 'OPEN_FESTIVAL_VIEW';
	/**设置失焦 */
	public static SETTING_INPUT_FOCUS: string = 'SETTING_INPUT_FOCUS';
	public static CLOSE_CONGRATULATION_VIWE:string = "CLOSE_CONGRATULATION_VIWE"
	public static CLOSE_FUNCBOARD: string = 'CLOSE_FUNCBOARD'
	public static SET_TR_ARROW: string = 'SET_TR_ARROW'
	public static UPDATE_BUFF_DATA: string = "UPDATE_BUFF_DATA"
	public static UPDATE_TOP_PLAYER_MAIN_DATA: string = "UPDATE_TOP_PLAYER_MAIN_DATA"
	public static UPDATE_VIEW_STORY_STEP:string = "UPDATE_VIEW_STORY_STEP"
	public static UPDATE_LIVELONG_COUNT:string = "UPDATE_LIVELONG_COUNT"
	public static REQUEST_13088:string = "REQUEST_13088"
	public static REQUEST_10202:string = "REQUEST_10202";
	public static UPDATE_IWY_SVIP_STATE = "UPDATE_IWY_SVIP_STATE"; //爱微游svip验证更新
	public static MINI_GAME_TEST = "MINI_GAME_TEST"; //消消乐测试用
	public static OPEN_SVIP_MAIN_VIEW = "OPEN_SVIP_MAIN_VIEW" //打开svip界面
	public static JUMP_VIEW_TO_CLEAN_BAG: string = 'OPEN_VIEW_TO_CLEAN_BAG';//清理背包跳转
	public static UPDATE_MAINUI_MONEY: string = 'UPDATE_MAINUI_MONEY';//更新主界面货币
	public static UPDATE_TOP_HALO_ICON_RED_STATE: string = 'UPDATE_TOP_HALO_ICON_RED_STATE';//更新主界面光环红点
	public static OPEN_HALO_ICON: string = 'OPEN_HALO_ICON' //跨12点打开主角光环界面图标
}
export class SceneEventType {
	static MAIN_ROLE_MOVE_END: string = 'MAIN_ROLE_MOVE_END';
	static MAIN_ROLE_FLYING: string = 'MAIN_ROLE_FLYING';
	static SAFE_AREA_CHANGE: string = 'SAFE_AREA_CHANGE';
	static REQUEST_SCENE_INFO: string = 'REQUEST_SCENE_INFO';
	static CHANGE_FIND_WAY_STATE: string = 'CHANGE_FIND_WAY_STATE'; //寻路状态改变 注意不是自动挂机状态
	static BROADCAST_CROSS_SCENE: string = 'BROADCAST_CROSS_SCENE';
	static ACTION_TARGET_MISSING: string = 'ACTION_TARGET_MISSING';
	static MOVEREQUEST: string = 'MOVEREQUEST';
	static MAIN_ROLE_MOVE_TO_BLOCK: string = 'MAIN_ROLE_MOVE_TO_BLOCK';
	static CAMERA_MOVE: string = 'CAMERA_MOVE';
	static CHARACTER_DEAD: string = 'CHARACTER_DEAD';
	static DOOR_VO_ADD: string = 'DOOR_VO_ADD';
	static JUMPPOINT_VO_ADD: string = 'JUMPPOINT_VO_ADD';
	static NPC_VO_ADD: string = 'NPC_VO_ADD';
	static ROLE_VO_ADD: string = 'ROLE_VO_ADD';
	static ROLE_VO_REMOVE: string = 'ROLE_VO_REMOVE';
	static MONSTER_VO_ADD: string = 'MONSTER_VO_ADD';
	static MONSTER_VO_REMOVE: string = 'MONSTER_VO_REMOVE';
	static OTHER_VO_ADD: string = 'OTHER_VO_ADD';
	static OTHER_VO_REMOVE: string = 'OTHER_VO_REMOVE';
	static DROP_VO_ADD: string = 'DROP_VO_ADD';
	static DROP_VO_REMOVE: string = 'DROP_VO_REMOVE';
	static NPC_VO_REMOVE: string = 'NPC_VO_REMOVE';
	static DOOR_VO_REMOVE: string = 'DOOR_VO_REMOVE';
	static JUMPPOINT_VO_REMOVE: string = 'JUMPPOINT_VO_REMOVE';
	static OPEN_SCENE_LOAD_VIEW: string = 'OPEN_SCENE_LOAD_VIEW';
	static CREATE_WAY_POINT: string = 'CREATE_WAY_POINT';
	static DELETE_WAY_POINT: string = 'DELETE_WAY_POINT';
	static HIDE_ALL_MONSTER: string = 'HIDE_ALL_MONSTER';
	static SHOW_ALL_MONSTER: string = 'SHOW_ALL_MONSTER';
	static UPDATE_ROLE_LIMIT: string = 'UPDATE_ROLE_LIMIT';
	static REQUEST_CHANGE_SCENE: string = 'REQUEST_CHANGE_SCENE';
	static SCENE_CHANGED: string = 'SCENE_CHANGED';
	static NOTIFY_SERVER_TIME: string = 'NOTIFY_SERVER_TIME';
	static CANCEL_TARGET: string = 'CANCEL_TARGET';
	static BROADCAST_SCENE_DROP_LIST: string = 'BROADCAST_SCENE_DROP_LIST';
	static UIROLE_VO_ADD: string = 'UIROLE_VO_ADD';
	static UIROLE_VO_ADD_SUCCESS: string = 'UIROLE_VO_ADD_SUCCESS';
	static REQUEST_PICK_UP_DROP_LIST: string = 'REQUEST_PICK_UP_DROP_LIST';
	static PICK_UP_DROP: string = 'PICK_UP_DROP';
	static SCENE_PALYER_COUNT: string = 'SCENE_PALYER_COUNT';
	static SCENE_MOVE_END: string = 'SCENE_MOVE_END';
	static UPDATE_KILLER: string = 'UPDATE_KILLER';
	static PET_MONSTER_VO_ADD: string = 'PET_MONSTER_VO_ADD';
	static REQUEST_MONSTER_BUFF: string = 'REQUEST_MONSTER_BUFF';
	static CLICK_SCENE_STOP_MOVE: string = 'CLICK_SCENE_STOP_MOVE';
	static CLOSE_DIALOGUE_VIEW: string = 'CLOSE_DIALOGUE_VIEW';
	static DIALOGUE_VIEW_IS_OPEN: string = 'DIALOGUE_VIEW_IS_OPEN';
	static SHOW_TASK: string = 'SHOW_TASK';
	static DIALOGUE_VIEW_IS_CLOSE: string = 'DIALOGUE_VIEW_IS_CLOSE';
	static AFTER_CLOSE_DIALOGUE_VIEW: string = 'AFTER_CLOSE_DIALOGUE_VIEW';
	static REQUEST_USE_FLY_SHOE_RETURN: string = 'REQUEST_USE_FLY_SHOE_RETURN';
	static REQUEST_USE_FLY_SHOE: string = 'REQUEST_USE_FLY_SHOE';
	static TASK_MUL_JUMP: string = 'TASK_MUL_JUMP';
	static CANCEL_CLICK_TARGET: string = 'CANCEL_CLICK_TARGET';
	static SCENE_REENTER: string = 'SCENE_REENTER';
	static PICK_UP_END: string = 'PICK_UP_END';
	static CAN_NOT_PICK_SCENE_DROP: string = 'CAN_NOT_PICK_SCENE_DROP';
	static START_PICK_SCENE_DROP: string = 'START_PICK_SCENE_DROP';
	static PICK_SCENE_DROP_SUCCESS: string = 'PICK_SCENE_DROP_SUCCESS';
	static DISMISS_SCENE_DROP: string = 'DISMISS_SCENE_DROP';
	static REQUEST_PICK_UP_SCENE_DROP: string = 'REQUEST_PICK_UP_SCENE_DROP';
	static DEAL_WITH_SCENE_DROP_LIST_VO: string = 'DEAL_WITH_SCENE_DROP_LIST_VO';
	static DO_SCENE_DROP_EFFECT: string = 'DO_SCENE_DROP_EFFECT';
	static BLOCK_AREA_CHANGE: string = 'BLOCK_AREA_CHANGE';
	static REQUEST_CHANGE_TO_AWAKEN_SCENE: string =
		'REQUEST_CHANGE_TO_AWAKEN_SCENE';
	static MAIN_ROLE_JUMP: string = 'MAIN_ROLE_JUMP';
	static MAIN_ROLE_JUMP_END: string = 'MAIN_ROLE_JUMP_END';
	static MAIN_ROLE_JUMP_END_IMM: string = 'MAIN_ROLE_JUMP_END_IMM';
	static MAIN_ROLE_FASHION_RES_CHANGE: string = 'MAIN_ROLE_FASHION_RES_CHANGE';
	static MAIN_ROLE_CLOTH_RES_CHANGE: string = 'MAIN_ROLE_CLOTH_RES_CHANGE';
	static FOCRE_UPDATE_SAP: string = "FOCRE_UPDATE_SAP";
	static MAIN_ROLE_PATH_FINISHED:string = "MAIN_ROLE_PATH_FINISHED";
	static MAIN_ROLE_PATH_START:string = "MAIN_ROLE_PATH_START";
	static GRAVE_VO_ADD: string = "GRAVE_VO_ADD" 	//创建怪物墓碑
	static GRAVE_VO_REMOVE: string = "GRAVE_VO_REMOVE" //删除怪物墓碑
}

export class ObjectEventType {
	static REMOVE_SCENE_OBJECT: string = 'REMOVE_SCENE_OBJECT';
	static MONSTER_REALLY_DEAD: string = 'MONSTER_REALLY_DEAD';
	static OBJ_DEADBODY_FADE_END: string = 'OBJ_DEADBODY_FADE_END';
	static OBJ_DEAD: string = 'OBJ_DEAD';
	static MAINROLE_RUSH_END: string = 'MAINROLE_RUSH_END';
	static MAINROLE_MOVE: string = 'MAINROLE_MOVE';
	static MONSTER_MOVE: string = 'MONSTER_MOVE';
	static ROLE_MOVE: string = 'ROLE_MOVE';
	static TALK_BOARD_TIME_OUT: string = 'TALK_BOARD_TIME_OUT';
	static MAIN_ROLE_COLLIDE_MONSTER: string = 'MAIN_ROLE_COLLIDE_MONSTER';
	static MAINROLE_MOVE_EVENT: string = 'MAINROLE_MOVE_EVENT';
	static MAINROLE_MOVE_EVENT_IMME: string = 'MAINROLE_MOVE_EVENT_IMME';
	static MAIN_ROLE_ENTER_NOTSAFE_AREA: string = 'MAIN_ROLE_ENTER_NOTSAFE_AREA';
	static MAIN_ROLE_ENTER_SAFE_AREA: string = 'MAIN_ROLE_ENTER_SAFE_AREA';
	static MAIN_ROLE_ENTER_BLOCK_AREA: string = 'MAIN_ROLE_ENTER_BLOCK_AREA';
	static MAIN_ROLE_ENTER_NOBLOCK_AREA: string = 'MAIN_ROLE_ENTER_NOBLOCK_AREA';
	static MAINROLE_MOVE_RES_LOAD_COMPLETE = 'MAINROLE_MOVE_RES_LOAD_COMPLETE'; //主角衣服加载完成
}

//登陆状态事件
export class LoginStateEvent {
	public static SHOW_LOGIN_BG_FIRST = 'LST.SHOW_LOGIN_BG_FIRST'; // 开始登陆模块
	public static START_LOGIN_MODULE = 'LST.START_LOGIN_MODULE'; // 开始登陆模块
	public static LOGIN_STATE_CHANGE = 'LST.LOGIN_STATE_CHANGE'; // 改变登陆流程状态事件
	public static START_GAME_CONNECT = 'LST.START_GAME_CONNECT'; // 连接游戏服务器
	public static PLAYER_LOGIN_INFO = 'LST.PLAYER_LOGIN_INFO'; // 玩家登陆信息
	public static PLAYER_SERVER_INFO = 'LST.PLAYER_SERVER_INFO'; // 玩家当前选中的服务器的信息
	public static SIMPLIFY_SERVER_INFO = 'LST.SIMPLIFY_SERVER_INFO'; // 精简服务器信息
	public static SERVER_LIST_INFO = 'LST.SERVER_LIST_INFO'; //  大区下的服务器列表
	public static UPDATE_SELECT_SERVER_VIEW = 'LST.UPDATE_SELECT_SERVER_VIEW'; //更新选服界面列表
	public static CHANGE_CUR_SERVER_ID = 'LST.CHANGE_CUR_SERVER_ID'; //改变选中的服务器ID
	public static OPEN_VIEW = 'LST.OPEN_VIEW'; //打开界面
	public static CLOSE_VIEW = 'LST.CLOSE_VIEW'; //关闭界面
	public static TRY_CREATE_ROLE = 'LST.CREATETRY_CREATE_ROLE_ROLE'; //尝试请求创角
	public static TRY_LOGIN_GAME = 'LST.TRY_LOGIN_GAME'; //尝试请求进入游戏
	public static COMFIRN_LOGIN_BTN = 'LST.COMFIRN_LOGIN_BTN'; // 响应登陆按钮
	public static COMFIRM_REGISTER_BTN = 'LST.COMFIRM_REGISTER_BTN'; // 响应注册按钮
	public static REFRESH_LODINGVIEW_LOCK_FLAG =
		'LST.REFRESH_LODINGVIEW_LOCK_FLAG'; //loading锁住状态，用来在loading界面打开的过程中加载需要的资源，
	public static OPEN_ACTIVATION_VIEW = 'LST.OPEN_ACTIVATION_VIEW'; //打开激活码验证界面(暂时没用到)
	public static CLOSE_ACTIVATION_VIEW = 'LST.CLOSE_ACTIVATION_VIEW'; //关闭激活码验证界面(暂时没用到)
	public static CLICK_SDKBG_VIEW = 'CLICK_SDKBG_VIEW'; //点击SDK背景界面
	public static REQUEST_EXIT_GAME = 'REQUEST_EXIT_GAME'; //点击手机退出键触发
	public static PLAY_ROLE_BG_VIEW = 'PLAY_ROLE_BG_VIEW'; //播放角色职业背景动画
	public static FIRST_LOAD_LOGIN_BG = 'FIRST_LOAD_LOGIN_BG'; //	第一次加载登陆背景效果完成回调
	public static ALL_SERVER_LIST_INFO = 'ALL_SERVER_LIST_INFO'; //所有服务器列表
	public static UPDATE_ADER_MODEL_SERVER_VIEW = 'UPDATE_ADER_MODEL_SERVER_VIEW';
	public static SDK_LOGIN_CALL_BACK_SUCCESS = 'SDK_LOGIN_CALL_BACK_SUCCESS'; //登录成功, sdk回调
	public static UPDATE_TEST_SERVER_DATA = 'UPDATE_TEST_SERVER_DATA'; //更新测试服务器数据
	public static AGREE_LOGIN_ALERT = 'AGREE_LOGIN_ALERT'; //同意了速游用户协议
	public static VERIFY_NAME = "VERIFY_NAME"; //验证姓名
	public static UPDATE_VERIFY_NAME_RESULT = "UPDATE_VERIFY_NAME_RESULT"; //更新验证姓名结果
	public static SELECT_SERVER_ITEM = "SELECT_SERVER_ITEM"; //选服Item触发
}
window['SceneEventType'] = SceneEventType;
window['ObjectEventType'] = ObjectEventType;
window['LoginStateEvent'] = LoginStateEvent;

window['EventName'] = EventName;
