import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionY, SetLocalScale, SetAnchoredPosition, HtmlColorTxt } from "../util/Util"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { Alert } from "../alert/Alert"
import { Trim } from "../util/Util"
import { Alert_Type } from "../alert/Alert"
import { OpenFun } from "../common/OpenFun"
import { EventName } from "../common/EventName"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { ZeroMoneyTwoGradeItem } from "./ZeroMoneyTwoGradeItem"


export class ZeroMoneyBaseViewTwo extends BaseView1 {
	bg: Laya.Image
	btn_buy: Laya.Box
	_Image1: Laya.Image
	price: Laya.Image
	_icon: Laya.Image
	red: Laya.Image
	gp_return: Laya.HBox
	return_desc: Laya.Label
	return_icon: Laya.Image
	gp_grade: Laya.Panel
	grade_time: Laya.HTMLDivElement
	outtime: Laya.Label
	receive: Laya.Label
	title_bg: Laya.Image
	title: Laya.Image
	close: Laya.Image
	Image1: Laya.Image
	fight: Laya.Label
	desc: Laya.Image
	model_gp: Laya.Box
	icon: Laya.Image
	effect: Laya.Box
	line: Laya.Image
	desc1: Laya.Box
	_Image2: Laya.Image
	desc_text: Laya.HTMLDivElement
	time_gp: Laya.HBox
	return_desc1: Laya.Label
	act_status_
	base_type
	cache_effect
	cache_model
	cache_model_type
	click_bg_toClose
	condition_
	cur_sorting_order
	data
	desc_tween_id
	destroy_callback
	goods_model
	grade_pos
	info
	is_requesting_
	item_list
	left_time
	location
	location1
	location2
	model
	open_callback
	// return _desc
	// return _icon
	select_grade
	sub_type
	timer
	tween_id
	use_background
	Font_name: string = "font_1"
	bitmapFont: Laya.BitmapFont
	set_index = 0

	public constructor() {
		super()

		this.base_file = "zeroMoney"
		this.layout_file = "ZeroMoneyBaseViewTwo"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.model = CustomActivityModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.item_list = []
		this.grade_pos = [[-195, -103], [-3, -109], [214, -103], [309, -6]]
		// this.bitmapFont = new Laya.BitmapFont();
		this.destroy_imm = true
		// this.bitmapFont.loadFont("resource/font/fighting_font.fnt", new Laya.Handler(this, () => {
		// 	// this.bitmapFont.autoScaleSize = true
		// 	Laya.Text.registerBitmapFont(this.Font_name, this.bitmapFont);
		// 	// this.bitmapFont.fontSize=60
		// 	// this.bitmapFont.autoScaleSize=true
		// 	if (this.fight) {
		// 		this.fight.font = this.Font_name
		// 		// this._lb_fighting.text=_fighting
		// 	}
		// }));
		this.load_callback = () => {
			this.gp_grade.hScrollBarSkin = ""
			this.grade_time.style.fontSize = 24
			this.grade_time.style.valign = "center"
			this.grade_time.style.color = "#ffffff"
			this.grade_time.width = 300

			this.desc_text.style.fontSize = 24
			this.desc_text.style.valign = "center"
			this.desc_text.style.color = "#663915"

			//this.return_desc.style.padding = [(this.return_desc.height - this.return_desc.contextHeight) / 2, 0, 0, 0];     //垂直居中
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	SetAnchoredPositionX(this.fight,325)
			// 	this.desc_text.size  = 18
			// }
			// if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
			// 	SetAnchoredPositionX(this.fight,323)
			// }
			this.InitEvent()
			this.LoadCallback()
		}
		this.open_callback = () => {
			this.OpenCallback()
		}
		this.destroy_callback = () => {
			this.DestroyCallback()
		}
	}

