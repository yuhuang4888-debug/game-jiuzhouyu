import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Util } from "../util/Util"
import { SeaApplyItem } from "./SeaApplyItem"

export class SeaSoldierApplyView extends BaseView1 {
    und
    FireEvent
    InitEvent
    UpdateView
    next_collect
    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaSoldierApplyView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true
        let local_model = SeaHegemonyModel
        let local_modelIns = SeaHegemonyModel.GetInstance()
        let local_Util = Util

        this.FireEvent = () => {
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._btn_pass, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18605, "cl", 2, 0)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._btn_refuse, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18605, "cl", 3, 0)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._btn_close, () => {
                    this.Close()
                },
                this,
                true
            )
            this.BindEvent(
                local_modelIns,
                SeaHegemonyModel.SOLDIER_APPLY, () => {
                    this.UpdateView()
                }
            )
        }

        this.UpdateView = () => {
            let list = local_modelIns.seaSoldierApplyList || []
            this._group_empty.visible = list.length < 1

            if (!this.next_collect) {
                this.next_collect = new LoopScrowViewMgr()
                this.next_collect.SetData(this.Content, SeaApplyItem, list,LoopScrCon.Vertical)
            } else {
                this.next_collect.replaceAll(list)
            }
        }

        this.load_callback = () => {

            this.InitEvent()
            this.FireEvent()
            this.UpdateView()
        }

        this.destroy_callback = () => {

            if (this.next_collect) {
                this.next_collect.DeleteMe()
                this.next_collect = null
            }
        }
    }

    public DeleteMe() {

        super.DeleteMe()
    }


_Image1111:Laya.Image
_Image2:Laya.Image
_btn_pass:Laya.Box
_Image11:Laya.Image
labelDisplay1:Laya.Label
_btn_refuse:Laya.Box
_Image111:Laya.Image
labelDisplay11:Laya.Label
Content:Laya.List
_btn_close:Laya.Box
_Image1:Laya.Image
_group_empty:Laya.Box
_Image6:Laya.Image
_Label2:Laya.Label
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this._Image1111,
this._Image2,
this._btn_pass,
this._Image11,
this.labelDisplay1,
this._btn_refuse,
this._Image111,
this.labelDisplay11,
this.Content,
this._btn_close,
this._Image1,
this._group_empty,
this._Image6,
this._Label2,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"_Image1111",
"_Image2",
"_btn_pass",
"_Image11",
"labelDisplay1",
"_btn_refuse",
"_Image111",
"labelDisplay11",
"Content",
"_btn_close",
"_Image1",
"_group_empty",
"_Image6",
"_Label2",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["SeaSoldierApplyView"]= SeaSoldierApplyView