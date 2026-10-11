import { DownDropList } from "../common/DownDropList"
import { MarriageDropItem } from "./MarriageDropItem"

export class MarriageDropList extends DownDropList {
    public constructor(parent) {
        super(parent)
        this.base_file = "marriage"
        this.layout_file = "MarriageDropList"
        this.anim_list = []
        this._btn_class = MarriageDropItem
        // this._btn_gap = 10
        // this._item_height = 31

        // let length = Util.TableSize(this.data_list)
        // this.show_count = show_count ? Math.min(length, show_count) : length
        // this.load_callback = () => {
        //     super.load_callback()
        //     this.UpdateView()
        //     this.UpdateItems()
        //     this.CreateBackground()
        // }
       
    }
    
    _img_bg: Laya.Image
    _scroller: Laya.Panel
    Content: Laya.VBox
    public GetComponents() {
        [
            this._img_bg,
            this._scroller,
            this.Content,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_scroller",
                "Content",
            ])
    }
}
window["MarriageDropList"] = MarriageDropList