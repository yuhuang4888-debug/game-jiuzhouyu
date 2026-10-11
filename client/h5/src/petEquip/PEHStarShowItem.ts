import { PetEquipType } from "../commonModel/PetEquipDefine"
import { APetEquipShowItem } from "./APetEquipShowItem"

export class PEHStarShowItem extends APetEquipShowItem {
	public constructor() {
		super()
		this._type = PetEquipType.HORSE
		this._red_type = 3
	}
}
window["PEHStarShowItem"]=PEHStarShowItem