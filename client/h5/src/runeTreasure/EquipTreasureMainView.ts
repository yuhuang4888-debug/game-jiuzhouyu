import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { ATreasureBaseView } from "./ATreasureBaseView"

export class EquipTreasureMainView extends ATreasureBaseView {
    public constructor(parent) {
        super(parent)
        this.treasure_type = RuneTreasureModel.EQUIP_TREASURE_TYPE
        this.treasure_ticket = RuneTreasureModel.EQUIP_TREASURE_TICKET
        this.treasure_show_alert = RuneTreasureModel.show_equip_cost_alert
        // this.bg_url = "resource/game/runeTreasure/texture/rt_bg1.png"
        // this.win_url = "resource/game/runeTreasure/texture/rt_winbg1.png"
        this.type = `a`
    }

    //第一次添加到舞台的时候调用
    public  createChildren() {
        let self = this
        self.story_obj_list = self.story_obj_list || {
        }
        // if (self.task_model.newest_finish_task_id >= RuneTreasureModel.RUNE_TREASURE_TASK_ID) {

        // } else {
            self.story_obj_list[TaskTipType.Rune_treasure] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
        // }
        super.createChildren()
    }

}

window["EquipTreasureMainView"] = EquipTreasureMainView