import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"

export class GuildGiftItem extends BaseItemRenderer {
  _group_item
  award_item
  //弃用
  public constructor(parent) {
    super()


    // this.base_file = "guild"
    // this.layout_file = "GuildGiftItemExml"
    //this.skinName = "resource/game/guild/exml/GuildGiftItemExml.exml"
  }

  public createChildren() {

    super.createChildren()
    this.award_item = new BaseAwardItem(this._group_item)
    this.award_item.Load()
    this.award_item.SetItemSize(96, 96)
  }

  public DeleteMe() {

    if (this.award_item) {
      this.award_item.DeleteMe()
      this.award_item = null
    }
    super.DeleteMe()
  }

  public dataChanged() {

    if (! super.dataChanged()) {
      return
    }
    let data = this.data
    let type_id = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
    this.award_item.SetData(type_id, data[2])
  }


}

window["GuildGiftItem"] = GuildGiftItem