import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, Util } from "../util/Util"

export class ftvAnyRechargeView extends BaseItem1 {
	_img_desc: Laya.Image
	_gp_time: Laya.Box
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	_Image11: Laya.Image
	_gp_reward: Laya.Box
	CustomMehod
	Emp_btn
	InitEvent
	InitReward
	InitView
	LocalDeleteMe
	RefBtn

	public constructor(parent?) {
		super(parent)


		let model = CustomActivityModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		let info_ = null
		let data_ = null
		let grade_data_ = null
		let item_list_ = []
		let timer_ = null
		let pos_ = [{ x: 30, y: 45 }, { x: 180, y: 45 }, { x: 327, y: 45 }, { x: 30, y: 283 }, { x: 180, y: 283 }, { x: 327, y: 283 }]
		this.base_file = "ftvAnyRecharge"
		this.layout_file = "ftvAnyRechargeView"
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {

			this.InitEvent()
			this.InitView()
		}

		this.InitEvent = () => {
			let getReward = (...new_args) => {
				let args = new_args
				if ((info_ && args[0] == info_.base_type) && args[1] == info_.sub_type) {
					data_ = model.GetActData(args[0], args[1])
					if (!data_ || data_.reward_list.length == 0) {
						return
					}
					grade_data_ = data_.reward_list[0]
					if (!grade_data_) {
						return
					}
					this.RefBtn()
					let reward = model.GetActReward(args[0], args[1], grade_data_.form_type, grade_data_.reward)
					if (reward.length > 0) {
						let view = new CongratulationObtainView(reward, 10)
						view.Open()
					}
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, getReward)
			let updataView = (...new_args) => {
				let args = new_args
				if ((info_ && args[0] == info_.base_type) && args[1] == info_.sub_type) {
					data_ = model.GetActData(args[0], args[1])
					this.InitReward()
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, updataView)
			Util.AddClickEvent(this._btn, () => {
				if (!grade_data_) {
					return
				}
				let status = grade_data_.status
				if (0 == status) {
					OpenFun.OpenFunHandler(21)
				} else if (1 == status) {
					model.RequireGetAward(data_.base_type, data_.sub_type, grade_data_.grade)
				} else if (2 == status) {
					Message.show("已领取该奖励")
				}
			}
				, this, true)
		}

		this.InitView = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg && info_) {
				model.LoadCompontRes(this, cfg, "ftvAnyRechargeView", info_.show_id)
			}
			if (!info_) {
				return
			}
			timer_ = model.LoadActTimer(this._gp_time, info_.etime, 22, "#ffdf7d", null, "#ffffff", "倒计时：")
			model.CloseACTRed(info_.base_type, info_.sub_type, null, info_.show_id)
			this.InitReward()
			//ResManager.GetInstance().SetImageSprite(this, this._img_desc, "ftvAnyRecharge", "uijrsc_002")
			//lua_resM:SetOutsideImageSprite(this,this._img_desc,GameResPath.GetIcon("ftvAnyRecharge"))
		}

		this.RefBtn = () => {
			if (!grade_data_) {
				return
			}
			let status = grade_data_.status
			this.labelDisplay.text = status != 2 && "一键领取" || "已领取"
			this._img_red.visible = status == 1
		}

		this.InitReward = () => {
			if (!info_) {
				return
			}
			let b = info_.base_type
			let s = info_.sub_type
			let data = model.GetActData(b, s)
			if (!data || data.reward_list.length == 0) {
				return
			}
			data_ = data
			let vo = data.reward_list[0]
			if (!vo) {
				return
			}
			grade_data_ = vo
			let reward = model.GetActReward(b, s, vo.form_type, vo.reward)
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					let item: EquipmentItem = item_list_[_tmpi]
					item.SetVisible(false)
				}
			}
			for (let i in reward) {
				let reward_data = reward[i]
				let item: EquipmentItem = item_list_[i]
				if (!item) {
					item = new EquipmentItem(this._gp_reward)
					item.Load()
					item.SetItemSize(85, 85)
					item.ExcuteCallback(() => {
						let pos = pos_[i]
						if (pos) {
							SetAnchoredPosition(item.display_obj, pos.x, pos.y)
						}
					})

				}
				let pos = pos_[i]
				if (pos) {
					SetAnchoredPosition(item.display_obj, pos.x, pos.y)
				}
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_data[0], reward_data[1])
				item.SetData(type, reward_data[2], lock)
			}
			this.RefBtn()
		}

		this.CustomMehod = (indx?, args?) => {
			if (args) {
				info_ = args
			}
		}

		this.LocalDeleteMe = () => {
			if (timer_) {
				timer_.DeleteMe()
				timer_ = null
			}
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					let item = item_list_[_tmpi]
					item.DeleteMe()
				}
				item_list_ = []
			}
		}
	}

	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_desc,
			this._gp_time,
			this._btn,
			this._Image1,
			this.labelDisplay,
			this._img_red,
			this._Image11,
			this._gp_reward,
		]
			= this.GetChildrenByNames([

				"_img_desc",
				"_gp_time",
				"_btn",
				"_Image1",
				"labelDisplay",
				"_img_red",
				"_Image11",
				"_gp_reward",
			])
	}
}
window["ftvAnyRechargeView"] = ftvAnyRechargeView