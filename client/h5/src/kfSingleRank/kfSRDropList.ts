import { DownDropList } from "../common/DownDropList"
import { Util } from "../util/Util"
import { kfSRDropItem } from "./kfSRDropItem"

export class kfSRDropList extends DownDropList {
	public constructor(parent) {
		super(parent)

		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRDropList"
		this._btn_class = kfSRDropItem
		this._item_height =50
		this._btn_gap = 5
		this.is_cus_width=true
		this.cus_width=200

	}


}
 window["kfSRDropList"]= kfSRDropList