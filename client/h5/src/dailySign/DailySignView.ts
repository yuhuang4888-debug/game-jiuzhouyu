import { Alert_Type, Alert } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { WelfareModel, WelfareEvent, AdModuleId } from "../commonModel/WelfareModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { DailySignItem } from "./DailySignItem"
import { DailySignTotalItem } from "./DailySignTotalItem"
import { DailyTipsView } from "./DailyTipsView"
import { Config } from "../common/Config"

export class DailySignView extends BaseItem1 {
	bg: Laya.Image
	bg1: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image4: Laya.Image
	reset_label: Laya.HTMLDivElement
	_Image5: Laya.Image
	retroactive_label: Laya.HTMLDivElement
	bg2: Laya.Image
	_Image6: Laya.Image
	_Group2: Laya.HBox
	_Label1: Laya.Label
	timer_label: Laya.Label
	bar_bg: Laya.Image
	bar_heigh_light: Laya.Image
	_data_scroller: Laya.List
	bottom_group: Laya.HBox
	InitEvent
	InitView
	LoadSuccess
	Local_DeleteMe
	Scr_data_scroller
	_Image2
	_Image3
	_data_viewport
	// ad_btn
	checkin_list
	tips_view
	total_list
	Setprogress
	is_first_open=true
	public constructor(parent?) {
		super(parent)


		this.checkin_list = []
		this.total_list = []
		this.tips_view = null
		this.base_file = "dailySign"
		this.layout_file = "DailySignView"
		let model = WelfareModel.GetInstance()
		let local_Util = Util

		let local_WelfareEvent = WelfareEvent
		let daily_model = DailyModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_Alert_Type = Alert_Type
		let sign_arr_ = null
		let bottom_arr_ = null
		let checkin_type_ = 1
		let total_type_ = 1
		let bar_len_ = null
		let checkin_type_cfg_ = null
		let checkin_reward_cfg_ = null
		let total_checkin_reward_cfg_ = null
		let daily_retroactive_cfg_ = null
		let content_cfg_ = null
		let timer_id_ = null
		let ad_cfg = null
		let ProgressBarMax=551
		this.preload_server_config = {
			"config_checkin_type": false,
			"config_checkin_daily_rewards": false,
			"config_checkin_total_rewards": false,
			"config_checkin_daily_retroactive": false,
			"config_checkin_key_value": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.reset_label.size  = 18
			// 	this.retroactive_label.size  = 18
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this.reset_label.size  = 16
			// 	this.retroactive_label.size  = 16
			// }
			checkin_type_cfg_ = this.preload_server_config["config_checkin_type"]
			checkin_reward_cfg_ = this.preload_server_config["config_checkin_daily_rewards"]
			total_checkin_reward_cfg_ = this.preload_server_config["config_checkin_total_rewards"]
			daily_retroactive_cfg_ = this.preload_server_config["config_checkin_daily_retroactive"]
			content_cfg_ = this.preload_server_config["config_checkin_key_value"]

			// this.RegisterMask(this._data_viewport)

			//if (this.use_delete_method ) {
			//lua_resM:DestroyAllReferenceRes(this.hashCode)
			//return
			//}

			//lua_resM:SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("dailySign","uiqd_006"), true)
			//lua_resM:SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("dailySign","uiqd_012"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bar_bg, GameResPath.GetIcon("dailySign", "ProgressBg"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bar_heigh_light, GameResPath.GetIcon("dailySign", "ProgressBar"))
			ResManager.GetInstance().SetOutsideImageSprite(this,this.bg,GameResPath.GetIcon("dailySign","uiqd_004_2"))
			bar_len_ = 551

			if (checkin_type_cfg_
				&& checkin_reward_cfg_
				&& total_checkin_reward_cfg_
				&& daily_retroactive_cfg_
				&& content_cfg_) {
				this.InitView()
				this.InitEvent()
			}
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_WelfareEvent.RETROACTIVE, (day?, vip_?, reward_?) => {
				if (!daily_retroactive_cfg_) {
					return
				}

				let retro_count = model.dailysigndata.retro_times
				let retro_cfg = daily_retroactive_cfg_[retro_count + 1]
				if (retro_cfg) {
					let live_limit = content_cfg_["liveness_retro_times"].value
					let max_retro_time = content_cfg_["max_retro_time"].value
					let chekin_retro_times = content_cfg_["chekin_retro_times"].value
					let live_data = daily_model.liveness_reward
					if (model.dailysigndata.remain_times <= 0) {
						let receiced_str = ""
						if (daily_model.liveness_reward && daily_model.liveness_reward.live >= live_limit) {
							receiced_str = "(已获得)"
						}
						Alert.Show(("今日活跃度达<font color='#ff9015'>" + live_limit + "</font>以上即可获得1次补签机会" + receiced_str + "<br/>本月已获得<font color='#639c12'>" + (retro_count - chekin_retro_times) + "/</font><font color='#639c12'>" + max_retro_time + "</font>次"), local_Alert_Type.One, null, null, "确定", null, null, null, null, null, null, null, null, "补签次数不足")
					} else {
						let money = retro_cfg.price
						let type = retro_cfg.money_type
						let Retroactive = () => {
							let request_fun = () => {
								model.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41704, "cc", day, 1)
							}
							let ok_func = () => {
								if (vip_ > 0) {
									let my_vip = VipModel.GetInstance().GetVipLevel()
									if (my_vip < vip_) {
										let str = "提升至<font color='#0a953e'>VIP" + vip_ + "</font>，本次签到可领取<font color='#0a953e'>2</font>倍奖励"
										let jump_fun = () => {
											OpenFun.OpenFunHandler(23)
										}
										let tips_view = new DailyTipsView(2, str, null, jump_fun, request_fun, reward_)
										tips_view.Open()
									} else {
										request_fun()
									}
								} else {
									request_fun()
								}

							}

							if (role_mgr.GetMainRoleVo().jinLock >= money) {
								ok_func()
							} else {
								if (role_mgr.GetMainRoleVo().jinLock + role_mgr.GetMainRoleVo().jin >= money) {
									let check_func = (bool?) => {
										model.show_jinlock_to_jin = !bool
									}

									if (model.show_jinlock_to_jin) {
										let jin_str = "当前绑定勾玉不足,是否消耗勾玉代替？"
										Alert.Show(jin_str, local_Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_func, "本次登录不再提示")
										Alert.SetIsCharge(true)
									} else {
										ok_func()
									}
								} else {
									Message.show("绑玉和勾玉不足")
								}
							}
						}

						let content = "本月已补签:<font color='#0a953e'>" + retro_count + "</font>次"
						let money_text = "本次补签花费 <font color='#0a953e'>" + money + "</font>"
						let SignTipsView = new DailyTipsView(1, content, money_text, Retroactive)
						SignTipsView.Open()
					}
				}
			}
			)

