import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionX, HtmlColorTxt } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class DungeonDragonRoleItem extends BaseItem1 {
	ChangeState
	ClearModel
	CreateModel
	Emp_gp_btn
	InitEvent
	LoadSuccess
	SetData
	UpdateMatchEffect
	UpdateView

	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonRoleItem"
		let model = BaseDungeonModel.GetInstance()
		let team_model = TeamModel.GetInstance()

		let local_TeamEvent = TeamEvent
		let vo_ = null
		let activity_id_ = null
		let dun_id_ = null
		let need_refresh_data_ = null
		let role_model_ = null
		let state_ = null
		this.load_callback = () => {
			this.PreHtml()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_add, GameResPath.GetIcon("dungeonDragon", "ui_copy_35"))
			this.BindEvent(
				team_model,
				local_TeamEvent.UPDATE_MATCH_STATE, () => {
					this.UpdateMatchEffect()
				}
			)
			this.InitEvent()
			if (need_refresh_data_) {
				this.UpdateView()
				need_refresh_data_ = false
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this._img_add, (e?) => {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonDragonClumpView", dun_id_)
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._gp_btn, (e?) => {
					switch (state_) {
						case 1:
							if (vo_) {
								team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24009, "l", vo_.id)
							}
							break;
						default:
							team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24005)
							break;
					}
				}, this, true)

		}

		this.SetData = (vo?, activity_id?, dun_id?) => {
			vo_ = vo
			activity_id_ = activity_id
			dun_id_ = dun_id
			if (this.is_loaded) {
				this.UpdateView()
			} else {
				need_refresh_data_ = true
			}
		}

		this.UpdateView = () => {
			let vo = vo_
			let bool = vo.none ? true : false
			this._gp_role.visible = !bool
			this._img_add.visible = bool
			this._img_join.visible = false
			if (!bool) {
				this._lb_fight.innerHTML =Util.StrToHTML(`战力：${ HtmlColorTxt(`${vo.power}`,"'#ffd154'")}`)
				this._lb_fight.style.width=180
				this._lb_name.text = `S${vo.server_num}.${vo.name}`    //"S" + vo.server_num + "." + vo.name

				this.CreateModel(vo)

				this._img_leader.visible = team_model.IsLeaderInTeam(vo.id)
				this._img_help.visible = vo.help_type == 1
				this._img_assist.visible = vo.help_type == 2
				if (team_model.InShowJoinID(activity_id_)) {
					this._img_join.visible = true
					//this._img_join.source = team_model.joinImage(activity_id_, vo.join_value)
					let sp_name = team_model.joinImage(activity_id_, vo.join_value)
					ResManager.GetInstance().SetImageSprite(this, this._img_join, "dungeonPolar_asset", sp_name, true, () => {
						//LayoutRebuilder(this._lb_name)
						SetAnchoredPositionX(this._img_join, this._lb_name.x - 5)
					})
				}
			}
			let main_role_id = RoleManager.GetInstance().GetMainRoleId()
			if (vo.id == main_role_id) {
				state_ = 0
			} else if (team_model.IsLeaderInTeam(main_role_id) && vo.id != main_role_id) {
				state_ = 1
			} else {
				state_ = 2
			}
			this.ChangeState()
			this.UpdateMatchEffect()
		}

		this.UpdateMatchEffect = () => {
			let bool = vo_.none && team_model.GetAutoMatch()
			if (bool) {
				//this.AddUIEffect2("ui_matching", this._gp_effect, null, null, true)
			} else {
				this.ClearUIEffect(this._gp_effect)
			}
		}

		this.ChangeState = () => {
			switch (state_) {
				case 1:
					this._gp_btn.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_btn, "common", "ui_button_rect14", false)
					this._lb_btn.text = "踢出队伍"
					this._lb_btn.color="#3e9298"
					break;
				case 2:
					this._gp_btn.visible = false
					break;
				default:
					this._gp_btn.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_btn, "common", "ui_button_rect11", false)
					this._lb_btn.text = "退出队伍"
					this._lb_btn.color="#a51c1c"
					break;
			}
		}

		this.CreateModel = (role_vo?) => {

			if (!role_vo) {
				return
			}
			//let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
			let weapon_model_id, weapon_texture_id = Util.GetWeaponClotheId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			let liveness_id = Util.GetLivenessId(role_vo)
			let wing_id = Util.GetWingClotheId(role_vo)
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)


			let data = {
				career : role_vo.career,
				sex : role_vo.sex,
				type : UI_MODEL_TYPE.MAINROLE,
				scale:0.58,
				position : new Vector3(0.15, 2.2, 0),

				clothe_res_id : model_id,
				fashion_model_id: model_id,
				texture_id : texture_id,

				head_wear_id : head_id,
				head_clothe_id :head_texture_id,

				weapon_res_id : weapon_model_id,
				weapon_clothe_id : weapon_texture_id,
				
				wing_id :wing_id,
				liveness_id : liveness_id,
				back_ornament_id :back_ornament_id,
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
		}

		this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}


	}


	public DeleteMe(){
		this.ClearModel()
		this.ClearUIEffect(this._gp_effect)
		super.DeleteMe()
	}

    PreHtml(){
        this._lb_fight.style.fontSize=18
        this._lb_fight.style.color="#ffffff"
        this._lb_name.width=180
    }

	

_img_add:Laya.Image
_gp_effect:Laya.Box
_gp_role:Laya.Box
_gp_model:Laya.Box
_gp_widget:Laya.Box
_gp_btn:Laya.Box
_img_btn:Laya.Image
_lb_btn:Laya.Label
_img_leader:Laya.Image
_img_help:Laya.Image
_img_assist:Laya.Image
_lb_fight:Laya.HTMLDivElement
_Group1:Laya.Box
_lb_name:Laya.Label
_img_join:Laya.Image
public GetComponents() {
[
this._img_add,
this._gp_effect,
this._gp_role,
this._gp_model,
this._gp_widget,
this._gp_btn,
this._img_btn,
this._lb_btn,
this._img_leader,
this._img_help,
this._img_assist,
this._lb_fight,
this._Group1,
this._lb_name,
this._img_join,
]
 = this.GetChildrenByNames([

"_img_add",
"_gp_effect",
"_gp_role",
"_gp_model",
"_gp_widget",
"_gp_btn",
"_img_btn",
"_lb_btn",
"_img_leader",
"_img_help",
"_img_assist",
"_lb_fight",
"_Group1",
"_lb_name",
"_img_join",
])
}
}
 window["DungeonDragonRoleItem"]= DungeonDragonRoleItem