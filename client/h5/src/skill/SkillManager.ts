import { EventDispatcher } from "../util/EventDispatcher";
import { Config } from "../common/Config";
import { RoleManager } from "../commonModel/RoleManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { SkillVo } from "./SkillVo";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { FightEvent } from "../scene/fight/FightEvent";
import { Scene } from "../scene/Scene";
import { PoseState } from "../util/StateMachineManager";
import { Message } from "../sysInfo/SysInfoController";
import { Status } from "../util/Status";
import { ErlangParser } from "../util/ErlangParser";
import { EventName } from "../common/EventName";
import { table } from "../common/table";
import { SceneManager } from "../scene/SceneManager";
import { AutoFightManager } from "../autofight/AutoFightManager";
import { GodBefallModel } from "../commonModel/GodBefallModel";
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel";
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel";
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel";
// import { GodBefallModel } from "../commonModel/GodBefallModel";



export class SkillManager extends EventDispatcher {

    static REQUEST_CCMD_EVENT = "REQUEST_CCMD_EVENT";

    //策划约定的技能id规则 职业id + 01普攻/02技能 + 技能id（两位） + 0主技能/1副技能
    static BaseAttackSkills = {
        ["1@1"]: [101010, 101020, 101030, 101040],
        ["2@2"]: [201010, 201020, 201030, 201040],
        ["3@1"]: [301010, 301020, 301030, 301040],
        ["4@2"]: [401010, 401020, 401030, 401040],

    };
    static ThreeAttackSkillInfo = {
        [101010]: 4, [101020]: 4, [101030]: 4, [101040]: 4,
        [201010]: 4, [201020]: 4, [201030]: 4, [201040]: 4,
        [301010]: 4, [301020]: 4, [301030]: 4, [301040]: 4,
        [401010]: 4, [401020]: 4, [401030]: 4, [401040]: 4,
    };
    static MonsterBaseSkill = 900101;
    static AngerValue = 150; //怒气值
    static SkillCacheTime = 0.4; //技能缓存时间
    //技能攻击类型  1只发起攻击（默认）  2只显示技能范围ui  3.两者都有
    static SKILL_ATTACK_TYPE = {
        ONLY_FIRE_ATTACK: 1,
        ONLY_SHOW_RANGE: 2,
        ATTACK_AND_RANGE: 3,
    };
    public static UPDATE_SKILL_LIST = "UPDATE_SKILL_LIST";
    public static LEVEL_UP_SUCCESS = "LEVEL_UP_SUCCESS";
    public static UPDATE_SKILL_BAR_INFO = "UPDATE_SKILL_BAR_INFO";
    public static SHORT_CUT_SKILL_ACTIVE = "SHORT_CUT_SKILL_ACTIVE";
    public static START_SKILL_CD = "START_SKILL_CD"
    public static LOCK_CD = "LOCK_CD"
    public static REFRESH_CD = "REFRESH_CD"

    public static Instance: SkillManager;
    public mySkillList = {};
    public cd_skill_list = {}
    public $test: boolean = false;
    public auto_fight_index = 0;
    public auto_fight_order = { "1": [100101, 100201, 100301, 100401, 100501, 100601], "2": [200101, 200201, 200301, 200401, 200501, 200601] };
    public skill_bar_info; //技能快捷栏信息
    InitConfig;
    IncreaseAutoFightIndex;
    PrepareAutoFightSkill;
    CanAttack;
    CreateSkillList;
    AddReleaseMainSkill;
    GetReleaseMainSkill;
    ResetThreeAttackIndex;
    IsMonsterBaseSkill;
    isMainSkill;
    GetBaseSkill;
    ResetSkill;
    SetCacheResetSkillId;
    CurrBaseSkillLen;
    IncreaseThreeAttackIndex;
    getThreeAttackIndex;
    IsThreeAttackSkill;
    Update;
    setCurrentSkillId;
    UpdateAttackDistance;
    GetCurrentAttackRange;
    getCurrentSkillId;
    getCurrentSkill;
    getSkillFromConfig;
    GetFightSkillMovie;
    getSkill;
    PackageMainSkillId;
    ParseComboSkill;
    GetShowPassitiveSkillList;
    SetUnlockSkillList;
    SetUnlockSkillListForce;
    GetUnlockSkillList;
    GetSkillStrenHurt;
    GetSkillFromConfigByIdAndLevelAndPower;
    GetGodSkillList;
    GetBarInfoByPos;
    GetBarInfoBySkillId;
    ThisSkillHadInSkillBar;

