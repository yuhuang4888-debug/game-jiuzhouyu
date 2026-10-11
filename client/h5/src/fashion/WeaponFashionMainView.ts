import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { FashionModel } from "../commonModel/FashionModel";
import { RoleManager } from "../commonModel/RoleManager";
import { FashionMainView } from "./FashionMainView";

export class WeaponFashionMainView extends FashionMainView {
	_color
	_res
	fashion_pos_id

	public constructor(parent?) {
		super(parent)

		// this.fashion_pos_id = FashionModel.FashionType.Weapon;
		this._res = 0
		this._color = 0
	}
}
window["WeaponFashionMainView"] = WeaponFashionMainView