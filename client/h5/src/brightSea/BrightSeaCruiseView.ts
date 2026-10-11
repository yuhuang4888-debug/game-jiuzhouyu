import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HaloModel } from "../commonModel/HaloModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Status } from "../util/Status"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, HtmlColorTxt, RefBoxChildsLayout, SetAnchoredPositionX, SetSizeDeltaX, Util } from "../util/Util"
import { BrightSeaCruiseItem } from "./BrightSeaCruiseItem"

export class BrightSeaCruiseView extends BaseView1 {
	ChangeLuckyValue
	ChangeLuckyValueFinished
	InitEvent
	LoadSuccess
	ScrScrollView
	ScrollView
	SetMaxLuckValue
	SetSliderValue
	StopTimers
	UpdateCost
	UpdateProgress
	UpdateToggle
	UpdateView
	InitHalo
	UpdateHalo


	cost_type_id
	item_list
	max_luck_value
	max_ship_id
	model
	my_ship_data
	sea_event
	ship_list
	timers
	tweens
	slider_value
	ClearTween

	//require("game.brightSea.BrightSeaCruiseItem")
	public constructor() {
		super()


		this.base_file = "brightSea"
		this.layout_file = "BrightSeaCruiseView"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.slider_value = 519
		this.preload_server_config =
		{
			"config_sea_treasure_reward": false,
			"config_sea_treasure_kv": false
		}
		this.model = BrightSeaModel.GetInstance()
		this.sea_event = BrightSeaEvent
		this.item_list = null
		this.tweens = []
		this.timers = []
		let goods_model = GoodsModel.GetInstance()
		let levelup_click_time = null
		let click_interval = 0.2

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("brightSea", "ui_bright_02"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("brightSea", "uixhrz_005"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._picture, GameResPath.GetIcon("brightSea", "uixhrz_005a"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._luck_bg, GameResPath.GetIcon("brightSea", "uixhrz_11a"))
			this.UpdateView()
			this.InitHalo()
		}

		this.InitHalo = () => {
			//光环
			this.UpdateHalo()
			Util.AddClickEvent(this._lb_halo_tips, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
			}, this, false)
		}

		this.UpdateHalo = () => {
			if (HaloModel.GetInstance().GetOpenState()) {
				this._box_halo.visible = true
				if (HaloModel.GetInstance().GetHaloOpenState()) {
					this._img_merge_count.visible = false
					this._lb_halo_tips.visible = false
				}
				else {
					this._img_merge_count.visible = false
					this._lb_halo_tips.visible = true
				}
			}
			else {
				this._box_halo.visible = false
			}
		}


		this.open_callback = () => {
			this.model.Fire(this.sea_event.REQUEST_PROTO, 18902)
		}

		this.close_callback = () => {
			this.StopTimers()
			this.my_ship_data = null
			this.ship_list = null
			if (this.item_list) {
				this.item_list.DeleteMe()
				this.item_list = null
			}
			this.ClearTween()
		}

		this.ClearTween = () => {
			if (this.tweens) {
				for (let _ in this.tweens) {
					var tween_id = this.tweens[_]
					SYTweenLite.Stop(tween_id)
				}
			}
			this.tweens = []
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this._btn_levelup, () => {
				if (!levelup_click_time) {
					levelup_click_time = Status.NowTime
				} else {
					if (Status.NowTime - levelup_click_time < click_interval) {
						return
					} else {
						levelup_click_time = Status.NowTime
					}
				}

				if (!this.my_ship_data) {
					return
				}
				let auto = this.model.onekey_toggle && 1 || 0
				this.model.Fire(this.sea_event.REQUEST_PROTO, 18914, this.my_ship_data.shipping_id, auto)
			}, this, true)

			Util.AddClickEvent(this._btn_confirm, () => {
				if (this.my_ship_data) {
					let have_num = this.my_ship_data.total_reward_times - this.my_ship_data.reward_times
					if (have_num < 1) {
						Alert.Show("今日次数已用完,次数每日4点重置", Alert_Type.One, null, null, "确定", "取消")
						return
					}
				}

				if (!this.ship_list) {
					return
				}
				let index = this._Content.selectedIndex
				if (!this.ship_list[index]) {
					return
				}
				this.max_ship_id = this.max_ship_id || 1
				let cur_ship_id = this.ship_list[index].id
				let start = () => {
					this.model.Fire(this.sea_event.REQUEST_PROTO, 18903, cur_ship_id)
				}
				if (cur_ship_id < this.max_ship_id) {
					Alert.Show("当前使用的船只<font color='#ff0000'>无法获得最大收益</font>。<br>是否仍要前往巡航?", Alert_Type.Two, () => {
						start()
					}, null, "确定", "取消")
				} else {
					// 航海
					start()
				}
			}, this, true)

			Util.AddClickEvent(this._img_onekey, () => {
				// 一键神船开关
				this.model.onekey_toggle = !this.model.onekey_toggle
				this.UpdateToggle()
			}, this)

			this.BindEvent(this.model, this.sea_event.CRUISE_CALLBACK, () => {
				this.Close()
			})

			this.BindEvent(this.model, this.sea_event.UPDATE_SHIP_INFO, (data?) => {
				this.my_ship_data = data
				this.UpdateView()
			})
			this.BindEvent(this.model, this.sea_event.UPDATE_LEVELUP_SHIP, (data?) => {
				this.UpdateProgress(data)
			})
		}

