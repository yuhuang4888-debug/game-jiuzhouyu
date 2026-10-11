import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BabyModel } from "../commonModel/BabyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class BabyChangedView extends BaseView1 {
    private baby_model
    private data
    private model = BabyModel.GetInstance()
    //0表示培养的 1 表示幻化的
    private type

    //function
    InitView
    SetModel
    ClearEffect
    ClearModel
    public constructor() {
        super()
        this.base_file = "baby"
        this.layout_file = "BabyChangedView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.background_alpha = 1
        this.is_center = true
        this.click_bg_toClose = true
        let res_mgr = ResManager.GetInstance()
        let config_baby_figure
        let local_resMgr = ResManager.GetInstance()
        this.preload_client_config = {
            "ClientBaby": false
        }
        this.preload_server_config = {
            "config_baby_figure":false
        }
        this.load_callback = function () {
            local_resMgr.SetOutsideImageSprite(this, this.table_img, GameResPath.GetIcon("pet", "uixxxjs_001"), true)
            this.InitView()
        }
        this.open_callback = function () {
            SoundManager.GetInstance().PlaySoundEffect("3_huode")
        }
        this.destroy_callback = function () {
            this.ClearModel()
            this.ClearEffect()
            this.data = undefined
            ResManager.GetInstance().ClearRoleMode(this.hashCode)
        }
        this.Open = (data?) => {
            this.data = data
            this.InitView()
            super.Open()
        }

        this.InitView = () => {
            config_baby_figure = res_mgr.GetGameConfigFromCache(this, "config_baby_figure", false)

            if (this.data == undefined || !this.is_loaded) {
                return
            }
            // res_mgr.SetTexture(this, this.table_img, "resource/game/baby/texture/uixxxjs_001.png")
            this.SetModel()
            // this.AddUIEffect("ui_image_arrary", this.image_arrary_group, undefined, undefined, true)
            // this.AddUIEffect("ui_image_bigglow", this.image_bigglow_group, undefined, undefined, true)
            // this.AddUIEffect("ui_image_particle", this.image_particle_group, undefined, undefined, true)
            // this.AddUIEffect("ui_image_text", this.image_text_group, undefined, undefined, false, undefined, () => {

            // }, undefined, this)

            Util.AddClickEvent(this._box_click, () => {
				this.Close()
			}, this, false)

        }

        this.SetModel = () => {
            this.model_group.visible = true
            if (!this.is_loaded) {
                return
            }
            let cfg = res_mgr.GetGameConfigFromCache(this, "ClientBaby", true)
            let resCfg = config_baby_figure[this.data]
            let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)
            let modelCfg = cfg[model_res]
            let scale =(modelCfg && modelCfg.scale) ? modelCfg.scale.x : 1.5
            let data = {
                clothe_res_id: model_res,
                type: UI_MODEL_TYPE.BABY,
                scale: scale,
                position: {x:0,y:1.5},
                action_name_list: ["show"] //action_name_list: ["idle"]
            }
            ResManager.GetInstance().SetRoleModel(this, this.model_group, data)


            this.name_label.text = resCfg ? resCfg.baby_name_con : `宝宝`
        }

        this.ClearEffect = () => {
            this.ClearUIEffect(this.image_text_group)
            this.ClearUIEffect(this.image_particle_group)
            this.ClearUIEffect(this.image_bigglow_group)
            this.ClearUIEffect(this.image_arrary_group)
        }

        this.ClearModel = () => {
            if (this.baby_model) {
                this.baby_model.DeleteMe()
                this.baby_model = null
            }
        }
    }

    public DeleteMe(){
        super.DeleteMe()
    }


table_img:Laya.Image
effect_group:Laya.Box
image_text_group:Laya.Box
tipstext:Laya.Label
image_bigglow_group:Laya.Box
success_image:Laya.Image
image_arrary_group:Laya.Box
_box_click:Laya.Box
model_group:Laya.Box
image_particle_group:Laya.Box
image_name:Laya.Image
name_label:Laya.Label
public GetComponents() {
[
this.table_img,
this.effect_group,
this.image_text_group,
this.tipstext,
this.image_bigglow_group,
this.success_image,
this.image_arrary_group,
this._box_click,
this.model_group,
this.image_particle_group,
this.image_name,
this.name_label,
]
 = this.GetChildrenByNames([

"table_img",
"effect_group",
"image_text_group",
"tipstext",
"image_bigglow_group",
"success_image",
"image_arrary_group",
"_box_click",
"model_group",
"image_particle_group",
"image_name",
"name_label",
])
}
}
 window["BabyChangedView"]= BabyChangedView