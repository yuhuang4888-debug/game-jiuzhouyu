import { Alert, Alert_Type } from "../alert/Alert"
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { FriendModel } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MarriageDefine, MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"


import "../marriage/MarriageBaseView"
import "../marriage/MarriageIssueView"
import "../marriage/MarriageRecordFlowerView"
import "../marriage/MarriageRecordComView"
import "../marriage/MarriageComView"
import "../marriage/MarriageFlowerView"
import "../marriage/MarriageRoleMenuView"
import "../marriage/MarriageFlowerTipsView"
import "../marriage/MarriageAskTipsView"
import "../marriage/MarriageAskView"
import "../marriage/MarriageSuccessView"
import "../marriage/MarriageMainView"
import "../marriage/MarriageBreakView"
import "../marriage/MarriageBreakTipsView"
import "../marriage/MarriageDsgtView"
import "../marriage/MarriageFlowView"
import "../marriage/MarriageAskListView"
import "../marriage/MarriageRingView"
import "../marriage/MarriageRingChangeView"
import "../marriage/MarriageGiftTipsView"
import "../marriage/MarriageGiftView"
import "../marriage/MarriageDunView"
import "../marriage/MarriageDunTipsView"
import "../marriage/MarriageDunLuckView"
import "../marriage/MarriageHonourView"
import "../marriage/MarriageForeShowView"

import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { TaskModel } from "../commonModel/TaskModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { PlatformManager } from "../PlatformManager"



// import "../marriage/MarriageTagView";

export class MarriageController extends BaseController {
    static Instance: MarriageController

