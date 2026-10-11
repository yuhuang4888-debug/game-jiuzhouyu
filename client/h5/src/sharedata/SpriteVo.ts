import { EventDispatcher } from "../util/EventDispatcher";
import { SceneBaseType } from "../scene/SceneConfig";
import { PoseState } from "../util/StateMachineManager";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { RoleManager } from "../commonModel/RoleManager";
import { Config } from "../common/Config";
import { SceneManager } from "../scene/SceneManager";
import { MaskModel } from "../commonModel/MaskModel";
// TypeScript file
export class SpriteVo extends EventDispatcher {
    vo_type = SceneBaseType.Sprite;

    pos_x = 0; //X像素坐标(int16)
    pos_y = 0; //Y像素坐标(int16)
    hp = 100; //当前hp(int32)
    maxHp = 100; //最大hp(int32)
    name = ""; //名字(string)
    move_speed = 160; //速度(int16)
    ghost_mode = 0;
    hide_flag = 0; //是否不可见(int8)
    warGroup = 0; //战斗分组(int8)
    sprite_id = 0; //精灵ID(int32)
    model_id = 0; //模型id
    texture_res = 0; //贴图
    poseState = PoseState.STAND;
    birth_angle = 90; //出生角度
    owner_id = 0; //所属玩家id
    owner_vo;
    team_id;
    
    public constructor() {
        super();
    }
    public SetVo(owner_vo) {
        let self = this;
        self.owner_vo = owner_vo;
        if (self.owner_vo) {
            self.warGroup = this.owner_vo.warGroup;
            self.team_id = this.owner_vo.team_id;
            self.name = owner_vo.name + "的精灵";
            self.sprite_id = MaskModel.GetInstance().GetMaskFlowerId(self.owner_vo,FigureProtoVo.FigureType.Sprite)
        }
    }
    public GetSpriteClotheId() {
        // if(ClientConfig.alpha_mode){
        //     let alpha_sprite = IOSShiledConfig.AlphaSpriteId
        //     if(alpha_sprite&&alpha_sprite!=""){
        //         return Number(alpha_sprite) || this.sprite_id
        //     }
        // }
        return this.sprite_id
    }

    public GetTextureId(){
        if(Number(this.texture_res) != 0)
		return this.GetSpriteClotheId() + "_" + this.texture_res
    }
    public InMaskState() {
		return this.owner_vo.mask_id > 0 && SceneManager.GetInstance().CanMaskScene()
	}

}

window["SpriteVo"] = SpriteVo