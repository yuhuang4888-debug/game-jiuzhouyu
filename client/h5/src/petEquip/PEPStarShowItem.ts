import { PetEquipType } from "../commonModel/PetEquipDefine"
import { APetEquipShowItem } from "./APetEquipShowItem"
export class PEPStarShowItem extends APetEquipShowItem {

	public constructor() {
		super()
		this._type = PetEquipType.PARTNER
		this._red_type = 3
	}
}
window["PEPStarShowItem"]=PEPStarShowItem