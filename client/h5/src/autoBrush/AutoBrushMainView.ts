import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildAssistType, GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, Util } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { StoryModel } from "../commonModel/StoryModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"

export class AutoBrushMainView extends BaseItem1 {

    erlang_parser: ErlangParser
    auto_brush_model: AutoBrushModel
    res_mgr: ResManager
    goods_model: GoodsModel
    guild_model: GuildModel
    show_goods_vo
    /**
     * 当前展示的关卡
     */
    show_level

    reward_item_list
    has_set_effect = false
    tween_id
    public constructor(parent?) {
        super(parent)
        this.base_file = "autoBrush"
        this.layout_file = "AutoBrushMainView"

        this.auto_brush_model = AutoBrushModel.GetInstance()
        this.erlang_parser = ErlangParser.GetInstance()
        this.res_mgr = ResManager.GetInstance()
        this.goods_model = GoodsModel.GetInstance()
        this.guild_model = GuildModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
            //this.CreatArrow()
            if (!this.task_model.IsSpecialBrushTask()) {
            let step = this.auto_brush_model.GetStep()
            if (step == 0 || step == 1) {
                this.auto_brush_model.CreatArrow(this, this._box_show, step + 1)
                }
            }


        }
    }

    public LoadSuccess() {

        this._html_exp.style.color = "#663915"
        this._html_exp.style.fontSize = 24
        this._html_exp.style.wordWrap = false

        this._html_desc.style.color = "#663915"
        this._html_desc.style.fontSize = 22
        this._html_desc.style.wordWrap = false

        this._panel_reward.hScrollBarSkin = ""

        //resource/game/autoBrush/texture/ui_zy_05.png
        this.res_mgr.SetTexture(this, this._img_bg4, GameResPath.GetIcon("autoBrush", "ui_zy_05"))
        this.tween_id = SYTweenLite.to(this, this._img_show, SYTweenLite.UiAnimationType.ANCHORED_POSY, this._img_show.y + 20, 1.5, null, SYTweenFunc.PINGPONG, true)

        this.InitEvent()
        this.UpdateView()

        this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13301)//请求排行榜
        this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13324)//玩家请求协助次数信息

        this.UpdateTaskStep()
    }


    public UpdateTaskStep() {
        // if (!this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap)) {
        // 	return
        // }
        // let step = this.story_model.GetTaskStep(TaskTipType.ActiveSoap)
        // if (step == 1) {
        //     let step1 = { "direction": 2, "text": "点击获取法器线索","off_x":-60 }
        //     GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._img_show, "UI", null, null, null, null, step1, true)
        // }else{
        //     GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._img_show)
        // }
    }

    public InitEvent() {

        // this.BindEvent(this.story_model, StoryModel.EventName.UPDATE_TASK_STEP, () => {
        //    // this.UpdateTaskStep()
        // })


        this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
            if (this.use_delete_method) {
                return
            }
            if (!this.task_model.IsSpecialBrushTask()) return
            if (this.task_model.IsCurrMainTaskHasFinish()) return
            for (let _tmpi in goods_list) {
                let vo = goods_list[_tmpi]
                if (vo.type_id >= AutoBrushModel.Task_Item_ID_1 && vo.type_id <= AutoBrushModel.Task_Item_ID_2) {
                    // if(!this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap))return

                    let boo1 = AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_1)
                    let boo2 = AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_2)

                    if (!boo1&& this.story_model.curr_view_story_step==0) {
                        this.story_model.curr_view_story_step = 0
                        GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_show)
                    } else if (boo1 && !boo2&& this.story_model.curr_view_story_step==1) {
                        this.story_model.curr_view_story_step = 1
                        GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_show)
                    } else if (boo1 && boo2 && this.story_model.curr_view_story_step <= 1) {
                        GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_show)
                        this.story_model.curr_view_story_step = 2
                        GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
                    }
                    break
                }
            }
        })



        Util.AddClickEvent(this._box_enter, () => {
            if (SceneManager.GetInstance().IsMainLineDungeonScene()) {
                Message.show("正在闯关中")
                return
            }

            let auto_brush_data = this.auto_brush_model.GetBrushStrangeInfo()
            if (!auto_brush_data) {
                return
            }

            if (auto_brush_data.current_times == auto_brush_data.need_times) {
                let enter_func = () => {
                    this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13305, "c", 0)
                    GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "AutoBrushBaseView")
                }

                let assist_id = this.auto_brush_model.GetAssistID()
                let assister_id = this.auto_brush_model.GetAssisterID()
                if (assist_id > 0 && assister_id == 0) {
                    Alert.Show("当前发送了协助请求但是还没有人协助,是否取消协助请求进入", Alert_Type.Two, () => {
                        this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40403, "l", assist_id)
                        enter_func()
                    })
                    return
                }
                else {
                    enter_func()
                }
            }
            else {
                Message.show("先去击败小妖再来挑战吧")
            }
        }, this, true)

        Util.AddClickEvent(this._img_rank, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "AutoBrushRankView")
        }, this, true)


        Util.AddClickEvent(this._box_show, () => {
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_show)
            this.auto_brush_model.CreatArrow(this, this._box_show, 2)
            let stage_level = this.auto_brush_model.GetNextStageRewardLevel()
            let level = this.auto_brush_model.GetLevel()
            if (stage_level && level >= stage_level) {
                this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13310, "l", stage_level)//下一个阶段奖励关卡
            }
            else {
                if (this.show_goods_vo) {
                    UIToolTipMgr.GetInstance().AppendIllusionTips(this.show_goods_vo.type_id)
                }
            }


            // if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap) 
            // && !this.task_model.IsCurrMainTaskHasFinish()
            // &&this.story_model.GetTaskStep(TaskTipType.ActiveSoap)==1) {
            //     this.story_model.UpdateTaskStep(TaskTipType.ActiveSoap,2)
            // }
        }, this, true)

        Util.AddClickEvent(this._box_click, () => {
            let stage_level = this.auto_brush_model.GetNextStageRewardLevel()
            let level = this.auto_brush_model.GetLevel()
            if (stage_level && level >= stage_level) {
                this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13310, "l", stage_level)//下一个阶段奖励关卡
            }
        }, this, false)


        Util.AddClickEvent(this._lb_go, () => {

            if (!SceneManager.GetInstance().IsFieldScene()) {
                Message.show("当前场景不可前往")
                return
            }


            let state = this.auto_brush_model.GetAutoBrushStrangeState()
            if (state) {
                AutoFightManager.GetInstance().StartFieldSceneAutoFight()
            }
            else {
                this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 0)
            }
            GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "AutoBrushBaseView")
        }, this, false)


        Util.AddClickEvent(this._box_assist, () => {

            let is_open = this.guild_model.IsOpenAssist(GuildAssistType.TYPE_MAIN_LINE_BOSS)
            if (!is_open) {
                Message.show(`${this.guild_model.GetAssistOpenDesc(GuildAssistType.TYPE_MAIN_LINE_BOSS)}`)
                return
            }


            if (this.auto_brush_model.CheckDoneState()) {
                return
            }

            let assist_data = this.auto_brush_model.GetAssistData()
            if (!assist_data) {
                return
            }

            if (assist_data.next_ask_time > TimeUtil.getServerTime()) {
                Message.show("冷却中")
                return
            }


            let key_cfg = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_key_value && Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_key_value[2]
            if (key_cfg) {
                if (assist_data.daily_ask_time >= key_cfg.value) {
                    Message.show("次数不足")
                    return
                }
                let next_level = this.auto_brush_model.GetLevel() + 1
                this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", AutoBrushModel.AssistType, AutoBrushModel.AssistSubType, next_level, AutoBrushModel.AssistTargetId)
            }
        }, this, true)

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_LEVEL, () => {
            this.UpdateLevel()
            this.UpdateStageReward()
            // if(this.UpdateAssistShowState()){
            //     this.UpdateAssistEnterTipsState()
            //     this.UpdateAssistBtnState()
            // }
        })


        this.BindEvent(this.guild_model, GuildEvent.CHANGED_CONDS_ASSIST, () => {
            if (this.UpdateAssistShowState()) {
                this.UpdateAssistEnterTipsState()
                this.UpdateAssistBtnState()
            }
        })


        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_BRUSH_STRANGE_INFO, () => {
            this.UpdateBrushStrangeInfo()
            this.UpdateAssistEnterTipsState()
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_RANK, () => {
            this.UpdateRank()
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.REFRESH_RED_FLAG, (flag, state) => {
            if (flag == AutoBrushModel.RedFlag.Brush) {
                this.UpdateBrushRed()
            } else if (flag == AutoBrushModel.RedFlag.Stage) {
                this.UpdateStageRed()
            }
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_STAGE_REWARD_LEVEL, () => {
            this.UpdateStageReward()
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_ASSIST, () => {
            this.UpdateAssistBtnState()
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_BRUSH_STRANGE_STATE, () => {
            this.UpdateBrushRed()
        })

    }



    public UpdateView() {
        this.UpdateLevel()
        this.UpdateReward()
        this.UpdateStageReward()
        this.UpdateBrushStrangeInfo()
        this.UpdateRank()
        this.UpdateExp()
        this.UpdateBrushRed()
        this.UpdateStageRed()
        if (this.UpdateAssistShowState()) {
            this.UpdateAssistEnterTipsState()
            this.UpdateAssistBtnState()
        }
    }

    public UpdateReward() {
        let config_enchantment_guard_boss = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_boss
        let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, this.show_level, false, config_enchantment_guard_boss)
        // let cfg = config_enchantment_guard_boss && config_enchantment_guard_boss[this.show_level]
        // if(!cfg){
        //     //如果满层了 显示最后一层的奖励
        //     cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name,this.show_level - 1, false, config_enchantment_guard_boss)
        // }
        if (cfg) {
            let reward_list = []
            let my_career = RoleManager.GetInstance().GetMainRoleCareer()
            //金币
            if (cfg.coin) {
                reward_list.push({
                    0: 3,
                    1: 0,
                    2: cfg.coin
                })
            }

            //other_reward_list 固定奖励
            if (cfg.other_reward_list) {
                let other_reward_list = JSON.parse(cfg.other_reward_list)
                for (let i in other_reward_list) {
                    if (my_career == Number(other_reward_list[i][0])) {
                        for (let j in other_reward_list[i][1]) {
                            reward_list.push(other_reward_list[i][1][j])
                        }
                    }
                }
            }

            //other_goods_pool 额外奖励
            if (cfg.other_goods_pool) {
                let other_goods_pool = JSON.parse(cfg.other_goods_pool)
                for (let i in other_goods_pool) {
                    reward_list.push(other_goods_pool[i])
                }
            }

            if (!this.reward_item_list) {
                this.reward_item_list = []
            }
            let len = reward_list.length
            if (len == 0) {
                this._panel_reward.visible = false
                return
            }
            this._panel_reward.visible = true

            let width = len * 85 + 42 * (len - 1)
            if (width > 635)
                width = 635
            this._panel_reward.width = width

            for (let i in reward_list) {
                var item: EquipmentItem = this.reward_item_list[i]
                var info = reward_list[i]
                if (!item) {
                    item = new EquipmentItem(this._panel_reward)
                    item.Load()
                    item.SetItemSize(85, 85)
                    this.reward_item_list[i] = item
                }
                item.SetVisible(true)
                let [type_id, lock] = this.goods_model.GetMappingTypeId(info[0], info[1])
                let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
                if (goods_vo) {
                    item.SetData(goods_vo.type_id, info[2], lock)
                }
                item.SetPosition(Number(i) * (85 + 42), 0)
            }

            for (let i = reward_list.length; i < this.reward_item_list.length; i++) {
                this.reward_item_list[i].SetVisible(false)
            }
        }
    }

    public UpdateLevel() {
        let bool = this.auto_brush_model.CheckDoneState()
        let level
        if (bool) {
            //如果满层了 显示最后一层的内容
            level = this.auto_brush_model.GetLevel()
        }
        else {
            level = this.auto_brush_model.GetLevel() + 1
        }
        this.show_level = level
        this._lb_level.text = `第${level}关`
    }

    public UpdateExp() {

        let config_enchantment_guard_boss = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_boss

        let desc
        if (this.auto_brush_model.CheckDoneState()) {
            let now_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, this.show_level, false, config_enchantment_guard_boss)
            if (now_cfg) {
                desc = `${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(now_cfg.exp_add))}`
            }
            else {
                desc = "0/时"
            }
        }
        else {
            // let now_cfg = config_enchantment_guard_boss && config_enchantment_guard_boss[this.show_level - 1]
            let now_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, this.show_level - 1, false, config_enchantment_guard_boss)


            if (now_cfg) {
                desc = `${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(now_cfg.exp_add))}`
            }
            else {
                desc = "0/时"
            }

            let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, this.show_level, false, config_enchantment_guard_boss)
            // let cfg = config_enchantment_guard_boss && config_enchantment_guard_boss[this.show_level]
            if (cfg) {
                desc += ` `
                if (now_cfg) {
                    desc += HtmlColorTxt(`+${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(cfg.exp_add) - AutoBrushModel.GetInstance().GetHourValue(now_cfg.exp_add))}`, "'#0a953e'")
                }
                else {
                    desc += HtmlColorTxt(`+${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(cfg.exp_add))}`, "'#0a953e'")
                }
            }
        }


        this._html_exp.innerHTML = desc
    }

    public UpdateBrushStrangeInfo() {
        let info = this.auto_brush_model.GetBrushStrangeInfo()
        let main_role_vo = TaskModel.GetInstance().GetMainLineTaskVo()
        //接取激活妖物任务时屏蔽斩妖入口
        if (info && (!main_role_vo || !(main_role_vo.task_id == AutoBrushModel.IgnoreRedTaskID && main_role_vo.has_finish == 0))) {
            if (info.current_times == info.need_times) {
                this._box_enter.visible = true
                this._html_desc.visible = false
                this._lb_go.visible = false
            }
            else {
                this._box_enter.visible = false
                this._html_desc.visible = true
                this._lb_go.visible = true
                this._html_desc.innerHTML = `还需要击败${HtmlColorTxt(info.need_times - info.current_times, ColorUtil.GetColorLight(ColorType.RED))}个野外妖物才可闯关`
            }
        }
        else {
            this._box_enter.visible = false
            this._html_desc.visible = false
            this._lb_go.visible = false
        }
        // let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
        // if (task_id && task_id == 100811) {
        //     this._box_enter.visible = false
        // }
    }

    public UpdateRank() {
        let data = this.auto_brush_model.GetRankData()
        if (data) {
            let first_data
            for (let v of data) {
                if (v.rank == 1) {
                    first_data = v
                    break
                }
            }
            if (first_data) {
                let rank_type = this.auto_brush_model.GetRankType()
                let role_name
                //榜单类型：0 本服 ； 1 跨服
                if (rank_type == 1) {
                    role_name = `S${first_data.server_num}.${first_data.role_name}`
                }
                else {
                    role_name = first_data.role_name
                }
                this._lb_first_level.text = `${first_data.level}关`
                this._lb_first_name.text = role_name
            }
            else {
                this._lb_first_level.text = "暂无排名"
                this._lb_first_name.text = ""
            }
        }
        else {
            this._lb_first_level.text = "暂无排名"
            this._lb_first_name.text = ""
        }
    }


    public UpdateStageReward() {
        let config_enchantment_guard_stage_reward = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_stage_reward
        if (config_enchantment_guard_stage_reward) {
            let stage_level = this.auto_brush_model.GetNextStageRewardLevel()
            let level = this.auto_brush_model.GetLevel()
            let stage_reward
            if (stage_level) {
                stage_reward = config_enchantment_guard_stage_reward[stage_level]
            }
            else {
                //顶层显示最后的阶段奖励
                for (let i in config_enchantment_guard_stage_reward) {
                    stage_reward = config_enchantment_guard_stage_reward[i]
                }
            }

            if (stage_reward) {
                if (level >= stage_level) {
                    this._lb_level_reward.text = `点击领取`
                }
                else {
                    this._lb_level_reward.text = `第${stage_reward.gate}关奖励`
                }

                let reward
                if (stage_reward.reward) {
                    reward = JSON.parse(stage_reward.reward)[0]
                }
                if (reward) {
                    let [type_id, lock] = this.goods_model.GetMappingTypeId(reward[0], reward[1])
                    let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
                    this.res_mgr.SetTexture(this, this._img_show, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
                    this.show_goods_vo = goods_vo
                }
            }

        }
    }

    public UpdateBrushRed() {
        this._img_enter_red.visible = this.auto_brush_model.HasRedFlag(AutoBrushModel.RedFlag.Brush)
    }

    public UpdateStageRed() {
        let bool = this.auto_brush_model.HasRedFlag(AutoBrushModel.RedFlag.Stage)
        if (bool && !this.has_set_effect) {
            this.has_set_effect = true
            this.AddUIEffect("UI_partner_skillicon_01", this._box_show_effect, { x: 0, y: 0 }, 6)
        }
        this._box_show_effect.visible = bool
        this._img_show_red.visible = bool
    }

    public UpdateAssistShowState() {
        let key_cfg = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_key_value && Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_key_value[4]
        let bool = false
        if (key_cfg) {
            let level = this.auto_brush_model.GetLevel()
            bool = level >= key_cfg.value
        }
        else {
            bool = false
        }

        //协助开发条件
        let assist_open = this.guild_model.IsCanOpenAssist()
        let boo2 = assist_open && bool

        this._box_assist.visible = boo2
        return boo2
    }

    public UpdateAssistEnterTipsState() {
        let assist_id = this.auto_brush_model.GetAssistID()
        let assister_id = this.auto_brush_model.GetAssisterID()

        //按钮上的求助提示
        this._img_assist_tips.visible = assist_id > 0 && assister_id > 0
    }

    public UpdateAssistBtnState() {
        let assist_data = this.auto_brush_model.GetAssistData()
        if (assist_data) {
            if (assist_data.next_ask_time > TimeUtil.getServerTime()) {
                this._img_assist_bg.skin = GameResPath.GetIcon("autoBrush", "ui_zy_24")
                this._lb_assist_time.visible = true
                this.StartCountTime(() => {
                    let assist_data = this.auto_brush_model.GetAssistData()
                    if (assist_data) {
                        let left_time = assist_data.next_ask_time - TimeUtil.getServerTime()
                        if (left_time > 0) {
                            this._lb_assist_time.text = `${left_time}S`
                        }
                        else {
                            this.CancelCountTime()
                            this.UpdateAssistBtnState()
                        }
                    }
                    else {
                        this.CancelCountTime()
                    }
                })
            }
            else {
                this._lb_assist_time.visible = false
                this._img_assist_bg.skin = GameResPath.GetIcon("autoBrush", "ui_zy_23")
            }
        }
        else {
            this._lb_assist_time.visible = false
            this._img_assist_bg.skin = GameResPath.GetIcon("autoBrush", "ui_zy_23")
        }
    }

    assist_func
    assist_time_id
    StartCountTime(func?) {
        this.CancelCountTime()
        this.assist_func = func
        this.assist_time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
        func()
    }

    CancelCountTime() {
        if (this.assist_time_id) {
            GlobalTimerQuest.CancelQuest(this.assist_time_id)
            this.assist_func = null
            this.assist_time_id = null
        }
    }

    public DeleteMe() {
        this.CancelCountTime()
        if (this.reward_item_list) {
            for (let item of this.reward_item_list) {
                item.DeleteMe()
            }
            this.reward_item_list = undefined
        }
        this.show_goods_vo = undefined
        this.has_set_effect = false
        super.DeleteMe()
    }

    // private CreatArrow() {
    //     let task_id = TaskModel.GetInstance().GetMainLineTaskVo().task_id
    //     if (task_id == 100811) {
    //         let step = { "direction": 6, "text": "点击开始斩妖之旅吧！" }
    //         GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_enter, "UI", null, null, null, null, step, true)
    //     }
    // }


    public createChildren() {
        if (this["GetComponents"]) {
            this["GetComponents"]()
            this.is_get = true
        }
        this.story_obj_list = this.story_obj_list || {}

        if (this.task_model.IsSpecialBrushTask()) {
            if (!AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_1)) {
                this.story_model.curr_view_story_step = 0
                this.story_obj_list[TaskTipType.ActiveSoap] = [this._box_show, this._box_show]
            } else if (AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_1)
                && !AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_2)) {
                this.story_model.curr_view_story_step = 1
                this.story_obj_list[TaskTipType.ActiveSoap] = [this._box_show, this._box_show]
            }
        }


        super.createChildren()
    }


    _img_bg: Laya.Image
    _img_bg4: Laya.Image
    _img_bg5: Laya.Image
    _img_bg2: Laya.Image
    _img_bg6: Laya.Image
    _img_bg7: Laya.Image
    _img_bg8: Laya.Image
    _img_rank: Laya.Image
    _img_bg3: Laya.Image
    _lb_first_name: Laya.Label
    _lb_first_level: Laya.Label
    _lb_level_reward: Laya.Label
    _lb_level: Laya.Label
    _box_show_effect: Laya.Box
    _img_show: Laya.Image
