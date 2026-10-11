import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CookieWrapper } from "../common/CookieWrapper"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LimitLevelShopModel } from "../commonModel/LimitLevelShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, NotEnougnDiamond, GlobalTimerQuest } from "../util/Util"
import { LimitLevelShopReward } from "./LimitLevelShopReward"
import { LimitLevelShopTabItem } from "./LimitLevelShopTabItem"

export class LimitLevelShopView extends BaseView1 {
	CancelCountTime
	ClearModel
	GetTabPos
	InitCfg
	InitEvent
	InitTab
	LoadSuccess
	Remove
	Scr_Scroller1
	SetActInfo
	StartCountTime
	SwitchTab
	UpdateBuyState
	UpdateView
	PlayRuneTweenOne
	PlayRuneTweenTwo
	_Viewport
	click_bg_toClose
	curr_sorting_order
	destroy_callback
	destroy_imm
	is_center
	need_loading_view
	open_callback
	show_open_movie
	use_background
	public constructor() {
		super()


		let model: LimitLevelShopModel = LimitLevelShopModel.GetInstance()
		let local_Number = Number
		let local_LimitLevelShopModel = LimitLevelShopModel
		let erlang_parser = ErlangParser.GetInstance()
		let cookie_wrapper = CookieWrapper.GetInstance()
		let local_TimeUtil = TimeUtil
		let icon_type_ = null
		let type_ = null
		let data_ = null
		let grade_data_ = null
		let tab_item_list_ = null
		let default_index_ = 0
		let now_index_ = null
		let reward_loop_mgr = null
		let show_model_ = null
		let _pos_list_ = [[90, 550], [290, 580], [500, 550]]
		let time_id_ = null
		let time_func_ = null
		let tween_id = null
		this.base_file = "limitLevelShop"
		this.layout_file = "LimitLevelShopView"
		this.layer_value = Enum_UILayer.Activity
		this.need_loading_view = false
		this.use_background = true
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_recharge_product": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.open_callback = () => {
			this._Scroller1.scrollBar.visible = false
			this.InitTab()
			this.SwitchTab(default_index_)
			// this._lable_tips.visible = model.GetGiftOpenTimes(data_.type, data_.subtype) >= 2 ? true : false
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.SetActInfo = (icon_type?, type?) => {
			icon_type_ = icon_type
			type_ = type
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._gp_buy, () => {
				let grade_state = data_.grade_state[now_index_]
				if (grade_state && grade_state.state == 0) {
					let grade_reward = grade_data_.grade_cfg[now_index_]
					let need_money = local_Number(grade_reward.cost)
					let cost = model.GetValueByErlang(grade_reward.condition, "cost_type")
					let cost_type = cost && Number(cost[1])
					if (cost_type == 3) {  //内玩代币
						let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
						if (hasNum >= (need_money / 10)) {
							VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', grade_reward.recharge_id);
						} else {
							let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
							let info = cfg[grade_reward.recharge_id]
							PlatformManager.GetInstance().PayRequest(need_money / 10, { id: grade_reward.recharge_id, pay_title: info.product_name });
						}
						return
					}

					let buy_request = () => {
						model.Fire(local_LimitLevelShopModel.SCMD_REQUEST, 61201, data_.type, data_.subtype, grade_state.grade)
					}

					let role_vo = RoleManager.GetInstance().mainRoleInfo
					let have_money = cost_type == 1 && role_vo.jin || role_vo.jinLock
					if (have_money >= need_money) {
						buy_request()
					} else {
						if (cost_type == 1) {
							NotEnougnDiamond()
							return
						} else if (cost_type == 2) {
							let str = "绑玉不足，是否消耗<font color='#639c12'>" + (need_money - role_vo.jinLock) + "勾玉</font>继续购买?"
							Alert.Show(Util.StrToHTML(str), Alert_Type.Two, buy_request)
							Alert.SetIsCharge(true)
						}
					}
				}else{
					Message.show("礼包限购一次，无法再次购买")
				}
			}
				, this, true)

			this.BindEvent(model, local_LimitLevelShopModel.BUY_SUCCESS, (type?, subtype?, grade?) => {
				if (data_ && data_.type == type && data_.subtype == subtype
					&& data_.grade_state[now_index_].grade == grade) {
					let [type, subtype] = model.IconType2Type(icon_type_)
					let data = model.GetTypeData(type)
					data_ = data
					this.UpdateBuyState()

					let grade_reward = grade_data_.grade_cfg[now_index_]
					let reward = erlang_parser.Parse(grade_reward.reward)
					Util.ShowCongratulationView(reward)
				}
			}
			)
		}

