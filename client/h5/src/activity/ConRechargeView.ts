import { AccumRechargeView } from "../activity/AccumRechargeView"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RevelationDevourItem } from "../revelation/RevelationDevourItem"
import { TeamHallItem } from "../team/TeamHallItem"
import { TopVipShopItem } from "../topVip/TopVipShopItem"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPosition, Util } from "../util/Util"
import { ConRechargeGradeItem } from "./ConRechargeGradeItem"
import { ConRechargeItem } from "./ConRechargeItem"

export class ConRechargeView extends AccumRechargeView {

	LoadSuccess
	UpdateItems
	SetTime
	now_select_tier
	max_gift_info
	item
	timer
	InitSelfEvent
	SetTab
	ChangeView
	type_1
	type_2
	type_3
	is_have_eff
	public constructor(parent?) {
		super(parent)
		this.base_file = "activity"
		this.layout_file = "ConRechargeView"
		this.now_select_tier = 1
		this.LoadSuccess = () => {
			if (this._act_info) {
				this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
			}
			this._model.specialRedDotMap.set(this._act_info.base_type + '_' + this._act_info.sub_type, true);
			this._model.CloseACTRed(this._act_info.base_type, this._act_info.sub_type)
			//let stime = this._act_info.stime
			//let time = TimeUtil.getServerTime() - stime
			//let day = Math.floor(time / 60 / 60 / 24)
			//this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 15960,day)
			this.InitView(ConRechargeItem)
			this.InitEvent()
			this.InitSelfEvent()
			this.SetTab(this.now_select_tier)
			SetAnchoredPosition(this._img_title, 31, 25)
			this._gp_time.y = 196
			let bg_url = GameResPath.GetIcon("activity", "ui_xelc_bg_01")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, bg_url, true)
			if (!this.item) {
				this.item = new BaseAwardItem(this.grade_item)
				this.item.Load()
			}
			if (!this.timer) {
				// this.timer = this._model.LoadActTimer(this._gp_time, this._act_info.etime, 22, "#00fa64", null, this.time_title_color, "活动剩余时间：")
			}
			//this:BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_RECHARGE_ITEM,() => {
			//this:UpdateRecharge()
			//})
		}

