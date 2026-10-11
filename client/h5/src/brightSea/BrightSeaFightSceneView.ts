import { BaseView1 } from "../common/BaseView1"
import { SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDelta, Util, Trim, SetSizeDeltaX, GlobalTimerQuest } from "../util/Util"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"

export class BrightSeaFightSceneView extends BaseView1 {
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
	enemy_role_id
	interval
	is_center
	level_0_img
	level_0_img1
	level_1_img
	level_1_img1
	my_role_id
	need_refresh_role
	need_refresh_role_vo
	open_callback
	role_updated
	role_vo_list
	scene_mgr
	time_id
	timeout_list

	public constructor() {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.is_center = true
		this.back_login_toClose = true

		this.timeout_list = []
		this._next_frame_update = false
		this.role_vo_list = null
		this.need_refresh_role = null
		this.time_id = null
		this.interval = null
		this._end_time = null
		this._update_id = null
		this.scene_mgr = SceneManager.GetInstance()

		let model = BrightSeaModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let role_mgr = RoleManager.GetInstance()
		let runner = Runner.GetInstance()
		let scene = Scene.GetInstance()
		let pick_up_cnt = 0
		let pick_up_max = 0
		let pick_up_diamond_num = 0
		let voice

		this.load_callback = () => {

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

			// this.AddUIEffect("UI_1126", this._gp_vs_effect_con, null, 1, true)
		}

		this.InitEvent = () => {
			this.BindEvent(model, BrightSeaEvent.UPDATE_FIGHT_INFO, (stage?, time?) => {
				if (stage == 1) {
					let left_time = time - local_TimeUtil.getServerTime()
					let id = setTimeout(() => {
						if (!this.use_delete_method) {
							//this.AddUIEffect("UI_1125", this._gp_fight_effect_con, null, null, true)
						}
					}, time - local_TimeUtil.getServerTime())
					table.insert(this.timeout_list, id)


				} else if (stage == 2) {
					voice = CommonManager.GetInstance().PlayFightingVoice(3)
					this._gp_count_time.visible = true
					this.StartFightTime(time)
				} else if (stage == 3) {
					this.CancelFightTime()
					this._gp_count_time.visible = false

				}
			}
			)

			let onAddRoleHandler = (role_id?, role_vo?) => {
				if (this.is_loaded) {
					this.UpdateRoleInfo(role_vo)
				} else {
					this.need_refresh_role = true
					this.need_refresh_role_vo = role_vo
				}
			}
			this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, onAddRoleHandler)

			this.BindEvent(GlobalEventSystem, SceneEventType.REQUEST_PICK_UP_SCENE_DROP, (drop_id?, show_type?) => {
				// 钻石
				if (show_type == 3) {
					if (pick_up_cnt <= pick_up_max) {
						let show_num = Mathf.Floor(pick_up_diamond_num / pick_up_max)
						if (pick_up_cnt == pick_up_max) {
							show_num = show_num + (pick_up_diamond_num - (show_num * pick_up_cnt))
						}
						Message.show("获得 绑定勾玉 x " + show_num)
					}
				}
			})

			this.BindEvent(GlobalEventSystem, SceneEventType.PICK_UP_END, () => {
				if (this.scene_mgr.IsBrightSeaScene()) {
					model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaBattleResultView")
				}
			})

			this.BindEvent(model, BrightSeaEvent.BATTLE_RESULT, () => {

				// 失败不掉落
				if (model.result_info.res != 1) {
					model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaBattleResultView")
					return
				}

				let reward_info = model.result_info.reward
				let cnt = 0
				let style
				let typeId
				for (let _ in reward_info) {
					var info = reward_info[_]
					if (info.typeId == 35) {
						cnt = cnt + info.count
						style = info.style
						typeId = info.typeId
					}
				}

				let num = Mathf.Floor(Mathf.Max(4, cnt / 10))

				pick_up_cnt = 0
				pick_up_diamond_num = cnt
				pick_up_max = num

				if (num > 0) {
					let list = []
					for (let i = 0; i < num; i++) {
						table.insert(list, { style: style, typeId: typeId, count: cnt })//{ style: style, typeId: typeId })
					}
					let role = scene.GetRole(this.enemy_role_id)
					if (role) {
						Util.ShowDrop(list, { x: role.real_pos.x, y: role.real_pos.y })
						Laya.timer.once(1500, this, () => {
							model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaBattleResultView")
						})
					} else {
						model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaBattleResultView")
					}
				} else {
					model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaBattleResultView")
				}
			}


			)

			//AddClickEvent(this._img_skip,() => {
			//		if (this.scene_mgr.IsArenaFightScene() ) {
			//			model.Fire(BrightSeaEvent.REQUEST_CCMD_EVENT, 28015)
			//		}
			//	}, this, true)
		}

		this.UpdateView = () => {
			if (!this.need_refresh_role_vo && !this.role_updated && this.scene_mgr.IsBrightSeaScene()) {
				let role_list = this.scene_mgr.GetAllRoleVos()
				for (let key in role_list) {
					this.need_refresh_role_vo = role_list[key]
					break
				}
				// let num = Util.TableSize(role_list)
				// if (num > 0) {
				// 	this.need_refresh_role_vo = table.shift(role_list)//role_list[next(role_list)]
				// }
			}

			//if (this.need_refresh_role ) {
			this.UpdateRoleInfo(this.need_refresh_role_vo)
			//}
		}


