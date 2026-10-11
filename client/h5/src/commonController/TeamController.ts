
//require("game.team.TeamApplyRoleItem")
//require("game.team.TeamApplyView")
//require("game.team.TeamBeInvitedRoleItem")
//require("game.team.TeamBeInvitedView")
//require("game.team.TeamChangeTargetTab")
//require("game.team.TeamChangeTargetView")
//require("game.team.TeamHallItem")
//require("game.team.TeamInviteRoleItem")
//require("game.team.TeamInviteView")
//require("game.team.TeamMatchView")
//require("game.team.TeamModel")
//require("game.team.TeamRoleItem")
//require("game.team.TeamMainRoleItem")
//require("game.team.TeamSmallDescView")
//require("game.team.TeamTabItem")
//require("game.team.TeamView")
//require("game.team.TeamVoteView")

import { BaseController } from "../common/BaseController"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import "../team/TeamView"
import "../team/TeamBeInvitedView"
import "../team/TeamChangeTargetView"
import "../team/TeamInviteView"
import "../team/TeamMatchView"
import "../team/TeamSmallDescView"
import "../team/TeamVoteView"
import "../team/TeamApplyView"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"

//require("game.proto.240.Require240")
export class TeamController extends BaseController {
    InitEvent
    RegisterAllProtocals

