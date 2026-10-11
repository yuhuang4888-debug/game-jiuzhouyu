// console.warn("StoryModel@ArrowComponent")
import { ArrowComponent } from "../common/ArrowComponent";
// console.warn("StoryModel@SceneManager")
import { SceneManager } from "../scene/SceneManager";
// console.warn("StoryModel@EventDispatcher")
import { EventDispatcher } from "../util/EventDispatcher";
// console.warn("StoryModel@Util")
import { GetTargetHashcode, Util } from "../util/Util";
// console.warn("StoryModel@TaskModel")
// import { TaskModel } from "../commonModel/TaskModel";
// console.warn("StoryModel")
// import { Util } from "../util/Util";
// TypeScript file

import "../common/ArrowComponent"
import { TaskModel } from "./TaskModel";
import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { Enum_UILayer, LayerManager } from "../common/LayerManager";
import { UIEffect } from "../common/UIEffect";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { PlatformManager } from "../PlatformManager";
export class StoryModel extends EventDispatcher {
    static StoryBossId = 509;
    //剧情配置
    static GetStoryCfg() {
        let cfg = [];
        return cfg;
    }
    static UIEFFECT_BOX_NAME = "effect_boxx"
    static FINGER_BOX_NAME = "finger_boxx"
    static ZORDER_COUNT = 888

    public static EventName = {
        CAMERA_FOLLOW: "CAMERA_FOLLOW",
        ANIM_CLIP_FINISH: "ANIM_CLIP_FINISH",
        OPEN_PATH_EDIT: "OPEN_PATH_EDIT",
        UPDATE_TASK_STEP: "UPDATE_TASK_STEP",
        UPDATE_TASK_STEP_SPE: "UPDATE_TASK_STEP_SPE" //引导更新
    }

    static StoryTargetName = {
        BagIcon: "SNBagIcon",
        RoleIcon: "SNRoleIcon",
        ForgingIcon: "SNForging",
        FriendIcon: "SNFriendIcon",
        GuildIcon: "SNGuildIcon",
        CompositeIcon: "SNCompositeIcon",
        PetIcon: "SNPetIcon",
        SingleDungeon: "SNSingleDungeon",
        MainLineDungeon: "SNMainLineDungeon",
        AuToMainLineDungeon: "SNAuToMainLineDungeon",
        BossDungeon: "SNBossDungeon",
        RebornBtn: "SNRebornBtn",
        ArenaBtn: "SNArenaBtn",
        KaiFuBtn: "SNKaiFuBtn",
        MallIcon: "SNMallIcon",
        RuneTreasureBtn: "SNRuneTreasureBtn",
        WefareBtn: "WefareBtn",
        SuitActivityBtn: "SuitActivityBtn",
        TempleAwakenBtn: "TempleAwakenBtn",
        AfkReceiveBtn: "AfkReceiveBtn",
        RedIcon: "RedIcon",//神装
        MainUISwitchBtn: "MainUISwitchBtn", //切换按钮
        BrushBtn: "BrushBtn" //主界面斩妖按钮
    };

    effect_obj: UIEffect
    CanRestoreFinger
    ReturnDic
    CreateFinger
    GetFinger
    DeleteFinger
    CanShowFinger
    HasMainUiFinger
    HasFingerIsShowing

    ShowAllFinger
    show_all_cache = true
    GetAllFingerStatus

    /** 关闭界面不触发引导锁*/
    static RestoreFingerLock = {}  

    /** 显示引导锁*/
    static ShowFingerLock = {}  

    static Instance: StoryModel

    _curr_view_story_step = 0 //当前打开的界面 引导到哪一步
    public last_pos
    // private main_ui_finger: FingerComponent
    public main_ui_finger
    public now_story_target_name
    story_camera
    story_index = 0
    story_obj = undefined

    //任务补充  比如任务有1-5 完成3后其实任务已经全部完成，但是在此次打开的界面中还需要引导其他内容 直至此次引导界面关闭
    task_supplement_list = {}
    UpdateTaskStep
    GetTaskStep
    RegisterTaskStep
    DeleteTaskStep
    RegisterFinishTaskFinger

