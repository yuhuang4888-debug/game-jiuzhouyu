import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class SeaAssertRankTab extends BaseItemRenderer {

    WIDTH = 140
    HEIGT = 52

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertRankTab"

        this.load_callback = () => {
            this.InitEvent();
            //this:LoadSuccess()
        }

        this.Load();
    }

    public InitEvent() {
        Util.AddClickEvent(this.tabBox, () => {
            SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.ASSERT_RANK_TAB, this.index)
        }, this)
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    public dataChanged() {
        if (super.dataChanged()) {
            this._lb_naem.text = this.data.name
            this._lb_naem.color = this.selected ? '#FFFFFF' : '#4F538F';
            this._lb_naem.stroke = 2;
            this._lb_naem.strokeColor = this.selected ? '#AD455C' : '#C6C3F4';
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon('topPk', this.selected ? "ui_phb_006" : "ui_phb_005"));
        }
    }



    tabBox: Laya.Box
    _Image1: Laya.Image
    _lb_naem: Laya.Label
    public GetComponents() {
        [
            this.tabBox,
            this._Image1,
            this._lb_naem,
        ]
            = this.GetChildrenByNames([

                "tabBox",
                "_Image1",
                "_lb_naem",
            ])
    }
}
window["SeaAssertRankTab"] = SeaAssertRankTab