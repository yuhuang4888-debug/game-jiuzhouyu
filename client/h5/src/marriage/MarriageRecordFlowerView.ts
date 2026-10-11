import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MarriageRecordFlowerItem } from "./MarriageRecordFlowerItem";

//伴侣-送花记录界面
export class MarriageRecordFlowerView extends BaseView1 {

    Clear
    LoadSuccess
    InitEvent
    UpdateView
    UpdateItems
    loop_mgr:LoopScrowViewMgr
    public constructor() {
        super();
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"];
        this.layout_file = "MarriageRecordFlowerView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        // this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            local_MarriageEvent = MarriageEvent
            // _ac_item_: eui.ArrayCollection

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("marriage", "uijh_081"))
            this.LoadSuccess()
            this.InitEvent()
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        this.Clear = () => {
            if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
        }

        this.LoadSuccess = () => {
            // _ac_item_ = new eui.ArrayCollection()
            // this._list.dataProvider = _ac_item_
            // this._list.itemRenderer = MarriageRecordFlowerItem
            this._list.scrollBar.visible = false
            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 22302)
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            this.BindEvent(_model, local_MarriageEvent.UPDATE_FLOWER_RECORD, (info) => {
                this.UpdateItems(info.record_list)
            })
        }

        this.UpdateView = () => {

        }

        this.UpdateItems = (list) => {
            // _ac_item_.source = list
            if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list, MarriageRecordFlowerItem, list, LoopScrCon.Vertical, undefined)
			} else {
				this.loop_mgr.replaceAll(list)
			}

            this._group_empty.visible = list.length < 1
        }
    }

    public Open(...parms) {
        super.Open()
    }
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Scroller1: Laya.Panel
    _list: Laya.List
    _btn_close: Laya.Image
    _group_empty: Laya.Box
    _Image5: Laya.Image
    _Label1: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Image3,
            this._Image4,
            this._Scroller1,
            this._list,
            this._btn_close,
            this._group_empty,
            this._Image5,
            this._Label1,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Image3",
                "_Image4",
                "_Scroller1",
                "_list",
                "_btn_close",
                "_group_empty",
                "_Image5",
                "_Label1",
            ])
    }
}
window["MarriageRecordFlowerView"] = MarriageRecordFlowerView