import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { MarriageFlowCfg, MarriageModel } from "../commonModel/MarriageModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MarriageFlowItem } from "./MarriageFlowItem";

export class MarriageFlowView extends BaseView1 {

    LoadSuccess
    InitEvent
    UpdateView
    UpdateItems
    loop_mgr: LoopScrowViewMgr
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageFlowView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            res_mgr = ResManager.GetInstance()

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("marriage", "ui_marry_10"))
            this.LoadSuccess()
        }
        this.LoadSuccess = () => {
            // res_mgr.SetTexture(this, this._img_005c, "resource/game/marriage/texture/uijh_005c.jpg")
            // res_mgr.SetTexture(this, this._img_040, "resource/game/marriage/texture/uijh_040.png")

            this._list.scrollBar.visible = false
            // _ac_item_ = new eui.ArrayCollection()
            // this._list.dataProvider = _ac_item_
            // this._list.itemRenderer = MarriageFlowItem

            this.InitEvent()
            this.UpdateView()
        }

        this.destroy_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)
        }

        this.UpdateView = () => {
            this.UpdateItems(MarriageFlowCfg)
        }

        this.UpdateItems = (list) => {
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this._list, MarriageFlowItem, list, LoopScrCon.Vertical)
            } else {
                this.loop_mgr.replaceAll(list)
            }
        }
    }


_Image1:Laya.Image
_btn_close:Laya.Image
_Image4:Laya.Image
_list:Laya.List
public GetComponents() {
[
this._Image1,
this._btn_close,
this._Image4,
this._list,
]
 = this.GetChildrenByNames([

"_Image1",
"_btn_close",
"_Image4",
"_list",
])
}
}
 window["MarriageFlowView"]= MarriageFlowView