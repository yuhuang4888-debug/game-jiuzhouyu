import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { SceneManager } from "../scene/SceneManager"
import { EnumAutoBrushTabType } from "../autoBrush/AutoBrushBaseView"
import { TaskModel } from "./TaskModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { PlatformManager } from "../PlatformManager"
import { GoodsModel } from "./GoodsModel"
import { IS2CMosterParam, MonsterModel } from "./MonsterModel"

export class AutoBrushModel extends EventDispatcher {
    static Instance: AutoBrushModel

    static REQUEST_PROTO_EVENT = "AutoBrushModel.REQUEST_PROTO_EVENT"
    static UPDATE_BRUSH_STRANGE_INFO = "AutoBrushModel.UPDATE_BRUSH_STRANGE_INFO"
    static UPDATE_BRUSH_STRANGE_STATE = "AutoBrushModel.UPDATE_BRUSH_STRANGE_STATE"
    static UPDATE_LEVEL = "AutoBrushModel.UPDATE_LEVEL"
    static UPDATE_DONE_STATE = "AutoBrushModel.UPDATE_DONE_STATE"
    static UPDATE_RANK = "AutoBrushModel.UPDATE_RANK"
    static UPDATE_STAGE_REWARD_LEVEL = "AutoBrushModel.UPDATE_STAGE_REWARD_LEVEL"
    static REFRESH_RED_FLAG = "AutoBrushModel.REFRESH_RED_FLAG"
    static NEXT_STEP_ARROW = "AutoBrushModel.NEXT_STEP_ARROW"
    static SHOW_MAIN_TASK_ARROW = "AutoBrushModel.SHOW_MAIN_TASK_ARROW"
    static SET_LOGOUT_ARROW_STATE = "AutoBrushModel.SET_LOGOUT_ARROW_STATE"
    static SHOW_MAIN_TASK_ARROW2 = "AutoBrushModel.SHOW_MAIN_TASK_ARROW2"
    static SHOW_MAIN_TASK_ARROW3 = "AutoBrushModel.SHOW_MAIN_TASK_ARROW3"
    static UPDATE_ASSIST = "AutoBrushModel.UPDATE_ASSIST"
    static UPDATE_STAGE_REWARD = "AutoBrushModel.UPDATE_STAGE_REWARD"  //13310领取阶段奖励
    static HIDE_MAIN_TASK_ARROW2 = "AutoBrushModel.HIDE_MAIN_TASK_ARROW2"  //13310领取阶段奖励

    static AutoBrushMonsterId = 7001
    static AutoBrushMonsterHpNum = 10
    static RedFlag = {
        Brush: 0x001,//刷怪
        Stage: 0x002,//阶段奖励
    }
    static IgnoreRedTaskID = 100811
    static IgnoreRedTaskLastID = 100810

    static Task_Item_ID_1 = 1105010021 //引导任务道具id
    static Task_Item_ID_2 = 1105010024 //引导任务道具id

    /**
     * 自动推关协助类型
     */
    static AssistType = 4
    static AssistSubType = 1
    static AssistTargetId = 0

    static GetInstance() {

        if (!AutoBrushModel.Instance) {
            AutoBrushModel.Instance = new AutoBrushModel()
        }
        return AutoBrushModel.Instance
    }


    brush_strange_info: ProtoRecvVObj<13300>
    assist_data: ProtoRecvVObj<13324>
    auto_brush_state
    level = 0
    cache_level = 0
    max_level
    open_auto_level
    init_state = false
    rank_data
    my_rank
    rank_type
    next_stage_reward_level
    red_flag = 0
    failue_scmd
    private arrow_step = 1
    private is_click_step_5 = false


    last_failue_level = 0
    public constructor() {
        super()
    }

    /**
     * 重置模块数据
     */
    ResetData() {
        this.max_level = Config.PRELOAD_CLIENT_CONFIG.ConfigAutoBrush["max_level"]
        this.open_auto_level = Config.PRELOAD_CLIENT_CONFIG.ConfigAutoBrush["open_auto_level"]
        this.init_state = false
        this.level = 0
        this.cache_level = 0
        this.rank_data = undefined
        this.my_rank = undefined
        this.next_stage_reward_level = undefined
        this.red_flag = 0
        this.failue_scmd = false
        this.last_failue_level = 0
    }


    /**
     * 保存刷怪记录
     * @param info 信息
    */
    SetBrushStrangeInfo = (info) => {
        this.brush_strange_info = info
        this.UpdateBrushRedState()
        this.Fire(AutoBrushModel.UPDATE_BRUSH_STRANGE_INFO)
    }

    /**
     * 获取刷怪记录
    */
    GetBrushStrangeInfo = () => {
        return this.brush_strange_info
    }

