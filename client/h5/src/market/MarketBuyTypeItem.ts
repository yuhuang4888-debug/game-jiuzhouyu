import { Market1TypeItem } from "./Market1TypeItem"
import { MarketEvent, MarketViewType } from "../commonModel/MarketModel"
export class MarketBuyTypeItem extends Market1TypeItem {
	public static width = 165
	public static height = 165

	public ClickCallback() {

		let data = this.data
		if(data)
			this.model.Fire(MarketEvent.SWTICH_BUY_SUBVIEW, MarketViewType.CTRL, data.type, data.subtype, 1, 1, 1)
	}
}

window["MarketBuyTypeItem"] = MarketBuyTypeItem