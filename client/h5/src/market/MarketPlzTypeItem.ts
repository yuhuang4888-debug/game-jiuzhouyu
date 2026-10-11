import { Market1TypeItem } from "./Market1TypeItem"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Message } from "../sysInfo/SysInfoController"
import { MarketEvent } from "../commonModel/MarketModel"
export class MarketPlzTypeItem extends Market1TypeItem {
	public static width = 159
	public static height = 159
	need_refresh = false
	public constructor() {
		super()

		// this.load_callback = () => {
		// 	this.GetComponents()


		// }
		this.load_callback = () => {
			this._lb_count.visible = false
			Util.AddClickEvent(this._group_click, () => {
				this.ClickCallback()
			}, this, true)
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}

	}
	public createChildren() {
		super.createChildren()


	}

	public dataChanged() {
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		let data = this.data
		let cfg = this.model.GetTypeCfg(data.type, data.subtype)
		if (!cfg) {
			return
		}
		this._lb_name.text = cfg.subtype_name
		this._lb_count.text = ""
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(cfg.icon))


	}

	public ClickCallback(e?) {

		let data = this.data
		let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
		let list = this.model.GetPlzGoodsByCond(data.type, data.subtype, 99, 99, 99, equip_attr_cfg)
		if (list.length < 1) {
			Message.show("没有物品可供求购")
			return
		}
		this.model.Fire(MarketEvent.CLICK_PLZ_TYPE_ITEM, data)
	}
}
window["MarketPlzTypeItem"] = MarketPlzTypeItem