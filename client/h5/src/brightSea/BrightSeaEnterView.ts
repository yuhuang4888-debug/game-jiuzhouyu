import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BrightSeaEvent, BrightSeaModel, CruiseState, SeaNotificationType } from "../commonModel/BrightSeaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDeltaX, SetAnchoredPosition, SetAnchoredPositionX, Util, GlobalTimerQuest, HtmlColorTxt, SetHtmlStyle } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { BrightSeaRoleItem } from "./BrightSeaRoleItem"
import { Config } from "../common/Config"
import { kfStageModel } from "../commonModel/kfStageModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"

export class BrightSeaEnterView extends BaseItem1 {
	Emp_btn_opt
	Emp_gp_cruise_log
	Emp_gp_plunder_list
	EmpkfBtn
	InitEvent
	LoadDefaultEffects
	LoadSuccess
	Local_DeleteMe
	OnCheckShipsTime
	OnTime
	Out_lb_opt
	RequestProto
	SetModelInfo
	StartShipsTimer
	StartTimer
	StopLoadTimers
	StopShipsTimer
	StopTimer
	UpdateShips
	UpdateView
	ships_timer
	item_list
	status
	timer
	timers
	total_time
	tween_id
	end_time
	ClearEff
	init_width
	public constructor(parent?) {
		super(parent)
		this.base_file = "brightSea"
		this.layout_file = "BrightSeaEnterView"
		this.layer_value = Enum_UILayer.UI

		let model = BrightSeaModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let request_result = false
		let check_map = null
		let check_left_time = null
		let check_auto_id = null

		this.item_list = null
		this.timer = null
		this.tween_id = null
		this.ships_timer = null

		this.load_callback = () => {
			this.init_width=229
			this.InitEvent()
			this.LoadSuccess()
		}


		this.LoadSuccess = () => {
			SetHtmlStyle(this._html_kf_mode, { f: 20, c: "#663915", ww: false})
			SetHtmlStyle(this._lb_cruise_num, { f: 20, c: "#00fa64", w: 200, ww: false })
			SetHtmlStyle(this._lb_plunder_num, { f: 20, c: "#00fa64", w: 200, ww: false })
			this.LoadDefaultEffects()
			this.RequestProto()
			this.UpdateView()
		}

		this.RequestProto = () => {
			model.Fire(BrightSeaEvent.REQUEST_PROTO, 18900)
			model.Fire(BrightSeaEvent.REQUEST_PROTO, 18915)
		}

		this.SetModelInfo = () => {
			if (model.serInfo && this.is_loaded) {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_treasure_mod
				let info = model.serInfo.treasure_mod
				if (info && cfg && cfg[info]) {
					let ser_num = cfg[info].ser_num
					if (ser_num) {
						this._html_kf_mode.innerHTML = `当前模式：<font color='#d15e00'>${(ser_num == 1 && ("本") || (ser_num))}服模式</font>`
					}
				}
			}
		}

		this.InitEvent = () => {
			RedDotController.ins.bind(RedKey.BRIGHT_SEA_PLUNDER, this._img_red_plunder);
			this.BindVar(model, "main_info", (event_name?, value?, old_value?) => {
				this.UpdateView(value)
			})

			this.BindEvent(model, BrightSeaEvent.UPDATE_CRUISE_RET, () => {
				// 结算通知
				if (request_result) {
					let notification = model.PopCruiseNotificationByType(SeaNotificationType.Result, true)
					if (notification) {
						model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaResultView", notification)
					}
				} else {
					model.Fire(BrightSeaEvent.REQUEST_PROTO, 18900)
				}
				request_result = false
			})

			this.BindEvent(
				model,
				BrightSeaEvent.UPDATE_SERVER_INFO, () => {
					this.SetModelInfo()
				}
			)

			this.BindEvent(model,
				BrightSeaEvent.UPDATE_SEND_LIST_ADD, () => {
					this.UpdateView()
				}
			)


			Util.AddClickEvent(this._btn_opt, () => {
				if (this.status == CruiseState.CanReward) {
					request_result = true
					model.Fire(BrightSeaEvent.REQUEST_PROTO, 18904, model.main_info.auto_id)
				} else {
					let data = model.main_info
					if (!data) {
						return
					}
					let have_num = (data.total_reward_times - data.reward_times)
					if (have_num > 0) {
						model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaCruiseView")
					} else {
						Message.show("今日巡航次数已用完")
					}
				}
			}, this, true)

			Util.AddClickEvent(this._gp_cruise_log, () => {
				model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaCruiseLogView")
			}, this, true)

			Util.AddClickEvent(this._gp_plunder_list, () => {
				model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaPlunderLogView")
				//model:Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaThanksDialog", {
				//	rold_id = 110,
				//	name = "战神",
				//	pic = "",
				//	shipping_id = 1,
				//	auto_id = 110,
				//	reward = {
				//		[1] = {
				//			[1] = 35,
				//			[2] = 35,
				//			[3] = 35,
				//		}
				//	}
				//})
			}, this, true)

			// Util.AddClickEvent(this._gp_test, () => {
			// 	model.ShowNotification()
			// }, this, true)

			Util.AddClickEvent(
				this._box_kf, () => {
					kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_189)
				},this,true)
		}

