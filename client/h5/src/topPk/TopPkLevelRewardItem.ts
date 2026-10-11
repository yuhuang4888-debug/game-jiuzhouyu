import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class TopPkLevelRewardItem extends BaseItemRenderer {
    Scr_Scroller1
    item_list
    model
    parent_mask_corners
    WIDTH = 575
    HEIGT = 130
    public constructor(parent) {
        super()


        this.model = TopPkModel.GetInstance()
        this.base_file = "topPk"
        this.layout_file = "TopPkLevelRewardItem"
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("topPk", "ui_activity_02"))
            Util.AddClickEvent(this._gp_btn, () => {
                if (this.data && this.data.state == 2) {
                    this.model.Fire(TopPkModel.REQUEST_SCMD, 28106, this.data.rank_lv)
                }
            }
                , this, true)
            // this.RegisterMask(this._gp_reward_con,2)
            // //this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect)).transform.Find("_list_item_con"))
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 	this._lb_level_name.size  = 17
            // 	let csf = this._lb_level_name.GetComponent("ContentSizeFitter")
            // 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
            // 	SetSizeDeltaX(this._lb_level_name,115)
            // 	SetAnchoredPositionX(this._lb_level_name,-229)
            // 	SetAnchoredPositionY(this._lb_level_name,-47)
            // }
        }
        this.Load()
    }


    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data == null) { return }
            let data = this.data
            this._gp_btn.visible = this.data.state == 2
            this._img_received.visible = data.state == 0
            this._lb_point.visible = false
            let top_pk_rank_reward_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_top_pk_rank_reward", false)
            let level_cfg = this.model.GetLevelCfg(data.rank_lv, top_pk_rank_reward_cfg)
            if (level_cfg) {
                this._lb_level_name.text = level_cfg.rank_name
                let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
                let reward_ = open_day > 15 && level_cfg.stage_reward || level_cfg.local_stage_reward
                let reward = JSON.parse(reward_)
                if (this.item_list) {
                    for (let _tmpi in this.item_list) {
                        var obj = this.item_list[_tmpi]
                        obj.DeleteMe()
                    }
                    this.item_list = null
                }
                if (!this.item_list) {
                    this.item_list = []
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
                        //item:SetUseMask(true)
                        // item.SetMaskId(2)				
                        // item.SetMaskRect(this.mask_corners)
                        // [ts2lua]this.item_list下标访问可能不正确
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
                // if (this.item_list && this.item_list.length > reward.length) {
                //     let i = reward.length
                //     for (let i = reward.length; i < this.item_list.length; i++) {
                //         this.item_list[i].SetVisible(false)
                //     }

                // }
                // this.Content.refresh()
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


_Image1:Laya.Image
_lb_level_name:Laya.Label
_Scroller1:Laya.Box
Content:Laya.HBox
_gp_btn:Laya.Box
_Image2:Laya.Image
_Label1:Laya.Label
_Image3:Laya.Image
_img_received:Laya.Image
_lb_point:Laya.Label
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
this._lb_point,
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
"_lb_point",
])
}
}
 window["TopPkLevelRewardItem"]= TopPkLevelRewardItem