import { AutoFightManager } from '../autofight/AutoFightManager';
import { CommonManager } from '../common/CommonManager';
import { Config } from '../common/Config';
import { EventName } from '../common/EventName';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { RoleManager } from './RoleManager';
import { Scene } from '../scene/Scene';
import { SceneObj } from '../scene/sceneobj/SceneObj';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventDispatcher } from '../util/EventDispatcher';
import { TimeUtil } from '../util/TimeUtil';
import { LoadLuaConfigAB, Util } from '../util/Util';
import { Vector2 } from '../util/Vector2';
import { EquipModel } from './EquipModel';
import { GoodsModel } from './GoodsModel';
import { GuildActivityModel } from './GuildActivityModel';
import { MainFunc } from './MainUIModel';
import { SceneManager } from '../scene/SceneManager';
import { RedDotController } from '../common/RedDotController';
import { RedKey } from '../common/RedDotDefine';
import { ErlangParser } from '../util/ErlangParser';

type TGuildEvent = typeof GuildEvent[keyof typeof GuildEvent];

export interface IGuildMergeInfo extends ArrayElement<ProtoRecvVObj<40061>['guild_list']> {
    /** 1: 申请界面，
     * 2: 审批界面 */
    tabIndex: number;
    /** 是否是前三公会 */
    isTop: boolean;
}
export interface GuildModel {
    Fire<P extends Proto>(event_id: typeof GuildEvent.REQUEST_PROTO, proto: P, fmt_str?: ProtoSendFmts<P>, ...sendArgs: ProtoSendArgs<P>): void;
    Fire(other_event_id: Exclude<TGuildEvent, typeof GuildEvent.REQUEST_PROTO>, ...args: any): void;
}

export const GuildEvent = {
    REQUEST_PROTO: 'GuildEvent.REQUEST_PROTO',
    REQUEST_40004: 'GuildEvent.REQUEST_40004',
    REQUEST_40006: 'GuildEvent.REQUEST_40006',
    REQUEST_40043: 'GuildEvent.REQUEST_40043',
    REQUEST_40063: 'GuildEvent.REQUEST_40063',
    REQUEST_40102: 'GuildEvent.REQUEST_40102',
    REQUEST_40104: 'GuildEvent.REQUEST_40104',
    REQUEST_40100: 'GuildEvent.REQUEST_40100',
    UPDATE_CLEAN_VIEW: 'UPDATE_CLEAN_VIEW',
    OPEN_VIEW: 'GuildEvent.OPEN_VIEW',
    CLOSE_VIEW: 'GuildEvent.CLOSE_VIEW',
    UPDATE_JION_LIST: 'GuildEvent.UPDATE_JION_LIST',
    UPDATE_APPLY_LIST: 'GuildEvent.UPDATE_APPLY_LIST',
    GET_APPLY_SETTING: 'GuildEvent.GET_APPLY_SETTING',
    APPLY_APPROVE: 'GuildEvent.APPLY_APPROVE',
    UPDATE_SKILLS: 'GuildEvent.UPDATE_SKILLS',
    UPDATE_DONATE: 'GuildEvent.UPDATE_DONATE',
    SELECT_SKILL_ITEM: 'GuildEvent.SELECT_SKILL_ITEM',
    GET_SALARY: 'GuildEvent.GET_SALARY',
    GET_DONATE_AWARD: 'GuildEvent.GET_DONATE_AWARD',
    UPDATE_DONATE_TIMES: 'GuildEvent.UPDATE_DONATE_TIMES',
    UPDATE_DONATE_RED_ONCE: 'GuildEvent.UPDATE_DONATE_RED_ONCE',
    CLOSE_ROLE_MENU_VIEW: 'GuildEvent.CLOSE_ROLE_MENU_VIEW',
    UPDATE_BASE_RED_STATUS: 'GuildEvent.UPDATE_BASE_RED_STATUS',
    UPDATE_SKILL_RED_STATUS: 'GuildEvent.UPDATE_SKILL_RED_STATUS',
    UPDATE_REWARD_BOX_RED: 'GuildEvent.UPDATE_REWARD_BOX_RED',

    EXPOLORE_UDPATE_RECORD: 'GuildEvent.EXPOLORE_UDPATE_RECORD',
    EXPOLORE_UDPATE_FIGHT_TIME: 'GuildEvent.EXPOLORE_UDPATE_FIGHT_TIME',
    EXPOLORE_UDPATE_RESULT: 'GuildEvent.EXPOLORE_UDPATE_RESULT',
    EXPOLORE_GET_BOX: 'GuildEvent.EXPOLORE_GET_BOX',

    DAMAGE_RANK_DATA: 'GuildEvent.DAMAGE_RANK_DATA',
    GUARD_ROUND_DATA: 'GuildEvent.GUARD_ROUND_DATA',
    GUARD_KILL_NUM_CHANGE: 'GuildEvent.GUARD_KILL_NUM_CHANGE',
    GUARD_ACT_INFO: 'GuildEvent.GUARD_ACT_INFO',
    GUARD_EXP_CHANGE: 'GuildEvent.GUARD_EXP_CHANGE',
    OPEN_GUARD_RESULT_VIEW: 'GuildEvent.OPEN_GUARD_RESULT_VIEW',
    GUARD_BE_HIT: 'GuildEvent.GUARD_BE_HIT',
    GUARD_WAVE: 'GuildEvent.GUARD_WAVE',
    REWARD_BOX_DATA_UPDATE: 'GuildEvent.REWARD_BOX_DATA_UPDATE',
    REWARD_BOX_TASK_UPDATE: 'GuildEvent.REWARD_BOX_TASK_UPDATE',

    //声望
    UPDATE_PRESTIGE_DATA: 'GuildEvent.UPD',
    UPDATE_HELP: 'GuildEvent.UPDATE_HELP',
    UPDATE_PRESTIGE: 'GuildEvent.UPDATE_PRESTIGE',

    //武魂
    IDOL_VIEW_INFO: 'GuildEvent.IDOL_VIEW_INFO',
    IDOL_UP: 'GuildEvent.IDOL_UP',
    IDOL_AWAKEN: 'GuildEvent.IDOL_AWAKEN',
    IDOL_RUNE_RETURN: 'GuildEvent.IDOL_RUNE_RETURN',
    IDOL_RUNE_SELECT: 'GuildEvent.IDOL_RUNE_SELECT',
    IDOL_RUNE_DEC_CHANGE: 'GuildEvent.IDOL_RUNE_DEC_CHANGE',
    IDOL_ACT_RED_UPDATE: 'GuildEvent.IDOL_ACT_RED_UPDATE',
    IDOL_AWAKEN_RED_UPDATE: 'GuildEvent.IDOL_AWAKEN_RED_UPDATE',
    IDOL_RUNE_RED_UPDATE: 'GuildEvent.IDOL_RUNE_RED_UPDATE',
    IDOL_TAB_RED_UPDATE: 'GuildEvent.IDOL_TAB_RED_UPDATE',
    IDOL_TAB_ALL_RED_UPDATE: 'GuildEvent.IDOL_TAB_ALL_RED_UPDATE',
    IDOL_RUNE_UP: 'GuildEvent.IDOL_RUNE_UP',
    IDOL_RUNE_LV_ACT: 'GuildEvent.IDOL_RUNE_LV_ACT',
    IDOL_CHANGE_COMBO_ID: 'GuildEvent.IDOL_CHANGE_COMBO_ID',

    //协助
    UPDATE_HELP_LIST: 'GuildEvent.UHL',
    HELP_SUCCESS: 'GuildEvent.HS',
    HAVE_HELP: 'GuildEvent.HAVE_HELP',
    UPDATE_HELP_OBJ: 'GuildEvent.UHO',
    REQ_SUCCESS: 'GuildEvent.REQ_SUCCESS',
    DEL_HELP_DATA: 'GuildEvent.DHD',
    ASSIST_SUCCESS: 'GuildEvent.AS',
    UPDATE_ASSIST_COUNT: 'GuildEvent.UAC',
    CANCEL_HELP_SUCCESS: 'GuildEvent.CHS',
    CHANGED_CONDS_ASSIST: "CHANGED_CONDS_ASSIST", //协助开放条件改变

    UPDATE_APPLY_RED: 'UPDATE_APPLY_RED',
    RENAME_SUCCESS: 'RENAME_SUCCESS',
    UPDATE_RENAME_VIEW: 'UPDATE_RENAME_VIEW',
    UPDATE_MERGE_VIEW: 'UPDATE_MERGE_VIEW',
    /**操作类型 0:请求 1:同意 2:拒绝*/
    MERGE_APPLY: 'MERGE_APPLY',

    /**选择捐献物品 */
    SELECT_DONATE_EQUIP: 'SELECT_DONATE_EQUIP',

    //捐献支线任务引导
    BRANCE_TASK_GUIDE: 'BRANCE_TASK_GUIDE'
} as const;

