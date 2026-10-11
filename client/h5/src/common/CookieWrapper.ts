
export class CookieWrapper {
    static LAST_ACCOUNT_DATA = "LAST_ACCOUNT_DATA";
    static LOGIN_USER_NAME = "LOGIN_USER_NAME";
    static REMEMBER_PASSWORD = 'REMEMBER_PASSWORD';
    static LOGIN_USER_PASSWORD = "LOGIN_USER_PASSWORD";
    static SERVER_LIST_LIST = "SERVER_LIST_LIST";
    static SERVER_LIST_MD5_LIST = "SERVER_LIST_MD5_LIST";
    static VIP_INVEST_RED_TIME = "VIP_INVEST_RED_TIME";
    static MONTH_INVEST_RED_TIME = "MONTH_INVEST_RED_TIME";
    static GUILD_FIGHT_ACT_RED_TIME = "GUILD_FIGHT_ACT_RED_TIME";
    static ACCOUNT_HISTORY = "ACCOUNT_HISTORY";
    static GAME_MAIN_VERSION = "GAME_MAIN_VERSION";
    static LAST_LOGIN_DATE = "LAST_LOGIN_DATE";
    static LAST_NOTICE_POP_DATA = "LAST_NOTICE_POP_DATA";
    static VIP_INVALID_VIEW_SHOW_TIME = "VIP_INVALID_VIEW_SHOW_TIME";
    static MARRIAGE_TAG_LIST_STR = "MARRIAGE_TAG_LIST_STR";
    static HOLY_SEAL_DECOMPOSE_INFO = "HOLY_SEAL_AUTO_DECOMPOSE";
    static BAG_SMELT_STATE = "BAG_SMELT_STATE";
    static BEAST_COM_ID = "BEAST_COM_ID";
    static SOUL_BOSS_COUNT = "SOUL_BOSS_COUNT";
    static EQUIP_WASH_LOCK_LIST = "EQUIP_WASH_LOCK_LIST";
    static SUPER_VIP_RED = "SUPER_VIP_RED";
    static BLOCK_HAS_INIT = "BLOCK_HAS_INIT"; //屏蔽设置是否有初始化过
    static BLOCK_SETTING = "BLOCK_SETTING";			//屏蔽设置
    static CONTROL_SETTING	= "CONTROL_SETTING";			//操作设置
	static SOUND_SETTING	= "SOUND_SETTING";			//声音设置
    static BLOCK_HAVE_SET_SETTING	= "BLOCK_HAVE_SET_SETTING";		//某屏蔽是否认为设置过
    static SYSTEM_SETTING = "SYSTEM_SETTING";        							//系统设置
    static LIMIT_LEVEL_SHOP_RED = "LIMIT_LEVEL_SHOP_RED";
    /**龙语分解信息*/
    static LONGLANG_DEC_INFO = "LONGLANG_DEC_INFO";
    /**公告版本号 */
    static NOTICE_VERSION = "NOTICE_VERSION";
     /**公告版本号 是否弹出过公告 */
    static POP_NOTICE_VERSION = "POP_NOTICE_VERSION";
    static STAR_EQUIP_INFO = "STAR_EQUIP";
    static GODCOURT_BAG_INFO = "GODCOURT_BAG_INFO";
    static CONVOY_FIND = "CONVOY_FIND";
    static BASE_LOCATION_CACHE = "BASE_LOCATION_CACHE";
    static ACT_LUCKY_DUBAO_LIMIT_BUY = "ACT_LUCKY_DUBAO_LIMIT_BUY";
    static SHOW_PRIVAC_VIEW_STATE = "SHOW_PRIVAC_VIEW_STATE";

    static AUTO_FIGHT_STATE = "AUTO_FIGHT_STATE"
    static AUTO_FIGHT_ATTACK_FIRST_STATE = "AUTO_FIGHT_ATTACK_FIRST_STATE"
    static AUTO_FIAGHT_SKILL_LIST = "AUTO_FIAGHT_SKILL_LIST"

    static PARTNER_AUTO_STATUS = "PARTNER_AUTO_STATUS"
    static LAST_LOGIN_ROLE_ID = "LAST_LOGIN_ROLE_ID"

