import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPositionX, Trim, HtmlColorTxt, SetSizeDeltaX, GlobalTimerQuest, SetHtmlCenter, RefBoxChildsLayout } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { TaskModel } from "../commonModel/TaskModel"

export class TeamVoteView extends BaseView1 {
    CancelTime
    InitEvent
    InitRole
    InitView
    AddArrow
    LoadSuccess
    Local_Open
    Remove
    StartTime
    UpdateVote
    destroy_callback
    is_center
    show_open_movie
    use_background
    list_head = []
    public static ProgressWidth = 491
    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamVoteView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.is_center = true
        this.show_open_movie = true
        let model = TeamModel.GetInstance()

        let local_TeamEvent = TeamEvent
        let local_Util = Util
        let role_mgr = RoleManager.GetInstance()
        let local_TimeUtil = TimeUtil
        let local_laya = Laya
        let data_ = null
        let id_to_index_ = null
        let time_func_ = null
        let time_id_ = null
        this.preload_server_config = {
            "config_dress_up_cfg": false
        }
        this.load_callback = () => {
            this._lb_desc.style.fontSize = 20
            this._lb_desc.style.color = "#663915"
            this.LoadSuccess()

            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIconOtherPath("team", "ui_copy_75"))
        }

        this.destroy_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            this.CancelTime()
            if(this.list_head.length > 0){
                for(let i = 0;i < this.list_head.length;i++){
                    this.list_head[i]?.DeleteMe()
                }
                this.list_head.length = 0
            }
        }

        this.Local_Open = (parms?) => {
            if (parms) {
                data_ = parms
            }
            super.Open()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("team", "ui_copy_76"))
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("team", "uizbfb_032"))
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("team", "uizbfb_034"))
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._img_progress, GameResPath.GetIcon("team", "uizbfb_033"))
            this.InitRole()
            this.InitView()
            this.UpdateVote()
            this.InitEvent()
            let task = TaskModel.GetInstance().GetMainLineTaskVo()

            if (task && task.task_id == 101270) {
                this.AddArrow()
            }

        }

        this.InitEvent = () => {
            this.BindEvent(
                model, local_TeamEvent.TEAM_UPDATE_VOTE_DATA, () => {
                    this.UpdateVote()
                }
            )


            //有些时候界面先打开，没收到队伍的信息就显示空了
            this.BindEvent(
                model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                    this.InitRole()
                }
            )

            Util.AddClickEvent(
                this._gp_go, () => {
                    let data = data_
                    if (!data) {
                        return
                    }
                    let vote_data = model.vote_data
                    // [ts2lua]vote_data下标访问可能不正确
                    if (vote_data && vote_data[role_mgr.GetMainRoleId()]) {
                        Message.show("您已经做出选择,请稍候")
                        return
                    }
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._gp_go)
                    model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24021, "hc", data.arbitrate_id, 1)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._gp_refuse, () => {
                    let data = data_
                    if (!data) {
                        return
                    }
                    let vote_data = model.vote_data
                    // [ts2lua]vote_data下标访问可能不正确
                    if (vote_data && vote_data[role_mgr.GetMainRoleId()]) {
                        Message.show("您已经做出选择,请稍候")
                        return
                    }
                    model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24021, "hc", data.arbitrate_id, 0)
                },
                this,
                true
            )
        }

        this.InitRole = () => {
            let team_info = model.team_info
            id_to_index_ = []
            if (team_info) {
                let i = 0
                do {
                    let vo = team_info.team_member_list[i]
                    if (vo) {
                        id_to_index_[vo.id] = i
                        this["_gp" + i].visible = true
                        this["_lb_name" + i].text = vo.name

                        //头像
                        // let _source = vo.career + "001"
                        // if (vo.picture && Trim(vo.picture) != "") {
                        //     let picture_cfg =ResManager.GetInstance().GetGameConfigFromCache(this,"config_picture",false)[vo.picture]
                        //     //this.preload_server_config["config_picture"][vo.picture]
                        //     if (picture_cfg) {
                        //         _source = picture_cfg.resource
                        //     }
                        // }
                        // ResManager.GetInstance().SetOutsideImageSprite(this, this["_img_head" + i], GameResPath.GetIcon("head", _source))

                        let headItem = this.list_head[i]
                        if (!headItem) {
                            headItem = new CustomHeadItem(this["_img_head" + i])
                            headItem.Load()
                            this.list_head[i] = headItem
                        }
                        headItem.SetRoleVoData(vo, vo.turn, vo.server_id)


                    } else {
                        this["_gp" + i].visible = false
                    }
                    i = i + 1
                } while ((i < 3))
            }

            RefBoxChildsLayout(this._Group2, 50, 142, true)
        }

        this.InitView = () => {
            let data = data_
            if (data) {
                let cfg = model.GetTaegetCfgById(data.activity_id, data.subtype)
                if (cfg) {
                    let desc = "您将要进行"
                    desc = desc + HtmlColorTxt(cfg.subtype_name, "'#0a953e'")
                    desc = desc + "是否前往?"
                    this._lb_desc.innerHTML = Util.StrToHTML(desc)
                    this._lb_desc.style.width = 472
                    SetHtmlCenter(this._lb_desc, { x: 71, w: 472 })
                }
                let end_time = data.end_time
                let max_left_time = end_time - local_TimeUtil.getServerTime()
                this.StartTime(() => {
                    let left_time = end_time - local_TimeUtil.getServerTime()
                    if (left_time <= 0) {
                        this.CancelTime()
                        this._lb_time.text = ""
                        return
                    }
                    this._lb_time.text = local_TimeUtil.timeConvert(left_time, "mm:ss")
                    //this._img_progress.width = left_time / max_left_time * TeamVoteView.ProgressWidth
                    SetSizeDeltaX(this._img_progress, left_time / max_left_time * TeamVoteView.ProgressWidth)
                }
                )
            }
        }

        this.UpdateVote = () => {
            let vote_data = model.vote_data
            let data = data_
            if (vote_data && data) {
                for (let role_id in vote_data) {

                    let value = vote_data[role_id]
                    if (value && value.arbitrate_id == data.arbitrate_id) {
                        let index = id_to_index_[role_id]
                        if (index != null) {
                            this["_img_tips" + index].visible = true
                            //this["img_img_tips" + index].source = (value.res == 1 && ( "common_asset.uihsl_001" ) || ( "common_asset.uizbfb_050" ) )
                            let sp_name = (value.res == 1) && "ui_27" || "uizbfb_050"
                            ResManager.GetInstance().SetImageSprite(this, this["_img_tips" + index], "common_asset", sp_name, true)
                        }
                    }
                }
            }
        }

        this.StartTime = (func?) => {
            this.CancelTime()
            time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1)
            func()
        }

        this.CancelTime = () => {
            if (time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_)
                time_id_ = null
            }
        }
        this.AddArrow = () => {
            let step_cfg = { text: "全员准备后即可开启挑战之旅!", direction: 8, "effect_scaleX": 0.65, "effect_scaleY": 0.9, close_time: 5,"off_y": 15 }
            GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._gp_go, this.layer_value, false, false, false, true, step_cfg, true)
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }


    public DeleteMe() {
        super.DeleteMe()
    }



    _Image1: Laya.Image
    _Image2_t: Laya.Image
    _lb_win_name: Laya.Label
    _Image4: Laya.Image
    _img_bg: Laya.Image
    _img_close: Laya.Image
    _Group2: Laya.Box
    _gp0: Laya.Box
    _Image5: Laya.Image
    _img_head0: Laya.Box
    _lb_name0: Laya.Label
    _img_tips0: Laya.Image
    _gp1: Laya.Box
    _Image51: Laya.Image
    _img_head1: Laya.Box
    _lb_name1: Laya.Label
    _img_tips1: Laya.Image
    _gp2: Laya.Box
    _Image52: Laya.Image
    _img_head2: Laya.Box
    _lb_name2: Laya.Label
    _img_tips2: Laya.Image
    _img_bg1: Laya.Image
    _lb_desc: Laya.HTMLDivElement
    _img_bg0: Laya.Image
    _img_progress: Laya.Image
    _Label2: Laya.Label
    _lb_time: Laya.Label
    _gp_refuse: Laya.Box
    _Image11: Laya.Image
    _Label3: Laya.Label
    _gp_go: Laya.Box
    _Image12: Laya.Image
    _Label4: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image2_t,
            this._lb_win_name,
            this._Image4,
            this._img_bg,
            this._img_close,
            this._Group2,
            this._gp0,
            this._Image5,
            this._img_head0,
            this._lb_name0,
            this._img_tips0,
            this._gp1,
            this._Image51,
            this._img_head1,
            this._lb_name1,
            this._img_tips1,
            this._gp2,
            this._Image52,
            this._img_head2,
            this._lb_name2,
            this._img_tips2,
            this._img_bg1,
            this._lb_desc,
            this._img_bg0,
            this._img_progress,
            this._Label2,
            this._lb_time,
            this._gp_refuse,
            this._Image11,
            this._Label3,
            this._gp_go,
            this._Image12,
            this._Label4,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2_t",
                "_lb_win_name",
                "_Image4",
                "_img_bg",
                "_img_close",
                "_Group2",
                "_gp0",
                "_Image5",
                "_img_head0",
                "_lb_name0",
                "_img_tips0",
                "_gp1",
                "_Image51",
                "_img_head1",
                "_lb_name1",
                "_img_tips1",
                "_gp2",
                "_Image52",
                "_img_head2",
                "_lb_name2",
                "_img_tips2",
                "_img_bg1",
                "_lb_desc",
                "_img_bg0",
                "_img_progress",
                "_Label2",
                "_lb_time",
                "_gp_refuse",
                "_Image11",
                "_Label3",
                "_gp_go",
                "_Image12",
                "_Label4",
            ])
    }
}
window["TeamVoteView"] = TeamVoteView