export const GuildPermission = {
    APPROVE_APPLY: 1, //审批申请
    APPOINT_POS: 2, //任命职位
    FIRE_MEMBER: 3, //开除成员
    MODIFY_TENET_AND_ANNOUNCE: 4, //宣言修改
    OPEN_ACT: 6, //活动开启
    APPROVE_SETTING: 5, //审批设置
    JOIN_ACT: 7, //活动参与
    GUILD_LEVEL_UP: 8, //结社升级
    WAREHOUSE_MANAGER: 9, //仓库管理
    STUDY_SKILL: 10, //技能管理
    SEND_GUILD_MAIL: 11, //邮件群发
    POSITION_SETTING: 12 //职位权限
};

export const GuildDefine = {
    TEXTURE_PATH: 'resource/game/guild/texture/',
    DEPOT_LIMIT: 200, //结社捐献上限
    ACTIVITY_GIFT_COUNT: 5, //结社活跃度奖励个数
    EXPLORE_GIFT_COUNT: 5, //结社副本分数奖励个数
    MAIL_CONTENT_LENGTH: 120, //结社邮件文字限制
    MAX_LAYER: 15, //结社副本层数
    MAX_RELIVE: 3, //结社副本复活次数
    MAX_NOTICE: 2, //结社副本通风报信次数
    DEPOT_LIMIT_COLOR: 6, //捐献装备颜色限制(策划指定写死粉色)
    GUILD_BUILD_LV: 160, //创建结社使用绑钻等级限制
    BOSS_HELP_CD: 20, //结社求助(boss玩法)冷却时间
    LIST_OPEN_DAY_MIN: 1, //结社列表开始天数
    LIST_OPEN_DAY_MAX: 4, //结社列表结束天数
    PRESTIGE: 36255100 //声望货币类型
};

export const GuildOrder = [1, 2, 5, 4, 3];

export const GuildIdolTab = {
    ACT: 1, //激活、升品
    AWAKEN: 2, //觉醒
    RUNE: 3 //铭文
};

/**各个功能协助开启条件 */
export const GuildAssistType = {
    /**世界boss */
    TYPE_FIELD_BOSS: "1@12",
    /**装备副本 */
    TYPE_DUNGEON_EQUIP: "2@5",
    /**龙纹副本 */
    TYPE_DUNGEON_DRAGON: "2@32",
    /**蜃气楼*/
    TYPE_HOLY_BOSS: "1@10",
    /**怨灵封印 灵饰boss*/
    TYPE_DOMAIN_BOSS: "1@17",
    /**斩妖*/
    TYPE_MAIN_LINE_BOSS: "4@1",
    /**众生之门*/
    TYPE_SENTIENT: "2@41",
    /**璀璨之海*/
    TYPE_SEA: "3@1"
};

window['GuildEvent'] = GuildEvent;
window['GuildPermission'] = GuildPermission;
window['GuildDefine'] = GuildDefine;
window['GuildOrder'] = GuildOrder;
window['GuildIdolTab'] = GuildIdolTab;
window['GuildAssistType'] = GuildAssistType;
export class GuildModel extends EventDispatcher {
    private activity = 0;
    private gfunds = 0;
    apply_request_mark = false;
    _apply_red_mark = false;
    boss_mark = false;
    boss_etime = 0;
    //声望
    private _prestige_data: ProtoRecvVObj<40030>;
    private _today_pdata = null;

    //武魂
    idol_view_info = null;
    IdolRune: { [key: number]: ProtoRecvVObj<40502> } = {};
    IdolRune_dec_color_list = [];
    IdolRune_dec_goods_list = [];
    IdolRune_Master_Goods = {
        '3': { color: 3, type_id: 81010031 },
        '4': { color: 4, type_id: 81010041 },
        '5': { color: 5, type_id: 81010051 }
    };
    RunePos = null;
    private idol_Red = [];
    private idol_Act_Item_Red = [];
    private idol_Awake_Item_Red = [];
    private idol_Rune_Item_Red = [];
    rune_max = 6;
    reqIdolRune = false;
    idol_select_tab = GuildIdolTab.ACT - 1;
    select_item = 1;
    last_max_title = 0;
    private idol_combo_id = 0;

    private _help_pdata: ProtoRecvVObj<40405>;
    _assist_data = null;
    private _req_data = null;
    _help_mark = false;

    depot_score = 0;
    private _guardKillNum = 0;

    _exchang_red = false;
    private permission_list_ = null;
    private donate_ = 0;
    private skill_red_ = false;
    private _damageRank_ = null;
    private _roundData_ = [];
    private _guardInfo_ = [];
    private reward_box_red_ = false;

    private guild_info: ProtoRecvVObj<40005>;
    private skill_info: ProtoRecvVObj<40040> = null;
    private donate_info = null;
    private permission_info = null;
    private depot_info: IGuildDepoInfo;
    private _actInfo;
    private _expData;
    _rewardBoxViewData: ProtoRecvVObj<40301>;
    apply_info: ProtoRecvVObj<40008>;
    private explore_info;
    private member_info: ProtoRecvVObj<40006>;
    private notice_info;
    private result_info;
    apply_red;
    private static Instance: GuildModel;
    private equip_model: EquipModel;
    private guild_activity_model: GuildActivityModel;
    private role_mgr: RoleManager;
    private goods_model: GoodsModel;
    private resManager_model: ResManager;
    donateSelectDict: { [key: number]: { goods_id: number; num: number } } = {};

    public constructor() {
        super();
        this.equip_model = EquipModel.GetInstance();
        //let local_Erlang = ErlangParser.GetInstance()
        this.guild_activity_model = GuildActivityModel.GetInstance();
        this.role_mgr = RoleManager.GetInstance();
        this.goods_model = GoodsModel.GetInstance();
        this.resManager_model = ResManager.GetInstance();
    }

    public static GetInstance() {
        if (!GuildModel.Instance) {
            GuildModel.Instance = new GuildModel();
        }
        return GuildModel.Instance;
    }

    InitConfig() {
        //this.const_cfg = local_Config.Guildconstant
    }

    Reset() {
        this.guild_info = null;
        this.member_info = null;
        this.apply_info = null;
        this.skill_info = null;
        this.depot_info = null;
        this.donate_info = null;
        this.permission_info = null;
        this.permission_list_ = [];
        this.donate_ = 0;
        this.depot_score = 0;
        this.activity = 0;
        this.gfunds = 0;
        this.result_info = null;
        this.notice_info = null;
        this.explore_info = null;
        this._rewardBoxViewData = null;
        this.reqIdolRune = false;
        this.exchang_red = false;
        this._guardInfo_ = [];
        this._guardInfo_.concat;
        this.idol_view_info = null
    }

    SetGuildInfo(info?) {
        this.ChangeVar('guild_info', info, false, true);
        this.SetEveningRedDot();
        this.SetSalaryStatus();
        this.SetGiftRedDot()
        this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
    }

    GetGuildInfo() {
        return this.guild_info;
    }

    SetMemberInfo(info?) {
        this.ChangeVar('member_info', info, false, true);
    }

    GetMemberInfo() {
        return this.member_info;
    }

    SetApplyInfo(info?) {
        this.ChangeVar('apply_info', info, false, true);

        //更新红点
        let boo: boolean = false;
        if (info && info.apply_list && info.apply_list.length > 0) {
            boo = true;
        }
        RedDotController.ins.up(RedKey.GUILD_APPLY, boo);
        GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
    }

    GetApplyInfo() {
        return this.apply_info;
    }

    SetSkillInfo(info?, Guildskill?) {
        LoadLuaConfigAB('Guildskillresearch', (cfgs?) => {
            this.ChangeVar('skill_info', info, false, true);
            this.resManager_model.LoadGameConfig(this, 'config_guild_skill_research', false, null, (cfg) => {
                this.RefreshSkillRedDot(cfg, Guildskill);
                this.resManager_model.DestoryGameConfig(this, 'config_guild_skill_research');
            });
        });
    }

    GetSkillInfo() {
        return this.skill_info;
    }

    SetDonate(donate?) {
        this.donate_ = donate;
        this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
    }

    GetDonate() {
        return this.donate_;
    }

