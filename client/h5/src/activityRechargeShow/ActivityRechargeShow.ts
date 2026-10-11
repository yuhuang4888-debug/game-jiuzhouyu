
import { Enum_UILayer } from "../common/LayerManager"
import { BaseView1 } from "../common/BaseView1"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { table } from "../common/table"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ActivityRechargeShowItem } from "./ActivityRechargeShowItem"
import { Util } from "../util/Util"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { IS2CTiredChargePoliteTaskInfoParam, IS2CTiredChargePoliteTasksParam, TiredChargePoliteModel, TiredChargePoliteTaskState } from "../commonModel/TiredChargePoliteModel"
import { VipModel } from "../commonModel/VipModel"
import { OpenFun } from "../common/OpenFun"
import { PlatformManager } from "../PlatformManager"


export class ActivityRechargeShow extends BaseView1 {
	product_info_
	_model: CustomActivityModel
	list_loop: LoopScrowViewMgr
	InitEvent
	is_recharging_ = false
	vip_model
	public constructor(parent?) {
		super()
		this.base_file = "activityRechargeShow"
		this.layout_file = "ActivityRechargeShow"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.destroy_imm = true
		this.is_center = true
		this.click_bg_toClose = true
		this.change_scene_close = true
		this.show_open_movie = true
		this._model = CustomActivityModel.GetInstance()
		this.vip_model = VipModel.GetInstance()
		this.load_callback = () => {
			//resource/game/activityRechargeShow/other/ui_czhl_03.png
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg4, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_03"), false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_02"), false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_01"), false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title_bg, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_05"), false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_yuan, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_06"), false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tip, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_07"), false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tip2, GameResPath.GetIcon("activityRechargeShow", "ui_czhl_08"), false)
			this._img_tip.visible = this._img_yuan.visible = this._lb_num.visible = false

			ResManager.GetInstance().LoadFont(this, "act_recharge_show", this._lb_num, 32, false, () => {
				if (this.product_info_) this._lb_num.text = `${this.product_info_.money}`
				let gap = 0
				let all_width = this._lb_num.textField.textWidth + this._img_yuan.width + gap
				this._lb_num.width = this._lb_num.textField.textWidth
				let center_x = (123 - all_width) / 2 + 255
				this._lb_num.x = center_x
				this._img_yuan.x = center_x + this._lb_num.textField.textWidth + gap
			})
			this.InitEvent()
			this.ShowReward()

		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)


			Util.AddClickEvent(this._btn, () => {
				this.is_recharging_ = true
				if (this.product_info_) {
					PlatformManager.GetInstance().PayRequest(this.product_info_.money, { id: this.product_info_.product_id, pay_title: this.product_info_.product_name })
				}
			}, this, true)


			let UpdateView = (scmd?) => {
				if (!this.product_info_) return
				if (this.product_info_ && this.product_info_.product_id && scmd && scmd.product_id) {
					if (scmd) {
						if (this.is_recharging_ && this.product_info_.product_id != 1) {
							this.is_recharging_ = false
						}
					}
				}
			}

			this.BindEvent(this.vip_model, VipModel.UPDATE_RECHARGE_VIEW, UpdateView)

			this.BindEvent(this.vip_model, VipModel.UPDATE_RECHARGE_TYPETWO, (info?) => {
				if (!this.product_info_) return
				if (info == null && this.is_recharging_) {
					this.is_recharging_ = false
					return
				}
			}
			)


			this.BindEvent(VipModel.GetInstance(), VipModel.CLOSE_SOME_VIEW, () => {
				this.Close()
			})


			let UpdateView_1 = (scmd?) => {

				if (!scmd) {
					//充值成功
					setTimeout(() => {
						if (this.use_delete_method) return
						this.ShowReward()
					}, 200);
				
				}

			}

			this.BindEvent(this.vip_model, VipModel.UPDATE_RECHARGE_VIEW, UpdateView_1)


		}

		this.destroy_callback = () => {
			if (this.list_loop) {
				this.list_loop.DeleteMe()
				this.list_loop = null
			}
		}

	}

	public ShowReward() {

		//定制活动
		let is_next = false
		let list = this._model.GetRechargeList(this.product_info_.product_id)
		if (list.length <= 0) {
			list = this._model.GetRechargeList(9999)
			is_next = true
		}

		if (list.length <= 0) {
			this.Close()
			return
		}



		//文字提示
		if (!is_next) {
			this._img_tip2.visible = this._img_yuan.visible = this._lb_num.visible = true
			this._img_tip.visible = false
		} else {
			this._img_tip.visible = true
			this._img_tip2.visible = this._img_yuan.visible = this._lb_num.visible = false
		}



		//压入一个假数据
		table.insert(list, {
			item_name: "假数据",
			reward_list: [],
			desc: "",
			is_faker: true
		})


		if (!this.list_loop) {
			this.list_loop = new LoopScrowViewMgr()
			this.list_loop.SetData(this._group_item, ActivityRechargeShowItem, list, LoopScrCon.Vertical, 1)
		} else {
			this.list_loop.replaceAll(list)
		}

	}


	public Open(...new_args) {
		this.product_info_ = new_args && new_args[0] || 0
		super.Open()
	}



	public DeleteMe() {
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_bg4: Laya.Image
	_img_title_bg: Laya.Image
	_img_tip2: Laya.Image
	_img_tip: Laya.Image
	_img_yuan: Laya.Image
	_group_item: Laya.List
	_img_bg2: Laya.Image
	_lb_num: Laya.Label
	_img_close: Laya.Image
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg4,
			this._img_title_bg,
			this._img_tip2,
			this._img_tip,
			this._img_yuan,
			this._group_item,
			this._img_bg2,
			this._lb_num,
			this._img_close,
			this._btn,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg4",
				"_img_title_bg",
				"_img_tip2",
				"_img_tip",
				"_img_yuan",
				"_group_item",
				"_img_bg2",
				"_lb_num",
				"_img_close",
				"_btn",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["ActivityRechargeShow"] = ActivityRechargeShow