import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DungeonEquipDefine } from "../dungeonEquip/DungeonEquipDefine"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { EventDispatcher } from "../util/EventDispatcher"
import { Status } from "../util/Status"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { FriendModel, FriendEvent } from "./FriendModel"
import { Config } from "../common/Config"
import { TaskModel } from "./TaskModel"

export let PlayerType = {
    Area: 1,
    Guild: 2,
    Frined: 3
}
export let TeamEvent = {
    TEAM_REQUEST_PROTO: "TEAM_REQUEST_PROTO",
    TEAM_REQUEST_OTHER_PROTO: "TEAM_REQUEST_OTHER_PROTO",
    TEAM_OPEN_VIEW: "TEAM_OPEN_VIEW",
    TEAM_CLOSE_VIEW: "TEAM_CLOSE_VIEW",
    TEAM_CLOSE_ALL_VIEW: "TEAM_CLOSE_ALL_VIEW",
    TEAM_UPDATE_TERAM_INFO: "TEAM_UPDATE_TERAM_INFO",
    TEAM_UPDATE_TERAM_HALL: "TEAM_UPDATE_TERAM_HALL",
    TEAM_UPDATE_APPLY_LIST: "TEAM_UPDATE_APPLY_LIST",
    TEAM_WORLD_SHOUT_SUCCESS: "TEAM_WORLD_SHOUT_SUCCESS",
    TEAM_UPDATE_NEAR_BY_PLAYER: "TEAM_UPDATE_NEAR_BY_PLAYER",
    TEAM_UPDATE_BE_INVITED_LIST: "TEAM_UPDATE_BE_INVITED_LIST",
    TEAM_CHANGE_TARGET_SUCCESS: "TEAM_CHANGE_TARGET_SUCCESS",
    TEAM_CHANGE_JOIN_TYPE: "TEAM_CHANGE_JOIN_TYPE",
    TEAM_UPDATE_VOTE_DATA: "TEAM_UPDATE_VOTE_DATA",
    TEAM_UPDATE_ZHAO_MU_DATA: "TEAM_UPDATE_ZHAO_MU_DATA",
    TEAM_BUILD_SUCCESS: "TEAM_BUILD_SUCCESS",
    UPDATE_MATCH_STATE: "UPDATE_MATCH_STATE",
    START_MATCH: "START_MATCH",
    UPDATE_HELP_STATE: "UPDATE_HELP_STATE",
    UPDATE_INVITE_DATA: "UPDATE_INVITE_DATA",
    UPDATE_TEAM_INVITE_DATA: "UPDATE_TEAM_INVITE_DATA",
    QUIT_TEAM_SUCCESS: "QUIT_TEAM_SUCCESS",
    TEAM_VIEW_IS_CLOSE: "TEAM_VIEW_IS_CLOSE",
    TEAM_CHANGE_TARGET_SELECTED: "TEAM_CHANGE_TARGET_SELECTED",
    BEFORE_TEAMMATE_CHANGE_SCENE: "BEFORE_TEAMMATE_CHANGE_SCENE",
}
// [ts2lua]window下标访问可能不正确
window["PlayerType"] = PlayerType
// [ts2lua]window下标访问可能不正确
window["TeamEvent"] = TeamEvent
export class TeamModel extends EventDispatcher {
    AddMatchTryFunc
    CancelCountTime
    ChangeTargetSuccess
    ClearTeamInfo
    DeleteBeInvited
    DeleteOneTeammate
    GetAllFieldScene
    GetInviteIntervalState
    GetOnlineStateImg
    GetOnlineStateStr
    GetOnlineVo
    GetTaegetCfgById
    GetTargetAllcfg
    InShowJoinID
    InitConfig
    InviteJoinTeam
    IsHelperState
    IsInShiledState
    IsLeaderInTeam
    MyTeammateOnlineChange
    MyTeammateSceneChange
    RemoveMatchTryFunc
    SHOW_JOIN_ID
    SetApplyList
    SetInviteIntervalState
    SetMyHelpState
    SetNearByPlayer
    SetTeamApplyRedDot
    SetVoteData
    SetZhaoMuLIst
    StartMatchCountTime
    UpdateBeInvitedList
    UpdateHelpState
    UpdateShieldList
    UpdateTeamHall
    UpdateTeamInfo
    UpdateTeamLeader
    _auto_match
    activity_id
    activity_sub_id
    apply_list
    apply_view_open
    be_invited_list
    cancel_match_text
    help_data
    joinImage
    joinName
    join_con_value
    match_time_count
    match_try_func_dic
    max_level
    min_level
    near_by_player
    quit_team_enter
    quit_team_match
    single_match_state
    team_hall
    team_info
    team_view_open
    vote_data
    zhao_mu_list
    map_cfgs
    IsOpenTeam // 是否解锁组队功能
    public static TEAMER_MAX = 3
    public static WORLD_SHOUT_COOL_TIME = 5
    public static SHOW_TEAM_LV = 50
    public static POLAR_DUN = 7


