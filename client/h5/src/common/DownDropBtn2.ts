import { DownDropBtn } from "./DownDropBtn"

export class DownDropBtn2 extends DownDropBtn {
	resType

	public constructor(parent) {
		super(parent)
		this.base_file = "common"
		this.layout_file = "DownDropBtn2"
		this.resType = 2
	}
}

window["DownDropBtn2"] = DownDropBtn2