    /**
     * 设置自动刷怪状态
     * @param state状态
     * @version Egret 5.2.0
    */
    SetAutoBrushStrangeState = (state) => {
        this.auto_brush_state = state
        if (state && SceneManager.GetInstance().IsFieldScene()) {
            let info = this.GetBrushStrangeInfo()
            if(info && info.current_times != info.need_times)
            {
                AutoFightManager.GetInstance().StartFieldSceneAutoFight()
            }
        }
        this.UpdateBrushRedState()
        this.Fire(AutoBrushModel.UPDATE_BRUSH_STRANGE_STATE)
    }

    /**
     * 获取自动刷怪状态
    */
    GetAutoBrushStrangeState = () => {
        return this.auto_brush_state
    }

    SetLevel = (level) => {
        this.level = level
        if(!this.cache_level){
            this.cache_level = level
        }
        this.UpdateStageRed()
        this.Fire(AutoBrushModel.UPDATE_LEVEL)
        PlatformManager.GetInstance().DataPost(7)

    }

    /**
     * 获取当前打过的关卡数
    */
    GetLevel = (): number => {
        return this.level
    }

    CheckDoneState = () => {
        let level = this.GetLevel()
        return level >= this.max_level
    }

    GetAutoOpenLevel = () => {
        return this.open_auto_level
    }

    SetRankData(data) {
        this.rank_data = data
        this.Fire(AutoBrushModel.UPDATE_RANK)
    }

    GetRankData() {
        return this.rank_data
    }

    SetMyRank(rank) {
        this.my_rank = rank
    }

    GetMyRank() {
        return this.my_rank
    }

    /**
     * 榜单类型：0 本服 ； 1 跨服
     * @param type 
     */
    SetRankType(type) {
        this.rank_type = type
    }

    GetRankType() {
        return this.rank_type
    }

    UpdateBrushRedState() {
        let bool = false
        let info = this.GetBrushStrangeInfo()
        let autoState = this.GetAutoBrushStrangeState();
        //自动闯关时不显示闯关红点
        if (!autoState && info) {
            if (info.current_times == info.need_times) {
                let level = this.GetLevel()
                let next_level = level + 1
                let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, next_level, false)
                if (cfg) {
                    bool = RoleManager.GetInstance().GetMainRoleVo().fighting >= cfg.power
                }
            }
        }