    static Instance: TeamModel
    public constructor() {


        super()

        if (TeamModel.Instance) {
            return
        }
        TeamModel.Instance = this
        this.SHOW_JOIN_ID = [TeamModel.POLAR_DUN]
        this.activity_id = 1
        this.activity_sub_id = 0
        this.min_level = 1
        this.max_level = 999
        this.team_view_open = false
        this.apply_view_open = false
        this.single_match_state = false
        this.quit_team_match = false
        this.quit_team_enter = false
        this._auto_match = false
        this.match_time_count = 0
        // let preload_client_config = Config.PRELOAD_CLIENT_CONFIG
        let local_TeamEvent = TeamEvent
        let scene_mgr = SceneManager.GetInstance()
        let friend_mgr = FriendModel.GetInstance()
        let role_mgr = RoleManager.GetInstance()
        let activity_scene_id_ = 0
        let shield_list_ = null
        let config_team_ui_ = null
        let target_tab_data_ = null
        let all_field_scene_ = null
        let match_time_id_ = null
        let match_time_func_ = null
        let invite_time_interval_dic_ = null
        this.InitConfig = () => {
            //config_team_ui_ = Config.Teamui
            config_team_ui_ = Config.PRELOAD_SERVER_CONFIG.config_team_ui
            this.map_cfgs = Config.PRELOAD_CLIENT_CONFIG.ClientMapConfig
        }

        this.InShowJoinID = (id?) => {
            for (let _ in this.SHOW_JOIN_ID) {
                var showId = this.SHOW_JOIN_ID[_]
                if (id == showId) {
                    return true
                }
            }
            return false
        }

        this.UpdateTeamInfo = (scmd?) => {
            this.team_info = scmd
            let sort_fun = (a?, b?) => {
                if (a.team_position != b.team_position) {
                    return a.team_position < b.team_position
                }
                return false
            }

            if (this.team_info && this.team_info.team_member_list) {
                table.sort(this.team_info.team_member_list, sort_fun)
            }
            this.activity_id = scmd.activity_id
            this.activity_sub_id = scmd.subtype
            this.min_level = scmd.min_lv
            this.max_level = scmd.max_lv
            this.join_con_value = scmd.join_con_value
            this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
        }

        this.ClearTeamInfo = () => {
            this.team_info = null
            this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
        }

        this.DeleteOneTeammate = (role_id?) => {
            if (this.team_info && this.team_info.team_member_list) {
                let vo = null

                for (let i = this.team_info.team_member_list.length - 1; i >= 0; i -= 1) {
                    vo = this.team_info.team_member_list[i]
                    if (vo.id == role_id) {
                        table.remove(this.team_info.team_member_list, i)
                        break
                    }
                }
                this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
            }
        }

        this.UpdateTeamLeader = (role_id?) => {
            if (this.team_info && this.team_info.team_member_list) {
                for (let _tmpi in this.team_info.team_member_list) {
                    var vo = this.team_info.team_member_list[_tmpi]
                    if (vo.id == role_id) {
                        vo.team_position = 1
                    } else {
                        vo.team_position = 0
                    }
                }
                this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
            }
        }

        this.MyTeammateSceneChange = (role_id?, scene_id?) => {
            if (this.team_info && this.team_info.team_member_list) {
                for (let _tmpi in this.team_info.team_member_list) {
                    var vo = this.team_info.team_member_list[_tmpi]
                    if (vo.id == role_id) {
                        vo.scene_id = scene_id
                        break
                    }
                }
                this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
            }
        }

        this.MyTeammateOnlineChange = (role_id?, online?) => {
            if (this.team_info && this.team_info.team_member_list) {
                for (let _tmpi in this.team_info.team_member_list) {
                    var vo = this.team_info.team_member_list[_tmpi]
                    if (vo.id == role_id) {
                        vo.online = online
                        break
                    }
                }
                this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
            }
        }

        this.UpdateTeamHall = (scmd?) => {
            this.team_hall = scmd.team_enlist
            let sort_fun = (a?, b?) => {
                if (a.num != b.num) {
                    return a.num > b.num
                }
                return false
            }

            table.sort(this.team_hall, sort_fun)
            this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_HALL, scmd.activity_id, scmd.subtype)
        }

