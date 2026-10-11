import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { ColorUtil } from "../util/ColorUtil"

export class SentientActTeamTabItem extends BaseItemRenderer {
    _Image1: Laya.Image
    _Label1: Laya.Label
    _img_red: Laya.Image
    WIDTH = 161
    HEIGT = 65
    public constructor(parent) {
        super()


        this.base_file = "sentientAct"
        this.layout_file = "SentientActTeamTabItem"
        this.load_callback = () => {
            this.BindEvent(SentientActModel.GetInstance(), SentientActEvent.UPDATE_APPLY_RED, (red) => {
                if(this.index == 2)
                    this._img_red.visible = red
            })
        }
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data) {
                this._Label1.text = this.data.name
                //this._img_red.visible = this.data.red_state
                if(this.data.red)
                    this._img_red.visible = true
                if (this.selected) {
                    this._Label1.color = ColorUtil.TryParseHtmlString("#ffffff")
                    this._Label1.strokeColor = ColorUtil.TryParseHtmlString("#ad455c")
                    ResManager.GetInstance().SetImageSprite(this, this._Image1, "sentientAct_asset", "ui_role_btn_3",true)
                } else {
                    let color = ColorUtil.TryParseHtmlString("#4f538f")
                    this._Label1.color = color
                    ResManager.GetInstance().SetImageSprite(this, this._Image1, "sentientAct_asset", "ui_role_btn_4",true)
                    this._Label1.strokeColor = ColorUtil.TryParseHtmlString("#c6c3f4")
                }
            }
        }
    }



    public GetComponents() {
        [
            this._Image1,
            this._Label1,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Label1",
                "_img_red",
            ])
    }
}
window["SentientActTeamTabItem"] = SentientActTeamTabItem