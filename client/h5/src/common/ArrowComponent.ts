import { ActivityIconManager } from "../commonModel/ActivityIconManager";
import { MainUIModel } from "../commonModel/MainUIModel";
import { StoryModel } from "../commonModel/StoryModel";
import { TaskTipType } from "../commonModel/TaskModel";
import { LoginModel } from "../login/LoginModel";
import { PlatformManager } from "../PlatformManager";
import { SceneManager } from "../scene/SceneManager";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SYTweenFunc } from "../util/SYTweenFunc";
import { SYTweenLite } from "../util/SYTweenLite";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { BaseItem1 } from "./BaseItem1";
import { BaseWindowComponent } from "./BaseWindowComponent";
import { EventName } from "./EventName";
import { Enum_UILayer, LayerManager } from "./LayerManager";

//箭头引导
export class ArrowComponent extends BaseItem1 {
    public target_obj: Laya.Box
    public target_self

    LoadSuccess
    SetPos
    SetSize
    ShowEffect
    SetArrowAnimation
    ClearTween
    Remove
    AutoFunc
    LocalDeleteMe

    model: StoryModel
    tween_id
    is_tween = false
    public constructor(parent, obj, target_self?) {
        super(parent)
        this.target_obj = obj
        this.target_self = target_self
        this.base_file = "mainUI"
        this.layout_file = "ArrowComponent"

        this.model = StoryModel.GetInstance()
        this.is_delay_callback = false
        this.load_callback = () => {
            this.display_obj.mouseEnabled = false
            this.display_obj.mouseThrough = false
            this.content.style.color = "#824141"
            this.content.style.align = "center"
            this.content.style.fontSize = 18
            this.content.style.wordWrap = false

            this.autoLb.style.color = "#FFFFFF"
            this.autoLb.style.align = "center"
            this.autoLb.style.fontSize = 18
            this.autoLb.style.wordWrap = false

            this.display_obj.zOrder = 2;
            this.LoadSuccess()
        }
        let layer_mgr = LayerManager.GetInstance(),
             event_name = EventName,
             local_GlobalEventSystem = GlobalEventSystem,
             local_TimeUtil = TimeUtil,
             local_Util = Util,
             local_base_window_compont = BaseWindowComponent,
            needRefresh_ = false,
            target_pos_,
            not_move_,
            step_cfg_,
            is_main_ui_arrow_,
            init_width_,
            init_height_,
            last_step_cfg_,
            endTime_,
            autoTimer_,
             cfg_offset_x = 0,
             cfg_offset_y = 0,
             arrow_offsetX = 0,
             arrow_offsetY = 0
        // local_SettingModel = SettingModel.getInstance()
        this.LoadSuccess = () => {
            this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_SECONDARY_ICON, (location_type) => {
                if (location_type == ActivityIconManager.LocationType.Right) {
                    target_pos_ = { "x": this.target_obj.x, "y": this.target_obj.y }
                    this.SetSize()
                }
            })
            this.display_obj.visible = false
            init_width_ = this.rect_conta.width
            init_height_ = this.rect_conta.height
            let onRemoveFromStage = () => {
                local_GlobalEventSystem.Fire(event_name.HIDE_FINGER, this.target_obj)
                this.DeleteMe()
            }
            this.display_obj.on(Laya.Event.REMOVED, this, onRemoveFromStage)

            if (needRefresh_) {
                this.SetPos(target_pos_, is_main_ui_arrow_, not_move_, step_cfg_)
                needRefresh_ = false
            }
        }
        this.SetPos = (target_pos, is_main_ui_arrow?, not_move?, step_cfg?, force?,lock_vis?) => {
            target_pos_ = target_pos
            not_move_ = not_move
            is_main_ui_arrow_ = is_main_ui_arrow
            step_cfg_ = step_cfg
            if (this.is_loaded) {
                step_cfg_ = step_cfg_ || this.task_model.GetNowGuideCfg(is_main_ui_arrow_)
                if (step_cfg_ && step_cfg_.text) {
                    if (step_cfg_ == last_step_cfg_ && !force) {
                        return
                    }
                    cfg_offset_x = step_cfg_.off_x ? step_cfg_.off_x : 0
                    cfg_offset_y = step_cfg_.off_y ? step_cfg_.off_y : 0
                    arrow_offsetX = step_cfg_.arrow_off_x ? step_cfg_.arrow_off_x : 0
                    arrow_offsetY = step_cfg_.arrow_off_y ? step_cfg_.arrow_off_y : 0
                    last_step_cfg_ = step_cfg_

                    this.content.innerHTML = local_Util.StrToHTML(step_cfg_.text)

                    let delay_fun = () => {
                        if (!this.use_delete_method) {
                            this.SetSize()
                            this.display_obj.visible = !lock_vis?this.story_model.GetAllFingerStatus():true
                            let direction = step_cfg_.direction
                            this.SetArrowAnimation(direction)
                            this.ShowEffect(direction)
                            if(!this.task_model.GetAutoTaskSetting()){
                                this.autoImg.visible = false
                                return
                            }
                            this.autoImg.visible = true
                            autoTimer_ = GlobalTimerQuest.AddPeriodQuest(this.AutoFunc, 1)
                            let time = step_cfg_.close_time || 10
                            endTime_ = local_TimeUtil.getServerTime() + time
                            this.AutoFunc()
                        }
                    }
                    GlobalTimerQuest.AddDelayQuest(delay_fun, 0.1)
                } else {
                    local_GlobalEventSystem.Fire(event_name.HIDE_FINGER, this.target_obj)
                }
            } else {
                needRefresh_ = true
            }
        }
        //自适应位置
        this.SetSize = () => {
            if (step_cfg_ && !this.use_delete_method) {
                let showImg = false//this.task_model.GetMainLineTaskVo() && this.task_model.GetMainLineTaskVo().task_id > 100111
                if (step_cfg_.text) {
                    let text_w = this.content.contextWidth
                    let text_h = this.content.contextHeight
                    this.content.width = text_w
                    this.content.height = text_h
                    this.rect_conta.width = this.content_bg.width = text_w + 155 - (!showImg && 102)
                    this.rect_conta.height = this.content_bg.height = Math.max(text_h + 10, 97)
                }
                let gap_width = 0
                let gap_height = 0
                gap_width = init_width_ - this.content_bg.width
                gap_height = init_height_ - this.content_bg.height
                let direction = step_cfg_.direction
                //电脑键盘数字键的2,4,8,6 分别是下，左，上，右
                if (direction == 2) {        //箭头向下的方向
                    let posX = target_pos_.x - this.rect_conta.width / 2 - this.rect_conta.x
                    this.display_obj.x = posX + this.target_obj.width / 2 + cfg_offset_x
                    let point: Laya.Point = this._parent.localToGlobal(new Laya.Point(this.display_obj.x, 0))
                    let globalX = point.x
                    let offset = 0
                    if (globalX + this.rect_conta.x < 0) {
                        offset = -(globalX + this.rect_conta.x)
                    } else if ((globalX + this.rect_conta.width + this.rect_conta.x) > layer_mgr.stageWidth) {
                        offset = -(globalX + this.rect_conta.width + this.rect_conta.x - layer_mgr.stageWidth)
                    }
                    this.display_obj.x += offset
                    this.display_obj.y = target_pos_.y - this.rect_conta.y - this.rect_conta.height - this.target_obj.height / 2 - 60 + cfg_offset_y
                    this.arrow_effect.x = this.rect_conta.x + this.rect_conta.width / 2
                    this.arrow_effect.y = 205 - gap_height + arrow_offsetY
                } else if (direction == 4) {      //箭头向左的方向
                    this.display_obj.x = target_pos_.x + this.target_obj.width + cfg_offset_x
                    this.display_obj.y = target_pos_.y - this.target_obj.height / 2 - this.rect_conta.y + 10 + cfg_offset_y
                    this.arrow_effect.x = 35 + arrow_offsetX
                    this.arrow_effect.y = 120 - gap_height / 2 + arrow_offsetY
                } else if (direction == 8) {      //箭头向上的方向
                    let posX = target_pos_.x - this.rect_conta.width / 2 - this.rect_conta.x
                    this.display_obj.x = posX + this.target_obj.width / 2 + cfg_offset_x
                    let point: Laya.Point = this._parent.localToGlobal(new Laya.Point(this.display_obj.x, 0))
                    let globalX = point.x
                    let offset = 0
                    if (globalX + this.rect_conta.x < 0) {
                        offset = -(globalX + this.rect_conta.x)
                    } else if ((globalX + this.rect_conta.width + this.rect_conta.x) > layer_mgr.stageWidth) {
                        offset = -(globalX + this.rect_conta.width + this.rect_conta.x - layer_mgr.stageWidth)
                    }
                    this.display_obj.x += offset
                    this.display_obj.y = target_pos_.y + this.target_obj.height / 2 + 40 + cfg_offset_y
                    this.arrow_effect.x = this.rect_conta.x + this.rect_conta.width / 2
                    this.arrow_effect.y = 35 + arrow_offsetY
                } else if (direction == 6) {      //箭头向右的方向
                    this.display_obj.x = target_pos_.x - this.target_obj.width / 2 - this.rect_conta.width - this.rect_conta.x - 30 + cfg_offset_x
                    this.display_obj.y = target_pos_.y - this.rect_conta.height / 2 - this.rect_conta.y + 25 + cfg_offset_y
                    this.arrow_effect.x = 405 - gap_width + arrow_offsetX
                    this.arrow_effect.y = 110 - gap_height / 2 + arrow_offsetY
                }
                if (direction == 6) {
                    this.contentImg.scaleX = -1
                    this.contentImg.left = 122
                    this.contentImg.right = undefined
                    this.content.x = showImg ? 121 : 20
                } else {
                    this.contentImg.scaleX = 1
                    this.contentImg.left = undefined
                    this.contentImg.right = 3
                    this.content.x = 20
                }
                this.contentImg.visible = showImg
                this.autoImg.y = this.content_bg.height - 9
            }
        }
        this.ShowEffect = (direction) => {
            let rotation1 = 0
            if (direction == 2) {
                rotation1 = -90
            } else if (direction == 6) {
                rotation1 = 180
            } else if (direction == 8) {
                rotation1 = 90
            }
            this.arrow_effect.rotation = rotation1
        }
        //电脑键盘数字键的2,4,8,6 分别是下，左，上，右
        this.SetArrowAnimation = (direction) => {
            if (this.is_tween) return
            this.is_tween = true
            this.ClearTween()
            if (direction) {
                let lite_type = SYTweenLite.UiAnimationType.POSY
                let target_value = 0
                if (direction == 2) {        //箭头向下的方向
                    target_value = 10//this.aniGp.y +
                } else if (direction == 4) {      //箭头向左的方向
                    target_value = - 10//this.aniGp.x 
                    lite_type = SYTweenLite.UiAnimationType.POSX
                } else if (direction == 8) {      //箭头向上的方向
                    target_value = - 10//this.aniGp.y 
                } else if (direction == 6) {      //箭头向右的方向
                    target_value = 10// this.aniGp.x +
                    lite_type = SYTweenLite.UiAnimationType.POSX
                }
                this.tween_id = SYTweenLite.to(this,
                    this.aniGp,
                    lite_type,
                    target_value,
                    1,
                    null,
                    SYTweenFunc.PINGPONG,
                    true)
            }
        }
        this.ClearTween = () => {
            if (this.aniGp && this.tween_id) {
                SYTweenLite.Stop(this.tween_id)
            }
        }
        this.LocalDeleteMe = () => {
            this.ClearTween()
            if (autoTimer_) {
                GlobalTimerQuest.CancelQuest(autoTimer_)
                autoTimer_ = null
            }
            last_step_cfg_ = null
            this._parent = null
        }