    SetDepotScore(score?) {
        this.ChangeVar('depot_score', score, true, true);
        if (!this.depot_info) {
            return;
        }
        this.depot_info.depot_score = score;
    }

    GetDepotScore() {
        return this.depot_score;
    }

    SetDonateInfo(info?) {
        this.ChangeVar('donate_info', info, false, true);
        this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
    }

    GetDonateInfo() {
        return this.donate_info;
    }

    SetActivity(activity?) {
        this.ChangeVar('activity', activity);
    }

    GetActivity() {
        return this.activity;
    }

    SetFunds(gfunds?) {
        this.ChangeVar('gfunds', gfunds);
    }

    GetFunds() {
        return this.gfunds;
    }

    SetPermissionInfo(info?) {
        this.permission_list_ = [];
        for (let _tmpi in info.permission_type_list) {
            let data = info.permission_type_list[_tmpi];
            table.insert(this.permission_list_, data.permission_type);
        }
        this.ChangeVar('permission_info', info, false, true);
    }

    GetPermissionInfo() {
        return this.permission_info;
    }

    SetDepotInfo(info?) {
        for (let _ in info.depot_goods) {
            let v = info.depot_goods[_];
            GoodsModel.GetInstance().SetEquipBaseInfo(v);
        }
        this.ChangeVar('depot_info', info, false, true);
    }

    GetDepotInfo() {
        return this.depot_info;
    }

    GetTopMemberVo(pos?) {
        let guild_info = this.GetGuildInfo();
        if (!guild_info) {
            return;
        }
        for (let _tmpi in guild_info.position_list) {
            let info = guild_info.position_list[_tmpi];
            if (info.position == pos) {
                return info;
            }
        }
    }

    GetGuildKVCfg(index?) {
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_constant;
        return cfg && cfg[index]['val'];
    }

    HasPermission(id?) {
        return this.permission_list_.indexOf(id);
    }

    SetSalaryStatus() {
        let guild_info = this.GetGuildInfo();
        RedDotController.ins.up(RedKey.GUILD_GIFT, guild_info?.salary_status === 0);
        if (!guild_info) {
            return false;
        }
        return (guild_info.salary_status == 1 && true) || false;
    }

    GetDepotScoreCfgByTypeID(type_id?, equip_attr_cfgs?, Guilddepotscore?) {
        if (equip_attr_cfgs && Guilddepotscore) {
            let stage = this.equip_model.GetStageByTypeId(type_id, equip_attr_cfgs);
            let star = this.equip_model.GetStarByTypeId(type_id, equip_attr_cfgs);
            let basic = this.goods_model.GetGoodsBasicByTypeId(type_id);
            // [ts2lua]Guilddepotscore下标访问可能不正确
            return Guilddepotscore[stage + '@' + star + '@' + basic.color];
        }
    }

