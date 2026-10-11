import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { RoleVo } from "../sharedata/RoleVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, RefBoxChildsLayout, RefGridLayout, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class DungeonDragonRecordItem extends BaseItem1 {
	model
	need_refresh_data
	role_model
	vo


	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonRecordItem"
		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		SetHtmlStyle(this._lb_fight,{c:"#ffffff",f:18,ww:false,w:234})
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_role, GameResPath.GetIcon("dungeonDragon", "ui_copy_35"), true)
		this.InitEvent()
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, EventName.GET_ROLE_FIGURE_INFO_RETURN, (scmd13013?) => {
			if ((this.vo && !this.vo.none) && scmd13013.player_id == this.vo.role_id) {
				// let role_res = GetRoleClotheTextureId(scmd13013)
				// let wing_res = GetFigureId(scmd13013.figure_list, FigureProtoVo.FigureType.Wing)
				// let back_ornament_res = GetFigureId(scmd13013.figure_list, FigureProtoVo.FigureType.BackOrnament)
				// let weapon_res = GetWeaponClotheId(scmd13013)
				// // [ts2lua]lua中0和空字符串也是true，此处back_ornament_res != nil需要确认
				// wing_res = (back_ornament_res != null && ( back_ornament_res ) || ( wing_res ) )
				// this.CreateModel(role_res, weapon_res, wing_res)
				this.CreateModel(scmd13013)
			}
		}
		)
	}

	public SetData(vo?) {

		this.vo = vo
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {

		let vo = this.vo
		let bool = vo.none ? true : false
		this._gp_role.visible = !bool
		this._img_role.visible = bool
		if (!bool) {
			this._lb_fight.innerHTML = `战力：${HtmlColorTxt(vo.power+"","'#ffc573'")}`
			this._lb_name.color="#ffe6bb"
			this._lb_name.text = `S${vo.server_num }.${vo.name}`
			GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13013, "hlh", this.vo.server_id, this.vo.role_id, 610)

			
			let start_x=(this._box1.width-(this._img_leader.width+this._lb_fight.contextWidth+5))/2
			this._img_leader.x=start_x
			this._lb_fight.x=start_x+this._img_leader.width+5
		} else {
			this._lb_name.color="#ffffff"
			this._lb_name.text = "虚位以待"
		}
	}

	// function DungeonDragonRecordItem.CreateModel(role_res, weapon_res, wing_res)
	public CreateModel(role_vo?) {

		this.ClearModel()
		if (!role_vo) {
			return
		}
		let mainVo = RoleManager.GetInstance().GetMainRoleVo()
		let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
		let weapon_model_id, weapon_texture_id = Util.GetWeaponClotheId(role_vo)
		let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
		// let head_model_id = Util.GetRoleHeadId(role_vo)
		// let head_clothe_id =0
		let hair_id = 0//mainVo.GetRoleHairId(role_vo.fashion_model_list)
		let call_back = () => {
			//this.CoverMode(this._gp_widget)
		}
		let data = {
			career : role_vo.career,
			sex : role_vo.sex,

			clothe_res_id : model_id,
			fashion_model_id: model_id, //暂时屏蔽一下时装
			weapon_res_id : weapon_model_id,
			texture_id : texture_id,

			weapon_clothe_id : weapon_texture_id,

			wing_id :Util.GetWingClotheId(role_vo),
			back_ornament_id :Util.GetBackOrnamentId(role_vo),
			head_wear_id : head_id,
			head_clothe_id :head_texture_id,

			hair_id : hair_id,

			type : UI_MODEL_TYPE.MAINROLE,
			layer_value : this.layer_value,
			scale : 1,
			load_call_back : call_back,
			liveness_id : role_vo.liveness_id,
			layout_file : this.layout_file
		}
		ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
	}

	public ClearModel() {
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
	}

	public DeleteMe() {

		this.ClearModel()
		super.DeleteMe()
	}



_img_role:Laya.Image
_lb_name:Laya.Label
_gp_role:Laya.Box
_gp_model:Laya.Box
_box1:Laya.Box
_lb_fight:Laya.HTMLDivElement
_img_leader:Laya.Image
public GetComponents() {
[
this._img_role,
this._lb_name,
this._gp_role,
this._gp_model,
this._box1,
this._lb_fight,
this._img_leader,
]
 = this.GetChildrenByNames([

"_img_role",
"_lb_name",
"_gp_role",
"_gp_model",
"_box1",
"_lb_fight",
"_img_leader",
])
}
}
 window["DungeonDragonRecordItem"]= DungeonDragonRecordItem