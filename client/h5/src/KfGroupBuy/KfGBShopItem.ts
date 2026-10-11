import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";

// TypeScript file
export class KfGBShopItem extends BaseItemRenderer {
    public WIDTH = 95
    public HEIGT = 95
    item
    local_CustomActivityModel
    local_GoodsModel
    local_ResManager
    

    public constructor() {
        super()
        this.base_file = "kfGroupBuy"
        this.layout_file = "KfGBShopItem"
        this.item = null
        this.local_CustomActivityModel = CustomActivityModel.GetInstance()
        this.local_GoodsModel = GoodsModel.GetInstance()
        this.local_ResManager = ResManager.GetInstance()
        this.Load()
    }

    public load_callback(){
        ResManager.GetInstance().SetOutsideImageSprite(this, this.img_select, GameResPath.GetIconOtherPath("kfGroupBuy", "com_selectbg"), false)
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let model = this.local_CustomActivityModel
            let data = this.data
            this.lable_order_value.text = this.index + 1
            let base_type = data.base_type
            let sub_type = data.sub_type
            if (data) {
                let reward = model.GetActReward(base_type, sub_type, data.form_type, data.reward)
                if (reward && reward[0]) {
                    let [typeId, lock] = this.local_GoodsModel.GetMappingTypeId(reward[0][0], reward[0][1])
                    if (!this.item) {
                        this.item = new EquipmentItem(this._gp_item)
                        this.item.Load()
                        this.item.SetItemSize(85, 85)
                    }
                    this.item.ExcuteCallback(() => {
                        this.item.SetData(typeId, reward[0][2], lock)
                    })
                }

                let select_bg = this.selected ? true : false
                this.img_select.visible = select_bg
                let cond = model.GetActCondition(base_type, sub_type, "data", data.grade)
                if (!cond) return
                let rare = cond.rare
                let url = rare == 1 ? `ui_kftg_10` : `ui_kftg_11`
                this._title0.visible = rare
                this.local_ResManager.SetOutsideImageSprite(this, this._title0, GameResPath.GetIconOtherPath("kfGroupBuy", url), false)
                let is_buy = data.is_buy
                let goods = data.goods
                let url_2 = !is_buy && goods && (goods.first_buy_count - goods.tail_buy_count) <= 0 ? `ui_kftg_13` : `ui_kftg_12`
                this.local_ResManager.SetOutsideImageSprite(this, this.title1, GameResPath.GetIconOtherPath("kfGroupBuy", url_2), false)
                this.title1.visible = goods && goods.first_buy_count
                this._red.visible = !is_buy && goods && (goods.first_buy_count - goods.tail_buy_count) > 0
            }
        }
    }
    

    public DeleteMe() {
        if (this.item) {
            this.item.DeleteMe()
            this.item = null
        }
        super.DeleteMe()
    }

    _gp_item: Laya.Box;
    _select: Laya.Image;
    _title0: Laya.Image;
    title1: Laya.Image;
    _red: Laya.Image;
    lable_order_value: Laya.Label;
    img_select: Laya.Image;
    
    public GetComponents() {
        [
            this._gp_item,
            this._select,
            this._title0,
            this.title1,
            this._red,
            this.lable_order_value,
            this.img_select,
        ]
        = this.GetChildrenByNames([
            "_gp_item",
            "_select",
            "_title0",
            "title1",
            "_red",
            "lable_order_value",
            "img_select",
        ])
    }
}
window["KfGBShopItem"] = KfGBShopItem
