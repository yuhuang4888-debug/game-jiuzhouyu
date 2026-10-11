import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"

export class TopPkRewardTabItem extends BaseItemRenderer {
    _Image1: Laya.Image
    _Label1: Laya.Label
    _img_red: Laya.Image
    WIDTH = 131
    HEIGT = 53
    public constructor(parent) {
        super()


        this.base_file = "topPk"
        this.layout_file = "TopPkRewardTabItem"
        this.load_callback = () => {

            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
            //     this._Label1.size = 18
            // }
        }
        this.Load()
    }

    public dataChanged() {
        if (super.dataChanged()) {
            if (this.data) {
                this._Label1.text = this.data.name
                this._img_red.visible = this.data.red_state
                if (this.selected) {
                    this._Label1.color = ColorUtil.TryParseHtmlString("#ffffff")
                    this._Label1.strokeColor = ColorUtil.TryParseHtmlString("#ad455c")
                    ResManager.GetInstance().SetImageSprite(this, this._Image1, "topPk_asset", "ui_phb_006",true)
                } else {
                    let color = ColorUtil.TryParseHtmlString("#4f538f")
                    this._Label1.color = color
                    ResManager.GetInstance().SetImageSprite(this, this._Image1, "topPk_asset", "ui_phb_005",true)
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
window["TopPkRewardTabItem"] = TopPkRewardTabItem