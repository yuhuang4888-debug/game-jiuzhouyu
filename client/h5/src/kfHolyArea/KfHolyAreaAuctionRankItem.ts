import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel";
import { ResManager } from "../common/ResManager";
export class KfHolyAreaAuctionRankItem extends BaseItemRenderer {
  model
  public constructor() {
    super()


    this.model = KfHolyAreaModel.GetInstance();
    this.base_file = "kfHolyArea"
    this.layout_file = "KfHolyAreaAuctionRankView"
  }

  public createChildren() {
    this.InitEvent()
    super.createChildren()

  }

  public InitEvent() {
  }
  public dataChanged() {

    if (! super.dataChanged()) {
      return
    }
    let data = this.data
    if (data.rank < 4) {
      this.rank_img.visible = true
      this.rank_lb.visible = false
    } else {
      this.rank_img.visible = false
      this.rank_lb.visible = true
    }
    if (1 == data.rank) {
      ResManager.GetInstance().SetImageSprite(this, this.rank_img, "common_asset", "uijjsh_006a", true)
    }
    else if (2 == data.rank) {
      ResManager.GetInstance().SetImageSprite(this, this.rank_img, "common_asset", "uijjsh_006b", true)
    }
    else if (3 == data.rank) {
      ResManager.GetInstance().SetImageSprite(this, this.rank_img, "common_asset", "uijjsh_006c", true)
    }
    else if ("default" == data.rank) {
      this.rank_lb.text = String(data.rank)
    }
    this.name_lb.text = "S" + data.server_num + "." + data.role_name
    this.contribution_lb.text = data.total_point
  }

  bg_img: Laya.Image
  _Group1: Laya.Box
  rank_img: Laya.Image
  rank_lb: Laya.Label
  name_lb: Laya.Label
  _Group2: Laya.Box
  title_gp: Laya.Box
  medal_img: Laya.Image
  contribution_lb: Laya.Label
  public GetComponents() {
    [
      this.bg_img,
      this._Group1,
      this.rank_img,
      this.rank_lb,
      this.name_lb,
      this._Group2,
      this.title_gp,
      this.medal_img,
      this.contribution_lb,
    ]
      = this.GetChildrenByNames([

        "bg_img",
        "_Group1",
        "rank_img",
        "rank_lb",
        "name_lb",
        "_Group2",
        "title_gp",
        "medal_img",
        "contribution_lb",
      ])
  }
}
window["KfHolyAreaAuctionRankItem"] = KfHolyAreaAuctionRankItem