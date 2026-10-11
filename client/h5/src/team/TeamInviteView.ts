import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { GuildModel } from "../commonModel/GuildModel"
import { PlayerType, TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Util, GlobalTimerQuest } from "../util/Util"
import { TeamInviteRoleItem } from "./TeamInviteRoleItem"
import { TeamTabItem } from "./TeamTabItem"

let TabList = [{ playerType: PlayerType.Area, name: "附近玩家" }, { playerType: PlayerType.Frined, name: "好友" }, { playerType: PlayerType.Guild, name: "结社" }]
// [ts2lua]window下标访问可能不正确
window["TabList"] = TabList
export class TeamInviteView extends BaseView1 {
    _Image1: Laya.Image
    _Group1: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    _Image3: Laya.Image
    closeBtn: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Scroller1: Laya.List
    _Image6: Laya.Image
    _Label2: Laya.Label
    _Scroller2: Laya.List
    nont_conta: Laya.Box
    tips: Laya.Label
    tips_icon: Laya.Image
    ClearTimer
    GetAreaScenePlayer
    InitEvent
    InitTab
    LoadSuccess
    OpenCallback
    Remove
    Scr_Scroller1
    Scr_Scroller2
    SetNoneStyle
    SetPlayer
    SwtichView
    _tab_list
    click_bg_toClose
    destroy_callback
    destroy_imm
    is_center
    is_delay_callback
    onTimer
    open_callback
    scroll_group
    show_open_movie
    tabTouchHandler

    use_background

    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamInviteView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.is_delay_callback = false
        let model = TeamModel.GetInstance()
        let local_TeamEvent = TeamEvent
        let local_PlayerType = PlayerType
        let scene_mgr = SceneManager.GetInstance()
        let tab_loop_mgr = null
        let tab_list = null
        let _select_tab_ = 0
        //let arrayCollection_ = null
        let invite_loop_mgr = null
        let invite_list = null
        let period_timer_ = null
        let all_field_scene_ = null
        let now_index_ = 0
        this.preload_client_config = {
            "ClientMapConfig": false
        }
        this.load_callback = () => {

            // LayoutRebuilder(this._Group1)
            this.LoadSuccess()
            this.InitEvent()
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	SetAnchoredPositionX(this._Label2,107)
            // 	SetAnchoredPositionX(this._Image6,78)
            // }
        }

        this.open_callback = () => {
            this.OpenCallback()
        }

