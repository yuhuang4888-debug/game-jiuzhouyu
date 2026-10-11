import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { RoleManager } from "../commonModel/RoleManager";
import { DemonModel } from "../commonModel/DemonModel";

/**
 * 使魔vo
 */
export class DemonVo extends EventDispatcher {
    /**
     * vo 类型
     */
    vo_type = SceneBaseType.Demon;
    /**
     * X像素坐标(int16)
     */
    pos_x = 0
    /**
     * Y像素坐标(int16)
     */
    pos_y = 0
    /**
     * 当前hp(int32)
     */
    hp = 100
    /**
     * 最大hp(int32)
     */
    maxHp = 100
    /**
     * 名字(string)
     */
    name = "妖灵"
    /**
     * 速度(int16)
     */
    move_speed = 160
    /**
     * 
     */
    ghost_mode = 0;
    /**
     * 是否不可见(int8)
     */
    hide_flag = 0; 
    /**
     * 战斗分组(int8)
     */
    warGroup = 0
    /**
     * 使魔id
     */
    demon_id = 0
    /**
     * 模型id
     */
    model_id = 0
    /**
     * 贴图
     */
    texture_res = 0
    /**
     * 当前状态
     */
    poseState = PoseState.STAND
    /**
     * 出生角度
     */
    birth_angle = 90
    /**
     * 所属玩家id
     */
    owner_id = 0
    /**
     * 所属玩家vo
     */
    owner_vo
    /**
     * 所属队伍id
     */
    team_id;

    public constructor() {
        super();
    }

    public ReadFromProtocal() {
    }

    public SetVo(owner_vo) {
        this.owner_vo = owner_vo
        if(this.owner_vo){
            this.warGroup = this.owner_vo.warGroup
            this.team_id = this.owner_vo.team_id
            this.name = owner_vo.name + "的妖灵"
            this.demon_id = owner_vo.demon_id
            this.model_id = DemonModel.GetInstance().GetResource(owner_vo.demon_id)
        }
    }
    public GetTextureId() {
        return this.model_id
    }
}
window["DemonVo"] = DemonVo