        this.SetRedFlag(AutoBrushModel.RedFlag.Brush, bool)
    }

    GetRedState() {
        let bool
        //接取激活妖物任务时屏蔽斩妖的红点
        let main_role_vo = TaskModel.GetInstance().GetMainLineTaskVo()
        if(main_role_vo && main_role_vo.task_id == AutoBrushModel.IgnoreRedTaskID && main_role_vo.has_finish == 0){
            bool = false
        }
        else{
            bool = this.red_flag > 0
        }


        return bool
    }

    /**
     * 配置内的是5s数值
     */
    GetHourValue(value) {
        return value *= 720
    }


    ConvertValue(value) {
        //超过千万后以w为单位,保留两位小数点
        if (value > 10000000) {
            value = (value / 10000).toFixed(2)
            value += "万/时"
        }
        else {
            value += "/时"
        }
        return value
    }


    SetNextStageRewardLevel(level) {
        this.next_stage_reward_level = level
        this.Fire(AutoBrushModel.UPDATE_STAGE_REWARD_LEVEL)
        this.UpdateStageRed()
    }


    UpdateStageRed() {
        let level = this.GetLevel()
        let stage_level = this.GetNextStageRewardLevel()
        let bool = false
        if (stage_level && level >= stage_level) {
            bool = true
        }
        this.SetRedFlag(AutoBrushModel.RedFlag.Stage, bool)
        RedDotController.ins.up(RedKey.AUTO_BRUSH_STAGE, bool ? 1 : 0);
    }

    GetNextStageRewardLevel() {
        return this.next_stage_reward_level
    }

    SetRedFlag(flag?, state?) {

        if (!flag) {
            return
        }
        let now_flag = 0
        if (state) {
            now_flag = this.red_flag | flag
        } else {
            now_flag = this.red_flag & ~flag
        }
        if (now_flag == this.red_flag) {
            return
        }
        this.red_flag = now_flag
        this.Fire(AutoBrushModel.REFRESH_RED_FLAG, flag)
        GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "AutoBrushBaseView", EnumAutoBrushTabType.eAutoBrush, this.GetRedState())
    }

    HasRedFlag(flag?) {
        if (!flag) {
            return false
        }
        return ((this.red_flag & flag) != 0)
    }

    SetStep(step) {
        this.arrow_step = step
    }

    GetStep() {
        return this.arrow_step
    }

    CreatArrow(this_obj, obj, real_step) {
        if (this.arrow_step == 6) return
        if (real_step == 5 && this.arrow_step < 2) {
            this.is_click_step_5 = true
        }
        GlobalEventSystem.Fire(EventName.HIDE_FINGER, obj)
        let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
        let step
        let layer = "UI"
        let is_finish = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().has_finish
        if (task_id && task_id == 100811 && (real_step - 1) == this.arrow_step && !is_finish) {
            this.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13322, "c", real_step - 1)
            switch (real_step) {
                case 1:
                    step = { "direction": 8, "text": "发现<font color='#0a9f42'>法器</font>的线索！<br>斩妖通过<font color='#0a9f42'>指定关卡</font>即可领取！", "off_x": -150, "off_y": -50 }
                    break;
                case 2:
                    step = { "direction": 8, "text": "还有未领取的<font color='#0a9f42'>奖励</font>呢~<br>达成目标后要记得来<font color='#0a9f42'>领取</font>哦！", "off_x": -150, "off_y": -50 }
                    break;
                case 3:
                    step = { "direction": 2, "text": "点击这里可以查看获取的<font color='#0a9f42'>法器</font>线索", "effect_scaleX": 0.65, "effect_scaleY": 0.9 }
                    break;
                case 4:
                    step = { "direction": 2, "text": "将收集到的<font color='#0a9f42'>线索</font>放入<font color='#0a9f42'>法器</font>", "effect_scaleX": 0.65, "effect_scaleY": 0.9 }
                    break;
                case 5:
                    step = { "direction": 2, "text": "放入<font color='#0a9f42'>全部线索</font>激活<font color='#0a9f42'>法器</font>", "effect_scaleX": 0.65, "effect_scaleY": 0.9 }
                    break;
                case 6:
                    step = { "direction": 6, "text": "点击返回主界面", "effect_scaleX": 0.35, "effect_scaleY": 1 }
                    break;
            }
        }
        if (this.IsSpeTaskId(task_id)&& real_step == this.arrow_step && real_step == 2 && this.arrow_step == 2) {
            if (this.is_click_step_5) {
                this.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13322, "c", 100)
                return
            }
            this.Fire(AutoBrushModel.NEXT_STEP_ARROW, 3)
        }
        if (this.IsSpeTaskId(task_id) && real_step == this.arrow_step && real_step == 5 && this.arrow_step == 5) {
            this.Fire(AutoBrushModel.NEXT_STEP_ARROW, 6)

        }
        if (step) {
            GlobalEventSystem.Fire(EventName.SHOW_FINGER, this_obj, obj, layer, null, null, null, null, step, true)
            this.arrow_step += 1
        }
    }

    StopAutoBrushState() {
        let state = this.GetAutoBrushStrangeState()
        if (state) {
            this.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 1)
        }
    }

    SetFailueScmd(scmd){
        //失败退出 自动状态取消
        this.failue_scmd = scmd
    }

    GetFailueState(){
        let bool = true
        if(this.failue_scmd){
            bool = this.failue_scmd.state == 1
        }
        return bool
    }

    /**
     * 返回请求协助ID, ID大约0说明提交了协助
     * @returns 
     */
    GetAssistID():number{
        let brush_strange_info = this.GetBrushStrangeInfo()
        if(brush_strange_info){
            return brush_strange_info.assist_id
        }
        return 0
    }


    /**
     * 协助者ID, 发起了请求且有人接受了才会有数据
     * @returns 
     */
     GetAssisterID():number{
        let brush_strange_info = this.GetBrushStrangeInfo()
        if(brush_strange_info){
            return brush_strange_info.assister_id
        }
        return 0
    }


    /**
     * 设置协助信息
     * @param data 
     */
    SetAssistData(data:ProtoRecvVObj<13324>){
        this.assist_data = data
        this.Fire(AutoBrushModel.UPDATE_ASSIST)
    }

    /**
     * 获取协助信息
     * @returns 
     */
    GetAssistData():ProtoRecvVObj<13324>{
        return this.assist_data
    }

    public IsSpeTaskId(task_id){
        return task_id==100811
    }

    /**是否获得指定任务道具
     */
    public IsGetSpeTaskItem(item_id){

        //判断古宝是否激活
        let main_task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
        if(!main_task_vo) return false
        if(MonsterModel.GetInstance().GetActBySoapId(main_task_vo.id)){
            return true
        }
        if(item_id==AutoBrushModel.Task_Item_ID_1){
            // if(this.IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_2)){
            //     return true
            // }
            if(MonsterModel.GetInstance().GetActByDebrisId(main_task_vo.id,1)){
                return true
            }
        }
        if(item_id==AutoBrushModel.Task_Item_ID_2){
            if(MonsterModel.GetInstance().GetActByDebrisId(main_task_vo.id,4)){
                return true
            }
        }

        if(GoodsModel.GetInstance().GetBagGoodsNum(item_id)>0){
            return true
        }
        return false
    }
}
window["AutoBrushModel"] = AutoBrushModel