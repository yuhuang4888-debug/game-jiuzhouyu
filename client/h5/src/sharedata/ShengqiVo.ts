import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { Role } from "../scene/sceneobj/Role";
import { SceneManager } from "../scene/SceneManager";
import { MaskModel } from "../commonModel/MaskModel";

export class ShengqiVo extends EventDispatcher {
    vo_type = SceneBaseType.Shengqi;
    shengqi_id = 0; //圣器ID(int32)
    name = ""; //名字(string)

    pos_x = 0; //X像素坐标(int16)
    pos_y = 100; //Y像素坐标(int16)
    hp = 100; //当前hp(int32)
    maxHp = 100; //最大hp(int32)
    move_speed = 160; //速度(int16)
    ghost_mode = 0;
    hide_flag = 0; //是否不可见(int8)
    warGroup = 0; //战斗分组(int8)
    model_id = 0; //模型id
    texture_res = 0; //贴图
    poseState = PoseState.STAND;
    birth_angle = 90; //出生角度
    owner_id = 0; //所属玩家id
    owner_vo;
    team_id;
    offset_height = 100        // 默认高度
    
    public constructor() {
        super();
    }
    public SetVo(owner_vo) {
        let self = this;
        
        self.owner_vo = owner_vo;
        if (self.owner_vo) {
            self.warGroup = self.owner_vo.warGroup;
            self.team_id = self.owner_vo.team_id;
            self.name = owner_vo.name + "的神器";
            self.shengqi_id = MaskModel.GetInstance().GetMaskFlowerId(self.owner_vo, FigureProtoVo.FigureType.Shengqi);
            self.move_speed = owner_vo.move_speed
        }
    }

    public GetTextureId() {
        return this.shengqi_id
    }

    public InMaskState() {
		return this.owner_vo.mask_id > 0 && SceneManager.GetInstance().CanMaskScene()
	}

    public DeleteMe() {
        super.DeleteMe();
    }
}

window["ShengqiVo"] = ShengqiVo