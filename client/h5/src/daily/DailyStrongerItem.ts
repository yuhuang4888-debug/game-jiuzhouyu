import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, SetSizeDeltaY, SetSizeDeltaX, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { DailyEvent } from "./DailyEvent"

export class DailyStrongerItem extends BaseItemRenderer {
	public WIDTH = 695
	public HEIGT = 120

	_model
	star_list

	public static width = 695
	public static height = 120
	public constructor() {
		super()
		this.base_file = "daily"
		this.layout_file = "DailyStrongerItem"
		this._model = DailyModel.GetInstance()
		this.star_list = []
		this.Load()
	}

	public load_callback() {

		//lua_resM:SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("friend","uitc_007"))
		this.InitEvents()
	}

	public InitEvents() {
		Util.AddClickEvent(this._btn_go, () => {
			let jump_id = this.data.jump_id
			if (jump_id == 0) {
				//this._model.Fire(DailyEvent.OPEN_VIEW, "DailyView")
				//OpenFun.OpenFunHandler(82)
				DailyModel.GetInstance().Fire(DailyEvent.DAILY_CLOSE_VIEW, "DailyView")
			} else {
				if (this.data.jump_id == 88 || this.data.jump_id == 104) {
					let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
					let cfg = CommonManager.GetInstance().GetFunctionIconCfg("283")
					if (cfg) {
						let maxDay = Number(cfg.max_open_day)
						if (openDay > maxDay) {
							OpenFun.OpenFunHandler(104)
						} else {
							OpenFun.OpenFunHandler(88)
						}
					}
				} else {
					OpenFun.OpenFunHandler(this.data.jump_id, this.data.jump_sub_id)
				}
			}
		}
			, this, true)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this.CreateStar(this.data.star)
			this._lb_name.text = this.data.name
			this._lb_desc.text = this.data.desc
			let _data = this._model.getStrongerDataByid(this.data.id)
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			this._lb_level.visible = level < this.data.lv
			if (this._lb_level.visible) {
				this._lb_level.text = this.data.lv + "级开启"
			}
			this._btn_go.visible = !this._lb_level.visible
			Util.SetImageGray(this._Image1, false)
			this.labelDisplay.stroke = 2
			this.labelDisplay.strokeColor = "#3e9298"
			if ((this._btn_go.visible && _data) && this.data.day_limit == 1) {
				Util.SetImageGray(this._Image1, _data.state == 1)
				this.labelDisplay.strokeColor = ColorUtil.TryParseHtmlString("#adadad")
				//this._btn_go.touchEnabled = _data.state != 1
				//if (! this._btn_go.touchEnabled ) {
				//this.bg.alpha = 0.8
				//}
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_icon, GameResPath.GetDailyIconPath(this.data.icon_id))
		}
	}

	//创建星星
	public CreateStar(num?) {

		for (let i = 0; i < this.star_list.length; i++) {
			var v = this.star_list[i]
			if (v) {
				v.visible = false
			}
		}
		for (let i = 1; i <= 5; i++) {
			let star = this.star_list[i]
			if (star == null) {
				star = new Laya.Image()
				star.width = 27
				star.height = 27
				this.star.addChild(star)
				this.star_list[i] = star
			} else {
				star.visible = true
			}
			// star.transform.pivot = Vector2(0, 1)
			// let x = (i - 1) * 30
			// star.x = Vector3(x, 0, 0)
			if (i <= num) {
				ResManager.GetInstance().SetImageSprite(this, star, "daily_asset", "uity_043a")
			} else {
				ResManager.GetInstance().SetImageSprite(this, star, "daily_asset", "uity_043a1")
			}
		}
	}

	public DeleteMe() {

		if (this.star_list&&this.star) {
			// for (let i = 0; i < this.star_list.length; i++) {
			// 	var v = this.star_list[i]
			// 	// destroy(v)
			// 	this.star.removeChildren(i, this.star_list.length - 1)
			// }
			this.star.removeChildren(0, this.star_list.length - 1)
			this.star_list = []
		}
		super.DeleteMe()
	}

	bg: Laya.Image
	star: Laya.HBox
	_lb_name: Laya.Label
	_lb_desc: Laya.Label
	_btn_go: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_lb_level: Laya.Label
	image2: Laya.Image
	_img_icon: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.star,
			this._lb_name,
			this._lb_desc,
			this._btn_go,
			this._Image1,
			this.labelDisplay,
			this._lb_level,
			this.image2,
			this._img_icon,
		]
			= this.GetChildrenByNames([

				"bg",
				"star",
				"_lb_name",
				"_lb_desc",
				"_btn_go",
				"_Image1",
				"labelDisplay",
				"_lb_level",
				"image2",
				"_img_icon",
			])
	}
}
window["DailyStrongerItem"] = DailyStrongerItem