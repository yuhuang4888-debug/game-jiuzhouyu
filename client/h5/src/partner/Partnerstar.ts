import { BaseItem1 } from "../common/BaseItem1"

export class Partnerstar extends BaseItem1 {
	star_bg: Laya.Image
	star: Laya.Image
	public constructor(parent) {
		super(parent)

		this.base_file = "partner"
		this.layout_file = "Partnerstar"
	}

	public SetDate(index?, info?) {
		let is_star = index <= info.star && info.is_active == 1
		this.star.visible = is_star
	}


	public GetComponents() {
		[
			this.star_bg,
			this.star,
		]
			= this.GetChildrenByNames([

				"star_bg",
				"star",
			])
	}
}
window["Partnerstar"] = Partnerstar