import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { DownDropBtn } from "../common/DownDropBtn";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendEvent, FriendModel, FRIEND_TYPE } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageDefine, MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MarriageAskItem } from "./MarriageAskItem";
import { MarriageDropBtn } from "./MarriageDropBtn";

//伴侣-求婚界面
export class MarriageAskView extends BaseView1 {

    Local_Open
    Clear
    LoadSuccess
    InitEvent
    UpdateFriendBtnData
    SetFriendBtn
    ClickItem
    ClickFriendDrop
    UpdateView
    UpdateItems

    _head_self: CustomHeadItem
    _head_other: CustomHeadItem
    private _drop_btn: MarriageDropBtn
    loop_mgr:LoopScrowViewMgr
    public constructor() {
        super()
        this.base_file = "marriage"
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageAskView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.preload_server_config={
            "config_propose_cfg":false
        }
        // this.show_open_movie = true
        // this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            friend_model = FriendModel.GetInstance(),
            role_mgr = RoleManager.GetInstance(),
            local_Message = Message,
            res_mgr = ResManager.GetInstance(),
            dress_model = DressModel.GetInstance(),
            Photo = DressType.Photo,
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            local_Util = Util,
            local_FriendEvent = FriendEvent,
            // _ac_item_: eui.ArrayCollection,
            _friend_list_,
            _cur_data_,
            _cur_role_data_,
            _no_friend_ = false

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("marriage", "ui_marry_10"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = function () {
            this.UpdateFriendBtnData()
        }

        this.destroy_callback = function () {
            this.Clear()
        }
        this.preload_server_config = {
            "config_propose_cfg": false
        }

        this.Local_Open = (parms) => {
            let role_lv = role_mgr.GetMainRoleVo().level
            let open_lv = MarriageDefine.OPEN_LV
            if (role_lv < open_lv) {
                local_Message.show(`${open_lv}级开启求婚`)
                this.Close()
                return
            }

            [_cur_role_data_] = parms
            super.Open()
        }

        this.Clear = () => {
            if (this._head_self) {
                this._head_self.DeleteMe()
                this._head_self = undefined
            }
            if (this._head_other) {
                this._head_other.DeleteMe()
                this._head_other = undefined
            }
            if (this._drop_btn) {
                this._drop_btn.DeleteMe()
                this._drop_btn = null
            }
            if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
        }

        this.LoadSuccess = () => {
            res_mgr.SetTexture(this, this._img_005c, "resource/game/marriage/texture/uijh_005c.jpg")
            res_mgr.SetTexture(this, this._img_040, "resource/game/marriage/texture/uijh_040.png")
            res_mgr.SetImageSprite(this, this._img_044,"marriage","uijh_044")

            this._head_self = new CustomHeadItem(this._head_self_con)
            this._head_self.Load()

            this._head_other = new CustomHeadItem(this._head_other_con)
            this._head_other.Load()

            

            // _ac_item_ = new eui.ArrayCollection()
            // this._list.dataProvider = _ac_item_
            // this._list.itemRenderer = 

            let role_vo = role_mgr.GetMainRoleVo()
            let frame_id = dress_model.GetDressByType(role_vo.dress_list, Photo)
            // this._head_self.setData(role_vo.level, role_vo.career, role_vo["picture"], undefined, undefined, frame_id)
            this._head_self.SetRoleVoData(role_vo)

            this._lb_name_self.text = role_vo.name

            // this._list.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.ClickItem, this)

            this.UpdateFriendBtnData()
            // this.UpdateView()
            _model.Fire(REQUEST_PROTO, 17232)
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_ask, () => {
                if (!_cur_role_data_) {
                    local_Message.show("请先选择一个心仪的伴侣")
                    return
                }
                if (!_cur_data_) {
                    local_Message.show("请先选择一枚戒指再示爱吧")
                    return
                }
                let cost_list = JSON.parse(_cur_data_.cost)
                let cost = cost_list[0]
                if (!cost) return
                GoodsModel.GetInstance().CheckCoinEnough(cost[0], cost[2], true, () => {
                    let role_id = _cur_role_data_.role_id
                    let type = _cur_data_.propose_type
                    let msg = "余生很长，与你共度才能将人生完满，你愿与我一起将人生慢慢填满么？"
                    _model.Fire(REQUEST_PROTO, 17231, "lcsc", role_id, type, msg, 0)
                })
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_help, () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 172)
            }, this, true)

            this.BindEvent(friend_model, local_FriendEvent.FRIEND_DATA_UPDATE, () => {
                let [need_fire, list] = _model.GetCanMarriageFriendList()
                this.SetFriendBtn(list)
            })

            this.BindVar(_model, "_mate_info", () => {
                this.UpdateView()
            })
        }

