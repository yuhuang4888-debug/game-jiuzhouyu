import { kfSRAwardItem } from "./kfSRAwardItem"

export class kfSRAwardItemC extends kfSRAwardItem {
	public WIDTH= kfSRAwardItem.width
	public HEIGT = kfSRAwardItem.height
	
	public constructor(parent) {
		super(parent)
		this.scaleValue=69

	}
}

window["kfSRAwardItemC"] = kfSRAwardItemC