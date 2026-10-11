import { SkillManager } from "./SkillManager";
import { Config } from "../common/Config";
import { Status } from "../util/Status";
import { Util } from "../util/Util";
import { ErlangParser } from "../util/ErlangParser";
// import { ChatModel } from "../commonModel/ChatModel";
// TypeScript file
export class SkillVo {
    id; //技能id
    level = 1; //技能等级
    skillExp = 0; //技能熟练度
    skillExp_max = 0; //-技能熟练度上限 trigger_cond
    basic;
    canLearn = false;
    name;
    totalLevel;
    skill_link = null;
    combo_skills: Array<any>;
    cfg_combo_skills: Array<any>;
    is_shake_pre;
    type;
    career;
    is_combo;
    obj;
    att_obj;
    broadcast;
    is_aoe_mode;
    aoe_mod;
    cd;
    desc;
    useTime = 0;
    baseAttr
    skill_mgr = SkillManager.GetInstance();
    public constructor(id) {
        this.id = id;
    }
    public getName() {
        if (this.name == null) {
            this.name = this.getBasic("name");
            if (this.name != null)
                this.name = String(this.name).trim();
        }
        return this.name;
    }
    //角色
    public getCarrer() {
        if (this.career == null)
            this.career = this.getBasic("career");
        return this.career;
    }
    // 技能类型 1主动技能，2辅助技能，3被动技能，4门派技能
    public GetSkillType() {
        if (this.type == null)
            this.type = this.getBasic("type");
        return this.type;
    }
    //攻击参照类型 1自己 2选取对象
    public GetSkillAttObj() {
        if (this.att_obj == null)
            this.att_obj = this.getBasic("att_obj");
        return this.att_obj;
    }
    //是否副技能
    public IsComboSkill() {
        if (this.is_combo == null)
            this.is_combo = this.getBasic("is_combo");
        return this.is_combo == 1;
    }
    //是否怒气技能
    public IsAngerSkill() {
        return this.id % 100000 == 1;
    }
    //选取模式  1自己，2最近敌方，3最近队友  
    public GetSelectType() {
        if (this.obj == null)
            this.obj = this.getBasic("obj");
        return this.obj;
    }
    //（0客户端直接播放，1等服务端返回播）
    public GetBroadcast() {
        if (this.broadcast == null)
            this.broadcast = this.getBasic("broadcast");
        return this.broadcast;
    }
    //（是否前摇技能）
    public IsPreSwingSkill() {
        if (!this.is_shake_pre)
            this.is_shake_pre = this.getBasic("is_shake_pre");
        return this.is_shake_pre == 1;
    }
    //获取攻击目标数量
    public GetAttackNum(level?) {
        level = level ? level : this.level;
        let level_vo = this.getLevelVo(level);
        // print("获取攻击目标数量", this.id, this.level, level_vo)
        if (level_vo && level_vo.num)
            return level_vo.num;
        else
            return [0, 0];
    }
    //是否群攻模式
    public IsAoeMode() {
        if (this.is_aoe_mode == null) {
            let mod = this.getBasic("mod");
            if (mod) {
                mod = Number(mod);
                if (mod == 1)
                    this.is_aoe_mode = false;
                else
                    this.is_aoe_mode = true;
            }
            else
                this.is_aoe_mode = true;
        }
        return this.is_aoe_mode;
    }
    //AOE时选取目标的方式
    public GetAoeMode() {
        if (this.aoe_mod == null) {
            let str = this.getBasic("range");
            if (str) {
                this.aoe_mod = Number(str);
                if (this.aoe_mod == 0)
                    this.aoe_mod = 1;
            }
            else
                this.aoe_mod = 1;
        }
        return this.aoe_mod;
    }

    public GetBaseAttr(level?){
        level =  level || this.level;

        if (this.baseAttr == null || this.baseAttr[level] == null) {
            if(!this.baseAttr){
                this.baseAttr = {}
            }
            let lvs = this.getBasic("lv_data");
            if (lvs) {
                lvs = JSON.parse(lvs);
                var str = lvs[level - 1].base_attr
                this.baseAttr[level] = ErlangParser.GetInstance().Parse(str)
            }
        }
        return this.baseAttr[level]
    }