    public constructor() {
        super()
        if (StoryModel.Instance) {
            return
        }
        StoryModel.Instance = this
        this.effect_obj = new UIEffect()
        let local_util = Util
        let finger_dic_ = {}                    //所有手指字典 
        let finger_eff_dic_1 = {}                    //所有手指字典  点击特效
        let finger_eff_dic_2 = {}                    //所有手指字典  框
        this.curr_view_story_step = 0
        this.now_story_target_name = ""
        this.story_camera = null //剧情摄像机

        //是否有手指正在引导
        this.HasFingerIsShowing = () => {
            if (this.main_ui_finger || local_util.TableSize(finger_dic_) > 0) {
                return true
            } else {
                return false
            }
        }

        //是否有主界面手指正在引导
        this.HasMainUiFinger = () => {
            if (this.main_ui_finger) {
                return true
            } else {
                return false
            }
        }

        this.CanShowFinger = (force_show) => {
            // let task_model = window["TaskModel"].GetInstance()
            if (force_show ||  SceneManager.GetInstance().IsFieldScene()) {
                return true
            }
        }


        this.DeleteFinger = (obj?: Laya.Box, is_main_ui_finger?) => {
            let clear_effect_obj
            let clear_effect_obj1
            if (this.main_ui_finger && (is_main_ui_finger || this.main_ui_finger.target_obj == obj)) {
                if (this.main_ui_finger.target_obj) {
                    clear_effect_obj = this.main_ui_finger.target_obj.removeChildByName(StoryModel.UIEFFECT_BOX_NAME)
                    clear_effect_obj1 = this.main_ui_finger.target_obj.removeChildByName(StoryModel.FINGER_BOX_NAME)
                }
                this.main_ui_finger.DeleteMe()
                this.main_ui_finger = null

            } else if (obj && finger_dic_[obj["$_GID"]]) {
                let finger = finger_dic_[obj["$_GID"]]
                clear_effect_obj = obj.removeChildByName(StoryModel.UIEFFECT_BOX_NAME)
                clear_effect_obj1 = obj.removeChildByName(StoryModel.FINGER_BOX_NAME)
                finger.DeleteMe()
                delete finger_dic_[obj["$_GID"]]
            }
            if (!clear_effect_obj && obj && obj.getChildByName) {
                clear_effect_obj = obj.getChildByName(StoryModel.UIEFFECT_BOX_NAME)
            }
            if (!clear_effect_obj1 && obj && obj.getChildByName) {
                clear_effect_obj = obj.getChildByName(StoryModel.FINGER_BOX_NAME)
            }
            if (clear_effect_obj) {
                this.effect_obj.ClearUIEffect(clear_effect_obj)
                if (finger_eff_dic_2[obj["$_GID"]]) {
                    delete finger_eff_dic_2[obj["$_GID"]]
                }
            }
            if (clear_effect_obj1) {
                this.effect_obj.ClearUIEffect(clear_effect_obj1)
                if (finger_eff_dic_1[obj["$_GID"]]) {
                    delete finger_eff_dic_1[obj["$_GID"]]
                }
            }




            // console.warn("------DeleteFinger------", is_main_ui_finger, GetTargetHashcode(clear_effect_obj), GetTargetHashcode(obj))

        }

        this.GetFinger = (_, obj: Laya.Box) => {
            if (obj) {
                if (this.main_ui_finger && this.main_ui_finger.target_obj == obj) {
                    return this.main_ui_finger
                }
                return finger_dic_[obj["$_GID"]]
            }
        }

        this.CreateFinger = (ref, obj: Laya.Box, _, x_off?, y_off?, is_main_ui_finger?, not_move?, step_cfg?, finger_type?, lock_vis?) => {
            if (this.HasFingerIsShowing() && is_main_ui_finger && !window["Util"].IsTableEmpty(window["BaseWindowComponent"].CURR_OPEN_VIEW)) return
            if (!window["Util"].IsTableEmpty(window["BaseWindowComponent"].CURR_OPEN_VIEW) && this.HasMainUiFinger()) {
                if (this.main_ui_finger) {
                    let clear_effect_obj = this.main_ui_finger.target_obj && this.main_ui_finger.target_obj.removeChildByName && this.main_ui_finger.target_obj.removeChildByName(StoryModel.UIEFFECT_BOX_NAME)
                    let clear_effect_obj1 = this.main_ui_finger.target_obj && this.main_ui_finger.target_obj.removeChildByName && this.main_ui_finger.target_obj.removeChildByName(StoryModel.FINGER_BOX_NAME)
                    if (clear_effect_obj) {
                        this.effect_obj.ClearUIEffect(clear_effect_obj)
                        if (finger_eff_dic_2[obj["$_GID"]]) {
                            delete finger_eff_dic_2[obj["$_GID"]]
                        }
                    }
                    if (clear_effect_obj1) {
                        this.effect_obj.ClearUIEffect(clear_effect_obj1)

                        if (finger_eff_dic_1[obj["$_GID"]]) {
                            delete finger_eff_dic_1[obj["$_GID"]]
                        }
                    }

                    this.main_ui_finger.DeleteMe()
                    this.main_ui_finger = null
                }
            }
            if (window["BaseWindowComponent"].CURR_BASE_WINDOW_COMPONENT && window["BaseWindowComponent"].CURR_BASE_WINDOW_COMPONENT._img_return && obj == window["BaseWindowComponent"].CURR_BASE_WINDOW_COMPONENT._img_return) {
                ref = window["BaseWindowComponent"].CURR_BASE_WINDOW_COMPONENT
            }
            let arrow_class = window["ArrowComponent"]
            let finger
            let step_cfg_ = step_cfg || TaskModel.GetInstance().GetNowGuideCfg(is_main_ui_finger)
            if (ref.layout_file == "MainUITaskItem" && is_main_ui_finger && step_cfg_ && step_cfg_.not_show_in_task_item) return
            if (obj && obj.parent && step_cfg_) {
                if (!is_main_ui_finger) {
                    if (!finger_dic_[obj["$_GID"]]) {
                        finger = new arrow_class(obj.parent, obj, ref)
                        finger.Load()
                        let onDelay = () => {
                            if (finger.use_delete_method || !obj.parent) return
                            finger.SetPos({ "x": obj.x + (x_off || 0), "y": obj.y + (y_off || 0) }, false, not_move, step_cfg, null, lock_vis)
                        }
                        setTimeout(onDelay, 100)
                        finger_dic_[obj["$_GID"]] = finger
                    }
                } else {
                    if (this.main_ui_finger && this.main_ui_finger.target_obj["$_GID"] != obj["$_GID"]) {
                        let clear_effect_obj = this.main_ui_finger.target_obj.removeChildByName(StoryModel.UIEFFECT_BOX_NAME)
                        let clear_effect_obj1 = this.main_ui_finger.target_obj.removeChildByName(StoryModel.FINGER_BOX_NAME)
                        if (clear_effect_obj) {
                            this.effect_obj.ClearUIEffect(clear_effect_obj)
                            if (finger_eff_dic_2[obj["$_GID"]]) {
                                delete finger_eff_dic_2[obj["$_GID"]]
                            }
                        }
                        if (clear_effect_obj) {
                            this.effect_obj.ClearUIEffect(clear_effect_obj1)
                            if (finger_eff_dic_1[obj["$_GID"]]) {
                                delete finger_eff_dic_1[obj["$_GID"]]
                            }
                        }
                        this.main_ui_finger.DeleteMe()
                        this.main_ui_finger = null
                    }
                    if (!this.main_ui_finger) {
                        this.main_ui_finger = new arrow_class(obj.parent, obj, ref)
                        this.main_ui_finger.Load()
                    }
                    // this.main_ui_finger.RetSetData()
                    let onDelay = () => {
                        if (!this.main_ui_finger || this.main_ui_finger.use_delete_method || !obj.parent) return
                        this.main_ui_finger.SetPos({ "x": obj.x + (x_off || 0), "y": obj.y + (y_off || 0) }, is_main_ui_finger, not_move, step_cfg, null, lock_vis)
                    }
                    if (this.main_ui_finger.target_obj["$_GID"] != obj["$_GID"]) {
                        setTimeout(onDelay, 100)
                    } else {
                        onDelay()
                    }
                }
            }

            if (!step_cfg_ || step_cfg_.not_effect) {
            }
            else {
                let effect_gp: Laya.Box = <Laya.Box>obj.removeChildByName(StoryModel.UIEFFECT_BOX_NAME)
                let finger_gp: Laya.Box = <Laya.Box>obj.removeChildByName(StoryModel.FINGER_BOX_NAME)
                if (effect_gp) {
                    this.effect_obj.ClearUIEffect(effect_gp)
                    if (finger_eff_dic_2[obj["$_GID"]]) {
                        delete finger_eff_dic_2[obj["$_GID"]]
                    }
                }

                if (finger_gp) {
                    this.effect_obj.ClearUIEffect(finger_gp)
                    if (finger_eff_dic_1[obj["$_GID"]]) {
                        delete finger_eff_dic_1[obj["$_GID"]]
                    }
                }

                effect_gp = new Laya.Box()
                effect_gp.name = StoryModel.UIEFFECT_BOX_NAME
                obj.autoSize = false
                obj.addChild(effect_gp)
                effect_gp.width = 720
                effect_gp.height = 1280
                effect_gp.centerX = effect_gp.centerY = 0
                finger_gp = new Laya.Box()
                finger_gp.name = StoryModel.FINGER_BOX_NAME
                obj.autoSize = false
                obj.addChild(finger_gp)
                finger_gp.width = 720
                finger_gp.height = 1280
                finger_gp.centerX = finger_gp.centerY = 0

                let center_x = (step_cfg_ && step_cfg_.finger_offset_x) ? step_cfg_.finger_offset_x : 0
                let center_y = (step_cfg_ && step_cfg_.finger_offset_y) ? step_cfg_.finger_offset_y : 0
                finger_gp.centerX = center_x
                finger_gp.centerY = center_y
                // if(obj.name == "arrow_box" && ref.layout_file == "ActivityIcon"){
                //     step_cfg_.direction = 6
                // }
                // if(obj.name == "_img_icon" && ref.layout_file == "MainFuncIconItem"){
                //     step_cfg_.direction = 2
                // }
                let scaleX = step_cfg_ && step_cfg_.effect_scaleX ? step_cfg_.effect_scaleX : 1
                let scaleY = step_cfg_ && step_cfg_.effect_scaleY ? step_cfg_.effect_scaleY : 1
                let scaleZ = step_cfg_ && step_cfg_.effect_scaleZ ? step_cfg_.effect_scaleZ : 1
                let ref_ = ref.base_item ? ref.base_item : ref
                if (ref_.layout_file && ref_.layout_file == "MainUITaskItem") {
                    if (ref.display_obj && ref.display_obj.height <= 55)
                        scaleX = scaleY = 1
                    else {
                        scaleX = 1.02
                        scaleY = 1.4
                    }

                }
                // else if (ref_.layout_file && ref_.layout_file == "PartnerAwakeShowView") {
                //     scaleX = 0.7
                //     scaleY = 0.9
                // }
                // console.warn("------CreateFinger------", ref, obj.name, GetTargetHashcode(effect_gp))
                if(obj.name == "_story_bar2"&&PlatformManager.IsEyouPlatform()){
                    scaleX +=0.18 
                }
                this.effect_obj.AddUIEffect("ui_yindaoxiaoguo", effect_gp, null, { x: scaleX, y: scaleY, z: scaleZ }, true, null, null, null, null, null, null, null, false)
                this.effect_obj.AddUIEffect("ui_dianjizhiyin", finger_gp)
                finger_eff_dic_1[obj["$_GID"]] = finger_gp
                finger_eff_dic_2[obj["$_GID"]] = effect_gp
            }
            if (step_cfg_ && step_cfg_.front_parent) {
                let parent: any = obj
                let final_parent
                do {
                    if (!parent) break
                    if (parent.name && parent.name == step_cfg_.front_parent) {
                        final_parent = parent.parent
                        final_parent.addChildAt(parent, final_parent.numChildren - 1)
                        parent.zOrder = StoryModel.ZORDER_COUNT++
                        break
                    }
                    parent = parent.parent

                } while (true)
                finger = finger || this.main_ui_finger
                if (finger) {
                    let finger_display_obj = finger.display_obj
                    if (finger_display_obj) {
                        parent = finger_display_obj.parent
                        if (parent) {
                            parent.setChildIndex(finger_display_obj, parent.numChildren - 1)
                            finger_display_obj.zOrder = StoryModel.ZORDER_COUNT++
                        }
                    }
                }
            }

            if (!lock_vis) {
                this.ShowAllFinger(this.show_all_cache, true)
            }

        }

        //关闭界面的时候，是否需要重新触发手指箭头判断
        this.CanRestoreFinger = (layout_file) => {
            let bool = (layout_file == null || (
                layout_file != "FightingUpView"
                && layout_file != "ItemUseView"
                && layout_file != "CollectBarView"
                && layout_file != "TeamMatchView"
            )
            )
            return bool
        }

        this.ReturnDic = () => {
            return finger_dic_
        }


        /**is_just_eff 紧紧隐藏特效   ArrowComponent需要加载完再设置*/
        this.ShowAllFinger = (bool, is_just_eff?) => {
            this.show_all_cache = bool

            if (!is_just_eff) {
                if (this.main_ui_finger) {
                    this.main_ui_finger.SetVisible(bool)
                } else {
                    //普通界面引导
                    for (let key in finger_dic_) {
                        let comp: ArrowComponent = finger_dic_[key]
                        if (comp) {
                            comp.SetVisible(bool)
                        }
                    }
                }
            }


            //隐藏特效
            for (let key in finger_eff_dic_1) {
                let comp: Laya.Box = finger_eff_dic_1[key]
                if (comp) {
                    comp.visible = bool
                }
            }

            for (let key in finger_eff_dic_2) {
                let comp: Laya.Box = finger_eff_dic_2[key]
                if (comp) {
                    comp.visible = bool
                }
            }

        }

        /***返回隐藏状态  true可见  false不可见 */
        this.GetAllFingerStatus = () => {
            return this.show_all_cache
        }

        this.UpdateTaskStep = (task_tip_type?, step?) => {
            // this.story_model.task_supplement_list[TaskTipType.ActiveSoap]=1  用这种方式注册
            if (task_tip_type) {
                if (this.task_supplement_list[task_tip_type]) {
                    this.task_supplement_list[task_tip_type] = step
                    this.Fire(StoryModel.EventName.UPDATE_TASK_STEP)
                }
            }
        }

        this.GetTaskStep = (task_tip_type) => {
            if (this.task_supplement_list[task_tip_type]) {
                return this.task_supplement_list[task_tip_type]
            }
            return 0
        }

        this.RegisterTaskStep = (task_tip_type) => {
            if (!this.task_supplement_list) {
                this.task_supplement_list = {}
            }
            this.task_supplement_list[task_tip_type] = 1
        }

        this.DeleteTaskStep = (task_tip_type) => {
            if (this.task_supplement_list[task_tip_type]) {
                delete this.task_supplement_list[task_tip_type]
            }
        }


        //有些任务完成但是未领取状态  需要在公共大界面显示返回主线的箭头
        this.RegisterFinishTaskFinger = (task_tip_type) => {
            if (TaskModel.GetInstance().IsCurrMainLineTaskTipType(task_tip_type) && TaskModel.GetInstance().IsCurrMainTaskHasFinish()) {
                let step1 =
                {
                    "direction": 6,
                    "text": "返回继续<font color='#0a9f42'>主线</font>",
                    "effect_scaleX": 0.4,
                    "effect_scaleY": 0.8
                }
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null, step1, true)
            }
        }
    }

    public get curr_view_story_step() {
        return this._curr_view_story_step
    }
    public set curr_view_story_step(value) {
        this._curr_view_story_step = value
    }

    public static GetInstance() {
        if (StoryModel.Instance == null) {
            StoryModel.Instance = new StoryModel()
        }
        return StoryModel.Instance
    }
}

window["StoryModel"] = StoryModel