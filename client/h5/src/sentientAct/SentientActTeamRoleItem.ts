import { BaseItem1 } from "../common/BaseItem1"
import { SentientActModel } from "../commonModel/SentientActModel"
import { DungeonEquipRoleItem } from "../dungeonEquip/DungeonEquipRoleItem"

export class SentientActTeamRoleItem extends DungeonEquipRoleItem {

	public constructor(parent?) {
		super(parent)

		this.base_file = "sentientAct"
		this.layout_file = "SentientActTeamRoleItem"
		this.dungeon_id = SentientActModel.GetInstance().dungeon_id

	}



}
window["SentientActTeamRoleItem"] = SentientActTeamRoleItem