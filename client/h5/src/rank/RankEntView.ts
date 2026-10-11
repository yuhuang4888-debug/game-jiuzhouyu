import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { RankView } from "./RankView"
import "./RankView"

export class RankEntView extends BaseWindowComponent {
  bg_list
  tabStrList
  titleStr
  viewClassList

  public constructor() {
    super()
    this.destroy_imm=true
    this.dependent_res = ["rank"]
    this.tabStrList = [{ label: "榜单" }]
    this.viewClassList = ["RankView"]
    this.titleStr = "rank.rank_title"
    this.bg_list = ["uiphb_001.jpg"]
  }
}

window["RankEntView"] = RankEntView