    InitEvent
    InitInfo
    public constructor() {
        super()
        let local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            model = MarriageModel.GetInstance(),
            role_mgr = RoleManager.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            user_msg_adapter = UserMsgAdapter.GetInstance(),
            local_Util = Util,
            friend_model = FriendModel.GetInstance(),
            local_Message = Message,
            base_boss_model = BaseDungeonModel.GetInstance(),
            local_BaseDungeonModel = BaseDungeonModel
        this.InitEvent = () => {

            
            local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {
                // model.InitCfg()
            })

            local_GlobalEventSystem.Bind(local_EventName.GAME_START, async () => {
                model.Reset()
                await model.InitCfg()
                this.SendFmtToGame(22303)//鲜花相关信息
                model.RefForeShowIcon()
                let need_lv = model.GetConstantData(1)
                let lv = role_mgr.GetMainRoleVo().level
                if (need_lv <= lv) {
                    // this.SendFmtToGame(17200, "c", 2)//我的关注
                    this.SendFmtToGame(17226)//别人求婚信息
                    this.SendFmtToGame(17238)//礼包信息
                    this.SendFmtToGame(17210)//戒指信息
                }
            })

            role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level) => {
                model.RefForeShowIcon()
                let need_lv = model.GetConstantData(1)
                if (need_lv == level) {
                    this.SendFmtToGame(17238)//请求礼包信息
                    this.SendFmtToGame(17210)//戒指信息
                }
            })

            model.Bind(local_MarriageEvent.REQUEST_PROTO, (id: number, fmt?: string, ...parms) => {
                this.SendFmtToGame(id, fmt, ...parms)
            })

            model.Bind(local_MarriageEvent.SEND_ISSUE_INFO, (msg, type, tag_list) => {
                this.WriteBegin(17202)
                this.WriteFMT("s", msg)
                this.WriteFMT("c", type)
                this.WriteFMT("h", tag_list.length)
                for (let info of tag_list) {
                    this.WriteFMT("c", info.tag_id)
                    this.WriteFMT("c", info.tag_subid)
                }
                this.SendToGame()
            })

            local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
                this.SendFmtToGame(17238)//礼包信息
            })

            GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
                if (!model._ring_cost_data) return
                let rinfo = model.GetRingInfo()
                for (let info of goods_list) {
                    if (info.type_id == model._ring_cost_data.type_id || (rinfo && rinfo.star == 0 && info.type_id == model.ring)) {
                        model.CheckRingRedStatus()
                        break
                    }
                }
            })

            local_GlobalEventSystem.Bind(local_EventName.SWITCH_MAIN_FUNC_VIEW, () => {

            })

            // GlobalEventSystem.Bind(SceneManager.START, () => {
            //     let scene_mgr = SceneManager.Instance
            //     let last_scene_id = scene_mgr.GetLastSceneId()
            //     if (scene_mgr.IsMarriageDunScene(last_scene_id) && !scene_mgr.IsMarriageDunScene()) {
            //         GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageBaseView", 4)
            //     }
            // })

            local_GlobalEventSystem.Bind(local_EventName.CLOSE_DUNGEON_RESULT_VIEW, () => {
                let scene_mgr = SceneManager.GetInstance()
                let last_scene_id = scene_mgr.GetLastSceneId()
                if (scene_mgr.IsMarriageDunScene(last_scene_id) && !scene_mgr.IsMarriageDunScene()) {
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBaseView", 4)
                }
            })


            let task_fashion = (task_id?) => {
                if(task_id == 100110){
                    //包含百度标识不打开'玩家风采'界面
                    if(PlatformManager.GetInstance().is_baidu_version || ClientConfig.not_show_marriagefore_view){
                        return
                    }
                    ViewPopLevelModel.GetInstance().SetViewPop('MarriageForeShowView', false, true);
                }
               
			}
			TaskModel.GetInstance().Bind(TaskModel.FINISH_TASK, task_fashion)

        }

        this.InitInfo = () => {
            let on17200 = () => {
                let scmd = user_msg_adapter.GetSCMD(17200)
                if (scmd.code == 1) {
                    scmd.player_list.sort((a, b) => {
                        return b.time - a.time
                    })
                    model.SetFriendInfo(scmd)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17201 = () => {
                let scmd = user_msg_adapter.GetSCMD(17201)
                if (scmd.code == 1) {
                    //从大厅获取数据放到我的关注中
                    let vo = model.GetFriendData(1, scmd.follow_role_id)
                    if (vo) {
                        let info = model.GetFriendInfo(2)
                        if (info) {
                            info.player_list.push(vo)
                            info.player_list.sort((a, b) => {
                                return b.time - a.time
                            })
                            model.SetFriendInfo(info)
                        } else {
                            model.Fire(local_MarriageEvent.REQUEST_PROTO, 17200, "c", 2)
                        }
                    }
                } else {
                    // if (scmd.code != 1012)
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17202 = () => {
                let scmd = user_msg_adapter.GetSCMD(17202)
                if (scmd.code == 1) {
                    Message.show("发布成功")
                    model.Fire(local_MarriageEvent.REQUEST_PROTO, 17200, "c", 1)
                    local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageIssueView")
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17205 = () => {
                let scmd = user_msg_adapter.GetSCMD(17205)
                model.Fire(local_MarriageEvent.UPDATE_ROLE_DATA, scmd)
            }

            let on17210 = () => {
                let scmd = user_msg_adapter.GetSCMD(17210)
                if (scmd.code == 1) {
                    let sdata = model.GetRingStarData(scmd.stage, scmd.star)
                    scmd.ring_combat_power = local_Util.CalAttrPower(sdata.attr_list) + local_Util.CalAttrPower(sdata.marriage_attr)
                    model.SetRingInfo(scmd)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17211 = () => {
                let scmd = user_msg_adapter.GetSCMD(17211)
                if (scmd.code == 1) {
                    let rinfo = model.GetRingInfo()
                    if (!rinfo) return
                    let old_stage = rinfo.stage
                    let old_star = rinfo.star

                    rinfo.stage = scmd.stage
                    rinfo.star = scmd.star
                    rinfo.pray_num = scmd.pray_num

                    let sdata = model.GetRingStarData(scmd.stage, scmd.star)
                    rinfo.ring_combat_power = local_Util.CalAttrPower(sdata.attr_list) + local_Util.CalAttrPower(sdata.marriage_attr)
                    model.SetRingInfo(rinfo)
                    model.Fire(local_MarriageEvent.RING_UPGRADE_SUCCESS, old_stage, old_star)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17212 = () => {
                let scmd = user_msg_adapter.GetSCMD(17212)
                if (scmd.code == 1) {
                    // let rinfo = model.GetRingInfo()
                    // if (!rinfo) return
                    // let old_star = rinfo.star
                    // if (rinfo.stage != scmd.stage) {
                    //     GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageRingChangeView")
                    // }
                    // rinfo.stage = scmd.stage
                    // rinfo.star = scmd.star
                    // rinfo.pray_num = scmd.pray_num

                    // let sdata = model.GetRingStarData(scmd.stage, scmd.star)
                    // rinfo.ring_combat_power = Util.CalAttrPower(sdata.attr_list) + Util.CalAttrPower(sdata.marriage_attr)
                    // model.SetRingInfo(rinfo)
                    // // this.SendFmtToGame(17210)
                    // model.Fire(MarriageEvent.RING_UPGRADE_SUCCESS)
                    // model.Fire(MarriageEvent.RING_UPGRADE_STAR, old_star != scmd.star)
                } else {
                    model.Fire(local_MarriageEvent.STOP_RING_UPGRADE)
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17213 = () => {
                let scmd = user_msg_adapter.GetSCMD(17213)
                if (scmd.code == 1) {
                    let rinfo = model.GetRingInfo()
                    if (!rinfo) return
                    let old_stage = rinfo.stage
                    let old_star = rinfo.star

                    // if (rinfo.stage != scmd.stage) {
                    //     GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageRingChangeView")
                    // }
                    rinfo.stage = scmd.stage
                    rinfo.star = scmd.star
                    rinfo.pray_num = scmd.pray_num

                    let sdata = model.GetRingStarData(scmd.stage, scmd.star)
                    rinfo.ring_combat_power = local_Util.CalAttrPower(sdata.attr_list) + local_Util.CalAttrPower(sdata.marriage_attr)
                    model.SetRingInfo(rinfo, true)
                    // this.SendFmtToGame(17210)
                    // let count = (scmd.stage - old_stage) * MarriageDefine.STAR_MAX_COUNT + (scmd.star - old_star)
                    // model.Fire(MarriageEvent.RING_UPGRADE_SUCCESS, count)
                    // model.Fire(MarriageEvent.RING_UPGRADE_STAR, old_star != scmd.star)

                    // let count = (scmd.stage - old_stage) * MarriageDefine.STAR_MAX_COUNT + (scmd.star - old_star)
                    model.Fire(local_MarriageEvent.RING_UPGRADE_SUCCESS, old_stage, old_star)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17222 = () => {
                let scmd = user_msg_adapter.GetSCMD(17222)
                if (scmd.type == 2) {//求婚
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageAskTipsView", scmd)
                } else if (scmd.type == 4) { //离婚
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBreakTipsView", scmd)
                } else if (scmd.type == 5) { //请求购买礼包
                    model.Fire(local_MarriageEvent.UPDATE_PLEASE_STATE, true)
                }
            }

            let on17223 = () => {
                let scmd = user_msg_adapter.GetSCMD(17223)
                if (scmd.code == 1) {
                    this.SendFmtToGame(17232)
                    this.SendFmtToGame(17238)
                    this.SendFmtToGame(17210)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17224 = () => {
                // 1表白 2求婚 3离婚 4分手 5AA制再次
                // 0无 1答应 2拒绝
                let scmd = user_msg_adapter.GetSCMD(17224)
                if (scmd.answer_type == 1) {
                    model.SetGiftInfo(undefined)
                    this.SendFmtToGame(17232)
                    this.SendFmtToGame(17238)
                    this.SendFmtToGame(17210)
                    local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageAskView")

                    if (scmd.type == 3) {
                        let fri_vo = friend_model.getFriendById(scmd.role_id)
                        if (fri_vo) {
                            fri_vo.intimacy = 0
                        }
                    } else if (scmd.type == 2 && scmd.answer_type == 1) {
                        local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageSuccessView")

                    }
                }
            }

            let on17226 = () => {
                let scmd = user_msg_adapter.GetSCMD(17226)
                for (let info of scmd.biaobai_list) {
                    if (info.type == 2) {//求婚
                        local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageAskTipsView", info)
                    } else if (info.type == 4) { //离婚
                        local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageBreakTipsView", info)
                    }
                }
            }

            let on17229 = () => {
                let scmd = user_msg_adapter.GetSCMD(17229)
                //1 恩爱值
                for (let info of scmd.list) {
                    model.SetKeyValue(info.key, info.val)
                }
            }

            let on17231 = () => {
                let scmd = user_msg_adapter.GetSCMD(17231)
                if (scmd.code == 1) {

                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17232 = () => {
                let scmd = user_msg_adapter.GetSCMD(17232)
                //1720012 单身中 / 等级不足
                if (scmd.code == 1 || scmd.code == 1720012 || scmd.code == 1012) {
                   
                    let role_vo = role_mgr.GetMainRoleVo()
                    role_vo.ChangeVar("is_marriage", scmd.role_id ? 2 : 0)
                    role_vo.ChangeVar("marriage_id", scmd.role_id)
                    role_vo.ChangeVar("marriage_name", scmd["name"])
                    model.SetMateInfo(scmd)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17234 = () => {
                let scmd = user_msg_adapter.GetSCMD(17234)
                if (scmd.code == 1) {
                    //请求伴侣信息
                    this.SendFmtToGame(17232)
                    local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageBreakView")
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17235 = () => {
                let scmd = user_msg_adapter.GetSCMD(17235)
                if (scmd.code == 1) {

                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17236 = () => {
                let scmd = user_msg_adapter.GetSCMD(17236)
                if (scmd.code == 1) {
                    //延迟刷新，等待称号数据先返回
                    setTimeout(() => {
                        model.Fire(local_MarriageEvent.UPDATE_DSGT)
                    }, 1000)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17237 = () => {
                let scmd = user_msg_adapter.GetSCMD(17237)
                if (scmd.code == 1) {
                    //服务端主动推送17238
                    // model.Fire(MarriageEvent.REQUEST_PROTO, 17238)
                    model.BoardMarriager()
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17238 = () => {
                let scmd = user_msg_adapter.GetSCMD(17238)
                model.SetGiftInfo(scmd)
            }

            let on17239 = () => {
                let scmd = user_msg_adapter.GetSCMD(17239)
                if (scmd.code == 1) {
                    //服务端主动推送17238
                    // model.Fire(MarriageEvent.REQUEST_PROTO, 17238)
                    local_Util.ShowCongratulationView(scmd.reward)
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17240 = () => {
                let scmd = user_msg_adapter.GetSCMD(17240)
                if (scmd.code == 1) {

                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17245 = () => {
                let scmd = user_msg_adapter.GetSCMD(17245)
                if (scmd.code == 1) {
                    if (scmd.type == 1) {
                        local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageMatchView")
                    } else if (scmd.type == 2) {
                        local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageMatchView")
                    }
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17246 = () => {
                let scmd = user_msg_adapter.GetSCMD(17246)
                if (scmd.code == 1) {
                    scmd.enter_time = TimeUtil.getServerTime() + scmd.enter_time
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageMatchTipsView", scmd)
                    local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageMatchView")
                    local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "MarriageBaseView")
                }
            }

            let on17295 = () => {
                let scmd = user_msg_adapter.GetSCMD(17295)
                if (scmd.code == 1) {
                    local_Message.show("已向ta发起请求")
                } else {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on17296 = () => {
                let scmd = user_msg_adapter.GetSCMD(17296)
                Alert.Show("您的伴侣正在请求您购买伴侣副本次数，购买后可为双方增加1次挑战次数", Alert_Type.Two, () => {
                    model.Fire(local_MarriageEvent.REQUEST_PROTO, 17297, "ci", 1, scmd.dun_id)
                    base_boss_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61021, MarriageDefine.DUN_ID, 1)
                }, (is_close) => {
                    if (!is_close) model.Fire(local_MarriageEvent.REQUEST_PROTO, 17297, "ci", 2, scmd.dun_id)
                }, "购买", "拒绝")
            }

            let on17297 = () => {
                let scmd = user_msg_adapter.GetSCMD(17297)
                if (scmd.agree == 1) {
                    local_Message.show("对方已购买")
                    base_boss_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61020, DUN_TYPE.Marriage)
                } else if (scmd.agree == 2) {
                    local_Message.show("对方已拒绝")
                }
            }


            ////////////////////////////////////鲜花功能////////////////////////////////
            let on22300 = () => {
                let scmd = user_msg_adapter.GetSCMD(22300)
                if (scmd.code != 1) {
                    local_Util.ErrorCodeShow(scmd.code)
                }
            }

            let on22301 = () => {
                let scmd = user_msg_adapter.GetSCMD(22301)
                if (scmd.code == 1) {
                    let fri_vo = friend_model.getFriendById(scmd.receive_id)
                    let fdata = model.GetFlowerData(scmd.goods_id)
                    if (fri_vo) fri_vo.intimacy += (fdata ? fdata.intimacy * scmd.goods_num : 0)
                    model.AddRoleFame(fdata ? fdata.fame * scmd.goods_num : 0)
                    model.Fire(local_MarriageEvent.GIVE_GIFT_SUCCESS, scmd)
                    local_Message.show("赠送成功")
                } else {
                    //不显示操作太频繁的错误码
                    if (scmd.code != 1020002) {
                        local_Util.ErrorCodeShow(scmd.code)
                    }
                }
            }

            let on22302 = () => {
                let scmd = user_msg_adapter.GetSCMD(22302)
                model.Fire(local_MarriageEvent.UPDATE_FLOWER_RECORD, scmd)
            }

            let on22303 = () => {
                let scmd = user_msg_adapter.GetSCMD(22303)
                model.SetRoleFlowerInfo(scmd)
            }

            let on22304 = () => {
                let scmd = user_msg_adapter.GetSCMD(22304)
                // let fri_vo = FriendModel.GetInstance().getFriendById(scmd.role_id)
                // let fdata = model.GetFlowerData(scmd.goods_id)
                // if (fri_vo) fri_vo.intimacy += fdata ? fdata.intimacy : 0
                scmd["role_id"] = scmd.sender_id
                model.Fire(local_MarriageEvent.GET_FLOWER, scmd)
                local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageFlowerTipsView", scmd)
            }

            let on22305 = () => {
                let scmd = user_msg_adapter.GetSCMD(22305)
                local_Message.show("感谢成功")
                model.Fire(local_MarriageEvent.THANKS_FLOWER, scmd)
            }
            this.RegisterProtocal(17200, on17200)  //打开征友大厅界面
            this.RegisterProtocal(17201, on17201)  //关注/取消关注玩家
            this.RegisterProtocal(17202, on17202)  //发布信息
            this.RegisterProtocal(17205, on17205)  //获取玩家细节信息
            this.RegisterProtocal(17210, on17210)  //打开戒指界面
            this.RegisterProtocal(17211, on17211)  //解锁戒指
            this.RegisterProtocal(17212, on17212)  //戒指提升
            this.RegisterProtocal(17213, on17213)  //戒指一键提升
            this.RegisterProtocal(17222, on17222)  //收到求婚/再次举行婚礼/协商离婚
            this.RegisterProtocal(17223, on17223)  //回应求婚
            this.RegisterProtocal(17224, on17224)  //收到回应求婚/离婚结果
            this.RegisterProtocal(17226, on17226)  //求婚/离婚信息
            this.RegisterProtocal(17229, on17229)  //其他信息推送(一些信息变更推送)
            this.RegisterProtocal(17231, on17231)  //发送求婚
            this.RegisterProtocal(17232, on17232)  //打开我的伴侣
            this.RegisterProtocal(17234, on17234)  //发送离婚
            this.RegisterProtocal(17235, on17235)  //回应离婚
            this.RegisterProtocal(17236, on17236)  //领取恩爱称号奖励
            this.RegisterProtocal(17237, on17237)  //购买真爱礼包
            this.RegisterProtocal(17238, on17238)  //真爱礼包信息
            this.RegisterProtocal(17239, on17239)  //领取真爱礼包奖励
            this.RegisterProtocal(17240, on17240)  //请求对方购买礼包
            this.RegisterProtocal(17245, on17245)  //进入/退出匹配
            this.RegisterProtocal(17246, on17246)  //匹配结果
            this.RegisterProtocal(17295, on17295)  //邀请伴侣购买副本次数
            this.RegisterProtocal(17296, on17296)  //邀请伴侣购买副本次数
            this.RegisterProtocal(17297, on17297)  //同意购买/不同意购买


            //鲜花协议
            this.RegisterProtocal(22300, on22300)  //错误码展示
            this.RegisterProtocal(22301, on22301)  //赠送礼物
            this.RegisterProtocal(22302, on22302)  //收礼记录
            this.RegisterProtocal(22303, on22303)  //鲜花相关信息
            this.RegisterProtocal(22304, on22304)  //收到的鲜花通知
            this.RegisterProtocal(22305, on22305)  //感谢收花者
        }
        this.InitInfo()
        this.InitEvent()
    }

    public static GetInstance() {
        if (!MarriageController.Instance) {
            MarriageController.Instance = new MarriageController()
        }
        return MarriageController.Instance
    }






}
window["MarriageController"] = MarriageController