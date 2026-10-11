import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { SceneManager } from "../scene/SceneManager";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { RoleManager } from "../commonModel/RoleManager";
import { Config } from "../common/Config";
import { MaskModel } from "../commonModel/MaskModel";
// TypeScript file
export class PartnerVo extends EventDispatcher {
    vo_type = SceneBaseType.Partner;
    pos_x = 0; //X像素坐标(int16)
    pos_y = 0; //Y像素坐标(int16)
    partner_id = 0; //用户ID(int32)
    hp = 100; //当前hp(int32)
    maxHp = 100; //最大hp(int32)
    name = ""; //玩家名(string)
    level = 0; //等级(int16)
    move_speed = 160; //玩家速度(int16)
    five_element = 0; //五行
    ghost_mode = 0;
    show_base_info_only = false; //nameBoard只显示名字和血条
    hide_flag = 0; //是否不可见(int8)
    warGroup = 0; //战斗分组(int8)
    level_model_list = []; //列表衣服武器id
    texture_res = 0; //贴图
    poseState = PoseState.STAND;
    birth_angle = 90; //出生角度
    ower_id = 0; //所属玩家id
    //
    owner_vo;
    team_id;
    public constructor() {
        super();
    }
    public SetVo(owner_vo) {
        let self = this;
        self.owner_vo = owner_vo
        if(self.owner_vo){
            this.warGroup = self.owner_vo.warGroup
            this.team_id = self.owner_vo.team_id
            // if(PlatformManager.IsEyouIdnPlatform())
            //     this.name = "Fae " + owner_vo.name
            // else
                this.name = owner_vo.name +  "的神巫"
            
            self.partner_id = MaskModel.GetInstance().GetMaskFlowerId(self.owner_vo,FigureProtoVo.FigureType.Partner)
        }    
    }
    
    public GetTextureId() {
        return this.partner_id
    }

    public InMaskState() {
		return this.owner_vo.mask_id > 0 && SceneManager.GetInstance().CanMaskScene()
	}
}

window["PartnerVo"] = PartnerVo