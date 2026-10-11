import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { Config } from "../common/Config";
// 守护
export class GuardVo extends EventDispatcher {
    vo_type = SceneBaseType.Guard;
    pos_x = 0; //X像素坐标(int16)
    pos_y = 0; //Y像素坐标(int16)
    hp = 100; //当前hp(int32)
    maxHp = 100; //最大hp(int32)
    name = ""; //名字(string)
    move_speed = 160; //速度(int16)
    ghost_mode = 0;
    hide_flag = 0; //是否不可见(int8)
    warGroup = 0; //战斗分组(int8)
    guard_id = 0; //守护ID(int32)
    model_id = 0; //模型id
    texture_res = 0; //贴图
    poseState = PoseState.STAND;
    birth_angle = 90; //出生角度
    owner_id = 0; //所属玩家id
    owner_vo;
    team_id;
    //属性
    att = 0;
    wreck = 0;
    def = 0;
    hit = 0;
    dodge = 0;
    crit = 0;
    ten = 0;
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
    public constructor() {
        super();
    }
    public ReadFromProtocal() {
    }
    public SetVo(owner_vo) {
        let self = this;
        self.owner_vo = owner_vo;
        if (self.owner_vo) {
            self.warGroup = this.owner_vo.warGroup;
            self.team_id = this.owner_vo.team_id;
            self.name = owner_vo.name + "的守护";
            self.hp = 100;
            self.maxHp = 100;
            self.guard_id = this.owner_vo.fazhen_id;
            // if (self.owner_vo.role_id == RoleManager.GetInstance().mainRoleInfo.role_id) {
            // let partner_data = SpriteModel.GetInstance().GetSpriteAttr()
            // if (partner_data) {
            //     self.SetGuardProperty(partner_data.attr_list)
            // }
            // }
        }
    }
    public GetGuardClotheId() {
        if (this.owner_vo)
            return this.owner_vo.fazhen_id;
        return 0;
    }
    public SetGuardProperty(attr_list) {
        if (attr_list) {
            let key = "";
            let cfg;
            for (let obj of attr_list) {
                cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr[obj.attr_id];
                if (cfg) {
                    this[cfg.mainvo_str] = obj.attr_val;
                }
            }
        }
    }
    public DeleteMe() {
        super.DeleteMe();
    }
}

window["GuardVo"] = GuardVo