import { PetEquipWholeType } from "../commonModel/PetEquipDefine";
import { PetEquipMasterView } from "./PetEquipMasterView"

export class PetEquipStageMasterView extends PetEquipMasterView {
	protected _str_1 = "阶数大师";
	protected _str_2 = "当前全身装备阶数";
	protected _str_3 = "总阶数";
	protected _wtype = PetEquipWholeType.STAGE;

	public constructor() {
		super()
	}
}
window["PetEquipStageMasterView"]=PetEquipStageMasterView