import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { MarketModel } from "../commonModel/MarketModel"
import { Util, Trim } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
export class Market1TypeItem extends BaseItemRenderer {
	_group_click: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_lb_name: Laya.Label
	_lb_count: Laya.Label
	model
	public static width = 127
	public static height = 127
	public constructor() {
		super()
		this.base_file = "market"
		this.layout_file = "MarketTypeItem"

		
		this.load_callback = () => {
			Util.AddClickEvent(this._group_click, () => {
				this.ClickCallback()
			}, this, true)
		}

		this.model = MarketModel.GetInstance();
		this.Load()
		// this.load_callback = () => {


		// 	// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	// 	this._lb_name.size  = 18
		// 	// 	this._lb_name.lineSpacing = 0.6
		// 	// }
		// }

	}
	public createChildren() {
		super.createChildren()
		
	}
	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data
			let cfg = this.model.GetTypeCfg(data.type, data.subtype)
			if (!cfg) {
				return
			}
			this._lb_name.text = Trim(cfg.subtype_name)
			this._lb_count.text = data.sell_num || 0
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(cfg.icon))
		}
	}

	public ClickCallback() {
	}



	public GetComponents() {
		[
			this._group_click,
			this._img_bg,
			this._img_icon,
			this._lb_name,
			this._lb_count,
		]
			= this.GetChildrenByNames([

				"_group_click",
				"_img_bg",
				"_img_icon",
				"_lb_name",
				"_lb_count",
			])
	}
}

window["Market1TypeItem"] = Market1TypeItem