	public LoadCallback() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("zeroMoney", "ui0yhl_012"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.title, GameResPath.GetIcon("zeroMoney", "ui0yhl_008"))
		//ResManager.GetInstance().SetOutsideImageSprite(this, this.line, GameResPath.GetIcon("zeroMoney", "img"), true)
		this.location = this.desc1.y
		this.location1 = this.icon.y
		this.location2 = this.effect.y
		if (!this.info) { return }
		this.base_type = this.info.base_type
		this.sub_type = this.info.sub_type
		let data = this.model.GetActData(this.info.base_type, this.info.sub_type)
		if (!data) { return }
		this.data = data
	}

	public InitEvent() {

		let model = this.model
		let local_CustomActivityDefine = CustomActivityDefine

		Util.AddClickEvent(this.close, () => {
			this.Close()
		}, this, true)

		this.BindEvent(this.model, CustomActivityDefine.EVENT.UP_GRADE, (base_type?, sub_type?, data?, grade?) => {
			if (!data && this.data && grade) {
				for (let k in this.data.reward_list) {
					var v = this.data.reward_list[k]
					if (v.grade == grade) {
						this.select_grade = v
						this.ShowSelect()
					}
				}
			}
		})

		if (this.use_delete_method) {
			return
		}
		let updata_view = (...new_args) => {
			let args = new_args
			if (this.info && args[0] == this.base_type && args[1] == this.sub_type) {
				let data = this.model.GetActData(this.info.base_type, this.info.sub_type)
				this.data = data
				this.InitGradeBtn()
				this.InitSelectGrade()
			}
		}

		this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, updata_view)

		this.BindEvent(model, local_CustomActivityDefine.EVENT.BUY_SUCCESS, (base_type?, sub_type?) => {
			if (this.select_grade && base_type == this.base_type && sub_type == this.sub_type && this.is_requesting_) {
				this.is_requesting_ = false
				let reward = this.model.GetActReward(this.base_type, this.sub_type, this.select_grade.form_type, this.select_grade.reward)
				if (reward) {
					let view = new CongratulationObtainView(reward, 10)
					view.Open()
				}
				model.RequireActInfo(this.base_type, this.sub_type)
			}
		}
		)
		this.BindEvent(model, local_CustomActivityDefine.EVENT.RECEIVE_SUCCESS, (base_type?, sub_type?) => {
			if (this.select_grade && base_type == this.base_type && sub_type == this.sub_type && this.is_requesting_) {
				this.is_requesting_ = false
				let reward_array
				if (this.condition_) {
					reward_array = this.condition_["return_reward"]
				}
				if (reward_array) {
					let view = new CongratulationObtainView(reward_array, 10)
					view.Open()
				}
				let list = model.GetActData(base_type, sub_type)
				if (!list) {
					return
				}
				for (let _tmpi in list.reward_list) {
					var reward = list.reward_list[_tmpi]
					if (reward.grade == this.select_grade.grade) {
						reward.status = 2
					}
				}
				model.SetActData(list)
				model.RequireActInfo(base_type, sub_type)
				this.ShowSelect()
			}
		}
		)

		let OnBuyBtnClick = () => {
			if (!this.select_grade) { return }
			let grade_ = this.select_grade.grade
			if (0 == this.act_status_) {
				if (this.condition_) {
					let need_lv = this.condition_["lv"]
					let cost = this.condition_["cost"]
					if (need_lv && Number(need_lv) != 1) {
						if (RoleManager.GetInstance().mainRoleInfo.level >= Number(need_lv)) {
							model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33137, this.sub_type, grade_)
							this.is_requesting_ = true
						} else {
							Message.show("您的等级不够")
						}
					} else if (cost && Number(cost[0][2]) != 0) {
						let cost_type = Number(cost[0][0])
						let reward = this.model.GetActReward(this.base_type, this.sub_type, this.select_grade.form_type, this.select_grade.reward)
						if (!reward || !reward[0]) { return }
						let [type, _] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
						let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type)
						let str = "<font color=" + ColorUtil.GetColorLight(basic.color) + ">" + Trim(basic.goods_name) + "</font>*" + reward[0][2]
						if (cost_type == 1) {
							let str1 = "是否花费<font color='#639c12'>" + cost[0][2] + "</font>勾玉购买" + str + "？"
							Alert.Show(Util.StrToHTML(str1), Alert_Type.One, () => {
								if (RoleManager.GetInstance().mainRoleInfo.jin >= Number(cost[0][2])) {
									this.is_requesting_ = true
									model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33137, this.sub_type, grade_)
								} else {
									let str2 = "您的勾玉不足" + cost[0][2] + "，是否前往充值"
									Alert.Show(Util.StrToHTML(str2), Alert_Type.One, () => {
										OpenFun.OpenFunHandler(21)
									}
									)
								}
							}
							)

						} else if (cost_type == 2) {
							let str3 = "是否花费<font color='#639c12'>" + cost[0][2] + "</font>绑玉购买" + str + "？"
							Alert.Show(Util.StrToHTML(str3), Alert_Type.One, () => {
								if (RoleManager.GetInstance().mainRoleInfo.jinLock >= Number(cost[0][2])) {
									this.is_requesting_ = true
									model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33137, this.sub_type, grade_)
								} else {
									let str4 = "您的绑玉不足" + cost[0][2] + "，是否使用勾玉代替"
									Alert.Show(Util.StrToHTML(str4), Alert_Type.One, () => {
										if (RoleManager.GetInstance().mainRoleInfo.jinLock + RoleManager.GetInstance().mainRoleInfo.jin >= Number(cost[0][2])) {
											this.is_requesting_ = true
											model.Fire(local_CustomActivityDefine.EVENT.SCMD_REQUEST, 33137, this.sub_type, grade_)
										} else {
											let str5 = "勾玉不足，前往充值"
											Alert.Show(Util.StrToHTML(str5), Alert_Type.One, () => {
												OpenFun.OpenFunHandler(21)
											}
											)
										}
									})
									Alert.SetIsCharge(true)
								}
							})
						}

					}
				}
			} else if (1 == this.act_status_) {
				Message.show('活动已结束')
			} else if (2 == this.act_status_) {
				Message.show("未到返利领取时间")
			} else if (3 == this.act_status_) {
				this.is_requesting_ = true
				model.RequireGetAward(this.base_type, this.sub_type, grade_)
			} else if (4 == this.act_status_) {
				Message.show("已领取该返利")
			} else if ("default" == this.act_status_) {
			}
		}

		Util.AddClickEvent(this.btn_buy, OnBuyBtnClick, this, true)

		this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
			if (this.condition_) {
				let need_lv = this.condition_["lv"]
				let lv = RoleManager.GetInstance().GetMainRoleVo().level
				if (need_lv && Number(need_lv) != 1 && lv >= Number(need_lv)) {
					this.InitGradeBtn()
					this.InitSelectGrade()
				}
			}
		}
		)
	}


	public BuyEndTime() {

		if (!this.info) { return }
		let condition = this.model.GetActCondition(this.info.base_type, this.info.sub_type, "info")
		if (condition) {
			for (let _tmpi in condition) {
				var v = condition[_tmpi]
				if (_tmpi == "buy_day") {
					let second = TimeUtil.getServerTime() - this.info.stime
					let all_second = Number(v) * 24 * 3600
					return all_second - second
				}
			}
		}
		return null
	}

	public SetTimeLabel(bool?, btn_content?, is_setGray?, time_content?, condition_lv?) {

		if (btn_content) {
			ResManager.GetInstance().SetImageSprite(this, this.price, "zeroMoney_asset", btn_content, true)
		}
		this._icon.visible = bool && !condition_lv

		if (time_content) {
			if (bool) {
				time_content = "购买剩余时间:<font color='#b3ff48'>" + time_content + "</font>"
			} else {
				time_content = "<font color='#b3ff48'>" + time_content + "</font>后领取"
			}
			this.grade_time.visible = true
			this.grade_time.innerHTML = Util.StrToHTML(time_content)
			this.grade_time.width = 300
			this.time_gp.refresh()
			//this.grade_time.x = bool ? 244 : 290
		} else {
			this.grade_time.visible = false
		}
		//LayoutRebuilder(this.btn_buy)

	}

	public StartTimer() {

		if (this.left_time && this.left_time > 0) {
			if (!this.timer) {
				let func = () => {
					if (this.left_time <= 0) {
						GlobalTimerQuest.CancelQuest(this.timer)
						this.timer = null
						this.model.RequireActInfo(this.base_type, this.sub_type)
						return
					}
					let time_content = TimeUtil.timeConvert(this.left_time, "dd-hh/hh-mm/mm-ss")
					if (this.act_status_ != undefined && this.act_status_ == 0) {
						time_content = "购买剩余时间:<font color='#b3ff48'>" + time_content + "</font>"
					} else if (this.act_status_ && this.act_status_ == 2) {
						time_content = "<font color='#b3ff48'>" + time_content + "</font>后领取"
					}
					this.grade_time.innerHTML = Util.StrToHTML(time_content)
					this.grade_time.width = 300
					this.time_gp.refresh()
					//this.grade_time.x = (this.act_status_ != undefined && this.act_status_ == 0) ? 244 : 290
					this.left_time = this.left_time - 1
				}
				this.timer = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
			}
		}
	}

	public ShowSelect() {

		if (!this.select_grade || !this.data) { return }
		let status = this.select_grade.status
		let time_content
		this.condition_ = this.model.GetActCondition(this.data.base_type, this.data.sub_type, "data", this.select_grade.grade)
		this.ShowReturnInfo()
		let btn_content
		let goods_model = GoodsModel.GetInstance()
		let left_time
		this.price.x = 30
		this._Image1.gray = false
		this.price.gray = false
		if (status == 0) {
			let left_time = this.BuyEndTime()
			if (left_time && left_time > 0) {
				this.left_time = left_time
				time_content = TimeUtil.timeConvert(left_time, "dd-hh/hh-mm/mm-ss")
				let is_lv = null
				for (let _tmpi in this.condition_) {
					var v = this.condition_[_tmpi]
					if (_tmpi == "lv" && Number(v) != 1) {
						let need_lv = Number(v)
						let lv = RoleManager.GetInstance().GetMainRoleVo().level
						btn_content = (lv >= need_lv && ("领取") || (need_lv + "级可领取"))
						this.red.visible = lv >= need_lv && true || false
						is_lv = true
						break
					} else if (_tmpi == "cost" && v[0] && v[0][2] && Number(v[0][2]) != 0) {
						let type_id, lock = goods_model.GetMappingTypeId(v[0][0], v[0][1])
						let goods_bsic = goods_model.GetGoodsBasicByTypeId(type_id)
						btn_content = this.condition_.btn
						let icon = Number(v[0][0]) == 1 && "com_diamond" || "com_bind_diamond"
						ResManager.GetInstance().SetImageSprite(this, this._icon, "common_asset", icon)
						//lua_resM:SetOutsideImageSprite(this, this._img_buyicon,  GameResPath.GetGoodsIconPath(goods_bsic.goods_icon))
						is_lv = false
						this.red.visible = false
						break
					}
				}
				this.SetTimeLabel(true, btn_content, false, time_content, is_lv)
				this.act_status_ = 0
				this.StartTimer()
			} else {
				btn_content = "ui0yhlwz_003"
				this.price.x = 50
				this.SetTimeLabel(false, btn_content, true, time_content)
				this.act_status_ = 1
				this.red.visible = false
				this._Image1.gray = true
				this.price.gray = true
			}
		} else if (status == 1) {
			left_time = this.select_grade.receive_time - TimeUtil.getServerTime()
			let is_setGray = null
			if (left_time > 0) {
				this.left_time = left_time
				btn_content = "ui0yhlwz_004"
				this.price.x = 50
				let time_str = TimeUtil.timeConvert(left_time, "dd-hh/hh-mm/mm-ss")
				time_content = time_str
				this.act_status_ = 2
				is_setGray = true
				this.red.visible = false
				this.StartTimer()
			} else {
				btn_content = "ui0yhlwz_002"
				this.price.x = 60
				this.red.visible = true
				this.act_status_ = 3
				is_setGray = false
			}
			this.SetTimeLabel(false, btn_content, is_setGray, time_content)
		} else if (status == 2) {
			btn_content = "ui0yhlwz_001"
			this.price.x = 50
			this.red.visible = false
			this.SetTimeLabel(false, btn_content, true, time_content)
			this.act_status_ = 4
			this._Image1.gray = true
			this.price.gray = true
		}
	}

	public ShowReturnInfo() {

		if (!this.condition_) { return }
		let condition_ = this.condition_
		let info = condition_["return_reward"]
		if (!info) { return }
		let [type_id, lock] = this.goods_model.GetMappingTypeId(info[0][0], info[0][1])
		let goods_bsic = this.goods_model.GetGoodsBasicByTypeId(type_id)
		if (goods_bsic) {
			//let str = condition_.receive_day + "天后返还" + HtmlColorTxt(,ColorUtil.GetColorDark(1,true) ) //+ goods_bsic.goods_name
			this.return_desc1.text = info[0][2]
			this.return_desc.text = condition_.receive_day//Util.StrToHTML( str)
			this.gp_return.refresh()
			let icon = Number(info[0][0]) == 1 && "com_diamond" || "com_bind_diamond"
			ResManager.GetInstance().SetImageSprite(this, this.return_icon, "common_asset", icon)
			//lua_resM:SetOutsideImageSprite(this, this.return_icon, GameResPath.GetGoodsIconPath(goods_bsic.goods_icon))
		}
		//LayoutRebuilder(this.gp_return)
		//战力展示
		if (condition_.fight) {
			this.fight.text = condition_.fight + (" + ")
			//this.fight.font = this.Font_name
		}
		//描述展示
		let show_desc1 = false
		if (condition_.desc) {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.desc, GameResPath.GetIcon("zeroMoney", condition_.desc), true)
		} else if (this.select_grade) {
			show_desc1 = true
			this.desc_text.innerHTML = Util.StrToHTML(this.select_grade.desc)
			this.desc_text.width = 150
			if (!this.desc_tween_id) {
				SetAnchoredPositionY(this.desc1, this.location)
				this.desc_tween_id = SYTweenLite.to(this, this.desc1, SYTweenLite.UiAnimationType.POSY, this.location - 15, 1.34, null, SYTweenFunc.PINGPONG, true)
			}
		}
		this.desc.visible = !show_desc1
		this.desc1.visible = show_desc1
		if (!show_desc1 && this.desc_tween_id) {
			this.ClearDesc1Tween()
		}

		//模型展示
		if (condition_.icon) {
			this.cache_effect = null
			this.cache_model = null
			this.cache_model_type = null
			this.icon.visible = true
			this.model_gp.visible = false
			this.effect.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetIcon("zeroMoney", condition_.icon[0][1]), true)
			this.ClearTween()
			if (!this.tween_id) {
				SetAnchoredPositionY(this.desc1, this.location1)
				//let location = this.icon.anchoredPosition.y
				this.tween_id = SYTweenLite.to(this, this.icon, SYTweenLite.UiAnimationType.POSY, this.location1 - 25, 2, null, SYTweenFunc.PINGPONG, true)
			}
		} else if (condition_.effect) {
			if (!this.cache_effect || this.cache_effect != condition_.effect[0][1]) {
				this.cache_model = null
				this.cache_model_type = null
				this.icon.visible = false
				this.model_gp.visible = false
				this.effect.visible = true
				let res_id = condition_.effect[0][1]
				this.cache_effect = res_id
				let cfg = Config.PRELOAD_CLIENT_CONFIG.UIModelParameter["ZeroMoneyBaseViewTwo"]
				let scale = cfg && cfg[res_id] && cfg[res_id].scale || 1
				let data = {
					load_call_back: () => {
						SetLocalScale(this.effect, scale, scale, scale)
					}
				}
				this.ClearUIEffect(this.effect)
				this.effect.width = 720
				this.effect.height = 1280
				this.AddUIEffect(res_id, this.effect, null, 2)
				this.ClearTween()
				if (!this.tween_id) {
					SetAnchoredPositionY(this.effect, this.location2)
					//this.tween_id = SYTweenLite.to(this, this.effect, SYTweenLite.UiAnimationType.POSY, this.location2 - 15, 2, null, SYTweenFunc.PINGPONG, true)
				}
			}
		} else if (condition_.model) {
			if (!this.cache_model || (this.cache_model != condition_.model[0][1] || this.cache_model_type != condition_.model[0][0])) {
				this.cache_effect = null
				this.ClearTween()
				this.cache_model = condition_.model[0][1]
				this.cache_model_type = condition_.model[0][0]
				this.icon.visible = false
				this.model_gp.visible = true
				this.effect.visible = false
				let call_back = () => {
					// this.CoverMode(this.line,this.layer_value,this.cur_sorting_order)
					// this.CoverMode(this.desc,this.layer_value,this.cur_sorting_order)
					// this.CoverMode(this.Image1,this.layer_value,this.cur_sorting_order)
					// this.CoverMode(this.fight,this.layer_value,this.cur_sorting_order)
					// this.CoverMode(this.desc1,this.layer_value,this.cur_sorting_order)
				}
				this.model.ShowViewModel(this, "ZeroMoneyBaseViewTwo", condition_.model[0], this.model_gp, call_back, null, this.cur_sorting_order)
			}
		}
	}

	public InitSelectGrade() {

		let data = this.data
		if (!data) { return }
		let grade
		//if (!this.select_grade) {
		let index = null
		if (this.set_index || this.set_index == 0)
			index = this.set_index
		else {
			for (let i in data.reward_list) {

				if (data.reward_list[i].status && data.reward_list[i].status == 1) {
					if (data.reward_list[i].receive_time <= TimeUtil.getServerTime()) {
						index = Number(i)
					}
					break
				}
			}
		}


		if (index == null) {
			for (let i in data.reward_list) {

				if (data.reward_list[i].status == 0) {
					index = Number(i)
					break
				}
			}
		}
		if (index == null) {
			index = 0
		}
		grade = data.reward_list[index]
		if (!grade) {
			grade = data.reward_list[0]
			if (!grade) { return }
		}
		// } else {
		// 	grade = this.select_grade
		// }
		this.model.Fire(CustomActivityDefine.EVENT.UP_GRADE, data.base_type, data.sub_type, null, grade.grade)
	}

	public InitGradeBtn() {

		let data = this.data
		if (!data) { return }
		let sortFunc = (a?, b?) => {
			return a.grade < b.grade
		}
		table.sort(data.reward_list, sortFunc)
		for (let k in data.reward_list) {
			var v = data.reward_list[k]
			let item = this.item_list[k]
			if (!item) {
				item = new ZeroMoneyTwoGradeItem(this.gp_grade)
				item.Load()
				table.insert(this.item_list, item)
			}
			item.SetPosition(Number(k) * 140, 0)
			item.SetData(data.base_type, data.sub_type, v)
			item.ExcuteCallback(() => {
				this.InitSelectGrade()
				// if (this.grade_pos[k]) {
				// 	SetAnchoredPosition(item.transform, this.grade_pos[k][0], this.grade_pos[k][1])
				// }


			})
		}
	}

	public OpenCallback() {

		if (!this.info) { return }
		//this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		this.InitGradeBtn()

	}

	public SetActInfo(info?, parm?) {

		this.info = info
		this.set_index = parm[0] ? parm[0] : 0

	}

	public ClearDesc1Tween() {

		if (this.desc_tween_id) {
			SYTweenLite.Stop(this.desc_tween_id)
			this.desc_tween_id = null
		}
	}

	public ClearTween() {

		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
	}

	public DestroyCallback() {
		this.ClearUIEffect(this.effect)
		this.cache_effect = null
		this.cache_model = null
		if (this.item_list && this.item_list.length) {
			for (let k in this.item_list) {
				var v = this.item_list[k]
				v.DeleteMe()
			}
			this.item_list = []
		}
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
		this.ClearDesc1Tween()
		this.ClearTween()
	}


	public GetComponents() {
		[
			this.bg,
			this.btn_buy,
			this._Image1,
			this.price,
			this._icon,
			this.red,
			this.gp_return,
			this.return_desc,
			this.return_icon,
			this.gp_grade,
			this.grade_time,
			this.outtime,

			this.receive,
			this.title_bg,
			this.title,
			this.close,
			this.Image1,
			this.fight,
			this.desc,
			this.model_gp,
			this.icon,
			this.effect,
			this.line,
			this.desc1,
			this._Image2,
			this.desc_text,
			this.time_gp,
			this.return_desc1
		]
			= this.GetChildrenByNames([

				"bg",
				"btn_buy",
				"_Image1",
				"price",
				"_icon",
				"red",
				"gp_return",
				"return_desc",
				"return_icon",
				"gp_grade",
				"grade_time",
				"outtime",
				"receive",
				"title_bg",
				"title",
				"close",
				"Image1",
				"fight",
				"desc",
				"model_gp",
				"icon",
				"effect",
				"line",
				"desc1",
				"_Image2",
				"desc_text",
				"time_gp",
				"return_desc1"
			])
		ResManager.GetInstance().LoadFont(this, "fighting_font", this.fight, 30, false)
	}
}
window["ZeroMoneyBaseViewTwo"] = ZeroMoneyBaseViewTwo