    CheckShortCutSkillOpenState: () => void;
    replaceSkillList: any = {};
    UpdateShortCutList: () => void;
    GetShortCutList: (is_base?: any) => any[];
    IsSkillHasUse: (id?: any) => any;
    skillUseList: any;
    SetHitSkillVo: (vo?: any) => void;
    GetHitSkillVo: () => any;
    AddSkillToSkillList: any;


    PopCachedSkill
    ClearCachedSkill
    AddCacheSkill
    ClearAllSkillCD
    ClearSkillCD
    LockCD
    AddCDItem
    RemoveCdItem
    IsCanUseHitSkill
    SetCanUseHitSkill


    shortcutList = []
    cache_skill_lv_dic: any;
    cached_skill_id
    cache_skill_time
    cache_secs
    can_use_hit_skill
    partner_skill_rigidity
    skill_rigidity
    joy_stick_dir
    public constructor() {
        super();
        let PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG,
            role_mgr = RoleManager.GetInstance(),
            user_msg_adapter = UserMsgAdapter.GetInstance(),
            local_SkillManager = SkillManager,
            combo_skill_parse_list_: { [key: number]: Array<any>; } = {},
            otherSkillList_: { [key: number]: SkillVo; } = {},
            currentSkillId_,
            currentSkillVo_,
            currentAttackRange_,
            release_main_skill_time_list_ = {},
            three_attack_index_ = 1,
            unlock_skill_list_: Array<number>,
            god_skill_list_: Array<number>,
            cacheReset_skillId_,
            config_skill_,
            ConfigCareerSkillMovies_,
            ConfigMonsterSkillMovies_,
            ConfigPartnerFightMovies_,
            ConfigGodFightMovies_

        this.InitConfig = () => {
            config_skill_ = Config.PRELOAD_SERVER_CONFIG.config_skill;
            ConfigCareerSkillMovies_ = PRELOAD_CLIENT_CONFIG.ConfigCareerSkillMovies;
            ConfigMonsterSkillMovies_ = PRELOAD_CLIENT_CONFIG.ConfigMonsterSkillMovies;
            ConfigPartnerFightMovies_ = PRELOAD_CLIENT_CONFIG.ConfigPartnerFightMovies
            ConfigGodFightMovies_ = PRELOAD_CLIENT_CONFIG.ConfigGodSkillMovies
        };
        this.IncreaseAutoFightIndex = () => {
            let skill_list = role_mgr.mainRoleInfo.god_id > 0 ? god_skill_list_ : unlock_skill_list_;
            if (skill_list && this.auto_fight_index >= skill_list.length - 1) {
                this.auto_fight_index = 0;
            }
            else {
                this.auto_fight_index++;
            }
        };
        this.PrepareAutoFightSkill = (not_auto_release_assist_skill?) => {
            let now_skill_vo = this.getCurrentSkill()
            if (now_skill_vo && !now_skill_vo.CoolDown())
                now_skill_vo = null

            //如果当前没技能，就随机一个
            if (now_skill_vo == null) {
                let short_cut_list = this.GetShortCutList()
                let skills_can_use = []
                //把所有可用的非普通攻击技能塞进队列，准备随机一个
                let id, skillVo, learn_level, can_auto
                for (let i in short_cut_list) {
                    var vo = short_cut_list[i]
                    if (Number(i) <= 5) //大于5 可能是其他技能
                    {
                        id = vo.id
                        skillVo = this.getSkill(id)
                        learn_level = skillVo.GetNeedLevel() || 0
                        can_auto = AutoFightManager.GetInstance().FindSkillIsAuto(id)
                        if (skillVo && can_auto && !this.IsThreeAttackSkill(id) && skillVo.CoolDown() && skillVo.level > 0 && (RoleManager.Instance.mainRoleInfo.level >= learn_level || skillVo.ignore_learn_level))
                            skills_can_use.push(skillVo)
                    }
                }
                if (this.IsCanUseHitSkill())
                    skillVo = this.GetHitSkillVo()
                if (skillVo) {
                    id = skillVo.id
                    learn_level = skillVo.GetNeedLevel() || 0
                    can_auto = AutoFightManager.GetInstance().FindSkillIsAuto(id)
                    if (skillVo && can_auto && skillVo.CoolDown() && skillVo.level > 0 && (RoleManager.Instance.mainRoleInfo.level >= learn_level || skillVo.ignore_learn_level))
                        skills_can_use.push(skillVo)
                }


                //随机取技能
                if (skills_can_use.length >= 1) {
                    let max_cd_time = 0
                    let max_skill_vo = null
                    for (let i in skills_can_use) {
                        let skillVo = skills_can_use[i]
                        if (skillVo.getCd() > max_cd_time) {
                            max_cd_time = skillVo.getCd()
                            max_skill_vo = skillVo
                        }
                    }
                    now_skill_vo = max_skill_vo
                    if (now_skill_vo)
                        this.setCurrentSkillId(now_skill_vo.id)
                }


                if (now_skill_vo == null) {
                    let id = this.GetBaseSkill()
                    this.setCurrentSkillId(id)
                    now_skill_vo = this.getSkill(id)
                }
            }

            if (now_skill_vo) {
                if (not_auto_release_assist_skill)
                    return now_skill_vo.id
                else if (now_skill_vo.GetSkillType() == SkillVo.SkillType.Assist && this.CanAttack(now_skill_vo.id)) {
                    GlobalEventSystem.Fire(FightEvent.RELEASE_ASSIST_SKILL, RoleManager.Instance.mainRoleInfo.role_id, now_skill_vo.id)
                    // this.last_attack_time = Time.time
                    this.setCurrentSkillId()
                    return false
                }
            }

            return true
        };
        this.CanAttack = (skill_id, show_tip?) => {
            let main_role = Scene.Instance.main_role;
            if(main_role.IsInState(PoseState.JUMP) || main_role.IsInState(PoseState.TASK_JUMP)){
                return false
            }
            // if (main_role.IsInState(PoseState.DOWN) || main_role.IsInState(PoseState.RISE) || main_role.IsInState(PoseState.HITED)
            //     || main_role.IsInState(PoseState.JUMP) || main_role.IsInState(PoseState.DOUBLE_JUMP) || main_role.IsInState(PoseState.GRAVITY_JUMP)
            //     || main_role.IsInState(PoseState.FLY_SHOE))
            //     return false

            if (main_role.IsInState(PoseState.HITED)) {
                return false;
            }
            let tip_str = null;
            if (skill_id) {
                let skillVo = this.getSkill(skill_id);
                if (!skillVo) {
                    console.log("取不到技能信息？？:  skill_id:", skill_id);
                    return false;
                }
                if (this.IsInRigidity()) {
                    // if (show_tip && skillVo.CoolDown()){
                    //     this.AddCacheSkill(skill_id)
                    // }
                    return false
                }
                let main_role_buff = main_role.buff_manager;
                if (skill_id != this.GetBaseSkill() && !skillVo.CoolDown())
                    tip_str = "技能冷却时间未到";
                else if (role_mgr.mainRoleInfo.ghost_mode == 1)
                    tip_str = "幽灵状态，不能发起攻击";
                else if (main_role_buff.hasYunBuff())
                    tip_str = "眩晕状态不能释放技能";
                // else if (main_role_buff.hasMabiBuff())
                //     tip_str = "麻痹状态不能释放技能"
                // else if (main_role_buff.hasDingshenBuff())
                //     tip_str = "定身状态不能释放技能"
                // else if (main_role_buff.hasHunluanBuff())
                //     tip_str = "混乱状态不能释放技能"
                // else if (main_role_buff.hasChanraoBuff())
                //     tip_str = "缠绕状态不能释放技能"
                // else if (main_role_buff.hasTuidingBuff())
                //     tip_str = "推顶状态不能释放技能"
                else if (main_role.IsInState(PoseState.DEAD))
                    tip_str = "死亡状态不能释放技能";
            }
            if (tip_str) {
                if (show_tip)
                    Message.show(tip_str, true);
                return false;
            }
            else
                return true;
        };
        this.CreateSkillList = () => {
            this.mySkillList = {};
            let len = user_msg_adapter.ReadFmt("h")
            for (let index = 0; index < len; index++) {
                let [skillId, skillLv] = user_msg_adapter.ReadFmt("ih"),
                    skill_cfg = this.getSkillFromConfig(skillId);
                if (skill_cfg != null) {
                    let skillVo = this.mySkillList[skillId] || new SkillVo(skillId);
                    skillVo.level = skillLv;
                    this.mySkillList[skillId] = skillVo;
                }
            }
            GlobalEventSystem.Fire(EventName.GET_SKILL_SHORTCUT) //刷新快捷栏
            this.UpdateShortCutList()
            this.Fire(local_SkillManager.UPDATE_SKILL_LIST);
            currentSkillId_ = this.GetBaseSkill();
            currentSkillVo_ = this.getSkill(currentSkillId_);
            this.UpdateAttackDistance();
            this.CheckShortCutSkillOpenState()
        };
        this.CheckShortCutSkillOpenState = () => {
            if (!this.cache_skill_lv_dic) {
                this.cache_skill_lv_dic = {}
            }
            let cache_lv
            for (let index = 0; index < this.shortcutList.length; index++) {
                let vo: SkillVo = this.shortcutList[index]
                cache_lv = this.cache_skill_lv_dic[vo.id]
                if (vo.level > cache_lv) {
                    FunctionOpenModel.GetInstance().Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenAutoView", { id: vo.id, is_skill: true, sort_no: 0, name: vo.getName(), condition: "", icon: vo.GetIcon(), icon_open_text: vo.getDesc(null, false), icon_text: vo.getName(), content: vo.getName(), show_lv: 1 })
                }
                this.cache_skill_lv_dic[vo.id] = vo.level
            }
        }
        this.AddSkillToSkillList = (skillId?) => {

            let skill_cfg = this.getSkillFromConfig(skillId)
            if (skill_cfg != null) {
                let skillVo = this.mySkillList[skillId] || new SkillVo(skillId)
                skillVo.level = 1
                this.mySkillList[skillId] = skillVo
            }
        }
        this.GetShortCutList = (is_base?) => {

            if (is_base) {
                return this.shortcutList
                //} else if (KFGuildWarModel.GetInstance().ShowShipSkill() ) {
                //return KFGuildWarModel.GetInstance().GetShipSkill()
                //} else if (GuildWarModel.GetInstance().IsShipModel() ) {
                //return GuildWarModel.GetInstance().GetShipSkill()
                //} else if (SceneManager.Instance.IsStarDungeonScene() ) {
                //return StarSpiritModel.GetInstance().GetStarSoulSkill()
            } else {
                if (SceneManager.Instance.IsSeaHegemonyScene()) {
                    return SeaHegemonyModel.GetInstance().GetShipSkillList(true)
                }


                //极限试炼改成  使用通用的技能
                // if (SceneManager.Instance.IsPolarDungeon() || SceneManager.Instance.IsKFPolarDungeon()) {
                //     return BaseDungeonModel.GetInstance().GetPolarSkillList()
                // }

                let god_skill_list = GodBefallModel.GetInstance().CheckAndGetMainRoleGodAllSkill(this)
                if (god_skill_list && god_skill_list.length > 0) {
                    return god_skill_list
                }

                let list = []
                let info
                for (let index in this.shortcutList) {
                    var data = this.shortcutList[index]
                    info = this.replaceSkillList[data.id]
                    if (info) {
                        let skillVo = this.getSkill(info.new_skill_id)
                        if (skillVo) {
                            table.insert(list, skillVo)
                        }
                    } else {
                        table.insert(list, data)
                    }
                }
                return list
            }
        }

        this.UpdateShortCutList = () => {
            this.shortcutList = []
            let config_list = Config.PRELOAD_CLIENT_CONFIG.ConfigSkillUI.carrerSkillList[RoleManager.Instance.mainRoleInfo.career]
            if (config_list) {
                for (let _ in config_list) {
                    var v = config_list[_]
                    if (!v.common) {	//除了普通攻击外
                        table.insert(this.shortcutList, this.mySkillList[v.skill_id])
                    }
                }
            }
            let sort_func = (a?, b?) => {
                return a.id < b.id
            }
            table.sort(this.shortcutList, sort_func)   //升序排序
        }

        //技能是否在快捷栏上面
        this.IsSkillHasUse = (id?) => {
            if (!id) {
                return
            }
            return this.skillUseList[id]
        }

        this.SetHitSkillVo = (vo?) => {
            let skill_vo = this.getSkill(vo.id)
            if (skill_vo) {
                this.skillUseList[vo.id] = vo
                this.shortcutList[vo.pos] = skill_vo
            }
        }

        //获取羁绊技能数据
        this.GetHitSkillVo = () => {
            return this.shortcutList[9]
        }

        this.AddReleaseMainSkill = (skill_id) => {
            if (!this.IsThreeAttackSkill(skill_id))
                release_main_skill_time_list_[skill_id] = Laya.timer.currTimer;
        };
        this.GetReleaseMainSkill = (skill_id) => {
            let time = release_main_skill_time_list_[skill_id];
            return time ? time : 0;
        };
        this.ResetThreeAttackIndex = () => {
            three_attack_index_ = 1;
        };
        this.IsMonsterBaseSkill = (id) => {
            return local_SkillManager.MonsterBaseSkill == id;
        };
        this.isMainSkill = (id) => {
            return (id % 10 == 1) && !this.IsThreeAttackSkill(id); //以1结尾的才是主技能
        };
        this.GetBaseSkill = (career?, sex?, index?) => {
            let id = 0, main_role_info = role_mgr.mainRoleInfo;

            career = career ? career : main_role_info.career;
            sex = sex ? sex : main_role_info.sex;
            index = index ? index : three_attack_index_;

            let god_id = main_role_info.god_id
            if (god_id <= 0) {
                let cfg = local_SkillManager.BaseAttackSkills[`${career}@${sex}`]
                if (cfg && cfg[index - 1]) {
                    id = cfg[index - 1]
                }
                return id;
            }
            else {
                let id = GodBefallModel.GetInstance().GetGodSkillId(god_id, index)
                return id
            }
        };

        this.CurrBaseSkillLen = () => {
            return 4;
        };
        this.IncreaseThreeAttackIndex = (skillId) => {
            let i = three_attack_index_ + 1;
            if (i > this.CurrBaseSkillLen())
                this.ResetThreeAttackIndex();
            else
                three_attack_index_ = i;
        };
        this.getThreeAttackIndex = () => {
            return three_attack_index_;
        };
        this.IsThreeAttackSkill = (id) => {
            return local_SkillManager.ThreeAttackSkillInfo[id];
        };
        this.Update = (now_time, elapsed_time) => {
        };
        this.setCurrentSkillId = (skillId?) => {
            if (currentSkillId_ != skillId) {
                currentSkillId_ = skillId || 0;
                currentSkillVo_ = this.getSkill(skillId);
                this.UpdateAttackDistance();
            }
        };
        this.UpdateAttackDistance = () => {
            let skillVo = currentSkillVo_;
            if (!skillVo) {
                currentAttackRange_ = 0;
                return;
            }
            let range = role_mgr.GetMainRoleVo().attack_range;
            let skill_distance = skillVo.GetDistance();
            skill_distance = skill_distance ? skill_distance : 100;
            if (skillVo.GetAoeMode() == 1) {
                let area = skillVo.GetArea();
                area = area ? area : 100;
                skill_distance = skill_distance + area;
            }
            if (skill_distance < 100)
                skill_distance = 100;
            currentAttackRange_ = skill_distance * 0.8;
        };
        this.GetCurrentAttackRange = () => {
            return Math.max(100, currentAttackRange_);
        };
        this.getCurrentSkillId = () => {
            return currentSkillId_;
        };
        this.getCurrentSkill = () => {
            return currentSkillVo_;
        };
        this.getSkillFromConfig = (id) => {
            return config_skill_ && config_skill_[id];
        };
        this.GetFightSkillMovie = (skill_id) => {
            return ConfigCareerSkillMovies_[skill_id] || ConfigMonsterSkillMovies_[skill_id] || ConfigPartnerFightMovies_[skill_id] || ConfigGodFightMovies_[skill_id] || {};
        };
        this.getSkill = (id) => {
            if (id == null || id <= 0)
                return;
            if (this.mySkillList[id] != null)
                return this.mySkillList[id];
            if (this.getSkillFromConfig(id) == null) {
                console.log(`getSkill:warning! can't find skill${id} in data_skill.db!`);
                return null;
            }
            if (otherSkillList_[id] == null) {
                let skillVo = new SkillVo(id);
                otherSkillList_[id] = skillVo;
            }
            return otherSkillList_[id];
        };
        this.PackageMainSkillId = (combo_skill) => {
            return Math.floor(combo_skill / 10) * 10 + 1; //主技能最后一位一定为1
        };
        this.ParseComboSkill = (skill_id) => {
            let skill_vo = this.getSkill(skill_id);
            if (skill_vo) {
                let cache_vo: Array<any> = combo_skill_parse_list_[skill_id];
                if (cache_vo == null) {
                    cache_vo = [];
                    let combo_infos: Array<any> = skill_vo.getComboSkill();
                    if (combo_infos) {
                        for (let info of combo_infos) {
                            cache_vo.push({
                                time: info.time + Status.NowTime,
                                skill_id: info.skill_id, has_trigger: false
                            });
                        }
                    }
                    combo_skill_parse_list_[skill_id] = cache_vo;
                }
                else {
                    let combo_infos: Array<any> = skill_vo.getComboSkill();
                    if (combo_infos) {
                        for (let i = 0; i < combo_infos.length; i++) {
                            cache_vo[i].time = combo_infos[i].time + Status.NowTime;
                            cache_vo[i].has_trigger = false;
                        }
                    }
                }
                return cache_vo;
            }
        };
        this.GetShowPassitiveSkillList = (skill_ui_cfg) => {
            let show_passitive_skill_list = [];
            let cur_index = 0;

            let passitive_list = skill_ui_cfg["passitiveSkillList"];
            if (passitive_list) {
                for (let id in this.mySkillList) {
                    let skill_vo = this.mySkillList[id];
                    if (passitive_list[id] && role_mgr.mainRoleInfo.level >= skill_vo.GetNeedLevel()) {
                        show_passitive_skill_list[cur_index] = skill_vo;
                        cur_index = cur_index + 1;
                    }
                }
            }
            let heart_list = skill_ui_cfg["heartSkillList"];
            if (heart_list) {
                for (let skill_id in heart_list) {
                    let skill_vo = this.mySkillList[skill_id] || new SkillVo(skill_id);
                    let lv = 0;
                    skill_vo.level = lv;
                    show_passitive_skill_list[cur_index] = skill_vo;
                    cur_index++;
                }
            }
            function sort_func(a, b) {
                return a.id - b.id;
            }
            show_passitive_skill_list.sort(sort_func);
            let temp = show_passitive_skill_list.splice(5, 1)
            let temp1 = show_passitive_skill_list.splice(2, 3)
            show_passitive_skill_list = show_passitive_skill_list.concat(temp, temp1)
            //return show_passitive_skill_list;

            let skillCfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill
            let career = RoleManager.GetInstance().GetMainRoleCareer()
            cur_index = 0
            for (let _ in skillCfg) {
                var v = skillCfg[_]
                let skillList = JSON.parse(v.skill_list)
                for (let _ in skillList) {
                    var skillInfo = skillList[_]
                    if (Number(skillInfo[0]) == career) {
                        let skill_id = Number(skillInfo[1][0][0])
                        let skill_vo = this.mySkillList[skill_id] || new SkillVo(skill_id)
                        let lv = BaseDungeonModel.GetInstance().GetHeartSkillLv(skill_id) || 0
                        skill_vo.level = lv
                        skill_vo.taskId = v.task_id
                        show_passitive_skill_list[cur_index] = skill_vo
                        cur_index = cur_index + 1
                    }
                }
            }
            return show_passitive_skill_list
        }
        this.SetUnlockSkillList = (role_lv?) => {
            // let short_cut_list: Array<number> = this.auto_fight_order[role_mgr.mainRoleInfo.career]
            let short_cut_list: Array<number> = this.GetSkillBarAutoFightSkillOrder();
            if (!short_cut_list)
                return;
            role_lv = role_lv || role_mgr.GetMainRoleVo().level;
            // if (!task_id) {
            //     let task_vo = TaskModel.GetInstance().MainLineTaskVo
            //     task_id = task_vo ? task_vo.task_id : SkillUIModel.MAX_TASK_ID + 1
            // }
            // if (role_lv > SkillUIModel.MAX_CHECK_ROLE_LV && task_id > SkillUIModel.MAX_TASK_ID)
            // if (role_lv > SkillUIModel.MAX_CHECK_ROLE_LV)
            // return short_cut_list
            let list = [], config_skill = config_skill_;
            if (config_skill) {
                for (let skill_id of short_cut_list) {
                    let cfg = config_skill[skill_id];
                    if (!cfg)
                        continue;
                    // let task_cache = skill_model.GetTaskIdCacheAndSet(skill_id, cfg)
                    // if (task_cache && !skill_model.CheckTaskFinish(task_cache)) continue
                    list.push(skill_id);
                }
            }
            return list;
        };
        this.SetUnlockSkillListForce = (role_lv?) => {
            unlock_skill_list_ = this.SetUnlockSkillList(role_lv);
        };
        this.GetUnlockSkillList = () => {
            if (!unlock_skill_list_) {
                unlock_skill_list_ = this.SetUnlockSkillList();
            }
            return unlock_skill_list_;
        };
        this.GetSkillStrenHurt = (skill_id) => {
        };
        this.GetSkillFromConfigByIdAndLevelAndPower = (id, level) => {
            let description = "";
            let name = "";
            let power = 0;
            let icon = 0;
            let skill_cfg = this.getSkillFromConfig(id);
            if (skill_cfg) {
                if (skill_cfg.lv_data) {
                    let list = JSON.parse(skill_cfg.lv_data);
                    if (list && list[level - 1]) {
                        description = list[level - 1].desc;
                        name = skill_cfg.name;
                        power = list[level - 1].power;
                        icon = list[level - 1].icon;
                    }
                }
            }
            return [description, name, Number(power), icon];
        };
        this.GetGodSkillList = () => {
            if (role_mgr.mainRoleInfo.god_id > 0) {
                let god_id = role_mgr.mainRoleInfo.god_id;
            }
        };
        this.GetBarInfoByPos = (pos) => {
            let skill_info;
            if (this.skill_bar_info) {
                for (let vo of this.skill_bar_info) {
                    if (vo.pos == pos && vo.type == 2) {
                        skill_info = vo;
                        break;
                    }
                }
            }
            return skill_info;
        };
        this.GetBarInfoBySkillId = (skill_id) => {
            let skill_info;
            if (this.skill_bar_info) {
                for (let vo of this.skill_bar_info) {
                    if (vo.skill_id == skill_id && vo.type == 2) {
                        skill_info = vo;
                        break;
                    }
                }
            }
            return skill_info;
        };
        //该技能是否已经已经在技能快捷栏里面了
        this.ThisSkillHadInSkillBar = (skill_id) => {
            let skill_info;
            if (this.skill_bar_info) {
                for (let vo of this.skill_bar_info) {
                    if (vo.skill_id == skill_id) {
                        skill_info = vo;
                        break;
                    }
                }
            }

            return skill_info;
        };

        this.AddCacheSkill = (id?, cache_secs?) => {
            //缓存一个技能
            let skillVo = this.getSkill(id)
            if (skillVo && skillVo.CoolDown()) {
                this.cached_skill_id = id
                this.cache_skill_time = Status.NowTime
                this.cache_secs = cache_secs || SkillManager.SkillCacheTime
            }
        }

        this.ClearCachedSkill = () => {
            this.cached_skill_id = null
        }

        this.PopCachedSkill = () => {
            return this.cached_skill_id
        }

        this.ResetSkill = (skillId) => {
            cacheReset_skillId_ = skillId;
            this.SetCacheResetSkillId();
        };
        //显示技能cd
        this.SetCacheResetSkillId = () => {
            let skillVo = this.getSkill(cacheReset_skillId_);
            if (skillVo && skillVo.getCd() != 0) {
                let cdTime = skillVo.getCd() / 1000
                skillVo.startCD()
                // this.skill_cd_time_list[skillVo.id] = local_egret.getTimer();
                this.Fire(SkillManager.START_SKILL_CD, cacheReset_skillId_, cdTime)
            }

            this.setCurrentSkillId();
            cacheReset_skillId_ = null;
        };

        this.ClearAllSkillCD = () => {
            for (let id in this.cd_skill_list) {
                // var info = this.cd_skill_list[id]
                this.ClearSkillCD(id)
            }
        }
        this.ClearSkillCD = (skill_id) => {
            let skillVo = this.getSkill(skill_id)
            if (skillVo) {
                skillVo.clearCD()
                this.Fire(SkillManager.START_SKILL_CD, skill_id, 0)
            }
        }
        this.LockCD = (lock?) => {
            SkillManager.GetInstance().Fire(SkillManager.LOCK_CD, lock)
        }
        this.AddCDItem = (skill_id?, item?) => {
            this.cd_skill_list[skill_id] = item
        }
        this.RemoveCdItem = (skill_id?) => {
            this.cd_skill_list[skill_id] = null
        }
        this.IsCanUseHitSkill = () => {
            return this.can_use_hit_skill
        }
        this.SetCanUseHitSkill = (bool?) => {
            this.can_use_hit_skill = bool
        }

        let skill_shortCut_click = (skillId, skill_attack_type) => {
            this.PressSkillHandler(skillId, skill_attack_type)
        }
        GlobalEventSystem.Bind(FightEvent.SKILL_SHORTCUT_CLICK, skill_shortCut_click)



    }
    public static GetInstance() {
        if (!SkillManager.Instance) {
            SkillManager.Instance = new SkillManager();
        }
        return SkillManager.Instance;
    }
    //获取技能快捷栏技能表
    public GetSkillBarAutoFightSkillOrder = () => {
        let short_cut_list: Array<number> = this.auto_fight_order[RoleManager.GetInstance().mainRoleInfo.career];
        if (this.skill_bar_info) {
            short_cut_list = [];
            let before_break_skill_id;
            for (let vo of this.skill_bar_info) {
                if (vo.type == 2) { //技能
                    short_cut_list.push(vo.skill_id);
                }
            }
            // console.log("this.mySkillList size++++++++++++:", Util.TableSize(this.mySkillList))
        }
        return short_cut_list;
    }

