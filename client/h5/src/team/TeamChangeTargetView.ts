import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Status } from "../util/Status"
import { Util } from "../util/Util"
import { TeamChangeTargetTab } from "./TeamChangeTargetTab"
import { GameResPath } from "../util/GameResPath"

export class TeamChangeTargetView extends BaseView1 {
    _Image1: Laya.Image
    _Group1: Laya.HBox
    _Image2: Laya.Image
    _Label1: Laya.Label
    _Image3: Laya.Image
    closeBtn: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Group2: Laya.HBox
    _Image6: Laya.Image
    _Label2: Laya.Label
    _image_element: Laya.Box
    _Image7: Laya.Image
    scroll: Laya.List
    down_bg: Laya.Image
    up_bg: Laya.Image
    down_level: Laya.Label
    up_level: Laya.Label
    _Label3: Laya.Label
    okBtn: Laya.Box
    _Image8: Laya.Image
    _Label4: Laya.Label
    ConfirmNumChange

    EmpokBtn
    GetSelectIndex
    InitEvent
    InitTab
    LoadSuccess
    OpenNumberTool
    Remove
    Scrscroll
    SwtichView
    _tab_list
    click_bg_toClose
    destroy_callback
    destroy_imm
    is_center
    is_delay_callback
    open_callback
    show_open_movie
    tabTouchHandler

    use_background

    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamChangeTargetView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.is_delay_callback = false
        let model = TeamModel.GetInstance()
        let local_Util = Util
        let local_TeamEvent = TeamEvent
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        let local_Message = Message
        let config_team_ui_ = null
        let _tab_arraycollection_ = null
        let _select_tab_ = 0
        let select_activity_id_ = null
        let select_activity_sub_id_ = null
        let select_min_level_ = null
        let select_max_level_ = null
        let now_value_ = 0
        let is_lower_ = false
        let last_click_time_ = null
        let tab_loop_mgr = null
        let tab_loop_list = []
        this.load_callback = () => {

            // LayoutRebuilder(this._Group1)
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
        }

