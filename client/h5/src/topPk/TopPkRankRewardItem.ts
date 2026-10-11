import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"

export class TopPkRankRewardItem extends BaseItemRenderer {

    _Image1: Laya.Image
    _lb_rank: Laya.Label
    _img_rank: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    VHS_Scroller1
    _gp_reward_con
    item_list
    parent_mask_corners
    parent_wnd
    WIDTH = 575
    HEIGT = 130
    public constructor(parent) {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkRankRewardItem"
        this.load_callback = () => {
            this._Scroller1.hScrollBar.visible = false
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("topPk", "ui_activity_02"))
            // this.RegisterMask(this._gp_reward_con, 2)
            // this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect)).transform.Find("_list_item_con"))
        }
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data == null) { return }
            let data = this.data
            let min_rank = data.min_rank
            let max_rank = data.max_rank
            if (min_rank == max_rank) {
                this._img_rank.visible = min_rank <= 3
                this._lb_rank.visible = min_rank > 3
                if (min_rank <= 3) {
                    TopPkModel.SetRankIcon(this._img_rank, min_rank,true)
                } else {
                    this._lb_rank.text = min_rank
                }
            } else {
                this._img_rank.visible = false
                this._lb_rank.visible = true
                this._lb_rank.text = min_rank + "~" + max_rank
            }
            let reward = ErlangParser.GetInstance().Parse(data.reward)
            if (!this.item_list) {
                this.item_list = []
            }
            if (this.item_list && this.item_list.length > reward.length) {
                let i = reward.length
                do {
                    this.item_list[i].SetVisible(false)
                    i = i + 1
                } while ((i < this.item_list.length)
                )
            }

            let item = null
            for (let key in reward) {

                // [ts2lua]reward下标访问可能不正确
                let vo = reward[key]
                // [ts2lua]this.item_list下标访问可能不正确
                item = this.item_list[key]
                if (!item) {
                    item = new EquipmentItem(this.Content)
                    item.SetItemSize(87, 87)
                    this.item_list[key] = item
                    item.Load()
                }
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                if (goods_vo) {
                    item.SetData(goods_vo.type_id, vo[2], lock)
                }
                item.SetVisible(true)
            }
        }
    }

    public DeleteMe() {

        if (this.item_list) {
            for (let _tmpi in this.item_list) {
                var obj = this.item_list[_tmpi]
                obj.DeleteMe()
            }
            this.item_list = null
        }
        super.DeleteMe()
    }



    public GetComponents() {
        [
            this._Image1,
            this._lb_rank,
            this._img_rank,
            this._Scroller1,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_lb_rank",
                "_img_rank",
                "_Scroller1",
                "Content",
            ])
    }
}
window["TopPkRankRewardItem"] = TopPkRankRewardItem