    //突破技能的话，要用突破后的技能id去替换mySkillList里面的技能id, mySkillList里面的技能id都是突破前的，服务端没有处理
    public ReplaceSkillListWithBreakSkillId = (before_skill_id, break_skill_id) => {
        if (before_skill_id && break_skill_id) {
            let skillVo = this.mySkillList[before_skill_id];
            if (skillVo) {
                let lv = skillVo.level;
                this.mySkillList[before_skill_id] = null;
                let new_skill_vo = new SkillVo(break_skill_id);
                new_skill_vo.level = lv;
                this.mySkillList[break_skill_id] = new_skill_vo;
            }
        }
    }


    public SetSkillRigidity = (time_len) => {
        let rigidity_end_time = time_len + Status.NowTime
        if (this.skill_rigidity && rigidity_end_time < this.skill_rigidity)
            return

        this.skill_rigidity = rigidity_end_time
    }


    public IsInRigidity() {
        if (this.skill_rigidity && Status.NowTime - this.skill_rigidity < -4) {
            console.warn("SkillManager:IsInRigidity:在异常CD中，", Status.NowTime - this.skill_rigidity)
        }
        return this.skill_rigidity && Status.NowTime < this.skill_rigidity;
    }


    public GetRigidityLeftTime() {
        if (!this.skill_rigidity) {
            return 0
        }
        return this.skill_rigidity - Status.NowTime
    }


