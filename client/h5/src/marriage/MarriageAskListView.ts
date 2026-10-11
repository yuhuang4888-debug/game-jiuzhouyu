import { BaseView1 } from "../common/BaseView1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { FriendEvent, FriendModel, FRIEND_TYPE } from "../commonModel/FriendModel";
import { MarriageDefine, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MarriageAskListItem } from "./MarriageAskListItem";

export class MarriageAskListView extends BaseView1 {

    Local_Open
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
        this.layout_file = "MarriageAskListView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        // this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            friend_model = FriendModel.GetInstance(),
            local_FriendEvent = FriendEvent,
            local_Util = Util

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("marriage", "uijh_081"))
            this.LoadSuccess()
            this.InitEvent()
        }
        this.destroy_callback = function () {
            this.Clear()
        }

        this.Local_Open = (parms) => {
            let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
            let open_lv = MarriageDefine.OPEN_LV
            if (role_lv < open_lv) {
                Message.show(`${open_lv}级开启求婚`)
                this.Close()
                return
            }
            super.Open()
        }

        this.Clear = () => {
            if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this, this._Image1, "resource/game/marriage/texture/uijh_081.png")
            this._list.scrollBar.visible = false
            // _ac_item_ = new eui.ArrayCollection()
            // this._list.dataProvider = _ac_item_
            // this._list.itemRenderer = MarriageAskListItem

            //请求好友数据
            // let [need_fire, list] = this._model.GetCanMarriageFriendListOutIntimacy()
            // if (need_fire) {
            friend_model.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.FRIEND)
            // } else {
            //     this.UpdateItems(list)
            // }
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_go, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageBaseView")
            }, this, true)

            this.BindEvent(friend_model, local_FriendEvent.FRIEND_DATA_UPDATE, () => {
                let [need_fire, list] = _model.GetCanMarriageFriendListOutIntimacy()
                this.UpdateItems(list)
            })
        }

        this.UpdateView = () => {

        }

        this.UpdateItems = (list) => {
            if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list, MarriageAskListItem, list, LoopScrCon.Vertical, undefined)
			} else {
				this.loop_mgr.replaceAll(list)
			}

            this._group_empty.visible = list.length < 1
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }
    

    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Scroller1: Laya.Panel
    _list: Laya.List
    _btn_close: Laya.Image
    _group_empty: Laya.Box
    _Label1: Laya.Label
    _btn_go: Laya.Box
    _Image5: Laya.Image
    _Label2: Laya.Label
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
            this._Label1,
            this._btn_go,
            this._Image5,
            this._Label2,
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
                "_Label1",
                "_btn_go",
                "_Image5",
                "_Label2",
            ])
    }
}
window["MarriageAskListView"] = MarriageAskListView