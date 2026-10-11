import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, GlobalTimerQuest } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { TeamHallItem } from "./TeamHallItem"
import { TeamRoleItem } from "./TeamRoleItem"
import { Config } from "../common/Config"

export class TeamView extends BaseView1 {
    _Image1: Laya.Image
    _Group1: Laya.HBox
    _Image2: Laya.Image
    title_img: Laya.Image
    _con_img_right: Laya.Box
    _Image3: Laya.Image
    closeBtn: Laya.Image
    _Image4: Laya.Image
    Separate_img: Laya.Image
    team_scroll: Laya.List
    hall_sroll: Laya.List
    target_label: Laya.HTMLDivElement
    targetBtn: Laya.Box
    _Image5: Laya.Image
    _Label1: Laya.Label
    inviteBtn: Laya.Box
    _Image6: Laya.Image
    _Label2: Laya.Label
    world_btn: Laya.Box
    _Image7: Laya.Image
    shout_txt: Laya.Label
    applyListBtn: Laya.Box
    _Image8: Laya.Image
    _Label3: Laya.Label
    applyListDot: Laya.Image
    createBtn: Laya.Box
    _Image9: Laya.Image
    _Label4: Laya.Label
    nont_conta: Laya.Box
    tips: Laya.Label
    tips_icon: Laya.Image
    tips_btn: Laya.Image
    CancelTimer
    CheckHallLoopMgr
    EmpapplyListBtn
    EmpcreateBtn
    EmpinviteBtn
    EmptargetBtn
    Empworld_btn
    InitEvent
    LoadSuccess
    Local_Open
    OnTime
    OpenCallback
    RefreshTarget
    RequestTeamHall
    Scrhall_sroll
    Scrteam_scroll
    SetBtnState
    SetMyTeam
    SetMyTeamGroup
    SetRedDot
    SetTeamHall
    SetTeamHallGroup
    StartCoolTimer
    click_bg_toClose
    close_callback
    created_team_flag
    destroy_callback
    destroy_imm
    group_loop_mgr
    hall_loop_mgr
    hall_scroll_group
    is_center
    is_delay_callback
    open_callback
    scroll_group
    show_open_movie
    use_background


    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamView"
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
        let local_Message = Message
        let role_mgr = RoleManager.GetInstance()
        let local_TeamModel = TeamModel
        let local_ModuleType = ModuleType
        let cfg_finish_ = false
        let arrayCollection_ = null
        let array_list = null
        let hallArrayCollection_ = null
        let hallarray_list = null
        let count_time_id_ = null
        let _is_create_team = null
        this.load_callback = () => {
            // 用于打开界面创建队伍
            this.created_team_flag = false

            this.LoadSuccess()
            this.InitEvent()
            this.RequestTeamHall()
        }

        this.open_callback = () => {
            model.team_view_open = true
            this.OpenCallback()
        }

        this.close_callback = () => {
            _is_create_team = false
            this.created_team_flag = false
            model.Fire(TeamEvent.TEAM_VIEW_IS_CLOSE)
        }

        this.destroy_callback = () => {
            model.team_view_open = false
            this.CancelTimer()
            array_list = null
            arrayCollection_ = null
            hallArrayCollection_ = null
            this.DeleteMe()
        }

        this.Local_Open = (is_create_team?) => {
            _is_create_team = is_create_team
            super.Open()
        }

