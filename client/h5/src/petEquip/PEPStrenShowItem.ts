import { PetEquipType } from "../commonModel/PetEquipDefine"
import { APetEquipShowItem } from "./APetEquipShowItem"

export class PEPStrenShowItem extends APetEquipShowItem {

	public constructor() {
		super()
		this._type = PetEquipType.PARTNER
		this._red_type = 2
	}
}
window["PEPStrenShowItem"]=PEPStrenShowItem