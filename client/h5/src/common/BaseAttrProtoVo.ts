
import { UserMsgAdapter } from "./UserMsgAdapter";
/**
 *  int32 攻击
    int32 破甲
    int32 防御
    int32 命中
    int32 闪避
    int32 暴击
    int32 坚韧
    int32 伤害加深
    int32 伤害减免
    int32 命中几率
    int32 闪避几率
    int32 暴击几率
    int32 抗暴几率
    int32 元素攻击
    int32 元素防御
    int32 会心几率
    int32 技能伤害加深百分比
    int32 受到技能伤害减免百分比
    int32 暴击加深百分比
    int32 暴击减免百分比
    int32 格挡几率百分比
    int32 过载几率（cd重置几率）
    int32 招架
    int32 忽视
    int32 会心伤害
    int32 会心减免
    int32 抗会心率
 */
export class BaseAttrProtoVo {
    //1代表是百分比属性
    public static pro_list = [
        ["att", "i", "攻击", 0],
        ["wreck", "i", "破甲", 0],
        ["def", "i", "防御", 0],
        ["hit", "i", "命中", 0],
        ["dodge", "i", "闪避", 0],
        ["crit", "i", "暴击", 0],
        ["ten", "i", "坚韧", 0],
        ["hurt_add_ratio", "i", "伤害加深", 1],
        ["hurt_del_ratio", "i", "伤害减免", 1],
        ["hit_ratio", "i", "命中几率", 1],
        ["dodge_ratio", "i", "躲闪几率", 1],
        ["crit_ratio", "i", "致命几率", 1],
        ["uncrit_ratio", "i", "抗暴几率", 1],
        ["abs_att", "i", "元素攻击", 0],
        ["abs_def", "i", "元素防御", 0],
        ["hurt_float_ratio", "i", "会心几率", 1],
        ["skill_hurt_add_ratio", "i", "技能伤害", 1],
        ["skill_hurt_del_ratio", "i", "技能减免", 1],
        ["crit_hurt_add_ratio", "i", "暴击加深", 1],
        ["crit_hurt_del_ratio", "i", "暴击减免", 1],
        ["parry_ratio", "i", "格挡几率", 1],
        ["overload_ratio", "i", "过载几率", 1],
        ["parry", "i", "招架", 1],
        ["neglect", "i", "忽视", 1],
        ["HearHurtAddRatio", "i", "会心伤害", 1],
        ["HearHurtDelRatio", "i", "会心减免", 1],
        ["DefHearHurtRatio", "i", "抗会心率", 1],
        ["att_add_ratio", "i", "攻击加成", 1],
        ["hp_add_ratio", "i", "气血加成", 1],
        ["wreck_add_ratio", "i", "破甲加成", 1],
        ["def_add_ratio", "i", "防御加成", 1],
        ["hit_add_ratio", "i", "命中加成", 1],
        ["dodge_add_ratio", "i", "闪避加成", 1],
        ["crit_add_ratio", "i", "暴击加成", 1],
        ["ten_add_ratio", "i", "坚韧加成", 1],
        ["draconic_sacred", "i", "神圣龙语", 0],
        ["draconic_tspace", "i", "时空龙语", 0],
        ["draconic_rule", "i", "法则龙语", 0],
        
        ["ex_ratio", "i", "", 0],
        ["unex_ratio", "i", "", 0],
        ["ex_hurt_add_ratio", "i", "", 0],
        ["unex_hurt_del_ratio", "i", "", 0],
        ["armor", "i", "", 0],
        ["undizzy_ratio", "i", "", 0],
        ["unedef_ratio", "i", "", 0],
        ["fixed_att", "i", "", 0],
        ["fixed_def", "i", "", 0],
        ["pvp_att_add","i","",1],
        ["pvp_att_reduece","i","",1],
        ["real_abs_att", "i", "绝对攻击", 0],
        ["real_abs_def", "i", "绝对防御", 0]
    ];
    public constructor() {
    }
    public ReadFmt(target) {
        let user_msg_adapter = UserMsgAdapter.GetInstance();
        BaseAttrProtoVo.pro_list.forEach((value: string[], index: number) => {
            target[<string>value[0]] = user_msg_adapter.ReadFmt(<string>value[1]);
        });
        return null;
    }
    //读取部分大于0的属性
    public ReadFmt2() {
        let user_msg_adapter = UserMsgAdapter.GetInstance(), result = [], len: number = user_msg_adapter.ReadFmt("h"), key: number, vo: Array<any>;
        for (let i = 0; i < len; i++) {
            key = user_msg_adapter.ReadFmt("c");
            vo = BaseAttrProtoVo.pro_list[key - 1];
            let obj;
            if (!vo) {
                obj.vo[0] = user_msg_adapter.ReadFmt(vo[1]);
                result.push(obj);
            }
        }
        return result;
    }
}

window["BaseAttrProtoVo"] = BaseAttrProtoVo