		/*
				shipping_id.int8         // 船只档次id
				ser_id.int32             // 服id
				ser_num.int32            // 服数
				guild_id.int64           // 结社id
				guild_name.string        // 结社名
				role_id.int64            // 玩家id
				role_name.string         // 玩家名
				power.int64              // 玩家战力
				end_time.int32           // 巡航结束时间
		*/
		let UpdateCruising = (data) => {
			let my_ship_data = model.GetMyShipData()
			if (my_ship_data) {
				this.StartTimer(my_ship_data.end_time, my_ship_data.shipping_id)
			}
		}
		this.UpdateView = () => {
			//let data =BrightSeaModel.GetInstance().GetTestDataOfShip()//测试代码
			let data = model.main_info
			if (!data) { return }
			let have_reward_num = (data.total_reward_times - data.reward_times)
			let have_rob_num = (data.total_rob_times - data.rob_times)
			let str = have_reward_num <= 0 ? HtmlColorTxt(have_reward_num + "", "'#ff0000'") : have_reward_num + ""
			let str2 = have_rob_num <= 0 ? HtmlColorTxt(have_rob_num + "", "'#ff0000'") : have_rob_num + ""
			this._lb_cruise_num.innerHTML = str + '/' + data.total_reward_times
			this._lb_plunder_num.innerHTML = str2 + '/' + data.total_rob_times

			let red_status = false
			let status = data.status
			if (data.auto_id == 0) {
				status = CruiseState.Rest
			}
			if (status == CruiseState.Rest) {
				this._lb_opt.text = "开始航行"
				if ((data.total_reward_times - data.reward_times) > 0) {
					red_status = true
				}
			} else if (status == CruiseState.Cruising) {
				UpdateCruising(data)
			} else if (status == CruiseState.CanReward) {
				this._lb_opt.text = "查看收获"
				red_status = true
			} else if (status == CruiseState.Finished) {
				// 领取完毕
				this._lb_opt.text = "已领取"
			}
			this.status = status

			this._gp_red.visible = red_status
			this._btn_opt.visible = status != CruiseState.Cruising
			this._con_time.visible = status == CruiseState.Cruising

			this.UpdateShips(model.GetShowShipList(model.send_list))
			//this.UpdateShips(model.GetShowShipList(data.send_list,true))//测试代码

			this.SetModelInfo()
		}

		this.StopShipsTimer = () => {
			if (this.ships_timer) {
				GlobalTimerQuest.CancelQuest(this.ships_timer)
				this.ships_timer = null
			}
		}