        this.LoadSuccess = () => {
            model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24010)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.Separate_img, GameResPath.GetIcon("team", "uiphb_004a"), true)
            ResManager.GetInstance().SetTexture(this,this._Image1,GameResPath.GetIcon("team","ui_content_bg2"))
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            let create_fun = () => {
                let scene_id = SceneManager.GetInstance().GetSceneId()
                if (model.activity_id == local_TeamModel.POLAR_DUN) {
                    // let dunInfo = BaseDungeonModel.GetInstance().getPolarInfo(model.activity_sub_id)
                    // if (dunInfo && dunInfo.dun_score <= 0)
                    // {
                    //     local_Message.show("请先通过单人试炼再进行组队挑战")
                    //     return false
                    // }
                }
                //百鬼夜行组队默认
                if(SceneManager.GetInstance().IsGhostWalkScene()){
                    let config_team_ui_ = Config.PRELOAD_SERVER_CONFIG.config_team_ui
                    let vo = config_team_ui_["10@1"]
                    model.activity_id = vo.activity_id
                    model.activity_sub_id = vo.subtype_id
                    model.min_level = vo.default_lv_min
                    model.max_level = vo.default_lv_max
                }
                model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", model.activity_id, model.activity_sub_id, scene_id, model.min_level, model.max_level, 0)
                return true
            }

            Util.AddClickEvent(this.createBtn, create_fun, this, true)
            let inviteBtn_fun = () => {
                model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamInviteView")
            }

            Util.AddClickEvent(this.inviteBtn, inviteBtn_fun, this, true)
            let targetBtn_fun = () => {
                if ((!model.team_info || model.team_info.team_id <= 0) || model.IsLeaderInTeam(role_mgr.mainRoleInfo.role_id)) {
                    model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamChangeTargetView")
                } else {
                    local_Message.show("您不是队长")
                }
            }

            Util.AddClickEvent(this.targetBtn, targetBtn_fun, this, true)
            let world_btn_fun = () => {
                if (model.IsLeaderInTeam(role_mgr.mainRoleInfo.role_id)) {
                    if (model.world_shout_time && local_TeamModel.WORLD_SHOUT_COOL_TIME > TimeUtil.getServerTime() - model.world_shout_time) {
                        local_Message.show("冷却中")
                    } else {
                        model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24055)
                    }
                } else {
                    local_Message.show("您不是队长")
                }
            }

            Util.AddClickEvent(this.world_btn, world_btn_fun, this, true)
            let applyListBtn_fun = () => {
                if (model.IsLeaderInTeam(role_mgr.mainRoleInfo.role_id)) {
                    model.SetTeamApplyRedDot(false)
                    model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamApplyView")
                } else {
                    local_Message.show("您不是队长")
                }
            }

            Util.AddClickEvent(this.applyListBtn, applyListBtn_fun, this, true)
            let tips_fun = () => {
                let target_cfg = model.GetTaegetCfgById(model.activity_id, model.activity_sub_id)
                if (target_cfg && Trim(target_cfg.desc) != "") {
                    //let pos = new Vector2(this.tips_btn.x,this.tips_btn.y) //this.tips_btn.position
                    let point= new Laya.Point(0,0)
                    let pos=this.tips_btn.localToGlobal(point,false)
                    model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamSmallDescView", point, target_cfg.desc)
                }
            }

            Util.AddClickEvent(this.tips_btn, tips_fun, this, true)
            this.BindEvent(
                GlobalEventSystem,
                EventName.UPDATE_REDDOT, (rType?, key?) => {
                    if (rType != local_ModuleType.TEAM_APPLY) {
                        return
                    }
                    this.SetRedDot()
                }
            )
            let update_my_team_fun = () => {
                this.SetMyTeam()
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, update_my_team_fun)
            let update_team_hall_fun = () => {
                if (_is_create_team) {
                    // 打开界面如果没有队伍，先创建
                    let have_team = model.team_info && model.team_info.team_id != null
                    if ((!this.created_team_flag) && (!have_team)) {
                        this.created_team_flag = true
                        let created = create_fun()
                        if (!created) {
                            this.SetTeamHall()
                        }
                        return
                    }
                    this.created_team_flag = true
                }
                this.SetTeamHall()
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_TERAM_HALL, update_team_hall_fun)
            this.BindEvent(
                model,
                local_TeamEvent.TEAM_WORLD_SHOUT_SUCCESS, () => {
                    this.StartCoolTimer()
                }
            )
            let target_fun = () => {
                this.RefreshTarget()
            }

            this.BindEvent(model, local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, target_fun)
            this.BindEvent(model, local_TeamEvent.TEAM_BUILD_SUCCESS, target_fun)
        }

        this.RequestTeamHall = () => {
            if (!model.team_info || !model.team_info.team_id) {
                model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24012, "cci", model.activity_id, model.activity_sub_id, 0)
            }
        }

        this.OpenCallback = () => {
            this.SetMyTeam()
            this.RefreshTarget()
        }

        this.SetMyTeam = () => {
            let have_team = (model.team_info && model.team_info.team_id) && true || false
            this.SetBtnState(have_team)
            if (have_team) {
                //this.title_img.source = "team_asset.uiqhds_004_2"
                this.created_team_flag = true
                ResManager.GetInstance().SetImageSprite(this, this.title_img, "team_asset", "uiqhds_004_2", true)
                if (!this.group_loop_mgr) {
                    this.SetMyTeamGroup(model.team_info.team_member_list)
                } else {
                    //arrayCollection_:replaceAll(model.team_info.team_member_list)
                    array_list = model.team_info.team_member_list
                    this.group_loop_mgr.replaceAll(model.team_info.team_member_list)
                }
            }
            this.nont_conta.visible = false
            this.SetRedDot()
            this.StartCoolTimer()
        }

        this.SetRedDot = () => {
            let open_state = model.apply_view_open
            if (open_state && RedDotManager.GetInstance().CheckRedStatus(local_ModuleType.TEAM_APPLY)) {
                model.SetTeamApplyRedDot(false)
                //this.applyListDot.visible = RedDotManager.GetInstance( .CheckRedStatus(local_ModuleType.TEAM_APPLY))
                this.applyListDot.visible = false
            } else {
                this.applyListDot.visible = RedDotManager.GetInstance().CheckRedStatus(local_ModuleType.TEAM_APPLY)
            }
        }

        this.SetBtnState = (have_team?) => {
            this.createBtn.visible = !have_team
            this.inviteBtn.visible = have_team
            this.world_btn.visible = have_team
            this.applyListBtn.visible = have_team
            this.team_scroll.visible = have_team
            this.hall_sroll.visible = !have_team
        }

        this.SetMyTeamGroup = (member_list?) => {
            array_list = member_list
            //this.scroll_group.dataProvider = arrayCollection_
            //this.scroll_group.itemRenderer = TeamRoleItem
            if (!this.group_loop_mgr) {
                this.group_loop_mgr = new LoopScrowViewMgr()
                this.group_loop_mgr.SetData(this.team_scroll, TeamRoleItem, array_list, LoopScrCon.Vertical, 1)
            } else {
                this.group_loop_mgr.replaceAll(array_list)
            }
        }

        this.SetTeamHall = () => {
            let have_team = model.team_info && model.team_info.team_id != null
            if (!have_team) {
                //this.title_img.source = "team_asset.uiqhds_004_1"
                ResManager.GetInstance().SetImageSprite(this, this.title_img, "team_asset", "uiqhds_004_2", true)
                this.SetBtnState(false)
                if (model.team_hall) {
                    if (!hallarray_list) {
                        this.SetTeamHallGroup(model.team_hall)
                    } else {
                        //hallArrayCollection_:replaceAll(model.team_hall)
                        hallarray_list = model.team_hall
                        this.CheckHallLoopMgr(hallarray_list)
                    }
                    this.nont_conta.visible = model.team_hall.length <= 0
                }
            }
        }

        this.CheckHallLoopMgr = (list?) => {
            if (!this.hall_loop_mgr) {
                this.hall_loop_mgr = new LoopScrowViewMgr()
                this.hall_loop_mgr.SetData(this.hall_sroll, TeamHallItem, list, LoopScrCon.Vertical, 1)
            } else {
                this.hall_loop_mgr.replaceAll(list)
            }
        }

        this.SetTeamHallGroup = (team_enlist?) => {
            hallarray_list = team_enlist
            //this.hall_scroll_group.dataProvider = hallArrayCollection_
            //this.hall_scroll_group.itemRenderer = TeamHallItem

            this.CheckHallLoopMgr(hallarray_list)
        }

        this.StartCoolTimer = () => {
            this.CancelTimer()
            if (model.world_shout_time) {
                count_time_id_ = GlobalTimerQuest.AddPeriodQuest((target?) => {
                    this.OnTime()
                },
                    1)
                this.OnTime()
            }
        }

        this.OnTime = () => {
            if (model.world_shout_time) {
                let left_time = local_TeamModel.WORLD_SHOUT_COOL_TIME + model.world_shout_time - TimeUtil.getServerTime()
                if (left_time < 0) {
                    this.CancelTimer()
                    this.shout_txt.text = "世界喊话"
                    model.world_shout_time = null
                    return
                }
                if (this.shout_txt) {
                    this.shout_txt.text = left_time + "s"
                }
            }
        }

        this.CancelTimer = () => {
            if (count_time_id_) {
                GlobalTimerQuest.CancelQuest(count_time_id_)
                count_time_id_ = null
            }
        }

        this.RefreshTarget = () => {
            let target_cfg = model.GetTaegetCfgById(model.activity_id, model.activity_sub_id)
            if (target_cfg) {
                this.target_label.width=350
                let str = "组队目标：<font color='#cb661b'>" + model.min_level + (" - ") + model.max_level + "级  "+"</font>"+ "<br/>" +"<font color='#cb661b'>"+ target_cfg.subtype_name + "</font>"
                // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
                // 	str = "Team Target: <font color=0x639c12>Lv." + model.min_level + (" - ") + model.max_level + "   " + target_cfg.subtype_name + "</font>"
                // }
                this.target_label.innerHTML = Util.StrToHTML(str)
            }
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }

    public DeleteMe() {
        this.created_team_flag = false
        if (this.hall_loop_mgr) {
            this.hall_loop_mgr.DeleteMe()
            this.hall_loop_mgr = null
        }

        if (this.group_loop_mgr) {
            this.group_loop_mgr.DeleteMe()
            this.group_loop_mgr = null
        }
    }


    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this._Image2,
            this.title_img,
            this._con_img_right,
            this._Image3,
            this.closeBtn,
            this._Image4,
            this.Separate_img,
            this.team_scroll,
            this.hall_sroll,
            this.target_label,
            this.targetBtn,
            this._Image5,
            this._Label1,
            this.inviteBtn,
            this._Image6,
            this._Label2,
            this.world_btn,
            this._Image7,
            this.shout_txt,
            this.applyListBtn,
            this._Image8,
            this._Label3,
            this.applyListDot,
            this.createBtn,
            this._Image9,
            this._Label4,
            this.nont_conta,
            this.tips,
            this.tips_icon,
            this.tips_btn,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Group1",
                "_Image2",
                "title_img",
                "_con_img_right",
                "_Image3",
                "closeBtn",
                "_Image4",
                "Separate_img",
                "team_scroll",
                "hall_sroll",
                "target_label",
                "targetBtn",
                "_Image5",
                "_Label1",
                "inviteBtn",
                "_Image6",
                "_Label2",
                "world_btn",
                "_Image7",
                "shout_txt",
                "applyListBtn",
                "_Image8",
                "_Label3",
                "applyListDot",
                "createBtn",
                "_Image9",
                "_Label4",
                "nont_conta",
                "tips",
                "tips_icon",
                "tips_btn",
            ])
        this.target_label.style.fontSize=20
        this.target_label.style.color="#663915"
        this.target_label.style.leading=10
        this.hall_sroll.scrollBar.visible=false
        this.team_scroll.scrollBar.visible=false
    }
}
window["TeamView"]=TeamView