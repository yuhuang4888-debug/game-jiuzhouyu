import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { DungeonEquipClumpApplyItem } from "../dungeonEquip/DungeonEquipClumpApplyItem"
import { Util } from "../util/Util"

export class SentientActTeamApplyItem extends DungeonEquipClumpApplyItem {
    role_head
    public WIDTH = 576
    public HEIGT = 104
    is_set
    public constructor(parent) {
        super(parent)
        this.base_file = "sentientAct"
        this.layout_file = "SentientActTeamApplyItem"

        
    }

}
window["SentientActTeamApplyItem"] = SentientActTeamApplyItem