		this.Remove = () => {
			Laya.timer.clearAll(this)
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			//if (this.interval ) {
			//clearInterval(this.interval)
			//}
			this.role_updated = null
			this.need_refresh_role_vo = null
			if (this.timeout_list.length > 0) {
				for (let _tmpi in this.timeout_list) {
					var id = this.timeout_list[_tmpi]
					clearTimeout(id)
				}
				this.timeout_list = []
			}
			this.CancelFightTime()
			this.role_vo_list = null
		}

		this.UpdateRoleInfo = (role_vo?) => {
			//if (! role_vo ) {
			//	return 
			//}
			let main_vo = RoleManager.GetInstance().GetMainRoleVo()
			let list
			if (role_vo) {
				list = [main_vo, role_vo]
				this.enemy_role_id = role_vo.role_id
				this.role_updated = true
			} else {
				list = [main_vo]
			}
			this.my_role_id = main_vo.role_id
			this.role_vo_list = list

			for (let i = 0; i < this.role_vo_list.length; i++) {

				let key = i
				let vo = this.role_vo_list[key]


				this["_lb_" + key + "_name"].text = vo.name
				let _lb_lv = this["_lb_lv_" + key]
				_lb_lv.text = vo.level>370?vo.level - 370:vo.level
				_lb_lv.color = vo.level > 370 ? "#fee54a" : "#ffffff"
				_lb_lv.strokeColor = vo.level > 370 ? "#76218b" : "#484253"
				let lv_bg=vo.level>370?"mainui_head_circle_purple":"mainui_head_circle_blue"
				if (Number(key) == 0) {
					ResManager.GetInstance().SetImageSprite(this, this._img_7, "mainUI", lv_bg)
					this._Image7.y = -3
				} else {
					ResManager.GetInstance().SetImageSprite(this, this._img_71, "mainUI", lv_bg)
				}


				if (this["head_" + key] == null) {
					this["head_" + key] = new CustomHeadItem(this["_img_" + key + "_head"])
					this["head_" + key].SetActiveLevel(false)
					if (key == 1) {
						this["head_" + key].SetLevelReverse()
					}
					this["head_" + key].Load()
				}
				this["head_" + key].SetRoleVoData(vo)
				let str_vip
				if(vo.is_hide_vip > 0){
					if(vo.supreme_vip == 1){
						str_vip = "SVIP-x"
					}
					else{
						str_vip = "VIP-x"
					}
				}
				else{
					if(vo.supreme_vip == 1){
						str_vip = "VIP_" + vo.vip_flag
					}
					else{
						str_vip =  "uivip_zjm_" + vo.vip_flag
					}
				}
				ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI_asset", str_vip, true)
				// ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI_asset", "uivip_zjm_" + vo.vip_flag, true)

				this.BindVar(vo, "hp", (event_name?, value?) => {
					SetSizeDeltaX(this["_img_" + key + "_hp"], 182 * (value / vo.maxHp))
				}
				)

				if (!vo.is_fake_role) {
					let fighting = vo.fighting
					if (!fighting || fighting < 1) {
						fighting = model.combat_power || model.enemy_fight
					}
					this["_lb_" + key + "_fighting"].text = vo.fighting
				} else {
					this["_lb_" + key + "_fighting"].text = model.combat_power || model.enemy_fight
				}
			}
			//this["text_lb_0_fighting"].text = String(role_mgr.GetMainRoleVo().fighting)
			this.SetNextFrameUpdate(true)
		}

		//竞技场血条颜色处理
		this.Update = () => {
			if (this.GetNextFrameUpdate()) {
				if (this.my_role_id) {
					let my_robot = scene.GetRole(this.my_role_id)
					if (my_robot && my_robot.name_board) {
						my_robot.name_board.SetGreenBar()
					}
				}
				if (this.enemy_role_id) {
					let enemy_robot = scene.GetRole(this.enemy_role_id)
					if (enemy_robot && enemy_robot.name_board) {
						enemy_robot.name_board.SetRedBar()
					}
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
					this._update_id = runner.AddRunObj(this, 3)
				} else {
					if (this._update_id) {
						runner.RemoveRunObj(this._update_id)
						this._update_id = null
					}
				}
				this._next_frame_update = value
			}
		}

	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_Group4: Laya.Box
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
	_lb_1_name: Laya.Label
	_img_71: Laya.Image
	_lb_lv_1: Laya.Label
	_fight_con: Laya.HBox
	_img_fight1: Laya.Image
	_lb_1_fighting: Laya.Label
	_gp_fight_effect_con: Laya.Box
	_gp_vs_effect_con: Laya.Box
	_gp_count_time: Laya.Box
	_Image7: Laya.Image
	_lb_count_time: Laya.Label
	_img_exit: Laya.Image
	_bit_time_down: Laya.Label
	public GetComponents() {
		[
			this._Group4,
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
			this._lb_1_name,
			this._img_71,
			this._lb_lv_1,
			this._fight_con,
			this._img_fight1,
			this._lb_1_fighting,
			this._gp_fight_effect_con,
			this._gp_vs_effect_con,
			this._gp_count_time,
			this._Image7,
			this._lb_count_time,
			this._img_exit,
			this._bit_time_down,
		]
			= this.GetChildrenByNames([

				"_Group4",
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
				"_lb_1_name",
				"_img_71",
				"_lb_lv_1",
				"_fight_con",
				"_img_fight1",
				"_lb_1_fighting",
				"_gp_fight_effect_con",
				"_gp_vs_effect_con",
				"_gp_count_time",
				"_Image7",
				"_lb_count_time",
				"_img_exit",
				"_bit_time_down",
			])
	}
}
window["BrightSeaFightSceneView"] = BrightSeaFightSceneView