        this.SetTeamApplyRedDot = (bool?) => {
            RedDotManager.GetInstance().SetRedStatus(ModuleType.TEAM_APPLY, 1, bool)
        }

        this.SetApplyList = (scmd?) => {
            let real_list = []
            if (scmd) {
                for (let _tmpi in scmd) {
                    var vo = scmd[_tmpi]
                    if (!this.IsInShiledState(vo.player_id)) {
                        table.insert(real_list, vo)
                    }
                }
            }
            this.apply_list = real_list
            this.Fire(local_TeamEvent.TEAM_UPDATE_APPLY_LIST)
        }

        this.IsLeaderInTeam = (role_id?) => {
            let is_leader = false
            if ((this.team_info && this.team_info.team_member_list) && this.team_info.team_member_list.length > 0) {
                for (let _tmpi in this.team_info.team_member_list) {
                    var vo = this.team_info.team_member_list[_tmpi]
                    if (vo.id == role_id && vo.team_position == 1) {
                        is_leader = true
                        break
                    }
                }
            }
            return is_leader
        }

        this.UpdateShieldList = (role_id?) => {
            if (!shield_list_) {
                shield_list_ = []
            }
            // [ts2lua]shield_list_下标访问可能不正确
            shield_list_[role_id] = Status.NowTime
        }

        this.IsInShiledState = (role_id?) => {
            let is_in_state = false
            // [ts2lua]shield_list_下标访问可能不正确
            // [ts2lua]shield_list_下标访问可能不正确
            if ((shield_list_ && shield_list_[role_id]) && Status.NowTime - shield_list_[role_id] < 60 * 10) {
                is_in_state = true
            }
            return is_in_state
        }

        this.GetOnlineStateStr = (online?, scene_id?, role_id?) => {
            let str = ""
            if (role_id != role_mgr.mainRoleInfo.role_id) {
                if (online == 1) {
                    let my_scene_id = scene_mgr.GetSceneId()
                    let is_same_field_scene = scene_mgr.IsFieldScene(my_scene_id) && scene_mgr.IsFieldScene(scene_id)
                    // [ts2lua]lua中0和空字符串也是true，此处is_same_field_scene || my_scene_id == scene_id需要确认
                    str = ((is_same_field_scene || my_scene_id == scene_id) && ("<font color='#0a953e'>附近</font>") || ("<font color='#ff4f50'>远离</font>"))
                } else {
                    str = "<font color='#9c9c9c'>离线</font>"
                }
            }
            return str
        }

