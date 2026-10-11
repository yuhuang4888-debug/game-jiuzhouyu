import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { RoleManager } from "../commonModel/RoleManager";
// TypeScript file
export class OtherVo extends EventDispatcher {
    vo_type = SceneBaseType.Other;
    pos_x = 0; //X坐标(int16)
    pos_y = 0; //Y坐标(int16)
    instance_id = 0; //怪物唯一标识(int32)
    name = ""; //怪物名字(string)
    model_res = 0; //资源(int32)
    effect_res = ""; //特效资源(string)
    move_speed = 160; //怪物速度(int16)
    can_pick = 1; //是否可点击（0否 1是）
    prePoseState = PoseState.STAND;
    poseState = PoseState.STAND;
    owner_team_id;
    owner_player_id;
    public constructor() {
        super();
    }
    public ReadFromProtocal() {
        [this.pos_x,
            this.pos_y,
            this.instance_id,
            this.name,
            this.model_res,
            this.effect_res,
            this.move_speed,
            this.can_pick,
            this.owner_team_id,
            this.owner_player_id] = //所属玩家id
            UserMsgAdapter.GetInstance().ReadFmt("hhisishcll");
        console.log("篝火==========：", this.owner_team_id, this.owner_player_id, RoleManager.Instance.mainRoleInfo.role_id);
    }
}

window["OtherVo"] = OtherVo