    /**
     * 设置施法僵直的时间秒数,结束时间
     * @param time_len 
     */
    public SetPartnerSkillRigidity(time_len) {
        let rigidity_end_time = time_len + Status.NowTime
        if (this.partner_skill_rigidity && rigidity_end_time < this.partner_skill_rigidity)
            return

        this.partner_skill_rigidity = rigidity_end_time
    }

    /**
     * 判断角色是否在施法僵直的过程中
     * @returns bool
     */
    public PartnerIsInRigidity() {
        if (this.partner_skill_rigidity && Status.NowTime - this.partner_skill_rigidity < -4) {
            console.warn("SkillManager:PartnerIsInRigidity:在异常CD中，", Status.NowTime - this.partner_skill_rigidity)
        }
        return this.partner_skill_rigidity && Status.NowTime < this.partner_skill_rigidity
    }


    public PressSkillHandler(skill_id?, skill_attack_type?) {


        if (!this.CanAttack(skill_id, true))
            return

        this.setCurrentSkillId(skill_id)

        let skillvo = this.getCurrentSkill()
        let carrer = skillvo.getCarrer()
        if (carrer == 52) { // 伙伴技能
            Scene.GetInstance().PartnerUpdateFight(skill_id)
        } else if (skillvo && skillvo.GetSelectType() == 1) { //对自己释放技能
            GlobalEventSystem.Fire(FightEvent.RELEASE_MAIN_SKILL, null, null, null, skill_attack_type)
        } else {
            Scene.GetInstance().MainRoleAttackTarget()
        }
    }
}

window["SkillManager"] = SkillManager