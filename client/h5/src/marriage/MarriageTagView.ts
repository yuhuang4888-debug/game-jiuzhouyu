import { BaseView1 } from "../common/BaseView1";
import { CookieWrapper } from "../common/CookieWrapper";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { MarriageModel, MarriageEvent, MarriageDefine } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { Util } from "../util/Util";
import { MarriageTagItem } from "./MarriageTagItem";
import { MarriageTagLayout } from "./MarriageTagLayout";
import { MarriageTagShowItem } from "./MarriageTagShowItem";

//伴侣-标签界面
export class MarriageTagView extends BaseView1 {
    // private _btn_close: eui.Image;
    // private _btn_go: eui.Button;
    // private _btn_cancel: eui.Button;
    // private _lb_name: eui.Label;
    // private _head: PlayerHead;
    // private _group_tag_show: eui.DataGroup;
    // private _group_tag: eui.DataGroup;
    // private _lb_count: eui.Label;
    // private _lb_guild: eui.Label;
    // private _img_bg: eui.Image;

    // Clear
    // LoadSuccess
    // InitEvent
    // UpdateShowItems
    // UpdateTagItems
    // GetTagListByDic
    // GetTagCookieStr
    // ClickTagItem
    // SetTagDicByCookie
    // SetMarkInDic
    // GetMarkInDic
    // public constructor() {
    //     super();

    //     let _model = MarriageModel.GetInstance(),
    //         local_Util = Util,
    //         local_MarriageEvent = MarriageEvent,
    //         local_MarriageDefine = MarriageDefine,
    //         _ac_show_: eui.ArrayCollection,
    //         _ac_tag_: eui.ArrayCollection,
    //         _tag_list_,
    //         _tag_dic_,
    //         _tag_mark_dic_

    //     this.base_file = "marriage";
    //     this.dependent_res = ["marriage2"];
    //     this.layout_file = "MarriageTagViewExml";
    //     this.layer_value = Enum_UILayer.Activity;
    //     this.is_center = true
    //     this.use_background = true
    //     this.click_bg_toClose = true
    //     this.show_open_movie = true
    //     this.destroy_imm = true

    //     this.load_callback = function () {
    //         this.LoadSuccess()
    //         this.InitEvent()
    //     }
    //     this.destroy_callback = function () {
    //         this.Clear()
    //     }

    //     this.Clear = () => {
    //         if (this._head) {
    //             this._head.DeleteMe()
    //             this._head = undefined
    //         }
    //         _tag_list_ = undefined
    //         _tag_dic_ = undefined

    //         if (this._group_tag) {
    //             this._group_tag.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.ClickTagItem, this)
    //         }
    //     }

    //     this.LoadSuccess = () => {
    //         ResManager.GetInstance().SetTexture(this, this._img_bg, "resource/game/marriage/texture/uijh_092.png")
    //         _tag_list_ = []
    //         _tag_mark_dic_ = {}
    //         let role_vo = RoleManager.GetInstance().GetMainRoleVo()
    //         this._lb_name.text = role_vo.name
    //         this._lb_guild.text = role_vo.guild_id ? role_vo.guild_name : "暂未加入结社"
    //         let frame_id = DressModel.GetInstance().GetDressByType(role_vo.dress_list, DressType.Photo)
    //         this._head.setData(role_vo.level, role_vo.career, role_vo["picture"], undefined, undefined, frame_id)

    //         _ac_show_ = new eui.ArrayCollection()
    //         this._group_tag_show.dataProvider = _ac_show_
    //         this._group_tag_show.itemRenderer = MarriageTagShowItem
    //         // this._group_tag_show.layout = new eui.VerticalLayout()
    //         this._group_tag_show.layout = new MarriageTagLayout()

    //         _ac_tag_ = new eui.ArrayCollection()
    //         this._group_tag.dataProvider = _ac_tag_
    //         this._group_tag.itemRenderer = MarriageTagItem
    //         // this._group_tag.layout = new eui.VerticalLayout()
    //         this._group_tag.layout = new MarriageTagLayout()

    //         this._group_tag.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.ClickTagItem, this)

    //         this.SetTagDicByCookie()
    //         this.UpdateTagItems()
    //         // this.UpdateShowItems()
    //     }

    //     this.InitEvent = () => {
    //         local_Util.AddClickEvent(this._btn_go, () => {
    //             // if (_tag_list_.length < 1) { Message.show("还没选择标签"); return }
    //             _model.Fire(local_MarriageEvent.SAVE_TAG, _tag_list_)
    //             let value = this.GetTagCookieStr()
    //             CookieWrapper.GetInstance().SaveCookie(CookieWrapper.MARRIAGE_TAG_LIST_STR, value)
    //             this.Close()
    //         }, this, true)

    //         local_Util.AddClickEvent(this._btn_close, () => {
    //             this.Close()
    //         }, this, true)

    //         local_Util.AddClickEvent(this._btn_cancel, () => {
    //             this.Close()
    //         }, this, true)

    //         this.BindEvent(_model, local_MarriageEvent.SUB_TAG, (data) => {
    //             let key = data.tag_id * 10000 + data.tag_subid
    //             delete _tag_dic_[key]
    //             this.UpdateShowItems()
    //             this.UpdateTagItems()
    //         })

