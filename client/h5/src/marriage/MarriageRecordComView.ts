import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { MarriageEvent, MarriageModel, MarriageRecordType } from "../commonModel/MarriageModel";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";
import { MarriageFriendItem } from "./MarriageFriendItem";
import { MarriageRecordComItem } from "./MarriageRecordComItem";

//伴侣-撩人记录界面
export class MarriageRecordComView extends BaseView1 {


    Local_Open
    Clear
    InitEvent
    UpdateView
    UpdateItems
    LoadSuccess

    loop_mgr:LoopScrowViewMgr
    public constructor() {
        super();
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"];
        this.layout_file = "MarriageRecordComView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            local_MarriageRecordType = MarriageRecordType,
            res_mgr = ResManager.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            // _ac_item_: eui.ArrayCollection,
            _type_

        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvent()
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        this.Local_Open = (parms) => {
            _type_ = parms[0] || local_MarriageRecordType.Self
            super.Open()
        }

        this.Clear = () => {
            if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("marriage", "ui_marry_10"))

            let source = ""
            if (_type_ == local_MarriageRecordType.Self) {
                source = `uijh_071`
            } else if (_type_ == local_MarriageRecordType.Other) {
                source = `uijh_070`
            }
            this._img_title.skin = AtlasUrl("marriage", source) 

            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17200, "c", _type_)
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            this.BindEvent(_model, local_MarriageEvent.UPDATE_FRIEND_INFO, (scmd) => {
                if (scmd.page != _type_) return
                this.UpdateView()
            })
        }

        this.UpdateView = () => {
            let info = _model.GetFriendInfo(_type_)
            if (!info) return
            let is_show = info.player_list.length > 0
            this._group_empty.visible = !is_show
            this.UpdateItems(info.player_list)
        }

        this.UpdateItems = (list) => {
            if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list, MarriageRecordComItem, list, LoopScrCon.Vertical, undefined)
			} else {
				this.loop_mgr.replaceAll(list)
			}
        }
    }


    public Open(...parms) {
        this.Local_Open(parms)
    }

    _Image1: Laya.Image
    _Image2: Laya.Image
    _img_005c: Laya.Image
    _Image3: Laya.Image
    _img_040: Laya.Image
    _btn_close: Laya.Image
    _img_title: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Scroller1: Laya.Panel
    _list: Laya.List
    _group_empty: Laya.Box
    _Image6: Laya.Image
    _Label1: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._img_005c,
            this._Image3,
            this._img_040,
            this._btn_close,
            this._img_title,
            this._Image4,
            this._Image5,
            this._Scroller1,
            this._list,
            this._group_empty,
            this._Image6,
            this._Label1,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_img_005c",
                "_Image3",
                "_img_040",
                "_btn_close",
                "_img_title",
                "_Image4",
                "_Image5",
                "_Scroller1",
                "_list",
                "_group_empty",
                "_Image6",
                "_Label1",
            ])
    }
}
window["MarriageRecordComView"] = MarriageRecordComView