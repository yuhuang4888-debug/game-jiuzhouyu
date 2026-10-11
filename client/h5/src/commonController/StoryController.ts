import { BaseController } from "../common/BaseController";
// import { WelcomeView } from "./WelcomeView";
// import { StoryModel } from "./StoryModel";
import { GlobalEventSystem, LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar";
import { EventName, SceneEventType, ObjectEventType } from "../common/EventName";
import { SceneManager } from "../scene/SceneManager";
// import { DialogueView } from "./DialogueView";
import { CameraManager } from "../scene/CameraManager";
import { Config } from "../common/Config";
import { GlobalTimerQuest, Split, Util } from "../util/Util";
import { NpcVo } from "../sharedata/NpcVo";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { AutoFightManager } from "../autofight/AutoFightManager";
import { StoryModel } from "../commonModel/StoryModel";
import { TaskModel, TaskTipType } from "../commonModel/TaskModel";
import { Status } from "../util/Status";
import { CommonManager } from "../common/CommonManager";
import { Scene } from "../scene/Scene";
import { LoginModel } from "../login/LoginModel";
import { ResManager } from "../common/ResManager";
import { PlatformManager } from "../PlatformManager";



// TypeScript file
export class StoryController extends BaseController {
    stroy_model: StoryModel
    play_story_ins_id
    finish_timer
    task_finish_id
    monster_dead_id
    curr_story_step
    trigger_progress
    nowStoryInfo
    isOnStory
    y0
    talkNpc
    dialogue_view
    curDungeonId
    finish_func_list
    finish_now_func_list
    complete_conditions
    play_story_list
    finish_reply_story_list
    cur_scene_played
    cur_play_index
    y1
    monster_add_id
    scene_mgr
    execute_times_table
    cache_story_play
    server_trigger_story_list
    do_task_id
    role_move_id
    scene_change_id
    path_edit_view
    task_model: TaskModel
    curSceneId
    x0
    x1

    static Instance: any;
    InitEvents
    GetStoryConfig
    GetStoryTotalTime
    Launch
    ClearStoryListener
    StartStoryListener
    AddStoryLister
    onStoryConditionChanged
    IsInRectArea
    StartStory
    StopStory
    ClearPlayStory
    RegisterFinishDelayCallback
    RegisterFinishNowCallback
    CanTriggerStory
    PrintStoryTimes
    HandleSceneChange
    SetStoryData
    IsPlaying
    RemoveCheckOutEvent
    InitDungeonInfo
    TriggerByServer
    NeedPlayStory
    ImmStopStory
    // let TRIGGER_PROGRESS = 90 //场景加载到多少进度加载剧情触发事件，默认值
    public constructor() {
        super()
        if (StoryController.Instance) {
            return
        }
        StoryController.Instance = this
        this.curr_story_step = 0
        this.stroy_model = StoryModel.GetInstance()
        this.scene_mgr = SceneManager.GetInstance()
        this.task_model = TaskModel.GetInstance()
        this.dialogue_view = null
        this.monster_dead_id = null
        this.scene_change_id = null
        this.talkNpc = null
        //剧情
        this.play_story_ins_id = 0
        this.play_story_list = []
        this.isOnStory = false //处在剧情监听中
        // this.trigger_progress = TRIGGER_PROGRESS //控制在loadview加载到多少时监听剧情事件
        this.curSceneId = 0 //当前场景Id
        this.curDungeonId = 0 //当前副本Id
        this.cur_play_index = null //当前播放的剧情索引
        this.cur_scene_played = [] //记录此次进入场景已播放的剧情
        this.complete_conditions = []
        this.cache_story_play = null //缓存播放剧情（isOnStory=true处在触发监听中才播）

        this.finish_reply_story_list = [] //保存需要发送给服务器的剧情id
        this.server_trigger_story_list = [] //后端触发，则忽略前端的条件

        this.InitEvents = () => {
            let onHideFinger = (obj?, is_mainui_finger?) => {
                this.stroy_model.DeleteFinger(obj, is_mainui_finger)
            }
            this.Bind(EventName.HIDE_FINGER, onHideFinger)

            let onShowFinger = (
                ref,
                obj,
                layer_value,
                x_off,
                y_off,
                is_in_main_ui,
                not_move,
                step_cfg,
                force_show,
                finger_type,
                lock_vis //不受隐藏全部逻辑影响
                ) => {

                let main_line_vo = this.task_model.GetMainLineTaskVo()
                if (is_in_main_ui && main_line_vo && main_line_vo.task_tips_type != TaskTipType.LV) {
                    this.task_model.click_lv_arrow_time = null
                }
                if(obj&&obj.name == "_story_bar2"&&PlatformManager.IsEyouPlatform()){
                    //因为之前的界面都设置了任务box的位置 所以不会自增
                    obj.x += 30
                }
                if (this.stroy_model.CanShowFinger(force_show)) {
                    this.stroy_model.CreateFinger(
                        ref,
                        obj,
                        layer_value,
                        x_off,
                        y_off,
                        is_in_main_ui,
                        not_move,
                        step_cfg,
                        finger_type,
                        lock_vis
                    )
                }
            }
            GlobalEventSystem.Bind(EventName.SHOW_FINGER, onShowFinger)
            GlobalEventSystem.Bind(EventName.STORY_SHOW_ALL_FINGER, (boo?)=>{
                this.stroy_model.ShowAllFinger(boo)
            })

            let update_task_fun = (scene_id?, index?) => {
                // if (scene_id == 10001 && index == 2) {
                //     let game_object = MapView.GetInstance().cache_effect_obj["scene_sunshinedynamic07 (4)"]
                //     if (game_object) {
                //         game_object.visible = true
                //     }

                // }
                //let main_line_vo = this.task_model.GetMainLineTaskVo()
                //if (//main_line_vo && main_line_vo.task_id == TaskModel.FIRST_TASK_ID &&
                //RoleManager:GetInstance().mainRoleInfo.level == 1 &&
                //Scene.Instance.IsProgressLoadFinish()
                //) {
                //this:Fire(EventName.OPEN_VIEW, "WelcomeView")
                //}
            }
            GlobalEventSystem.Bind(EventName.STORY_FINISH, update_task_fun)
            //this.task_model.Bind(TaskModel.UPDATE_ALL_TASK_FROM_30000, update_task_fun)
            //this:Bind(EventName.SCENELOADVIEWE_CLOSE, update_task_fun)

            this.Bind(SceneManager.START, () => {
                this.stroy_model.task_supplement_list ={}
                let scene_mgr = SceneManager.GetInstance()
                if (scene_mgr.IsDungeonScene()) {
                    this.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.SingleDungeon, false)
                } else if (scene_mgr.IsBossScene()) {
                    this.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.BossDungeon, false)
                }
            }
            )

            //切换场景设置剧情数据
            //var onSceneChange =()=> {
            //this:HandleSceneChange()
            //}
            //GlobalEventSystem:Bind(SceneEventType.SCENE_CHANGED, onSceneChange)

            //剧情触发事件监听
            var StoryStartTrigger = () => {
                this.StartStoryListener()
                this.Launch()
            }
            //一个是切屏特效，一个是进度条加载
            // GlobalEventSystem.Bind(EventName.SCENE_LOAD_VIEW_COMPLETE, StoryStartTrigger)
            GlobalEventSystem.Bind(SceneManager.START, StoryStartTrigger)


            var StoryStartTrigger1 = () => {
                this.StartStoryListener()
            }
            GlobalEventSystem.Bind(EventName.TRIGGER_STORY_START, StoryStartTrigger1)

            //场景开始的时候，触发一下位置检测
            var onSceneStart = () => {
                this.onStoryConditionChanged(4)
            }
            GlobalEventSystem.Bind(SceneManager.START, onSceneStart)

            //主动触发播放剧情
            var onStoryTrigger = (scene_id, story_sub_id, start_time, is_server_trigger) => {
                if (this.curSceneId == scene_id) {
                    this.StartStory(story_sub_id, start_time, is_server_trigger)
                }
            }
            GlobalEventSystem.Bind(EventName.STORY_PLAY_TRIGGER, onStoryTrigger)

            var onOpenPathEdit = () => {
                // if (this.path_edit_view == null) {
                //     this.path_edit_view = new PathEditView()
                // }
                // this.path_edit_view.Open()
            }
            this.stroy_model.Bind(StoryModel.EventName.OPEN_PATH_EDIT, onOpenPathEdit)
        }

        ////////////////-剧情////////////////-
        this.GetStoryConfig = (scene_id?) => {
            let config = Config["Story" + scene_id]
            if (config == null) {
                console.log("===================没有剧情配置,scene_id = ", scene_id)
            } else {
                console.log("===================剧情配置:sceneId = ", scene_id)
            }

            return config
        }

        this.GetStoryTotalTime = (scene_id?, index?) => {

            let config = this.GetStoryConfig(scene_id)
            if (config) {
                let storyVo = config.storyVoList[index]
                let value = 60
                if (storyVo && storyVo.totalTime) {
                    value = storyVo.totalTime
                } else {
                    console.warn("没有配置剧情总时间。scene_id = " + String(scene_id) + ", index" + String(index))
                }
                return value
            }
        }

        //处理在加载界面关闭之前就判断要播放的剧情
        this.Launch = () => {
            if (this.cache_story_play) {
                this.cache_story_play()
                this.cache_story_play = null
            }
        }

        this.ClearStoryListener = () => {
            this.isOnStory = false
            if (this.role_move_id) {
                GlobalEventSystem.UnBind(this.role_move_id)
                this.role_move_id = null
            }
            if (this.do_task_id) {
                GlobalEventSystem.UnBind(this.do_task_id)
                this.do_task_id = null
            }
            if (this.task_finish_id) {
                GlobalEventSystem.UnBind(this.task_finish_id)
                this.task_finish_id = null
            }
            if (this.monster_add_id) {
                GlobalEventSystem.UnBind(this.monster_add_id)
                this.monster_add_id = null
            }
        }

        this.StartStoryListener = () => {
            if (this.isOnStory) {
                return
            }
            console.log("StoryController:StartStoryListener()", Status.NowTime)
            // console.log(debug.traceback())
            if (this.nowStoryInfo != null && this.nowStoryInfo.storyVoList.length > 0) {
                this.cur_scene_played = []
                this.complete_conditions = []

                if (this.execute_times_table) {
                    for (let k = 0; k < this.execute_times_table.length; k++) {
                        var index = this.execute_times_table[k]
                        this.cur_scene_played[index] = true
                    }
                    this.execute_times_table = null
                }
                this.AddStoryLister()
                this.onStoryConditionChanged(null, null, true) //开场剧情检测
            }
        }

        this.AddStoryLister = () => {
            this.isOnStory = true
            let pre_rect_list = []
            var onMainRoleMove = (posx, posy) => {
                let bool = false
                for (let i = 0; i < pre_rect_list.length; i++) {
                    var args = pre_rect_list[i]
                    if (this.IsInRectArea(posx, posy, args.x, args.y, args.w / 2, args.h / 2)) {
                        bool = true
                        break
                    }
                }
                if (bool) {
                    this.onStoryConditionChanged(4)
                }
            }

            var onMainRoleDoTask = () => {
                let main_line_task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
                if (main_line_task_vo && main_line_task_vo.task_id) {
                    this.onStoryConditionChanged(5, main_line_task_vo.task_id)
                }
            }

            let pre_task_list = []
            var onTaskFinishHandler = (taskId) => {
                if (pre_task_list[taskId]) {
                    this.onStoryConditionChanged(6, taskId)
                }
            }

            let pre_monster_id
            var onMonsterBorn = (mon_id, mon_vo) => {
                if (mon_vo && mon_vo.type_id == pre_monster_id) {
                    this.onStoryConditionChanged(8)
                }
            }

            let storyVo = null
            let condition
            let len = 0
            let type = 0
            let listType = []
            for (let i = 1; i <= this.nowStoryInfo.storyVoList.length; i++) {
                storyVo = this.nowStoryInfo.storyVoList[i]
                if (!storyVo.dungeon_id_list || Util.TableContains(storyVo.dungeon_id_list, this.curDungeonId)) {
                    if (storyVo.condition) {
                        len = storyVo.condition.length
                        for (let j = 1; j <= len; j++) {
                            condition = storyVo.condition[j]
                            type = condition.type
                            if (type == 4) {
                                //记录检测区域
                                let content = Split(condition.content, ",")
                                let center_x = content[0]
                                let center_y = content[1]

                                let width = content[2]
                                let height = content[3]

                                pre_rect_list[pre_rect_list.length] = { "x": center_x, "y": center_y, "w": width, "h": height }

                                //人物进入某个区域
                                if (listType[4] == null) {
                                    this.role_move_id = GlobalEventSystem.Bind(ObjectEventType.MAINROLE_MOVE_EVENT, onMainRoleMove)
                                    listType[4] = true
                                }
                            } else if (type == 5 && listType[5] == null) {
                                //任务中途触发
                                this.do_task_id = GlobalEventSystem.Bind(ObjectEventType.MAINROLE_MOVE_EVENT, onMainRoleDoTask)
                                listType[5] = true
                            } else if (type == 6) {
                                let id = Number(condition.content)
                                pre_task_list[id] = true
                                if (listType[6] == null) {
                                    //任务完成
                                    this.task_finish_id = TaskModel.GetInstance().Bind(TaskModel.FINISH_TASK, onTaskFinishHandler)
                                    listType[6] = true
                                }
                            } else if (type == 8) {
                                pre_monster_id = condition.content
                                if (listType[8] == null) {
                                    this.monster_add_id = GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_ADD, onMonsterBorn)
                                    listType[8] = true
                                }
                            }
                        }
                    }
                }
            }
        }

        this.onStoryConditionChanged = (type?, taskId?, first?) => {

            if (this.nowStoryInfo == null) {
                return
            }

            if (this.IsPlaying()) {
                return
            }

            let storyVo = null
            let currentStoryVo_index = 0
            let condition
            let len
            let is_on_task_fire = false
            let need_check = false

            taskId = taskId || 0

            for (let i = 1; i <= this.nowStoryInfo.storyVoList.length; i++) {
                storyVo = this.nowStoryInfo.storyVoList[i]

                //已完成的条件集
                this.complete_conditions[i] = this.complete_conditions[i] || {}
                let myCondition = this.complete_conditions[i]

                need_check = false
                let hasTimes = false //是否有播放次数
                if (!storyVo.times || storyVo.times == -1
                    // || storyVo.times > StoryModel.GetInstance().GetStoryTimes(this.nowStoryInfo.sceneId, i)
                ) {
                    hasTimes = true
                }

                if (storyVo.condition && hasTimes && !this.cur_scene_played[i]) {
                    need_check = true
                }

                if (need_check) {
                    if (!this.TriggerByServer(this.curSceneId, i)) {
                        len = storyVo.condition.length
                        for (let j = 1; j <= len; j++) {
                            condition = storyVo.condition[j]
                            if (myCondition[j] == null) {
                                myCondition[j] = false
                            }
                            if (myCondition[j] != true) {
                                //英文需要屏蔽掉最开头的剧情
                                if (this.curSceneId == 10001 && condition.type == 1 && CommonManager.GetInstance().GetWelfareWelcomeOpenState()) {
                                    break
                                }
                                if (first && condition.type == 1) { //进入场景触发
                                    myCondition[j] = true
                                } else if (first && condition.type == 2) { //进入副本触发
                                    let content = Split(condition.content, ",")
                                    for (let i = 0; i < content.length; i++) {
                                        var v = content[i]
                                        if (this.curDungeonId == Number(v)) {
                                            myCondition[j] = true
                                            break
                                        }
                                    }
                                } else if (condition.type == 4 && type == 4) { //区域触发
                                    let content = Split(condition.content, ",")
                                    let center_x = content[0]
                                    let center_y = content[1]

                                    let width = content[2]
                                    let height = content[3]

                                    let main_role = Scene.Instance.main_role
                                        let role_pos_x, role_pos_y = main_role.GetRealPos()
                                        if (this.IsInRectArea(role_pos_x, role_pos_y, center_x, center_y, width / 2, height / 2)) {
                                            myCondition[j] = true
                                        }
                                } else if (condition.type == 5 && type == 5) {	//任务中途寻路触发
                                    let content = Split(condition.content, ",")
                                    let id = content[1]
                                    if (Number(id) == taskId) {
                                        let center_x = content[1]
                                        let center_y = content[2]
                                        let width = content[3]
                                        let height = content[4]

                                        let main_role = Scene.Instance.main_role
                                            let role_pos_x, role_pos_y = main_role.GetRealPos()
                                            if (this.IsInRectArea(role_pos_x, role_pos_y, center_x, center_y, width / 2, height / 2)) {
                                                myCondition[j] = true
                                            }
                                    }
                                } else if (condition.type == 6 && type == 6) {	//完成某个任务
                                    let id = Number(condition.content)
                                    if (id == taskId) {
                                        myCondition[j] = true
                                    }
                                } else if (condition.type == 7) {	//未完成某个任务
                                    let id = Number(condition.content)
                                    if (TaskModel.GetInstance().newest_finish_task_id < id) {
                                        myCondition[j] = true
                                    }
                                } else if ((first && condition.type == 8) || (condition.type == 8 && type == 8)) { //怪物出生触发
                                    let monster_id = condition.content
                                    if (this.scene_mgr.GetMonsterVoByTypeId(monster_id)) {
                                        myCondition[j] = true
                                    }
                                }
                            }
                        }
                        let isOk = len != 0 && true || false
                        for (let ix = 1; ix <= myCondition.length; ix++) {
                            if (myCondition[ix] != true) {
                                isOk = false
                                break
                            }
                        }
                        if (isOk) {
                            currentStoryVo_index = i
                        }
                    }
                }
            }

            if (currentStoryVo_index && currentStoryVo_index > 0) {
                console.log("StoryController@onStoryConditionChanged@满足条件了", currentStoryVo_index, Status.NowTime)
                this.StartStory(currentStoryVo_index)
            }
        }

        //是否在矩形区域
        this.IsInRectArea = (role_x?, role_y?, center_x?, center_y?, offset_x?, offset_y?) => {

            this.x0 = center_x - offset_x
            this.x1 = center_x + offset_x
            this.y0 = center_y - offset_y
            this.y1 = center_y + offset_y

            if (role_x >= this.x0 && role_x <= this.x1 && role_y >= this.y0 && role_y <= this.y1) {
                return true
            }

            return false
        }

        this.StartStory = (index?, start_time?, is_server_trigger?) => {

            //处于剧情触发监听中才能播放剧情，也就是场景加载后
            if (!this.isOnStory) {
                this.cache_story_play = () => {
                    this.StartStory(index, start_time, is_server_trigger)
                }
                console.log("StoryController:StartStory(), 剧情还未完成初始化, 进行缓存")
                return
            }

            //当前场景是否有剧情配置
            if (this.nowStoryInfo == null) {
                console.log("StoryController:StartStory() 剧情配置信息为null, scene_id = ", this.curSceneId)
                return
            }

            //是否为有效配置
            let storyVo = null
            let contentList = null
            if (this.nowStoryInfo.storyVoList[index] && this.nowStoryInfo.storyVoList[index].contentList) {
                storyVo = this.nowStoryInfo.storyVoList[index]
                contentList = storyVo.contentList
            }
            if (!contentList || contentList.length == 0) {
                console.log("StoryController:StartStory(), 播放的剧情无效 ", this.curSceneId, index)
                return
            }

            //是否已经播放
            for (let ins in this.play_story_list) {
                var player = this.play_story_list[ins]
                if (player.play_index == index) {
                    console.log("StoryController:StartStory(), 已播放的剧情 ", this.curSceneId, index)
                    return
                }
            }

            //播放需要的预加载剧情
            if (storyVo.preload) {
                for (let i = 0; i < storyVo.preload.length; i++) {
                    var index = storyVo.preload[i]
                    this.StartStory(index)
                }
            }

            console.log("开始播放剧情, scene_id = " + String(this.curSceneId) + ", index = " + String(index))
            if (is_server_trigger) {
                this.SendFmtToGame(61010, "iic", this.curSceneId, index, 0)
            }
            this.complete_conditions[index] = null //清空这段剧情的完成标识
            this.cur_scene_played[index] = true //记录此次进入场景已播放的剧情

            this.play_story_ins_id = this.play_story_ins_id + 1

            // let story_view = new StoryPlayer(this, this.play_story_ins_id, index, is_server_trigger)
            // story_view.SetData(storyVo, start_time)
            // story_view.Open()
            // this.play_story_list[this.play_story_ins_id] = story_view

            GlobalEventSystem.Fire(EventName.STORY_START, this.curSceneId, index)
        }

        this.StopStory = (story_player?) => {

            //结束相关联的预加载剧情
            if (story_player.storyVo.preload) {
                for (let i = 0; i < story_player.storyVo.preload.length; i++) {
                    var index = story_player.storyVo.preload[i]
                    for (let ins in this.play_story_list) {
                        var player = this.play_story_list[ins]
                        if (player.play_index == index) {
                            this.StopStory(player)
                        }
                    }
                }
            }

            let play_index = story_player.play_index
            console.log("StoryController:StopStory(), 剧情结束 ins_id = " + story_player.ins_id + ", index = " + play_index)

            this.ImmStopStory(story_player)

            this.cur_scene_played[play_index] = true
            this.play_story_list[story_player.ins_id] = null
            story_player.QuitStoryPlayMode()
            story_player.Close()

            GlobalEventSystem.Fire(EventName.STORY_FINISH, this.curSceneId, play_index)

            if (this.finish_func_list) {
                this.finish_timer =
                    setTimeout(() => {
                        if (this.finish_func_list) {
                            for (let _ = 0; _ < this.finish_func_list.length; _++) {
                                var func = this.finish_func_list[_]
                                func()
                            }
                            this.finish_func_list = null
                        }
                    },
                        0.3
                    )
            }
            if (this.finish_now_func_list) {

                if (this.finish_now_func_list) {
                    for (let _ = 0; _ < this.finish_now_func_list.length; _++) {
                        var func = this.finish_now_func_list[_]
                        func()
                    }
                    this.finish_now_func_list = null
                }

            }
        }

        this.ClearPlayStory = () => {

            for (let ins in this.play_story_list) {
                var player = this.play_story_list[ins]
                if (player) {
                    this.StopStory(player)
                }
            }
            this.play_story_list = []
        }

        this.RegisterFinishDelayCallback = (func?) => {

            this.finish_func_list = this.finish_func_list || {}
            this.finish_func_list[this.finish_func_list.length + 1] = func
        }
        this.RegisterFinishNowCallback = (func?) => {

            this.finish_now_func_list = this.finish_now_func_list || {}
            this.finish_now_func_list[this.finish_now_func_list.length + 1] = func
        }

        this.CanTriggerStory = (index?) => {

            if (this.cur_scene_played[index]) {
                return false
            } else {
                return true
            }
        }

        //打印次数
        this.PrintStoryTimes = () => {

            if (this.curDungeonId == 0) {
                for (let i = 1; i <= this.nowStoryInfo.storyVoList.length; i++) {
                    // let times = StoryModel.GetInstance().GetStoryTimes(this.nowStoryInfo.sceneId, i)
                    // console.log(" i = ", i, " times = ", times, "  nowStoryInfo = ", this.nowStoryInfo.times)
                }
            }
        }

        this.HandleSceneChange = () => {
            console.log("StoryController:HandleSceneChange()")
            this.ClearPlayStory()
            this.ClearStoryListener()
            this.SetStoryData()
            this.cache_story_play = null
        }

        //场景切换马上设置 剧情信息
        this.SetStoryData = () => {

            this.curSceneId = SceneManager.Instance.GetSceneId() || 0
            this.curDungeonId = SceneManager.Instance.GetCurrDunId() || 0

            this.InitDungeonInfo(this.curDungeonId)
            this.nowStoryInfo = this.GetStoryConfig(this.curSceneId)
            // if (this.nowStoryInfo ) {
            // 	this.trigger_progress = this.nowStoryInfo.progress || TRIGGER_PROGRESS
            // }
        }

        //在播类型为Config.StoryType.Preload的剧情，不算播
        this.IsPlaying = () => {

            let bool = false
            for (let ins in this.play_story_list) {
                var player = this.play_story_list[ins]
                // if (player.storyVo.type != Config.StoryType.Preload) {
                //     bool = true
                //     break
                // }
            }

            return bool
        }

        this.RemoveCheckOutEvent = () => {
            this.ClearStoryListener()
            this.ClearPlayStory()
            this.cur_play_index = null
            // this.model.ClearData()
            this.cache_story_play = null
            this.cur_scene_played = []
            this.finish_func_list = null
            this.finish_now_func_list = null
            if (this.finish_timer) {
                GlobalTimerQuest.CancelQuest(this.finish_timer)
                this.finish_timer = null
            }
        }

        //初始化由服务端触发的剧情;初始化结束需要发给服务器的剧情
        this.InitDungeonInfo = (dungeon_id?) => {
            this.finish_reply_story_list = []
            this.server_trigger_story_list = []
            // let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon[dungeon_id]
            // if (cfg) {
            //     let p1, p2, story_id, story_sub_id = null
            //     let curr_scene_id = SceneManager.Instance.GetSceneId()
            //     let element_cfg = null
            //     for (let key in cfg) {
            //         var value = cfg[key]
            //         if ( typeof(value) == "object" && Util.TableSize(value) > 0) {
            //             element_cfg = value[curr_scene_id]
            //             if (element_cfg) {
            //                 p2 = -1
            //                 while (p2) {
            //                     // [p1, p2, story_id, story_sub_id] = String(element_cfg).search("%{story_finish%, -(%d+), -(%d+)")
            //                     // if (p2) {
            //                     //     this.finish_reply_story_list[Number(story_sub_id)] = Number(story_id)
            //                     // }
            //                 }
            //             }
            //         }
            //     }

            //     if (typeof(cfg.story_event) == "object" && Util.TableSize(cfg.story_event) > 0) {
            //         for (let k in cfg.story_event) {
            //             var v = cfg.story_event[k]
            //             let list = JSON.parse(v)
            //             for (let i = 0; i < list.length; i++) {
            //                 var arr0 = list[i]
            //                 for (let j = 0; j < arr0.length; j++) {
            //                     var arr1 = arr0[j]
            //                     let id_list = arr1[2]
            //                     if (Util.TableSize(id_list) > 0 && id_list.length >= 2) {
            //                         let story_id = id_list[1]
            //                         let story_sub_id = id_list[2]
            //                         this.server_trigger_story_list[Number(story_sub_id)] = Number(story_id)
            //                     }
            //                 }
            //             }
            //         }
            //     }
            // }
        }

        //是否忽略客户端条件，由服务端触发
        this.TriggerByServer = (story_id?, story_sub_id?) => {

            return this.server_trigger_story_list[story_sub_id] == story_id
        }

        this.NeedPlayStory = (scene_id?, dungeon_id?) => {

            let config = this.GetStoryConfig(scene_id)
            if (config) {
                for (let i = 0; i < config.storyVoList.length; i++) {
                    var item = config.storyVoList[i]
                    let condition = item.condition
                    if (condition && !this.cur_scene_played[i]) {
                        for (let _ = 0; _ < condition.length; _++) {
                            var v = condition[_]
                            if (v.type == 1) {		//进入场景触发
                                return true
                            } else if (v.type == 2) {	//进入副本触发
                                let content = Split(v.content, ",")
                                for (let _ = 0; _ < content.length; _++) {
                                    var id = content[_]
                                    if (dungeon_id == Number(id)) {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return false
        }

        this.ImmStopStory = (story_player?) => {
            if (story_player.is_server_trigger) {
                // if (story_player.storyVo.type == Config.StoryType.Dungeon) {
                //     this.SendFmtToGame(61010, "iic", this.curSceneId, story_player.play_index, 1)
                //     console.log("副本剧情结束, 通知服务器。索引id = ", story_player.play_index)
                // }
                story_player.is_server_trigger = false
            }
        }
        this.InitEvents()
    }
    

}



window["StoryController"] = StoryController