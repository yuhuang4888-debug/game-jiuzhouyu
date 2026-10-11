import { BaseClass } from "../common/BaseClass"

export class DemonEvent extends BaseClass {
    public static REQUEST_PROTO = "DemonEvent.REQUEST_PROTO"
    public static UPDATE_DEMON_DATA = "DemonEvent.UPDATE_DEMON_DATA"
    public static UPDATE_DEMONS_LIST = "DemonEvent.UPDATE_DEMONS_LIST"
    public static UPDATE_PAINTING_DATA = "DemonEvent.UPDATE_PAINTING_DATA"
    public static UPDATE_FETTERS_DATA = "DemonEvent.UPDATE_FETTERS_DATA"
    public static UPDATE_SKILL_DATA = "DemonEvent.UPDATE_SKILL_DATA"
    public static LEVEL_UP_SUCCESS = "DemonEvent.LEVEL_UP_SUCCESS"
    public static UPDATE_DEMONS_POWER = "DemonEvent.UPDATE_DEMONS_POWER"
    public static REFRESH_RED_FLAG = "DemonEvent.REFRESH_RED_FLAG"
    public static TALENT_FIGHT_RETURN = "DemonEvent.TALENT_FIGHT_RETURN"
    public static TALENT_UP_RETURN = "DemonEvent.TALENT_UP_RETURN"
    public static TALENT_SHOP_DATA_RETURN = "DemonEvent.TALENT_SHOP_DATA_RETURN"
    public static TALENT_SHOP_BUY_RETURN = "DemonEvent.TALENT_SHOP_BUY_RETURN"
    public static GETREWARD = "DemonEvent.GETREWARD"
    public static REF_ROTARY_RED = "DemonEvent.REF_ROTARY_RED"
    public static ACTIVE_DEMON = "DemonEvent.ACTIVE_DEMON"//激活
    public static ACTIVE_DEMON_SKILL = "DemonEvent.ACTIVE_DEMON_SKILL"//技能激活成功
}
window["DemonEvent"] = DemonEvent