		this.StartShipsTimer = () => {
			this.StopShipsTimer()

			if (!check_map) {
				return
			}

			if (check_map.length <= 0) {
				return
			}

			this.ships_timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnCheckShipsTime()
			}, 2, -1)
		}

		/*
			检测船只过期
		*/
		this.OnCheckShipsTime = () => {
			if (!check_map) {
				this.StopShipsTimer()
			}

			check_auto_id = null
			for (let auto_id in check_map) {
				var end_time = check_map[auto_id]
				check_left_time = end_time - local_TimeUtil.getServerTime()
				if (check_left_time <= 0) {
					check_auto_id = auto_id
					break
				}
			}
			if (check_auto_id) {
				check_map[check_auto_id] = null
				model.Fire(BrightSeaEvent.REQUEST_PROTO, 18900)
			}
			if (check_map.length <= 0) {
				this.StopShipsTimer()
			}
		}

		this.StartTimer = (end_time?, ship_id?) => {
			this.StopTimer()
			this.end_time = end_time
			if (ship_id) {
				let ship_data = Config.PRELOAD_SERVER_CONFIG.config_sea_treasure_reward[ship_id]
				//Config.Seatreasurereward[ship_id]
				this.total_time = ship_data.need_time
			} else {
				this.total_time = this.end_time - local_TimeUtil.getServerTime()
			}

			this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTime()
			}, 1, -1)
			this.OnTime()
		}

		this.OnTime = () => {
			let left_time = this.end_time - local_TimeUtil.getServerTime()
			if (left_time < 0) {
				this.StopTimer()
				GlobalTimerQuest.AddDelayQuest(() => {
					model.Fire(BrightSeaEvent.REQUEST_PROTO, 18900)
				}, 1)
				this._time_value.width = 0
				return
			}
			let time = local_TimeUtil.timeConvert(left_time, "hh-mm-ss")
			this._time_fnt.text = time

			let value=(left_time / this.total_time)*this.init_width
			this._time_value.width = Math.min(value,this.init_width)
		}

		this.StopTimer = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
		}

		this.StopLoadTimers = () => {
			if (this.timers) {
				for (let _ in this.timers) {
					var timer_id = this.timers[_]
					if (timer_id) {
						clearTimeout(timer_id)
					}
				}
				this.timers = null
			}
		}

		this.LoadDefaultEffects = () => {
			let scale = 6
			this.StopLoadTimers()
			this.timers = [false, false, false, false, false, false, false, false]
			let timer_id
			for (let i = 1; i <= 8; i++) {
				timer_id = setTimeout((index?) => {
					this.AddUIEffect("ui_diamondsea_3", this["_eff" + index], { x: 0, y: 0 }, scale, false)
				}, 0.05 * i, i)
				this.timers[i - 1] = timer_id
			}
		}


		this.ClearEff = ()=>{
			for (let i = 1; i <= 8; i++) {
				this.ClearUIEffect(this["_eff" + i])
			}
		}

		this.UpdateShips = (ship_list?) => {
			if (!ship_list) {
				 return 
			}
			let list = ship_list
			let len = list.length
			if (!this.item_list) {
				this.item_list = []
			}

			for (let i = 0; i < this.item_list.length; i++) {
				this.item_list[i].SetVisible(false)
			}

			if (len > 0) {
				let cant_rob_before_end = Config.PRELOAD_SERVER_CONFIG.config_sea_treasure_kv["cant_rob_before_end"].value
				//Config.Seatreasurekv["cant_rob_before_end"].value
				let main_role_id = RoleManager.GetInstance().GetMainRoleId()
				model.guide_info = null
				let item = null
				check_map = []
				for (let key = 0; key < len; key++) {
					let vo = list[key]
					if (vo && vo.role_id != main_role_id) {
						check_map[vo.auto_id] = vo.end_time - (cant_rob_before_end || 0)
					}
					item = this.item_list[key]
					if (!item) {
						item = new BrightSeaRoleItem(this["_item" + (key + 1)])
						this.item_list[key] = item
						item.Load()
					}

					item.SetData(vo, key + 1)
					item.SetVisible(true)
				}
				this.StartShipsTimer()
			}
		}


		this.Local_DeleteMe = () => {
			request_result = null
			this.ClearEff()
			this.StopTimer()
			this.StopShipsTimer()
			this.StopLoadTimers()
			if (this.item_list) {
				for (let _tmpi in this.item_list) {
					var vo = this.item_list[_tmpi]
					vo.DeleteMe()
				}
				this.item_list = null
			}

		}
	}


	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