		this.InitSelfEvent = () => {
			Util.AddClickEvent(this._btn_1, () => {
				if (this.now_select_tier == 1) return
				this.now_select_tier = 1
				this.UpdateItems(1)
				this.SetTab(1)
			}, this, true)
			Util.AddClickEvent(this._btn_2, () => {
				if (this.now_select_tier == 2) return
				this.now_select_tier = 2
				this.UpdateItems(1)
				this.SetTab(2)
			}, this, true)

			Util.AddClickEvent(this._btn_3, () => {
				if (this.now_select_tier == 3) return
				this.now_select_tier = 3
				this.UpdateItems(1)
				this.SetTab(3)
			}, this, true)
			// Util.AddClickEvent(this.btn_get, () => {
			// 	let data = this.max_gift_info
			// 	if (data.status == 1) {
			// 		this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, data.base_type, data.sub_type, data.grade)
			// 	}
			// 	CustomActivityModel.GetInstance().SetActRedDot()
			// }, this, true)
			this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_RECHARGE_ITEM, () => {
				let list = this._reward_data.reward_list
				this._btn_red_1.visible = false
				this._btn_red_2.visible = false
				this._btn_red_3.visible = false
				for (let i = 0; i < list.length; i++) {
					let v = list[i]
					let condition = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", v.grade)

					if (v.status == 1 && condition) {
						if (condition.tier == 1) {
							this._btn_red_1.visible = true
						} else if (condition.tier == 2) {
							this._btn_red_2.visible = true
						} else if (condition.tier == 3) {
							this._btn_red_3.visible = true
						}
					}
				}
			})
			this.BindEvent(this._model, CustomActivityDefine.EVENT.RECHARGE_SUCCESS, () => {
				this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
			})
			this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
				if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
					let act_data = this._model.GetActData(this._act_info.base_type, this._act_info.sub_type)
					if (act_data) {
						for (let _tmpi in act_data.reward_list) {
							var data = act_data.reward_list[_tmpi]
							data.base_type = this._act_info.base_type
							data.sub_type = this._act_info.sub_type
							//data.parent_mask = this.parent_mask_corner
						}
					}
					this._reward_data = act_data
					this.UpdateItems()
				}
			})
		}

		this.UpdateItems = (force?) => {
			if (!this._reward_data || !this.is_loaded) {
				return
			}
			let stime = this._act_info.stime
			let time = TimeUtil.getServerTime() - stime
			let day = Math.floor(time / 60 / 60 / 24)
			this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 15960, day)
			let list = this._reward_data.reward_list
			let recharge_list = this._model.GetActRechargeOneDay()
			let recharge_list1 = []
			let recharge_day = 0
			if (recharge_list && Util.TableSize(recharge_list) > 0) {
				for (let i = 0; i <= Util.TableSize(recharge_list) - 1; i++) {
					if (recharge_list[i].total_gold > 0) {
						table.insert(recharge_list1, recharge_list[i].total_gold)
					}
				}
				if (recharge_list1 && Util.TableSize(recharge_list1) > 0) {

					for (let j = 0; j <= Util.TableSize(list) - 1; j++) {
						let b = list[j]
						let cond = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", b.grade)
						let is_today = cond.tier && Number(cond.tier) == 1
						let target = Number(cond.gold)
						target = target == null && 0 || target
						let total = 0
						for (let i = 0; i <= Util.TableSize(recharge_list1) - 1; i++) {
							if (i == Number(cond.day)) {
								total = recharge_list1[i]
								if (Number(total) >= Number(target)) {
									recharge_day = recharge_day + 1
								}
							}
						}
					}
				}
			}

			for (let _ = 0; _ < list.length; _++) {
				var v = list[_]
				v.recharge_day = recharge_day
			}

			table.sort(list, (a?, b?) => {
				let cond_a = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", a.grade)
				let cond_b = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", b.grade)
				let grade1 = cond_a.grade && 1 || 0
				let grade2 = cond_b.grade && 1 || 0

				if (grade1 != grade2) {
					return grade1 > grade2
				} else {
					if (a.status != b.status) {
						if (a.status == 1) {
							return true
						} else if (b.status == 1) {
							return false
						} else {
							return a.status < b.status
						}
					} else {
						return a.grade < b.grade
					}
				}
			})
			if (!force) {
				for (let i = 0; i < list.length; i++) {
					if (list[i].status == 1) {
						v = list[i]
						let condition = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", v.grade)
						this.now_select_tier = condition.tier
						break
					}
				}
			}

			let list_info = []
			let count = 0
			this._btn_red_1.visible = false
			this._btn_red_2.visible = false
			this._btn_red_3.visible = false
			for (let i = 0; i < list.length; i++) {
				let v = list[i]
				let condition = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", v.grade)
				if (condition.tier == 1) {
					this._lb_btn_1.text = condition.gold / 10 + "元"
					this.type_1 = true
				} else if (condition.tier == 2) {
					this._lb_btn_2.text = condition.gold / 10 + "元"
					this.type_2 = true
				} else if (condition.tier == 3) {
					this._lb_btn_3.text = condition.gold / 10 + "元"
					this.type_3 = true
				}
				if (v.status == 1) {
					if (condition.tier == 1) {
						this._btn_red_1.visible = true
					} else if (condition.tier == 2) {
						this._btn_red_2.visible = true
					} else if (condition.tier == 3) {
						this._btn_red_3.visible = true
					}
				}
				if ((condition.tier == this.now_select_tier && condition.grade == 1) || (condition.grade == 1 && !this.type_1 && !this.type_2 && !this.type_3)) {
					this.max_gift_info = v
					this.max_gift_info.base_type = this._act_info.base_type
					this.max_gift_info.sub_type = this._act_info.sub_type
					this.max_gift_info.now_select_tier = this.now_select_tier
					// let reward = this._model.GetActReward(this._act_info.base_type, this._act_info.sub_type, v.form_type, v.reward)
					// let [type_id, _] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
					// let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (!this.item) {
						this.item = new ConRechargeGradeItem(this.grade_item)
						this.item.Load()
					}
					this.item.SetData(this.max_gift_info)
					// if (v.status == 1) {
					// 	this._img_prgress_bg.visible = false
					// 	this._img_has_get.visible = false
					// 	this.btn_get.visible = true
					// 	this._gp_effect.visible = true
					// 	if (!this.is_have_eff) {
					// 		this.AddUIEffect("UI_1609_01", this._gp_effect, undefined, 14, true)
					// 		this.is_have_eff = true
					// 	}

					// } else if (v.status == 2) {
					// 	this._img_prgress_bg.visible = false
					// 	this._img_has_get.visible = true
					// 	this.btn_get.visible = false
					// 	this._gp_effect.visible = false
					// } else if (v.status == 0) {
					// 	this._img_prgress_bg.visible = true
					// 	this._img_has_get.visible = false
					// 	this.btn_get.visible = false
					// 	this._gp_effect.visible = false
					// }

				} else if ((condition.tier == this.now_select_tier) || !condition.tier) {
					if (v.status == 1 || v.status == 2) {
						count++
					}
					list_info.push(v)
				}
			}
			this.SetTab(this.now_select_tier)
			// this._lb_progress.style.fontSize = 22
			// this._lb_progress.style.color = "#663915"
			// this._lb_progress.style.wordWrap = false
			// this._lb_progress.style.bold = true
			// let condition = CustomActivityModel.GetInstance().GetActCondition(this._act_info.base_type, this._act_info.sub_type, "data", this.max_gift_info.grade)
			// if (condition) {
			// 	this._lb_progress.innerHTML = "已达成天数:" + "<font color = '#d15e00'>" + count + "</font>/" + condition.day
			// } else {
			// 	this._lb_progress.innerHTML = "已达成天数:" + "<font color = '#d15e00'>" + count + "</font>/" + list_info.length
			// }

			// this._lb_progress.x = 198 / 2 - this._lb_progress.contextWidth / 2
			// this._lb_progress.y = 30 / 2 - this._lb_progress.contextHeight / 2
			this._ac_item.replaceAll(list_info)
			this.ChangeView()
		}

		this.ChangeView = () => {
			let title_url
			if (this.now_select_tier == 1) {
				title_url = GameResPath.GetIcon("activity", "ui_xelc_03")
			} else if (this.now_select_tier == 2) {
				title_url = GameResPath.GetIcon("activity", "ui_xelc_05")
			} else if (this.now_select_tier == 3) {
				title_url = GameResPath.GetIcon("activity", "ui_xelc_06")
			} else {
				title_url = GameResPath.GetIcon("activity", "ui_xelc_03")
			}
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, title_url, true)
		}

		this.SetTab = (index?) => {
			if (this.is_loaded) {
				if (index) {
					if (this.type_1 == true && this.type_2 == true && this.type_3 == true) {
						for (let i = 1; i < 4; i++) {
							if (index == i) {
								ResManager.GetInstance().SetImageSprite(this, this["_btn_bg_" + i], "activity", "ui_xelc_01", true)
								this["_lb_btn_" + i].color = "#ffffff"
								this["_lb_btn_" + i].stroke = 4
								this["_lb_btn_" + i].strokeColor = "#ad455c"
							} else {
								ResManager.GetInstance().SetImageSprite(this, this["_btn_bg_" + i], "activity", "ui_xelc_02", true)
								this["_lb_btn_" + i].color = "#403442"
								this["_lb_btn_" + i].stroke = 4
								this["_lb_btn_" + i].strokeColor = "#c6c3f4"
							}
						}
					} else {
						this._gp_tab.visible = false
						this._group_item.y = 230
						this._group_item.height = 760
					}
				} else {
					this._gp_tab.visible = false
					this._group_item.y = 230
					this._group_item.height = 760
					return
				}
			}
		}

		this.DeleteMe = () => {
			if (this.item) {
				this.item.DeleteMe()
			}
			this.item = null
			super.DeleteMe()
		}
	}





	bg: Laya.Image
	bg1: Laya.Image
	_img_bg: Laya.Image
	_img_title: Laya.Image
	_titleBg: Laya.Image
	_gp_tips: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	time_bg: Laya.Image
	_gp_time: Laya.Box
	grade_item: Laya.Box
	_group_item: Laya.List
	_gp_tab: Laya.HBox
	_btn_1: Laya.Box
	_btn_bg_1: Laya.Image
	_lb_btn_1: Laya.Label
	_btn_red_1: Laya.Image
	_btn_2: Laya.Box
	_btn_bg_2: Laya.Image
	_lb_btn_2: Laya.Label
	_btn_red_2: Laya.Image
	_btn_3: Laya.Box
	_btn_bg_3: Laya.Image
	_lb_btn_3: Laya.Label
	_btn_red_3: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.bg1,
			this._img_bg,
			this._img_title,
			this._titleBg,
			this._gp_tips,
			this._Image1,
			this._Label1,
			this.time_bg,
			this._gp_time,
			this.grade_item,
			this._group_item,
			this._gp_tab,
			this._btn_1,
			this._btn_bg_1,
			this._lb_btn_1,
			this._btn_red_1,
			this._btn_2,
			this._btn_bg_2,
			this._lb_btn_2,
			this._btn_red_2,
			this._btn_3,
			this._btn_bg_3,
			this._lb_btn_3,
			this._btn_red_3,
		]
			= this.GetChildrenByNames([

				"bg",
				"bg1",
				"_img_bg",
				"_img_title",
				"_titleBg",
				"_gp_tips",
				"_Image1",
				"_Label1",
				"time_bg",
				"_gp_time",
				"grade_item",
				"_group_item",
				"_gp_tab",
				"_btn_1",
				"_btn_bg_1",
				"_lb_btn_1",
				"_btn_red_1",
				"_btn_2",
				"_btn_bg_2",
				"_lb_btn_2",
				"_btn_red_2",
				"_btn_3",
				"_btn_bg_3",
				"_lb_btn_3",
				"_btn_red_3",
			])
	}
}
window["ConRechargeView"] = ConRechargeView