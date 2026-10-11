import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { DsgtModel } from "../commonModel/DsgtModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"

export class SeaDsgtPreItem extends BaseItemRenderer {

    public WIDTH: number = 611
    public HEIGT: number = 137
    html_width=370
    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaDsgtPreItem"

        this.load_callback = () => {
            SetHtmlStyle(this.disLb,{c:"#774239",f:20,w:this.html_width,lh:25})
        }
        this.Load()
    }


    public dataChanged() {
        if (!super.dataChanged()) return
        let dsgt = DsgtModel.GetInstance().getDsgtCfgByID(this.data)
        if (!dsgt) {
            return
        }
        if (dsgt.type == 1) {
            this.dsgtImg.visible = false
        } else {
            this.dsgtImg.visible = true
            ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgtImg, GameResPath.GetDesignImage(dsgt.resource_id), true)
        }
        this.nameLb.text = dsgt.name
        let propStr = ""
        let propAttr = (typeof (dsgt.attr_list) == "string" && (ErlangParser.GetInstance().Parse(dsgt.attr_list)) || (dsgt.attr_list))
        let i = 0
        do {
            let vo = propAttr[i]
            if (i % 2 == 1) {
                propStr = `${propStr}&nbsp;&nbsp;&nbsp;&nbsp;${WordManager.GetProperties(vo[0])}:&nbsp;${HtmlColorTxt(WordManager.ConvertToPercentValue(vo[0], vo[1]),"'#ff6600'")}<br>`
            }else{
                propStr = `${propStr}${WordManager.GetProperties(vo[0])}:&nbsp;${HtmlColorTxt(WordManager.ConvertToPercentValue(vo[0], vo[1]),"'#ff6600'")}`
            }
            i = i + 1
        } while ((i < propAttr.length))
        if (this.data == 801006) {
            propStr = propStr + "<br>受致命一击时，无敌2s，cd120s"
        }
        this.disLb.innerHTML = Util.StrToHTML(propStr)
        this.disLb.style.width=this.html_width
    }

    public DeleteMe(): void {
        super.DeleteMe()
    }

    bg: Laya.Image
    _Image1: Laya.Image
    nameLb: Laya.Label
    disLb: Laya.HTMLDivElement
    dsgtImg: Laya.Image
    public GetComponents() {
        [
            this.bg,
            this._Image1,
            this.nameLb,
            this.disLb,
            this.dsgtImg,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_Image1",
                "nameLb",
                "disLb",
                "dsgtImg",
            ])
    }
}
window["SeaDsgtPreItem"] = SeaDsgtPreItem