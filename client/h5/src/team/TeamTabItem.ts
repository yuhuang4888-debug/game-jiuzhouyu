import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class TeamTabItem extends BaseItemRenderer {
    _Image1: Laya.Image
    _Group1: Laya.Box
    iconDisplay: Laya.Image
    _lb: Laya.Label
    redDisplay: Laya.Image

    model
    public static width = 135
    public static height = 60

    public constructor(parent) {
        super()

        this.base_file = "team"
        this.layout_file = "TeamTabItem"
        this.WIDTH=135
        this.HEIGT=60
        // this.skinName = "resource/game/team/exml/TeamTabItemExml.exml"
        //this.model = DressModel.GetInstance()
        // this.load_callback = () => {

        // this.InitEvent()
        // }
        this.Load()
    }

    public InitEvent() {

    }

    public dataChanged() {
        if(!super.dataChanged()) return 
        this._lb.text = this.data.name
        let sp_name = this.selected && "uizd_005" || "uizd_006"
        ResManager.GetInstance().SetImageSprite(this, this._Image1, "team", sp_name, true)
    }

    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this.iconDisplay,
            this._lb,
            this.redDisplay,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Group1",
                "iconDisplay",
                "_lb",
                "redDisplay",
            ])
    }
}
window["TeamTabItem"]=TeamTabItem
