import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Util, NotEnougnDiamond, GlobalTimerQuest, Split, Trim, Color, SetAnchoredPosition, SetSizeDeltaY, GetSizeDeltaX, SetAnchoredPositionX, RefGridLayout, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { FtvActivenessAllItem } from "./FtvActivenessAllItem"
import { FtvActivenessPersonalItem } from "./FtvActivenessPersonalItem"
import { FtvActivenessReward } from "./FtvActivenessReward"


export class FtvActivenessMainView extends BaseItem1 {
	_img_titlebg: Laya.Image
	_lb_time: Laya.HTMLDivElement
	_lb_dec: Laya.HTMLDivElement
	_Image2: Laya.Image
	_lb_all: Laya.Label
	_Image3: Laya.Image
	_img_all_mask: Laya.Image
	_img_all: Laya.Image
	_gp_all_num: Laya.Box
	_gp_all_icon: Laya.VBox
	_Image10: Laya.Image
	_lb_dec_goods: Laya.HTMLDivElement
	_Image5: Laya.Image
	_Scroller1: Laya.Panel
	_gp_reward: Laya.VBox
	_Scroller2: Laya.Panel
	_Content1: Laya.Box
	_gp_personal: Laya.HBox
	_img_per_bg: Laya.Image
	_img_personal: Laya.Image
	_Image9: Laya.Image
	_lb_num0: Laya.Label
	_lb_num1: Laya.Label
	_btn_jin: Laya.Box
	_Image7: Laya.Image
	_Text7: Laya.Label
	_gp_jin: Laya.HBox
	_lb_jin_num: Laya.Label
	_Image6: Laya.Image
	_btn_good: Laya.Box
	_Image8: Laya.Image
	_Text8: Laya.Label
	_img_red: Laya.Image
	_gp_good: Laya.HBox
	_lb_good_num: Laya.Label
	_img_good_icon: Laya.Image
	_lb_have_num: Laya.HTMLDivElement
	_gp_effect: Laya.Box
	_lb_count_down: Laya.HTMLDivElement
	reward_bg:Laya.Image
	box_layout:Laya.Box
	CustomMehod
	InitAllItem
	InitEvent
	InitPersonalItem
	InitRewardItem
	InitView
	JumpToPersonalItem
	LimitTime
	LoadSuccess
	Local_DeleteMe
	OnTimer
	RefAllProgress
	RefPersonalProgress
	Refresh
	RefreshAllItem
	RefreshPersonal
	RefreshReward
	Scr_Scroller1
	Scr_Scroller2
	StopTimer
	_Viewport1
	_Viewport2
	box_layout_data
	reward_number
	public constructor(parent?) {
		super(parent)


		this.base_file = "ftvActiveness"
		this.layout_file = "FtvActivenessMainView"
		let model = CustomActivityModel.GetInstance()

		let erlang_parser = ErlangParser.GetInstance()
		let local_Message = Message
		let local_Number = Number
		let local_CustomActivityDefine = CustomActivityDefine
		let goods_model = GoodsModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let info_ = null
		let data_ = null
		let all_item_list_ = []
		let personal_item_list_ = []
		let reward_item_list_ = []
		let personal_times_list = []
		let timer_ = null
		let good_cost_ = null
		let left_submit_time_ = null
		let jump_index = null
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {
			this.box_layout_data={
				column: 4,
				h_gap: 5,
				v_gap: 10,
				item_w: 103,
				item_h: 99
			}
			this.LoadSuccess()
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_dec.style.fontSize = 16
				this._lb_dec.style.leading = 0.8
			}
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_all, GameResPath.GetIcon("ftvActiveness", "uihyjl_012"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("ftvActiveness", "uihyjl_013"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_per_bg, GameResPath.GetIcon("ftvActiveness", "uihyjl_010"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_personal, GameResPath.GetIcon("ftvActiveness", "uihyjl_009"))
			ResManager.GetInstance().SetTexture(this,this._img_titlebg,GameResPath.GetIconJpg("ftvActiveness","uihyjl_015"))
			// ResManager.GetInstance().SetImageSprite(this,this._Image3,"ftvActiveness","ui_midweek_01")
			// ResManager.GetInstance().SetImageSprite(this,this.reward_bg,"ftvActiveness","ui_midweek_07")

			// this.RegisterMask(this._Viewport1, 3)
			// this.RegisterMask(this._Viewport2)

			if (!info_) {
				return
			}
			let cfg = this.preload_client_config["ConfigCustomActivityView"]
			if (cfg) {
				model.LoadCompontRes(this, cfg, "FtvActivenessMainView", info_.show_id)
			}
			model.CloseACTRed(info_.base_type, info_.sub_type, null, info_.show_id)
			if (typeof (info_.condition) == "string") {
				info_.condition = erlang_parser.Parse(info_.condition)
			}
			let temp_data=model.GetActInfo(info_.base_type,info_.sub_type)
			data_ = model.GetActData(info_.base_type, info_.sub_type)
			if (data_ && data_.person_times!=undefined && data_.server_times!=undefined) {
				this.InitEvent()
				this.InitView()
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_jin, () => {
				if (left_submit_time_ && left_submit_time_ > 0) {
					local_Message.show("早上7:00开放提交")
					return
				}
				let base_type = info_.base_type
				let sub_type = info_.sub_type
				let ok_callback = () => {
					let jin = RoleManager.GetInstance().mainRoleInfo.jin
					if (local_Number(this._lb_jin_num.text) <= jin) {
						model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33194, base_type, sub_type, 1)
					} else {
						NotEnougnDiamond()
					}
				}

				ok_callback()
			}, this, true)	

			Util.AddClickEvent(this._btn_good, () => {
				if (left_submit_time_ && left_submit_time_ > 0) {
					local_Message.show("早上7:00开放提交")
					return
				}
				let num = goods_model.GetTypeGoodsNum(good_cost_[0])
				if (good_cost_[1] <= num) {
					model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33194, info_.base_type, info_.sub_type, 2)
				} else {
					local_Message.show("材料不足")
				}
			}, this, true)

			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, (list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (good_cost_ && vo.type_id == good_cost_[0]) {
						let have_num = goods_model.GetTypeGoodsNum(good_cost_[0])
						this._lb_have_num.innerHTML ="拥有<font color='#0a953e'>"+have_num+"</font>个"
						this._lb_have_num.x=150/2-this._lb_have_num.contextWidth/2
						if (!left_submit_time_ || left_submit_time_ <= 0) {
							let bool = (have_num >= good_cost_[1] && (true) || (false))
							this._img_red.visible = bool
						}
					}
				}
			}
			)

			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, (...new_args) => {
				let arg = new_args
				if (arg[0] == info_.base_type && arg[1] == info_.sub_type && arg[2] == 33193) {
					data_ = model.GetActData(arg[0], arg[1])
					this.Refresh()
				}
			}
			)

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
				let arg = new_args
				if (arg[0] == info_.base_type && arg[1] == info_.sub_type) {
					data_ = model.GetActData(arg[0], arg[1])
					let list = []
					let reward = []
					let ref = false
					if (arg[2].reward_list) {
						for (let i in arg[2].reward_list) {

							table.insert(reward, arg[2].reward_list[i].reward[0])
						}
					}
					if (arg[2].reward) {
						table.insert(reward, arg[2].reward[0])
						ref = true
					}
					for (let i in reward) {

						let v = []
						v[0] = reward[i].style
						v[1] = reward[i].typeId
						v[2] = reward[i].count
						table.insert(list, v)
					}
					if (list.length == 0) {
						for (let _tmpi in data_.reward_list) {
							var v = data_.reward_list[_tmpi]
							if (v.grade == arg[2].grade) {
								if (typeof (v.reward) == "string") {
									v.reward = erlang_parser.Parse(v.reward)
								}
								table.insert(list, v.reward[0])
								ref = true
							}
						}
					}
					if (list.length > 0) {
						let view = new CongratulationObtainView(list)
						view.Open()
					}
					if (ref) {
						this.Refresh()
					}
				}
			}
			)

			let activenss_time_limit = () => {
				this.LimitTime()
			}
			this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, activenss_time_limit)
		}

		this.InitView = () => {
			let info = info_

			this.LimitTime()
			if (!timer_) {
				timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
					this.OnTimer()
				}, 1, -1)
			}
			if (info.etime > local_TimeUtil.getServerTime()) {
				this.OnTimer()
			} else {
				this.StopTimer()
			}

			if (info.condition) {
				if (typeof (info.condition) == "string") {
					info.condition = erlang_parser.Parse(info.condition)
				}
				for (let _tmpi in info.condition) {
					var vo = info.condition[_tmpi]
					if (vo[0] == "cost1") {
						this._lb_jin_num.text = vo[1][0][2]
					}
					if (vo[0] == "cost2") {
						let [type_id, lock] = goods_model.GetMappingTypeId(vo[1][0][0], vo[1][0][1])
						let have_num = goods_model.GetTypeGoodsNum(type_id)
						good_cost_ = [type_id, Number(vo[1][0][2])]
						let basic = goods_model.GetGoodsBasicByTypeId(type_id)
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_good_icon, "resource/game/goodsIcon/" + basic.goods_icon + ".png")
						this._lb_have_num.innerHTML ="拥有<font color='#0a953e'>"+have_num+"</font>个"
						this._lb_have_num.x=150/2-this._lb_have_num.contextWidth/2
						if (!left_submit_time_ || left_submit_time_ <= 0) {
							let bool = (have_num >= good_cost_[1] && (true) || (false))
							this._img_red.visible = bool
						}
						this._lb_dec_goods.innerHTML = Util.StrToHTML("提交<font color=" + ColorUtil.GetColorLight(basic.color) + ">" + basic.goods_name + "</font>可获得随机奖励")
						this._lb_dec_goods.x=this.box_layout.width/2-this._lb_dec_goods.contextWidth/2
						if (info.desc) {
							let list = Split(info.desc, "@")
							this._lb_dec.innerHTML = Util.StrToHTML(list[0] + "<font color=" + ColorUtil.GetColorLight(basic.color) + ">" + Trim(basic.goods_name) + "</font>" + list[1])
						}
					}
				}
			}
			let cond = model.GetActCondition(info_.base_type, info_.sub_type)
			if (cond && cond.info) {
				let group = cond.info.group
				if (group) {
					this._lb_good_num.text = group
				} else {
					this._lb_good_num.text = group
				}
			}
			// LayoutRebuilder(this._gp_jin)
			// LayoutRebuilder(this._gp_good)

			let ser_data = []
			let per_data = []
			let reward_data = []
			for (let _tmpi in data_.reward_list) {
				var v = data_.reward_list[_tmpi]
				if (typeof (v.condition) == "string") {
					v.condition = erlang_parser.Parse(v.condition)
				}
				for (let i in v.condition) {

					if (v.condition[i][0] == "total") {
						table.insert(per_data, v)
						break
					} else if (v.condition[i][0] == "ser_reward_type") {
						table.insert(ser_data, v)
						break
					} else if (v.condition[i][0] == "weight") {
						table.insert(reward_data, v)
					}
				}
			}
			this.InitRewardItem(reward_data)
			this.InitAllItem(ser_data)
			this.InitPersonalItem(per_data)
			// RefBoxChildsLayout(this._gp_personal, 0, 80, true, "left")
		}

		this.Refresh = () => {
			let ser_data = []
			let per_data = []
			for (let _tmpi in data_.reward_list) {
				var v = data_.reward_list[_tmpi]
				if (typeof (v.condition) == "string") {
					v.condition = erlang_parser.Parse(v.condition)
				}
				for (let i in v.condition) {

					if (v.condition[i][0] == "total") {
						table.insert(per_data, v)
						break
					} else if (v.condition[i][0] == "ser_reward_type") {
						table.insert(ser_data, v)
						break
					}
				}
			}
			this.RefreshAllItem(ser_data)
			this.RefreshPersonal(per_data)
		}

		this.StopTimer = () => {
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null
			}
			this._lb_time.innerHTML = Util.StrToHTML("<font color='#a2420d'>活动已结束</font>")
		}

		this.OnTimer = () => {
			let left_time = info_.etime - local_TimeUtil.getServerTime()
			if (left_time > 0) {
				this._lb_time.innerHTML = Util.StrToHTML("<font color='#663915'>活动剩余时间:</font><font color='#fe1a1a'>" + local_TimeUtil.timeConvert(left_time, "hh-mm-ss") + "</font>")
			} else {
				this.StopTimer()
			}
			if (left_submit_time_ && left_submit_time_ > 0) {
				left_submit_time_ = left_submit_time_ - 1
				if (left_submit_time_ <= 0) {
					this.LimitTime()
					return
				}
				this._lb_count_down.innerHTML = Util.StrToHTML("可提交倒计时：<font color='#639c12'>" + local_TimeUtil.timeConvert(left_submit_time_, "dd-hh-mm-ss") + "</font>")
				this._lb_count_down.x=this.box_layout.width/2-this._lb_count_down.contextWidth/2
			}
		}

		//全服buff——item
		this.InitAllItem = (ser_data?) => {
			if (!ser_data || ser_data.length == 0) {
				return
			}
			if (all_item_list_.length > 0) {
				for (let _tmpi in all_item_list_) {
					var item = all_item_list_[_tmpi]
					item.SetVisible(false)
				}
			}

			let sort_func = (a?, b?) => {
				return b.grade < a.grade
			}
			table.sort(ser_data, sort_func)

			for (let i in ser_data) {

				let item = all_item_list_[i]
				if (!item) {
					item = new FtvActivenessAllItem(this._gp_all_icon)
					item.Load()
					table.insert(all_item_list_, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(ser_data[i], info_)
				}
				)
				let lb_go =  new Laya.Label() //UiFactory.CreateChild(this._gp_all_num, UIType.Label)
				// let lb = lb_go.transform.GetComponent("Text")
				// lb_go.anchorMax = new Vector2(0, 1)
				// lb_go.anchorMin = new Vector2(0, 1)
				// lb_go.pivot = new Vector2(0, 1)
				lb_go.fontSize = 20
				lb_go.text = ser_data[i].times
				lb_go.color = "#663915" //Color(89 / 255, 61 / 255, 48 / 255, 1)
				this._gp_all_num.addChild(lb_go)
			}
			if (all_item_list_.length > 0) {
				let num = all_item_list_.length
				let height = 572 / num
				let gap = height - 67
				// let layout = this._gp_all_icon.GetComponent("UnityEngine.UI.VerticalLayoutGroup")
				// layout.spacing = gap
				if (this._gp_all_num.numChildren > 0) {
					for (let i = 0; i < this._gp_all_num.numChildren; i++) {
						let lb = this._gp_all_num.getChildAt(i)
						let item = all_item_list_[i]
						if (lb && item) {
							let lb_height = 23
							let item_y = (gap + 67) * i + 67 / 2 - 22 - lb_height / 2
							SetAnchoredPosition(lb, 0, item_y)
						}
					}
				}
			}
			this.RefAllProgress(ser_data, true)
		}

		this.RefreshAllItem = (ser_data?) => {
			if (!ser_data || ser_data.length == 0) {
				return
			}
			if (data_.server_times && data_.server_times >= 0) {
				let sort_func = (a?, b?) => {
					return b.grade < a.grade
				}
				table.sort(ser_data, sort_func)

				for (let i in ser_data) {

					let item = all_item_list_[i]
					if (item) {
						item.SetData(ser_data[i], info_)
					}
					let lb = <Laya.Label>this._gp_all_num.getChildAt(Number(i))
					// let lb_com = lb.GetComponent("Text")
					lb.text = ser_data[i].times
				}
				//this._gp_all_num.validateNow()
				this.RefAllProgress(ser_data)
			}
		}

		this.RefAllProgress = (ser_data?, is_init?) => {
			if (is_init == null) {
				is_init = false
			}
			let data = data_
			if (!data || !ser_data || ser_data.length == 0) {
				return
			}
			let list = ser_data
			let times = data_.server_times
			let value = 0
			if (list.length > 0) {
				let max_vo = list[0]
				if (!list[list.length-1].times) {
					return
				}
				//小于第一档
				if (times <= list[list.length-1].times) {	
					let item = <Laya.Label>this._gp_all_num.getChildAt(list.length - 1)
					let item_y = Math.abs(item.y)
					let item_height = 23
					if (item) {
						value = (534 - (item_y + item_height / 2)) * (times / list[list.length-1].times)
					}
				} else if (max_vo && times >= max_vo.times) {//大于最后一档
					value = 534
				} else {//中间档

					for (let i = list.length-1; i >= 0; i -= 1) {
						let next_index = local_Number(i) - 1
						if (!list[next_index]) {
							return
						}
						let last_times = list[i].times
						let next_times = list[next_index].times
						if (times > last_times && times <= next_times) {
							let item =<Laya.Label> this._gp_all_num.getChildAt(i )
							let next_item =<Laya.Label> this._gp_all_num.getChildAt(next_index )
							let item_y = Math.abs(item.y)
							let next_item_y = Math.abs(next_item.y)
							let basic_height = 534 - item_y
							let add_height = 534 - (next_item_y + 23 / 2) - basic_height
							let add_progress = (times - last_times) / (next_times - last_times)
							value = basic_height + add_height * add_progress
							break
						}
					}
				}
				this._img_all.width=value
				// SetSizeDeltaY(this._img_all_mask, value)
			}
			this._lb_all.text = "（" + data_.server_times + "/" + ser_data[0].times + "）"
		}

		//个人阶段奖励
		this.InitPersonalItem = (per_data?) => {
			if (!per_data) {
				return
			}
			if (personal_item_list_.length > 0) {
				for (let _tmpi in personal_item_list_) {
					var item = personal_item_list_[_tmpi]
					item.SetVisible(false)
				}
			}
			table.sort(per_data, (a?, b?) => {
				return a.grade < b.grade
			})

			this._img_per_bg.width = per_data.length * 90
			this._Content1.width = per_data.length * 90

			for (let i in per_data) {
				let item = personal_item_list_[i]
				if (!item) {
					item = new FtvActivenessPersonalItem(this._gp_personal)
					item.Load()
					table.insert(personal_item_list_, item)
				}
				if (typeof (per_data[i].condition) == "string") {
					per_data[i].condition = erlang_parser.Parse(per_data[i].condition)
				}
				item.ExcuteCallback(() => {
					item.SetData(per_data[i], info_)
					if(Number(i)==(per_data.length-1)){
						Laya.timer.frameOnce(1,this,()=>{
							if (this.use_delete_method) return
							this.RefPersonalProgress(data_.person_times,per_data)
							this.JumpToPersonalItem()
						})
					}
				}
				)

				personal_times_list[i] = Number(per_data[i].condition[0][1])

				if (!jump_index && per_data[i].status == 1) {
					jump_index = i
				}
			}

			// if (personal_item_list_.length > 0) {
				// let num = personal_item_list_.length
				// let width = 720 / num
				// let gap = width - 76
				// let layout = this._gp_personal.GetComponent("UnityEngine.UI.HorizontalLayoutGroup")
				// layout.spacing = gap
				// this._gp_personal.space = gap
			// }
			// LayoutRebuilder(this._gp_personal)
			// this.RefPersonalProgress(data_.person_times)
		}

		this.RefreshPersonal = (per_data?) => {
			if (!per_data) {
				return
			}
			table.sort(per_data, (a?, b?) => {
				return a.grade < b.grade
			})
			for (let i in per_data) {

				let item = personal_item_list_[i]
				if (item) {
					item.SetData(per_data[i], info_)
				}
			}
			if (data_.person_times && data_.person_times >= 0) {
				this.RefPersonalProgress(data_.person_times, per_data)
			}
		}

		this.RefPersonalProgress = (times?, per_data?) => {
			if (!personal_times_list || personal_times_list.length == 0) {
				return
			}
			let value = 0
			let _half = 76 / 2
			let list = personal_times_list
			if (list.length > 0) {
				let max_vo = list[list.length - 1]
				if (times <= list[0]) {
					//小于第一档
					let item = personal_item_list_[0].display_obj
					let item_x = Math.abs(item.x) + _half
					if (item) {
						value = item_x * (times / list[0])
					}
				} else if (max_vo && times >= max_vo) {
					//大于最后一档
					let max_item= personal_item_list_[list.length-1].display_obj
					let max_item_x = max_item.x + _half
					let add_width = 720 - max_item_x
					let add_times = (times - max_vo) / 50
					value = max_item_x + add_width * add_times
				} else {
					//中间档
					for (let i = 1; i < list.length; i++) {
						if (!list[i]) {
							return
						}
						if (times > list[i-1] && times <= list[i]) {
							let curr_item = personal_item_list_[i-1].display_obj
							let nest_item = personal_item_list_[i].display_obj
							let curr_item_x = curr_item.x + _half
							let nest_item_x = nest_item.x + _half
							let add_width = nest_item_x - curr_item_x
							let add_times = (times - list[i-1]) / (list[i] - list[i-1])
							value = curr_item_x + add_width * add_times
							break
						}
					}
				}
				let len = per_data.length * 90
				if(value > len){
					value = len
				}
				this._img_personal.width = value//Mathf.Clamp01(value )
			}

			this._lb_num0.text = "提交次数：" + times
		}

		this.JumpToPersonalItem = () => {
			if (jump_index) {
				let jump_item = personal_item_list_[jump_index].display_obj
				let scr_width = GetSizeDeltaX(this._Scroller2)
				let jump_x = jump_item.x
				jump_x = Mathf.Clamp(jump_x, 0, 720 - scr_width)
				// SetAnchoredPositionX(this._Content1, -jump_x)
			}

		}

		//提交奖励预览
		this.InitRewardItem = (reward_data?) => {
			if (!reward_data) {
				return
			}
			if (reward_item_list_.length > 0) {
				for (let _tmpi in reward_item_list_) {
					var item = reward_item_list_[_tmpi]
					item.SetVisible(false)
				}
			}
			let sort_func = (a?, b?) => {
				return a.grade < b.grade
			}
			table.sort(reward_data, sort_func)
			let count = 0
			this.reward_number=reward_data.length
			for (let i in reward_data) {

				let item = reward_item_list_[i]
				if (!item) {
					item = new FtvActivenessReward(this._gp_reward)
					item.Load()
					table.insert(reward_item_list_, item)
				}
				item.ExcuteCallback(()=>{
					count ++
					if(count == this.reward_number){
						RefGridLayout(this._gp_reward,this.box_layout_data)
					}
				})
				if (typeof (reward_data[i].reward) == "string") {
					reward_data[i].reward = erlang_parser.Parse(reward_data[i].reward)
				}
				item.SetData(reward_data[i].reward)
			}
		}

		this.RefreshReward = (reward_data?) => {
			if (!reward_data) {
				return
			}
			let sort_func = (a?, b?) => {
				return a.grade < b.grade
			}
			table.sort(reward_data, sort_func)

			for (let i in reward_data) {

				let item = reward_item_list_[i]
				if (typeof (reward_data[i].reward) == "string") {
					reward_data[i].reward = erlang_parser.Parse(reward_data[i].reward)
				}
				let[ type_id, lock] = goods_model.GetMappingTypeId(reward_data[i].reward[0][0], reward_data[i].reward[0][1])
				item.SetData(type_id, reward_data[i].reward[0][2])
			}
		}

		this.LimitTime = () => {
			let now_time = local_TimeUtil.getServerTime()
			let data = new Date(now_time * 1000)
			data.setHours(7)
			data.setMinutes(0)
			data.setSeconds(0)
			let taget_time = Mathf.Round(data.getTime() / 1000)
			if (now_time >= taget_time) {
				this._gp_good.visible = true
				this._gp_jin.visible = true
				this._lb_have_num.visible = true
				this._lb_count_down.visible = false
				if (good_cost_) {
					let have_num = goods_model.GetTypeGoodsNum(good_cost_[1])
					let bool = (have_num >= good_cost_[2] && (true) || (false))
					this._img_red.visible = bool
				}
			} else {
				this._img_red.visible = false
				this._gp_good.visible = false
				this._gp_jin.visible = false
				this._lb_have_num.visible = false
				this._lb_count_down.visible = true
				left_submit_time_ = taget_time - now_time
				this._lb_count_down.innerHTML = Util.StrToHTML("可提交倒计时：<font color='#639c12'>" + local_TimeUtil.timeConvert(left_submit_time_, "dd-hh-mm-ss") + "</font>")
				this._lb_count_down.x=this.box_layout.width/2-this._lb_count_down.contextWidth/2
			}
		}

		this.CustomMehod = (index?, arg?) => {
			info_ = arg
		}

		this.Local_DeleteMe = () => {
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null
			}
			if (all_item_list_.length > 0) {
				for (let _tmpi in all_item_list_) {
					var item = all_item_list_[_tmpi]
					item.DeleteMe()
				}
				all_item_list_ = []
			}
			if (personal_item_list_.length > 0) {
				for (let _tmpi in personal_item_list_) {
					var item = personal_item_list_[_tmpi]
					item.DeleteMe()
				}
				personal_item_list_ = []
			}
			if (reward_item_list_.length > 0) {
				for (let _tmpi in reward_item_list_) {
					var item = reward_item_list_[_tmpi]
					item.DeleteMe()
				}
				reward_item_list_ = []
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_titlebg,
			this._lb_time,
			this._lb_dec,
			this._Image2,
			this._lb_all,
			this._Image3,
			this._img_all_mask,
			this._img_all,
			this._gp_all_num,
			this._gp_all_icon,
			this._Image10,
			this._lb_dec_goods,
			this._Image5,
			this._Scroller1,
			this._gp_reward,
			this._Scroller2,
			this._Content1,
			this._gp_personal,
			this._img_per_bg,
			this._img_personal,
			this._Image9,
			this._lb_num0,
			this._lb_num1,
			this._btn_jin,
			this._Image7,
			this._Text7,
			this._gp_jin,
			this._lb_jin_num,
			this._Image6,
			this._btn_good,
			this._Image8,
			this._Text8,
			this._img_red,
			this._gp_good,
			this._lb_good_num,
			this._img_good_icon,
			this._lb_have_num,
			this._gp_effect,
			this._lb_count_down,
			this.reward_bg,
			this.box_layout
		]
			= this.GetChildrenByNames([

				"_img_titlebg",
				"_lb_time",
				"_lb_dec",
				"_Image2",
				"_lb_all",
				"_Image3",
				"_img_all_mask",
				"_img_all",
				"_gp_all_num",
				"_gp_all_icon",
				"_Image10",
				"_lb_dec_goods",
				"_Image5",
				"_Scroller1",
				"_gp_reward",
				"_Scroller2",
				"_Content1",
				"_gp_personal",
				"_img_per_bg",
				"_img_personal",
				"_Image9",
				"_lb_num0",
				"_lb_num1",
				"_btn_jin",
				"_Image7",
				"_Text7",
				"_gp_jin",
				"_lb_jin_num",
				"_Image6",
				"_btn_good",
				"_Image8",
				"_Text8",
				"_img_red",
				"_gp_good",
				"_lb_good_num",
				"_img_good_icon",
				"_lb_have_num",
				"_gp_effect",
				"_lb_count_down",
				"reward_bg",
				"box_layout"
			])
			this._lb_dec_goods.style.fontSize=20
			this._lb_dec_goods.style.color="#7a4e37"
			this._lb_dec_goods.style.wordWrap=false
			this._lb_count_down.style.fontSize=22
			this._lb_count_down.style.color="#7a4e37"
			this._lb_count_down.style.wordWrap=false
			this._lb_dec.style.fontSize=22
			this._lb_dec.style.color="#ffffff"
			this._lb_dec.style.width=715
			this._lb_dec.style.leading=5
			this._lb_time.style.fontSize=20
			this._lb_time.style.color="#663915"
			this._lb_time.style.wordWrap=false
			this._Scroller2.hScrollBar.visible=false
			this._Scroller1.vScrollBar.visible=false
			this._lb_have_num.style.fontSize=20
			this._lb_have_num.style.color="#593d30"
			this._lb_have_num.style.wordWrap=false
	}
}
window["FtvActivenessMainView"]=FtvActivenessMainView