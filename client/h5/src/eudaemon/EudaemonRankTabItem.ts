import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"

export class EudaemonRankTabItem extends BaseItem1 {
	select_cache
	callback
	data
	index

	need_refresh_data
	public constructor(parent) {
		super(parent)
		this.base_file = "eudaemon"
		this.layout_file = "EudaemonRankTabItem"
		
		this.load_callback = () => {
			Util.AddClickEvent(this._img_bg, () => {
				if (this.callback) {
					this.callback(this.index)
				}
			}, this)
			if (this.select_cache) {
				this.SetSelect(this.select_cache)
			}

			if(this.need_refresh_data){
				this.need_refresh_data = false
				this._lb_name.text = this.data.name
			}
		}
	}

	public SetData(data?, callback?, index?) {
		this.data = data
		this.callback = callback
		this.index = index
		if(this.is_loaded){
			this._lb_name.text = this.data.name
		}
		else{
			this.need_refresh_data = true
		}
	}

	public SetSelect(bool?) {
		if (this.is_loaded) {
			if(bool){
				this._lb_name.color = "#9b572f"
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "eudaemon","ui_button_orange")
			}else{
				this._lb_name.color = "#ffffff"
				ResManager.GetInstance().SetImageSprite(this, this._img_bg, "eudaemon", "ui_button_mid_1")
			}
		} else {
			this.select_cache = bool
		}
	}
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_name",
			])
	}
}
window["EudaemonRankTabItem"] = EudaemonRankTabItem