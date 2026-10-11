import { PetEquipType } from "../commonModel/PetEquipDefine";
import { PetEquipBagItem } from "./PetEquipBagItem";

export class PetEquipHorseBagItem extends PetEquipBagItem {
	public constructor() {
		super()
		this.HEIGT=87
		this.WIDTH=87
		this._type = PetEquipType.HORSE;
	}
}

window["PetEquipHorseBagItem"] = PetEquipHorseBagItem