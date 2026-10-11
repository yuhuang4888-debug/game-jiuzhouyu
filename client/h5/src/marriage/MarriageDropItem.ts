import { DownDropItem } from "../common/DownDropItem"

export class MarriageDropItem extends DownDropItem {
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage"
        this.layout_file = "MarriageDropItem"
    }
    _img_bg: Laya.Image
    _lb_content: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._img_bg,
            this._lb_content,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_content",
            ])
    }
}
window["MarriageDropItem"] = MarriageDropItem