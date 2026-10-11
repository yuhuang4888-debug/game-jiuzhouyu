import { BaseItem1 } from "../common/BaseItem1"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDelta, SetAnchoredPositionX, SetSizeDeltaX, SetAnchoredPosition, SetAnchoredPositionY, Util, HtmlColorTxt, SetHtmlStyle, MakeListCenter, SetHtmlCenter } from "../util/Util"
import { Config } from "../common/Config"
import { kfStageModel } from "../commonModel/kfStageModel"
export class HolyBattleEnterView extends BaseItem1 {
	f
	InitEvent
	LoadSuccess
	Local_DeleteMe
	Scr_Scroller1
	UpdateMode
	UpdateOpenRed
	UpdateOpenTimeData
	UpdateReward
	UpdateRewardRed
	preload_client_config
	preload_server_config


	public constructor(parent?) {
		super(parent)


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleEnterView"

		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_HolyBattleModel = HolyBattleModel
		let local_TimeUtil = TimeUtil
		let local_MessageShow = Message.show
		let local_EventName = EventName
		let local_GlobalEventSystem = GlobalEventSystem
		let reward_array = null

		this.load_callback = () => {
			SetHtmlStyle(this._lb_time, { f: 20, c: "#3f2816", ww: false, w: 200 })
			SetHtmlStyle(this._html_kf_mode, { f: 20, c: "#663915", ww: false})
			this.LoadSuccess()
		}

		this.preload_server_config = { "config_holy_spirit_battlefield_mod": false, "config_holy_spirit_battlefield_kv": false }
		this.preload_client_config = { "ConfigHolyBattle": false }

		this.LoadSuccess = () => {

			this.UpdateMode()
			this.UpdateOpenTimeData()
			this.UpdateReward()
			this.UpdateOpenRed()
			this.UpdateRewardRed()
			this.InitEvent()

			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21811)


		
		}


		

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_enter, () => {
				if (local_HolyBattleModel_Instance.OpenState()) {
					local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21802)
				} else {
					local_MessageShow("活动未开启")
				}
			}, this, true)

			Util.AddClickEvent(this._box_kf, () => {
				kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_218)
				//local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleServerView")
			}, this, true)

			Util.AddClickEvent(this._img_reward, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "HolyBattleRewardView")
			}, this, true)

			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_ACT_DATA, () => {
				this.UpdateMode()
			}
			)

			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.REFRESH_RED_FLAG, (flag?) => {
				if (flag == local_HolyBattleModel.RedFlag.Open) {
					this.UpdateOpenRed()
				} else if (flag == local_HolyBattleModel.RedFlag.Reward) {
					this.UpdateRewardRed()
				}

			}
			)
		}

		this.UpdateMode = () => {
			let mode = local_HolyBattleModel_Instance.GetMode()
			if (mode) {
				let holy_spirit_battlefield_mod_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_mod", false)//Config.Holyspiritbattlefieldmod
				let mode_cfg = holy_spirit_battlefield_mod_cfg && holy_spirit_battlefield_mod_cfg[mode]

				if (mode_cfg) {
					this._html_kf_mode.innerHTML = `当前模式：<font color='#d15e00'>${mode_cfg.name}</font>`
				}
			}
		}

		this.UpdateOpenTimeData = () => {
			let holy_spirit_battlefield_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_kv", false)// Config.Holyspiritbattlefieldkv
			let open_time = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["open_time"]
			let local_week = holy_spirit_battlefield_kv_cfg && holy_spirit_battlefield_kv_cfg["local_week"]
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			let str = ""

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	str = "Mon, Wed, Fri at 20.30"
			// } else if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	str = " Buka setiap Senin, Rabu, Jumat 20.30"
			// } else {
			if (local_week) {
				local_week = JSON.parse(local_week.values)
				str = str + "每周"

				let week_data = null
				for (let k in local_week) {

					week_data = local_week[k]
					if (Number(week_data[0]) <= open_day && Number(week_data[1]) >= open_day) {
						for (let j in week_data[2]) {

							let v = Number(week_data[2][j])
							// if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
							// 	str = str + TimeUtil.KrDayName(v)
							// } else {
							str = str + (v == 7 && ("日") || (WordManager.NumConvertStage(v)))
							// }
							if (Number(j) + 1 <= week_data[2].length) {
								str = str + "、"
							} else {
								str = str + "  "
							}
						}
						break
					}
				}
			}

			if (open_time) {
				let open_time1 = JSON.parse(open_time.values)
				let hours = open_time1[0][0]
				let min = open_time1[0][1]
				str = str + hours + ":" + (min.length == 1 && ("0" + min) || (min))
			}
			str = `${str}开启`
			//}
			this._lb_time.innerHTML = `活动时间：${HtmlColorTxt(str, "'#9b572f'")}`
			SetHtmlCenter(this._lb_time, { x: 0, w: 720 })
		}

		this.UpdateReward = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigHolyBattle", true)//Config.ConfigHolyBattle
			let reward_cfg = cfg && cfg["preview_reward"]
			let list = []

			if (reward_cfg) {
				for (let _tmpi in reward_cfg) {
					var v = reward_cfg[_tmpi]
					table.insert(list,
						{
							size: 88,
							vo: {
								style: v[0],
								typeId: v[1],
								count: v[2]
							}
						})
				}
			}


			if (!reward_array) {
				reward_array = new LoopScrowViewMgr()
				reward_array.SetData(this._list_reward_con, CommonRewardItem, list, LoopScrCon.Horizontal)
			} else {
				reward_array.replaceAll(list)
			}

			MakeListCenter(this._list_reward_con, 7, 40, 88)
		}

		this.UpdateOpenRed = () => {
			let bool = local_HolyBattleModel_Instance.HasRedFlag(local_HolyBattleModel.RedFlag.Open)
			this._img_go_red.visible = bool
		}

		this.UpdateRewardRed = () => {
			let bool = local_HolyBattleModel_Instance.HasRedFlag(local_HolyBattleModel.RedFlag.Reward)
			this._img_reward_red.visible = bool
		}

		this.Local_DeleteMe = () => {
			if (reward_array) {
				reward_array.DeleteMe()
				reward_array = null
			}
		}

	}



	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	_img_reward: Laya.Image
	_img_reward_red: Laya.Image
	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_gp_enter: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	_img_go_red: Laya.Image
	_lb_time: Laya.HTMLDivElement
	_img_wz_bg: Laya.Image
	_txt_wz: Laya.Text
_list_reward_con:Laya.List
	_box_kf: Laya.Box
_img_kf:Laya.Image
_lb_kf:Laya.Label
_img_bg22:Laya.Image
_html_kf_mode:Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_reward,
			this._img_reward_red,
			this._img_bg1,
			this._img_bg2,
			this._gp_enter,
			this._Image3,
			this._Label1,
			this._img_go_red,
			this._lb_time,
			this._img_wz_bg,
			this._txt_wz,
this._list_reward_con,
			this._box_kf,
this._img_kf,
this._lb_kf,
this._img_bg22,
this._html_kf_mode,
		]
			= this.GetChildrenByNames([

				"_img_reward",
				"_img_reward_red",
				"_img_bg1",
				"_img_bg2",
				"_gp_enter",
				"_Image3",
				"_Label1",
				"_img_go_red",
				"_lb_time",
				"_img_wz_bg",
				"_txt_wz",
"_list_reward_con",
				"_box_kf",
"_img_kf",
"_lb_kf",
"_img_bg22",
"_html_kf_mode",
			])
	}
}
window["HolyBattleEnterView"] = HolyBattleEnterView