_img_show_red:Laya.Image
    _box_show: Laya.Box
    _box_click: Laya.Box
    _img_title: Laya.Image
    _html_exp: Laya.HTMLDivElement
    _panel_reward: Laya.Panel
    _box_enter: Laya.Box
    _img_enter: Laya.Image
    _lb_enter: Laya.Label
    _img_enter_red: Laya.Image
    _img_assist_tips: Laya.Image
    _html_desc: Laya.HTMLDivElement
    _lb_go: Laya.Label
    _box_assist: Laya.Box
    _img_assist_bg: Laya.Image
    _lb_assist_time: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg4,
            this._img_bg5,
            this._img_bg2,
            this._img_bg6,
            this._img_bg7,
            this._img_bg8,
            this._img_rank,
            this._img_bg3,
            this._lb_first_name,
            this._lb_first_level,
            this._lb_level_reward,
            this._lb_level,
            this._box_show_effect,
            this._img_show,
this._img_show_red,
            this._box_show,
            this._box_click,
            this._img_title,
            this._html_exp,
            this._panel_reward,
            this._box_enter,
            this._img_enter,
            this._lb_enter,
            this._img_enter_red,
            this._img_assist_tips,
            this._html_desc,
            this._lb_go,
            this._box_assist,
            this._img_assist_bg,
            this._lb_assist_time,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg4",
                "_img_bg5",
                "_img_bg2",
                "_img_bg6",
                "_img_bg7",
                "_img_bg8",
                "_img_rank",
                "_img_bg3",
                "_lb_first_name",
                "_lb_first_level",
                "_lb_level_reward",
                "_lb_level",
                "_box_show_effect",
                "_img_show",
"_img_show_red",
                "_box_show",
                "_box_click",
                "_img_title",
                "_html_exp",
                "_panel_reward",
                "_box_enter",
                "_img_enter",
                "_lb_enter",
                "_img_enter_red",
                "_img_assist_tips",
                "_html_desc",
                "_lb_go",
                "_box_assist",
                "_img_assist_bg",
                "_lb_assist_time",
            ])
    }
}
window["AutoBrushMainView"] = AutoBrushMainView