import { PetEquipWholeType } from "../commonModel/PetEquipDefine";
import { PetEquipMasterView } from "./PetEquipMasterView";

export class PetEquipStrenMasterView extends PetEquipMasterView {
	protected _str_1 = "强化大师";
	protected _str_2 = "当前全身强化等级";
	protected _str_3 = "强化总等级";
	protected _wtype = PetEquipWholeType.STREN;

	public constructor() {
		super()
	}

}
window["PetEquipStrenMasterView"]=PetEquipStrenMasterView