import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GameResPath } from "../util/GameResPath"

export class FashionAttrItem extends BaseItem1 {
	bg: Laya.Image
	_lb_att0: Laya.Label
	_Image1: Laya.Image
	_lb_att1: Laya.Label
	name: Laya.Label
	public constructor(parent?) {
		super(parent)

		this.base_file = "fashion"
		this.layout_file = "FashionAttrItem"
		this.load_callback = () => {

		}
	}

	public SetData(...new_args) {

		let pram = new_args
		if (!pram[0]) {
			return
		}
		let value = WordManager.ConvertToPercentValue(pram[0][0], (pram[1] && (pram[1][1]) || (0)))
		this.name.text = WordManager.GetProperties(pram[0][0]) 
		this._lb_att0.text = "+"+value
		this._lb_att0.x = this.name.x + this.name.width + 8
		this._lb_att1.text = (pram[2] && ("+" + WordManager.ConvertToPercentValue(pram[2][0], pram[2][1])) || ("已满阶"))
	}



	public GetComponents() {
		[
			this.bg,
			this._lb_att0,
			this._Image1,
			this._lb_att1,
			this.name,
		]
			= this.GetChildrenByNames([

				"bg",
				"_lb_att0",
				"_Image1",
				"_lb_att1",
				"name",
			])
	}
}
window["FashionAttrItem"] = FashionAttrItem