import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, SetSizeDeltaY, Util } from "../util/Util"

export class DiamondFightWaitingView extends BaseView1 {


	destroy_imm
	diamond_fight_model: DiamondFightModel
	mainUI_mgr: MainUIManager
	res_mgr: ResManager
	time_id






	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightWaitingView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.back_login_toClose = true

		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.mainUI_mgr = MainUIManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_drumwar_zone_reward": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {

		this.CancelCountTime()
		this.mainUI_mgr.RemoveMoveComponent(this)
	}

	public LoadSuccess() {

		this._html_time.style.fontSize = 22
		this._html_time.style.wordWrap = false
		this._html_time.style.leading = 10
		this._html_time.style.color = "#ffffff"

		this.display_obj.left = this.display_obj.bottom = this.display_obj.right = 0
		this.display_obj.top = Util.GetLiuhaiHeight()

		let url = "resource/game/diamondFight/texture/"


		this.UpdateWaitTips()
		this.UpdateWaitingInfo()
		this.UpdateTips()
		this.UpdateRecordRed()
		this.InitEvent()
		this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13703)


		this.mainUI_mgr.AddMoveComponent(this, this._img_leave, false, MainUIManager.MOVE_TYPE.Left)
		this.mainUI_mgr.AddMoveComponent(this, this._box_con, false, MainUIManager.MOVE_TYPE.Left)
		this.mainUI_mgr.AddMoveComponent(this, this._box_con1, false, MainUIManager.MOVE_TYPE.Stay)
		this.mainUI_mgr.AddMoveComponent(this, this._box_record, false, MainUIManager.MOVE_TYPE.Left)
		this.mainUI_mgr.AddMoveComponent(this, this._img_leave, false, MainUIManager.MOVE_TYPE.Left)
		this.mainUI_mgr.AddMoveComponent(this, this._box_record, false, MainUIManager.MOVE_TYPE.Left)

		this._lb_left_time1.fontSize = this._lb_action1.fontSize = this._lb_action2.fontSize = this._lb_turn3.fontSize = this._lb_left_time3.fontSize = 41
		ResManager.GetInstance().LoadFont(this, "diamond_fight_2", this._lb_left_time1, 41)
		ResManager.GetInstance().LoadFont(this, "diamond_fight_2", this._lb_action1, 41)

		ResManager.GetInstance().LoadFont(this, "diamond_fight_2", this._lb_action2, 41)

		ResManager.GetInstance().LoadFont(this, "diamond_fight_2", this._lb_turn3, 41)
		ResManager.GetInstance().LoadFont(this, "diamond_fight_2", this._lb_left_time3, 41)
	}

	public InitEvent() {


		Util.AddClickEvent(this._box_buy, () => {
			let info = this.diamond_fight_model.waiting_info
			if (info) {
				if (info.is_out == 0) {
					if (!this.diamond_fight_model.waiting_info) {
						return
					}
					this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightPurchaseView")
				} else {
					Message.show("您已被淘汰，无法购买命数")
				}
			}
		}, this, true)

		Util.AddClickEvent(this._img_record, () => {
			let info = this.diamond_fight_model.stage_info
			if (info) {
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightBattleView")
			}
		}, this, true)

		Util.AddClickEvent(this._img_leave, () => {
			let info = this.diamond_fight_model.waiting_info
			let leave_func = () => {
				this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13707, 0)
			}

			if (this.diamond_fight_model.champion_info) {
				leave_func()
				return
			}
			if (info && info.is_out == 1) {
				leave_func()
			} else {
				let tips = "离开场景将会影响正常匹配<br>" + HtmlColorTxt("（若下一轮匹配开始尚未进入则默认被淘汰）", Enum_ColorUtil_Dark.RED) + "<br>是否确认离开场景？"
				Alert.Show(tips, Alert_Type.Two, () => {
					leave_func()
				}
					, null, "确定", "取消")
			}
		}, this, true)

		this.BindVar(this.diamond_fight_model, "waiting_info", () => {
			this.UpdateWaitingInfo()
			this.UpdateTips()
		})

		this.BindVar(this.diamond_fight_model, "wait_tip_info", () => {
			this.UpdateWaitTips()
			this.UpdateTips()
		})

		this.BindVar(this.diamond_fight_model, "stage_info", () => {
			this.UpdateStage()
		})

		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_LIFE, (life?) => {
			this.SetLive(life)
		})

		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_RECORD_RED_STATE, () => {
			this.UpdateRecordRed()
		})


	}

	public UpdateStage() {

		let stage_info = this.diamond_fight_model.stage_info
		if (!stage_info) {
			return
		}
	}

	public SetLive(life?) {
		let i = 0
		do {
			ResManager.GetInstance().SetImageSprite(this, this["_img_heart" + i], "diamondFight", i < life && "uizsdz_010a" || "uizsdz_010b")
			i = i + 1
		} while ((i < 3)
		)
	}

	public UpdateWaitTips() {
		// return
		let wait_tip_info = this.diamond_fight_model.wait_tip_info
		if (wait_tip_info) {
			if (wait_tip_info.action > DiamondFightModel.HAIXUAN_ROUNDS) {
				this._img_record.visible = true
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightBattleView")
				this.ShowState(4)
				return
			}
			let end_time
			if (1 == wait_tip_info.type) {
				this.ShowState(0)
			} else if (2 == wait_tip_info.type) {
				this.ShowState(1)
				end_time = wait_tip_info.end_time
				this._lb_action1.text = wait_tip_info.action + "a" + DiamondFightModel.HAIXUAN_ROUNDS
				this.StartCountTime(1, () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime(1)
						return
					}
					this._lb_left_time1.text = String(left_time)
				}
				)
			} else if (5 == wait_tip_info.type) {
				this.ShowState(3)
				end_time = wait_tip_info.end_time
				this.StartCountTime(3, () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime(3)
						return
					}
					this._lb_left_time3.text = String(left_time)
				}
				)
			} else if (6 == wait_tip_info.type) {
				this._lb_action2.text = wait_tip_info.action + "a" + DiamondFightModel.HAIXUAN_ROUNDS
				this.ShowState(2)
			}
		}
	}

	public UpdateTips() {

		let wait_tip_info = this.diamond_fight_model.wait_tip_info
		let waiting_info = this.diamond_fight_model.waiting_info
		if (!waiting_info || !wait_tip_info) {
			return
		}
		this._img_tips.height = 40
		this._img_tips.width = 351
		if (waiting_info.is_out == 1) {
			this._html_time.style.color = "#ffffff"
			this._html_time.innerHTML = "很遗憾,您被淘汰了,请再接再厉!<br>参与16强争霸押注可获得绑玉奖励哦！"
			this._img_tips.height = 73
			this._img_tips.width = 500
			this._box_tips.visible = true
		} else if (wait_tip_info.action > DiamondFightModel.HAIXUAN_ROUNDS) {
			this._box_tips.visible = false
		} else {
			this._html_time.style.color = "#ffffff"
			let end_time
			if (1 == wait_tip_info.type) {
				end_time = wait_tip_info.end_time
				this.StartCountTime(0, () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime(0)
						return
					}
					this._html_time.innerHTML = `倒计时：${HtmlColorTxt(TimeUtil.timeConvert(left_time, "hh:MM:ss"), "'#00fa64'")}`
				}
				)
				this._box_tips.visible = true
			} else if (2 == wait_tip_info.type) {
				this._box_tips.visible = false
			} else if (5 == wait_tip_info.type) {
				this._box_tips.visible = false
			} else if (6 == wait_tip_info.type) {
				let str = ""
				if (wait_tip_info.action == DiamondFightModel.HAIXUAN_ROUNDS) {
					str = "您已晋级16强争霸赛,请等待"
				} else {
					str = "您已晋级第" + (wait_tip_info.action + 1) + "轮,请等待"
				}
				end_time = wait_tip_info.end_time
				this.StartCountTime(0, () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime(0)
						return
					}
					this._html_time.innerHTML = `${str}${HtmlColorTxt(TimeUtil.timeConvert(left_time, "hh:MM:ss"), "'#00fa64'")}`
				}
				)
				this._box_tips.visible = true
			}
		}
		this.CallLater(()=>{
			this._html_time.x = Math.abs(this._box_tips.width - this._html_time.width) / 2
		})
	}

	public UpdateWaitingInfo() {

		let info = this.diamond_fight_model.waiting_info
		if (!info) {
			return
		}
		this.SetLive(info.life_num)
		let drumwar_zone_reward_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_zone_reward", false)
		let config_drumwar_lv_to_zone = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_lv_to_zone", false)
		this._lb_get_reward.text = String(this.diamond_fight_model.GetTotalDiamond(info.zone, info.stage, info.is_out == 0, drumwar_zone_reward_cfg, config_drumwar_lv_to_zone))
		if (info.is_out == 1) {
			this._box_tips.visible = true
			this._html_time.style.color = "#b3ff48"
			if (info.stage > DiamondFightModel.HAIXUAN_ROUNDS) {
				let str = ""
				if (9 == info.stage) {
					str = "止步16强"
				} else if (10 == info.stage) {
					str = "止步8强"
				} else if (11 == info.stage) {
					str = "止步4强"
				} else if (12 == info.stage) {
					str = "获得第二名"
				}
				this._lb_my_state.text = str
			} else {
				let stage = info.stage
				if (!stage) {
					stage = 1
				}
				this._lb_my_state.text = "止步第" + info.stage + "轮"
			}
			this._html_time.innerHTML = "您已被淘汰可自行离开赛场..."
		} else if (info.stage == 0) {
			this._lb_my_state.text = "暂无战绩"
			return
		} else if (info.stage == DiamondFightModel.HAIXUAN_ROUNDS) {
			this._box_tips.visible = true
			this._html_time.style.color = "#b3ff48"
			this._html_time.innerHTML = "您已晋级16强争霸赛，请等待"
			this._lb_my_state.text = "晋级16强"
		} else if (info.stage > DiamondFightModel.HAIXUAN_ROUNDS) {
			let str = ""
			if (9 == info.stage) {
				str = "晋级8强"
			} else if (10 == info.stage) {
				str = "晋级4强"
			} else if (11 == info.stage) {
				str = "晋级决赛"
			} else if (12 == info.stage) {
				str = "冠军"
			}
			this._lb_my_state.text = str
			this._box_tips.visible = false
		} else {
			this._box_tips.visible = true
			this._html_time.style.color = "#b3ff48"
			this._html_time.innerHTML = "您已晋级海选赛第" + ((info.stage + 1)) + "/" + DiamondFightModel.HAIXUAN_ROUNDS + "轮，请等待"
			this._lb_my_state.text = "晋级第" + (info.stage + 1) + "轮"
		}
	}

	public ShowState(index?) {

		let i = 0
		do {
			this["_box_state" + i].visible = i == index
			i = i + 1
		} while ((i < 4)
		)
	}

	public StartCountTime(index?, func?) {

		if (!this.time_id) {
			this.time_id = {}
		}
		this.CancelCountTime(index)
		this.time_id[index] = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public CancelCountTime(index?) {

		if (index == null) {
			if (!this.time_id) {
				return
			}
			for (let key in this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id[key])
			}
			this.time_id = null
		} else {
			if (!this.time_id || !this.time_id[index]) {
				return
			}
			GlobalTimerQuest.CancelQuest(this.time_id[index])
			delete this.time_id[index]
		}
	}

	public UpdateRecordRed() {

		this._img_record_red.visible = this.diamond_fight_model.GetRecordRedState()
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_lb_title: Laya.Label
	_lb_my_state: Laya.Label
	_img_cost: Laya.Image
	_lb_get_reward: Laya.Label
	_box_hearts: Laya.HBox
	_img_heart0: Laya.Image
	_img_heart1: Laya.Image
	_img_heart2: Laya.Image
	_box_buy: Laya.Box
	_img_buy: Laya.Image
	_lb_buy: Laya.Label
	_img_leave: Laya.Image
	_box_record: Laya.Box
	_img_record: Laya.Image
	_img_record_red: Laya.Image
	_box_con1: Laya.Box
	_box_state0: Laya.Box
	_img_state0: Laya.Image
	_box_state1: Laya.Box
	_lb_left_time1: Laya.Label
	_img_state1: Laya.Image
	_lb_action1: Laya.Label
	_box_state2: Laya.Box
	_img_state2: Laya.Image
	_lb_action2: Laya.Label
	_box_state3: Laya.Box
	_img_state31: Laya.Image
	_box_state32: Laya.Box
	_lb_left_time3: Laya.Label
	_img_state32: Laya.Image
	_lb_turn3: Laya.Label
	_img_state33: Laya.Image
	_box_tips: Laya.Box
	_img_tips: Laya.Image
	_html_time: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._lb_title,
			this._lb_my_state,
			this._img_cost,
			this._lb_get_reward,
			this._box_hearts,
			this._img_heart0,
			this._img_heart1,
			this._img_heart2,
			this._box_buy,
			this._img_buy,
			this._lb_buy,
			this._img_leave,
			this._box_record,
			this._img_record,
			this._img_record_red,
			this._box_con1,
			this._box_state0,
			this._img_state0,
			this._box_state1,
			this._lb_left_time1,
			this._img_state1,
			this._lb_action1,
			this._box_state2,
			this._img_state2,
			this._lb_action2,
			this._box_state3,
			this._img_state31,
			this._box_state32,
			this._lb_left_time3,
			this._img_state32,
			this._lb_turn3,
			this._img_state33,
			this._box_tips,
			this._img_tips,
			this._html_time,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_lb_title",
				"_lb_my_state",
				"_img_cost",
				"_lb_get_reward",
				"_box_hearts",
				"_img_heart0",
				"_img_heart1",
				"_img_heart2",
				"_box_buy",
				"_img_buy",
				"_lb_buy",
				"_img_leave",
				"_box_record",
				"_img_record",
				"_img_record_red",
				"_box_con1",
				"_box_state0",
				"_img_state0",
				"_box_state1",
				"_lb_left_time1",
				"_img_state1",
				"_lb_action1",
				"_box_state2",
				"_img_state2",
				"_lb_action2",
				"_box_state3",
				"_img_state31",
				"_box_state32",
				"_lb_left_time3",
				"_img_state32",
				"_lb_turn3",
				"_img_state33",
				"_box_tips",
				"_img_tips",
				"_html_time",
			])
	}
}
window["DiamondFightWaitingView"] = DiamondFightWaitingView