		this.LoadSuccess = () => {
			this._lable_tips.visible = false
			reward_loop_mgr = new LoopScrowViewMgr()
			reward_loop_mgr.SetData(this._Scroller1, LimitLevelShopReward, {}, LoopScrCon.Vertical, 4)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("limitLevelShop", "uidjqg_001"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("limitLevelShop", "uidjqg_003"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("limitLevelShop", "ui_midweek_10a"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_btn, GameResPath.GetIcon("limitLevelShop", "uidjqg_002"), true)

			//展示大图动画
			tween_id = SYTweenLite.to(this, this._img_show, SYTweenLite.UiAnimationType.ANCHORED_POSY, -30, 2, null, SYTweenFunc.PINGPONG, true)
			let [type, subtype] = model.IconType2Type(icon_type_)
			let data = model.GetTypeData(type)
			if (!data) {
				this.Close()
				return
			}

			data_ = data
			this.InitCfg()
			this.InitEvent()

			// LayoutRebuilder(this._Group2)
			// LayoutRebuilder(this._gp_price)

			let cond = model.GetGiftCond(data.type, data.subtype)
			if (cond && cond.title) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title,GameResPath.GetIconOtherPath( "limitLevelShop", cond.title), true)
			}

			let red = model.GetRedState(type, subtype)
			let key = type + "@" + subtype
			if (red) {
				let last_time_data //= cookie_wrapper.GetCookie(CookieLevelType.Account,CookieKey.LIMIT_LEVEL_SHOP_RED)
				let next_time = String(local_TimeUtil.GetFutureZeroStamp(1))
				let dic = null
				if (!last_time_data) {
					dic = []
					dic[key] = next_time
				} else {
					dic = last_time_data
					let last_time = dic[key]
					if (!last_time || local_TimeUtil.getServerTime() > local_Number(last_time)) {
						dic[key] = next_time
					}
				}

				// cookie_wrapper.SaveCookie(CookieLevelType.Account,CookieTimeType.TYPE_ALWAYS, CookieKey.LIMIT_LEVEL_SHOP_RED,dic)
				model.RefreshRedState(data)
			}

			this.StartCountTime(() => {
				let left_time = data.end_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelCountTime()
					return
				}
				this._lb_left_time.text = "购买剩余时间:" + local_TimeUtil.timeConvert(left_time, "dd-hh/hh-mm/mm-ss")
			}
				, 1)
		}

		this.InitCfg = () => {
			let grade_data = model.GetGiftData(data_.type, data_.subtype)
			if (grade_data) {
				grade_data_ = grade_data
			}

			let grade_state = data_.grade_state
			let select = null
			for (let _tmpi in grade_state) {
				var vo = grade_state[_tmpi]
				if (vo.state < 1 && select == null) {
					select = vo.grade - 1
				}
			}
			default_index_ = select != null && select || 0
		}

		this.InitTab = () => {
			let grade_list = grade_data_.grade_cfg
			let item = null
			if (!tab_item_list_) {
				tab_item_list_ = []
			}

			for (let key in grade_list) {
				let buy_state = data_.grade_state[local_Number(key)].state
				let vo = grade_list[key]
				item = tab_item_list_[key]
				if (!item) {
					item = new LimitLevelShopTabItem(this._gp_tab_con)
					item.Load()
					tab_item_list_[key] = item
					// item.ExcuteCallback(()=>{
					// 	item.display_obj.x=_pos_list_[key][0],
					// 	item.display_obj.y=_pos_list_[key][1]
					// })

				}
				item.SetData(data_.type, data_.subtype, buy_state, vo, local_Number(key), (index?) => {
					this.SwitchTab(index)
				}, _pos_list_[key])
			}
		}

		this.GetTabPos = (len?) => {

		}

		this.SwitchTab = (index?) => {
			if (now_index_ == index) {
				return
			}

			let last_item = tab_item_list_[now_index_]
			if (last_item) {
				last_item.SetSelect(false)
			}

			let now_item = tab_item_list_[index]
			if (now_item) {
				now_item.SetSelect(true)
			}

			now_index_ = index
			this.UpdateView()
		}

		this.UpdateView = () => {
			if (!grade_data_) {
				return
			}
			let grade_reward = grade_data_.grade_cfg[now_index_]
			if (!grade_reward) {
				return
			}

			//价格信息，奖励信息
			let list = []
			if (grade_reward) {
				let reward_list = erlang_parser.Parse(grade_reward.reward)
				for (let _tmpi in reward_list) {
					var vo = reward_list[_tmpi]
					table.insert(list, {
						size: 76,
						vo: {
							style: vo[0],
							typeId: vo[1],
							count: vo[2]
						}
					})
				}
				let cost_type = model.GetValueByErlang(grade_reward.condition, "cost_type")
				let url = ""
				if (cost_type) {
					if (cost_type[1] == "1") {
						url = "com_diamond"
					} else if (cost_type[1] == "2") {
						url = "com_bind_diamond"
					}
				}
				if (url != "") {
					this._img_now_price0.scaleX = 1
					this._img_last_price.scaleX = 1
					this._img_now_price.scaleX = 1
					ResManager.GetInstance().SetImageSprite(this, this._img_last_price, "common_asset", url)
					ResManager.GetInstance().SetImageSprite(this, this._img_now_price, "common_asset", url)
					ResManager.GetInstance().SetImageSprite(this, this._img_now_price0, "common_asset", url)
					this._lb_last_price.text = grade_reward.normal_cost
					this._lb_now_price.text = grade_reward.cost
					this._lb_now_price0.text = grade_reward.cost
				} else {
					this._img_now_price0.scaleX = 0
					this._img_last_price.scaleX = 0
					this._img_now_price.scaleX = 0
					this._lb_last_price.text = (grade_reward.normal_cost / 10) + "元"
					this._lb_now_price.text = (grade_reward.cost / 10) + "元"
					this._lb_now_price0.text = "仅售" + (grade_reward.cost / 10) + "元"
				}

			}

			reward_loop_mgr.replaceAll(list)

			//展示信息tips和show
			let tips_show = null
			let view_show = null
			this._img_tab.visible = false
			let show_list = erlang_parser.Parse(grade_reward.show)
			for (let i in show_list) {

				let c = show_list[i]
				if (c[0] == "tips_show") {
					tips_show = c
				}
				if (c[0] == "show") {
					view_show = c
				}

				if (c[0] == "tab_mark") {
					this._img_tab.visible = true
					ResManager.GetInstance().SetImageSprite(this, this._img_tab, "limitLevelShop", c[1])
				}


			}

			if (tips_show) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIconOtherPath("limitLevelShop", tips_show[1]), true)
			}


			if (view_show) {
				// console.warn("测试@view_show", view_show, grade_data_)
				let index = null
				let data = view_show[2]
				Laya.Tween.clearAll(this._gp_rune)
				if (view_show[1] == "show_model") {
					index = 0
					let model_id = null
					if (data[0]) {
						model_id = data[0]//data[0][1]
					}
					if (model_id) {
						CustomActivityModel.GetInstance().ShowViewModel(this, "LimitLevelShopView", model_id, this._gp_model, null, null, this.curr_sorting_order)
					}
					//if (type_ == 3
					//or type_ == 63
					//or type_ == 75 ) {
					//if (list[1] ) {
					//show_model_ = uiModel
					//}, true)
					//}
					//}else{
					//show_model_ =  new UIModelClass(this._gp_model, list, {x=10, y=75}, {x=1, y=1})
					//}

				} else if (view_show[1] == "show_icon") {
					index = 1
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_show,GameResPath.GetIconOtherPath("limitLevelShop", data))
				} else if (view_show[1] == "show_effect") {
					index = 2
					let scale = 2.6
					let pos = { x: 0, y: -2.8 }
					this.AddUIEffect(data, this._gp_effect, pos, scale, true)
				}else if(view_show[1] == "goods_id"){
					index = 3
					let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(view_show[2])
					this.ClearUIEffect(this._gp_rune_effect)
					this._gp_rune.y = 150
					if(basic){
						ResManager.GetInstance().SetTexture(this, this._img_rune, GameResPath.GetIconOtherPath("limitLevelShop", `card_${view_show[2]}`),undefined,undefined,true)
						let effect = basic.color == 4 ? "ui_yuhunkuang_03" : "ui_yuhunkuang_04"
						this.AddUIEffect(effect, this._gp_rune, { x: 0, y: -0.1 }, 5.5, true)
					}
					this.PlayRuneTweenOne()
					
				}


				this._gp_model.visible = index == 0
				this._img_show.visible = index == 1
				this._gp_effect.visible = index == 2
				this._gp_rune.visible = index == 3
				if (index != 2) {
					this.ClearUIEffect(this._gp_effect)
				}
				if (index != 0) {
					this.ClearModel()
				}
				if(index != 3){
					this.ClearUIEffect(this._gp_rune_effect)
				}
			}
			this.UpdateBuyState()
		}

		this.PlayRuneTweenOne = () => {
			Laya.Tween.to(this._gp_rune, { y: this._gp_rune.y + 10 }, 1000, null, Laya.Handler.create(this, () => {
				this.PlayRuneTweenTwo()
			}))
		}

		this.PlayRuneTweenTwo = () => {
			Laya.Tween.to(this._gp_rune, { y: this._gp_rune.y - 10 }, 1000, null, Laya.Handler.create(this, () => {
				this.PlayRuneTweenOne()
			}))
		}
		this.UpdateBuyState = () => {
			let grade_state = data_.grade_state[now_index_]
			this._gp_price.visible = grade_state.state == 0
			this._lb_btn.text = grade_state.state == 0 && "立即抢购" || "已购买"
		}

		this.Remove = () => {
			this.CancelCountTime()
			Laya.Tween.clearAll(this._gp_rune)
			this.ClearUIEffect(this._gp_effect)
			this.ClearUIEffect(this._gp_rune_effect)
			this.ClearModel()
			if (tab_item_list_) {
				for (let _tmpi in tab_item_list_) {
					var obj = tab_item_list_[_tmpi]
					obj.DeleteMe()
				}
				tab_item_list_ = null
			}

			if (reward_loop_mgr) {
				reward_loop_mgr.DeleteMe()
				reward_loop_mgr = null
			}

			if (tween_id) {
				SYTweenLite.Stop(tween_id)
				tween_id = null
			}
			now_index_ = null
		}

		this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}

		this.StartCountTime = (func?, time?) => {
			this.CancelCountTime()
			time_func_ = func
			time_id_ = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}

		this.CancelCountTime = () => {
			if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
				time_func_ = null
				time_id_ = null
			}
		}


	}


	_img_bg:Laya.Image
	_img_title:Laya.Image
	_img_bg2:Laya.Image
	_img_bg1:Laya.Image
	_lb_left_time:Laya.Label
	_img_show_bg:Laya.Image
	_gp_rune:Laya.Box
	_img_rune:Laya.Image
	_gp_rune_effect:Laya.Box
	_gp_show:Laya.Box
	_gp_model:Laya.Box
	_gp_effect:Laya.Box
	_img_show:Laya.Image
	_img_tips:Laya.Image
	_gp_buy:Laya.Box
	_img_btn:Laya.Image
	_lb_btn:Laya.Label
	_Group2:Laya.HBox
	_Label1:Laya.Label
	_img_last_price:Laya.Image
	_lb_last_price:Laya.Label
	_Group1:Laya.Box
	_Label2:Laya.Label
	_img_now_price:Laya.Image
	_lb_now_price:Laya.Label
	_gp_tab_con:Laya.Box
	_Scroller1:Laya.List
	_img_close:Laya.Image
	_gp_price:Laya.HBox
	_img_now_price0:Laya.Image
	_lb_now_price0:Laya.Label
	_Image1:Laya.Image
	_img_tab:Laya.Image
	_lable_tips:Laya.Label


	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_bg2,
			this._img_bg1,
			this._lb_left_time,
			this._img_show_bg,
			this._gp_rune,
			this._img_rune,
			this._gp_rune_effect,
			this._gp_show,
			this._gp_model,
			this._gp_effect,
			this._img_show,
			this._img_tips,
			this._gp_buy,
			this._img_btn,
			this._lb_btn,
			this._Group2,
			this._Label1,
			this._img_last_price,
			this._lb_last_price,
			this._Group1,
			this._Label2,
			this._img_now_price,
			this._lb_now_price,
			this._gp_tab_con,
			this._Scroller1,
			this._img_close,
			this._gp_price,
			this._img_now_price0,
			this._lb_now_price0,
			this._Image1,
			this._img_tab,
			this._lable_tips
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_bg2",
				"_img_bg1",
				"_lb_left_time",
				"_img_show_bg",
				"_gp_rune",
				"_img_rune",
				"_gp_rune_effect",
				"_gp_show",
				"_gp_model",
				"_gp_effect",
				"_img_show",
				"_img_tips",
				"_gp_buy",
				"_img_btn",
				"_lb_btn",
				"_Group2",
				"_Label1",
				"_img_last_price",
				"_lb_last_price",
				"_Group1",
				"_Label2",
				"_img_now_price",
				"_lb_now_price",
				"_gp_tab_con",
				"_Scroller1",
				"_img_close",
				"_gp_price",
				"_img_now_price0",
				"_lb_now_price0",
				"_Image1",
				"_img_tab",
				"_lable_tips"
			])
	}
}
 window["LimitLevelShopView"]= LimitLevelShopView