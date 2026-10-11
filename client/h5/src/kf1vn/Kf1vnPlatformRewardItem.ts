import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"

export class Kf1vnPlatformRewardItem extends BaseItemRenderer {

  model
  item_list
  GetDefendNumByTurn
  public WIDTH = 615
  public HEIGT = 120

  public constructor(parent) {
    super()

    this.base_file = "kf1vn"
    this.layout_file = "Kf1vnPlatformRewardItem"
    this.model = Kf1vnModel.GetInstance()
    this.item_list = []

    this.GetDefendNumByTurn = (turn?) => {
      let num = 0
      let config_kf_1vn_match=ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_match",false)
      if (config_kf_1vn_match) {
        let cfg = config_kf_1vn_match[turn]
        num = (config_kf_1vn_match[turn] && (config_kf_1vn_match[turn].c_num) || (0))
      }
      return num
    }
  


    this.Load()
  }

  public load_callback() {
    //this._Scroller1.hScrollBarSkin=""
    this.InitEvents()
  }

  public InitEvents() {


  }

  public dataChanged() {
    if(!super.dataChanged())return
    if (this.data) {
      if (this.data["type"] == 1) {
        let num = this.GetDefendNumByTurn(this.data.turn)
        let style = (this.data.is_win == 1 && ("胜利") || ("失败"))
        this.title.text = `1v${num}${style}\n奖励`
      } else {
        let style = (this.data.is_win == 1 && ("胜利") || ("失败"))
        this.title.text = `挑战者${style}\n奖励`
      }
      let item:BaseAwardItem = null
      let list = this.data.reward
      let i = 0
      do {
        item = this.item_list[i]
        if (!item) {
          item= new BaseAwardItem(this.Content)
          this.item_list[i] = item
          item.Load()
          item.SetItemSize(90, 90)
        }
        item.SetVisible(true)
        let[ type_id, lock ]= GoodsModel.GetInstance().GetMappingTypeId(list[i][0], list[i][1])
        item.SetData(type_id, list[i][2])
        i = i + 1
      } while ((i < list.length))
      if (this.item_list.length > list.length) {
        let i = list.length
        do {
          if (this.item_list[i]) {
            this.item_list[i].SetVisible(false)
          }
          i = i + 1
        } while ((i < this.item_list.length))
      }
    }
  }

  public DeleteMe() {

    if (this.item_list) {
      for (let _tmpi in this.item_list) {
        var item = this.item_list[_tmpi]
        item.DeleteMe()
      }
      this.item_list = null
    }
    super.DeleteMe()
  }



_Image1:Laya.Image
title:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this._Image1,
this.title,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"_Image1",
"title",
"_Scroller1",
"Content",
])
}
}
 window["Kf1vnPlatformRewardItem"]= Kf1vnPlatformRewardItem