import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SettingModel } from "../commonModel/SettingModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SettingHeadItem } from "./SettingHeadItem"

export class SettingChangeHeadView extends BaseView1 {
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Group1: Laya.Box
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    scroll: Laya.List
    okBtn: Laya.Box
    _Image6: Laya.Image
    _Label1: Laya.Label
    _close_btn: Laya.Image
    Content
    FormatAllHeadList
    InitEvent
    LoadSuccess
    Scrscroll
    SetItemRender
    UpdateView

    click_bg_toClose
    destroy_callback
    destroy_imm
    head_loop_mgr
    is_center

    open_callback

    scroll_group
    show_open_movie
    use_background
    RefSelType
    public constructor() {
        super()

        this.base_file = "setting"
        this.layout_file = "SettingChangeHeadView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        let model = SettingModel.GetInstance()
        let role_mgr = RoleManager.GetInstance()
        let global_event_sys = GlobalEventSystem
        let local_EventName = EventName
        let local_Util = Util
        let data_ = null
        let config_picture_ = null
        this.preload_server_config = {
            "config_picture": false
        }
        this.load_callback = () => {
            this.LoadSuccess()

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._Label1.size  = 18
            // }
            this.InitEvent()
        }

        this.open_callback = () => {
            this.UpdateView()
        }

        this.destroy_callback = () => {
            model.select_head_id = null
            config_picture_ = null
            if (this.head_loop_mgr) {
                this.head_loop_mgr.DeleteMe()
                this.head_loop_mgr = null
            }
        }

        this.LoadSuccess = () => {
            config_picture_ = this.preload_server_config["config_picture"]
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("common2", "uitc_001"))s
            GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13080)
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }
            Util.AddClickEvent(this._close_btn, close_fun, this, true)

            this.BindEvent(global_event_sys, SettingModel.SELECT_ROLE_HEAD_ICON_SUCCESS, close_fun)

            let okBtn_fun = () => {
                if (model.select_head_id) {
                    GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13083, "l", Number(model.select_head_id))
                }
            }
            Util.AddClickEvent(this.okBtn, okBtn_fun, this, true)

            this.BindEvent(
                global_event_sys,
                SettingModel.UPDATE_ROLE_HEAD_ICON, () => {
                    this.UpdateView()
                }
            )

            this.BindEvent(
                GlobalEventSystem,
                EventName.ROLEHEAD_UPLOAD_SUCCEED, () => {
                    if (role_mgr.mainRoleInfo) {
                        Message.show("头像上传成功 roleid: " + role_mgr.mainRoleInfo.role_id)
                        GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13081, "l", role_mgr.mainRoleInfo.role_id)
                    }
                }
            )
        }

        this.UpdateView = () => {
            data_ = this.FormatAllHeadList()
            if (!data_) {
                return
            }
            //table.insert(data_, 1, {})
            this.SetItemRender()
        }

        this.FormatAllHeadList = () => {
            let list = []
            if (config_picture_) {
                let career = role_mgr.mainRoleInfo.career
                for (let key in config_picture_) {

                    // [ts2lua]config_picture_下标访问可能不正确
                    let vo = config_picture_[key]
                    if (vo.sex == career || vo.sex == 0) {
                        table.insert(list, vo)
                    }
                }
            }
            let sort_fun = (a?, b?) => {
                let active_a = role_mgr.HaveActiviteThisHead(a.id) && 1 || 0
                let active_b = role_mgr.HaveActiviteThisHead(b.id) && 1 || 0
                if (active_a != active_b) {
                    return active_b < active_a
                } else {
                    if (a.id != b.id) {
                        return a.id < b.id
                    }
                }
            }

            table.sort(list, sort_fun)
            return list
        }

        this.RefSelType = (item?) => {
            // this.head_loop_mgr.replaceAll(data_)
        }

        this.SetItemRender = () => {
            if (!this.head_loop_mgr) {
                // data_.unshift({id:-1})
                this.head_loop_mgr = new LoopScrowViewMgr()
                this.head_loop_mgr.SetData(this.scroll, SettingHeadItem, data_, 4,LoopScrCon.Vertical)
                // this.Content.addEventListener(Laya.ItemTapEvent.ITEM_TAP,this.RefSelType,this)
            } else {
                // data_.unshift({id:-1})
                this.head_loop_mgr.replaceAll(data_)
            }
        }
    }


    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Group1,
            this._Image3,
            this._Image4,
            this._Image5,
            this.scroll,
            this.okBtn,
            this._Image6,
            this._Label1,
            this._close_btn,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Group1",
                "_Image3",
                "_Image4",
                "_Image5",
                "scroll",
                "okBtn",
                "_Image6",
                "_Label1",
                "_close_btn",
            ])
        this.scroll.scrollBar.visible=false
    }
}
window["SettingChangeHeadView"]=SettingChangeHeadView