_gp_eff:Laya.Box
_eff1:Laya.Box
_eff2:Laya.Box
_eff3:Laya.Box
_eff4:Laya.Box
_eff5:Laya.Box
_eff6:Laya.Box
_eff7:Laya.Box
_eff8:Laya.Box
_gp_item_con:Laya.Box
_item1:Laya.Box
_item2:Laya.Box
_item3:Laya.Box
_item4:Laya.Box
_item5:Laya.Box
_item6:Laya.Box
_item7:Laya.Box
_item8:Laya.Box
_img_left:Laya.Image
_gp_cruise_log:Laya.Box
_Image3:Laya.Image
_gp_plunder_list:Laya.Box
_Image31:Laya.Image
_img_red_plunder:Laya.Image
_Group1:Laya.HBox
_Label1:Laya.Label
_lb_plunder_num:Laya.HTMLDivElement
_Group2:Laya.HBox
_Label2:Laya.Label
_lb_cruise_num:Laya.HTMLDivElement
_con_time:Laya.Box
bg:Laya.Image
_time_value:Laya.Image
label:Laya.Label
icon:Laya.Image
_time_fnt:Laya.Label
_btn_opt:Laya.Box
_bg_0:Laya.Image
_lb_opt:Laya.Label
_gp_red:Laya.Box
Image:Laya.Image
_box_kf:Laya.Box
_img_kf:Laya.Image
_lb_kf:Laya.Label
_img_bg2:Laya.Image
_html_kf_mode:Laya.HTMLDivElement
public GetComponents() {
[
this._gp_eff,
this._eff1,
this._eff2,
this._eff3,
this._eff4,
this._eff5,
this._eff6,
this._eff7,
this._eff8,
this._gp_item_con,
this._item1,
this._item2,
this._item3,
this._item4,
this._item5,
this._item6,
this._item7,
this._item8,
this._img_left,
this._gp_cruise_log,
this._Image3,
this._gp_plunder_list,
this._Image31,
this._img_red_plunder,
this._Group1,
this._Label1,
this._lb_plunder_num,
this._Group2,
this._Label2,
this._lb_cruise_num,
this._con_time,
this.bg,
this._time_value,
this.label,
this.icon,
this._time_fnt,
this._btn_opt,
this._bg_0,
this._lb_opt,
this._gp_red,
this.Image,
this._box_kf,
this._img_kf,
this._lb_kf,
this._img_bg2,
this._html_kf_mode,
]
 = this.GetChildrenByNames([

"_gp_eff",
"_eff1",
"_eff2",
"_eff3",
"_eff4",
"_eff5",
"_eff6",
"_eff7",
"_eff8",
"_gp_item_con",
"_item1",
"_item2",
"_item3",
"_item4",
"_item5",
"_item6",
"_item7",
"_item8",
"_img_left",
"_gp_cruise_log",
"_Image3",
"_gp_plunder_list",
"_Image31",
"_img_red_plunder",
"_Group1",
"_Label1",
"_lb_plunder_num",
"_Group2",
"_Label2",
"_lb_cruise_num",
"_con_time",
"bg",
"_time_value",
"label",
"icon",
"_time_fnt",
"_btn_opt",
"_bg_0",
"_lb_opt",
"_gp_red",
"Image",
"_box_kf",
"_img_kf",
"_lb_kf",
"_img_bg2",
"_html_kf_mode",
])
}
}
 window["BrightSeaEnterView"]= BrightSeaEnterView