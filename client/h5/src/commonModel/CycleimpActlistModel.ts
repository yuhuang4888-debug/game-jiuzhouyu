import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { OneDollarSpikeAwardItem } from "../oneDollarSpike/OneDollarSpikeAwardItem"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { ActivityIconManager } from "./ActivityIconManager"
import { enum_OutWardType, OutWardBaseModel } from "./OutWardBaseModel"
import { RoleManager } from "./RoleManager"


export const CycleimpActlistEvent = {
    UPDATE_CYCLEIMPACTLIST_VIEW: "UPDATE_CYCLEIMPACTLIST_VIEW",
    UPDATE_CYCLEIMPACTLIT_RED: "UPDATE_CYCLEIMPACTLIT_RED",
    UPDATE_CYCLEIMPACTLIST_DATA: "UPDATE_CYCLEIMPACTLIST_DATA",
    CLOSE_CYCLEIMPACTLIST: "CLOSE_CYCLEIMPACTLIST",
    REQUEST_PROTO: "REQUEST_PROTO",
    OPEN_VIEW: "OPEN_VIEW",
    GET_REWARD: "GET_REWARD"

}
window["CycleimpActlistEvent"] = CycleimpActlistEvent

export class CycleimpActlistModel extends EventDispatcher {
    private static _instance: CycleimpActlistModel;
    SetActTime
    GetActTime
    SetActData
    GetMyScore
    GetStage
    SetRed
    GetActIsOpen
    CheckActData
    SetRankList
    GetRankStage
    SetYesterdayInfo
    GetNowRankList
    GetYesterdayInfo
    GetStatuse
    GetMyRank
    CheckIsShowTips
    CheckActOpen
    GetOutWardType
    type
    subtype
    config_cycle_rank_reach_reward
    is_first_login  //第一次打开界面
    is_first_show_yesterday_tips  //第一次打开昨日榜单
    will_show_yesterday_tips
    public constructor() {
        super()

        let activity_icon_mgr = ActivityIconManager.GetInstance()
        let role_mgr = RoleManager.GetInstance()
        let local_CycleimpActlistEvent = CycleimpActlistEvent
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        this.type = null
        this.subtype = null
        let time_info  //活动开始结束时
        let act_is_open //活动是否开启
        let score = 0   //个人分数
        let my_rank = 0
        let old_my_rank = 0
        let stage = null  // 个人奖励，当前阶段
        let rank_stage = null // 排行榜阶段id
        let is_can_get = null  // 1为可领取；2为已领取；3为未达条件
        this.is_first_login = true
        let now_rank_list = [] //今日榜单数据
        let yesterday_rank_list = [] //昨日榜单数据
        this.will_show_yesterday_tips = false
        this.is_first_show_yesterday_tips = true


        this.SetActTime = (scmd) => {
            this.type = scmd.type
            this.subtype = scmd.subtype
            time_info = scmd
        }

        this.GetActTime = () => {
            return time_info
        }

        this.SetActData = (scmd) => {
            act_is_open = scmd.is_open
            score = scmd.score
            stage = scmd.id
            is_can_get = scmd.got_type
        }

        this.GetMyScore = () => {
            return score
        }

        this.GetActIsOpen = () => {
            return act_is_open
        }

        this.GetStage = () => {
            return stage
        }

        this.GetStatuse = () => {
            return is_can_get
        }

        this.CheckActData = () => {
            // let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            // let lv = RoleManager.GetInstance().GetMainRoleLevel()
            let topplayer_icon = this.CheckActOpen()
            if (this.is_first_login && topplayer_icon && this.type) {
                return true
            }
            if (is_can_get == 1) {
                return true
            }

            let outward_type =this.GetOutWardType()
            if (outward_type) {
                let red = OutWardBaseModel.GetInstance().LvsystemCanLvUp(outward_type)  // && is_can_get != 3;
                return red;

            }
            return false
        }
        /**检查活动是否达到开启条件 */
        this.CheckActOpen = () => {
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            let lv = RoleManager.GetInstance().GetMainRoleLevel()
            return (open_day >= 8 && lv >= 130) ? true : false
        }

        this.SetRankList = (scmd) => {
            now_rank_list = scmd.rank_list
            my_rank = scmd.rank
            rank_stage = scmd.reward_id
            if (old_my_rank == 0) {
                old_my_rank = scmd.rank
            }
        }

        this.SetYesterdayInfo = (scmd) => {
            yesterday_rank_list = scmd
        }

        this.GetMyRank = () => {
            return my_rank
        }

        this.GetRankStage = () => {
            return rank_stage
        }

        this.GetNowRankList = () => {
            return now_rank_list
        }

        this.GetYesterdayInfo = () => {
            return yesterday_rank_list
        }

        this.CheckIsShowTips = (scmd) => {
            if (RoleManager.GetInstance().GetMainRoleLevel() >= 130) {
                this.Fire(CycleimpActlistEvent.OPEN_VIEW, "CycleimpActlistTipsView", scmd)
            }
        }

        this.GetOutWardType=()=>{
            let type_id
            if (this.type == 1) {
                type_id = enum_OutWardType.Horse
            } else if (this.type == 2) {
                type_id = enum_OutWardType.Partner
            } else if (this.type == 3) {
                type_id = enum_OutWardType.Wings
            } else if (this.type == 4) {
                type_id = enum_OutWardType.Artifact
            } else if (this.type == 5) {
                type_id = enum_OutWardType.HolyDevice
            } else if (this.type == 6) {
                type_id = enum_OutWardType.BackOrnament
            } else if (this.type == 7) {
            }
            return type_id
        }
    }
    /**
     * 初始化配置
     */
    public async InitConfig() {
        await ResManager.GetInstance().LoadGameConfig(this, 'config_cycle_rank_reach_reward', false, undefined, (obj) => {
            this.config_cycle_rank_reach_reward = obj;
            ResManager.GetInstance().DestoryGameConfig(this, 'config_cycle_rank_reach_reward', false);
        });



    }




    public static GetInstance() {

        if (!CycleimpActlistModel._instance) {
            CycleimpActlistModel._instance = new CycleimpActlistModel();
        }
        return CycleimpActlistModel._instance
    }

}
window['CycleimpActlistModel'] = CycleimpActlistModel;
