import { EventDispatcher } from "../util/EventDispatcher";
import { Config } from "../common/Config";
import { LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar";
import { SceneObj } from "../scene/sceneobj/SceneObj";
import { SceneBaseType } from "../scene/SceneConfig";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
// TypeScript file
export class NpcVo extends EventDispatcher {
    npc_id = 0; //类型ID(int32)
    type_id = 0
    name = ""; //名称(string)
    pos_x = 0; //X坐标(int16)
    pos_y = 0; //Y坐标(int16)
    logic_x = 0;
    logic_y = 0;
    model_id = ""; //资源ID(int32)
    task_icon = 0; //任务状态：0什么都没有，1可接任务，2有未完成任务，3可提交任务，4有任务相关
    talk = 0; //默认对话内容
    angle = -1; // 初始化的角度
    instance_id = 0;
    icon_scale = 1;
    y_off_for_body = 0;
    is_hide_hp = false;
    model = 0
    func_flag = ""
    realm = 0
    icon = 0
    icon_type = 0
    icon_res_type = 0
    head_icon = 0
    anima = ""
    dynamic_action_str = ""
    assign_angle = 0
    weapon_id = 0
    texture_id = 0
    model_scale = 0

    static IconType2SceneType = {
        "0":SceneBaseType.Npc,//NPC
        "1":SceneBaseType.Monster,//怪物
        "2":SceneBaseType.Partner,//神巫
        "3":SceneBaseType.Sprite,//侍魂
        "4":SceneBaseType.Horse,//坐骑
        "5":SceneBaseType.Demon,//妖灵
        "6":SceneBaseType.God,//降神
        "7":SceneBaseType.Baby,//宝宝
        "8":SceneBaseType.Guard,//守护神
    }

    static IconType2UIType = {
        "0":UI_MODEL_TYPE.NPC,//NPC
        "1":UI_MODEL_TYPE.MONSTER,//怪物
        "2":UI_MODEL_TYPE.PARTNER,//神巫
        "3":UI_MODEL_TYPE.SPRITE,//侍魂
        "4":UI_MODEL_TYPE.HORSE,//坐骑
        "5":UI_MODEL_TYPE.DEMON,//妖灵
        "6":UI_MODEL_TYPE.GOD,//降神
        "7":UI_MODEL_TYPE.BABY,//宝宝
        "8":UI_MODEL_TYPE.GUARD,//守护神
    }
    public constructor() {
        super();
    }
    public CreateNpcInfo(baseInfo) {
        if (baseInfo == null)
            return;
        let npc_id = baseInfo.npc_id ? baseInfo.npc_id : 0;
        let npc_config = Config.PRELOAD_SERVER_CONFIG.config_npc[npc_id];
        if (npc_config == null)
            return;
        this.npc_id = npc_id; //类型ID(int32)
        // this.name = npc_config.name;
        // this.pos_x = baseInfo.x || baseInfo.pos_x; //X坐标(int16)
        // this.pos_y = baseInfo.y || baseInfo.pos_y; //Y坐标(int16)
        // this.logic_x = this.pos_x / LogicRealRatio_X;
        // this.logic_y = this.pos_y / LogicRealRatio_Y;
        // this.model_id = npc_config.icon; //资源ID(int32)
        // this.talk = npc_config.talk; //默认对话内容
        // this.angle = npc_config.angle;
        // this.is_hide_hp = baseInfo.is_hide_hp;
        // this.icon_scale = npc_config.icon_scale || 1;


        this.instance_id = npc_id	//唯一标识(int32)
        this.type_id = npc_id		//类型ID(int32)
        this.name = (npc_config.name).trim()			//名称(string)
        this.pos_x = baseInfo.x || baseInfo.pos_x		//X坐标(int16)
        this.pos_y = baseInfo.y	|| baseInfo.pos_y		//Y坐标(int16)
        this.logic_x = this.pos_x / SceneObj.GetLogicRealRatio().x
        this.logic_y = this.pos_y / SceneObj.GetLogicRealRatio().y
        this.model = npc_config.icon			//资源ID(int32)
        this.func_flag = npc_config.func		//功能(int8)
        this.realm = npc_config.realm		//国家(int8)
        this.icon = npc_config.icon
        this.icon_type = npc_config.icon_type

        this.icon_res_type = NpcVo.IconType2SceneType[this.icon_type] || 0
        // this.icon = 100101
        this.head_icon = npc_config.image		//Npc头像(int32)
        this.talk = npc_config.talk          //默认对话内容
        this.anima = npc_config.anima
        this.dynamic_action_str = baseInfo.args || ""
        this.assign_angle = npc_config.brith_rot || - 1
        this.weapon_id = npc_config.arm_id
        this.texture_id = npc_config.icon_texture || 0
        this.model_scale = Number(npc_config.icon_scale)

    // if GodClothesResId[this.model] then
        //     this.weapon_id = this.model
        //     this.wing_id = this.model
        // end
    }
    public GetRoleClotheId() {
        return this.model_id;
    }
}

window["NpcVo"] = NpcVo