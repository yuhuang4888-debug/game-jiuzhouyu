import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { ModelPartPos, RoleVo } from "../sharedata/RoleVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionX, HtmlColorTxt, RefBoxChildsLayout, SetHtmlStyle } from "../util/Util"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { table } from "../common/table"
import { Vector3 } from "../util/Vector3"

export class DungeonEquipRoleItem extends BaseItem1 {
	ChangeState
	ClearModel
	CreateModel
	Emp_gp_btn
	InitEvent
	LoadSuccess
	SetData
	UpdateMatchEffect
	UpdateView
	cur_model
	GetAwakeClothe
	GetModelId
	IsAwakeClothe
	dungeon_id
	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonEquip"
		this.layout_file = "DungeonEquipRoleItem"
		let model = BaseDungeonModel.GetInstance()
		let team_model = TeamModel.GetInstance()

		let local_TeamEvent = TeamEvent
		let local_Util = Util
		// to) { dxj 未移植
		//let arena_model = ArenaModel.GetInstance()
		let local_FigureProtoVo = FigureProtoVo
		let local_UI_MODEL_TYPE = UI_MODEL_TYPE
		let vo_ = null
		let activity_id_ = null
		let dun_id_ = null
		let need_refresh_data_ = null
		let role_model_ = null
		let state_ = null
		this.load_callback = () => {
			this.cur_model = ""
			SetHtmlStyle(this._lb_fight, { c: "#ffffff", f: 18, ww: false, w: 180 })
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {

			// if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
			// 	SetAnchoredPositionX(this._lb_fight,120)
			// }
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_fight_bg, GameResPath.GetIcon("mainUI", "new_fight_bg"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_add, GameResPath.GetIcon("dungeonEquip", "ui_copy_35"))
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
					let id = this.dungeon_id ? this.dungeon_id : dun_id_
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEquipClumpView", id)
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
			this._box_img.visible = false
			if (!bool) {
				this._lb_fight.innerHTML = Util.StrToHTML(`战力：${HtmlColorTxt(`${vo.power}`, "'#ffd154'")}`)
				this._lb_fight.style.width = 180
				this._lb_name.text = `S${vo.server_num}.${vo.name}`    //"S" + vo.server_num + "." + vo.name

				this.CreateModel(vo)

				this._img_leader.visible = team_model.IsLeaderInTeam(vo.id)
				this._img_help.visible = vo.help_type == 1
				this._img_assist.visible = vo.help_type == 2
				if (team_model.InShowJoinID(activity_id_)) {
					this._box_img.visible = true
					//this._img_join.source = team_model.joinImage(activity_id_, vo.join_value)
					let sp_name = team_model.joinImage(activity_id_, vo.join_value)
					ResManager.GetInstance().SetImageSprite(this, this._img_join, "dungeonPolar_asset", sp_name, true, () => {
						//LayoutRebuilder(this._lb_name)
						//SetAnchoredPositionX(this._img_join, this._lb_name.x - 5)
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

			RefBoxChildsLayout(this._Group1, 5)
			RefBoxChildsLayout(this._box_gp2, 5)

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
				case 1: //是队长 才有的权限
					this._lb_btn.visible = this._gp_btn.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_btn, "common", "ui_button_rect14", false)
					this._lb_btn.text = "踢出队伍"
					this._lb_btn.color = "#3e9298"
					this._lb_btn.visible = true
					break;
				case 2:
					this._lb_btn.visible = this._gp_btn.visible = false
					break;
				default:
					this._lb_btn.visible = this._gp_btn.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_btn, "common", "ui_button_rect11", false)
					this._lb_btn.text = "退出队伍"
					this._lb_btn.color = "#a51c1c"
					break;
			}
		}

		this.CreateModel = (role_vo?) => {

			if (!role_vo) {
				return
			}

			if (this.cur_model == role_vo.name) {
				return
			}
			this.cur_model = role_vo.name

			
			
			//普通时装
			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
			let weapon_model_id = Util.GetWeaponClotheId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			let liveness_id = Util.GetLivenessId(role_vo)
			let wing_id = Util.GetWingClotheId(role_vo)
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)

			let data = {
				career: role_vo.career,
				sex: role_vo.sex,
				type: UI_MODEL_TYPE.ROLE,
				scale:0.58,
				position : new Vector3(0.15, 2.2, 0),

				clothe_res_id: model_id,
				fashion_model_id: model_id,
				texture_id: texture_id,

				head_wear_id: head_id,
				head_clothe_id: head_texture_id,

				weapon_res_id: weapon_model_id,
				weapon_clothe_id: 0,
				
				wing_id: wing_id,
				back_ornament_id: back_ornament_id,
				liveness_id: liveness_id,
			}


			if (this.IsAwakeClothe(role_vo)) {
				let [awaken_fashion, head_model_id] = this.GetAwakeClothe(role_vo.career, role_vo.sex)
				data.clothe_res_id=awaken_fashion
				data.head_wear_id=head_model_id
			}


			ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)

		}

