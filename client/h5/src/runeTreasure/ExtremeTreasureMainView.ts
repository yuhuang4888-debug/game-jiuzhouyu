import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { ATreasureBaseView } from "./ATreasureBaseView"

export class ExtremeTreasureMainView extends ATreasureBaseView {
    public constructor(parent) {
        super(parent)
        this.treasure_type = RuneTreasureModel.EXTREME_TREASURE_TYPE
        this.treasure_ticket = RuneTreasureModel.EXTREME_TREASURE_TICKET
        this.treasure_show_alert = RuneTreasureModel.show_extreme_cost_alert
        // this.bg_url = "resource/game/runeTreasure/texture/rt_bg3.png"
        // this.win_url = "resource/game/runeTreasure/texture/rt_winbg3.png"
        this.type = `c`
    }
}

window["ExtremeTreasureMainView"] = ExtremeTreasureMainView
