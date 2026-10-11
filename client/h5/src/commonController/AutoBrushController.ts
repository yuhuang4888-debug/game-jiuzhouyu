import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { DUN_TYPE } from "../commonModel/BaseDungeonModel"

import "../autoBrush/AutoBrushBaseView"
import "../autoBrush/AutoBrushRankView"
import "../autoBrush/AutoBrushRankItem"
import "../autoBrush/AutoBrushResultView"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { StoryModel } from "../commonModel/StoryModel"
import { Config } from "../common/Config"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { EnumAutoBrushTabType } from "../autoBrush/AutoBrushBaseView"

export class AutoBrushController extends BaseController {

    auto_brush_model: AutoBrushModel
    scene_mgr:SceneManager
    task_model:TaskModel
    story_model:StoryModel
    user_msg_adapter:UserMsgAdapter

    public constructor() {
        super()
        this.auto_brush_model = AutoBrushModel.GetInstance()
        this.user_msg_adapter = UserMsgAdapter.GetInstance()
        this.task_model = TaskModel.GetInstance()
        this.story_model = StoryModel.GetInstance()
        this.scene_mgr = SceneManager.GetInstance()
        this.InitEvent()
        this.RegisterAllProtocals()
    }

    public InitEvent() {

        GlobalEventSystem.Bind(EventName.GAME_START, () => {
            this.auto_brush_model.ResetData()
            this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13300)//刷怪信息
            this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13301)//请求排行榜
            this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13309)//下一个阶段奖励关卡
            this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13323)//获取结界守护新手流程节点信息
            this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13324)//玩家请求协助次数信息
        })

        this.auto_brush_model.Bind(AutoBrushModel.REQUEST_PROTO_EVENT, (id, fmt, ...new_args) => {
            this.SendFmtToGame(id, fmt, ...new_args)
        })

        let update_fight_time_id
        RoleManager.GetInstance().GetMainRoleVo().BindOne("fighting", (id, fmt, ...new_args) => {
            if(update_fight_time_id) return
            update_fight_time_id = setTimeout(() => {
                update_fight_time_id = null
                this.auto_brush_model.UpdateBrushRedState()
            }, 500);
        })

        GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (task_id) => {
            if(task_id == AutoBrushModel.IgnoreRedTaskID || task_id == AutoBrushModel.IgnoreRedTaskLastID){
                this.auto_brush_model.Fire(AutoBrushModel.REFRESH_RED_FLAG, AutoBrushModel.RedFlag.Brush)
                GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "AutoBrushBaseView", EnumAutoBrushTabType.eAutoBrush, this.auto_brush_model.GetRedState())
                this.auto_brush_model.Fire(AutoBrushModel.UPDATE_BRUSH_STRANGE_INFO)
            }
        })

        GlobalEventSystem.Bind(SceneManager.START, () => {
			if (!this.scene_mgr.IsMainLineDungeonScene() && this.scene_mgr.IsMainLineDungeonScene(this.scene_mgr.GetLastSceneId())) {
                let no_first_recharge = FirstRechargeModel.GetInstance().IsNoFirstRecharge()
                let failue_state = AutoBrushModel.GetInstance().GetFailueState()
                if(no_first_recharge && failue_state){
                    let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge?.auto_brush_open_tips_cond
                    if(cfg){
                        // if(this.auto_brush_model.level > this.auto_brush_model.cache_level){
                            let create_day = RoleManager.GetInstance().GetRoleCreateDay() + 1
                            for(let cond of cfg){
                                if(cond.start_level <= this.auto_brush_model.level && cond.end_level >= this.auto_brush_model.level && cond.start_open_day <= create_day && cond.end_open_day >= create_day){
                                    FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW)
                                }
                            }
                        // }
                    }
                }
                this.auto_brush_model.cache_level = this.auto_brush_model.level
                Laya.timer.frameOnce(1, this,()=>{
                    if (this.use_delete_method) return
                    //延迟一帧其他逻辑也要用
                    AutoBrushModel.GetInstance().SetFailueScmd(null)
                })
			}
		})
    }

    public RegisterAllProtocals() {
        let On13300 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13300)
            this.auto_brush_model.SetBrushStrangeInfo(scmd)
        }
        let On13301 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13301)
            this.auto_brush_model.SetLevel(scmd.level)
            this.auto_brush_model.SetMyRank(scmd.role_rank)
            this.auto_brush_model.SetRankType(scmd.rank_type)
            this.auto_brush_model.SetRankData(scmd.res)
            this.auto_brush_model.Fire(AutoBrushModel.UPDATE_DONE_STATE)
        }

        let On13305 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13305)
            if (scmd.code != 1)
                Util.ErrorCodeShow(scmd.code)
        }

        let On13306 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13306)
            this.auto_brush_model.SetFailueScmd(scmd)
            if (scmd.state == 0) {
                //成功 关卡数+1
                let level = this.auto_brush_model.GetLevel()
                this.auto_brush_model.SetLevel(level + 1)

                let reward_list = []
                let goods_list = scmd.reward_array[0].reward_list
                for (let i in goods_list) {
                    let vo = goods_list[i]
                    reward_list.push({
                        0: vo.style,
                        1: vo.typeId,
                        2: vo.count,
                        3: vo.goods_id
                    })
                }

                if (scmd.coin) {
                    reward_list.push({ 0: 3, 1: 0, 2: scmd.coin })
                }
                if (scmd.exp) {
                    reward_list.push({ 0: 5, 1: 0, 2: scmd.exp })
                }
                // reward_list = reward_list.concat(goods_list)

                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "AutoBrushResultView", reward_list)
            }
            else if (scmd.state == 1) {
                let level = this.auto_brush_model.GetLevel()
                this.auto_brush_model.last_failue_level = level + 1
                // this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 1)
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonFailureView", DUN_TYPE.Main_Line, window["DungeonFailureView"].TYPE_STRENG)
            }
        }

        let On13307 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13307)
            if (scmd.code == 1) {
                this.auto_brush_model.SetAutoBrushStrangeState(scmd.type == 0)
                let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
                let is_finish = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().has_finish
                if (task_id && AutoBrushModel.GetInstance().IsSpeTaskId(task_id) && is_finish && scmd.type == 1) {
                    AutoBrushModel.GetInstance().Fire(AutoBrushModel.SHOW_MAIN_TASK_ARROW)
                }
            }
        }

        let On13309 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13309)
            if (scmd.code == 1) {
                let next_stage_reward_gate = scmd.next_stage_reward_gate
                if(next_stage_reward_gate === 0 ){
                    next_stage_reward_gate = 99999
                }
                this.auto_brush_model.SetNextStageRewardLevel(next_stage_reward_gate)
            }
            else {
                Util.ErrorCodeShow(scmd.code)
            }
        }

        let On13310 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13310)
            if (scmd.code == 1) {
                this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13309)//下一个阶段奖励关卡
                Util.ShowCongratulationView(scmd.reward_list)
                this.Fire(AutoBrushModel.UPDATE_STAGE_REWARD)
            }
            else {
                Util.ErrorCodeShow(scmd.code)
            }
        }

        let On13322 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13322)
            
        }
        let On13323 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13323)
            this.auto_brush_model.SetStep(scmd.node)
        }
        let On13324 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13324)
            this.auto_brush_model.SetAssistData(scmd)
        }

        this.RegisterProtocal(13300, On13300)//获取进入条件信息
        this.RegisterProtocal(13301, On13301)//排行榜信息
        this.RegisterProtocal(13305, On13305)//进出退出副本
        this.RegisterProtocal(13306, On13306)//通关奖励信息
        this.RegisterProtocal(13307, On13307)//开启关闭自动闯关
        this.RegisterProtocal(13309, On13309)//下一个阶段奖励关卡
        this.RegisterProtocal(13310, On13310)//领取阶段奖励
        this.RegisterProtocal(13322, On13322)//查看结界守护新手流程节点信息
        this.RegisterProtocal(13323, On13323)//获取结界守护新手流程节点信息
        this.RegisterProtocal(13324, On13324)//玩家请求协助次数信息
    }
}

window["AutoBrushController"] = AutoBrushController