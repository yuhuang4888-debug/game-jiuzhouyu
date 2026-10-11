import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionX } from "../util/Util"
import { TeamApplyRoleItem } from "./TeamApplyRoleItem"

export class TeamApplyView extends BaseView1 {
    _Image1: Laya.Image
    _Group1: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    _Image3: Laya.Image
    closeBtn: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Scroller1: Laya.List
    auto_accept: Laya.Box
    check_img: Laya.Image
    check_label: Laya.Label
    clearBtn: Laya.Box
    _Image7: Laya.Image
    _Label2: Laya.Label
    _Group2: Laya.HBox
    _Image8: Laya.Image
    _Label3: Laya.Label
    _Image9: Laya.Image
    _Label4: Laya.Label
    nont_conta: Laya.Box
    tips: Laya.Label
    tips_icon: Laya.Image
    ClearApplyList
    InitEvent
    LoadSuccess
    Scr_Scroller1
    SetApplyList
    SetCheackState
    SetData
    click_bg_toClose

    destroy_callback
    destroy_imm
    is_center
    is_delay_callback

    open_callback
    scroll_group
    show_open_movie

    use_background

    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamApplyView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.is_delay_callback = false
        let model = TeamModel.GetInstance()
        let local_TeamEvent = TeamEvent
        let local_Util = Util
        let apply_loop_list = null
        let apply_loop_mgr = null
        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	SetAnchoredPositionX(this._Group2,16)
            // 	SetAnchoredPositionX(this.clearBtn,431)
            // }
        }

        this.open_callback = () => {
            model.apply_view_open = true
            model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24047)
            this.SetData()
        }

        this.destroy_callback = () => {
            model.apply_view_open = false
            if (apply_loop_mgr) {
                apply_loop_mgr.DeleteMe()
                apply_loop_mgr = null
            }
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this,this._Image1,GameResPath.GetIcon("team","ui_content_bg2"))
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            let clear_fun = () => {
                this.ClearApplyList()
            }

            Util.AddClickEvent(this.clearBtn, clear_fun, this, true)
            let auto_accept_fun = () => {
                if (model.team_info) {
                    // [ts2lua]lua中0和空字符串也是true，此处model.team_info.join_type == 1需要确认
                    let auto_tag = (model.team_info.join_type == 1 && (2) || (1))
                    model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24018, "c", auto_tag)
                }
            }

            Util.AddClickEvent(this.auto_accept, auto_accept_fun, this)
            let update_fun = () => {
                this.SetData()
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_APPLY_LIST, update_fun)
            let join_type_fun = () => {
                this.SetCheackState()
            }

            this.BindEvent(model, local_TeamEvent.TEAM_CHANGE_JOIN_TYPE, join_type_fun)
            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, join_type_fun)
        }

        this.SetData = () => {
            this.nont_conta.visible = !model.apply_list || model.apply_list.length <= 0
            if (model.apply_list) {
                if (!apply_loop_mgr) {
                    this.SetApplyList(model.apply_list)
                } else {
                    apply_loop_list = model.apply_list
                    apply_loop_mgr.replaceAll(apply_loop_list)
                }
            }
            this.SetCheackState()
        }

        this.SetApplyList = (apply_list?) => {
            apply_loop_list = apply_list
            if (!apply_loop_mgr) {
                apply_loop_mgr = new LoopScrowViewMgr()
                apply_loop_mgr.SetData(this._Scroller1, TeamApplyRoleItem, apply_loop_list, LoopScrCon.Vertical, 1)
            } else {
                apply_loop_mgr.replaceAll(apply_loop_list)
            }
        }

        this.SetCheackState = () => {
            if (model.team_info) {
                if (model.team_info.join_type == 2) {
                    ResManager.GetInstance().SetImageSprite(this, this.check_img, "common_asset", "com_ui_gx1", true)
                } else {
                    ResManager.GetInstance().SetImageSprite(this, this.check_img, "common_asset", "com_ui_gx", true)
                }
            }
        }

        this.ClearApplyList = () => {
            if (model.apply_list) {
                model.apply_list = []
                model.Fire(local_TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, {})
            }
        }
    }


    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this._Image2,
            this._Label1,
            this._Image3,
            this.closeBtn,
            this._Image4,
            this._Image5,
            this._Image6,
            this._Scroller1,
            this.auto_accept,
            this.check_img,
            this.check_label,
            this.clearBtn,
            this._Image7,
            this._Label2,
            this._Group2,
            this._Image8,
            this._Label3,
            this._Image9,
            this._Label4,
            this.nont_conta,
            this.tips,
            this.tips_icon,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Group1",
                "_Image2",
                "_Label1",
                "_Image3",
                "closeBtn",
                "_Image4",
                "_Image5",
                "_Image6",
                "_Scroller1",
                "auto_accept",
                "check_img",
                "check_label",
                "clearBtn",
                "_Image7",
                "_Label2",
                "_Group2",
                "_Image8",
                "_Label3",
                "_Image9",
                "_Label4",
                "nont_conta",
                "tips",
                "tips_icon",
            ])
    }
}
window["TeamApplyView"]=TeamApplyView