			this.BindEvent(model, local_WelfareEvent.UPDATE_DAILY_SIGN_DATA, () => {
				this.InitView()
			}
			)
		}

		this.InitView = () => {
			if (!checkin_type_cfg_
				|| !checkin_reward_cfg_
				|| !total_checkin_reward_cfg_
				|| !daily_retroactive_cfg_
				|| !model.dailysigndata) {
				return
			}
			//每日
			checkin_type_ = model.dailysigndata.check_type
			total_type_ = model.dailysigndata.total_type
			let acc_state = model.dailysigndata.acc_state
			let today_num = null
			if (acc_state) {
				for (let _tmpi in acc_state) {
					var vo = acc_state[_tmpi]
					if (vo.receive == 3) {
						today_num = vo.check_day
					}
					let cfg = checkin_reward_cfg_[checkin_type_ + "@" + vo.check_day]
					if (cfg) {
						vo["cfg"] = cfg
					}
				}
				if(!sign_arr_){
					sign_arr_ = new LoopScrowViewMgr()
					sign_arr_.SetData(this._data_scroller, DailySignItem, acc_state, LoopScrCon.Vertical, 5)
				}else{
					sign_arr_.replaceAll(acc_state)
				}
				let last_count = acc_state.length - model.dailysigndata.days_fresh
				this.reset_label.innerHTML = Util.StrToHTML("<font color='#ffe96c'>" + last_count + "天</font>后重置")
				this.reset_label.x=this._Image4.width/2-this.reset_label.contextWidth/2
				this.reset_label.y=this._Image4.height/2-this.reset_label.contextHeight/2
			}

			//累计
			let total_state = model.dailysigndata.total_state

			if (total_state) {

				if (!bottom_arr_) {
					bottom_arr_ = []
				}

				for (let i = 0; i < total_state.length; i++) {
					let vo = total_state[i]
					let cfg = total_checkin_reward_cfg_[total_type_ + "@" + vo.sum]
					if (cfg) {
						vo["cfg"] = cfg
					}

					let item = bottom_arr_[i]
					if (!item) {
						item = new DailySignTotalItem(this.bottom_group)
						item.Load()
						bottom_arr_[i] = item
						item.ExcuteCallback(()=>{
							if(i==total_state.length-1 && this.is_first_open){
								this.Setprogress(total_state,acc_state)
								this.is_first_open=false
							}
						})
					}
					item.SetData(total_state[i])
				}
			}
			// LayoutRebuilder(this.bottom_group)

			if(!this.is_first_open){
				this.Setprogress(total_state,acc_state)
			}

			this.timer_label.text = model.dailysigndata.total_days.toString()
			this.retroactive_label.innerHTML = Util.StrToHTML("补签机会:<font color='#ffe96c'>" + model.dailysigndata.remain_times + "次</font>")
			this.retroactive_label.x=this._Image5.width/2-this.retroactive_label.contextWidth/2
			this.retroactive_label.y=this._Image5.height/2-this.retroactive_label.contextHeight/2
			// LayoutRebuilder(this._Group2)


			// if (today_num && (today_num / 5) > 4) {
				// let h = Mathf.Ceil(today_num / 5) * 146 - this._data_viewport.rect.height
				// if (h > 0) {
					// this._sign_group.pos(0,h)// = new Vector2(0, h)
					// sign_arr_.WrapContent()
				// }
			// }
		}

		this.Setprogress=(total_state?,acc_state?)=>{
			let times = model.dailysigndata.total_days
			if (total_state && total_state[0]) {
				//进度条
				let value = 0
				let _half = 83 / 2
				let min_times = total_state[0].sum
				let max_times = total_state[total_state.length-1].sum
				if (times <= min_times) {
					//小于第一档
					let item = bottom_arr_[0]
					let item_x = Math.abs(item.display_obj.x) + _half
					if (item) {
						value = item_x * (times / total_state[0].sum)
					}
				} else if (min_times < times && times < max_times) {
					//中间档
					// value+=_half 
					for (let i = 1; i < total_state.length; i++) {
						if (!total_state[i]) {
							return
						}
						// if (times >= total_state[i].sum ) {
							if(times>total_state[i].sum){
								value+=133  
								continue
							} 
							// let curr_item = bottom_arr_[i]
							// let nest_item = bottom_arr_[i+1]
							// let curr_item_x = curr_item.display_obj.x + _half	
							// let nest_item_x = nest_item.display_obj.x + _half
							// let add_width = nest_item_x - curr_item_x
							// let add_times = (times - total_state[i].sum) / (total_state[i+1].sum-total_state[i].sum )
							// value += curr_item_x + add_width * add_times
							value+=133/(total_state[i].sum-total_state[i-1].sum)*(times-total_state[i-1].sum)
							break
						// }
					}

				} else if (times >= max_times) {
					//大于最后一档
					// let max_item = bottom_arr_[total_state.length - 1]
					// let max_item_x = max_item.display_obj.x + _half
					// let add_width = bar_len_ - max_item_x
					// let add_times = (times - max_times) / (acc_state.length - max_times)
					value+=551
					// value += (bar_len_-573.5)/(acc_state.length- max_times )*(times-max_times )
				}
				this.bar_heigh_light.width = Mathf.Clamp01(value / bar_len_)*ProgressBarMax
			}
		}

		this.Local_DeleteMe = () => {

			if (sign_arr_) {
				sign_arr_.DeleteMe()
				sign_arr_ = null
			}

			if (bottom_arr_) {
				for (let k in bottom_arr_) {
					var item = bottom_arr_[k]
					if (item) {
						item.DeleteMe()
					}
				}
				bottom_arr_ = null
			}

			model.show_story_arrow_day = null
		}

	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.bg,
			this.bg1,
			this._Group1,
			this._Image1,
			this._Image4,
			this.reset_label,
			this._Image5,
			this.retroactive_label,
			this.bg2,
			this._Image6,
			this._Group2,
			this._Label1,
			this.timer_label,
			this.bar_bg,
			this.bar_heigh_light,
			this._data_scroller,
			this.bottom_group,
			this._Group1,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"bg",
				"bg1",
				"_Group1",
				"_Image1",
				"_Image4",
				"reset_label",
				"_Image5",
				"retroactive_label",
				"bg2",
				"_Image6",
				"_Group2",
				"_Label1",
				"timer_label",
				"bar_bg",
				"bar_heigh_light",
				"_data_scroller",
				"bottom_group",
				"_Group1",
				"_Image1",
			])
		this.reset_label.style.fontSize=18
		this.reset_label.style.color="#ffffff"
		this.reset_label.style.wordWrap=false
		this.retroactive_label.style.fontSize=18
		this.retroactive_label.style.color="#ffffff"
		this.retroactive_label.style.wordWrap=false
	}
}
window["DailySignView"]=DailySignView