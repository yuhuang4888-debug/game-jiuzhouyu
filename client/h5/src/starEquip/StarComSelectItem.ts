import { AStarEquipBagItem } from "./AStarEquipBagItem"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarComSelectItem extends AStarEquipBagItem {
	WIDTH = 102
	HEIGT = 100
	public constructor() {
		super()
	}

	public ClickFunc() {
		if ((this.data && this.data.goods_id) && this.data.comIndex) {
			StarEquipModel.GetInstance().SelectComMat(this.data.goods_id, this.data.comIndex, true)
			StarEquipModel.GetInstance().Fire(StarEquipModel.CLOSE_VIEW, "StarEquipComSelectView")
		}
	}
}
