import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"

export class SeaAppointTab extends BaseItemRenderer {

    public WIDTH: number = 157
    public HEIGT: number = 69

    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaAppointTab"
        this.load_callback = () => {

            this.InitEvent()
        }

        this.Load()
    }

    public InitEvent() {

        this.BindEvent(
            SeaHegemonyModel.GetInstance(),
            SeaHegemonyModel.SELECT_PEOPLE, (level?) => {
                if (this.data && this.data[0] == level) {
                    this.dataChanged()
                }
            }
        )
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        // [ts2lua]SeaHegemonyModel:GetInstance().selectInfo下标访问可能不正确
        let info = SeaHegemonyModel.GetInstance().selectInfo[this.data[0]]
        if (info) {
            this.PositionLb.text = this.data[1] + (info && info.num || 0) + "/" + this.data[2]
        } else {
            this.PositionLb.text = this.data[1] + "0/" + this.data[2]
        }

        ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4", this.selected && "ui_btn_achv_highlight" || "ui_btn_achv", true)
        this.PositionLb.color=this.selected && "#a75d21" || "#ffffff"
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }

    _Image1: Laya.Image
    PositionLb: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this.PositionLb,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "PositionLb",
            ])
    }
}
window["SeaAppointTab"] = SeaAppointTab