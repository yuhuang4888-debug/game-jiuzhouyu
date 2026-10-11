import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { Config } from "../common/Config";
export class MonsterVo extends EventDispatcher {
    vo_type = SceneBaseType.Monster;
    pos_x = 0; //X坐标(int16)
    pos_y = 0; //Y坐标(int16)
    instance_id = 0; //怪物唯一标识(int32)
    type_id = 0; //怪物类型ID(int32)
    defend = 0; //防御属性
    hp = 100; //怪物当前血量(int32)
    maxHp = 100; //怪物最大血量(int32)
    level = 1; //怪物等级(int16)
    name = ""; //怪物名字(string)
    move_speed = 160; //怪物速度(int16)
    monster_res = 0; //怪物资源(int32)
    effect_res = ""; //特效资源(string)
    texture_res = 0;
    weapon_id = 0;
    attack_mode = 0; //攻击类型(int8) 0:近战 1:远程
    type = 0; //类型(int8) 0为怪物 1采集 2旗子...5镖车
    quality = 0; //品级(int8) 0白/1绿/2蓝/3紫/4橙
    guaji_flag = 0; //是否挂机(int8) 0是，1否
    boss_type = 0; //Boss类型(int8) 0普通怪，1野外BOSS，2英灵殿BOSS，3世界BOSS，4帮派BOSS，5副本BOSS，6爬塔BOSS，7塔防BOSS
    pick_time = 0; //采集所需时间(int32)
    master_id = 0; //主人ID(int32)
    can_pick = 1; //是否可点击（0否 1是）
    can_attack = 1; //是否可攻击（0否 1是）
    warGroup = 0; //攻击阵营，默认0为无阵营
    realm = 0; //国家/阵营（1|2|3）
    prePoseState = PoseState.STAND;
    poseState = PoseState.STAND;
    guild_id = 0;
    attributive_id = 0; //所属玩家id
    kuangbao_left_time = 0; //狂暴结束时间戳
    guild_name = "";
    server_num = 0;
    next_collect_time = 0; //采集冷却时间
    birth_angle = null;
    // five_element = 0
    // title = 0
    ////-----------一下是客户端战斗用到的属性------------------------------------------------------------------------
    hide_flag = 0; //是否隐藏
    ghost_mode = 0; //是否幽灵模式
    cfg_data = null;
    is_armor = 0; //是否霸体
    icon_scale = 1;
    color = 0;
    birth_effect_res = null; //出生特效
    dead_effect_res = null; //出生特效
    foot_effect_res = null; //脚下特效
    classification = null; //怪物分类名字
    load_immediately = 0; //是否立即加载怪物
    is_hit_ac = 0; //是否需要受击动作
    is_hide_hp = null;
    is_client_monster = false;
    not_fade = false;
    is_client_auto_fight_monster = false; //是否客户端战斗挂机怪
    drop_list: Array<any>;
    reborn_end_pos;
    // pos_x = 0 //X坐标(int16)
    // pos_y = 0 //Y坐标(int16)
    // instance_id = 0	   //怪物唯一标识(int32)
    // type_id = 0	 //怪物类型ID(int32)
    // hp = 100		//怪物当前血量(int32)
    // maxHp = 100	//怪物最大血量(int32)
    // level = 1		//怪物等级(int16)
    // name = ""		//怪物名字(string)
    // move_speed = 160 //怪物速度(int16)
    // monster_res = 0	//怪物资源(int32)
    // effect_res = ""	//特效资源(string)
    // texture_res = 0
    // weapon_id = 0
    // attack_mode = 0	//攻击类型(int8) 0:近战 1:远程
    // type = 0	//类型(int8) 0为怪物 1采集 2旗子...5镖车
    // quality = 0 //品级(int8) 0白/1绿/2蓝/3紫/4橙
    // guaji_flag = 0 //是否挂机(int8) 0是，1否
    // boss_type = 0 //Boss类型(int8) 0普通怪，1野外BOSS，2英灵殿BOSS，3世界BOSS，4帮派BOSS，5副本BOSS，6爬塔BOSS，7塔防BOSS
    // pick_time = 0	//采集所需时间(int32)
    // master_id = 0	//主人ID(int32)
    // can_pick = 1 	//是否可点击（0否 1是）
    // can_attack = 1//是否可攻击（0否 1是）
    // warGroup = 0 	//攻击阵营，默认0为无阵营
    // realm = 0 		//国家/阵营（1|2|3）
    // prePoseState = PoseState.STAND
    // poseState = PoseState.STAND
    // guild_id = 0
    // birth_angle = null
    // cfg_data
    // five_element = 0
    // title = 0
    // is_armor = 0				//是否霸体
    // icon_scale = 1
    // color = 0
    // birth_effect_res = null //出生特效
    // foot_effect_res = null//脚下特效
    // classification = null  //怪物分类名字
    // load_immediately = 0 //是否立即加载怪物
    // is_hit_ac = 0 //是否需要受击动作
    // is_hide_hp = null
    // hide_flag = 0 //是否隐藏
    // ghost_mode = 0 //是否幽灵模式
    public constructor() {
        super();
    }
    public ResetData() {
        let self = this;
        // self.cfg_data
        // self.is_armor = 0				//是否霸体
        // self.icon_scale = 1
        // self.color = 0
        // self.birth_angle = null
        // self.birth_effect_res = null //出生特效
        // self.foot_effect_res = null//脚下特效
        // self.classification = null  //怪物分类名字
        // self.load_immediately = 0 //是否立即加载怪物
        // self.is_hit_ac = 0 //是否需要受击动作
        // self.is_hide_hp = null
        self.cfg_data = null;
        self.is_armor = 0; //是否霸体
        self.icon_scale = 1;
        self.color = 0;
        self.birth_angle = null;
        self.birth_effect_res = null; //出生特效
        self.dead_effect_res = null; //出生特效
        self.foot_effect_res = null; //脚下特效
        self.classification = null; //怪物分类名字
        self.load_immediately = 0; //是否立即加载怪物
        self.is_hit_ac = 0; //是否需要受击动作
        self.defend = 0;
        self.is_hide_hp = null;
        self.is_client_monster = false;
        self.not_fade = false;
        self.is_client_auto_fight_monster = false;
        self.drop_list = null;
    }
    public ReadFromProtocal() {
        let self = this;
        [
            self.pos_x,
            self.pos_y,
            self.instance_id,
            self.type_id,
            self.hp,
            self.maxHp,
            self.level,
            self.name,
            self.move_speed,
            self.monster_res,
            self.effect_res,
            self.texture_res,
            self.weapon_id,
            self.attack_mode,
            self.type,
            self.quality,
            self.guaji_flag,
            self.boss_type,
            self.pick_time,
            self.can_pick,
            self.can_attack,
            self.hide_flag,
            self.ghost_mode,
            self.warGroup,
            self.guild_id,
            self.attributive_id,
            self.kuangbao_left_time,
            self.guild_name,
            self.server_num,
            self.next_collect_time //采集冷却时间
        ] = UserMsgAdapter.GetInstance().ReadFmt("hhiillhshisiicccccicccclllishi"); //头衔
        self.SetBasePropertyFromConfig();
        // console.log("创建怪物.",self.name, self.instance_id, self.hp,self.maxHp, self.type_id, self.weapon_id, self.monster_res, self.warGroup)
    }
    public SetBasePropertyFromConfig() {
        let self = this;
        self.CacheCfgData();
        if (!self.cfg_data)
            return;
        self.is_armor = self.cfg_data.is_armor ? self.cfg_data.is_armor : 0; //是否霸体
        self.icon_scale = Number(self.cfg_data.icon_scale);
        self.color = Number(self.cfg_data.color);
        self.birth_effect_res = self.cfg_data.mon_state ? String(self.cfg_data.mon_state).trim() : ""; //出生特效
        self.dead_effect_res = self.cfg_data.mon_die_state ? String(self.cfg_data.mon_die_state).trim() : ""; //死亡特效
        self.foot_effect_res = self.cfg_data.foot_icon ? String(self.cfg_data.foot_icon).trim() : ""; //脚下特效
        self.classification = self.cfg_data.classification ? String(self.cfg_data.classification).trim() : ""; //怪物分类名字
        self.load_immediately = self.cfg_data.load_immediately ? Number(self.cfg_data.load_immediately) : 0; //是否立即加载怪物
        self.is_hit_ac = self.cfg_data.is_hit_ac ? Number(self.cfg_data.is_hit_ac) : 0; //是否需要受击动作
        self.is_hide_hp = (self.cfg_data.is_hide_hp == 1);
        if(self.birth_angle == null){
            self.birth_angle = Number(self.cfg_data.direction)
            if(self.birth_angle == -1){
                self.birth_angle = null
            }
        }
    }
    public CacheCfgData() {
        if (!this.cfg_data)
            this.cfg_data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.type_id, false); //Config.PRELOAD_SERVER_CONFIG.config_mon[this.type_id]
    }
    public InitCutstomMonsterVo(vo) {
        let self = this;
        if (vo) {
            self.pos_x = vo.pos_x; //X坐标(int16)
            self.pos_y = vo.pos_y; //Y坐标(int16)
            self.instance_id = vo.instance_id; //怪物唯一标识(int32)
            self.type_id = vo.type_id; //怪物类型ID(int32)
            self.hp = vo.hp; //怪物当前血量(int32)
            self.maxHp = vo.maxHp; //怪物最大血量(int32)
            self.level = vo.level; //怪物等级(int16)
            self.name = vo.name; //怪物名字(string)
            self.move_speed = vo.move_speed; //怪物速度(int16)
            self.monster_res = vo.monster_res; //怪物资源(int32)
            self.effect_res = vo.effect_res; //特效资源(string)
            self.texture_res = vo.texture_res; //贴图id(int32)
            self.weapon_id = vo.weapon_id; //武器id(int32)
            self.attack_mode = vo.attack_mode; //攻击类型(int8) 0:近战 1:远程
            self.type = vo.type; //类型(int8) 0为怪物 1采集 2旗子 3护送车队
            self.quality = vo.quality; //品级(int8) 0白/1绿/2蓝/3紫/4橙
            self.guaji_flag = vo.guaji_flag; //是否挂机(int8) 0是，1否
            self.boss_type = vo.boss_type; //Boss类型(int8) 0普通怪，1野外BOSS，2宠物BOSS，3世界BOSS，4帮派BOSS，5副本BOSS，6爬塔BOSS，7塔防BOSS
            self.pick_time = vo.pick_time; //采集所需时间(int32)
            self.can_pick = vo.can_pick;
            self.can_attack = vo.can_attack;
            self.hide_flag = vo.hide_flag; //是否不可见(int8)
            self.ghost_mode = vo.ghost_mode; //幽灵状态(int8)  
            self.warGroup = vo.warGroup;
            self.guild_id = vo.guild_id; //结社ID
            self.attributive_id = vo.attributive_id;
        }
        self.SetBasePropertyFromConfig();
        // console.log("创建怪物.",self.name, self.instance_id, self.hp,self.maxHp, self.type_id, self.weapon_id, self.monster_res, self.warGroup)
    }
    //设置怪物出生位移路线
    public SetMonsterRebornWay(end_pos) {
        this.reborn_end_pos = end_pos;
    }
}

window["MonsterVo"] = MonsterVo