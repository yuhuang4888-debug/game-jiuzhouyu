import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"

export class EudaemonTaskTabItem extends BaseItem1 {
	callback
	data
	index
	select_cache

	public constructor(parent) {
		super(parent)

		this.base_file = "eudaemon"
		this.layout_file = "EudaemonTaskTabItem"
		this.load_callback = () => {
			if (this.data) {
				this.SetData(this.data, this.index)
				this.data = null
			}

			if (this.select_cache) {
				this.SetSelect(this.select_cache)
			}

			Util.AddClickEvent(this._box_con, () => {
				if (this.callback) {
					this.callback(this.index)
				}
			}, this)
		}
	}

	public SetData(data?, index?) {

		this.index = index
		if (this.is_loaded) {
			this._lb_name.text = data.name
		} else {
			this.data = data
		}
	}

	public SetClickCall(callback?) {
		this.callback = callback
	}

	public SetSelect(bool?) {

		if (this.is_loaded) {
			if (bool) {
				this._lb_name.color = "#ffffff"
				this._lb_name.strokeColor = "#ad455c"
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "eudaemon", "ui_kf_dgxs0102")
			} else {
				this._lb_name.color = "#4f538f"
				this._lb_name.strokeColor = "#c6c3f4"
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "eudaemon", "ui_kf_dgxs0101")
			}
		} else {
			this.select_cache = bool
		}
	}

	public DeleteMe(): void {
		super.DeleteMe()
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_lb_name",
			])
	}
}
window["EudaemonTaskTabItem"] = EudaemonTaskTabItem