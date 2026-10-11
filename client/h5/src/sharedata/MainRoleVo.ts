import { RoleVo } from "./RoleVo";
import { SceneBaseType } from "../scene/SceneConfig";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { BattleProtoVo } from "../common/BattleProtoVo";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { SkillManager } from "../skill/SkillManager";
import { ResManager } from "../common/ResManager";
import { PlatformManager } from "../PlatformManager";
import { MedalModel } from "../commonModel/MedalModel";
// TypeScript file
export class MainRoleVo extends RoleVo {
    is_start_fight
    vo_type = SceneBaseType.MainRole;
    gm_flag = 0; // int:8	gm
    level = 0; // int:16	等级
    attack_speed = 0.8; // int:16	攻击速度(秒)
    attack_range = 2; // int:8	攻击范围(格子数)
    exp = 0; // int:64  经验（有符号）
    exp_lim = 0; // int:32	经验上限
    jin = 0; //int:32 钻石
    jinLock = 0; //int:32 礼券
    tong = 0; //int:32 金币
    tongLock = 0; //int:32 绑定金币
    slot_info = {};
    anger = 0; //怒气
    lastSceneId = 0; //玩家上次下线所在的场景id
    hp = 0; // int:32	气血
    maxHp = 0; // int:32	气血上限
    enemy_id = 0; //当前敌人id
    particle_priority = 1;
    last_role_id = 0
    role_id = 0;
    plat_name = "测试";
    server_unique_id = 0; //int:16 服务器唯一id
    server_name = "";
    server_id = 1;
    server_msg = ""
    chaosTime = 0;
    peace_cd_time = 0;
    worldLv = 0; // 世界等级
    worldLvExp = 0; // 世界等级经验加成
    hatred = 0;
    hatred_time = 0;
    date_role_id = 0;
    kill_mon_exp = 0;
    province = "同省";
    city = "";
    ip = "";
    camp; //阵营
    dun_id;
    guild_coin;
    att = 0;
    wreck = 0;
    def = 0;
    hit = 0;
    dodge = 0;
    crit = 0;
    ten = 0;
    is_fighting_state = false;
    is_start_to_fight = false;
    //一下百分比的值 已经在BattleProtoVo中除以10000
    hurt_add_ratio = 0;
    hurt_del_ratio = 0;
    hit_ratio = 0;
    dodge_ratio = 0;
    crit_ratio = 0;
    uncrit_ratio = 0;
    abs_att = 0;
    abs_def = 0;
    hurt_float_ratio = 0;
    skill_hurt_add_ratio = 0;
    skill_hurt_del_ratio = 0;
    crit_hurt_add_ratio = 0;
    crit_hurt_del_ratio = 0;
    parry_ratio = 0;
    overload_ratio = 0;
    parry = 0;
    neglect = 0;
    HearHurtAddRatio = 0;
    HearHurtDelRatio = 0;
    DefHearHurtRatio = 0;
    att_add_ratio = 0;
    hp_add_ratio = 0;
    wreck_add_ratio = 0;
    def_add_ratio = 0;
    hit_add_ratio = 0;
    dodge_add_ratio = 0;
    crit_add_ratio = 0;
    ten_add_ratio = 0;
    draconic_sacred = 0;
    draconic_tspace = 0;
    draconic_rule = 0;
    last_role_res;
    last_horse_res;
    last_weapon_res;
    last_wing_res;
    res_change = true;
    role_res_list = [];
    weapon_res_list = [];
    wing_res_list = [];
    horse_res_list = [];
    dir_list = [3, 9];
    level_cache_list;
    exp_cache = -1;
    create_role_time = 0;
    /**
     * 托管状态
     */
    deposit_state = false
    public constructor() {
        super();
    }
    // public ResetRoleReslist = (role_res) => {
    //     if (role_res) {
    //         let self = this,
    //             horse_res = self.GetFigureId(FigureProtoVo.FigureType.Horse),
    //             cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPreloadResList,
    //             horse_flag = horse_res ? "_1" : "_0",
    //             base_res_path = GameResPath.GetScenePath(),
    //             res_name,
    //             preload_action
    //         if(self.career == 1)
    //         {
    //             preload_action = cfg.preload_qishi_action
    //         }else
    //         {
    //             preload_action = cfg.preload_sheshou_action
    //         }
    //         self.role_res_list.length = 0
    //         for (let j = 0; j < preload_action.length; j++) {
    //             for (let k = 0; k < self.dir_list.length; k++) {
    //                 res_name = `${role_res}_${preload_action[j]}_${self.dir_list[k]}${horse_flag}`;
    //                 self.role_res_list.push(`${base_res_path}sceneobj/${role_res}/${res_name}.json`)
    //                 self.role_res_list.push(`${base_res_path}sceneobj/${role_res}/${res_name}.png`)
    //             }
    //         }
    //         if (self.last_role_res) {
    //             MovieClipDataPool.GetInstance().CheckForeverPool()
    //         }
    //     }
    // }
    // public ResetWeaponReslist = (weapon_res) => {
    //     if (weapon_res) {
    //         let self = this,
    //             horse_res = self.GetFigureId(FigureProtoVo.FigureType.Horse),
    //             cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPreloadResList,
    //             horse_flag = horse_res ? "_1" : "_0",
    //             base_res_path = GameResPath.GetScenePath(),
    //             res_name,
    //             preload_action
    //         if(self.career == 1)
    //         {
    //             preload_action = cfg.preload_qishi_action
    //         }else
    //         {
    //             preload_action = cfg.preload_sheshou_action
    //         }
    //         self.weapon_res_list.length = 0
    //         for (let j = 0; j < preload_action.length; j++) {
    //             for (let k = 0; k < self.dir_list.length; k++) {
    //                 res_name = `${weapon_res}_${preload_action[j]}_${self.dir_list[k]}${horse_flag}`;
    //                 self.weapon_res_list.push(`${base_res_path}weapon/${weapon_res}/${res_name}.json`)
    //                 self.weapon_res_list.push(`${base_res_path}weapon/${weapon_res}/${res_name}.png`)
    //             }
    //         }
    //         if (self.last_weapon_res) {
    //             MovieClipDataPool.GetInstance().CheckForeverPool()
    //         }
    //     }
    // }
    // public ResetWingReslist = (wing_res) => {
    //     if (wing_res) {
    //         let self = this,
    //             horse_res = self.GetFigureId(FigureProtoVo.FigureType.Horse),
    //             cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPreloadResList,
    //             horse_flag = horse_res ? "_1" : "_0",
    //             base_res_path = GameResPath.GetScenePath(),
    //             res_name,
    //             preload_action
    //         if(self.career == 1)
    //         {
    //             preload_action = cfg.preload_qishi_action
    //         }else
    //         {
    //             preload_action = cfg.preload_sheshou_action
    //         }
    //         self.wing_res_list.length = 0
    //         for (let j = 0; j < preload_action.length; j++) {
    //             for (let k = 0; k < self.dir_list.length; k++) {
    //                 res_name = `${wing_res}_${preload_action[j]}_${self.dir_list[k]}_1`;
    //                 if (preload_action[j] != "idle" && preload_action[j] != "run") {
    //                     res_name = `${res_name}_${self.career}`
    //                 }
    //                 self.wing_res_list.push(`${base_res_path}wing/${wing_res}/${res_name}.json`)
    //                 self.wing_res_list.push(`${base_res_path}wing/${wing_res}/${res_name}.png`)
    //             }
    //         }
    //         if (self.last_wing_res) {
    //             MovieClipDataPool.GetInstance().CheckForeverPool()
    //         }
    //     }
    // }
    // public ResetHorseReslist = (horse_res) => {
    //     if (horse_res) {
    //         let self = this,
    //             horse_res = self.GetFigureId(FigureProtoVo.FigureType.Horse),
    //             cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigPreloadResList,
    //             base_res_path = GameResPath.GetScenePath(),
    //             res_name,
    //             preload_action
    //         if(self.career == 1)
    //         {
    //             preload_action = cfg.preload_qishi_action
    //         }else
    //         {
    //             preload_action = cfg.preload_sheshou_action
    //         }
    //         self.horse_res_list.length = 0
    //         for (let j = 0; j < preload_action.length; j++) {
    //             for (let k = 0; k < self.dir_list.length; k++) {
    //                 res_name = `${horse_res}_${preload_action[j]}_${self.dir_list[k]}_1`;
    //                 self.horse_res_list.push(`${base_res_path}horse/${horse_res}/${res_name}.json`)
    //                 self.horse_res_list.push(`${base_res_path}horse/${horse_res}/${res_name}.png`)
    //             }
    //         }
    //         if (self.last_horse_res) {
    //             MovieClipDataPool.GetInstance().CheckForeverPool()
    //         }
    //     }
    // }
    // //是否是主角的资源  判断是否在以上四个列表中之一
    // public CheckIsMainRoleRes = (res_name) => {
    //     if (res_name) {
    //         if (this.role_res_list.indexOf(res_name) >= 0
    //             || this.weapon_res_list.indexOf(res_name) >= 0
    //             || this.wing_res_list.indexOf(res_name) >= 0
    //             || this.horse_res_list.indexOf(res_name) >= 0
    //         ) {
    //             return true
    //         }
    //     }
    // }
    public ReadFrom13001 = () => {
        let self = this, _user_msg_adapter = UserMsgAdapter.GetInstance();
        let new_role_id = _user_msg_adapter.ReadFmt("l"); //用户id
        if(self.role_id && self.role_id != new_role_id)
		{
			self.last_role_id = self.role_id
		}
        self.role_id = new_role_id
        self.plat_name = _user_msg_adapter.ReadFmt("s"); //平台名字
        self.server_id = _user_msg_adapter.ReadFmt("h"); //服数
        self.server_msg = _user_msg_adapter.ReadFmt("s"); //服信息
        self.server_unique_id = _user_msg_adapter.ReadFmt("h"); //服务器id(唯一id)注意一般不用唯一id
        self.server_name = _user_msg_adapter.ReadFmt("s"); //服务器名字
        //console.log(self.role_id,self.plat_name,self.server_id,self.server_name)
        let list = new FigureProtoVo().ReadFmt(self);
        new BattleProtoVo().ReadFmt(self);
        [
            self.lastSceneId,
            self.pos_x,
            self.pos_y,
            self.dun_id,
            self.exp,
            self.exp_lim,
            self.jin,
            self.jinLock,
            self.tong,
            self.guild_coin,
            self.fighting,
            self.guild_id,
            self.guild_name,
        ] = _user_msg_adapter.ReadFmt("ihhilliilills");
        self.ChangeVar("peace_cd_time", _user_msg_adapter.ReadFmt("h"));
        self.hatred = _user_msg_adapter.ReadFmt("h"); //int16 : 仇恨值
        self.team_id = _user_msg_adapter.ReadFmt("l"); //int:32  队伍id(为0时没队伍)
        self.date_role_id = _user_msg_adapter.ReadFmt("l"); //约会id
        self.ip = _user_msg_adapter.ReadFmt("s"); //ip地址
        self.camp = _user_msg_adapter.ReadFmt("h"); // 阵营
        self.create_role_time = _user_msg_adapter.ReadFmt("i")    //创角时间
        self.ChangeAllVar();
        console.warn("ReadFrom13001", this.role_id, this.lastSceneId, this.create_role_time)
    };
    public ChangeFromVo = (roleVo: RoleVo) => {
        let self = this;
        self.ChangeVar("name", roleVo.name);
        self.ChangeVar("maxHp", roleVo.maxHp);
        self.ChangeVar("hp", roleVo.hp);
        self.ChangeVar("move_speed", roleVo.move_speed);
        self.ChangeVar("att_speed", roleVo.att_speed);
        self.ChangeVar("hide_flag", roleVo.hide_flag);
        self.ChangeVar("ghost_mode", roleVo.ghost_mode);
        self.ChangeVar("sit_state", roleVo.sit_state);
        self.ChangeVar("team_id", roleVo.team_id);
        self.ChangeVar("vip_flag", roleVo.vip_flag);
        self.ChangeVar("is_hide_vip", roleVo.is_hide_vip);
        self.ChangeVar("team_job", roleVo.team_job);
        self.ChangeVar("pk_status", roleVo.pk_status);
        self.ChangeVar("guild_id", roleVo.guild_id);
        self.ChangeVar("is_ride", roleVo.is_ride);
        self.ChangeVar("warGroup", roleVo.warGroup);
        self.ChangeVar("dsgt_id", roleVo.dsgt_id);
        self.ChangeVar("guild_name", roleVo.guild_name);
        self.ChangeVar("position_name", roleVo.position_name);
        self.ChangeVar("sky_flags", roleVo.sky_flags, null, true);
        self.ChangeVar("weapon_effect", roleVo.weapon_effect);
        self.ChangeVar("grade_id", roleVo.grade_id);
        self.ChangeVar("is_marriage", roleVo.is_marriage);
        self.ChangeVar("marriage_id", roleVo.marriage_id);
        self.ChangeVar("marriage_name", roleVo.marriage_name);
        self.ChangeVar("boss_flag", roleVo.boss_flag, null, true);
        self.ChangeVar("escort_state", roleVo.escort_state);
        self.ChangeVar("protect_time", roleVo.protect_time);
        self.ChangeVar("ship_model_id", roleVo.ship_model_id);
        self.ChangeVar("god_id", roleVo.god_id);
        self.ChangeVar("brick_id", roleVo.brick_id);
        self.ChangeVar("supreme_vip", roleVo.supreme_vip);
        self.ChangeVar("invincible_end_time", roleVo.invincible_end_time);
        self.ChangeVar("title_id", roleVo.title_id);
        self.ChangeVar("camp", roleVo.camp);
        self.ChangeVar("mask_id", roleVo.mask_id);
        self.ChangeVar("seaCamp", roleVo.seaCamp);


        self.level_model_list.length = 0
        for(let i in roleVo.level_model_list){
            self.level_model_list[i] = roleVo.level_model_list[i]
        }
        self.ChangeVar("level_model_list", self.level_model_list, null, true);

        self.fashion_model_list.length = 0
        for(let i in roleVo.fashion_model_list){
            self.fashion_model_list[i] = roleVo.fashion_model_list[i]
        }
        self.ChangeVar("fashion_model_list", self.fashion_model_list, null, true);
       

        self.figure_ride_list.length = 0
        for(let i in roleVo.figure_ride_list){
            self.figure_ride_list[i] = roleVo.figure_ride_list[i]
        }
        self.ChangeVar("figure_ride_list", self.figure_ride_list, null, true);

        self.figure_list.length = 0
        for(let i in roleVo.figure_list){
            self.figure_list[i] = roleVo.figure_list[i]
        }
        self.ChangeVar("figure_list", self.figure_list, null, true);


        self.dress_list.length = 0
        for(let i in roleVo.dress_list){
            self.dress_list[i] = roleVo.dress_list[i]
        }
        self.ChangeVar("dress_list", self.dress_list, null, true);
    };
    public changeCareer = (roleVo: RoleVo) => {
        let self = this;
        self.ChangeVar("career", roleVo.career);
        self.ChangeVar("sex", roleVo.sex);
        self.ChangeVar("level_model_list", roleVo.level_model_list, null, true);
        self.ChangeVar("fashion_model_list", roleVo.fashion_model_list, null, true);
        self.ChangeVar("revelation_suit", roleVo.revelation_suit);
        self.ChangeVar("figure_list", roleVo.figure_list);
        self.ChangeVar("picture", roleVo.picture);
        let local_GlobalEventSystem = GlobalEventSystem;
        let local_EventName = EventName;
        local_GlobalEventSystem.Fire(local_EventName.REQUEST_ROLE_PROTO, 13080);
        local_GlobalEventSystem.Fire(local_EventName.REQUEST_ROLE_PROTO, 13046);
        local_GlobalEventSystem.Fire(local_EventName.REQUEST_ROLE_PROTO, 13007);
        SkillManager.GetInstance().Fire(SkillManager.REQUEST_CCMD_EVENT, 21002);
        local_GlobalEventSystem.Fire(local_EventName.CHANGE_MAINROLE_CAREER);
        ResManager.GetInstance().ResetStaticSprite3DUrlDic()
        // Message.show("转职成功");
    };
    public ReadFrom13003 = () => {
        let old_level = this.level;
        let [level, new_exp, exp_lim] = UserMsgAdapter.GetInstance().ReadFmt("hll");
        // this.level = level
        this.exp_lim = exp_lim;
        this.exp = -1;
        if (!ResManager.GetInstance().true_game_start) {
            if (!this.level_cache_list)
                this.level_cache_list = [];
            this.level_cache_list.push(level);
            this.exp_cache = new_exp;
        }
        else {
            this.level_cache_list = null;
            this.exp_cache = -1;
            this.level = level;
            this.ChangeVar("exp", new_exp);
            if (old_level > 0 && old_level < this.level) {
                Laya.timer.callLater(this, () => {
                    this.Fire(EventName.CHANGE_LEVEL, level);
                });
                PlatformManager.GetInstance().DataPost(2);
                // PlatformManager.GetInstance().EyouDataPlacement("level_up");
            }
        }
    };
    public ReadFrom13033 = () => {
        // this.CacheLastProperty()
        this.ChangeVar("fighting", UserMsgAdapter.GetInstance().ReadFmt("l"));
        let cache_move_speed = this.move_speed
        new BattleProtoVo().ReadFmt(this);
        //速度有变化派发一下事件
        if(cache_move_speed != this.move_speed){
            this.Fire("move_speed", "move_speed", this.move_speed, cache_move_speed);
        }
        // this.PropertyChange()
        this.Fire(EventName.UPDATE_MAIN_ROLE_INFO_VIEW);
        MedalModel.GetInstance().Fire(MedalModel.UpdateInfo)//更新勋章界面
    };
    public ReadFrom13011 = () => {
        let [worldLvExp, worldLv] = UserMsgAdapter.GetInstance().ReadFmt("Hh");
        this.ChangeVar("worldLv", worldLv);
        this.ChangeVar("worldLvExp", worldLvExp);
    };
    public ReadFrom13017 = () => {
        let deposit_state = UserMsgAdapter.GetInstance().ReadFmt("c");
        this.ChangeVar("deposit_state", deposit_state == 1)
    }
    // public CacheLastProperty = () => {
    //     let vo,
    //         pro_str,
    //         last_pro_str
    //     this["last_maxHp"] = this["maxHp"]
    //     for (let i = 0; i < BaseAttrProtoVo.pro_list.length; i++) {
    //         vo = BaseAttrProtoVo.pro_list[i]
    //         pro_str = vo[0]
    //         last_pro_str = `last_${pro_str}`
    //         this[last_pro_str] = this[pro_str]
    //     }
    // }
    // public PropertyChange = () => {
    //     let vo,
    //         pro_str,
    //         last_pro_str,
    //         txt
    //     if (this["last_maxHp"] > 0 && this["maxHp"] - this["last_maxHp"] > 0) {
    //         txt = `<font color=0xffef67>生命+${this["maxHp"] - this["last_maxHp"]}</font>`
    //         // Message.show(txt, true, SysInfoType.MINI, SysInfoMiniMgr.MessageType.Two)
    //     }
    //     let add: number = 0
    //     for (let i = 0; i < BaseAttrProtoVo.pro_list.length; i++) {
    //         vo = BaseAttrProtoVo.pro_list[i]
    //         pro_str = vo[0]
    //         last_pro_str = `last_${pro_str}`
    //         if (this[pro_str] != undefined && this[last_pro_str] && this[pro_str] - this[last_pro_str] > 0) {
    //             add = this[pro_str] - this[last_pro_str]
    //             if (vo[3] == 1) {//显示百分比
    //                 add = add * 100
    //                 txt = `<font color=0xffef67>${vo[2]}+${add.toFixed(2)}%</font>`
    //             } else {
    //                 txt = `<font color=0xffef67>${vo[2]}+${add}</font>`
    //             }
    //             // Message.show(txt, true, SysInfoType.MINI, SysInfoMiniMgr.MessageType.Two)
    //         }
    //     }
    // }
    public CacheHandle() {
        if (this.level_cache_list) {
            for (let level of this.level_cache_list) {
                this.level = level;
                this.Fire(EventName.CHANGE_LEVEL, level);
            }
            this.level_cache_list = undefined;
        }
        if (this.exp_cache >= 0) {
            this.ChangeVar("exp", this.exp_cache);
            this.exp_cache = -1;
        }
    }
}

window["MainRoleVo"] = MainRoleVo