        this.destroy_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            if (tab_loop_mgr) {
                tab_loop_mgr.DeleteMe()
                tab_loop_mgr = null
            }
            if (invite_loop_mgr) {
                invite_loop_mgr.DeleteMe()
                invite_loop_mgr = null
            }
            _select_tab_ = 1
            tab_list = null
            invite_list = null
            this.ClearTimer()
            now_index_ = 0
            model.near_by_player = null
        }

        this.LoadSuccess = () => {
            this.InitTab()
            ResManager.GetInstance().SetTexture(this,this._Image1,GameResPath.GetIcon("team","ui_content_bg2"))
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            let update_near_by = () => {
                // [ts2lua]TabList下标访问可能不正确
                // [ts2lua]TabList下标访问可能不正确
                if (TabList[_select_tab_] && TabList[_select_tab_].playerType == local_PlayerType.Area) {
                    this.SetPlayer(local_PlayerType.Area)
                }
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_NEAR_BY_PLAYER, update_near_by)
            let update_zhao_mu = (_type?) => {
                // [ts2lua]TabList下标访问可能不正确
                if (TabList[_select_tab_]) {
                    // [ts2lua]TabList下标访问可能不正确
                    if (_type == local_PlayerType.Guild && TabList[_select_tab_].playerType == local_PlayerType.Guild) {
                        // [ts2lua]TabList下标访问可能不正确
                        this.SetPlayer(local_PlayerType.Guild)
                    }
                    else if (_type == local_PlayerType.Frined && TabList[_select_tab_].playerType == local_PlayerType.Frined) {
                        this.SetPlayer(local_PlayerType.Frined)
                    }
                }
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_ZHAO_MU_DATA, update_zhao_mu)
            let update_team_fun = () => {
                this.SwtichView(_select_tab_)
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, update_team_fun)
        }

        this.OpenCallback = () => {
            this.SwtichView(_select_tab_)
        }

        this.InitTab = () => {
            if (!tab_loop_mgr) {
                tab_list = TabList
                tab_loop_mgr = new LoopScrowViewMgr()
                tab_loop_mgr.SetData(this._Scroller2, TeamTabItem, tab_list, LoopScrCon.Horizontal, 1, () => {
                    this.tabTouchHandler()
                })
                _select_tab_ = 0
                // this.Content1.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.tabTouchHandler)
                tab_loop_mgr.SetSelectIndex(_select_tab_)
            }
        }

        this.tabTouchHandler = (e?) => {
            if (_select_tab_ == this._Scroller2.selectedIndex) {
                return
            }
            _select_tab_ = this._Scroller2.selectedIndex
            this.SwtichView(_select_tab_)
        }

        this.SwtichView = (index?) => {
            // [ts2lua]TabList下标访问可能不正确
            let tab = TabList[index]
            if (tab) {
                if (tab.playerType == local_PlayerType.Area) {
                    model.near_by_player = null
                    this.GetAreaScenePlayer()
                }
                else if (tab.playerType == local_PlayerType.Frined) {
                    model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24061, "c", 3)
                }
                else if (tab.playerType == local_PlayerType.Guild) {
                    if (GuildModel.IsHasGuild())
                    {
                        model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24061, "c", 2)
                    }else{
                    this.SetNoneStyle(local_PlayerType.Frined, true)
                    this.SetPlayer(local_PlayerType.Frined)
                    }
                }
            }
            tab_loop_mgr.replaceAll(tab_list)
        }

        this.GetAreaScenePlayer = () => {
            model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24053, "i", scene_mgr.GetSceneId())
            if (scene_mgr.IsFieldScene()) {
                now_index_ = 0
                this.ClearTimer()
                if (!period_timer_) {
                    period_timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
                        this.onTimer()
                    }, 0.1)
                }
                this.onTimer()
            }
        }

        this.onTimer = () => {
            let scene_id = scene_mgr.GetSceneId()
            if (!all_field_scene_) {
                all_field_scene_ = model.GetAllFieldScene(this.preload_client_config["ClientMapConfig"])
            }
            if (all_field_scene_) {
                let scene_cfg = null
                if (now_index_ == all_field_scene_.length - 1) {
                    this.ClearTimer()
                }
                // [ts2lua]all_field_scene_下标访问可能不正确
                scene_cfg = all_field_scene_[now_index_]
                if (scene_cfg) {
                    if (scene_id == scene_cfg.scene_id) {
                        now_index_ = now_index_ + 1
                        this.onTimer()
                    } else {
                        model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24053, "i", scene_cfg.scene_id)
                        now_index_ = now_index_ + 1
                    }
                }
            }
        }

        this.ClearTimer = () => {
            if (period_timer_) {
                GlobalTimerQuest.CancelQuest(period_timer_)
                period_timer_ = null
            }
        }

        this.SetNoneStyle = (index?, show?) => {
            this.nont_conta.visible = show
            let txt = "暂无附近玩家哦~"
            // [ts2lua]TabList下标访问可能不正确
            let tab = TabList[index]
            if (tab) {
                if (tab.playerType == local_PlayerType.Frined) {
                    txt = "暂无在线好友哦~"
                }
                else if (tab.playerType == local_PlayerType.Guild) {
                    txt = "暂无在线结社成员哦~"
                }
            }
            this.tips.text = txt
        }

        this.SetPlayer = (_type?) => {
            let online_vo = model.GetOnlineVo(_type)
            this.SetNoneStyle(this._Scroller2.selectedIndex, online_vo.length <= 0)
            if (!invite_loop_mgr) {
                invite_list = online_vo
                invite_loop_mgr = new LoopScrowViewMgr()
                invite_loop_mgr.SetData(this._Scroller1, TeamInviteRoleItem, invite_list, LoopScrCon.Vertical, 3)
            } else {
                invite_list = online_vo
                invite_loop_mgr.replaceAll(invite_list)
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
            this._Scroller1,
            this._Image6,
            this._Label2,
            this._Scroller2,
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
                "_Scroller1",
                "_Image6",
                "_Label2",
                "_Scroller2",
                "nont_conta",
                "tips",
                "tips_icon",
            ])
        this._Scroller1.scrollBar.visible=false
        this._Scroller2.scrollBar.visible=false
    }
}
window["TeamInviteView"]=TeamInviteView