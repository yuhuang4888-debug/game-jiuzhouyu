import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SeaDsgtPreItem } from "./SeaDsgtPreItem"

export class SeaDsgtPreview extends BaseView1 {

    InitView
    dataGp
    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layer_value = Enum_UILayer.Activity
        this.layout_file = "SeaDsgtPreview"
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.destroy_imm = true
        this.load_callback = () => {

            this.InitView()
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
        }

        this.InitView = () => {
            let dataList = [801006, 801001, 801002, 801003, 801004, 801005]
            this.dataGp = new LoopScrowViewMgr(this.Content)
            this.dataGp.SetData(this.Content, SeaDsgtPreItem, dataList, LoopScrCon.Vertical)
        }
    }

    public DeleteMe() {

        if (this.dataGp) {
            this.dataGp.DeleteMe()
            this.dataGp = null
        }
        super.DeleteMe()
    }


    bg: Laya.Image
    closeBtn: Laya.Image
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    Content: Laya.List
    _Image2_title: Laya.Image
    _lb_win_name: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.closeBtn,
            this._Image1,
            this._Image2,
            this._Image3,
            this.Content,
            this._Image2_title,
            this._lb_win_name,
        ]
            = this.GetChildrenByNames([

                "bg",
                "closeBtn",
                "_Image1",
                "_Image2",
                "_Image3",
                "Content",
                "_Image2_title",
                "_lb_win_name",
            ])
    }
}
window["SeaDsgtPreview"] = SeaDsgtPreview