    SortDepotGoods(list?, goods_cfg?) {
        table.sort(list, (a?, b?) => {
            let adata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, a.type_id, false, goods_cfg);
            let bdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, b.type_id, false, goods_cfg);
            if (bdata && adata && adata.equip_type != bdata.equip_type) {
                return adata.equip_type < bdata.equip_type;
            } else {
                return b.overall_rating < a.overall_rating;
            }
        });
        return list;
    }

    GetDepotLimit(Guilddepotscore?) {
        for (let key in Guilddepotscore) {
            // [ts2lua]Guilddepotscore下标访问可能不正确
            return Guilddepotscore[key];
        }
    }

    CheckDepotOver() {
        let depot_info = this.GetDepotInfo();
        if (!depot_info) {
            return false;
        }
        return depot_info.depot_goods.length >= GuildDefine.DEPOT_LIMIT;
    }

    SetGiftRedDot() {
        let guild_info = this.GetGuildInfo();
        RedDotController.ins.up(RedKey.GUILD_GIFT, guild_info?.salary_status === 0);
        if (!guild_info) {
            return false;
        }
        return guild_info.salary_status == 0;
    }

    CheckSkillRedDotAll() {
        return this.skill_red_;
    }

    RefreshSkillRedDot(guild_skill_research_cfg?, Guildskill?) {
        let skill_bool = false;
        let skill_info = this.GetSkillInfo();
        if (skill_info) {
            for (let _tmpi in skill_info.skill_list) {
                let info = skill_info.skill_list[_tmpi];
                if (this.CheckSkillRedDotOne(info, guild_skill_research_cfg, Guildskill)) {
                    skill_bool = true;
                    break;
                }
            }
        }
        if (skill_bool != this.skill_red_) {
            this.skill_red_ = skill_bool;
            RedDotController.ins.up(RedKey.GUILD_SKILL, skill_bool);
            this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
            this.Fire(GuildEvent.UPDATE_SKILL_RED_STATUS);
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
        }
    }

    CheckSkillRedDotOne(data?, guild_skill_research_cfg?, Guildskill?) {
        let guild_info = this.GetGuildInfo();
        if (!guild_info) {
            return false;
        }
        // [ts2lua]guild_skill_research_cfg下标访问可能不正确
        let next_cfg = guild_skill_research_cfg[data.skill_id + '@' + (data.learn_lv + 1)];
        if (!next_cfg) {
            return false;
        }
        // [ts2lua]Guildskill下标访问可能不正确
        let cur_cfg = Guildskill[data.skill_id];
        let unlock = guild_info.guild_lv >= cur_cfg.unlock_lv;
        if (!unlock) {
            return false;
        }
        let cost_count = JSON.parse(next_cfg.learn_cost)[0][1];
        let own = this.GetDonate();
        return own >= Number(cost_count);
    }

    CheckDonateRedDot() {
        return false;
    }

    CheckActivityRedDot() {
        return false;
    }

    SetEveningRedDot() {
        let red = true;
        if (SceneManager.GetInstance().IsEveningScene()) {
            red = false;
        }

        let act_info = this.guild_activity_model.GetActInfo();
        if (!act_info || act_info.status == 0 || act_info.stage == 0) {
            red = false;
        }
        let cfg = this.guild_activity_model.GetGuildActCfg();
        if (!cfg) {
            red = false;
        } else if (this.role_mgr.GetMainRoleVo().level < Number(cfg[3]['value'])) {
            red = false;
        } else if (this.GetGuildInfo()?.guild_lv < cfg[40]['value']) {
            red = false;
        } else if (this.GetJoinDay() < cfg[41]['value']) {
            red = false;
        }
        RedDotController.ins.up(RedKey.GUILD_EVENING, red);
        return red;
    }

    GetJoinDay() {
        let day = 0;
        let guild_info = this.GetGuildInfo();
        if (!guild_info) {
            return day;
        }
        let rtime = TimeUtil.getServerTime() - guild_info.join_time;
        return Math.floor(rtime / 86400);
    }

    CheckExploreRedDot() {
        return false;
    }

    SetExploreInfo(info?) {
        this.ChangeVar('explore_info', info, false, true);
    }

    GetExploreInfo() {
        return this.explore_info;
    }

    SetResultInfo(info?) {
        this.ChangeVar('result_info', info, false, true);
    }

    GetResultInfo() {
        return this.result_info;
    }

    SetNoticeInfo(info?) {
        this.ChangeVar('notice_info', info, false, true);
    }

    GetNoticeInfo() {
        return this.notice_info;
    }

    GetExploreNameByType(type?, config_guild_dun_type?) {
        let name = '未知';
        let cfg = config_guild_dun_type;
        if (!cfg) {
            return name;
        }
        // [ts2lua]cfg下标访问可能不正确
        return cfg[type].name;
    }

    GetExploreLayerReward(layer?, config_guild_dun_level_reward?) {
        let cfg = config_guild_dun_level_reward;
        if (!cfg) {
            return {};
        }
        let list = [];
        for (let key in cfg) {
            // [ts2lua]cfg下标访问可能不正确
            if (cfg[key].level != layer) {
                break;
            }
            // [ts2lua]cfg下标访问可能不正确
            table.insert(list, cfg[key]);
        }
        //list:sort((a?, b?) => {
        //return a.world_lv - b.world_lv
        //}
        //)
        list.sort((a?, b?) => {
            return a.world_lv - b.world_lv;
        });
        let world_lv = this.role_mgr.GetMainRoleVo().worldLv;
        for (let _tmpi in list) {
            let info = list[_tmpi];
            if (world_lv < info.world_lv) {
                return JSON.parse(info.preview_reward);
            }
        }
        return {};
    }

    GetExploreGiftData(dun_score?, config_guild_dun_score_reward?) {
        let cfg = config_guild_dun_score_reward;
        if (!cfg) {
            return [0, 0, 0];
        }
        let data = null;
        let index = 0;
        for (let key in cfg) {
            // [ts2lua]cfg下标访问可能不正确
            let info = cfg[key];
            let over = info.score > dun_score;
            if (over) {
                // [ts2lua]lua中0和空字符串也是true，此处data需要确认
                return [(data && data.score) || 0, info.score, index];
            }
            data = info;
            index = index + 1;
        }
        return [data.score, data.score + 1, index];
    }

    CanOpenGuildExplore() {
        let role_vo = this.role_mgr.GetMainRoleVo();
        if (role_vo.guild_id <= 0) {
            Message.show('请先加入结社');
            return false;
        }
        let guild_info = this.GetGuildInfo();
        if (!guild_info) {
            return false;
        }
        let guild_lv = this.GetGuildKVCfg(16);
        if (guild_info.guild_lv < guild_lv) {
            Message.show('结社升至' + guild_lv + '级开启结社探索');
            return false;
        }
        let role_lv = this.GetGuildKVCfg(20);
        if (role_vo.level < role_lv) {
            Message.show('人物升至' + role_lv + '才可进入结社探索');
            return false;
        }
        return true;
    }

    OpenGuildView(...new_args) {
        let param = new_args;
        if (GuildModel.IsHasGuild()) {
            this.Fire(GuildEvent.OPEN_VIEW, 'GuildMainBaseView', ...new_args);
        } else {
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
            if (open_day <= GuildDefine.LIST_OPEN_DAY_MAX && open_day >= GuildDefine.LIST_OPEN_DAY_MIN) {
                this.Fire(GuildEvent.OPEN_VIEW, 'GuildListView');
            } else {
                this.Fire(GuildEvent.OPEN_VIEW, 'GuildJoinBaseView', param[0], param[1]);
            }
        }
    }

    setDamageRank(data?) {
        this._damageRank_ = data;
        this.Fire(GuildEvent.DAMAGE_RANK_DATA);
    }

    getDamageRank() {
        return this._damageRank_;
    }

    setRoundData(data?) {
        for (let key in data.wave_list) {
            // [ts2lua]data.wave_list下标访问可能不正确
            let info = data.wave_list[key];
            let str = info.wave_type_args;
            // [ts2lua]tslua无法自动转换正则表达式，请手动处理。
            //let type = str.gsub(/\[\{(.*?),\d+\}\]/ig, '$1')
            // [ts2lua]_roundData_下标访问可能不正确
            this._roundData_['type'] = info;
        }
        this.Fire(GuildEvent.GUARD_ROUND_DATA);
    }

    getRoundData(type?) {
        // [ts2lua]_roundData_下标访问可能不正确
        return this._roundData_[type];
    }

    setGuardInfo(data?) {
        for (let key in data.object_list) {
            // [ts2lua]data.object_list下标访问可能不正确
            let info = data.object_list[key];
            // [ts2lua]_guardInfo_下标访问可能不正确
            this._guardInfo_[info.mon_type_id] = info;
        }
    }

    setGuardInfoByType(data?) {
        if (data) {
            // [ts2lua]_guardInfo_下标访问可能不正确
            this._guardInfo_[data.mon_type_id] = data;
            this.Fire(GuildEvent.GUARD_BE_HIT, data.mon_type_id);
        }
    }

    getGuardInfo() {
        return this._guardInfo_;
    }

    getGuardInfoByType(type_id?) {
        // [ts2lua]_guardInfo_下标访问可能不正确
        return this._guardInfo_[type_id];
    }

    guildguardLive(index?) {
        let kv_cfg = null;
        let towerConfig = JSON.parse(kv_cfg[2].values);
        // [ts2lua]towerConfig下标访问可能不正确
        let tower = towerConfig[index];
        if (tower) {
            let tower_id = tower[0];
            let info = this.getGuardInfoByType(tower_id);
            if (!info || (info && info.hp > 0)) {
                return true;
            }
        }
        return false;
    }

    guildguardReward(config?, round?) {
        let lv = this.role_mgr.GetMainRoleVo().level;
        for (let key in config) {
            // [ts2lua]config下标访问可能不正确
            let reward = config[key];
            if (lv >= reward.lv1 && lv <= reward.lv2 && round == reward.wave_num) {
                return reward.reward;
            }
        }
    }

    SetGuildguardRedDot() {
        let flag = false;
        let info = this.GetactInfo();
        if (info) {
            flag = info.is_end == 0 && info.state == 1;
        }
        RedDotController.ins.up(RedKey.GUILD_GUARD, flag);
        return flag;
    }

    guildguardTime(times?) {
        let timeStr = '';
        let second = Math.floor(times % 60);
        let minute = Math.floor(times / 60);
        if (minute >= 60) {
            times = Math.floor(minute / 60);
            // [ts2lua]lua中0和空字符串也是true，此处times > 9需要确认
            timeStr = timeStr + ((times > 9 && times) || '0' + times);
            timeStr = timeStr + ';';
            minute = minute % 60;
            // [ts2lua]lua中0和空字符串也是true，此处minute > 9需要确认
            timeStr = timeStr + ((minute > 9 && minute) || '0' + minute);
            timeStr = timeStr + ';';
            // [ts2lua]lua中0和空字符串也是true，此处second > 9需要确认
            timeStr = timeStr + ((second > 9 && second) || '0' + second);
        } else {
            timeStr = timeStr + '00;';
            // [ts2lua]lua中0和空字符串也是true，此处minute > 9需要确认
            timeStr = timeStr + ((minute > 9 && minute) || '0' + minute);
            timeStr = timeStr + ';';
            // [ts2lua]lua中0和空字符串也是true，此处second > 9需要确认
            timeStr = timeStr + ((second > 9 && second) || '0' + second);
        }
        return timeStr;
    }

    SetValue(value?) {
        if (value >= 10000 && value < 1000000) {
            value = value / 10000;
            value = value.toFixed(2);
            return value + '万';
        } else if (value >= 1000000 && value < 100000000) {
            value = Math.floor(value);
            return value + '万';
        } else if (value >= 100000000 && value < 10000000000) {
            value = value / 100000000;
            value = value.toFixed(2);
            return value + '亿';
        } else if (value >= 10000000000) {
            value = Math.floor(value);
            return value + '亿';
        } else {
            return value + '';
        }
    }

    setRewardBoxGet(data?) {
        let list = [];
        for (let key in data.send_list) {
            // [ts2lua]data.send_list下标访问可能不正确
            let reward = data.send_list[key];
            if (reward.reward) {
                for (let key1 in reward.reward) {
                    // [ts2lua]reward.reward下标访问可能不正确
                    let info = reward.reward[key1];
                    let obj = [info.style, info.typeId, info.count];
                    table.insert(list, obj);
                }
            }
        }
        Util.ShowCongratulationView(list, 10);
        //success_view_ =  new CongratulationObtainView(list, 10)
        //success_view_:Open()
    }

    updateRewardBox(data?: ProtoRecvVObj<40303>) {
        if (!this._rewardBoxViewData) {
            return;
        }
        for (let send of data.send_list) {
            this._rewardBoxViewData.send_list.unshift(send);
        }
        for (let log of data.log) {
            this._rewardBoxViewData.log.unshift(log);
        }
        this.Fire(GuildEvent.REWARD_BOX_DATA_UPDATE);
    }

    delRewardBox(id?) {
        if (!this._rewardBoxViewData) {
            return;
        }
        let delIndex = this._rewardBoxViewData.send_list.findIndex((send) => send.auto_id == id);
        if (delIndex >= 0) {
            this._rewardBoxViewData.send_list.splice(delIndex, 1);
        }
        this.Fire(GuildEvent.REWARD_BOX_DATA_UPDATE);
    }

    updateRewardBoxTask(data?: ProtoRecvVObj<40305>) {
        if (!this._rewardBoxViewData) {
            return;
        }
        for (let task of data.info) {
            let find = this._rewardBoxViewData.info.some((now_task) => {
                if (now_task.task_id == task.task_id) {
                    now_task.send_num = task.send_num;
                    return true;
                }
                return false;
            });
            if (!find) {
                this._rewardBoxViewData.info.push(task);
            }
        }
        this.Fire(GuildEvent.REWARD_BOX_DATA_UPDATE);
    }

    getBoxTaskNum(id?) {
        return this._rewardBoxViewData?.info.find((now_task) => now_task.task_id == id)?.send_num || 0;
    }

    CheckRewardBoxRed() {
        return this.reward_box_red_;
    }

    RefreshRewardBoxRed() {
        let red = this.rewardBoxRed();
        if (this.reward_box_red_ != red) {
            this.reward_box_red_ = red;
            this.Fire(GuildEvent.UPDATE_REWARD_BOX_RED);
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
        }
        RedDotController.ins.up(RedKey.GUILD_REWARD_BOX, red);
    }

    rewardBoxRed() {
        if (!this._rewardBoxViewData || this._rewardBoxViewData.send_list.length <= 0) {
            return false;
        }
        let now = this._rewardBoxViewData.num;
        let max = this._rewardBoxViewData.max_num;
        if (now >= max) {
            return false;
        }
        return this._rewardBoxViewData.send_list.some((send_info) => send_info.status != 1);
    }

    SetPrestigeData(scmd?) {
        this._prestige_data = scmd;
        this.Fire(GuildEvent.UPDATE_PRESTIGE_DATA, scmd);
    }

    GetPrestigeData() {
        return this._prestige_data;
    }

    SetPrestigetToday(scmd?) {
        this._today_pdata = scmd;
        this.Fire(GuildEvent.UPDATE_PRESTIGE, scmd);
    }

    GetPrestigetToday() {
        return this._today_pdata;
    }

    SetHelpData(scmd?) {
        this._help_pdata = scmd;
        this.Fire(GuildEvent.UPDATE_HELP_LIST, scmd);
    }

    GetHelpData() {
        return this._help_pdata;
    }

    SetAssistData(scmd?) {
        this._assist_data = scmd;
    }

    GetAssistData(need_id?) {
        let target_id = null;
        if (need_id && this._help_pdata && this._assist_data) {
            for (let k in this._help_pdata.assist_list) {
                let v = this._help_pdata.assist_list[k];
                if (v.assist_id == this._assist_data.assist_id) {
                    target_id = v.target_cfg_id;
                    break;
                }
            }
        }
        return this._assist_data, target_id;
    }

    SetReqData(scmd?) {
        this._req_data = scmd;
    }

    GetReqData() {
        return this._req_data;
    }

    /**是否开启了协助功能  全局条件*/
    public IsCanOpenAssist() {
        if (!GuildModel.IsHasGuild()) {
            return false
        }
        let cond_lv = this.GetGuildKVCfg(26);
        let open_day = this.GetGuildKVCfg(28);
        let cur_day = ServerTimeModel.GetInstance().GetOpenServerDay();
        let cur_lv = this.role_mgr.GetMainRoleVo().level;

        return cur_lv >= cond_lv && cur_day >= open_day;
        }


    /***各个功能的协助模块是否可以启用 
     * 
     * @param key GuildAssistType
     */
    public IsOpenAssist(key) {
        if (!GuildModel.IsHasGuild()) {
            return false
    }
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_assist;
        let vo = Config.GetConfigVo(Config.PRELOAD_SERVER_CONFIG.config_guild_assist.name, key, false, cfg)
        let is_open = false //默认是关闭
        if (vo) {
            let cond = JSON.parse(vo.condition)
            let now_open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
            let role_level = this.role_mgr.GetMainRoleVo().level;
            is_open = true
            for (let i = 0; i < cond.length; i++) {
                if (cond[i][0] == "role_lv" && role_level < cond[i][1]) {
                    is_open = false
                    break
                }

                if (cond[i][0] == "open_day" && now_open_day < cond[i][1]) {
                    is_open = false
                    break
                }
            }
        }
        return is_open
    }
    /**各个功能  公会协助开启提示 
     * @param key GuildAssistType
    */
    public GetAssistOpenDesc(key) {
        if (!GuildModel.IsHasGuild()) {
            return "请先加入或创建一个公会~"
        }
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_assist;
        let vo = Config.GetConfigVo(Config.PRELOAD_SERVER_CONFIG.config_guild_assist.name, key, false, cfg)
        let desc = [];
        if (vo) {
            let cond = JSON.parse(vo.condition)
            let len =cond.length
            for (let i = len-1; i >=0; i--) {
                if (cond[i][0] == "role_lv") {
                    desc.push(`${cond[i][1]}级`);
                }
                if (cond[i][0] == "open_day") {
                    desc.push(`开服第${cond[i][1]}天`);
                }
            }
        }
        //例“世界大妖结社协助将在开服第2天且玩家300级时开启~”
        let open_cond_string = desc.join('且')
        let func_name = vo?vo.desc:"该功能"
        let str = `${func_name}结社协助将在${open_cond_string}时开启~`
        return str
    }

    FindWay(x?, y?, call_back?) {
        AutoFightManager.GetInstance().SetAutoFight(false);
        let logic_real_ration = SceneObj.GetLogicRealRatio();
        let tar_pos = new Vector2(x / logic_real_ration.x, y / logic_real_ration.y);
        Scene.GetInstance().MainRoleMove(tar_pos, 2, () => {
            AutoFightManager.GetInstance().SetAutoFight(true);
            if (call_back) {
                call_back();
            }
        });
        Scene.GetInstance().SetClickTarget(null);
    }

    GetGuildLv() {
        let guild_info = this.GetGuildInfo();
        return (guild_info && guild_info.guild_lv) || 0;
    }

    //武魂
    GuildIdolIsOpen() {
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_kv;
        if (!cfg) return false;
        let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
        let limit_day = cfg['open_day']['value'];
        let role_lv = RoleManager.GetInstance().GetMainRoleLevel();
        let limit_lv = cfg['lv_limit']['value'];

        if (open_day >= limit_day && role_lv >= limit_lv) {
            return true;
        }
        return false;
    }

    IdolTabName(id?) {
        let name = '';
        if (id == GuildIdolTab.ACT) {
            name = '升品';
        } else if (id == GuildIdolTab.AWAKEN) {
            name = '觉醒';
        } else if (id == GuildIdolTab.RUNE) {
            name = '铭文';
        }
        return name;
    }

    //武魂页面页签红点
    IdolTabRed(id?, god_id?) {
        let flag = false;
        if (id == GuildIdolTab.ACT) {
            flag = this.actItemRed(god_id);
        } else if (id == GuildIdolTab.AWAKEN) {
            flag = this.awakenItemRed(god_id);
        } else if (id == GuildIdolTab.RUNE) {
            flag = this.runeItemRed(god_id);
        }
        return flag;
    }

    //获取武魂品级
    getIdolLv(god_id?) {
        let lv = 0;
        if (this.idol_view_info) {
            for (let key in this.idol_view_info.god_list) {
                let data = this.idol_view_info.god_list[key];
                if (data.god_id == god_id) {
                    lv = data.color;
                    break;
                }
            }
        }
        return lv;
    }

    getIdolPower(god_id) {
        let power = 0;
        if (this.idol_view_info) {
            for (let key in this.idol_view_info.god_list) {
                let data = this.idol_view_info.god_list[key];
                if (data.god_id == god_id) {
                    power = data.god_power;
                    break;
                }
            }
        }

        return power;
    }

    //武魂升品
    idolUp(data?) {
        if(!this.idol_view_info)return
        for (let key in this.idol_view_info.god_list) {
            let info = this.idol_view_info.god_list[key];
            if (info.god_id == data.god_id) {
                info.color = data.color;
                info.lv = data.lv;
                info.god_power = data.god_power;
                this.Fire(GuildEvent.IDOL_UP, info.color);
                if (data.color == 1) {
                    //激活后请求铭文信息
                    this.Fire(GuildEvent.REQUEST_PROTO, 40502, 'h', data.god_id);
                }
                break;
            }
        }
        this.setActRed();
    }

    //武魂觉醒
    idolAwaken(data?) {
        if(!this.idol_view_info)return
        for (let key in this.idol_view_info.god_list) {
            let info = this.idol_view_info.god_list[key];
            if (info.god_id == data.god_id) {
                info.color = data.color;
                info.lv = data.lv;
                info.god_power = data.god_power;
                this.Fire(GuildEvent.IDOL_AWAKEN, data.lv);
                break;
            }
        }
        this.setAwakenRed();
    }

    //获取武魂觉醒等级
    getIdolAwakenLv(god_id?) {
        if(!this.idol_view_info)return 0
        let lv = 0;
        for (let key in this.idol_view_info.god_list) {
            let data = this.idol_view_info.god_list[key];
            if (data.god_id == god_id) {
                lv = data.lv;
                break;
            }
        }
        return lv;
    }

    //设置铭文信息
    setIdolRune(data?: ProtoRecvVObj<40502>) {
        this.IdolRune[data.god_id] = data;
        if (this.idol_combo_id != data.combo_id) {
            this.idol_combo_id = data.combo_id;
            this.Fire(GuildEvent.IDOL_CHANGE_COMBO_ID);
        }
        this.setRuneRed();
        this.Fire(GuildEvent.IDOL_RUNE_RETURN);
    }

    //获取铭文信息
    getIdolRune(god_id?) {
        return this.IdolRune[god_id];
    }

    //改变铭文分解列表（颜色选择
    changeRuneDecColor(color?, add?) {
        if (add == null) {
            add = true;
        }
        let index = table.find(this.IdolRune_dec_color_list, color);
        if (add && index == -1) {
            table.insert(this.IdolRune_dec_color_list, color);
            this.setRuneDecList(null, color, add);
        }
        if (!add && index != -1) {
            table.remove(this.IdolRune_dec_color_list, index);
            this.setRuneDecList(null, color, add);
        }
    }

    //改变铭文分解列表
    setRuneDecList(goods?, color?, add?) {
        if (add == null) {
            add = true;
        }
        let dic = this.IdolRune_dec_goods_list[color];
        if (goods) {
            if (add) {
                if (!dic) {
                    dic = [];
                    this.IdolRune_dec_goods_list[color] = dic;
                }
                dic[goods.goods_id] = goods;
            } else {
                if (dic[goods.goods_id]) {
                    dic[goods.goods_id] = null;
                }
            }
        } else {
            if (add) {
                let goods_data = this.goods_model.guildRuneList;
                for (let key in goods_data) {
                    let goods = goods_data[key];
                    if (goods.color != color) {
                    } else {
                        if (!dic) {
                            dic = [];
                            this.IdolRune_dec_goods_list[color] = dic;
                        }
                        dic[goods.goods_id] = goods;
                    }
                }
            } else {
                if (this.IdolRune_dec_goods_list[color]) {
                    delete this.IdolRune_dec_goods_list[color];
                    //this.IdolRune_dec_goods_list[color] = null
                }
            }
        }
        this.Fire(GuildEvent.IDOL_RUNE_DEC_CHANGE);
    }

    //获取铭文分解信息
    getRuneDecList() {
        let list = [];
        for (let key in this.IdolRune_dec_goods_list) {
            let goods_dic = this.IdolRune_dec_goods_list[key];
            for (let k in goods_dic) {
                let goods = goods_dic[k];
                table.insert(list, goods);
            }
        }
        return list;
    }

    //检查某铭文是否在分解列表内
    checkRuneDecSelect(goods_id?) {
        let flag = false;
        for (let key in this.IdolRune_dec_goods_list) {
            let goods_dic = this.IdolRune_dec_goods_list[key];
            if (goods_dic[goods_id]) {
                flag = true;
                break;
            }
        }
        return flag;
    }

    //铭文分解可获得
    getRuneDecShow(dec_list?) {
        let dic = [];
        for (let key in dec_list) {
            let goods = dec_list[key];
            let mat_cfg = Config.GetConfigVo('config_goods_decompose', goods.type_id, false);
            if (mat_cfg) {
                let regular_mat = JSON.parse(mat_cfg.regular_mat);
                for (let _tmpi in regular_mat) {
                    let v = regular_mat[_tmpi];
                    let id = Number(v[1]);
                    let num = Number(v[2]);
                    let cur_num = 0;
                    if (dic[id]) {
                        dic[id] = dic[id] + num;
                    } else {
                        dic[id] = num;
                    }
                }
            }
        }
        return dic;
    }

    //铭文大师等级配置
    runeActNeedLv(god_id?, cfg_list?) {
        let lv = 3;
        let isMax = false;
        let attr = 0;
        let lvcfg = null;
        let godData = this.getIdolRune(god_id);
        if (!godData) {
            return [lv, lvcfg, isMax, attr];
        }
        let act_lv = 0;
        for (let key in godData.achievemetn_lvs) {
            let _lv = godData.achievemetn_lvs[key];
            if (act_lv < _lv.achievemetn_lv) {
                act_lv = _lv.achievemetn_lv;
            }
        }
        for (let key in cfg_list) {
            let cfg = cfg_list[key];
            lv = cfg.need_lv;
            lvcfg = cfg;
            attr = attr + Number(lvcfg.attr_skill);
            if (lv > act_lv) {
                break;
            }
        }
        isMax = act_lv == lv;
        return [lv, lvcfg, isMax, attr];
    }

    //检查武魂品级红点
    checkActRed(god_id?, lv?, cost_cfg?) {
        let flag = false;
        let cur_cfg = cost_cfg[god_id + '@' + lv];
        let next_cfg = cost_cfg[god_id + '@' + (lv + 1)];
        if (!cur_cfg || !next_cfg) {
            return flag;
        }
        let cost = JSON.parse(cur_cfg.cost);
        let fullNum = 0;
        let length = 0;
        for (let key in cost) {
            let costInfo = cost[key];
            let type_id, lock;
            [type_id, lock] = this.goods_model.GetMappingTypeId(costInfo[0], costInfo[1]);
            let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id);
            if (goods_vo) {
                let num = Number(costInfo[2]);
                let cur = this.goods_model.GetBagGoodsNum(goods_vo.type_id);
                if (cur >= num) {
                    fullNum = fullNum + 1;
                }
            }
            length = length + 1;
        }
        flag = fullNum >= length;
        return flag;
    }

    //设置武魂品级红点
    async setActRed() {
        if (!this.idol_view_info) {
            return;
        }

        let god_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god
        let guild_god_color =Config.PRELOAD_SERVER_CONFIG.config_guild_god_color
        let flag = false;
        for (let key in god_cfg) {
            let god_info = god_cfg[key];
            let can = this.checkGodCondition(god_info, false);
            if (can) {
                let god_id = god_info.god_id;
                let lv = this.getIdolLv(god_id);
                let show = this.checkActRed(god_id, lv, guild_god_color);
                let lastRed = this.idol_Act_Item_Red[god_id];
                if (lastRed != show) {
                    this.idol_Act_Item_Red[god_id] = show;
                    this.Fire(GuildEvent.IDOL_TAB_RED_UPDATE, god_id);
                }
                if (show && !flag) {
                    flag = true;
                }
            }
        }
        RedDotController.ins.up(RedKey.GUILD_IDOL_ACT, flag);
        if (this.idol_Red[GuildIdolTab.ACT] != flag) {
            this.idol_Red[GuildIdolTab.ACT] = flag;
            this.Fire(GuildEvent.IDOL_ACT_RED_UPDATE);
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        }
    }

    //某武魂的品级红点
    actItemRed(god_id?) {
        return this.idol_Act_Item_Red[god_id];
    }

    //所有武魂的品级红点
    actRed() {
        return this.idol_Red[GuildIdolTab.ACT];
    }

    //检查武魂觉醒红点
    checkAwakenRed(god_id?, awakenLv?, awaken_cfg?) {
        let flag = false;
        let cur_cfg = awaken_cfg[god_id + '@' + awakenLv];
        let next_cfg = awaken_cfg[god_id + '@' + (awakenLv + 1)];
        let lv = this.getIdolLv(god_id);
        if (!cur_cfg || !next_cfg || lv <= 0) {
            return flag;
        }
        let cost = JSON.parse(cur_cfg.cost);
        let fullNum = 0;
        let length = 0;
        for (let key in cost) {
            let costInfo = cost[key];
            let type_id, lock;
            [type_id, lock] = this.goods_model.GetMappingTypeId(costInfo[0], costInfo[1]);
            let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id);
            if (goods_vo) {
                let num = Number(costInfo[2]);
                let cur = this.goods_model.GetBagGoodsNum(goods_vo.type_id);
                if (cur >= num) {
                    fullNum = fullNum + 1;
                }
            }
            length = length + 1;
        }
        flag = fullNum >= length;
        return flag;
    }

    //设置武魂觉醒红点
    async setAwakenRed() {
        let guild_god = Config.PRELOAD_SERVER_CONFIG.config_guild_god
        let guild_god_lv = Config.PRELOAD_SERVER_CONFIG.config_guild_god_lv
        let flag = false;
        for (let key in guild_god) {
            let god_info = guild_god[key];
            let god_id = god_info.god_id;
            let can = this.checkGodCondition(god_info);
            if (can) {
                let awakenLv = this.getIdolAwakenLv(god_id);
                let show = this.checkAwakenRed(god_id, awakenLv, guild_god_lv);
                let lastRed = this.idol_Awake_Item_Red[god_id];
                if (lastRed != show) {
                    this.idol_Awake_Item_Red[god_id] = show;
                    this.Fire(GuildEvent.IDOL_TAB_RED_UPDATE, god_id);
                }
                if (show && !flag) {
                    flag = true;
                }
            }
        }
        RedDotController.ins.up(RedKey.GUILD_IDOL_AWAKEN, flag);
        if (this.idol_Red[GuildIdolTab.AWAKEN] != flag) {
            this.idol_Red[GuildIdolTab.AWAKEN] = flag;
            this.Fire(GuildEvent.IDOL_AWAKEN_RED_UPDATE);
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        }
    }

    //某武魂的觉醒红点
    awakenItemRed(god_id?) {
        return this.idol_Awake_Item_Red[god_id];
    }

    //所有武魂的觉醒红点
    awakenRed() {
        return this.idol_Red[GuildIdolTab.AWAKEN];
    }

    //检查武魂是否满足开启条件
    checkGodCondition(god_cfg?, need_act?) {
        if(!this.idol_view_info){
            return false
        }
        if (need_act == null) {
            need_act = true;
        }
        let can = true;
        let god_id = god_cfg.god_id;
        let con_list = JSON.parse(god_cfg.condition);
        for (let key in con_list) {
            let condition = con_list[key];
            if (condition[0] == 'guild_title_lv') {
                let value = condition[1];
                let guild_title_lv = this.idol_view_info.guild_title_lv;
                if (Number(guild_title_lv) < Number(value)) {
                    can = false;
                    break;
                }
            }
            if (condition[0] == 'role_lv') {
                let value = condition[1];
                let role_lv = RoleManager.GetInstance().GetMainRoleVo().level;
                if (role_lv < Number(value)) {
                    can = false;
                    break;
                }
            }
            if (condition[0] == 'guild_lv') {
                let value = condition[1];
                let guild_lv = this.GetGuildLv();
                if (guild_lv < Number(value)) {
                    can = false;
                    break;
                }
            }
            if (condition[0] == 'open_day') {
                let value = condition[1];
                let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
                if (open_day < Number(value)) {
                    can = false;
                    break;
                }
            }
            //强制需求武魂已经激活
            if (need_act && this.getIdolLv(god_id) <= 0) {
                can = false;
                break;
            }
        }
        return can;
    }

    //请求具体武魂的信息
    reqRuneData() {
        let god_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god;
            for (let key in god_cfg) {
                let god_info = god_cfg[key];
                let god_id = god_info.god_id;
                let can_req = this.checkGodCondition(god_info);
                if (can_req) {
                    //已经激活的才去请求
                    this.Fire(GuildEvent.REQUEST_PROTO, 40502, 'h', god_id);
                }
            }

    }

    //是否有铭文可以镶嵌这个位置
    runeCanPutByPos(god_id?, pos?) {
        let flag = false;
        let runeData = this.IdolRune[god_id];
        if (!runeData) {
            return flag;
        }
        let find = false;
        for (let key in runeData.rune_list) {
            let rune = runeData.rune_list[key];
            if (rune && rune.pos == pos) {
                let data_vo = this.goods_model.GetGoodsBasicByTypeId(rune.goods_type_id);
                for (let key in this.goods_model.guildRuneList) {
                    let bag_rune = this.goods_model.guildRuneList[key];
                    if (bag_rune.type_id > data_vo.type_id) {
                        return true;
                    }
                }
                find = true;
                break;
            }
        }
        if (!find && this.goods_model.guildRuneList.length > 0) {
            return true;
        }
        return flag;
    }

    //是否有铭文可以镶嵌（全部检查
    runeCanPut(god_id?) {
        let flag = false;
        for (let pos = 1; pos <= this.rune_max; pos++) {
            flag = this.runeCanPutByPos(god_id, pos);
            if (flag) {
                return true;
            }
        }
        return flag;
    }

    //是否有铭文可以升级（物品类型
    runeCanUpByTypeId(goods_type_id?, rune_cfg?) {
        if (!rune_cfg) {
            return false;
        }
        let cfg = rune_cfg[Number(goods_type_id)];
        if (!cfg) {
            return false;
        }
        let cost = JSON.parse(cfg.cost);
        let can = true;
        for (let key in cost) {
            let costInfo = cost[key];
            let goods_vo = this.goods_model.GetGoodsBasicByTypeId(costInfo[1]);
            if (goods_vo) {
                let num = Number(costInfo[2]);
                let cur = this.goods_model.GetBagGoodsNum(costInfo[1]);
                if (cur < num) {
                    return false;
                }
            }
        }
        if (can && Util.TableSize(cost) > 0) {
            return true;
        } else {
            return false;
        }
    }

    //是否有铭文可以升级（全部
    runeCanUp(god_id?, rune_cfg?) {
        let flag = false;
        let runeData = this.IdolRune[god_id];
        if (!runeData) {
            return flag;
        }
        for (let key in runeData.rune_list) {
            let runedata = runeData.rune_list[key];
            flag = this.runeCanUpByTypeId(runedata.goods_type_id, rune_cfg);
            if (flag) {
                return true;
            }
        }
        return flag;
    }

    //是否更好的铭文组合（具体id
    runeMasterBetterByComId(god_id?, combo_id?, combo_cfg?) {
        let runeData = this.IdolRune[god_id];
        if (!runeData || runeData.rune_list.length < this.rune_max || combo_id == runeData.combo_id) {
            return false;
        }
        let rune_Color_dic = [];
        let color_num = 0;
        for (let p in runeData.rune_list) {
            let rune = runeData.rune_list[p];
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(rune.goods_type_id);
            if (goods_vo) {
                color_num = rune_Color_dic[goods_vo.color] || 0;
                color_num = (!color_num && 0) || color_num;
                color_num = color_num + 1;
                rune_Color_dic[goods_vo.color] = color_num;
            }
        }
        let full = true;
        let cfg = combo_cfg[god_id + '@' + combo_id];
        let condition_list = JSON.parse(cfg.condition);

        for (let c = condition_list.length - 1; c > -1; c--) {
            let condition = condition_list[c];
            let need_color = Number(condition[0]);
            let need_num = Number(condition[1]);
            for (let color in rune_Color_dic) {
                let num = rune_Color_dic[color];
                if (num > 0 && Number(color) >= need_color) {
                    let fullNum = (need_num > num && num) || need_num;
                    num = num - fullNum;
                    need_num = need_num - fullNum;
                    rune_Color_dic[color] = num;
                }
                if (need_num <= 0) {
                    break;
                }
            }
            if (need_num > 0) {
                full = false;
                break;
            }
        }
        if (full && cfg.combo_id != runeData.combo_id) {
            return true;
        }
        return false;
    }

    //是否有更好的铭文组合（全部
    runeMasterBetter(god_id?, combo_cfg?) {
        let flag = false;
        let runeData = this.IdolRune[god_id];
        if (!runeData || runeData.rune_list.length < this.rune_max) {
            return flag;
        }
        for (let key in combo_cfg) {
            let cfg = combo_cfg[key];
            if (cfg.god_id != god_id || cfg.combo_id <= runeData.combo_id) {
            } else {
                let rune_Color_dic = {};
                for (let p in runeData.rune_list) {
                    let rune = runeData.rune_list[p];
                    let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(rune.goods_type_id);
                    if (goods_vo) {
                        let color_num = rune_Color_dic[goods_vo.color] || 0;
                        color_num = (!color_num && 0) || color_num;
                        color_num = color_num + 1;
                        rune_Color_dic[goods_vo.color] = color_num;
                    }
                }
                let condition_list = JSON.parse(cfg.condition);
                let full = true;

                for (let c = condition_list.length - 1; c > -1; c--) {
                    let condition = condition_list[c];
                    let need_color = Number(condition[0]);
                    let need_num = Number(condition[1]);
                    for (let color in rune_Color_dic) {
                        let num = rune_Color_dic[color];
                        if (num > 0 && Number(color) >= need_color) {
                            let fullNum = (need_num > num && num) || need_num;
                            num = num - fullNum;
                            need_num = need_num - fullNum;
                            rune_Color_dic[color] = num;
                        }
                        if (need_num <= 0) {
                            break;
                        }
                    }
                    if (need_num > 0) {
                        full = false;
                        break;
                    }
                }
                if (full && cfg.combo_id > runeData.combo_id) {
                    return true;
                }
            }
        }
        return flag;
    }

    //铭文大师是否能升级
    runeActCanUp(god_id?, rune_act_cfg?) {
        let flag = false;
        let runeData = this.IdolRune[god_id];
        if (!runeData || runeData.rune_list.length < this.rune_max) {
            return flag;
        }
        let attr_data = [];
        for (let key in rune_act_cfg) {
            let info = rune_act_cfg[key];
            if (info.god_id == god_id) {
                table.insert(attr_data, info);
            }
        }
        table.sort(attr_data, (a?, b?) => {
            return a.need_lv < b.need_lv;
        });
        let need_lv, cfg, isMax;

        [need_lv, cfg, isMax] = this.runeActNeedLv(god_id, attr_data);
        if (isMax) {
            return false;
        }
        let full = true;
        for (let key in runeData.rune_list) {
            let rune = runeData.rune_list[key];
            let str = String(rune.goods_type_id);

            // let lv = Number(string.sub(str, -1))
            let lv = Number(str.charAt(str.length - 1));
            lv = (lv == 0 && 10) || lv;
            if (lv < need_lv) {
                full = false;
                break;
            }
        }
        if (full) {
            return true;
        }
        return flag;
    }

    //设置铭文红点
    async setRuneRed() {
        if (!this.idol_view_info) {
            return;
        }
        let god_cfg  = Config.PRELOAD_SERVER_CONFIG.config_guild_god;
        let rune_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune
        let combo_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_combo
        let rune_act_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_achievement
        let flag = false;
        if (CommonManager.GetInstance().CheckFuncOpenState('GuildIdolMainRune',true)) {
            for (let key in god_cfg) {
                let god_info = god_cfg[key];
                let god_id = god_info.god_id;
                let can = this.checkGodCondition(god_info);
                if (can) {
                    let show = this.runeCanPut(god_id) || this.runeCanUp(god_id, rune_cfg) || this.runeMasterBetter(god_id, combo_cfg) || this.runeActCanUp(god_id, rune_act_cfg);

                    let lv = this.getIdolLv(god_id);
                    show = show && lv > 0;
                    let lastRed = this.idol_Rune_Item_Red[god_id];
                    if (lastRed != show) {
                        this.idol_Rune_Item_Red[god_id] = show;
                        this.Fire(GuildEvent.IDOL_TAB_RED_UPDATE, god_id);
                    }
                    if (show && !flag) {
                        flag = true;
                    }
                }
            }
        }
        RedDotController.ins.up(RedKey.GUILD_IDOL_RUNE, flag);
        if (this.idol_Red[GuildIdolTab.RUNE] != flag) {
            this.idol_Red[GuildIdolTab.RUNE] = flag;
            this.Fire(GuildEvent.IDOL_RUNE_RED_UPDATE);
            GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        }
    }

    //某武魂的铭文红点
    runeItemRed(god_id?) {
        return this.idol_Rune_Item_Red[god_id] && CommonManager.GetInstance().CheckFuncOpenState('GuildIdolMainRune');
    }

    //所有武魂的铭文红点
    runeRed() {
        return this.idol_Red[GuildIdolTab.RUNE] && CommonManager.GetInstance().CheckFuncOpenState('GuildIdolMainRune');
    }

    //所有武魂的红点
    guildIdolRed() {
        return this.actRed() || this.awakenRed() || this.runeRed();
    }

    //获取结社头衔
    GetTitleId() {
        let pdata = this.GetPrestigeData();
        return (pdata && pdata.title_id) || 0;
    }

    //检查是否要弹出有新协助提示窗
    CheckHelpTips(scmd?) {
        let can_assist = this.IsCanOpenAssist();
        for (let _tmpi in scmd.assist_list) {
            let vo = scmd.assist_list[_tmpi];
            let con;
            if (vo.is_assist == 0 && !vo.is_open) {
                if ((vo.type == 1 || vo.type == 2) && !can_assist) {
                    //1 2类型协助，未达到等级要求
                    con = true;
                }
                if (!con&&RoleManager.GetInstance().GetMainRoleId() != vo.role_id) {
                    this.Fire(GuildEvent.HAVE_HELP, true);
                    return;
                }
            }
        }
        this.Fire(GuildEvent.HAVE_HELP, false);
    }

    /***公会仓库可捐赠装备 */
    public GetShowEquips() {
        let limit = { stage: 4, star: 1, color: 3, max_color: 7, score_plus: 23662, score_cost: 23662 }; // model.GetDepotLimit(Guilddepotscore)
        let equips = this.goods_model.bag_goods_list;
        let emodel = EquipModel.GetInstance();
        let list = [];
        for (let info of equips) {
            if (info.bind != 0 || info.type != 10) continue;
            let { star, stage } = emodel.GetEquipData(info.type_id);
            if (stage < limit.stage || star < limit.star) continue;
            if (info.color < limit.color || info.color >= limit.max_color) continue;
            if (info.color == GuildDefine.DEPOT_LIMIT_COLOR) continue;
            list.push(Object.assign(info, { is_depot_select: true }));
        }
        return list;
    }
    public static IsHasGuild() {
        let role_vo = RoleManager.GetInstance().GetMainRoleVo();
        return role_vo.guild_id > 0;
    }

    /**是否是结社会长 */
    public static IsGuildMaster() {
        let role_vo = RoleManager.GetInstance().GetMainRoleVo();
        return role_vo.position == 1;
    }
    /**是否是结社副会长 */
    public static IsGuildViceMaster() {
        let role_vo = RoleManager.GetInstance().GetMainRoleVo();
        return role_vo.position == 2;
    }

    public static IsMergeOpen() {
        let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
        return open_day >= GuildModel.GetInstance().GetGuildKVCfg(29);
    }

    public static ComparePosition(other_pos) {
        return RoleManager.GetInstance().GetMainRoleVo().position <= other_pos;
    }

    public SetguardKillNum(value?) {
        if (this._guardKillNum != value) {
            this._guardKillNum = value;
            this.Fire(GuildEvent.GUARD_KILL_NUM_CHANGE);
        }
    }

    public GetguardKillNum() {
        return this._guardKillNum;
    }

    public SetactInfo(data?) {
        this._actInfo = data;
        this.SetGuildguardRedDot();
        this.Fire(GuildEvent.GUARD_ACT_INFO);
        this.Fire(GuildEvent.UPDATE_BASE_RED_STATUS);
        GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
    }

    public GetactInfo() {
        return this._actInfo;
    }

    public SetexpData(value?) {
        this._expData = value;
        this.Fire(GuildEvent.GUARD_EXP_CHANGE);
    }

    public GetexpData() {
        return this._expData;
    }

    //仓库换装备红点
    public CheckExchangeRed() {
        if (!this.depot_info) {
            return;
        }
        ResManager.GetInstance().LoadGameConfig(this, 'config_guild_depot_score', false, null, (guild_depot_score) => {
            let list = this.depot_info.depot_goods;
            let { sex, turn } = RoleManager.GetInstance().GetMainRoleVo();
            let level = RoleManager.GetInstance().GetMainRoleLevel();
            let career = RoleManager.GetInstance().GetMainRoleCareer();
            let score = this.depot_info.depot_score;
            let red = false;
            /**         这里的v没有sex、turn、level和career_id属性，所以red只会是false */
            if (list && list.length > 0) {
                for (let _ in list) {
                    let v = list[_];
                    if ((v.sex == 0 || sex == v.sex) && turn >= v.turn && level >= v.level && (v.career_id == 0 || career == v.career_id)) {
                        let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(v.equip_type);
                        if ((!wear_equip_info || v.rating > wear_equip_info.rating) && v.star) {
                            let score_cfg = guild_depot_score[v.stage + '@' + v.star + '@' + v.color];
                            if (score_cfg && score >= score_cfg.score_cost) {
                                red = true;
                                break;
                            }
                        }
                    }
                }
            }
            let same = this.exchang_red == red;
            this.exchang_red = red;
            
            if (!same) {
                GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild);
            }
            ResManager.GetInstance().DestoryGameConfig(this, 'config_guild_depot_score');
        });
    }

    public get apply_red_mark() {
        return this._apply_red_mark;
    }
    public set apply_red_mark(value) {
        this._apply_red_mark = value;
        RedDotController.ins.up(RedKey.GUILD_APPLY_MARK, value);
    }
    /**加入公会 提示红点 */
    public CheckApplyRedMask(){
        this.apply_red_mark = !GuildModel.IsHasGuild() &&  CommonManager.GetInstance().CheckFuncOpenState('GuildJoinBaseView', true)
    }
    public get exchang_red(): boolean {
        return this._exchang_red;
    }

    public set exchang_red(v: boolean) {
        this._exchang_red = v;
        RedDotController.ins.up(RedKey.GUILD_EXCHANGE, v);
    }
}

window['GuildModel'] = GuildModel;
