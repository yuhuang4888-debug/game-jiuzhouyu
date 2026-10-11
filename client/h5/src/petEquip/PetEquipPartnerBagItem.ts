import { PetEquipType } from "../commonModel/PetEquipDefine";
import { PetEquipBagItem } from "./PetEquipBagItem";

export class PetEquipPartnerBagItem extends PetEquipBagItem {
	public constructor() {
		super()
		this.WIDTH=87
		this.HEIGT=87
		this._type = PetEquipType.PARTNER;
	}
}

window["PetEquipPartnerBagItem"] = PetEquipPartnerBagItem