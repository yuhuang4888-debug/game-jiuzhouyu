import { RuneIcon } from "./RuneIcon"

export class RuneSpIcon extends RuneIcon {

	public constructor(parent?) {
		super(parent)
		this.base_file = "rune"
		this.layout_file = "RuneSpIcon"
	}
}
window["RuneSpIcon"] = RuneSpIcon