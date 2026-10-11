import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class SeaFightGuildItem extends BaseItemRenderer {

    public WIDTH: number = 224
    public HEIGT: number = 95

    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaFightGuildItem"

        this.load_callback = () => {

        }
        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        this.PositionLb.text = this.data.guild_name
        this.scoreLb.text = this.data.guild_score+""
        this.rankLb.text = this.data.guild_rank+""

        if(this.data.is_att == 2){
            //防御
            this.typeIcon.size(36,35)
            ResManager.GetInstance().SetImageSprite(this, this.typeIcon, "seaHegemony", "ui_hyzc_tj03")
        }else{
            //攻击
            this.typeIcon.size(37,43)
            ResManager.GetInstance().SetImageSprite(this, this.typeIcon, "seaHegemony", "ui_hyzc_tj02")
        }
        
        if (this.selected) {
            this._Image1.pos(0, -3)
            this._Image1.height = 99
            ResManager.GetInstance().SetImageSprite(this, this._Image1, "seaHegemony", "ui_hyzc_tj05")
        } else {
            this._Image1.pos(0, 0)
            this._Image1.height = 88
            ResManager.GetInstance().SetImageSprite(this, this._Image1, "seaHegemony", "ui_hyzc_tj01")
        }
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }

    _Image1: Laya.Image
    PositionLb: Laya.Label
    _Image2: Laya.Image
    _Image3: Laya.Image
    scoreLb: Laya.Label
    rankLb: Laya.Label
    typeIcon: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this.PositionLb,
            this._Image2,
            this._Image3,
            this.scoreLb,
            this.rankLb,
            this.typeIcon,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "PositionLb",
                "_Image2",
                "_Image3",
                "scoreLb",
                "rankLb",
                "typeIcon",
            ])
    }
}
window["SeaFightGuildItem"] = SeaFightGuildItem