import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class GuildFightWiningRewardItem extends BaseItemRenderer {

    item_list
    InitEvent
    public WIDTH = 620
    public HEIGT = 150
    is_set
    public constructor(parent) {
        super()
        this.is_set = false
        this.item_list = []
        this.base_file = "guildFight"
        this.layout_file = "GuildFightWiningRewardItem"

        this.load_callback = () => {
            this.scroll.hScrollBarSkin=""
            this.InitEvent()
            if (!this.is_set) {
                this.is_set = true
                this.SetData()
            }
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.btn, () => {
                    if (this.data.win_state == 1) {
                        if (RoleManager.GetInstance().GetMainRoleVo().position == 1) {
                            GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_OPEN_VIEW, "GuildFightDistributionView")
                        } else {
                            Message.show("只有会长可以分配")
                        }
                    }
                },
                this,
                true
            )
        }

        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        if (this.is_loaded) {
            this.is_set = true
            this.SetData()
        } else {
            this.is_set = false
        }
    }
    public SetData() {

        if (!this.data) { return }

        if (this.data.win_reward) {

            if (this.item_list) {
                for (let i = 0; i < this.item_list.length; i++) {
                    this.item_list[i].SetVisible(false)
                }
            }

            let i = 0
            do {
                let item: BaseAwardItem = this.item_list[i]
                if (!item) {
                    item = new BaseAwardItem(this.Content)
                    item.SetUseMask(true)
                    item.Load()
                    item.SetScale(0.9)
                    this.item_list[i] = item
                }
                if (item) {
                    item.SetVisible(true)
                    let type_id, lock
                    [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.win_reward[i][0], this.data.win_reward[i][1])
                    let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id, this.data.win_reward[i][2], lock)
                    } else {
                        //Laya:log("goodsVo is null type_id:" + type_id)
                    }
                }
                i = i + 1
            } while ((i < this.data.win_reward.length))
        }
        this.title.text = this.data.time + "连胜奖励"
        // if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
        //     this.title.text = "รางวัลชนะรวด" + this.data.time
        // }
        if (this.data.win_state == 1) {
            this.labelDisplay.text = "可分配"
            //this.title.color = ColorUtil.TryParseHtmlString(ColorUtil.GetColorLight(ColorType.ORANGE))
            Util.SetImageGray(this._Image11, false)
            this.btn.visible = true
        }
        else if (this.data.win_state == 0) {
            this.btn.visible = false
            //this.title.color = ColorUtil.TryParseHtmlString(ColorUtil.GetColorLight(ColorType.WHITE))
            Util.SetImageGray(this._Image11, true)
        }
        else if (this.data.win_state == 2) {
            this.btn.visible = false
            this.labelDisplay.text = "已分配"
            //this.title.color = ColorUtil.TryParseHtmlString(ColorUtil.GetColorLight(ColorType.WHITE))
            Util.SetImageGray(this._Image11, true)
        }
    }

    public DeleteMe() {

        if (this.item_list) {
            for (let i = 0; i < this.item_list.length; i++) {
                this.item_list[i].DeleteMe()
            }
        }
        this.item_list = []
        super.DeleteMe()
    }



_Image1:Laya.Image
title:Laya.Label
btn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
scroll:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this._Image1,
this.title,
this.btn,
this._Image11,
this.labelDisplay,
this.scroll,
this.Content,
]
 = this.GetChildrenByNames([

"_Image1",
"title",
"btn",
"_Image11",
"labelDisplay",
"scroll",
"Content",
])
}
}
 window["GuildFightWiningRewardItem"]= GuildFightWiningRewardItem