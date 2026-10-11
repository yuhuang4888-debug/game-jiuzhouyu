import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "./EventName";
export enum ModuleType {
    SUIT_ONE = 1524,
    SUIT_SEC = 1525,
    SUIT_ONE_POWER = 1526,
    SUIT_SEC_POWER = 1527,
    SUIT_ONE_DOWN = 1528,
    SUIT_SEC_DOWN = 1529,
    GUILD = 400,
    MEDAL = 134,
    MEDAL_STRENGTHEN = 135,
    ONLINE = 41715,
    DAILY = 41703,
    VIPINVEST = 42001,
    MONTHINVSET = 42002,
    SOUL_INLAY = 1701,
    SOUL_UPGRADE = 1702,
    SOUL_REPLACE = 1703,
    SOUL_BAG = 1704,
    SOUL_AWAKE = 1705,
    EQUIP_STREN = 1521,
    EQUIP_SMELT = 1522,
    EQUIP_JEWEL = 1523,
    EQUIP_WASH = 1530,
    SKILL_STREN = 2101,
    BEAST_FIGHT = 1731,
    BEAST_EQUIP = 1732,
    BEAST_STREN = 1733,
    BEAST_REPLACE = 1734,
    CONSTELLATION = 422,
    SECRET_ENCHANT = 1781,
    SECRET_SMELT = 1782,
    SECRET_SKILL = 1783,
    SECRET_SIGN_LV = 1784,
    SECRET_SIGN_STAR = 1785,
    LIGHT_RULING = 139,
    MARRIAGE_GIFT = 1721,
    MARRIAGE_RING = 1722,
    MARRIAGE_ASK = 1723,
    RED_PACKET = 339,
    PEH_EQUIP = 16011,
    PEH_STREN = 16012,
    PEH_STAR = 16013,
    PEP_EQUIP = 16021,
    PEP_STREN = 16022,
    PEP_STAR = 16023,
    TEAM_APPLY = 24003,
    CSPVP_COUNT = 65001,
    CSPVP_HONOUR = 65002,
    CSPVP_OPEN = 65003,
    CSPVP_DAY = 65004,
    CSPVP_APPLY = 65005,
    CSPVP_BET = 65006,
    LUNG_DOT = 181,
    HOR_ILLU_STAR = 160120,
    PAR_ILLU_STAR = 160220,
    PET_ILLU_STAR = 160720,
    GOD_ACTIVE = 4400,
    GOD_LV = 4401,
    GOD_STAGE = 4402,
    GOD_STAR = 4403,
    GOD_EQUIP = 4404,
    GOD_QUICK_COM = 4405,
    BABY_EQUIP_FOR = 18219,
    BABY_EQUIP_IMP = 18220,
    BABY_ILLU_RED = 18206,
    DUNGEON_PET = 61101,
    EQUIP_TREASURE_RED = 41601,
    PEAK_TREASURE_RED = 41602,
    EXTREME_TREASURE_RED = 41603,
    RUNE_TREASURE_RED = 41604,
    JEWEL_CRAVE_RED = 15211,
    REVE_EQUIP_RED = 28600,
    REVE_DEVOUR_RED = 28601,
    REVE_UP_RED = 28602,
    ENTERNITY_RED = 27901,
    GUARD_RED = 216,
    AUCTON = 154,
    SINGLE_RANK = 507,
    DRAGON_WHISPER = 651,
    SPRITE_ROTARY = 509,
    /**1 更好的装备 2 强化 3 分解 4 合成*/
    LONGLANG = 27000,
    SPRITE = 14800,
    StarEquip = 23299,
    CHC_STREN = 23201,
    CHC_EVO = 23202,
    CHC_MAGIC = 23203,
    CHC_SOUL = 23204,
    CHC_STREN_M = 23205,
    CHC_MAGIC_M = 23206,
    REFINEMENT_RED = 15212,
    PARTNER = 142,
    /**祭典 */
    FESTIVAL = 223
}
window["ModuleType"] = ModuleType;
//使用RedDotMgr注意事项：
//1.使用位操作进行红点判断,位操作以32位进行处理,即某个模块红点类型最大为32个
//2.红点类型必须为在0-31范围内(若超过可创建一个新的模块id存放)
//3.在影响红点数据的触发方法里调用SetRedStatus
//4.斟酌多个红点类型是否全部刷新(例:icon的红点需要类型1-7判断)
//5.带Any词语的方法支持红点类型为any
export class RedDotManager {
    private static _instance;
    // private red_cfg;
    // private viewMgr: ViewManager;
    InitEvent;
    SetRedStatus;
    ClearRedStatus;
    GetRedStatus;
    SetAnyRedStatus;
    CheckAnyRedStatus;
    GetAnyRedStatus;
    ClearAnyRedStatus;
    CheckAnyRedStatusMultModule;
    constructor() {
        // this.red_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigRedDot
        // this.viewMgr = ViewManager.GetInstance()
        let _reddot_dic = {};
        let _any_reddot_dic = {}, local_GlobalEventSystem = GlobalEventSystem, update_red_dot_event = EventName.UPDATE_REDDOT;
        this.InitEvent = () => {
            // GlobalEventSystem.Bind(EventName.UPDATE_REDDOT, () => {
            // })
            // GlobalEventSystem.Bind(EventName.INIT_CONFIG, () => {
            //     _reddot_dic = {}
            //     _any_reddot_dic = {}
            // })
        };
        /**
         * @param  {number} mType 模块id
         * @param  {number} rType 红点类型id
         * @param  {boolean} active 红点状态
         */
        this.SetRedStatus = (mType: number, rType: number, active: boolean) => {
            let redbit = this.GetRedStatus(mType);
            if (!redbit)
                redbit = 0;
            redbit = active ? redbit | 1 << rType : redbit & ~(1 << rType);
            _reddot_dic[mType] = redbit;
            local_GlobalEventSystem.Fire(update_red_dot_event, mType, rType);
        };
        /**
         * @param  {number} mType 模块id
         * 清除某个模块的所有红点
         */
        this.ClearRedStatus = (mType: number) => {
            _reddot_dic[mType] = undefined;
        };
        /**
         * @param  {number} mType
         * 获取某个模块的红点数据
         */
        this.GetRedStatus = (mType: number) => {
            return _reddot_dic[mType];
        };
        this.SetAnyRedStatus = (mType: number, key: number, active: boolean) => {
            _any_reddot_dic[mType] = _any_reddot_dic[mType] || {};
            _any_reddot_dic[mType][key] = active;
            local_GlobalEventSystem.Fire(update_red_dot_event, mType, key);
        };
        this.CheckAnyRedStatus = (mType: number, key?: number) => {
            let dic = this.GetAnyRedStatus(mType);
            if (!dic)
                return false;
            if (key) {
                return dic[key];
            }
            else {
                for (let k in dic) {
                    if (dic[k])
                        return true;
                }
            }
            return false;
        };
        this.GetAnyRedStatus = (mType: number) => {
            return _any_reddot_dic[mType];
        };
        this.ClearAnyRedStatus = (mType: number) => {
            _any_reddot_dic[mType] = undefined;
        };
        this.CheckAnyRedStatusMultModule = (modules, key?) => {
            let result = false;
            for (let mType of modules) {
                result = this.CheckAnyRedStatus(mType, key);
                if (result)
                    return true;
            }
            return false;
        };
        this.InitEvent();
    }
    public static GetInstance(): RedDotManager {
        if (!RedDotManager._instance) {
            RedDotManager._instance = new RedDotManager();
        }
        return RedDotManager._instance;
    }
    /**
     * @param  {number[]} 红点类型s
     * 类型转二进制
     */
    public static Type2Bit(...types: number[]) {
        let result;
        for (let type of types) {
            result |= 1 << type;
        }
        return result;
    }

    /**
     * 判断某个模块的某个类型的红点
     * @param  {number} mType 模块id
     * @param  {number} rType? 红点类型id
     */
    CheckRedStatus(mType: number, rType?: number) {
        let redbit = this.GetRedStatus(mType);
        if (!redbit)
            return false;
        let rbit = 1 << rType;
        return rType ? (redbit & rbit) == rbit : redbit > 0;
    };
    /**
     * 判断多个模块的红点    不能判断带有any组合的模块
     * @param modules 模块ids
     * @param rType 红点类型id
     */
    CheckRedStatusMultModule(modules: number[], rType?: number) {
        let result = false;
        for (let mType of modules) {
            result = this.CheckRedStatus(mType, rType);
            if (result)
                return true;
        }
        return false;
    };
    /**
     * @param  {number} mType 模块id
     * @param  {number} typebit? 二进制红点类型,可以传入1<<0 | 1<<1 | 1<<2
     * 判断某个模块的某个类型的红点
     */
    CheckRedStatusMultType(mType: number, typebit?: number) {
        let redbit = this.GetRedStatus(mType);
        if (!redbit)
            return false;
        return typebit ? (redbit & typebit) == typebit : redbit > 0;
    };
}

window["RedDotManager"] = RedDotManager