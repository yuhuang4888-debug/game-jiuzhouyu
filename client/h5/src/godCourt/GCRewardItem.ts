

//@描述:itemRenderer
//@作者:code
//@Laya版本:2.12.2
//@日期:2022-12-15  15:13

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { GodCourtModel } from "../commonModel/GodCourtModel"

export class GCRewardItem extends BaseItemRenderer {
	/*----这里定义变量-----*/


	/*---------------------*/
	public WIDTH = 90
	public HEIGHT = 96
	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GCRewardItem"

		this.Load()
	}

	public load_callback() {
		this.InitEvent()
	}

	/**
	* 初始化事件
	*/
	public InitEvent() {
		Util.AddClickEvent(this._gp_click, () => {
			if (this.data && this.data.status == 1) {
				GodCourtModel.GetInstance().Fire(GodCourtModel.SEND_SCMD, 23309, "h", this.data.times)
			} else {
				GodCourtModel.GetInstance().Fire(GodCourtModel.OPEN_VIEW, "GodHouseRewardView")
			}
		}, this, true)
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		let data = this.data
		this.countLb.text = "升橙" + data.times + "次"
		if (data.status == 3) {
			this.recivedImg.visible = true
		} else {
			this.recivedImg.visible = false
		}
		this._img_red.visible = data.status == 1
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_gp_click: Laya.Box
	_img_bg: Laya.Image
	countLb: Laya.Label
	effectGp: Laya.Box
	recivedImg: Laya.Image
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._gp_click,
			this._img_bg,
			this.countLb,
			this.effectGp,
			this.recivedImg,
			this._img_red,
		]
		= this.GetChildrenByNames([

			"_gp_click",
			"_img_bg",
			"countLb",
			"effectGp",
			"recivedImg",
			"_img_red",
		])
	}
}
window["GCRewardItem"] = GCRewardItem