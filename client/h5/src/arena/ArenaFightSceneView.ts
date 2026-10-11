import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { MainUIController } from "../commonController/MainUIController"
import { ArenaModel } from "../commonModel/ArenaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDelta, Util, SetSizeDeltaX, GlobalTimerQuest } from "../util/Util"

export class ArenaFightSceneView extends BaseView1 {
	_Group4: Laya.Box
	_Image1: Laya.Image
	_img_0_hp: Laya.Image
	_Image6: Laya.Image
	_img_0_head: Laya.Image
	_img_vip_bg: Laya.Image
	_img_0_vip: Laya.Image
	_lb_0_hp: Laya.Label
	_lb_0_fighting: Laya.Label
	_lb_0_name: Laya.Label
	_img_title_bg: Laya.Image
	_img_vs: Laya.Image
	_Group8: Laya.Box
	_Image4: Laya.Image
	_img_1_hp: Laya.Image
	_Image61: Laya.Image
	_img_1_head: Laya.Image
	_img_vip_bg_1: Laya.Image
	_img_1_vip: Laya.Image
	_lb_1_hp: Laya.Label
	_lb_1_fighting: Laya.Label
	_lb_1_name: Laya.Label
	_gp_fight_effect_con: Laya.Box
	_gp_vs_effect_con: Laya.Box
	_img_skip: Laya.Image
	_gp_count_time: Laya.Box
	_Image7: Laya.Image
	_lb_count_time: Laya.Label
	_img_exit: Laya.Image
	_bit_time_down: Laya.Label
	_lb_lv_0: Laya.Label
	_lb_lv_1: Laya.Label
	_fight_con: Laya.Box
	_img_7: Laya.Image
	_img_71: Laya.Image
	CancelFightTime
	GetNextFrameUpdate
	InitEvent
	LoadSuccess
	OnTime
	Remove
	SetNextFrameUpdate
	StartFightTime
	Update
	UpdateRoleInfo
	UpdateView
	_end_time
	_next_frame_update
	_update_id
	back_login_toClose
	close_callback
	destroy_imm
	head_0
	head_1
	interval
	is_center
	need_refresh_role
	open_callback
	role_vo_list
	scene_mgr
	time_id
	timeout_list
	run_id
	public constructor() {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		// this.is_center = true
		this.back_login_toClose = true

		this.timeout_list = []
		this._next_frame_update = false
		this.role_vo_list = null
		this.need_refresh_role = null
		this.time_id = null
		this.interval = null
		this._end_time = null
		this._update_id = null
		this.head_0 = null
		this.head_1 = null
		let voice
		this.scene_mgr = SceneManager.GetInstance()

		let model = ArenaModel.GetInstance()
		let local_ArenaModel = ArenaModel
		let local_TimeUtil = TimeUtil
		let role_mgr = RoleManager.GetInstance()
		let scene_mgr = Scene.GetInstance()
		let runner = Runner.GetInstance()

		this.load_callback = () => {
			this.display_obj.centerX = 0
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			// SetSizeDelta(this.form, 0, 0)
			this.AddUIEffect("effect_daojishi_01", this._gp_fight_effect_con, null, 5, false, null, null, () => {
				ArenaModel.GetInstance().Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28018)
			})
			// ResManager.GetInstance().SetUIEffect(this,"UI_1126", this.layer_value, this._gp_vs_effect_con, null, 1, true)
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_ArenaModel.UPDATE_FIGHT_INFO, (stage?, time?) => {
				if (stage == 0) {
					let left_time = time - local_TimeUtil.getServerTime()
					let id = setTimeout(() => {
						if (!this.use_delete_method) {
							// this.AddUIEffect("effect_daojishi_01", this._gp_fight_effect_con, null, 5, true)
						}
					}, time - local_TimeUtil.getServerTime())
					table.insert(this.timeout_list, id)

					voice = CommonManager.GetInstance().PlayFightingVoice(3)

				} else if (stage == 1) {
					this._gp_count_time.visible = true
					this.StartFightTime(time)

				} else if (stage == 2) {
					this.CancelFightTime()
					this._gp_count_time.visible = false

				}
			}
			)

