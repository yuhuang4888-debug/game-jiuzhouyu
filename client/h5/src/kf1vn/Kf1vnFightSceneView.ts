import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DressModel, DressType } from "../commonModel/DressModel"
import { GodBefallModel } from "../commonModel/GodBefallModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { RoleManager } from "../commonModel/RoleManager"
import { MainUISkillItemGod } from "../mainUI/MainUISkillItemGod"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Role } from "../scene/sceneobj/Role"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util, SetSizeDeltaX, SetSizeDeltaY } from "../util/Util"
import { Kf1vnRoleHpItem } from "./Kf1vnRoleHpItem"

//1vn战斗场景界面
export class Kf1vnFightSceneView extends BaseView1 {
	CheckVo
	ClearGodBtn
	ClearTimer
	CreateGodBtn
	GetVoFightting
	InitEvent
	IsChallenger
	LoadSuccess
	OpenCallback
	RfreshDefenderHp
	SetEnemyList
	SetHp
	SetLeftNum
	SetRoleInfo
	SetTimeText
	SetTimer
	Update
	UpdateRoleInfo
	UpdateTimer
	back_login_close
	destroy_callback
	destroy_imm
	open_callback
	role_head1
	role_head0
	_god_btn
	HideMainModel
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.back_login_close = true
		this.destroy_imm = true
		let model = Kf1vnModel.GetInstance()
		let runner = Runner.GetInstance()
		let scene = Scene.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let scene_mgr = SceneManager.GetInstance()
		let dress_model = DressModel.GetInstance()
		let data_ = null
		let timer_id_ = null
		let end_time_ = null
		let vo_list_ = null
		let leaderVo_ = null
		let rivalVo_ = null
		let hp_bind_list_ = null
		let enemy_item_list_ = null
		let timer_out_ = null
		let old_real_pos_fun_ = null
		let update_id_ = null
		let hp_change_event_id_ = null
		let defend_vo_ = null
		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			this.ClearTimer()
			let vo = null
			for (let id in hp_bind_list_) {

				vo = hp_bind_list_[id]
				if (vo) {
					vo.UnBind(id)
				}
			}
			hp_bind_list_ = null
			for (let _tmpi in enemy_item_list_) {
				var item = enemy_item_list_[_tmpi]
				item.DeleteMe()
			}
			enemy_item_list_ = null
			if (timer_out_) {
				clearTimeout(timer_out_)
				timer_out_ = null
			}
			if (update_id_) {
				runner.RemoveRunObj(update_id_)
				update_id_ = null
			}
			if (hp_change_event_id_ && defend_vo_) {
				defend_vo_.UnBind(hp_change_event_id_)
				hp_change_event_id_ = null
			}
			if (this.role_head0) {
				this.role_head0.DeleteMe()
				this.role_head0 = null
			}
			if (this.role_head1) {
				this.role_head1.DeleteMe()
				this.role_head1 = null
			}
			this.ClearGodBtn()
			let role: Role = Scene.GetInstance().main_role
			if (role) {
				role.SetModelHideFlag(SceneObj.ModelHideFlag.Arena, false)
				role.SetShadowVisible(true)
			}
			this.ClearUIEffect(this._group_eff)
		}

		this.LoadSuccess = () => {

			if (!model.GetMainUIVisible()) {
				model.SetMainUIVisible(model.GetMainUIVisible())
			}

			this.display_obj.top = Util.GetLiuhaiHeight() || 0

			hp_bind_list_ = []
			enemy_item_list_ = []
			leaderVo_ = null
			rivalVo_ = null
			defend_vo_ = null
			this.CreateGodBtn()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_exit, () => {
				if (data_ && (data_["isPart"] == null || data_["isPart"] == true)) {
					Alert.Show("确定要离开比赛么，本场战斗结果您可能会被判负？", Alert_Type.Two, () => {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62107)
					}
					)
				} else {
					model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62107)
				}
			}
				, this, true)

			let onAddRoleHandler = (role_id?, role_vo?) => {
				if (!data_) {
					return
				}
				let mainVo = RoleManager.GetInstance().GetMainRoleVo()
				if (!mainVo) {
					return
				}
				let data = null
				if (data_.battle_list) {
					rivalVo_ = role_vo
					this.UpdateRoleInfo(1)
				} else if (data_.challenger_list) {
					let type = null
					let is_challenger = this.IsChallenger()
					if (!leaderVo_) {
						if (is_challenger) {
							if (role_id == mainVo.role_id) {
								leaderVo_ = role_vo
								type = 0
							}
						} else {
							if (data_.player_id == role_id) {
								leaderVo_ = role_vo
								type = 0
							}
						}
					}
					if (!rivalVo_) {
						if (is_challenger) {
							if (data_.player_id == role_id) {
								rivalVo_ = role_vo
								type = 1
							}
						} else {
							if (!rivalVo_ && data_["isPart"] == false) {
								rivalVo_ = role_vo
								type = 1
							}
						}
					}
					let id = role_vo.BindOne("hp", (varName?, value?) => {
						if (value <= 1) {
							this.CheckVo()
							this.SetLeftNum()
						}
					}
					)
					hp_bind_list_[id] = role_vo
					if (type != null) {
						this.UpdateRoleInfo(type)
					}
					this.SetLeftNum()
				}
				model.DeleteNotPlayerRole()



			}


			this.BindEvent(GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_RES_LOAD_COMPLETE, () => {
				this.HideMainModel(true)
			})


			this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, onAddRoleHandler)

			this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_REMOVE, () => {
				if (data_ && data_.challenger_list) {
					this.CheckVo()
					this.SetLeftNum()
				}
			}
			)

			let refresh_defender_hp_fun = (defender?) => {
				this.RfreshDefenderHp(defender)
			}
			this.BindEvent(model, Kf1vnEvent.KF1VN_REFRESH_DEFENDER_HP, refresh_defender_hp_fun)

			let set_fun = () => {
				this.OpenCallback()
			}
			this.BindVar(model, "ticket_fighting_info", set_fun)
			this.BindVar(model, "leader_fighting_info", set_fun)
			this.BindVar(model, "stage_info", set_fun)
		}

		this.Update = (now_time?, elapse_time?) => {
			// if (leaderVo_ ) {
			// 	let leader = scene.GetRole(leaderVo_.role_id)
			// 	if (leader ) {
			// 		let pos_x, pos_y = leader.GetRealPos()
			// 		MainCamera.GetInstance().SetPos(pos_x, pos_y)
			// 	}
			// }
		}

		this.OpenCallback = () => {
			let sInfo = model.stage_info
			if (sInfo) {
				if (sInfo.stage == 3) {
					data_ = model.ticket_fighting_info
					if (!data_) {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62105)
					}
				} else if (sInfo.stage == 5) {
					data_ = model.leader_fighting_info
					if (!data_) {
						model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62112)
					}
				}
			}
			if (!data_) {
				return
			}
			// this.display_obj.visible = false
			// if (timer_out_) {
			// 	clearTimeout(timer_out_)
			// 	timer_out_ = null
			// }
			// let leftTime = data_.loading_time - TimeUtil.getServerTime()
			// if (leftTime > 1) {
			// 	timer_out_ = setTimeout(() => {
			// 		if (!this.use_delete_method) {
			// 			auto_fight_mgr.SetAutoFight(true)
			// 			this.display_obj.visible = true
			// 		}
			// 	}
			// 		, leftTime)
			// } else {
			// 	auto_fight_mgr.SetAutoFight(true)
			// 	this.display_obj.visible = true
			// }

			this.SetTimer(data_)
			//this.AddUIEffect("ui_fight_vs", this._group_eff, null, 1, true)
			this.SetRoleInfo()
			this.SetEnemyList()
			this.SetLeftNum()
			this.is_viewing.visible = model.is_vistor == true
			model.DeleteNotPlayerRole()


			this.HideMainModel(true)
		}

		this.SetTimer = (info?) => {
			this.ClearTimer()
			end_time_ = info.battle_time
			this.SetTimeText(end_time_ - TimeUtil.getServerTime())

			let time_fun = () => {
				this.UpdateTimer()
			}
			timer_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
			time_fun()
		}

		this.UpdateTimer = () => {
			let rtime = end_time_ - TimeUtil.getServerTime()
			if (rtime < 0) {
				this._lb_time.text = "已结束"
				auto_fight_mgr.SetAutoFight(false)
				this.ClearTimer()
			} else {
				this.SetTimeText(rtime)
			}
		}

		this.SetTimeText = (rtime?) => {
			this._lb_time.text = (rtime <= 0 && ("已结束") || (TimeUtil.timeConvert(rtime, "mm:ss")))
		}

		this.ClearTimer = () => {
			if (timer_id_) {
				GlobalTimerQuest.CancelQuest(timer_id_)
				timer_id_ = null
			}
		}

		this.SetRoleInfo = () => {
			if (!data_) {
				return
			}
			this.CheckVo()
		}

		this.CheckVo = () => {
			if (!data_) {
				return
			}
			vo_list_ = []
			if (data_.battle_list) {
				if (!leaderVo_) {
					leaderVo_ = RoleManager.GetInstance().GetMainRoleVo()
				}
				if (!rivalVo_) {
					let vo = null
					let i = 0
					do {
						vo = data_.battle_list[i]
						if (vo.player_id != RoleManager.GetInstance().GetMainRoleVo().role_id) {
							let roleVo = scene_mgr.GetRoleVo(vo.player_id)
							if (roleVo) {
								rivalVo_ = roleVo
								break
							}
						}
						i = i + 1
					} while ((i < data_.battle_list.length))
				}
			} else if (data_.challenger_list) {
				let mainVo = RoleManager.GetInstance().GetMainRoleVo()
				let is_challenger = this.IsChallenger()
				if (!leaderVo_) {
					if (data_.player_id == mainVo.role_id) {
						leaderVo_ = mainVo
					} else {
						if (is_challenger) {
							leaderVo_ = mainVo
						} else {
							let roleVo = scene_mgr.GetRoleVo(data_.player_id)
							if (roleVo) {
								leaderVo_ = roleVo
							}
						}
					}
				}
				if (!rivalVo_) {
					if (is_challenger) {
						let roleVo = scene_mgr.GetRoleVo(data_.player_id)
						if (roleVo) {
							rivalVo_ = roleVo
						}
					} else {
						let vo = null
						let i = 0
						do {
							vo = data_.challenger_list[i]
							if (data_["isPart"] == false) {
								let roleVo = scene_mgr.GetRoleVo(vo.player_id)
								if (roleVo && roleVo.hp > 1) {
									rivalVo_ = roleVo
									break
								}
							}
							i = i + 1
						} while ((i < data_.challenger_list.length))
					}
				}
			}
			if (leaderVo_) {
				this.UpdateRoleInfo(0)
			}
			if (rivalVo_) {
				this.UpdateRoleInfo(1)
			}
		}

		this.IsChallenger = () => {
			let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let vo = null
			let is_challenger = false
			if ((mainVo && data_) && data_.challenger_list) {
				let i = 0
				do {
					vo = data_.challenger_list[i]
					if (vo && vo.player_id == mainVo.role_id && data_.player_id != mainVo.role_id) {
						is_challenger = true
						break
					}
					i = i + 1
				} while ((i < data_.challenger_list.length))
			}
			return is_challenger
		}

		this.UpdateRoleInfo = (_type?) => {
			let vo = (_type == 0 && (leaderVo_) || (rivalVo_))
			if (vo) {

				this["_lb_" + _type + "_hp"].text = vo.hp + "/" + vo.maxHp
				SetSizeDeltaX(this["_img_" + _type + "_hp"], 182 * (vo.hp / vo.maxHp))

				this["_lb_" + _type + "_fighting"].text = this.GetVoFightting(vo.role_id)
				//let frame_id = dress_model.GetDressByType(data_.dress_list, DressType.Photo)

				this["_lb_" + _type + "_name"].text = vo.name

				let _lb_lv = this["_lb_lv_" + _type]
				_lb_lv.text = vo.level > 370 ? vo.level - 370 : vo.level
				_lb_lv.color = vo.level > 370 ? "#fee54a" : "#ffffff"
				_lb_lv.strokeColor = vo.level > 370 ? "#76218b" : "#484253"
				let lv_bg = vo.level > 370 ? "mainui_head_circle_purple" : "mainui_head_circle_blue"
				if (Number(_type) == 0) {
					ResManager.GetInstance().SetImageSprite(this, this._img_7, "mainUI", lv_bg)
				} else {
					ResManager.GetInstance().SetImageSprite(this, this._img_71, "mainUI", lv_bg)
				}





				if (this["head_" + _type] == null) {
					this["head_" + _type] = new CustomHeadItem(this["_img_" + _type + "_head"])
					this["head_" + _type].SetActiveLevel(false)
					if (_type == 1) {
						this["head_" + _type].SetLevelReverse()
					}
					this["head_" + _type].Load()
				}
				this["head_" + _type].SetRoleVoData(vo)
				
				let source
				if(vo.is_hide_vip > 0){
					source = "VIP-x"
					if (vo.supreme_vip == 1) {
						source = "SVIP-x"
					}
				}
				else{
					source = "uivip_zjm_" + vo.vip_flag
					if (vo.supreme_vip == 1) {
						source = "VIP_" + vo.vip_flag
					}
				}
				ResManager.GetInstance().SetImageSprite(this, this["_img_" + _type + "_vip"], "mainUI_asset", source)
				
				// ResManager.GetInstance().SetImageSprite(this, this["_img_" + _type + "_vip"], "mainUI_asset", "uivip_zjm_" + vo.vip_flag, true)


				this.BindVar(vo, "hp", (event_name?, value?) => {
					if (this["_lb_" + _type + "_hp"]) {
						this["_lb_" + _type + "_hp"].text = value + "/" + vo.maxHp
						SetSizeDeltaX(this["_img_" + _type + "_hp"], 182 * (value / vo.maxHp))
					}
				}
				)
				if (_type == 0 && data_["isPart"] == false) {
					if (!update_id_) {
						update_id_ = runner.AddRunObj(this, 1)
					}
				}
			}
		}

		this.SetEnemyList = () => {
			if (data_ && data_.challenger_list) {
				this.role_conta.visible = true
				let vo = null
				let item = null
				let i = 0
				do {
					vo = data_.challenger_list[i]
					item = enemy_item_list_[i]
					if (!item) {
						item = new Kf1vnRoleHpItem(this.Content)
						enemy_item_list_[i] = item
						item.Load()
					}
					item.SetData(vo)
					i = i + 1
				} while ((i < data_.challenger_list.length))
				SetSizeDeltaY(this.Content, data_.challenger_list.length * 25)
			} else {
				this.role_conta.visible = false
			}
		}

		this.SetLeftNum = () => {
			let num = 0
			if (data_ && data_.challenger_list) {
				let role = null
				for (let _tmpi in data_.challenger_list) {
					var vo = data_.challenger_list[_tmpi]
					role = scene_mgr.GetRoleVo(vo.player_id)
					if (role && role.hp > 1) {
						num = num + 1
					}
				}
				this.left_role_num.text = num + "/" + data_.challenger_list.length
			}
		}

		this.RfreshDefenderHp = (vo?) => {
			if ((data_ && vo) && data_.challenger_list) {
				let role_vo = vo.GetVo()
				if (role_vo && role_vo.role_id != data_.player_id) {
					this._group_1_role.visible = true
					this._lb_1_name.text = role_vo.name
					this._lb_1_fighting.text = this.GetVoFightting(role_vo.role_id)
					let frame_id = dress_model.GetDressByType(data_.dress_list, DressType.Photo)
					if (!this.role_head1) {
						this.role_head1 = new CustomHeadItem(this._img_1_head)
						this.role_head1.CloseClick()
						this.role_head1.Load()
					}
					this.role_head1.SetRoleVoData(role_vo)
					ResManager.GetInstance().SetImageSprite(this, this._img_1_vip, "mainUI_asset", "uivip_zjm_" + role_vo.vip_flag)
					this.SetHp(role_vo.hp, role_vo.maxHp)
					if (!defend_vo_ || defend_vo_.role_id != role_vo.role_id) {
						if (hp_change_event_id_ && defend_vo_) {
							defend_vo_.UnBind(hp_change_event_id_)
							hp_change_event_id_ = null
							defend_vo_ = null
						}
						defend_vo_ = role_vo
						hp_change_event_id_ = defend_vo_.BindOne("hp", (varName?, value?) => {
							this.SetHp(defend_vo_.hp, defend_vo_.maxHp)
						}
						)
					}
				}
			}
		}

		this.SetHp = (hp?, maxHp?) => {
			if (this._lb_1_hp && this._img_1_hp) {
				this._lb_1_hp.text = hp + "/" + maxHp
				SetSizeDeltaX(this["trans_img_1_hp"], 195 * hp / maxHp)
			}
		}

		this.GetVoFightting = (role_id?) => {
			let fighting = 0
			if (role_id == RoleManager.GetInstance().mainRoleInfo.role_id) {
				fighting = RoleManager.GetInstance().mainRoleInfo.fighting
			} else {
				let vo_list = data_.battle_list
				if (data_.challenger_list) {
					vo_list = data_.challenger_list
					if (role_id == data_.player_id) {
						fighting = data_.combat_power
					}
				}
				if (vo_list && fighting == 0) {
					for (let _tmpi in vo_list) {
						var vo = vo_list[_tmpi]
						if (vo.player_id == role_id) {
							fighting = vo.combat_power
							break
						}
					}
				}
			}
			return String(fighting)
		}

		this.CreateGodBtn = () => {
			//这个是在战场里面用的
			if (GodBefallModel.GetInstance()._cur_battle_id) {
				this._god_btn = new MainUISkillItemGod(this._gp_god)
				this._god_btn.Load()
				this._god_btn.SetVisible(true)
			}
		}

		this.ClearGodBtn = () => {
			if (this._god_btn) {
				this._god_btn.DeleteMe()
				this._god_btn = null
			}
		}


		this.HideMainModel = (boo) => {
			if (scene_mgr.IsKf1vnFightVistorScene()) {
				let role: Role = Scene.GetInstance().main_role
				if (role) {
					role.SetModelHideFlag(SceneObj.ModelHideFlag.Arena, boo)
					role.SetShadowVisible(!boo)
				}
			}
		}
	}

	public Open(...new_args) {

		super.Open()
	}
	public DeleteMe() {
		super.DeleteMe()
	}


	_btn_exit: Laya.Image
	time_conta: Laya.Box
	_Image1_k: Laya.Image
	_lb_time: Laya.Label
	_group_1_role: Laya.Box
	_Image4: Laya.Image
	_img_1_hp: Laya.Image
	_Image61: Laya.Image
	_img_1_head: Laya.Image
	_img_vip_bg_1: Laya.Image
	_img_1_vip: Laya.Image
	_lb_1_hp: Laya.Label
	_lb_1_name: Laya.Label
	_img_71: Laya.Image
	_lb_lv_1: Laya.Label
	_fight_con: Laya.HBox
	_img_fight1: Laya.Image
	_lb_1_fighting: Laya.Label
	_group_0_role: Laya.Box
	_Image1: Laya.Image
	_img_0_hp: Laya.Image
	_Image6: Laya.Image
	_img_0_head: Laya.Image
	_img_vip_bg: Laya.Image
	_img_7: Laya.Image
	_lb_lv_0: Laya.Label
	_img_0_vip: Laya.Image
	_img_fight: Laya.Image
	_lb_0_hp: Laya.Label
	_lb_0_fighting: Laya.Label
	_lb_0_name: Laya.Label
	_group_eff: Laya.Box
	role_conta: Laya.Box
	left_bg: Laya.Image
	_Image2_title2: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	_Image10: Laya.Image
	left_role_num: Laya.Label
	shopBtn: Laya.Image
	_click_mask: Laya.Image
	is_viewing: Laya.Label
	_gp_god: Laya.Box
	public GetComponents() {
		[
			this._btn_exit,
			this.time_conta,
			this._Image1_k,
			this._lb_time,
			this._group_1_role,
			this._Image4,
			this._img_1_hp,
			this._Image61,
			this._img_1_head,
			this._img_vip_bg_1,
			this._img_1_vip,
			this._lb_1_hp,
			this._lb_1_name,
			this._img_71,
			this._lb_lv_1,
			this._fight_con,
			this._img_fight1,
			this._lb_1_fighting,
			this._group_0_role,
			this._Image1,
			this._img_0_hp,
			this._Image6,
			this._img_0_head,
			this._img_vip_bg,
			this._img_7,
			this._lb_lv_0,
			this._img_0_vip,
			this._img_fight,
			this._lb_0_hp,
			this._lb_0_fighting,
			this._lb_0_name,
			this._group_eff,
			this.role_conta,
			this.left_bg,
			this._Image2_title2,
			this._Scroller1,
			this.Content,
			this._Image10,
			this.left_role_num,
			this.shopBtn,
			this._click_mask,
			this.is_viewing,
			this._gp_god,
		]
			= this.GetChildrenByNames([

				"_btn_exit",
				"time_conta",
				"_Image1_k",
				"_lb_time",
				"_group_1_role",
				"_Image4",
				"_img_1_hp",
				"_Image61",
				"_img_1_head",
				"_img_vip_bg_1",
				"_img_1_vip",
				"_lb_1_hp",
				"_lb_1_name",
				"_img_71",
				"_lb_lv_1",
				"_fight_con",
				"_img_fight1",
				"_lb_1_fighting",
				"_group_0_role",
				"_Image1",
				"_img_0_hp",
				"_Image6",
				"_img_0_head",
				"_img_vip_bg",
				"_img_7",
				"_lb_lv_0",
				"_img_0_vip",
				"_img_fight",
				"_lb_0_hp",
				"_lb_0_fighting",
				"_lb_0_name",
				"_group_eff",
				"role_conta",
				"left_bg",
				"_Image2_title2",
				"_Scroller1",
				"Content",
				"_Image10",
				"left_role_num",
				"shopBtn",
				"_click_mask",
				"is_viewing",
				"_gp_god",
			])
	}
}
window["Kf1vnFightSceneView"] = Kf1vnFightSceneView