        this.AutoFunc = () => {
            if (this.use_delete_method) {
                return
            }
            if (PlatformManager.IsEyouThPlatform()) {
                this.autoLb.innerHTML = local_Util.StrToHTML(`<font color='#FFFF00'>${endTime_ - local_TimeUtil.getServerTime()}</font>วิ.จะทำต่อออโต้`)
            }else{
                 this.autoLb.innerHTML = local_Util.StrToHTML(`<font color='#FFFF00'>${endTime_ - local_TimeUtil.getServerTime()}</font>秒后自动继续`)
            }

            if (endTime_ - local_TimeUtil.getServerTime() <= 0) {
                this.autoLb.innerHTML = ``
                if (autoTimer_) {
                    GlobalTimerQuest.CancelQuest(autoTimer_)
                    autoTimer_ = null
                }
                let Fire = (obj) => {
                    if (obj.hasListener && obj.hasListener(Laya.Event.CLICK)) {
                        obj.event(Laya.Event.CLICK)
                        if (local_base_window_compont.CURR_BASE_WINDOW_COMPONENT && obj == local_base_window_compont.CURR_BASE_WINDOW_COMPONENT._story_bar2) {
                            let index
                            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
                            if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.UpgradeMedal)
                                || this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveDsg)
                                || this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveDesignation)
                                || (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Award_eternal_valley) && open_day < 8 && !PlatformManager.GetInstance().is_alpha && !PlatformManager.GetInstance().need_alpha_open_charge)
                                || this.task_model.MainTaskIsExpDungeonTaskType()) {
                                index = 2
                            } else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Fin_glad)) {
                                index = 3
                            }
                            else {
                                index = 1
                            }
                            if (index) {
                                let tabList = local_base_window_compont.CURR_BASE_WINDOW_COMPONENT._list_tab_con
                                if (tabList && tabList.getChildAt(index)) {
                                    let tabBtn
                                    tabBtn = tabList.getChildAt(index)
                                    tabBtn.event(Laya.Event.CLICK);
                                }
                            }
                        }
                    } else if (obj.parent) {
                        Fire(obj.parent)
                    }
                    this.DeleteMe()
                }
                this.target_obj && Fire(this.target_obj)

            }
            let parent = <Laya.HBox>this.autoLb.parent
            if (parent)
                parent.refresh()
        }
    }
    public DeleteMe() {
        this.LocalDeleteMe()
        super.DeleteMe()
    }

    aniGp: Laya.Box
    arrow_effect: Laya.Box
    _Image1: Laya.Image
    rect_conta: Laya.Box
    content_bg: Laya.Image
    content3: Laya.Label
    content: Laya.HTMLDivElement
    contentImg: Laya.Image
    autoImg: Laya.Image
    autoLb2: Laya.Label
    autoLb: Laya.HTMLDivElement
    public GetComponents() {
        [
            this.aniGp,
            this.arrow_effect,
            this._Image1,
            this.rect_conta,
            this.content_bg,
            this.content3,
            this.content,
            this.contentImg,
            this.autoImg,
            this.autoLb2,
            this.autoLb
        ]
            = this.GetChildrenByNames([

                "aniGp",
                "arrow_effect",
                "_Image1",
                "rect_conta",
                "content_bg",
                "content3",
                "content",
                "contentImg",
                "autoImg",
                "autoLb2",
                "autoLb"
            ])
    }
}
window["ArrowComponent"] = ArrowComponent