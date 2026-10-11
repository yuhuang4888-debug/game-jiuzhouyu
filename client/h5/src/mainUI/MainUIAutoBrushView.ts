import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { MonsterModel, MonsterModelEvent } from "../commonModel/MonsterModel"
import { RoleManager } from "../commonModel/RoleManager"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetLocalPosition, Util } from "../util/Util"

export class MainUIAutoBrushView extends BaseView1 {

    model: MainUIModel
    res_mgr: ResManager
    auto_brush_model: AutoBrushModel
    auto_state
    progress_width
    open_state
    _box_challenge_effect
    public constructor() {
        super()
        this.base_file = "mainUI"
        this.layout_file = "MainUIAutoBrushView"
        this.layer_value = Enum_UILayer.Main

        this.res_mgr = ResManager.GetInstance()
        this.model = MainUIModel.GetInstance()
        this.auto_brush_model = AutoBrushModel.GetInstance()

        this.load_callback = () => {
            this.CreatArrow()
            this.LogOutSetArrow()
            this.LoadSuccess()



        }

        this.open_callback = () => {
            this.UpdateOpenState()
        }

        this.destroy_callback = function () {

            this.Remove()
        }
    }

    public Remove() {

    }

    public LoadSuccess() {

        this.display_obj.x = 26
        this.display_obj.bottom = 262

        this.display_obj.scale(0.9, 0.9)

        this.progress_width = this._img_progress.width
        this.UpdateView()
        this.InitEvent()
        this.InitChallengeEffect()
    }

    public UpdateView() {
        this.UpdateAutoBrushStrangeState()
        this.UpdateBrushStrangeInfo()
        this.UpdateLevel()
        this.UpdateRed()
    }

    public StartMainLineTween() {
        this.InitChallengeEffect()
        if (this._box_challenge_effect) {
            this._box_challenge_effect.visible = true
        }
    }

    public CancelMainLineTween() {
        if (this._box_challenge_effect) {
            this._box_challenge_effect.visible = false
        }
    }

