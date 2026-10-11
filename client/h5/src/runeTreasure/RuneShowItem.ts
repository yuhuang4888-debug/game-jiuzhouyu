import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GlobalTimerQuest, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel } from "../commonModel/RuneModel"
import { WordManager } from "../common/WordManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { Point } from "../scene/AstarManager"
import { LayerManager } from "../common/LayerManager"

export class RuneShowItem extends BaseItemRenderer {
	WIDTH = 170
	HEIGT = 450

	model
	res_mgr
	goods_model
	rune_model

	timer_id
	anim_time = 0.01
	move_step = 0.5
	scale_step = 0.001

	rune_color = {
		1: "rune_N",
		2: "rune_R",
		3: "rune_SR",
		4: "rune_SSR",
		5: "rune_UR",
		6: "rune_SP"
	}

	public constructor() {
		super()
		this.base_file = "runeTreasure"
		this.layout_file = "RuneResultItem"

		this.res_mgr = ResManager.GetInstance()
		this.model = RuneTreasureModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.rune_model = RuneModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.scaleX = this.scaleY = 0.95
				this.PlayAnim()
			}, this.anim_time)
		}
		this.Load()
	}

	public LoadSuccess() {
		this._img_bg.visible = false
		this._btn_click.y = 325
		this.display_obj.height = 450
		this.display_obj.width = this.WIDTH
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn_click, () => {
			let basic = this.goods_model.GetGoodsBasicByTypeId(this.data.goods_id)
			if (basic) {
				UIToolTipMgr.GetInstance().AppendIllusionTips(basic.type_id)
			}
			// UIToolTipMgr.GetInstance().AppendGoodsTips(this.data.goods_id)
		}, this, false)
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		let url = "resource/game/runeIcon/" + this.data.goods_id + ".png"
		this.res_mgr.SetOutsideImageSprite(this, this._img_icon, url)
		let basic = this.goods_model.GetGoodsBasicByTypeId(this.data.goods_id)
		if (basic) {
			let icon = this.rune_color[basic.color]
			this.res_mgr.SetImageSprite(this, this._img_color, "runeTreasure", icon)
			let rune = this.rune_model.GetRuneProList(basic.subtype, 1, basic.color)
			if (rune) {
				if (rune.length == 1) {
					this._lb_msg1.text = ""
					this._lb_msg2.text = basic.goods_name
					this._lb_msg3.text = WordManager.GetProperties(rune[0][0]) + "：" + WordManager.ConvertToPercentValue(rune[0][0], rune[0][1])
				} else {
					this._lb_msg1.text = basic.goods_name
					this._lb_msg2.text = WordManager.GetProperties(rune[0][0]) + "：" + WordManager.ConvertToPercentValue(rune[0][0], rune[0][1])
					this._lb_msg3.text = WordManager.GetProperties(rune[1][0]) + "：" + WordManager.ConvertToPercentValue(rune[1][0], rune[1][1])
				}
			}
		}
	}

	public PlayAnim() {
		let point = new Laya.Point(this.display_obj.x + this.display_obj.width / 2, this.display_obj.y + this.display_obj.height / 2)
		point = this.display_obj.localToGlobal(point)
		let centerX = LayerManager.GetInstance().stageWidth / 2
		let dis = Math.abs(point.x - centerX)
		this._btn_click.scaleX = 0.9 - dis * this.scale_step
		this._btn_click.scaleY = 0.9 - dis * this.scale_step
		//this._btn_click.y = 325 - dis * this.move_step
		this._btn_click.y = 325 - (dis * dis) / 1400
	}

	public DeleteMe() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
		super.DeleteMe()
	}

	_btn_click: Laya.Box
	_img_icon: Laya.Image
	_img_color: Laya.Image
	_lb_msg1: Laya.Label
	_lb_msg2: Laya.Label
	_lb_msg3: Laya.Label
	_img_bg: Laya.Image
	public GetComponents() {
		[
			this._btn_click,
			this._img_icon,
			this._img_color,
			this._lb_msg1,
			this._lb_msg2,
			this._lb_msg3,
			this._img_bg,
		]
			= this.GetChildrenByNames([
				"_btn_click",
				"_img_icon",
				"_img_color",
				"_lb_msg1",
				"_lb_msg2",
				"_lb_msg3",
				"_img_bg",
			])
	}
}
window["RuneShowItem"] = RuneShowItem