    public constructor() {
        super()

        let model = TeamModel.GetInstance()
        let user_msg_adapter = UserMsgAdapter.GetInstance()
        let local_Message = Message
        let request_proto_event = TeamEvent.TEAM_REQUEST_PROTO
        let local_TeamEvent = TeamEvent
        let local_Util = Util
        let role_mgr = RoleManager.GetInstance()

        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        let view_dic_ = []
        this.RegisterAllProtocals = () => {
            let Handler24000 = () => {
                let scmd = user_msg_adapter.GetSCMD(24000)
                if (scmd.res == 1) {
                    local_Message.show("创建队伍成功")
                    model.Fire(local_TeamEvent.TEAM_BUILD_SUCCESS)
                } else {
                    if (model.single_match_state) {
                        model.single_match_state = false
                    }
                    Util.ErrorCodeShow(scmd.res, scmd.error_code_args)
                }
            }

            let Handler24002 = () => {
                let scmd = user_msg_adapter.GetSCMD(24002)
                if (scmd.res == 1) {
                    local_Message.show("发送申请成功")
                } else {
                    Util.ErrorCodeShow(scmd.res, scmd.error_code_args)
                }
            }

            let Handler24003 = () => {
                let scmd = user_msg_adapter.GetSCMD(24003)
                SentientActModel.GetInstance().Fire(SentientActEvent.UPDATE_APPLY_RED, true)
                if (!model.IsInShiledState(scmd.player_id)) {
                    model.SetTeamApplyRedDot(true)
                }
                model.Fire(request_proto_event, 24047)
            }

            let Handler24004 = () => {
                let scmd = user_msg_adapter.GetSCMD(24004)
                if (scmd.res == 1) {
                    local_Message.show("回应成功")
                    model.Fire(request_proto_event, 24047)
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24005 = () => {
                let scmd = user_msg_adapter.GetSCMD(24005)
                if (scmd.res == 1) {
                    //model.SetAutoMatch(false)
                    model.ClearTeamInfo()
                    model.Fire(local_TeamEvent.QUIT_TEAM_SUCCESS)
                    model.Fire(local_TeamEvent.UPDATE_MATCH_STATE)
                    BaseDungeonModel.GetInstance().ActionforView()
                    model.Fire(request_proto_event, 24010)
                    model.Fire(request_proto_event, 24012, "cci", model.activity_id, model.activity_sub_id, 0)
                    //退出队伍 取消匹配
                    let auto_match = model.GetAutoMatch()
                    if (auto_match) {
                        model.SetCancelMatchText("匹配取消")
                        model.Fire(request_proto_event, 24048, "c", 0)
                    } 
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24006 = () => {
                let scmd = user_msg_adapter.GetSCMD(24006)
                if (scmd.res == 1) {
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24007 = () => {
                let scmd = user_msg_adapter.GetSCMD(24007)
                model.UpdateBeInvitedList(scmd)
            }

            let Handler24008 = () => {
                let scmd = user_msg_adapter.GetSCMD(24008)
                if (scmd.res == 1) {
                } else {
                    Util.ErrorCodeShow(scmd.res, scmd.error_code_args)
                }
            }

            let Handler24009 = () => {
                let scmd = user_msg_adapter.GetSCMD(24009)
                if (scmd.res == 1) {
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24010 = () => {
                let scmd = user_msg_adapter.GetSCMD(24010)
                model.UpdateTeamInfo(scmd)
            }

            let Handler24011 = () => {
                let scmd = user_msg_adapter.GetSCMD(24011)
                if (scmd.res == 1) {
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24012 = () => {
                let scmd = user_msg_adapter.GetSCMD(24012)
                model.UpdateTeamHall(scmd)
            }

            let Handler24013 = () => {
                let scmd = user_msg_adapter.GetSCMD(24013)
                let role_vo = SceneManager.GetInstance().GetRoleVo(scmd.id)
                if (role_vo) {
                    role_vo.team_job = scmd.position
                    role_vo.ChangeVar("team_id", scmd.team_id)
                }
            }

            let Handler24014 = () => {
                let scmd = user_msg_adapter.GetSCMD(24014)
                if (scmd.id == role_mgr.mainRoleInfo.role_id) {
                    model.ClearTeamInfo()
                    model.Fire(local_TeamEvent.TEAM_CLOSE_ALL_VIEW)
                    //model.SetAutoMatch(false)
                    model.Fire(local_TeamEvent.UPDATE_MATCH_STATE, model.GetAutoMatch())
                } else {
                    model.DeleteOneTeammate(scmd.id)
                }
            }

            let Handler24015 = () => {
                let scmd = user_msg_adapter.GetSCMD(24015)
                if (scmd.id) {
                    model.UpdateTeamLeader(scmd.id)
                }
            }

            let Handler24017 = () => {
                let scmd = user_msg_adapter.GetSCMD(24017)
                if (scmd.res == 1) {
                    local_Message.show("更改目标成功")
                    model.ChangeTargetSuccess(scmd, true)
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24018 = () => {
                let scmd = user_msg_adapter.GetSCMD(24018)
                if (scmd.res == 1) {
                    if (model.team_info) {
                        model.team_info.join_type = scmd.join_type
                        model.Fire(local_TeamEvent.TEAM_CHANGE_JOIN_TYPE)
                    }
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24020 = () => {
                let scmd = user_msg_adapter.GetSCMD(24020)
                if (scmd.error_code != 1) {
                    Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
                }
            }

            let Handler24021 = () => {
                let scmd = user_msg_adapter.GetSCMD(24021)
                if (scmd.error_code != 1) {
                    Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
                }
            }

            let Handler24023 = () => {
                let scmd = user_msg_adapter.GetSCMD(24023)
                if (scmd.res == 1) {
                    // Message.show("开始匹配")
                    // model.auto_match = true
                    // model.Fire(TeamEvent.UPDATE_MATCH_STATE, true)
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }

            let Handler24030 = () => {
                let scmd = user_msg_adapter.GetSCMD(24030)
                if (scmd.res == 2400022) {
                    if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
                        model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamView")
                    }
                }
                Util.ErrorCodeShow(scmd.res)
            }

            let Handler24033 = () => {
                let scmd = user_msg_adapter.GetSCMD(24033)
                if (scmd.error_code == 1) {
                    let data
                    data={}
                    data.dun_id = scmd.dun_id
                    data.state = scmd.help_type
                    model.SetMyHelpState(data)
                } else {
                    Util.ErrorCodeShow(scmd.error_code)
                }
            }

            let Handler24034 = () => {
                let scmd = user_msg_adapter.GetSCMD(24034)
                model.UpdateHelpState(scmd)
            }

            let Handler24035 = () => {
                let scmd = user_msg_adapter.GetSCMD(24035)
                model.Fire(TeamEvent.TEAM_CLOSE_VIEW, "TeamMatchView")
                model.Fire(local_TeamEvent.TEAM_CLOSE_VIEW, "TeamView")
                model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamVoteView", scmd)
            }

            let Handler24036 = () => {
                let scmd = user_msg_adapter.GetSCMD(24036)
                model.SetVoteData(scmd)
            }

            let Handler24037 = () => {
                let scmd = user_msg_adapter.GetSCMD(24037)
                model.Fire(local_TeamEvent.TEAM_CLOSE_VIEW, "TeamVoteView")
                model.vote_data = null
                Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
            }

            let Handler24038 = () => {
                let scmd = user_msg_adapter.GetSCMD(24038)
                Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
            }

            let Handler24040 = () => {
                let scmd = user_msg_adapter.GetSCMD(24040)
                model.Fire(local_TeamEvent.TEAM_CLOSE_VIEW, "TeamVoteView")
                model.vote_data = null
            }

            let Handler24042 = () => {
                let scmd = user_msg_adapter.GetSCMD(24042)
            }

            let Handler24047 = () => {
                let scmd = user_msg_adapter.GetSCMD(24047)
                model.SetApplyList(scmd.reqlist)
            }

            let Handler24049 = () => {
                let scmd = user_msg_adapter.GetSCMD(24049)
                model.SetMyHelpState(scmd)
            }

            let Handler24048 = () => {
                let scmd = user_msg_adapter.GetSCMD(24048)
                if (scmd.res == 1) {
                    if (scmd.state == 0) {
                        if (((scmd.role_id > 0 && scmd.role_id != role_mgr.GetMainRoleId()) && model.team_info) && model.team_info.team_member_list) {
                            for (let _tmpi in model.team_info.team_member_list) {
                                var v = model.team_info.team_member_list[_tmpi]
                                if (v.id == scmd.role_id) {
                                    // [ts2lua]lua中0和空字符串也是true，此处v.team_position == 1需要确认
                                    let pos_str = (v.team_position == 1 && ("队长") || ("队员"))
                                    let str = pos_str + "<font color='#ff8a3c'>" + v.name + "</font>取消了匹配"
                                    local_Message.show(str)
                                    break
                                }
                            }
                        } else {
                            let text = model.GetCancelMatchText()
                            local_Message.show(text || "取消匹配")
                            model.SetCancelMatchText(null)
                        }
                        model.match_st = null
                    }
                    else if (scmd.state == 1) {
                        if (model.team_info) {
                            local_Message.show("开始队伍匹配")
                            model.team_info.match_st = scmd.match_st
                        } else {
                            local_Message.show("开始个人匹配")
                            model.match_st = scmd.match_st
                        }
                        model.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamMatchView", scmd)
                    }
                    model.SetAutoMatch(scmd.state == 1)
                    model.Fire(local_TeamEvent.UPDATE_MATCH_STATE, model.GetAutoMatch())
                } else {
                    Util.ErrorCodeShow(scmd.res, scmd.error_code_args)
                }
            }

            let Handler24051 = () => {
                let scmd = user_msg_adapter.GetSCMD(24051)
                model.Fire(local_TeamEvent.BEFORE_TEAMMATE_CHANGE_SCENE, scmd.role_id, scmd.scene_id)
                model.MyTeammateSceneChange(scmd.role_id, scmd.scene_id)
            }

            let Handler24052 = () => {
                let scmd = user_msg_adapter.GetSCMD(24052)
                model.MyTeammateOnlineChange(scmd.role_id, scmd.online)
            }

            let Handler24053 = () => {
                let scmd = user_msg_adapter.GetSCMD(24053)
                model.SetNearByPlayer(scmd.users)
            }

            let Handler24055 = () => {
                let scmd = user_msg_adapter.GetSCMD(24055)
                Message.show("招募发送成功")
                model.world_shout_time = TimeUtil.getServerTime()
                model.Fire(local_TeamEvent.TEAM_WORLD_SHOUT_SUCCESS)
            }

            let Handler24057 = () => {
                let scmd = user_msg_adapter.GetSCMD(24057)
                if (scmd.res == 1) {
                } else {
                    Util.ErrorCodeShow(scmd.res)
                }
            }
            let Handler24060 = () => {
                let scmd = user_msg_adapter.GetSCMD(24060)
                model.SetZhaoMuLIst(scmd)
            }

            let Handler24061 = () => {
                let scmd = user_msg_adapter.GetSCMD(24061)
                model.SetZhaoMuLIst(scmd)
            }
            let Handler24063 = () => {
                let scmd = user_msg_adapter.GetSCMD(24063)
                model.Fire(request_proto_event, 24047)
                Util.ErrorCodeShow(scmd.error_code)
            }

            this.RegisterProtocal(24000, Handler24000)
            this.RegisterProtocal(24002, Handler24002)
            this.RegisterProtocal(24003, Handler24003)
            this.RegisterProtocal(24004, Handler24004)
            this.RegisterProtocal(24005, Handler24005)
            this.RegisterProtocal(24006, Handler24006)
            this.RegisterProtocal(24007, Handler24007)
            this.RegisterProtocal(24008, Handler24008)
            this.RegisterProtocal(24009, Handler24009)
            this.RegisterProtocal(24010, Handler24010)
            this.RegisterProtocal(24011, Handler24011)
            this.RegisterProtocal(24012, Handler24012)
            this.RegisterProtocal(24013, Handler24013)
            this.RegisterProtocal(24014, Handler24014)
            this.RegisterProtocal(24015, Handler24015)
            this.RegisterProtocal(24017, Handler24017)
            this.RegisterProtocal(24018, Handler24018)
            this.RegisterProtocal(24020, Handler24020)
            this.RegisterProtocal(24021, Handler24021)
            this.RegisterProtocal(24023, Handler24023)
            this.RegisterProtocal(24030, Handler24030)
            this.RegisterProtocal(24033, Handler24033)
            this.RegisterProtocal(24034, Handler24034)
            this.RegisterProtocal(24035, Handler24035)
            this.RegisterProtocal(24036, Handler24036)
            this.RegisterProtocal(24037, Handler24037)
            this.RegisterProtocal(24038, Handler24038)
            this.RegisterProtocal(24040, Handler24040)
            this.RegisterProtocal(24042, Handler24042)
            this.RegisterProtocal(24047, Handler24047)
            this.RegisterProtocal(24049, Handler24049)
            this.RegisterProtocal(24048, Handler24048)
            this.RegisterProtocal(24051, Handler24051)
            this.RegisterProtocal(24052, Handler24052)
            this.RegisterProtocal(24053, Handler24053)
            this.RegisterProtocal(24055, Handler24055)
            this.RegisterProtocal(24057, Handler24057)
            this.RegisterProtocal(24060, Handler24060)
            this.RegisterProtocal(24061, Handler24061)
            this.RegisterProtocal(24063, Handler24063)
        }

        this.InitEvent = () => {
            model.Bind(
                request_proto_event, (id, fmt, ...new_args) => {
                    this.SendFmtToGame(id, fmt, ...new_args)
                }
            )
            model.Bind(
                local_TeamEvent.TEAM_REQUEST_OTHER_PROTO, (id?, list?) => {
                    if (id == 24004) {
                        this.WriteBegin(24004)
                        this.WriteFMT("h", list.length)
                        for (let _tmpi in list) {
                            var vo = list[_tmpi]
                            this.WriteFMT("c", vo[0])
                            this.WriteFMT("h", vo[1])
                            this.WriteFMT("l", vo[2])
                        }
                        this.SendToGame()
                    }
                    else if (id == 24006) {
                        this.WriteBegin(24006)
                        this.WriteFMT("c", list[0])
                        this.WriteFMT("c", list[1])
                        this.WriteFMT("i", list[2])
                        this.WriteFMT("h", list[3])
                        this.WriteFMT("h", list[4])
                        this.WriteFMT("h", list[5].length)
                        for (let _tmpi in list[5]) {
                            var vo = list[5][_tmpi]
                            this.WriteFMT("l", vo)
                        }
                        this.SendToGame()
                    }
                    else if (id == 24057) {
                        this.WriteBegin(24057)
                        this.WriteFMT("h", list.length)
                        for (let _tmpi in list) {
                            var vo = list[_tmpi]
                            this.WriteFMT("h", vo[0])
                            this.WriteFMT("l", vo[1])
                        }
                        this.SendToGame()
                    }
                    else if (id == 24008) {
                        this.WriteBegin(24008)
                        this.WriteFMT("h", list.length)
                        for (let _tmpi in list) {
                            var vo = list[_tmpi]
                            this.WriteFMT("l", vo[0])
                            this.WriteFMT("c", vo[1])
                        }
                        this.SendToGame()
                    }
                }
            )
            model.Bind(
                local_TeamEvent.TEAM_OPEN_VIEW, (view_name, ...new_args) => {
                    // [ts2lua]view_dic_下标访问可能不正确
                    let view = view_dic_[view_name]
                    if (!view) {
                        // [ts2lua]view_dic_下标访问可能不正确
                        view_dic_[view_name] = true
                        // [ts2lua]window下标访问可能不正确
                        if (!window[view_name]) {
                            if (!ResManager.GetInstance().IsJsLoad("team")) {
                            }
                        }
                        // [ts2lua]view_dic_下标访问可能不正确
                        if (view_dic_[view_name] == true) {
                            // [ts2lua]window下标访问可能不正确
                            let view_class: any = window[view_name]
                            view = new view_class()
                            // [ts2lua]view_dic_下标访问可能不正确
                            view_dic_[view_name] = view
                        }
                    }
                    if (view && view != true) {
                        view.Open(...new_args)
                    }
                }
            )
            model.Bind(
                local_TeamEvent.TEAM_CLOSE_VIEW, (view_name, ...new_args) => {
                    // [ts2lua]view_dic_下标访问可能不正确
                    let view = view_dic_[view_name]
                    if (view && view != true) {
                        view.Close()
                    }
                    // [ts2lua]view_dic_下标访问可能不正确
                    view_dic_[view_name] = null
                }
            )
            model.Bind(
                local_TeamEvent.TEAM_CLOSE_ALL_VIEW, () => {
                    if (view_dic_) {
                        let view = null
                        for (let key in view_dic_) {

                            // [ts2lua]view_dic_下标访问可能不正确
                            view = view_dic_[key]
                            if (view && view.Close) {
                                view.Close()
                            }
                        }
                    }
                }
            )
            local_GlobalEventSystem.Bind(
                local_EventName.INIT_CONFIG, () => {
                    //model:InitConfig()
                }
            )
            local_GlobalEventSystem.Bind(
                local_EventName.GAME_START, () => {
                    model.InitConfig()
                    model.Fire(request_proto_event, 24010)
                    model.Fire(request_proto_event, 24047)
                }
            )
            local_GlobalEventSystem.Bind(EventName.CHANGE_ROLE, () => {
                model.ClearTeamInfo()
            })

            local_GlobalEventSystem.Bind(EventName.CHANGE_ACCOUNT, () => {
                model.ClearTeamInfo()
            })
        }

        this.RegisterAllProtocals()
        this.InitEvent()
    }
}
window["TeamController"]=TeamController