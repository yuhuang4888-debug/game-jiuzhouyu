import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendEvent, FriendModel } from "../commonModel/FriendModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { RefGridLayout, Util } from "../util/Util";

//伴侣-交流界面(打招呼)
export class MarriageComView extends BaseView1 {

    private _head: CustomHeadItem;

    Local_Open
    Clear
    LoadSuccess
    UpdateView
    UpdateBtnState
    InitEvent
    public constructor() {
        super();

        let _model = MarriageModel.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            role_mgr = RoleManager.GetInstance(),
            friend_model = FriendModel.GetInstance(),
            local_Util = Util,
            local_GlobalEventSystem = GlobalEventSystem,
            OPEN_VIEW = EventName.OPEN_VIEW,
            local_Message = Message,
            local_FriendEvent = FriendEvent,
            _ohter_vo_

        this.base_file = "marriage";
        this.dependent_res = ["marriage2"];
        this.layout_file = "MarriageComView";
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uijh_092"))
            this.LoadSuccess()
            this.InitEvent()
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        this.Local_Open = (parms) => {
            [_ohter_vo_] = parms
            if (!_ohter_vo_) {
                this.Close()
                return
            }
            super.Open()
        }

        this.Clear = () => {
            if (this._head) {
                this._head.DeleteMe()
                this._head = undefined
            }
        }

        this.LoadSuccess = () => {
            this._head = new CustomHeadItem(this._head_con)
            this._head.Load()

            ResManager.GetInstance().SetTexture(this, this._img_bg, "resource/game/marriage/texture/uijh_092.png")
            _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17205, "l", _ohter_vo_.role_id)
            this.UpdateView()
        }

        this.UpdateView = () => {
            let role_vo = _ohter_vo_
            let has_tag = role_vo.tag_list.length > 0
            this._lb_intimacy.text = `亲密度:${role_vo.intimacy}`
            this._lb_msg.text = role_vo.msg
            this._lb_tag.text = has_tag ? _model.GetTagsStr(role_vo.tag_list) : "未设置个人标签"
            // this._group_tag.visible = has_tag
            this._group_tag.visible = false
            this._lb_name.text = role_vo.name
            // this._lb_guild.text = role_vo.guild_id ? role_vo.guild_name : "暂未加入结社"
            let frame_id = DressModel.GetInstance().GetDressByType(role_vo.dress_list, DressType.Photo)
            // this._head.SetData(role_vo.level || role_vo.lv, role_vo.career, role_vo["picture"], undefined, undefined, frame_id)
            this._head.SetRoleVoData(role_vo)

            this.UpdateBtnState()
        }

