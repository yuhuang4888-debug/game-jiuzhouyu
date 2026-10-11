import { UserMsgAdapter } from "./UserMsgAdapter";
import { BaseAttrProtoVo } from "./BaseAttrProtoVo";
/**
 *  int:32  hp
    int:32  hp上限
    int:16  攻击距离(格子数)
    attr    基础属性
 */
export class BattleProtoVo {
    public static pro_list = [
        ["hp", "l"],
        ["maxHp", "l"],
        ["move_speed", "h"],
    ];
    public constructor() {
    }
    public ReadFmt(target) {
        let user_msg_adapter = UserMsgAdapter.GetInstance();
        BattleProtoVo.pro_list.forEach((value: string[], index: number) => {
            target[<string>value[0]] = user_msg_adapter.ReadFmt(<string>value[1]);
        });
        new BaseAttrProtoVo().ReadFmt(target);
        // target.hurt_add_ratio *= 0.0001;
        // target.hurt_del_ratio *= 0.0001;
        // target.hit_ratio *= 0.0001;
        // target.dodge_ratio *= 0.0001;
        // target.crit_ratio *= 0.0001;
        // target.uncrit_ratio *= 0.0001;
        // target.hurt_float_ratio *= 0.0001;
        // target.skill_hurt_add_ratio *= 0.0001;
        // target.skill_hurt_del_ratio *= 0.0001;
        // target.crit_hurt_add_ratio *= 0.0001;
        // target.crit_hurt_del_ratio *= 0.0001;
        // target.parry_ratio *= 0.0001;
        // target.overload_ratio *= 0.0001;
        // target.HearHurtAddRatio *= 0.0001;
        // target.HearHurtDelRatio *= 0.0001;
        // target.DefHearHurtRatio *= 0.0001;
        // target.att_add_ratio *= 0.0001;
        // target.hp_add_ratio *= 0.0001;
        // target.wreck_add_ratio *= 0.0001;
        // target.def_add_ratio *= 0.0001;
        // target.hit_add_ratio *= 0.0001;
        // target.dodge_add_ratio *= 0.0001;
        // target.crit_add_ratio *= 0.0001;
        // target.ten_add_ratio *= 0.0001;
        // target.parry *= 0.0001;
        // target.neglect *= 0.0001;
        return null;
    }
}

window["BattleProtoVo"] = BattleProtoVo