    static SkillType = {
        Initiative: 1,
        Passitive: 2,
        Assist: 3,
        Menpai: 4,
    };
    //CD时间
    public getCd(level?) {
        level = level ? level : this.level;
        let level_vo = this.getLevelVo(level);
        if (level_vo && level_vo.cd)
            this.cd = Number(level_vo.cd);
        else
            this.cd = 0;
        return this.cd;
    }
    public getDesc(level?, light?) {
        level = level ? level : this.level;
        let level_vo = this.getLevelVo(level);
        if (level_vo && level_vo.desc){
            if(window["ChatModel"]){
                this.desc = window["ChatModel"].GetInstance().FormatColorTag(level_vo.desc, light);
            }
            else{
                this.desc = level_vo.desc;
            }
        }
        else
            this.desc = "";
        return this.desc;
    }
    //基础伤害倍率
    public getHurtRatio(level?) {
        level = level ? level : this.level;
        let level_vo = this.getLevelVo(level);
        return level_vo ? level_vo.hurt : 0;
    }
    //cdLev 等级限制
    public getLevelVo(level?, cdLev = true) {
        level = (level == null) ? 0 : level;
        let lvs = this.getBasic("lv_data");
        if (lvs) {
            lvs = JSON.parse(lvs);
        }
        level = Math.max(--level, 0);
        if ((cdLev && lvs && level < lvs.length) || !cdLev)
            return lvs[level];
        return null;
    }
    public GetTotalLevel() {
        if (this.totalLevel == null) {
            let lvs = this.getBasic("lv_data");
            if (lvs) {
                lvs = JSON.parse(lvs);
                return lvs.length;
            }
            else {
                return 1;
            }
        }
        else {
            return this.totalLevel;
        }
    }
    //取攻击距离
    public GetDistance(level?) {
        level = level ? level : this.level;
        let level_vo = this.getLevelVo(level);
        if (level_vo) {
            let distance = Number(level_vo.distance);
            if (!distance)
                distance = 50;
            return distance;
        }
        else
            return 50;
    }
    //攻击范围
    public GetArea(level?) {
        level = level ? level : this.level;
        let level_vo = this.getLevelVo(level);
        if (level_vo) {
            let area = Number(level_vo.area);
            return area;
        }
        return 0;
    }
    //获取combo技（类似战士旋风，需要客户端自动每隔一段时间发一次技能）
    public getComboSkill() {
        if (!this.combo_skills) {
            this.combo_skills = [];
            let cfg = this.skill_mgr.GetFightSkillMovie(this.id);
            if (cfg) {
                let comboSkills = cfg.comboSkills;
                if (comboSkills) {
                    let time = 0;
                    let info = null;
                    for (let i = 0; i < comboSkills.length; i++) {
                        let delta = Number(comboSkills[i][0]) / 1000;
                        let skill_id = Number(comboSkills[i][1]);
                        time = time + delta;
                        info = {
                            time: time,
                            skill_id: skill_id
                        };
                        this.combo_skills.push(info);
                    }
                }
            }
        }
        return this.combo_skills;
    }
    //从后台配置中获取combo技
    public getComboSkillFromCfg() {
        if (!this.cfg_combo_skills) {
            this.cfg_combo_skills = [];
            let cfg = this.getBasic("combo");
            if (cfg) {
                let comboSkills = JSON.parse(cfg);
                if (comboSkills) {
                    let time = 0;
                    let info = null;
                    for (let i = 0; i < comboSkills.length; i++) {
                        let delta = Number(comboSkills[i][1]) / 1000;
                        let skill_id = Number(comboSkills[i][0]);
                        time = time + delta;
                        info = {
                            time: time,
                            skill_id: skill_id
                        };
                        this.cfg_combo_skills.push(info);
                    }
                }
            }
        }
        return this.cfg_combo_skills;
    }
    public GetComboSkillBySkillId(skill_id) {
        let vo;
        let skill_list = this.getComboSkillFromCfg();
        if (skill_list) {
            for (let skill of skill_list) {
                if (skill.skill_id == skill_id) {
                    vo = skill;
                    break;
                }
            }
        }
        return vo;
    }
    public getBasic(str) {
        if (!this.basic) {
            this.basic = this.skill_mgr.getSkillFromConfig(this.id);
            if (!this.basic)
                return null;
        }
        return this.basic[str];
    }

    //获取剩下的cd时间
    public GetLeftCD(){
        let ret_cd = 0
        let cfg_cd = this.getCd() / 1000
        if(this.useTime != 0){
            if(Status.NowTime - this.useTime > (cfg_cd - 0.2))
                ret_cd = 0
            else
                ret_cd = Math.max(0, cfg_cd - ( Status.NowTime - this.useTime ))
        }
        return ret_cd
    }

    public CoolDown() {
        let cd_info = SkillManager.GetInstance().cd_skill_list[this.id]
        if ((cd_info && cd_info.IsPlaying()) || this.GetLeftCD() > 0) {
            return false
        }
        return true;
    }
    public GetNeedLevel(level?) {
        level = level ? level : this.level;
        let levelVo = this.getLevelVo(level);
        if (levelVo && levelVo.condition && levelVo.condition.length > 0) {
            let result: string;
            for (let vo of levelVo.condition) {
                if (vo && vo.search("lv,") >= 0) {
                    result = vo;
                    break;
                }
            }
            if (result) {
                let list = result.split(",");
                if (list && list.length >= 2) {
                    return list[1];
                }
            }
        }
        return 0;
    }
    public GetIcon(level?) {
        level = level ? level : this.level;
        let levelVo = this.getLevelVo(level);
        if (levelVo && levelVo.icon) {
            return levelVo.icon;
        }
        return this.id;
    }
    /**
     * 获取对应等级的技能名称
    */
    public GetLvName(level?) {
        level = level ? level : this.level;
        let levelVo = this.getLevelVo(level);
        if (levelVo && levelVo.lv_name) {
            return levelVo.lv_name;
        }
        return this.name;
    }

    public startCD(){
	    this.useTime = Status.NowTime
    }

    public clearCD(){
        this.useTime = 0
    }

    public refreshCD(time){
        this.useTime = this.useTime - time
    }
}

window["SkillVo"] = SkillVo