        this.destroy_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            if (tab_loop_mgr) {
                tab_loop_mgr.DeleteMe()
                tab_loop_mgr = null
            }
            tab_loop_list = []
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this,this._Image1,GameResPath.GetIcon("team","ui_content_bg2"))
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            this.BindEvent(model, local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, close_fun)
            let okBtn_fun = () => {
                if (!last_click_time_ || Status.NowTime - last_click_time_ >= 1.5) {
                    if (select_activity_id_) {
                        let scene_id = SceneManager.GetInstance().GetSceneId()
                        let min = Number(this.down_level.text)
                        let max = Number(this.up_level.text)
                        if (min > 0 && max > 0) {
                            if (model.team_info && model.team_info.team_id > 0) {
                                model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24017, "ccihhi", select_activity_id_, select_activity_sub_id_, scene_id, min, max, 0)
                            } else {
                                let params = { activity_id: select_activity_id_, subtype: select_activity_sub_id_, scene_id: scene_id, min_lv: min, max_lv: max }
                                model.ChangeTargetSuccess(params)
                            }
                        }
                    }
                    last_click_time_ = Status.NowTime
                }
            }

            Util.AddClickEvent(this.okBtn, okBtn_fun, this, true)
            let down_bg_fun = () => {
                this.OpenNumberTool(true)
            }

            Util.AddClickEvent(this.down_level, down_bg_fun, this)
            let up_bg_fun = () => {
                this.OpenNumberTool(false)
            }

            Util.AddClickEvent(this.up_level, up_bg_fun, this)
            local_GlobalEventSystem.Fire(local_EventName.CLOSE_CALCULATOR_VIEW)
            let caculator_view_close = () => {
                if (is_lower_ != null && now_value_ != null) {
                    this.ConfirmNumChange(is_lower_, now_value_)
                    now_value_ = null
                }
            }

            this.BindEvent(local_GlobalEventSystem, local_EventName.CLOSE_CALCULATOR_VIEW, caculator_view_close)
            this.InitTab(_select_tab_)

        }

        this.GetSelectIndex = () => {
            let index = 0
            if (tab_loop_list) {
                let vo = null
                let i = 0
                do {
                    vo = tab_loop_list[i]
                    if (vo.activity_id == model.activity_id && vo.subtype_id == model.activity_sub_id) {
                        index = i
                        break
                    }
                    i = i + 1
                } while ((i < tab_loop_list.length))
            }
            return index
        }

        this.InitTab = (_select_?) => {
            if (!_tab_arraycollection_) {
                let main_role = RoleManager.GetInstance().GetMainRoleVo()
                let my_level = main_role.level
                ResManager.GetInstance().LoadGameConfig(this, "config_team_ui", false, null, (cfg) => {
                    model.config_team_ui_ = cfg
                    let tab_data_ = model.GetTargetAllcfg()
                    tab_loop_list = []
                    for (let k = 0; k < tab_data_.length; k++) {
                        let v = tab_data_[k]
                        let min_lv = v.default_lv_min
                        if (my_level >= min_lv) {
                            table.insert(tab_loop_list, v)
                        }
                    }
                    if (!tab_loop_mgr) {
                        tab_loop_mgr = new LoopScrowViewMgr()
                        tab_loop_mgr.SetData(this.scroll, TeamChangeTargetTab, tab_loop_list, LoopScrCon.Vertical, 1, () => {
                            this.tabTouchHandler()
                        })
                        // this.Content.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.tabTouchHandler)
                    } else {
                        tab_loop_mgr.replaceAll(tab_loop_list)
                    }

                    _select_tab_ = this.GetSelectIndex()
                    tab_loop_mgr.SetSelectIndex(_select_tab_ > 0 && _select_tab_ || 1)
                    this.SwtichView(_select_tab_)
                })

            }
        }

        this.tabTouchHandler = (e?) => {
            if (_select_tab_ == this.scroll.selectedIndex) {
                return
            }
            _select_tab_ = this.scroll.selectedIndex
            this.SwtichView(_select_tab_)
        }

        this.SwtichView = (index?) => {
            // [ts2lua]tab_data_下标访问可能不正确
            let tab = tab_loop_list[index]
            if (tab) {
                let min_lv = tab.default_lv_min
                let max_lv = tab.default_lv_max
                select_activity_id_ = tab.activity_id
                select_activity_sub_id_ = tab.subtype_id
                select_min_level_ = min_lv
                select_max_level_ = max_lv
                if (tab.activity_id == model.activity_id && tab.subtype_id == model.activity_sub_id) {
                    min_lv = model.min_level
                    max_lv = model.max_level
                }
                this.down_level.text = min_lv
                this.up_level.text = max_lv
            }
            if (tab_loop_mgr) {
                tab_loop_mgr.replaceAll(tab_loop_list)
            }

        }

        this.OpenNumberTool = (is_lower?) => {
            if (this.use_delete_method) {
                return
            }
            let max_num = 999
            is_lower_ = is_lower
            let num_change_fun = (value?) => {
                now_value_ = value
                if (!this.down_level) {
                    return
                }
                if (is_lower) {
                    this.down_level.text = value
                } else {
                    this.up_level.text = value
                }
            }

            let pos=[0,0]
            local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, pos, false)
        }

        this.ConfirmNumChange = (is_lower?, value?) => {
            if (select_activity_id_) {
                if (is_lower) {
                    if (value < select_min_level_) {
                        local_Message.show("不能低于最低等级")
                        this.down_level.text = select_min_level_
                        return
                    }
                    else if (value > select_max_level_ || value > Number(this.up_level.text)) {
                        local_Message.show("不能高于右侧最高等级")
                        this.down_level.text = select_min_level_
                        return
                    } else {
                        this.down_level.text = value
                    }
                } else {
                    if (value > select_max_level_) {
                        local_Message.show("不能高于最高等级")
                        this.up_level.text = select_max_level_
                        return
                    }
                    else if (value < select_min_level_ || value < Number(this.down_level.text)) {
                        local_Message.show("不能低于左侧最低等级")
                        this.up_level.text = select_max_level_
                        return
                    }
                    this.up_level.text = value
                }
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
            this._Group2,
            this._Image6,
            this._Label2,
            this._image_element,
            this._Image7,
            this.scroll,
            this.down_bg,
            this.up_bg,
            this.down_level,
            this.up_level,
            this._Label3,
            this.okBtn,
            this._Image8,
            this._Label4,
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
                "_Group2",
                "_Image6",
                "_Label2",
                "_image_element",
                "_Image7",
                "scroll",
                "down_bg",
                "up_bg",
                "down_level",
                "up_level",
                "_Label3",
                "okBtn",
                "_Image8",
                "_Label4",
            ])
        this.scroll.scrollBar.visible=false
    }
}
window["TeamChangeTargetView"]=TeamChangeTargetView