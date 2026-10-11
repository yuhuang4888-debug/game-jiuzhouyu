import { BaseView1 } from "../common/BaseView1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
// import { FriendModel, FriendEvent, FriendVo } from "../commonModel/FriendModel";
import { FriendModel, FriendEvent } from "../commonModel/FriendModel";

import { MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { RefGridLayout, Util } from "../util/Util";

export class MarriageRoleMenuView extends BaseView1 {

    // private evt: Laya.Event;

    pos
    Local_Open
    Clear
    InitView
    InitEvent
    public constructor() {
        super();
        let _model = MarriageModel.GetInstance(),
            role_mgr = RoleManager.GetInstance(),
            friend_model = FriendModel.GetInstance(),
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            local_Util = Util,
            local_FriendEvent = FriendEvent,
            role_data_

        this.base_file = "marriage";
        this.layout_file = "MarriageRoleMenuView";
        this.layer_value = Enum_UILayer.Activity;
        this.show_open_movie = true;
        // this.use_background = true
        // this.background_alpha = 0
        this.click_bg_toClose = true
        this.load_callback = function () {
            this._Scroller1.vScrollBar.visible = false
            this.InitEvent()
        }
        this.close_callback = function () {
            this.Clear()
        }
        this.open_callback = function () {
            if (this.pos) {
                this.display_obj.x = this.pos.x
                this.display_obj.y = this.pos.y
            }
            this.InitView()
        }

        this.Local_Open = (parms) => {
            [role_data_, this.pos] = parms

            super.Open()
        }

        this.Clear = () => {

        }

        this.InitView = () => {
            this._Scroller1.scrollTo(0, 0)
            let role_vo = role_mgr.GetMainRoleVo()
            let need_intimacy = _model.GetConstantData(9)
            let fri_vo = friend_model.getFriendById(role_data_.role_id)
            let has_fri = !!fri_vo

            this._btn_friend.visible = !has_fri
            // this._btn_friend.includeInLayout = !has_fri
            this._btn_chat.visible = has_fri
            // this._btn_chat.includeInLayout = has_fri

            //对方未婚，己方未婚，亲密度足够
            let intimacy_enough = fri_vo && fri_vo.intimacy >= need_intimacy
            let married_s = !!role_mgr.GetMainRoleVo().marriage_id
            let married_o = role_data_.if_marriage == 2
            let can_sex = role_vo.sex != role_data_.sex
            let can_ask = !married_s && !married_o && intimacy_enough && can_sex
            this._btn_ask.visible = can_ask
            // this._btn_ask.includeInLayout = can_ask

            RefGridLayout(this._Scroller1, {
                column: 1,
                h_gap: 6,
                v_gap: 6,
                item_w: 141,
                item_h: 52
            }, true)

            let count = 0
            for (let i = 0; i < this._Scroller1.numChildren; i++) {
                let child: Laya.Box = this._Scroller1.getChildAt(i) as Laya.Box
                count += child.visible ? 1 : 0
            }
            this.display_obj.height = count >= 5 ? 272 : (count <= 2 ? 124 : count * 52 + 10)
            this._img_bg.height = this.display_obj.height
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._Scroller1, (e: Laya.Event) => {
                e.stopPropagation()
            }, this, false)

            this.BindEvent(local_GlobalEventSystem, local_EventName.STAGE_CLICK_EVENT, () => {
                this.Close()
            })

            local_Util.AddClickEvent(this._btn_ask, () => {
                local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageAskView")
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_chat, () => {
                // Message.show("敬请期待")
                // let friend_vo
                // friend_vo = new FriendVo()
                // friend_vo.role_id = role_data_.role_id
                // friend_vo.role_name = role_data_.name
                // friend_model.Fire(local_FriendEvent.OPEN_CHAT_VIEW, friend_vo)
                // this.Close()
                friend_model.Fire(local_FriendEvent.OPEN_CHAT_VIEW, role_data_)
				this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_look, () => {
                // Message.show("敬请期待")

                friend_model.requestPlayerMessage(role_data_.role_id)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_friend, () => {
                friend_model.Fire(local_FriendEvent.ADD_FRIEND, role_data_.role_id)
                this.Close()
            }, this, true)
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    
    _img_bg: Laya.Image
    _Scroller1: Laya.Panel
    _btn_look: Laya.Box
    _Image11: Laya.Image
    labelDisplay1: Laya.Label
    _btn_chat: Laya.Box
    _Image111: Laya.Image
    labelDisplay11: Laya.Label
    _btn_ask: Laya.Box
    _Image1111: Laya.Image
    labelDisplay111: Laya.Label
    _btn_friend: Laya.Box
    _Image11111: Laya.Image
    labelDisplay1111: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._Scroller1,
            this._btn_look,
            this._Image11,
            this.labelDisplay1,
            this._btn_chat,
            this._Image111,
            this.labelDisplay11,
            this._btn_ask,
            this._Image1111,
            this.labelDisplay111,
            this._btn_friend,
            this._Image11111,
            this.labelDisplay1111,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Scroller1",
                "_btn_look",
                "_Image11",
                "labelDisplay1",
                "_btn_chat",
                "_Image111",
                "labelDisplay11",
                "_btn_ask",
                "_Image1111",
                "labelDisplay111",
                "_btn_friend",
                "_Image11111",
                "labelDisplay1111",
            ])
    }
}
window["MarriageRoleMenuView"] = MarriageRoleMenuView