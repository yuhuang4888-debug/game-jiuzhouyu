import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { Util } from "../util/Util"

export class TeamChangeTargetTab extends BaseItemRenderer {
    _Image1: Laya.Image
    _Group1: Laya.Box
    _lb: Laya.HTMLDivElement
    redDisplay: Laya.Image
    InitEvent
    model

    public static width = 150
    public static height = 60

    public constructor(parent) {
        super()

        this.base_file = "team"
        this.layout_file = "TeamChangeTargetTab"
        this.WIDTH=1125
        this.HEIGT=52
        // this.skinName = "resource/game/team/exml/TeamChangeTargetTabExml.exml"
        this.model = TeamModel.GetInstance()
        let local_TeamEvent = TeamEvent

        // this.InitEvent = () => {
        //     //let fitter = this._lb.GetComponent("ContentSizeFitter")
        //     //fitter.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize
        // }
        this.Load()
    }

    public dataChanged() {
        if(!super.dataChanged()) return 
        if (this.data) {
            let color_dex = this.selected && "'#9b572f'" || "'#ffffff'"
            if(this.selected){
                this._lb.style.stroke=0
            }else{
                this._lb.style.stroke=2
                this._lb.style.strokeColor="#6873a8"
            }
            this._lb.width=120
            this._lb.innerHTML = Util.StrToHTML("<font color=" + color_dex + ">" + this.data.subtype_name + "</font>")

            let sp_name = this.selected && "ui_btn_achv_highlight" || "ui_btn_achv"
            ResManager.GetInstance().SetImageSprite(this, this._Image1, "team_asset", sp_name, true)
            this._lb.x=this._Group1.width/2-this._lb.contextWidth/2
            this._lb.y=this._Group1.height/2-this._lb.contextHeight/2
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this._lb,
            this.redDisplay,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Group1",
                "_lb",
                "redDisplay",
            ])
        this._lb.style.leading = 1
        this._lb.style.fontSize=20
        this._lb.style.color="#ffffff"
    }
}
window["TeamChangeTargetTab"]=TeamChangeTargetTab