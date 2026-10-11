import { PetEquipType } from "../commonModel/PetEquipDefine"
import { APetEquipShowItem } from "./APetEquipShowItem"

export class PEHStrenShowItem extends APetEquipShowItem {

	public constructor() {
		super()

		this._type = PetEquipType.HORSE
		this._red_type = 2
	}
}
window["PEHStrenShowItem"]=PEHStrenShowItem