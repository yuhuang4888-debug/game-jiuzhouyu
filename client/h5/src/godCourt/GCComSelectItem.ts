import { GCBagItem } from "./GCBagItem"
import { GodCourtModel } from "../commonModel/GodCourtModel"

export class GCComSelectItem extends GCBagItem {
	WIDTH = 90
    HEIGT = 90
	ClickFunc

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GCBagItem"

		this.ClickFunc = () => {
			if ((this.data && this.data.goods_id) && this.data.comIndex != null) {
				GodCourtModel.GetInstance().SelectComMat(this.data.goods_id, this.data.comIndex, true)
				GodCourtModel.GetInstance().Fire(GodCourtModel.CLOSE_VIEW, "GCComSelectView")
			}
		}
		this.Load()
	}
}
