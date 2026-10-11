import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { ResManager } from "../common/ResManager"
import { SetAnchoredPositionX } from "../util/Util"
import "./AdventureMainView"

export class AdventureWindowView extends BaseWindowComponent {
  Load_back
  destroy_imm
  instruction_list
  money_list
  not_show_item_use
  tabStrList
  titleStr
  viewClassList
  window_load_back

  public constructor() {
    super()


    this.viewClassList = ["AdventureMainView"]
    this.tabStrList = [{ label: "天天冒险" }]
    this.money_list = [2, 1, 0]
    this.dependent_res = ["adventure"]
    this.titleStr = "adventure.uittmx_019"
    this.not_show_item_use = true
    this.destroy_imm = true
    this.is_show_tab = false
    this.window_load_back = () => {
      this.Load_back()
    }

    this.Load_back = () => {
      ResManager.GetInstance().SetImageSprite(this, this._img_return0, "adventure_asset", "uittmx_003", true)
      // this.SetDownState(false)
    }

    if (CommonManager.GetInstance().GetInstructionState(427)) {
      this.instruction_list = [42700]
    }
  }
}
window["AdventureWindowView"] = AdventureWindowView