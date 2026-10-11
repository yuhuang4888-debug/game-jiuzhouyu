import { kfSRAwardItem } from "./kfSRAwardItem"

export class kfSRAwardItemB extends kfSRAwardItem {
	public WIDTH= kfSRAwardItem.width
	public HEIGT = kfSRAwardItem.height

	public constructor(parent) {
		super(parent)
		this.scaleValue=76
		//this.SetScale(76 / 92)
	}
}
window["kfSRAwardItemB"] = kfSRAwardItemB