    static LOCAL_ACCOUNT_INFO = "CW.LOCAL_ACCOUNT_INFO"

    static CHECK_DAILY_TASK_RED_TIME = "CW.CHECK_DAILY_TASK_RED_TIME"
    //神殿觉醒 领取登录气泡
    static TEMPLE_AWAKEN_POP_BOARD = "TEMPLE_AWAKEN_POP_BOARD"
    //海域玩法介绍页面
    static SEA_FIGHT_INSTRUCTION = "SEA_FIGHT_INSTRUCTION"

    static HT_LOGIN_STATE = "HT_LOGIN_STATE"

    static GUILD_MERGE_GUIDE = "GUILD_MERGE_GUIDE"


    static LOCAL_DEVICE_ID = "LOCAL_DEVICE_ID"
    static COOKIE_GUILD_SHOP_RED_1 = "COOKIE_GUILD_SHOP_RED_1"//善缘商店红点
    static COOKIE_GUILD_SHOP_RED_2 = "COOKIE_GUILD_SHOP_RED_2"//武魂商店红点
    static SUPER_GIFT_CHECK = "SUPER_GIFT_CHECK"
    static COOKIE_GHOST_WALK_RED = "COOKIE_GHOST_WALK_RED"//百鬼夜行红点
    static CACHE_BASE_SERVER_ID = "CACHE_BASE_SERVER_ID"
    static INSIDE_NOTIVE_RED ="INSIDE_NOTIVE_RED"
    /**培养等级红点开关 */
    static OUTWARD_LV_RED_OPEN_STATE = "OUT_WARD_RED_OPEN_STATE"

    /**光环开启红点 */
    static HALO_RED_OPEN_STATE = "HALO_RED_OPEN_STATE"

    static ACCOUNT_FIRST_CHAT = "ACCOUNT_FIRST_CHAT"

    static LOCAL_POP_MIN_GAME = "LOCAL_POP_MIN_GAME"


    static Instance: CookieWrapper;
    main_role_id;
    InitInfo;
    SaveCookie: (key: string, value: string | number, is_save_with_main_role_id?: boolean) => void;
    GetCookie: (key: string, is_save_with_main_role_id?: boolean) => string;
    RemoveCookie;
    ClearAll;
    // 时间类型
    CookieTimeType = {
        TYPE_DAY : 1,
        TYPE_ALWAYS : 2,
    }
    public static GetInstance() {
        if (!CookieWrapper.Instance) {
            CookieWrapper.Instance = new CookieWrapper();
        }
        return CookieWrapper.Instance;
    }
    public constructor() {
        let local_egret_localStorage = Laya.LocalStorage;
        let has_localStorage = !!Laya.LocalStorage;
        this.InitInfo = (id) => {
            this.main_role_id = id;
        };
        this.SaveCookie = (key: string, value: string | number, is_save_with_main_role_id: boolean = true) => {
            if (has_localStorage) {
                if (this.main_role_id && is_save_with_main_role_id) {
                    local_egret_localStorage.setItem(`${this.main_role_id}_${key}`, `${value}`);
                }
                else {
                    local_egret_localStorage.setItem(key, `${value}`);
                }
            }
        };
        this.GetCookie = (key: string, is_save_with_main_role_id: boolean = true) => {
            if (has_localStorage) {
                if (this.main_role_id && is_save_with_main_role_id) {
                    return local_egret_localStorage.getItem(`${this.main_role_id}_${key}`);
                }
                else {
                    return local_egret_localStorage.getItem(key);
                }
            }
        };
        this.RemoveCookie = (key: string, is_save_with_main_role_id: boolean = true) => {
            if (has_localStorage) {
                if (this.main_role_id && is_save_with_main_role_id) {
                    return local_egret_localStorage.removeItem(`${this.main_role_id}_${key}`);
                }
                else {
                    local_egret_localStorage.removeItem(key);
                }
            }
        };
        this.ClearAll = () => {
            if (has_localStorage) {
                local_egret_localStorage.clear();
            }
        };
    }
}

window["CookieWrapper"] = CookieWrapper