        this.UpdateBtnState = () => {
            let main_vo = role_mgr.GetMainRoleVo()
            let married = main_vo.is_marriage == 2
            let role_vo = _ohter_vo_
            let need_intimacy = _model.GetConstantData(9)
            let enough = need_intimacy <= role_vo.intimacy

            let vo = friend_model.getFriendById(role_vo.role_id)
            let is_friend = !!vo
            this._btn_friend.visible = !is_friend
            // this._btn_friend.includeInLayout = !is_friend
            this._btn_hi.visible = is_friend
            // this._btn_hi.includeInLayout = is_friend

            let can_ask = is_friend && enough && !married
            this._btn_ask.visible = can_ask
            // this._btn_ask.includeInLayout = can_ask
            this._btn_gift.visible = !can_ask
            // this._btn_gift.includeInLayout = !can_ask

            //根据好友亲密度刷新数据(收花/送花)
            role_vo.intimacy = vo ? vo.intimacy : role_vo.intimacy
            this._lb_intimacy.text = `亲密度:${role_vo.intimacy}`

            RefGridLayout(this._Group4, {
                column: 2,
                h_gap: 45,
                v_gap: 8,
                item_w: 150,
                item_h: 65
            }, true)
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_hi, () => {
                // Message.show("敬请期待")
                _model.HiToChat(_ohter_vo_.role_id)
                _model.OpenChatView(_ohter_vo_.role_id)
                if (!_model.GetFriendData(2, _ohter_vo_.role_id)) {
                    _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17201, "lc", _ohter_vo_.role_id, 1)
                }
            }, this, true)

            local_Util.AddClickEvent(this._btn_gift, () => {
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageFlowerView", _ohter_vo_)
                if (!_model.GetFriendData(2, _ohter_vo_.role_id)) {
                    _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17201, "lc", _ohter_vo_.role_id, 1)
                }
            }, this, true)

            local_Util.AddClickEvent(this._btn_ask, () => {
                let role_vo = role_mgr.GetMainRoleVo()
                let married_s = role_vo.marriage_id
                if (married_s) {
                    local_Message.show("您已结婚，无法求婚")
                    return
                }
                let married_o = _ohter_vo_.if_marriage == 2
                if (married_o) {
                    local_Message.show("对方已结婚，无法求婚")
                    return
                }
                if (role_vo.sex == _ohter_vo_.sex) {
                    local_Message.show("只有异性玩家才可以求婚哦")
                    return
                }
                if (role_vo.level < 180 || _ohter_vo_.level < 180) {
                    local_Message.show("需要双方等级均达到180级方可求婚")
                    return
                }
                local_GlobalEventSystem.Fire(OPEN_VIEW, "MarriageAskView", _ohter_vo_)
            }, this, true)

            local_Util.AddClickEvent(this._btn_friend, () => {
                friend_model.Fire(local_FriendEvent.ADD_FRIEND, _ohter_vo_.role_id)
                if (!_model.GetFriendData(2, _ohter_vo_.role_id)) {
                    _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17201, "lc", _ohter_vo_.role_id, 1)
                }
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            this.BindEvent(friend_model, local_FriendEvent.FRIEND_DATA_UPDATE, () => {
                this.UpdateBtnState()
            })

            this.BindEvent(_model, local_MarriageEvent.GIVE_GIFT_SUCCESS, (scmd) => {
                if (_ohter_vo_.role_id != scmd.receive_id) return
                this.UpdateBtnState()
            })

            this.BindEvent(_model, local_MarriageEvent.GET_FLOWER, (scmd) => {
                if (_ohter_vo_.role_id != scmd.role_id) return
                this.UpdateBtnState()
            })

            this.BindEvent(_model, local_MarriageEvent.UPDATE_ROLE_DATA, (scmd) => {
                if (_ohter_vo_.role_id != scmd.role_id) return
                this._lb_guild.text = scmd.guild_id ? `结社：${scmd.guild_name }`: "暂未加入结社"
            })
        }
    }


    public Open(...parms) {
        this.Local_Open(parms)
    }


    _img_bg: Laya.Image
    _btn_close: Laya.Image
    _head_con: Laya.Box
    _lb_tips: Laya.Label
    _lb_name: Laya.Label
    _Group2: Laya.Box
    _Image2: Laya.Image
    _lb_intimacy: Laya.Label
    _group_tag: Laya.Box
    _Image3: Laya.Image
    _lb_tag: Laya.Label
    _Group3: Laya.Box
    _Image4: Laya.Image
    _lb_msg: Laya.Label
    _Group4: Laya.Box
    _btn_friend: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    _btn_hi: Laya.Box
    _Image21: Laya.Image
    labelDisplay2: Laya.Label
    _btn_gift: Laya.Box
    _Image31: Laya.Image
    labelDisplay3: Laya.Label
    _btn_ask: Laya.Box
    _Image41: Laya.Image
    labelDisplay4: Laya.Label
    _lb_guild: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._btn_close,
            this._head_con,
            this._lb_tips,
            this._lb_name,
            this._Group2,
            this._Image2,
            this._lb_intimacy,
            this._group_tag,
            this._Image3,
            this._lb_tag,
            this._Group3,
            this._Image4,
            this._lb_msg,
            this._Group4,
            this._btn_friend,
            this._Image1,
            this.labelDisplay1,
            this._btn_hi,
            this._Image21,
            this.labelDisplay2,
            this._btn_gift,
            this._Image31,
            this.labelDisplay3,
            this._btn_ask,
            this._Image41,
            this.labelDisplay4,
            this._lb_guild,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_btn_close",
                "_head_con",
                "_lb_tips",
                "_lb_name",
                "_Group2",
                "_Image2",
                "_lb_intimacy",
                "_group_tag",
                "_Image3",
                "_lb_tag",
                "_Group3",
                "_Image4",
                "_lb_msg",
                "_Group4",
                "_btn_friend",
                "_Image1",
                "labelDisplay1",
                "_btn_hi",
                "_Image21",
                "labelDisplay2",
                "_btn_gift",
                "_Image31",
                "labelDisplay3",
                "_btn_ask",
                "_Image41",
                "labelDisplay4",
                "_lb_guild",
            ])
    }
}
window["MarriageComView"] = MarriageComView