    public UpdateAutoBrushStrangeState() {
        let state = this.auto_brush_model.GetAutoBrushStrangeState()
        // this._img_auto_level.skin = GameResPath.GetIcon("mainUI", state ? "uizjmv3_025" : "uizjmv3_026")
        this._lb_auto_level.text = state ? "取消自动" : "自动闯关"
        // this._lb_auto_level.strokeColor = state ? "#e98234" : "#70a240"
        this.auto_state = state
        if (state) {
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_auto_level)
        }
    }

    public UpdateBrushStrangeInfo() {
        let info = this.auto_brush_model.GetBrushStrangeInfo()
        if (info) {
            this._img_progress.width = (info.current_times / info.need_times) * this.progress_width
            if (info.current_times == info.need_times) {
                this.StartMainLineTween()
            }
            else {
                this.CancelMainLineTween()
            }
        }
    }

    public UpdateOpenState() {
        // this.CancelHide()
        // return
        let open_state = CommonManager.GetInstance().CheckFuncOpenState("AutoBrush", true) && SceneManager.GetInstance().IsFieldScene()
        if (open_state == this.open_state) return
        this.open_state = open_state
        if (open_state) {
            this.display_obj.x = 26
            // this.display_obj.visible = true
            this.CancelHide()
            MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, true, MainUIManager.MOVE_TYPE.Left)
        }
        else {
            this.Hide()
            // this.display_obj.visible = false
            MainUIManager.GetInstance().RemoveMoveComponent(this)
        }
    }

    public UpdateLevel() {
        let bool = this.auto_brush_model.CheckDoneState()
        if (!bool) {
            this._lb_level.text = `第${this.auto_brush_model.GetLevel() + 1}关`
        }
    }
    public UpdateRed() {
        let brushRed = AutoBrushModel.GetInstance().HasRedFlag(AutoBrushModel.RedFlag.Brush);
        let main_role_vo = TaskModel.GetInstance().GetMainLineTaskVo()
        if(main_role_vo && main_role_vo.task_id == AutoBrushModel.IgnoreRedTaskID && main_role_vo.has_finish == 0){
            brushRed = false
        }
        let state2 = MonsterModel.GetInstance().GetSoapRedDotAll();
        let stageRed = AutoBrushModel.GetInstance().HasRedFlag(AutoBrushModel.RedFlag.Stage);
        this._img_red.visible = state2 || stageRed
        this._img_red2.visible = brushRed
    }

    public InitChallengeEffect() {
        if (this._box_challenge_effect == null) {

            let box = new Laya.Box()
            box.name = "_box_challenge_effect"
            box.width = box.height = 128
            this.display_obj.addChild(box)
            box.x = -19
            box.y = -39
            this.AddUIEffect("ui_mainDungeon", box, null, 10)

            this._box_challenge_effect = box
        }
    }

    public InitEvent() {

        Util.AddClickEvent(this.click_gp, () => {
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.click_gp)
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "AutoBrushBaseView")


            // if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap)
            //     && !this.task_model.IsCurrMainTaskHasFinish()
            //     && this.story_model.GetTaskStep(TaskTipType.ActiveSoap) == 1) {
            //     if (this.auto_brush_model.IsGetSpeTaskItem()) {
            //         this.story_model.UpdateTaskStep(TaskTipType.ActiveSoap, 4)
            //     } else {
            //         this.story_model.UpdateTaskStep(TaskTipType.ActiveSoap, 1)
            //     }

            // }



            // let data = this.auto_brush_model.GetBrushStrangeInfo()
            // if (data) {
            // 	if (data.current_times == data.need_times) {
            // 		this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13305, "c", 0)
            // 	}
            // 	else {
            // 		GlobalEventSystem.Fire(EventName.OPEN_VIEW, "AutoBrushBaseView")
            // 	}

            // }
        }, this, true)

        Util.AddClickEvent(
            this._box_auto_level, () => {
                // let level = this.auto_brush_model.GetLevel()
                // let open_auto_level = this.auto_brush_model.GetAutoOpenLevel()
                // if (!level || !open_auto_level || level < open_auto_level) {
                //     Message.show(`关卡达${open_auto_level}关开启`)
                //     return
                // }
                GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_auto_level)
                if (this.auto_state) {
                    this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 1)
                } else {
                    this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13307, "c", 0)
                }
            }, this, true)

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_BRUSH_STRANGE_INFO, () => {
            this.UpdateBrushStrangeInfo()
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_BRUSH_STRANGE_STATE, () => {
            this.UpdateAutoBrushStrangeState()
            this.UpdateRed()
        })

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_LEVEL, () => {
            this.UpdateLevel()
        })

        this.BindEvent(GlobalEventSystem, EventName.UPDATE_NEWEST_TASK_ID, (value?) => {
            this.UpdateOpenState()
            this.CreatArrow(value)
        }
        )

        this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, (level?) => {
            this.UpdateOpenState()
        }
        )

        this.BindEvent(this.auto_brush_model, AutoBrushModel.REFRESH_RED_FLAG, () => {
            this.UpdateRed()
        })

        this.BindEvent(MonsterModel.GetInstance(), MonsterModelEvent.UPDATE_RED_DOT, () => {
            this.UpdateRed()
        })

        this.BindEvent(AutoBrushModel.GetInstance(), AutoBrushModel.NEXT_STEP_ARROW, (step) => {
            // let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
            // if (task_id && task_id == 100811 && step == 7) {
            //     AutoBrushModel.GetInstance().CreatArrow(this, this._box_auto_level, 7)
            // }
        })
        let restore_fun = () => {

            if (this.story_model.CanRestoreFinger(this.layout_file)) {
                this.CreatArrow()
            }
        }
        this.BindEvent(GlobalEventSystem, EventName.RESTORE_FINGER, restore_fun)

        this.BindEvent(AutoBrushModel.GetInstance(), AutoBrushModel.SHOW_MAIN_TASK_ARROW2, () => {
            this.CreatArrow2()
        })

        this.BindEvent(AutoBrushModel.GetInstance(), AutoBrushModel.HIDE_MAIN_TASK_ARROW2, () => {
            this.DelFinger()
        })


        this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
            this.UpdateOpenState()
        })

    }

    private CreatArrow(task_id?) {
        if (!this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap)) {
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.click_gp)
        }

        let now_task_id = 0
        let is_finish = 1
        if (!task_id) {
            now_task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
            is_finish = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().has_finish
        }
        if (this.auto_brush_model.GetStep() != 6 && (task_id && task_id == 100810 || (AutoBrushModel.GetInstance().IsSpeTaskId(task_id) && !is_finish))) {

            let step = {
                "direction": 4,
                "text": "发现<font color='#0a9f42'>斩妖</font>入口，<br>点击这里就可以<font color='#0a9f42'>随时</font>进行斩妖啦~",
                "effect_scaleX": 0.5,
                "effect_scaleY": 1.1,
                "off_x": 20,
                "off_y": 20,
            }
            GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.click_gp, "Main", null, null, null, null, step, true)
        }
    }

    private LogOutSetArrow() {
        let lv = this.auto_brush_model.GetLevel()
        let state = this.auto_brush_model.GetAutoBrushStrangeState()
        let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
        // if (lv == 10 && task_id && task_id == 100811 && !state) {
        //     let step = { "direction": 4, "text": "点击按钮可开启<font color='#0a9f42'>自动斩妖</font><br>看看自己可以勇闯几回！", "effect_scaleX": 0.5, "effect_scaleY": 0.7, "off_x": 10, "off_y": -30 }
        //     GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_auto_level, "Main", null, null, null, null, step, true)
        // }
        if (lv == 11 && task_id && AutoBrushModel.GetInstance().IsSpeTaskId(task_id) && !state) {
            AutoBrushModel.GetInstance().Fire(AutoBrushModel.SHOW_MAIN_TASK_ARROW)
        }
    }

    private CreatArrow2() {

        //开启条件
        let open_state = CommonManager.GetInstance().CheckFuncOpenState("AutoBrush", true) && SceneManager.GetInstance().IsFieldScene()
        if (!open_state) return

        //在一些任务的进行情况下 屏蔽该箭头
        // if(this.task_model.IsCurrMainLineTaskTipType(TaskTipType.PassMainDungeon))return
        if(this.task_model.IsSpecialBrushTask())return
        let main_vo = this.task_model.GetMainLineTaskVo()
        if(main_vo&&AutoBrushModel.GetInstance().IsSpeTaskId(main_vo.task_id))return
        let step = {
            "direction": 4,
            "text": "点击按钮可开启<font color='#0a9f42'>自动斩妖</font><br>看看自己可以勇闯几回!",
            "effect_scaleX": 0.5,
            "effect_scaleY": 0.7,
            "off_x": 10,
            "off_y": -30,
            "front_parent":true
        }
        GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_auto_level, "Main", null, null, null, null, step, true)
    }


    public DelFinger(){


        GlobalEventSystem.Fire(EventName.HIDE_FINGER,this._box_auto_level)
    }


    createChildren() {
		if (this['GetComponents']) {
			this['GetComponents']();
			this.is_get = true;
		}
		this.story_target_name_dic = this.story_target_name_dic||{}
		this.story_target_name_dic[StoryModel.StoryTargetName.BrushBtn] = this.click_gp;
        this.story_target_name_dic[StoryModel.StoryTargetName.MainLineDungeon] = this._box_auto_level
		super.createChildren();
	}



    _img_bg: Laya.Box
    _img_bg2: Laya.Image
    _img_bg3: Laya.Image
    _lb_level: Laya.Label
    _img_bg4: Laya.Image
    _img_progress: Laya.Image
    _box_effect: Laya.Box
    _box_auto_level: Laya.Box
    _img_auto_level: Laya.Image
    _lb_auto_level: Laya.Label
    _img_red: Laya.Image
    click_gp: Laya.Box
    _img_red2: Laya.Image
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_bg3,
            this._lb_level,
            this._img_bg4,
            this._img_progress,
            this._box_effect,
            this._box_auto_level,
            this._img_auto_level,
            this._lb_auto_level,
            this._img_red,
            this.click_gp,
            this._img_red2
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_bg3",
                "_lb_level",
                "_img_bg4",
                "_img_progress",
                "_box_effect",
                "_box_auto_level",
                "_img_auto_level",
                "_lb_auto_level",
                "_img_red",
                "click_gp",
                "_img_red2"
            ])
    }
}
window["MainUIAutoBrushView"] = MainUIAutoBrushView