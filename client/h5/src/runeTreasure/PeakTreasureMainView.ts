import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { ATreasureBaseView } from "./ATreasureBaseView"

export class PeakTreasureMainView extends ATreasureBaseView{
    public constructor(parent){
        super(parent)
        this.treasure_type = RuneTreasureModel.PEAK_TREASURE_TYPE
        this.treasure_ticket = RuneTreasureModel.PEAK_TREASURE_TICKET
        this.treasure_show_alert = RuneTreasureModel.show_peak_cost_alert
        // this.bg_url = "resource/game/runeTreasure/texture/rt_bg2.png"
        // this.win_url = "resource/game/runeTreasure/texture/rt_winbg2.png"
        this.type = `b`
    }
}

window["PeakTreasureMainView"] = PeakTreasureMainView