        this.GetOnlineStateImg = (online?, scene_id?, role_id?) => {
            let str = ""
            if (role_id != role_mgr.mainRoleInfo.role_id) {
                if (online == 1) {
                    let my_scene_id = scene_mgr.GetSceneId()
                    let is_same_field_scene = scene_mgr.IsFieldScene(my_scene_id) && scene_mgr.IsFieldScene(scene_id)
                    // [ts2lua]lua中0和空字符串也是true，此处is_same_field_scene || my_scene_id == scene_id需要确认
                    str = ((is_same_field_scene || my_scene_id == scene_id) && ("uirwl_013") || ("uirwl_012"))
                } else {
                    str = "uirwl_012a_1"
                }
            }
            return str
        }

        this.SetNearByPlayer = (scmd?) => {
            this.near_by_player = []
            if (scmd) {
                for (let _tmpi in scmd) {
                    var vo = scmd[_tmpi]
                    table.insert(this.near_by_player, vo)
                }
            }
            this.Fire(local_TeamEvent.TEAM_UPDATE_NEAR_BY_PLAYER)
        }

        this.GetOnlineVo = (_type?) => {
            let list = []
            if (_type == PlayerType.Area) {
                if (this.near_by_player) {
                    for (let _tmpi in this.near_by_player) {
                        var vo = this.near_by_player[_tmpi]
                        vo.online_flag = 1
                        table.insert(list, vo)
                    }
                }
            } else {
                // [ts2lua]this.zhao_mu_list下标访问可能不正确
                if (this.zhao_mu_list && this.zhao_mu_list[_type]) {
                    // [ts2lua]this.zhao_mu_list下标访问可能不正确
                    list = this.zhao_mu_list[_type]
                }
            }
            return list
        }

        this.UpdateBeInvitedList = (scmd?) => {
            if (!this.be_invited_list) {
                this.be_invited_list = []
            }
            let vo = null
            if (scmd) {

                for (let i = this.be_invited_list.length - 1; i >= 0; i -= 1) {
                    vo = this.be_invited_list[i]
                    // 同一个人的覆盖
                    if (vo.team_id == scmd.team_id || vo.inviter_id == scmd.inviter_id) {
                        //this.be_invited_list.splice(i, 1)
                        table.remove(this.be_invited_list, i)
                    }
                }
                table.insert(this.be_invited_list, scmd)
            }
            this.Fire(local_TeamEvent.TEAM_UPDATE_BE_INVITED_LIST)
        }

        this.DeleteBeInvited = (scmd?) => {
            if (this.be_invited_list) {
                let vo = null
                if (scmd) {
                    let i = 0
                    do {
                        vo = this.be_invited_list[i]
                        if (vo.team_id == scmd.team_id) {
                            //this.be_invited_list.splice(i, 1)
                            table.remove(this.be_invited_list, 0)
                            break
                        }
                        i = i + 1
                    } while ((i < this.be_invited_list.length))
                }
                this.Fire(local_TeamEvent.TEAM_UPDATE_BE_INVITED_LIST)
            }
        }

        this.GetTargetAllcfg = () => {
            if (!target_tab_data_) {
                target_tab_data_ = []
                let vo = null
                if (!config_team_ui_) {
                    return target_tab_data_
                }
                for (let key in config_team_ui_) {

                    // [ts2lua]config_team_ui_下标访问可能不正确
                    vo = config_team_ui_[key]
                    table.insert(target_tab_data_, vo)
                }
                let sort_fun = (a?, b?) => {
                    if (a.activity_id != b.activity_id) {
                        return a.activity_id < b.activity_id
                    }
                    else if (a.subtype_id != b.subtype_id) {
                        return a.subtype_id < b.subtype_id
                    }
                    return false
                }

                table.sort(target_tab_data_, sort_fun)
            }
            return target_tab_data_
        }

