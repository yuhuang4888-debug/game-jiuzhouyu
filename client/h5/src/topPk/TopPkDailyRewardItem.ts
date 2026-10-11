import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SevenDayModel } from "../commonModel/SevenDayModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class TopPkDailyRewardItem extends BaseItemRenderer {
    _Image1: Laya.Image
    _lb_level_name: Laya.Label
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    _gp_btn: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    _Image3: Laya.Image
    _img_received: Laya.Image
    Emp_gp_btn
    _gp_reward_con
    item_list
    model
    parent_mask_corners
    parent_wnd
    WIDTH = 575
    HEIGT = 130
    public constructor(parent) {
        super()


        this.model = TopPkModel.GetInstance()
        this.base_file = "topPk"
        this.layout_file = "TopPkDailyRewardItem"
        this.load_callback = () => {
            this._Scroller1.hScrollBar.visible = false
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("topPk", "ui_activity_02"))
            Util.AddClickEvent(this._gp_btn, () => {
                let daily_reward_data = this.model.daily_reward_data
                if (daily_reward_data) {
                    if (this.data.rank_lv == daily_reward_data.yesterday_rank_lv && daily_reward_data.honor_is_got == 1) {
                        this.model.Fire(TopPkModel.REQUEST_SCMD, 28102)
                    }
                }
            }
                , this, true)
            this.BindVar(this.model, "daily_reward_data", () => {
                this.dataChanged()
            }
            )
            // this.RegisterMask(this._gp_reward_con, 2)
            //this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect)).transform.Find("_list_item_con"))
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
            //     this._lb_level_name.size = 17
            //     let csf = this._lb_level_name.GetComponent("ContentSizeFitter")
            //     csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            //     SetSizeDeltaX(this._lb_level_name, 115)
            //     SetAnchoredPositionX(this._lb_level_name, -229)
            //     SetAnchoredPositionY(this._lb_level_name, -47)
            // }
        }
        this.Load()
    }



    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data == null) { return }
            let data = this.data
            let daily_reward_data = this.model.daily_reward_data
            if (daily_reward_data) {
                if (data.rank_lv == daily_reward_data.yesterday_rank_lv) {
                    this._img_received.visible = daily_reward_data.honor_is_got == 0
                    this._gp_btn.visible = daily_reward_data.honor_is_got == 1
                } else {
                    this._gp_btn.visible = false
                    this._img_received.visible = false
                }
            }
            this._lb_level_name.text = data.rank_name
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            let reward_ = open_day > 15 && data.day_reward || data.local_day_reward
            let reward = JSON.parse(reward_)
            if (!this.item_list) {
                this.item_list = []
            }
            if (this.item_list && this.item_list.length > reward.length) {
                let i = reward.length + 1
                do {
                    //this.item_list[i].includeInLayout = false
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
            this._lb_level_name,
            this._Scroller1,
            this.Content,
            this._gp_btn,
            this._Image2,
            this._Label1,
            this._Image3,
            this._img_received,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_lb_level_name",
                "_Scroller1",
                "Content",
                "_gp_btn",
                "_Image2",
                "_Label1",
                "_Image3",
                "_img_received",
            ])
    }
}
window["TopPkDailyRewardItem"] = TopPkDailyRewardItem