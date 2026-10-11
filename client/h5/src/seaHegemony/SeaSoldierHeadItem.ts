import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class SeaSoldierHeadItem extends BaseItem1 {

    SetData
    needRefresh
    CreateModel
    ClearModel
    cur_model
    data
    InitEvent
    public constructor(parent?) {
        super(parent)

        this.base_file = "seaHegemony"
        this.layout_file = "SeaSoldierHeadItem"
        this.load_callback = () => {
            this.InitEvent()
            this.cur_model=""
            if (this.needRefresh) {
                this.SetData(this.data)
            }
            
        }

        this.SetData = (data?) => {
            this.data = data
            if (this.is_loaded) {
                this.needRefresh = false
                let title = null
                if (data.role_id!=null) {
                    this.nameLb.text = data.role_name
                    this._Image1.visible=this.noImg.visible = false
                    title = data.self_level - 1
                    GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, 13015, "hlh", data.server_id, data.role_id, 186)
                } else {
                    this.ClearModel()
                    this.nameLb.text = "虚位以待"
                    this._Image1.visible=this.noImg.visible = true
                    title = data.index-1

                    ResManager.GetInstance().SetOutsideImageSprite(this,this._Image1,GameResPath.GetIconOtherPath("country","uikf1vn_003"))
                    ResManager.GetInstance().SetOutsideImageSprite(this,this.noImg,GameResPath.GetIconOtherPath("country","ui_shzb_021"))
                }
                let sp_name = "ui_shzb_02" + (5 + title) 
                ResManager.GetInstance().SetImageSprite(this, this.titleImg, "seaHegemony", sp_name, true)
                ResManager.GetInstance().SetImageSprite(this,this._Image2,"country","ui_role_title_bg1")
            } else {
                this.needRefresh = true
            }
        }


        this.InitEvent=()=>{
            this.BindEvent(
                GuildFightModel.GetInstance(),
                GuildFightEvent.UPDATE_REQUEST_FIGURE_2, (scmd?) => {
                    if (scmd.model_id != 186||!this.data||this.data.role_id!=scmd.role_id) {
                        return
                    }
                    this.CreateModel(scmd.figure)
                }
            )
        }


        this.CreateModel = (role_vo?) => {

			if (!role_vo) {
				return
			}

			if (this.cur_model == role_vo.name) {
				return
			}
			this.cur_model = role_vo.name

			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			let weapon_model_id = Util.GetWeaponClotheId(role_vo)
            let weapon_texture_id = 0
            let wing_id = Util.GetWingClotheId(role_vo)
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)
			let liveness_id = Util.GetLivenessId(role_vo)

			let data = {
                type: UI_MODEL_TYPE.MAINROLE,
				career: role_vo.career,
				sex: role_vo.sex,
                layer_value: this.layer_value,
				scale: 0.75,
                position: new Vector3(0, 2.4, 0),

				clothe_res_id: model_id,
				fashion_model_id: model_id,
				texture_id: texture_id,

				head_wear_id: head_id,
				head_clothe_id: head_texture_id,

				weapon_res_id: weapon_model_id,
				weapon_clothe_id: weapon_texture_id,
				
				wing_id: wing_id,
				back_ornament_id: back_ornament_id,
				liveness_id: liveness_id
				
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
		}

		this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}



    }

    public DeleteMe() {
        this.ClearModel()
        super.DeleteMe()
    }



_Image1:Laya.Image
_Image2:Laya.Image
noImg:Laya.Image
titleImg:Laya.Image
nameLb:Laya.Label
_gp_model:Laya.Box
public GetComponents() {
[
this._Image1,
this._Image2,
this.noImg,
this.titleImg,
this.nameLb,
this._gp_model,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"noImg",
"titleImg",
"nameLb",
"_gp_model",
])
}
}
 window["SeaSoldierHeadItem"]= SeaSoldierHeadItem