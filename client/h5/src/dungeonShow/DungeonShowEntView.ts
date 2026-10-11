import { OpenMode } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonShowView } from "./DungeonShowView"

export class DungeonShowEntView extends BaseWindowComponent {
  _model
  bg_list
  change_scene_close
  money_list
  open_mode
  tabStrList
  titleStr
  viewClassList

  public constructor() {
    super()


    this.dependent_res = ["dungeonShow"]
    this.tabStrList = [{ label: "多倍奖励", effect: { source: "ui_activity" } }, { label: "双倍奖励", effect:{ source: "ui_activity" } }]
    this.viewClassList = ["DungeonShowView", "DungeonShowView"]
    this.titleStr = "dungeonShow_asset.title"
    this.bg_list = ["uisbjy_04.jpg", "uisbjy_05.jpg"]
    this.money_list = [2, 1, 0]
    this.change_scene_close = true
    this.open_mode = OpenMode.OpenToggle
    this._model = BaseDungeonModel.GetInstance()
  }
}
window["DungeonShowEntView"]=DungeonShowEntView