		this.UpdateToggle = () => {
			let sp_name = this.model.onekey_toggle && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this._img_onekey, "common_asset", sp_name, true)

			this.UpdateCost()
		}

		this.SetMaxLuckValue = (ship_id?) => {
			let max_luck_value = 5
			let sea_ship_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_treasure_reward", false)//Config.Seatreasurereward
			for (let _ in sea_ship_cfg) {
				var reward_data = sea_ship_cfg[_]
				if (reward_data.id == ship_id) {
					max_luck_value = reward_data.value
					break
				}
			}
			this.max_luck_value = max_luck_value
		}

		this.UpdateView = () => {
			let my_ship_data = this.my_ship_data
			let sea_ship_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_treasure_reward", false)//Config.Seatreasurereward
			let ship_list = []
			let select_index = 1
			let max_luck_value = 5
			this.max_ship_id = 1
			for (let _ in sea_ship_cfg) {
				var reward_data = sea_ship_cfg[_]
				table.insert(ship_list, reward_data)
				if (my_ship_data) {
					if (reward_data.id == my_ship_data.shipping_id) {
						max_luck_value = reward_data.value
					}
				}
				if (reward_data.id > this.max_ship_id) {
					this.max_ship_id = reward_data.id
				}
			}
			table.sort(ship_list, (ship1?, ship2?) => {
				if (ship1.id != ship2.id) {
					return ship1.id > ship2.id
				}
				return false
			})
			let len = ship_list.length
			this.ship_list = ship_list
			this.max_luck_value = max_luck_value
			if (len > 0) {

				if (!my_ship_data || !my_ship_data.shipping_id) {
					select_index = len - 1
				} else {
					select_index = Math.min(len - my_ship_data.shipping_id + 1, len) - 1
				}


				if (!this.item_list) {
					this.item_list = new LoopScrowViewMgr()
					this.item_list.SetData(this._Content, BrightSeaCruiseItem, ship_list, LoopScrCon.Vertical)
					this._Content.scrollBar.touchScrollEnable = false//禁用滚动
				} else {
					this.item_list.replaceAll(ship_list)
				}
				this.item_list.SetSelectIndex(select_index)
			}
			this.UpdateToggle()
			this.UpdateCost()
			if (my_ship_data) {
				if (this.max_luck_value <= 0) {
					// 最大等级
					this.SetSliderValue(1, 1)
				} else {
					this.SetSliderValue(this.my_ship_data.luckey_value, this.max_luck_value)
				}
			}
			//this:ChangeLuckyValue(10, 50, 100, true, 10)
		}

		this.UpdateCost = () => {
			let my_ship_data = this.my_ship_data
			let show_cost = this.model.onekey_toggle
			if (my_ship_data) {
				let have_free_num = my_ship_data.total_up_times - my_ship_data.up_times
				this._luck_value.text = my_ship_data.luckey_value + "/" + this.max_luck_value

				let free_str = have_free_num + ""
				if (have_free_num <= 0) {
					free_str = "<font color='#ff0000'>" + have_free_num + "</font>"
				}
				this._free_num.text = free_str + "/" + my_ship_data.total_up_times

				let have_reward_num = (my_ship_data.total_reward_times - my_ship_data.reward_times)
				let str = have_reward_num <= 0 ? HtmlColorTxt(have_reward_num + "", "'#ff0000'") : have_reward_num + ""
				this._cruise_num.text = str + "/" + my_ship_data.total_reward_times

				if (have_free_num < 1 || show_cost) {
					this._con_free.visible = false
					this._gp_cost.visible = true
					show_cost = true
				} else {
					this._con_free.visible = true
					this._gp_cost.visible = false
				}

				// 最大等级
				if (this.max_luck_value <= 0) {
					this._luck_value.text = "已达到最高档次"
				}
			} else {
				this._luck_value.text = "0/0"
				this._free_num.text = "0/0"
				this._cruise_num.text = "0/0"
			}

			if (show_cost) {
				let cost
				if (this.model.onekey_toggle) {
					cost = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_treasure_kv", false)["one_step_max_ship_cost"].value
					//Config.Seatreasurekv["one_step_max_ship_cost"].value
				} else {
					let sea_ship_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_treasure_reward", false)// Config.Seatreasurereward
					let data_cfg = sea_ship_cfg[my_ship_data.shipping_id]
					cost = data_cfg.cost
				}
				let cost_list = ErlangParser.GetInstance().parse(cost)
				cost = cost_list[0]
				if (cost) {
					let [type_id, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
					this.cost_type_id = type_id
					let cost_need_num = Number(cost[2])
					let basic = goods_model.GetGoodsBasicByTypeId(type_id)
					if (basic) {
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(basic.goods_icon))
					}
					this._lb_cost.text = cost_need_num + ""
					RefBoxChildsLayout(this._gp_cost)
				}
			}
		}

		this.UpdateProgress = (new_data?) => {
			if (!this.my_ship_data) {
				return
			}
			this.SetMaxLuckValue(new_data.shipping_id)
			let old_value = this.my_ship_data.luckey_value
			let new_value = new_data.luckey_value
			let up_lv = new_data.shipping_id - this.my_ship_data.shipping_id
			let is_levelup = up_lv > 0
			this.ChangeLuckyValue(old_value, new_value, this.max_luck_value, is_levelup, up_lv)

			let old_ship_id = this.my_ship_data.shipping_id
			this.my_ship_data.shipping_id = new_data.shipping_id
			this.my_ship_data.luckey_value = new_data.luckey_value
			this.my_ship_data.up_times = new_data.up_times
			this.my_ship_data.total_up_times = new_data.total_up_times

			if (is_levelup) {
				this.UpdateView()
				let anim_num = new_data.shipping_id - old_ship_id
				let time = 0
				let timer_id
				this.StopTimers()
				for (let i = old_ship_id + 1; i <= new_data.shipping_id; i++) {
					timer_id = GlobalTimerQuest.AddDelayQuest(() => {
						this.model.Fire(this.sea_event.LEVELUP_SHIP, i, new_data.shipping_id)
					}, time)
					time = time + 0.5
					table.insert(this.timers, timer_id)
				}
			}

			this.UpdateCost()
		}

		this.StopTimers = () => {
			if (this.timers) {
				for (let _ in this.timers) {
					var timer_id = this.timers[_]
					GlobalTimerQuest.CancelQuest(timer_id)
				}
				this.timers = []
			}
		}

		this.ChangeLuckyValueFinished = () => {
			if (this.my_ship_data) {
				if (this.max_luck_value <= 0) {
					this.SetSliderValue(1, 1)
				} else {
					this.SetSliderValue(this.my_ship_data.luckey_value, this.max_luck_value)
				}
			}
		}

		this.SetSliderValue = (value?, max_value?) => {
			if (max_value > 0) {
				this._slider_value.width = value / max_value * this.slider_value
			} else {
				if (this.max_luck_value <= 0) {
					this._slider_value.width = 1
				} else {
					this._slider_value.width = 0
				}
			}
		}

		let FULL_VALUE_TIME = 0.5
		this.ChangeLuckyValue = (old_value?, new_value?, max_value?, is_levelup?, change_lv?) => {
			this.ClearTween()
			let time = FULL_VALUE_TIME
			if (!is_levelup || !change_lv || change_lv < 1) {
				time = (new_value - old_value) / (max_value != 0 && max_value || 100) * FULL_VALUE_TIME
				let slider_value = new_value / (max_value != 0 && max_value || 100)
				this.SetSliderValue(old_value, max_value)
				let tween_id = SYTweenLite.to(this, this._slider_value, SYTweenLite.UiAnimationType.WIDTH, slider_value, time, () => {
					this.ChangeLuckyValueFinished()
				})
				table.insert(this.tweens, tween_id)
			} else {
				if (change_lv && change_lv > 0) {
					time = (max_value - old_value) / (max_value != 0 && max_value || 1) * FULL_VALUE_TIME
					this.SetSliderValue(old_value, max_value)
					let tween_id = SYTweenLite.to(this, this._slider_value, SYTweenLite.UiAnimationType.WIDTH, 1, time, () => {
						this._slider_value.width = 0
						if (change_lv && change_lv > 0) {
							this.ChangeLuckyValue(0, 1, max_value, true, change_lv - 1)
						} else {
							this.ChangeLuckyValue(0, new_value, max_value, false)
						}
					})
					table.insert(this.tweens, tween_id)
				}
			}

		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_Image1: Laya.Image
	_close_btn: Laya.Image
	bg: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_luck_bg: Laya.Image
	_picture: Laya.Image
	_Content: Laya.List
	_btn_levelup: Laya.Box
	_Image6: Laya.Image
	_Label41: Laya.Label
	_con_free: Laya.Box
	label11: Laya.Label
	_free_num: Laya.Label
	_gp_cost: Laya.Box
	_lb_label: Laya.Label
	_img_cost: Laya.Image
	_lb_cost: Laya.Label
	_btn_confirm: Laya.Box
	_Image61: Laya.Image
	_Label4: Laya.Label
	_box_select: Laya.Box
	lb_onekey: Laya.Label
	label: Laya.Label
	_img_onekey: Laya.Image
	_cruise_num: Laya.Label
	label1: Laya.Label
	_con_luck: Laya.Box
	slider_bg: Laya.Image
	_slider_value: Laya.Image
	_luck_value: Laya.Label
	img_luck: Laya.Image
	img_luck2: Laya.Image
	img_sale: Laya.Image
	_box_halo: Laya.Box
	_img_merge_count: Laya.Image
	_lb_halo_tips: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._close_btn,
			this.bg,
			this._Image2,
			this._Image3,
			this._luck_bg,
			this._picture,
			this._Content,
			this._btn_levelup,
			this._Image6,
			this._Label41,
			this._con_free,
			this.label11,
			this._free_num,
			this._gp_cost,
			this._lb_label,
			this._img_cost,
			this._lb_cost,
			this._btn_confirm,
			this._Image61,
			this._Label4,
			this._box_select,
			this.lb_onekey,
			this.label,
			this._img_onekey,
			this._cruise_num,
			this.label1,
			this._con_luck,
			this.slider_bg,
			this._slider_value,
			this._luck_value,
			this.img_luck,
			this.img_luck2,
			this.img_sale,
			this._box_halo,
			this._img_merge_count,
			this._lb_halo_tips,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_close_btn",
				"bg",
				"_Image2",
				"_Image3",
				"_luck_bg",
				"_picture",
				"_Content",
				"_btn_levelup",
				"_Image6",
				"_Label41",
				"_con_free",
				"label11",
				"_free_num",
				"_gp_cost",
				"_lb_label",
				"_img_cost",
				"_lb_cost",
				"_btn_confirm",
				"_Image61",
				"_Label4",
				"_box_select",
				"lb_onekey",
				"label",
				"_img_onekey",
				"_cruise_num",
				"label1",
				"_con_luck",
				"slider_bg",
				"_slider_value",
				"_luck_value",
				"img_luck",
				"img_luck2",
				"img_sale",
				"_box_halo",
				"_img_merge_count",
				"_lb_halo_tips",
			])
	}
}
window["BrightSeaCruiseView"] = BrightSeaCruiseView