    //         this.BindEvent(_model, local_MarriageEvent.ADD_TAG, (data) => {
    //             if (local_MarriageDefine.TAG_MAX_COUNT <= _tag_list_.length) {
    //                 Message.show("达到最大标签数量")
    //                 return
    //             }
    //             let key = data.tag_id * 10000 + data.tag_subid
    //             _tag_dic_[key] = data
    //             this.UpdateShowItems()
    //             this.UpdateTagItems()
    //         })
    //     }

    //     this.UpdateShowItems = () => {
    //         _tag_list_ = this.GetTagListByDic()
    //         _ac_show_.source = _tag_list_
    //         this._lb_count.text = `已选：${_tag_list_.length}/${local_MarriageDefine.TAG_MAX_COUNT}`
    //     }

    //     this.UpdateTagItems = () => {
    //         let list = _model.GetTagDataList()
    //         for (let data of list) {
    //             for (let tag of data.tag_list) {
    //                 let key = tag.tag_id * 10000 + tag.tag_subid
    //                 tag.tag_mark = !!_tag_dic_[key]
    //                 if (!data.tag_mark) {
    //                     data.tag_mark = tag.tag_mark
    //                 }
    //             }
    //         }
    //         _ac_tag_.source = list
    //     }

    //     this.GetTagListByDic = () => {
    //         let list = []
    //         for (let key in _tag_dic_) {
    //             let data = _tag_dic_[key]
    //             list.push(data)
    //         }
    //         return list
    //     }

    //     this.GetTagCookieStr = () => {
    //         let str = ""
    //         for (let data of _tag_list_) {
    //             let key = data.tag_id * 10000 + data.tag_subid
    //             str += `${key}${local_MarriageDefine.TAG_SAVE_SIGN}`
    //         }
    //         str = str.substring(0, str.length - 1)
    //         return str
    //     }

    //     this.ClickTagItem = (e: eui.ItemTapEvent) => {

    //     }

    //     this.SetTagDicByCookie = () => {
    //         _tag_dic_ = {}
    //         let tag_list = _model.GetTagListByCookie()
    //         for (let data of tag_list) {
    //             let key = data.tag_id * 10000 + data.tag_subid
    //             _tag_dic_[key] = data
    //             this.SetMarkInDic(data.tag_id, data.tag_subid, true)
    //         }
    //     }

    //     this.SetMarkInDic = (tag_id, tag_subid, mark) => {
    //         if (!_tag_mark_dic_[tag_id]) {
    //             _tag_mark_dic_[tag_id] = {}
    //         }
    //         _tag_mark_dic_[tag_id][tag_subid] = mark
    //     }

    //     this.GetMarkInDic = (tag_id, tag_subid) => {
    //         if (!_tag_mark_dic_[tag_id]) return false
    //         return _tag_mark_dic_[tag_id][tag_subid]
    //     }
    // }

    // public Open(...parms) {
    //     super.Open()
    // }
    // _img_bg: Laya.Image
    // _btn_close: Laya.Image
    // _head: Laya.Box
    // _lb_guild: Laya.Label
    // _lb_count: Laya.Label
    // _Group1: Laya.Box
    // _Image1: Laya.Image
    // _lb_name: Laya.Label
    // _Scroller1: Laya.Panel
    // _group_tag_show: Laya.VBox
    // _Group2: Laya.Box
    // _Image2: Laya.Image
    // _Scroller2: Laya.Panel
    // _group_tag: Laya.Box
    // _Group3: Laya.HBox
    // _btn_cancel: Laya.Box
    // _Image1: Laya.Image
    // labelDisplay: Laya.Label
    // _btn_go: Laya.Box
    // _Image1: Laya.Image
    // labelDisplay: Laya.Label
    // public GetComponents() {
    //     [
    //         this._img_bg,
    //         this._btn_close,
    //         this._head,
    //         this._lb_guild,
    //         this._lb_count,
    //         this._Group1,
    //         this._Image1,
    //         this._lb_name,
    //         this._Scroller1,
    //         this._group_tag_show,
    //         this._Group2,
    //         this._Image2,
    //         this._Scroller2,
    //         this._group_tag,
    //         this._Group3,
    //         this._btn_cancel,
    //         this._Image1,
    //         this.labelDisplay,
    //         this._btn_go,
    //         this._Image1,
    //         this.labelDisplay,
    //     ]
    //         = this.GetChildrenByNames([

    //             "_img_bg",
    //             "_btn_close",
    //             "_head",
    //             "_lb_guild",
    //             "_lb_count",
    //             "_Group1",
    //             "_Image1",
    //             "_lb_name",
    //             "_Scroller1",
    //             "_group_tag_show",
    //             "_Group2",
    //             "_Image2",
    //             "_Scroller2",
    //             "_group_tag",
    //             "_Group3",
    //             "_btn_cancel",
    //             "_Image1",
    //             "labelDisplay",
    //             "_btn_go",
    //             "_Image1",
    //             "labelDisplay",
    //         ])
    // }
}
window["MarriageTagView"] = MarriageTagView