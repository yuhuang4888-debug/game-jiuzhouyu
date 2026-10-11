
import { Trim, Util } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
export class TopPlayerGetWayItem extends BaseItemRenderer {
	_Image11: Laya.Image
	targetName: Laya.Label
	btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	tip: Laya.Image
	time: Laya.Label
	_type
	act_show_id
	act_type
	public static width = 488
	public static height = 80
	WIDTH = 520
	HEIGT = 90
	public constructor(parent) {
		super()


		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerGetWayItem"
		this.load_callback = () => {

			Util.AddClickEvent(this.btn, () => {
				GlobalEventSystem.Fire(EventName.TOOLTIPS_JUMP)
				if (this.act_type == null) {
					OpenFun.OpenFunHandler(this._type)
				} else {
					OpenFun.OpenFunHandler(this._type, this.act_type, this.act_show_id)
				}
			}
				, this, true)
		}
		this.Load()
	}


	public dataChanged() {
		if (super.dataChanged()) {
			this._type = this.data.open_id
			this.act_type = this.data.act_type
			this.act_show_id = this.data.show_id
			this.targetName.text = this.data.desc
			this.tip.visible = this.data.label
			this.time.visible = this.data.label && this.data.label == 2
			if (this.data.label) {
				let res = this.data.label == 2 ? "bimai" : "chaozhi"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.tip, GameResPath.GetIconOtherPath("topPlayer", res))
				if (this.data.label == 2) {
					this.time.visible = this.data.end_time - TimeUtil.getServerTime() > 0
					if (this.data.end_time - TimeUtil.getServerTime() > 0)
						this.time.text = `剩余时间：${TimeUtil.timeConvert(this.data.end_time - TimeUtil.getServerTime(), "dd-hh-mm-ss")}`

				}

			}

		}
	}





	public GetComponents() {
		[
			this._Image11,
			this.targetName,
			this.btn,
			this._Image1,
			this.labelDisplay,
			this.tip,
			this.time
		]
			= this.GetChildrenByNames([

				"_Image11",
				"targetName",
				"btn",
				"_Image1",
				"labelDisplay",
				"tip",
				"time"
			])
	}
}
window["TopPlayerGetWayItem"] = TopPlayerGetWayItem