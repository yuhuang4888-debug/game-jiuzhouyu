import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"

export class SeaGuildRewardItem extends BaseItemRenderer {

    public WIDTH: number = 585
    public HEIGT: number = 120
    itemList
    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaGuildRewardItem"

        this.load_callback = () => {
            this._cur_tag.visible = false
            //this._Scroller1.hScrollBarSkin = ""

        }
        this.Load()
    }


    public dataChanged() {
        if (!super.dataChanged()) return
        if (!this.itemList) {
            this.itemList = []
        }
        let rewardCfg =JSON.parse(this.data.reward)
        let i = 0
        do {
            let vo = rewardCfg[i]
            let item: BaseAwardItem = this.itemList[i]
            if (!item) {
                item = new BaseAwardItem(this.Content)
                item.SetUseMask(true)
                item.Load()
                item.SetItemSize(87, 87)
                this.itemList[i] = item
            }
            let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
            item.SetData(type_id, vo[2])
            i = i + 1
        } while ((i < rewardCfg.length))
        let sp_name = (this.data.type == 1 && ("ui_zcjl_js01") || ("ui_zcjl_js02"))
        ResManager.GetInstance().SetImageSprite(this, this.statusImg, "seaHegemony", sp_name, true)
    }

    public DeleteMe() {

        if (this.itemList) {
            for (let _tmpi in this.itemList) {
                var vo = this.itemList[_tmpi]
                vo.DeleteMe()
            }
            this.itemList = null
        }
        super.DeleteMe()
    }


    bg: Laya.Image
    statusImg: Laya.Image
    _cur_tag: Laya.Box
    _cur_img: Laya.Image
    _cur_lb: Laya.Label
    _Scroller1: Laya.Panel
    Content: Laya.HBox
    public GetComponents() {
        [
            this.bg,
            this.statusImg,
            this._cur_tag,
            this._cur_img,
            this._cur_lb,
            this._Scroller1,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "bg",
                "statusImg",
                "_cur_tag",
                "_cur_img",
                "_cur_lb",
                "_Scroller1",
                "Content",
            ])
    }
}
window["SeaGuildRewardItem"] = SeaGuildRewardItem