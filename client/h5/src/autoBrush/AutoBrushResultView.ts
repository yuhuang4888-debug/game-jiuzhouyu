import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class AutoBrushResultView extends BaseView1 {

    static OpenTweenData = {
        //下半部分界面
        ViewInDelayTime:300,
        ViewInTime : 400,
        ViewInStartPos: -447,
        ViewInStartAlpha:0,

        //标题背景
        TitleBgInDelayTime: 200,
        TitleBgInTime : 200,
        TitleBgInStartPos: 75,
        TitleBgInStartAlpha:0,

        //标题
        TitleInDelayTime:0,
        TitleInTime: 150,
        TitleInStartAlpha: 0,
        TitleInStartScale: 1.5,
        TitleInEndScale: 2,
        TitleLessenTime:200,
        TitleLessenEndScale:1,

        //两边的云
        YunInDelayTime: 600,
        YunInTime : 600,
        YunInStartPos: -150,
        YunInStartAlpha:0,

    }

    static localBackOut = function(t: number, b: number, c: number, d: number, s: number = 1.00158): number {
        return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    }

    auto_brush_model: AutoBrushModel
    res_mgr: ResManager
    goods_model: GoodsModel

    time_event_id
    left_time = 10
    end_time
    reward_data
    reward_item_list
    voice
    ShowFinger
    ClearPassMainStep
    cache_img_bg9_y
    cache_img_bg6_y
    cache_img_bg7_x
    cache_img_bg8_x
    
    public constructor() {
        super()
        this.base_file = "autoBrush"
        this.layout_file = "AutoBrushResultView"
        this.layer_value = Enum_UILayer.Activity

        this.use_background2 = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true

        this.auto_brush_model = AutoBrushModel.GetInstance()
        this.res_mgr = ResManager.GetInstance()
        this.goods_model = GoodsModel.GetInstance()

        this.load_callback = () => {
            this.LoadSuccess()
            this.ShowFinger()
        }

        this.open_callback = () => {
           this.StartAni()
        }

        this.close_callback = () => {
            if(this._img_bg9){
                Laya.Tween.clearAll(this._img_bg9)
                Laya.Tween.clearAll(this._img_bg6)
                Laya.Tween.clearAll(this._img_title)
                Laya.Tween.clearAll(this._img_bg7)
                Laya.Tween.clearAll(this._img_bg8)
            }
            if (SceneManager.GetInstance().IsMainLineDungeonScene()) {
                BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
            }
        }

        this.destroy_callback = () => {
            this.Remove()
        }


        this.ClearPassMainStep = () => {
            let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
            if (task_vo && this.task_model.IsPassMainDungeon(task_vo.task_id, false)) {
                if (this.story_model.curr_view_story_step > 0) {
                    this.story_model.curr_view_story_step = 0
                }
            }
        }


        //引导
        this.ShowFinger = () => {
            let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
            if (task_vo && this.task_model.IsPassMainDungeon(task_vo.task_id, false) && this.task_model.IsAllStepFinish(task_vo.task_id)) {
                let step_cfg = this.task_model.GetNowGuideCfg(false)
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_exit, this.layer_value, null, null, null, null, step_cfg, true)
            }
        }
    }

    LoadSuccess() {
        //resource/game/autoBrush/other/com_up_bg1.png
        this.res_mgr.SetTexture(this, this._img_bg9, GameResPath.GetIconOtherPath("autoBrush", "com_up_bg5"))

        //resource/game/autoBrush/other/ui_copy_88.png
        this.res_mgr.SetTexture(this, this._img_bg2, GameResPath.GetIconOtherPath("autoBrush", "ui_copy_88"))

        //resource/game/autoBrush/other/ui_copy_88.png
        this.res_mgr.SetTexture(this, this._img_bg3, GameResPath.GetIconOtherPath("autoBrush", "ui_copy_88"))

        // this._img_title.anchorX = this._img_title.anchorY = 0.5
        // @ts-ignore
        this._img_title.runCallLater(this._img_title._sizeChanged)

        this.cache_img_bg9_y = this._img_bg9.y
        this.cache_img_bg6_y = this._img_bg6.y
        this.cache_img_bg7_x = this._img_bg7.x
        this.cache_img_bg8_x = this._img_bg8.x

        this._panel_reward.hScrollBarSkin = ""

        this.voice = CommonManager.GetInstance().PlayFightingVoice(2)

        this.InitEvent()
        this.UpdateView()
        if (this.task_model.GetAutoTaskSetting()) {
            this.StartCountTime()
        }
    }

    InitEvent() {
        Util.AddClickEvent(this._box_exit, () => {
            this.Close()
        }, this, true)


        this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, () => {
            this.ShowFinger()
        })
    }

    UpdateView() {
        this.UpdateExpAndCoin()
        this.UpdateReward()
    }

    UpdateExpAndCoin() {
        let level = this.auto_brush_model.GetLevel()
        let last_level = level - 1
        let config_enchantment_guard_boss = Config.PRELOAD_SERVER_CONFIG.config_enchantment_guard_boss
        let last_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, last_level, false, config_enchantment_guard_boss)
        // let last_cfg = config_enchantment_guard_boss && config_enchantment_guard_boss[last_level]
        if (last_cfg) {
            this._lb_old_exp.text = `${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(last_cfg.exp_add))}`
            this._lb_old_coin.text = `${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(last_cfg.coin_add))}`
        }
        else {
            this._lb_old_exp.text = `0/时`
            this._lb_old_coin.text = `0/时`
        }

        let now_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_enchantment_guard_boss.name, level, false, config_enchantment_guard_boss)
        // let now_cfg = config_enchantment_guard_boss && config_enchantment_guard_boss[level]
        if (now_cfg) {
            this._lb_now_exp.text = `${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(now_cfg.exp_add))}`
            this._lb_now_coin.text = `${AutoBrushModel.GetInstance().ConvertValue(AutoBrushModel.GetInstance().GetHourValue(now_cfg.coin_add))}`
        }
    }

    UpdateReward() {
        let reward_list = this.reward_data
        if (!reward_list)
            return

        let len = reward_list.length
        if (len == 0) {
            this._panel_reward.visible = false
            return
        }
        this._panel_reward.visible = true

        let width = (len - 1) * 23 + len * 85
        if (width > 518)
            width = 518

        this._panel_reward.width = width

        if (!this.reward_item_list) {
            this.reward_item_list = []
        }

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
            item.SetPosition(Number(i) * (85 + 23), 0)
        }

        for (let i = reward_list.length; i < this.reward_item_list.length; i++) {
            this.reward_item_list[i].SetVisible(false)
        }
    }

    StartCountTime() {
        this.CancelTime()
        this.end_time = this.left_time + TimeUtil.getServerTime()
        this.time_event_id = GlobalTimerQuest.AddPeriodQuest(this.OnTime, 1)
        this.OnTime()
    }


    OnTime = () => {
        let left_time = this.end_time - TimeUtil.getServerTime()
        if (left_time < 0) {
            this.CancelTime()
            this.Close()
            return
        }
        this._lb_exit.text = `完成(${left_time})`
    }

    CancelTime() {
        if (this.time_event_id) {
            GlobalTimerQuest.CancelQuest(this.time_event_id)
            this.time_event_id = undefined
        }
    }

    StartAni(){
        // 奖励栏 向下
        Laya.Tween.clearAll(this._img_bg9)
        this._img_bg9.alpha = AutoBrushResultView.OpenTweenData.ViewInStartAlpha
        this._img_bg9.y = this.cache_img_bg9_y + AutoBrushResultView.OpenTweenData.ViewInStartPos
        Laya.Tween.to(this._img_bg9, { y: this.cache_img_bg9_y, alpha: 1 }, AutoBrushResultView.OpenTweenData.ViewInTime, AutoBrushResultView.localBackOut, null, AutoBrushResultView.OpenTweenData.ViewInDelayTime)

        // 扇子 向上
        Laya.Tween.clearAll(this._img_bg6)
        this._img_bg6.alpha = AutoBrushResultView.OpenTweenData.TitleBgInStartAlpha
        this._img_bg6.y = this.cache_img_bg6_y + AutoBrushResultView.OpenTweenData.TitleBgInStartPos
        Laya.Tween.to(this._img_bg6, { y: this.cache_img_bg6_y, alpha: 1 }, AutoBrushResultView.OpenTweenData.TitleBgInTime, Laya.Ease.circOut, null, AutoBrushResultView.OpenTweenData.TitleBgInDelayTime)

        // 字体 放大缩小
        Laya.Tween.clearAll(this._img_title)
        this._img_title.alpha = AutoBrushResultView.OpenTweenData.TitleInStartAlpha
        this._img_title.scale(AutoBrushResultView.OpenTweenData.TitleInStartScale, AutoBrushResultView.OpenTweenData.TitleInStartScale)
        Laya.Tween.to(this._img_title, { scaleX: AutoBrushResultView.OpenTweenData.TitleInEndScale, scaleY: AutoBrushResultView.OpenTweenData.TitleInEndScale, alpha: 1 }, AutoBrushResultView.OpenTweenData.TitleInTime, Laya.Ease.linearIn, Laya.Handler.create(this, function(){
            Laya.Tween.to(this._img_title, { scaleX: AutoBrushResultView.OpenTweenData.TitleLessenEndScale, scaleY: AutoBrushResultView.OpenTweenData.TitleLessenEndScale }, AutoBrushResultView.OpenTweenData.TitleLessenTime, Laya.Ease.backOut)
        }), AutoBrushResultView.OpenTweenData.TitleInDelayTime)

        // 两边tips 向上
        Laya.Tween.clearAll(this._img_bg7)
        this._img_bg7.alpha = AutoBrushResultView.OpenTweenData.YunInStartAlpha
        this._img_bg7.x = this.cache_img_bg7_x - AutoBrushResultView.OpenTweenData.YunInStartPos
        Laya.Tween.to(this._img_bg7, { x: this.cache_img_bg7_x, alpha: 1 }, AutoBrushResultView.OpenTweenData.YunInTime, Laya.Ease.circOut, null, AutoBrushResultView.OpenTweenData.YunInDelayTime)

        Laya.Tween.clearAll(this._img_bg8)
        this._img_bg8.alpha = AutoBrushResultView.OpenTweenData.YunInStartAlpha
        this._img_bg8.x = this.cache_img_bg8_x + AutoBrushResultView.OpenTweenData.YunInStartPos
        Laya.Tween.to(this._img_bg8, { x: this.cache_img_bg8_x, alpha: 1 }, AutoBrushResultView.OpenTweenData.YunInTime, Laya.Ease.circOut, null, AutoBrushResultView.OpenTweenData.YunInDelayTime)
    }

    Remove() {
        this.CancelTime()
        if (this.reward_item_list) {
            for (let item of this.reward_item_list) {
                item.DeleteMe()
            }
            this.reward_item_list = undefined
        }
        if (this.voice) {
            SoundManager.GetInstance().StopSoundEffect(this.voice)
            this.voice = null
        }

        this.ClearPassMainStep()
    }

    public Open(...new_args) {
        if (new_args && new_args.length > 0) {
            this.reward_data = new_args[0]
        }
        super.Open()
    }

    _box_con: Laya.Box
    _img_bg7: Laya.Image
    _img_bg8: Laya.Image
    _img_bg6: Laya.Image
    _img_title: Laya.Image
    _img_bg9: Laya.Image
    _img_bg2: Laya.Image
    _img_bg3: Laya.Image
    _img_exp_icon: Laya.Image
    _img_bg5: Laya.Image
    _img_bg4: Laya.Image
    _img_coin_icon: Laya.Image
    _panel_reward: Laya.Panel
    _lb_old_exp: Laya.Label
    _lb_old_coin: Laya.Label
    _lb_now_exp: Laya.Label
    _lb_now_coin: Laya.Label
    _box_exit: Laya.Box
    _img_exit: Laya.Image
    _lb_exit: Laya.Label
    public GetComponents() {
        [
            this._box_con,
            this._img_bg7,
            this._img_bg8,
            this._img_bg6,
            this._img_title,
            this._img_bg9,
            this._img_bg2,
            this._img_bg3,
            this._img_exp_icon,
            this._img_bg5,
            this._img_bg4,
            this._img_coin_icon,
            this._panel_reward,
            this._lb_old_exp,
            this._lb_old_coin,
            this._lb_now_exp,
            this._lb_now_coin,
            this._box_exit,
            this._img_exit,
            this._lb_exit,
        ]
            = this.GetChildrenByNames([

                "_box_con",
                "_img_bg7",
                "_img_bg8",
                "_img_bg6",
                "_img_title",
                "_img_bg9",
                "_img_bg2",
                "_img_bg3",
                "_img_exp_icon",
                "_img_bg5",
                "_img_bg4",
                "_img_coin_icon",
                "_panel_reward",
                "_lb_old_exp",
                "_lb_old_coin",
                "_lb_now_exp",
                "_lb_now_coin",
                "_box_exit",
                "_img_exit",
                "_lb_exit",
            ])
    }
}
window["AutoBrushResultView"] = AutoBrushResultView