import { FashionModel } from "../commonModel/FashionModel";
import { FashionMainView } from "./FashionMainView";

export class HeadFashionMainView extends FashionMainView {
	_color
	_res
	fashion_pos_id

	public constructor(parent?) {
		super(parent)

		this.fashion_pos_id = FashionModel.FashionType.Head;
		this._res = 0
		this._color = 0
	}
}
window["HeadFashionMainView"]=HeadFashionMainView