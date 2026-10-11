import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { SecretTreasureMainViewIndex } from "../commonModel/LungModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class GodBeastStrenBaseView extends BaseWindowComponent {
  public constructor() {
      super()
      this.destroy_imm = true
      this.append_to_ctl_queue = true
      this.dependent_res = ["godBeast"]
      this.viewClassList = ["GodBeastStrenView"]
      this.titleStr = "godBeast_json.uiss_001_png"
      // this.bg_list = { "0": "uiss_002_720x1222.jpg" }
       
      this.tabStrList = [
          { label: "强化", icon_up_source: "godBeast_json.uiss_020_r1_c2_png", icon_down_source: "godBeast_json.uiss_020_r1_c1_png" },
      ];

      this.window_load_back = function () {
          let is_show = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_STREN)
          GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "GodBeastStrenBaseView", 0, is_show)
      }

  }

  public BaseWindowCloseFunc() {
      GlobalEventSystem.Fire(EventName.OPEN_VIEW,"SecretTreasureMainView", SecretTreasureMainViewIndex.GodBeast)
      // GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
      super.BaseWindowCloseFunc()
  }
}
window["GodBeastStrenBaseView"] = GodBeastStrenBaseView