import { PetEquipWholeType } from "../commonModel/PetEquipDefine"
import { PetEquipMasterView } from "./PetEquipMasterView"

export class PetEquipStarMasterView extends PetEquipMasterView {
	protected _str_1 = "星数大师";
	protected _str_2 = "当前全身装备星数";
	protected _str_3 = "总星数";
	protected _wtype = PetEquipWholeType.STAR;
	public constructor() {
		super()
	}
}
window["PetEquipStarMasterView"]=PetEquipStarMasterView