import { AccumRechargeItem } from "../activity/AccumRechargeItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { TurnTableModel } from "../commonModel/TurnTableModel"
import { PlatformManager } from "../PlatformManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { Util, HtmlColorTxt, TransformCurrency } from "../util/Util"
import { RechargeItem } from "../vip/RechargeItem"

export class ConRechargeItem extends AccumRechargeItem {
	_canGet
	_enough
	_item_list
	_model
	grade

	public static width = 698
	public static height = 163

	public constructor(partner?) {
		super(partner)
		this._item_list = []
		this._enough = false
		this._canGet = false
		this.base_file = "activity"
		this.layout_file = "ConRechargeItem"

		this._model = CustomActivityModel.GetInstance()

		this.load_callback = () => {
			this.GetComponents()
			this.LoadSuccess()
			this.BindEvent(this._model, CustomActivityDefine.EVENT.UPDATE_RECHARGE_ITEM, () => {
				this.UpdateRecharge()
				// super.UpdateBtn()
			})
		}
	}
	public UpdateRecharge() {

		let data = this.data
		let cond = CustomActivityModel.GetInstance().GetActCondition(data.base_type, data.sub_type, "data", data.grade)
		let is_today = cond.tier && Number(cond.tier) == 1
		if (cond && Number(cond.grade) == 1) {
			this.grade = 1
		}
		let total = 0
		let recharge_list = this._model.GetActRechargeOneDay()
		let recharge_list1 = []
		let finish_count = 0
		if (recharge_list && Util.TableSize(recharge_list) > 0) {
			for (let i = 0; i <= Util.TableSize(recharge_list) - 1; i++) {
				if (recharge_list[i].total_gold > 0) {
					table.insert(recharge_list1, recharge_list[i].total_gold)
					if (recharge_list[i].total_gold >= Number(cond.gold)) {
						finish_count++
					}
				}
			}
			// if (recharge_list1 && Util.TableSize(recharge_list1) > 0) {
			// 	for (let i = 0; i <= Util.TableSize(recharge_list1) - 1; i++) {
			// 		if (i + 1 == Number(cond.day)) {
			// 			total = recharge_list1[i]
			// 			break
			// 		}
			// 	}
			// }


		}
		if (this._model.GetActRechargeDay() < Number(cond.gold)) {
			finish_count++
		}
		total = total == null && 0 || total
		let target = is_today && Number(cond.today_gold) || Number(cond.gold)
		target = target == null && 0 || target
		let enough = total >= target
		let canGet = data.status == 1

		let color = Enum_ColorUtil_Light.GREEN
		let str = HtmlColorTxt(total + "/" + target, color)
		let day_ref = "<font color='#ffe82a'>" + cond.day + "</font>"
		this._lb_title.style.bold = true
		this._lb_title.innerHTML = "累计" + day_ref + "天" + "<font color ='#ffe82a'>" + "充值" + TransformCurrency(target) + "元</font>,可领取奖励！" //(cond && Number(cond.grade) == 1) && "累计" + day_ref + "充值" + target + "勾玉(" + data.recharge_day + "/" + cond.day + ")" || Util.StrToHTML("累计充值" + str + "勾玉" + day_ref)
		this.labelDisplay.text = "前往充值"
		this._reddot.visible = data.status == 1
		this._btn_get.visible = data.status == 1
		this._btn_recharge.visible = data.status == 0
		this._img_over.visible = data.status == 2
		if (finish_count == cond.day) {
			this._lb_progress.style.bold = true
			this._lb_progress.innerHTML = "（已充值:<font color = '#0a953e'>" + TransformCurrency(this._model.GetActRechargeDay())  + "元</font>）"
			this._lb_progress.visible = data.status == 2 ? false : true
			if(PlatformManager.IsEyouPlatform()){
				this._lb_progress.x = -140
			}else{
			this._lb_progress.x = 161 / 2 - this._lb_progress.contextWidth / 2
			}
			this._lb_progress.y = 35 / 2 - this._lb_progress.contextHeight / 2
		} else {
			this._lb_progress.visible = false
		}
		this._enough = enough
		this._canGet = canGet
		let rewards = this._model.GetActReward(data.base_type, data.sub_type, data.form_type, data.reward)
		this.UpdateItems(rewards)
	}
	public dataChanged() {
		if (super.dataChanged()) {
			this.UpdateRecharge()
			ResManager.GetInstance().SetImageSprite(this.base_item, this._Image111, "activity", "cjgh_004", true)
			ResManager.GetInstance().SetImageSprite(this.base_item, this._Image11, "common", "com_rect_btn1")
			ResManager.GetInstance().SetImageSprite(this.base_item, this._Image1, "common", "com_rect_btn3")
			ResManager.GetInstance().SetImageSprite(this.base_item, this._img_over, "activity", "ui_cbdb_05", true)
			this._img_over.x = 500
			this._img_over.width = 123
			this._img_over.height = 56
			this.labelDisplay.stroke = 2
			this.labelDisplay.strokeColor = "#c95b37"
			this.labelDisplay1.stroke = 2
			this.labelDisplay1.strokeColor = "#c5373d"
			if(PlatformManager.IsEyouPlatform()){
				this._gp_reward.y= 45
			}
			return true
		}
	}

	_img_bg: Laya.Image
	_Image111: Laya.Image
	_img_over: Laya.Image
	_btn_recharge: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_btn_get: Laya.Box
	_Image1: Laya.Image
	_reddot: Laya.Image
	labelDisplay1: Laya.Label
	_gp_reward: Laya.List
	_lb_title: Laya.HTMLDivElement
	_lb_progress: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._Image111,
			this._img_over,
			this._btn_recharge,
			this._Image11,
			this.labelDisplay,
			this._btn_get,
			this._Image1,
			this._reddot,
			this.labelDisplay1,
			this._gp_reward,
			this._lb_title,
			this._lb_progress,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image111",
				"_img_over",
				"_btn_recharge",
				"_Image11",
				"labelDisplay",
				"_btn_get",
				"_Image1",
				"_reddot",
				"labelDisplay1",
				"_gp_reward",
				"_lb_title",
				"_lb_progress",
			])

		this._lb_title.style.fontSize = 20
		this._lb_title.style.color = "#ffffff"
		this._lb_title.style.wordWrap = false
		this._lb_progress.style.color = "#663915"
		this._lb_progress.style.fontSize = 18
		this._lb_progress.style.wordWrap = false
	}
}
window["ConRechargeItem"] = ConRechargeItem