			this.BindVar(model, "rolesData", (event_name?, value?) => {
				let role_list = this.scene_mgr.GetAllRoleVos()
				if (!this.role_vo_list) {
					this.role_vo_list = []
				}
				for (let key in role_list) {

					let vo = role_list[key]
					let role_id = vo.role_id
					if (role_id == value.self_robot_id) {
						this.role_vo_list[0] = vo
						this.role_vo_list[0].role_id = value.self_role_id
					} else if (role_id == value.rival_robot_id) {
						this.role_vo_list[1] = vo
						this.role_vo_list[1].role_id = value.rival_role_id
					}
				}
				if (Util.TableSize(this.role_vo_list) == 2) {
					if (this.is_loaded) {
						this.UpdateRoleInfo()
					} else {
						this.need_refresh_role = true
					}
				}
			}
			)

			let onAddRoleHandler = (role_id?, role_vo?) => {
				if (role_id == role_mgr.mainRoleInfo.role_id) {
					return
				}

				let rolesData = model.GetRolesData()
				if (!this.role_vo_list) {
					this.role_vo_list = []
				}
				if (rolesData) {
					if (role_id == rolesData.this_robot_id) {
						this.role_vo_list[0] = role_vo
						this.role_vo_list[0].role_id = rolesData.self_role_id
					} else if (role_id == rolesData.rival_robot_id) {
						this.role_vo_list[1] = role_vo
						this.role_vo_list[1].role_id = rolesData.rival_role_id
					}
				}
				if (Util.TableSize(this.role_vo_list) == 2) {
					if (this.is_loaded) {
						this.UpdateRoleInfo()
					} else {
						this.need_refresh_role = true
					}
				}
			}
			this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, onAddRoleHandler)

			Util.AddClickEvent(this._img_skip, () => {
				if (this.scene_mgr.IsArenaFightScene()) {
					model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28015)
				}
			}, this, true)

			Util.AddClickEvent(this._img_exit, () => {
				let ok_callback = () => {
					model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 65306)
				}

				Alert.Show("提前离开会被判为挑战失败，是否继续离开", Alert_Type.Two, ok_callback)
			}, this, true)
		}

		this.UpdateView = () => {
			if (this.scene_mgr.IsArenaFightScene()) {
				model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28013)
			}
			let id = setTimeout(() => {
				MainUIController.GetInstance().SetHeadVisible(false)
			}, 0.5)
			table.insert(this.timeout_list, id)
			if (this.need_refresh_role) {
				this.UpdateRoleInfo()
			}
		}

		this.Remove = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}

			//if (this.interval ) {
			//clearInterval(this.interval)
			//}
			if (this.timeout_list.length > 0) {
				for (let _tmpi in this.timeout_list) {
					var id = this.timeout_list[_tmpi]
					clearTimeout(id)
				}
				this.timeout_list = []
			}
			this.CancelFightTime()
			for (let i = 0; i <= 1; i++) {
				if (this["head_" + i]) {
					this["head_" + i].DeleteMe()
					this["head_" + i] = null
				}
			}
			this.role_vo_list = null
		}

		this.UpdateRoleInfo = () => {
			for (let key in this.role_vo_list) {

				let vo = this.role_vo_list[key]
				// this["_lb_" + key + "_hp"].text = vo.hp + "/" + vo.maxHp
				this["_lb_" + key + "_name"].text = vo.name

				let _lb_lv = this["_lb_lv_" + key]
				_lb_lv.text = vo.level > 370 ? vo.level - 370 : vo.level
				_lb_lv.color = vo.level > 370 ? "#fee54a" : "#ffffff"
				_lb_lv.strokeColor = vo.level > 370 ? "#76218b" : "#484253"
				let lv_bg = vo.level > 370 ? "mainui_head_circle_purple" : "mainui_head_circle_blue"
				if (Number(key) == 0) {
					ResManager.GetInstance().SetImageSprite(this, this._img_7, "mainUI", lv_bg)
					//this._Image7.y = -3
				} else {
					ResManager.GetInstance().SetImageSprite(this, this._img_71, "mainUI", lv_bg)
				}




				if (this["head_" + key] == null) {
					this["head_" + key] = new CustomHeadItem(this["_img_" + key + "_head"])
					this["head_" + key].SetActiveLevel(false)
					if (key == "1") {
						this["head_" + key].SetLevelReverse()
					}
					this["head_" + key].Load()
				}
				this["head_" + key].SetRoleVoData(vo)

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
				ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI", source)

				// if(vo.is_hide_vip > 0){
				// 	ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI_asset", "VIP-x", true)
				// }
				// else{
				// 	ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI_asset", "uivip_zjm_" + vo.vip_flag, true)
				// }

				this.BindVar(vo, "hp", (event_name?, value?) => {
					// this["_lb_" + key + "_hp"].text = value + "/" + vo.maxHp
					SetSizeDeltaX(this["_img_" + key + "_hp"], 182 * (value / vo.maxHp))
				}
				)
			}

			this["_lb_0_fighting"].text = String(role_mgr.GetMainRoleVo().fighting)
			this["_lb_1_fighting"].text = model.enemy_fight
			let count = 1
			for (let i = 0; i <= 10; i++) {
				if (model.enemy_fight < count * 10) {
					break
				} else {
					count *= 10
					this._fight_con.x += 10
				}
			}
			this.SetNextFrameUpdate(true)
		}

		//竞技场血条颜色处理
		this.Update = () => {
			if (this.GetNextFrameUpdate()) {
				let roleDatas = model.GetRolesData()
				let my_robot = scene_mgr.GetRole(roleDatas.self_robot_id)
				if (my_robot && my_robot.name_board) {
					my_robot.name_board.SetGreenBar()
				}
				let enemy_robot = scene_mgr.GetRole(roleDatas.rival_robot_id)
				if (enemy_robot && enemy_robot.name_board) {
					enemy_robot.name_board.SetRedBar()
				}
				this.SetNextFrameUpdate(false)
			}
		}

		this.StartFightTime = (end_time?) => {
			this.CancelFightTime()
			this._end_time = end_time
			this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1, -1)
			this.OnTime()
		}

		this.OnTime = () => {
			let left_time = this._end_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelFightTime()
				return
			}
			let time_str = local_TimeUtil.timeConvert8(left_time)
			this._lb_count_time.text = String(time_str)
		}

		this.CancelFightTime = () => {
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
		}

		this.GetNextFrameUpdate = () => {
			return this._next_frame_update
		}

		this.SetNextFrameUpdate = (value?) => {
			if (this._next_frame_update != value) {
				if (value) {
					this.run_id = runner.AddRunObj(this, 3)
				} else {
					runner.RemoveRunObj(this.run_id)
				}
				this._next_frame_update = value
			}
		}
	}
	public GetComponents() {
		[
			this._Group4,
			this._Image1,
			this._img_0_hp,
			this._Image6,
			this._img_0_head,
			this._img_vip_bg,
			this._img_0_vip,
			this._lb_0_hp,
			this._lb_0_fighting,
			this._lb_0_name,
			this._img_title_bg,
			this._img_vs,
			this._Group8,
			this._Image4,
			this._img_1_hp,
			this._Image61,
			this._img_1_head,
			this._img_vip_bg_1,
			this._img_1_vip,
			this._lb_1_hp,
			this._lb_1_fighting,
			this._lb_1_name,
			this._gp_fight_effect_con,
			this._gp_vs_effect_con,
			this._img_skip,
			this._gp_count_time,
			this._Image7,
			this._lb_count_time,
			this._img_exit,
			this._bit_time_down,
			this._lb_lv_0,
			this._lb_lv_1,
			this._fight_con,
			this._img_7,
			this._img_71
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_Image1",
				"_img_0_hp",
				"_Image6",
				"_img_0_head",
				"_img_vip_bg",
				"_img_0_vip",
				"_lb_0_hp",
				"_lb_0_fighting",
				"_lb_0_name",
				"_img_title_bg",
				"_img_vs",
				"_Group8",
				"_Image4",
				"_img_1_hp",
				"_Image61",
				"_img_1_head",
				"_img_vip_bg_1",
				"_img_1_vip",
				"_lb_1_hp",
				"_lb_1_fighting",
				"_lb_1_name",
				"_gp_fight_effect_con",
				"_gp_vs_effect_con",
				"_img_skip",
				"_gp_count_time",
				"_Image7",
				"_lb_count_time",
				"_img_exit",
				"_bit_time_down",
				"_lb_lv_0",
				"_lb_lv_1",
				"_fight_con",
				"_img_7",
				"_img_71"
			])
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_0_fighting, undefined, false)
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_1_fighting, undefined, false)
	}
}
window["ArenaFightSceneView"] = ArenaFightSceneView