import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class TSCrackLockServerItem extends BaseItemRenderer {
	_lb_name: Laya.Label
	_lb_lv: Laya.Label
	gp: Laya.HBox
	bg: Laya.Image

	public static width = 268
	public static height = 24
	WIDTH = 333
	HEIGT = 34
	public constructor(parent) {
		super()


		this.base_file = "tsCrack"
		this.layout_file = "TSCrackLockServerItem"
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("tsCrack", "ui_kfjd_004"))
		}
		this.Load()
	}



	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			this._lb_name.text = "s." + data.server_num + "	" + data.server_name
			let lv = data.lv > 370 && "神创" + (data.lv - 370) || data.lv
			this._lb_lv.text = lv + "级"
			this.gp.refresh()
		}



	}


	public GetComponents() {
		[
			this._lb_name,
			this._lb_lv,
			this.gp,
			this.bg
		]
			= this.GetChildrenByNames([

				"_lb_name",
				"_lb_lv",
				"gp",
				"bg"
			])
	}
}
window["TSCrackLockServerItem"] = TSCrackLockServerItem