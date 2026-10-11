import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Util } from "../util/Util"

export class CountryPayItem extends BaseItemRenderer {

    public WIDTH: number = 613
    public HEIGT: number = 105
    model
    rewardList
    public constructor(parent) {
        super()

        this.base_file = "country"
        this.layout_file = "CountryPayItem"

        this.model = SeaHegemonyModel.GetInstance()
        this.load_callback = () => {

            this.InitEvent()
        }
        this.Load()
    }

    public InitEvent() {

        Util.AddClickEvent(
            this.getBtn, () => {
                this.model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18621)
            },
            this,
            true
        )
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        let sp_name = "ui_shzb_08" + this.data.level + ""
        ResManager.GetInstance().SetImageSprite(this, this.nameImg, "country_asset", sp_name, true)
        if (!this.rewardList) {
            this.rewardList = []
        }
        let rewardData =JSON.parse(this.data.normal)
        let i = 0
        do {
            let vo = rewardData[i]
            let item: BaseAwardItem = this.rewardList[i]
            if (!item) {
                item = new BaseAwardItem(this.rewardGp)
                item.SetUseMask(true)
                item.Load()
                item.SetItemSize(69, 69)
                this.rewardList[i] = item
            }
            let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
            item.SetData(type_id, vo[2])
            i = i + 1
        } while ((i < rewardData.length))
        let curLv = this.model.showRewardType == this.data.level
        this.getBtn.visible = curLv
        if (curLv) {
            let status = this.model.seaHegemonyData.reward_status
            // [ts2lua]lua中0和空字符串也是true，此处status == 1需要确认
            this.labelDisplay.text = (status == 1 && ("已领取") || ("领取"))
            this.getRed.visible = status == 0
            Util.SetImageGray(this._Image1, status == 1)
            this.labelDisplay.gray=status == 1
        } else {
            this.getRed.visible = false
        }
    }

    public DeleteMe() {

        if (this.rewardList) {
            for (let _tmpi in this.rewardList) {
                var vo = this.rewardList[_tmpi]
                vo.DeleteMe()
            }
            this.rewardList = null
        }

        super.DeleteMe()
    }


    _Image11: Laya.Image
    getBtn: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    nameImg: Laya.Image
    _Scroller1: Laya.Box
    rewardGp: Laya.HBox
    getRed: Laya.Image
    public GetComponents() {
        [
            this._Image11,
            this.getBtn,
            this._Image1,
            this.labelDisplay,
            this.nameImg,
            this._Scroller1,
            this.rewardGp,
            this.getRed,
        ]
            = this.GetChildrenByNames([

                "_Image11",
                "getBtn",
                "_Image1",
                "labelDisplay",
                "nameImg",
                "_Scroller1",
                "rewardGp",
                "getRed",
            ])
    }
}
window["CountryPayItem"] = CountryPayItem