        this.UpdateFriendBtnData = () => {
            //请求好友数据
            // let [need_fire, list] = _model.GetCanMarriageFriendList()
            // if (need_fire) {
            friend_model.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.FRIEND)
            // } else {
            //     this.SetFriendBtn(list)
            // }
        }

        this.SetFriendBtn = (list) => {
            if (!_cur_role_data_) {
                _friend_list_ = list.length > 0 ? list : [{ role_name: local_Util.HtmlColorTxt("无可求婚对象", "'#F44767'") }]
                _no_friend_ = list.length <= 0
                let role_vo = role_mgr.GetMainRoleVo()
                // let career = role_vo.career == 1 ? 2 : 1
                if (_no_friend_) {
                    let career = "s"
                    this._head_other.SetData(null, career)
                    
                }
            } else {
                if (!_cur_role_data_.role_name) {
                    _cur_role_data_.role_name = _cur_role_data_.name
                }
                let fdata = friend_model.getFriendById(_cur_role_data_.role_id)
                if (!fdata) {
                    list.unshift(_cur_role_data_)
                } else {
                    if (list[0] && list[0] != fdata) {
                        let index = list.indexOf(fdata)
                        if (index > -1) {
                            let del_list = list.splice(index, 1)
                            list.unshift(del_list[0])
                        }
                    }
                }
                _friend_list_ = list
                _no_friend_ = false
            }
            if (!this._drop_btn) {
                // this._drop_btn = new MarriageDropBtn(this._drop_btn_con)
                this._drop_btn = new DownDropBtn(this._drop_btn_con)
                this._drop_btn.Init(_friend_list_, this.ClickFriendDrop, undefined, "role_name", undefined, 5)
                this._drop_btn.Load()
            }
        }

        this.ClickItem = (index) => {
            _cur_data_ = this.loop_mgr.data_list[index]
        }

        this.ClickFriendDrop = (index, data) => {
            if (_no_friend_) {
                local_Message.show("无可求婚对象");
                return;
            }
            _cur_role_data_ = data
            let frame_id = dress_model.GetDressByType(data.dress_list, Photo)
            // this._head_other.setData(data.lv || data.level, data.career, data["picture"], undefined, undefined, frame_id)
            this._head_other.SetRoleVoData(data)

        }

        this.UpdateView = () => {
            let config = res_mgr.GetGameConfigFromCache(this, "config_propose_cfg", false)
            let list = _model.GetAskDataList(config)
            this.UpdateItems(list)
            this._list.selectedIndex = 0
            _cur_data_ = this._list.selectedItem
        }

        this.UpdateItems = (list) => {
            // _ac_item_.source = list
            if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list, MarriageAskItem, list, LoopScrCon.Vertical, undefined, (index)=>{
                    this.ClickItem(index)
                })
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
    _img_040: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _img_044: Laya.Image
    _btn_close: Laya.Image
    _head_self_con: Laya.Box
    _head_other_con: Laya.Box
    _Image5: Laya.Image
    _Image6: Laya.Image
    _btn_help: Laya.Image
    _btn_ask: Laya.Box
    _Image7: Laya.Image
    _Label1: Laya.Label
    group2: Laya.VBox
    _Scroller1: Laya.Panel
    _list: Laya.List
    _lb_tips: Laya.Label
    _Group1: Laya.Box
    _Image8: Laya.Image
    _lb_name_self: Laya.Label
    _drop_btn_con: Laya.Box
    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._img_005c,
            this._img_040,
            this._Image3,
            this._Image4,
            this._img_044,
            this._btn_close,
            this._head_self_con,
            this._head_other_con,
            this._Image5,
            this._Image6,
            this._btn_help,
            this._btn_ask,
            this._Image7,
            this._Label1,
            this.group2,
            this._Scroller1,
            this._list,
            this._lb_tips,
            this._Group1,
            this._Image8,
            this._lb_name_self,
            this._drop_btn_con,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_img_005c",
                "_img_040",
                "_Image3",
                "_Image4",
                "_img_044",
                "_btn_close",
                "_head_self_con",
                "_head_other_con",
                "_Image5",
                "_Image6",
                "_btn_help",
                "_btn_ask",
                "_Image7",
                "_Label1",
                "group2",
                "_Scroller1",
                "_list",
                "_lb_tips",
                "_Group1",
                "_Image8",
                "_lb_name_self",
                "_drop_btn_con",
            ])
    }
}
window["MarriageAskView"] = MarriageAskView