		this.IsAwakeClothe = (role_vo) => {
			let list = role_vo.figure_ride_list || []
			for (let i = 0; i < list.length; i++) {
				let obj = list[i]
				if (obj && obj.figure_type && obj.figure_type == 11) {
					return true
				}
			}

			return false
		}

		//觉醒时装
		this.GetAwakeClothe = (career, sex) => {
			let cfg_kv = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv
			//时装 武器等
			let [awaken_fashion, awaken_hallow, awaken_wing, awaken_artiface, awaken_mount] = this.GetModelId(career)
			//觉醒时装专用发型
			let head_model_id = Number(ErlangParser.GetInstance().Parse(cfg_kv[7].value)[sex - 1][1])
			return [awaken_fashion, head_model_id]//衣服、发型
		}

		this.GetModelId = (career) => {
			//let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_suit
			let cfg_chapter = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken
			let list = []
			for (let _ in cfg_chapter) {
				var v = cfg_chapter[_]
				table.insert(list, { chapter: v.chapter_id, model_id: cfg[v.chapter_id + "@" + career].figure_id })
			}
			table.sort(list, (a?, b?) => {
				return a.chapter < b.chapter
			})

			return [list[0] && list[0].model_id, list[1] && list[1].model_id, list[2] && list[2].model_id, list[3] && list[3].model_id, list[4] && list[4].model_id]

		}


		this.ClearModel = () => {
			// if (!role_model_) {
			// 	return
			// }
			// role_model_.DeleteMe()
			// role_model_ = null
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}


	}


	public DeleteMe() {
		this.ClearModel()
		this.ClearUIEffect(this._gp_effect)
		super.DeleteMe()
	}




	_img_add: Laya.Image
	_img_add2: Laya.Image
	_gp_effect: Laya.Box
	_gp_role: Laya.Box
	_gp_model: Laya.Box
	_gp_widget: Laya.Box
	_gp_btn: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	_Group1: Laya.Box
	_lb_name: Laya.Label
	_box_img: Laya.Box
	_img_join: Laya.Image
	_box_gp2: Laya.Box
	_lb_fight: Laya.HTMLDivElement
	_img_assist: Laya.Image
	_img_help: Laya.Image
	_img_leader: Laya.Image
	public GetComponents() {
		[
			this._img_add,
			this._img_add2,
			this._gp_effect,
			this._gp_role,
			this._gp_model,
			this._gp_widget,
			this._gp_btn,
			this._img_btn,
			this._lb_btn,
			this._Group1,
			this._lb_name,
			this._box_img,
			this._img_join,
			this._box_gp2,
			this._lb_fight,
			this._img_assist,
			this._img_help,
			this._img_leader,
		]
			= this.GetChildrenByNames([

				"_img_add",
				"_img_add2",
				"_gp_effect",
				"_gp_role",
				"_gp_model",
				"_gp_widget",
				"_gp_btn",
				"_img_btn",
				"_lb_btn",
				"_Group1",
				"_lb_name",
				"_box_img",
				"_img_join",
				"_box_gp2",
				"_lb_fight",
				"_img_assist",
				"_img_help",
				"_img_leader",
			])
	}
}
window["DungeonEquipRoleItem"] = DungeonEquipRoleItem