        this.ChangeTargetSuccess = (scmd?, not_show?) => {
            this.activity_id = scmd.activity_id
            this.activity_sub_id = scmd.subtype
            activity_scene_id_ = scmd.scene_id
            this.min_level = scmd.min_lv
            this.max_level = scmd.max_lv
            this.join_con_value = scmd.join_con_value
            this.Fire(local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS)
            if (!not_show) {
                Message.show("更改目标成功")
            }
            this.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24012, "cci", this.activity_id, this.activity_sub_id, activity_scene_id_)
        }

        this.GetTaegetCfgById = (activity_id?, activity_sub_id?) => {
            let list = this.GetTargetAllcfg()
            let cfg = null
            if (list) {
                for (let _tmpi in list) {
                    var vo = list[_tmpi]
                    if (vo.activity_id == activity_id && vo.subtype_id == activity_sub_id) {
                        cfg = vo
                        break
                    }
                }
            }
            return cfg
        }

        this.InviteJoinTeam = (role_id?, server_id?) => {
            let fdata = friend_mgr.getFriendById(role_id)
            let main_role = RoleManager.GetInstance().GetMainRoleVo().server_id
            if (!fdata && server_id && main_role && main_role == server_id) {
                friend_mgr.Fire(FriendEvent.ADD_FRIEND, role_id)
            }
            let scene_id = scene_mgr.GetSceneId()
            
            if (server_id && main_role != server_id)
                this.Fire(local_TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24057, [[server_id, role_id]])
            else
                this.Fire(local_TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24006, [this.activity_id, this.activity_sub_id, scene_id, this.min_level, this.max_level, [role_id]])
        }

        this.GetAllFieldScene = () => {
            if (this.map_cfgs) {
                if (!all_field_scene_) {
                    all_field_scene_ = []
                }
                for (let key in this.map_cfgs) {

                    // [ts2lua]preload_client_config.ClientMapConfig下标访问可能不正确
                    let scene = this.map_cfgs[key]
                    if (scene.is_field_scene == 1) {
                        table.insert(all_field_scene_, scene)
                    }
                }
                let sort_fun = (a?, b?) => {
                    if (a.scene_id != b.scene_id) {
                        return a.scene_id > b.scene_id
                    }
                    return false
                }

                table.sort(all_field_scene_, sort_fun)
            }
            return all_field_scene_
        }

        this.SetZhaoMuLIst = (scmd?) => {
            if (!this.zhao_mu_list) {
                this.zhao_mu_list = []
            }
            // [ts2lua]this.zhao_mu_list下标访问可能不正确
            this.zhao_mu_list[scmd.type] = scmd.array_list
            this.Fire(local_TeamEvent.TEAM_UPDATE_ZHAO_MU_DATA, scmd.type)
        }

        this.SetVoteData = (scmd?) => {
            if (!this.vote_data) {
                this.vote_data = []
            }
            // [ts2lua]this.vote_data下标访问可能不正确
            this.vote_data[scmd.role_id] = scmd
            this.Fire(local_TeamEvent.TEAM_UPDATE_VOTE_DATA)
        }

        this.UpdateHelpState = (scmd?) => {
            let team_info = this.team_info
            if (team_info) {
                for (let _tmpi in scmd.help_type_list) {
                    var help_data = scmd.help_type_list[_tmpi]
                    for (let _tmpi in team_info.team_member_list) {
                        var vo = team_info.team_member_list[_tmpi]
                        if (vo.id == help_data.role_id) {
                            vo.help_type = help_data.help_type
                            break
                        }
                    }
                }
                this.Fire(local_TeamEvent.TEAM_UPDATE_TERAM_INFO)
            }
        }

        this.SetMyHelpState = (scmd?) => {
            if (!this.help_data) {
                this.help_data = {}
            }
            // [ts2lua]this.help_data下标访问可能不正确
            this.help_data[scmd.dun_id] = scmd.state
            this.Fire(local_TeamEvent.UPDATE_HELP_STATE, scmd.dun_id)
        }

        this.StartMatchCountTime = (func?) => {
            this.CancelCountTime()
            match_time_func_ = func
            match_time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1)
            func()
        }

        this.CancelCountTime = () => {
            if (match_time_id_) {
                this.match_time_count = 0
                GlobalTimerQuest.CancelQuest(match_time_id_)
                match_time_id_ = null
            }
        }

        this.AddMatchTryFunc = (hash_code?, func?) => {
            if (!this.match_try_func_dic) {
                this.match_try_func_dic = {}
            }
            // [ts2lua]this.match_try_func_dic下标访问可能不正确
            this.match_try_func_dic[hash_code] = func
        }

        this.RemoveMatchTryFunc = (hash_code?) => {
            if (this.match_try_func_dic) {
                // [ts2lua]this.match_try_func_dic下标访问可能不正确
                delete this.match_try_func_dic[hash_code]
            }
        }

        this.SetInviteIntervalState = (role_id?) => {
            if (!invite_time_interval_dic_) {
                invite_time_interval_dic_ = []
            }
            // [ts2lua]invite_time_interval_dic_下标访问可能不正确
            invite_time_interval_dic_[role_id] = TimeUtil.getServerTime() + DungeonEquipDefine.InviteInterval
        }

        this.GetInviteIntervalState = (role_id?) => {
            // [ts2lua]invite_time_interval_dic_下标访问可能不正确
            return invite_time_interval_dic_ && invite_time_interval_dic_[role_id]
        }

        this.IsHelperState = () => {
            let team_info = this.team_info
            if (team_info) {
                for (let _tmpi in team_info.team_member_list) {
                    var vo = team_info.team_member_list[_tmpi]
                    if (vo.id == role_mgr.GetMainRoleId()) {
                        return vo.help_type == 1
                    }
                }
            } else {
                return false
            }
        }

        this.joinImage = (activity_id?, join_value?) => {
            if (activity_id == 7) {
                let switch1
                switch1 = {
                    "1": "uijdfb_016",
                    "2": "uijdfb_017",
                    "3": "uijdfb_018",
                    "default": "uijdfb_016"
                }

                let casef = switch1[join_value]
                if (!casef) {
                    casef = switch1["default"]
                }
                if (casef) {
                    //let img = casef()
                    return casef
                }
            }
        }

        this.joinName = (activity_id?, join_value?) => {
            if (activity_id == 7) {
                let switch1
                switch1 = {
                    "1": "普通",
                    "2": "完美",
                    "3": "史诗",
                    "default": "无"
                }

                let casef = switch1[join_value]
                if (!casef) {
                    casef = switch1["default"]
                }
                if (casef) {
                    return casef
                }
            }
        }
        this.IsOpenTeam = () => {
            let task_info = TaskModel.GetInstance().GetMainLineTaskVo()
            let target_task = TaskModel.GetInstance().GetTaskCfg(101260)
            if (task_info == null) return true
            if (task_info.task_id <= target_task.id) {
                Message.show("完成" + target_task.name + "任务开启")
                return false
            }
            return true
        }
    }

    public static GetInstance() {

        if (!TeamModel.Instance) {
            TeamModel.Instance = new TeamModel()
        }
        return TeamModel.Instance
    }

    public SetAutoMatch(value?) {

        if (this._auto_match == value) {
            return
        }
        if (value) {
            this.match_time_count = 0
            this.StartMatchCountTime(() => {
                this.match_time_count = this.match_time_count + 1
                if (this.match_try_func_dic) {
                    for (let hash_code in this.match_try_func_dic) {

                        // [ts2lua]this.match_try_func_dic下标访问可能不正确
                        let func = this.match_try_func_dic[hash_code]
                        if (func) {
                            func(this.match_time_count)
                        }
                    }
                }
            }
            )
        } else {
            this.Fire(TeamEvent.TEAM_CLOSE_VIEW, "TeamMatchView")
            this.CancelCountTime()
        }
        this._auto_match = value
    }

    public GetAutoMatch() {

        return this._auto_match
    }

    public SetCancelMatchText(cancel_match_text?) {

        this.cancel_match_text = cancel_match_text
    }

    public GetCancelMatchText() {

        return this.cancel_match_text
    }
}

window["TeamModel"] = TeamModel