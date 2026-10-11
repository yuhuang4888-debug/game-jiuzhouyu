import { BaseView1 } from "../common/BaseView1"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { MainUIManager } from "../common/MainUIManager"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName, SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, Trim, SetHtmlStyle, SetHtmlCenter } from "../util/Util"
import { SYTweenLite } from "../util/SYTweenLite"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUITaskMainLineItem } from "./MainUITaskMainLineItem"
import { TeamMainRoleItem } from "./TeamMainRoleItem"
import { BossModel } from "../commonModel/BossModel"
import { Enum_UILayer } from "../common/LayerManager"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { GuildModel } from "../commonModel/GuildModel"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { TempleAwakenEvent, TempleAwakenModel } from "../commonModel/TempleAwakenModel"
import { GameResPath } from "../util/GameResPath"
import { FuncBoardView } from "./FuncBoardView"
import { PlatformManager } from "../PlatformManager"
import { StoryModel } from "../commonModel/StoryModel"
import { DialogueModel } from "../commonModel/DialogueModel"
import { MainUITaskItem } from "./MainUITaskItem"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { GhostWalkEvent, GhostWalkModel } from "../commonModel/GhostWalkModel"
import { LoginModel } from "../login/LoginModel"
//-@class MainUITaskTeamView
export class MainUITaskTeamView extends BaseView1 {

    public static SwitchType = {
        Task: 1,
        Team: 2
    }

    public static LightColor = "#98521a"// Color(131/255,79/255,51/255,1)
    public static DarkColor = "#50557d"// Color(241/255,212/255,181/255,1)

    public static MoveInterval = 0.7


    is_boss_scene
    group_loop_mgr
    last_finish_id
    main_line_item
    mainui_act_state
    now_type
    switch_state
    task_init
    task_item_list: MainUITaskItem[]
    task_list
    tween_id
    reward_item
    pos_x = 38
    func_board_item
    guaji_time
    delay_call_time
    delay_timer_id
    delay_update_size_id
    cache_temple_awaken_open_state
    turn_change_id
    panel_height = 0
    time_id_

    team_model: TeamModel
    task_model: TaskModel
    guild_model: GuildModel
    mainUI_model: MainUIModel

    public constructor() {
        super()

        this.base_file = "mainUI"
        this.layout_file = "MainUITaskTeamView"
        this.layer_value = Enum_UILayer.Main

        this.task_model = TaskModel.GetInstance()
        this.mainUI_model = MainUIModel.GetInstance()
        this.team_model = TeamModel.GetInstance()
        this.guild_model = GuildModel.GetInstance()
        this.preload_server_config = {
            "config_beings_gate_kv": false
        }
        this.load_callback = () => {
            this.LoadSuccess()
            this.mouseEvent()
        }

        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public Remove() {
        TempleAwakenModel.GetInstance().is_moving = false
        Laya.stage.off(Laya.Event.MOUSE_DOWN, this, this.mouseEvent);
        this.CancelTime()

        if (this.task_item_list) {
            for (let item of this.task_item_list) {
                item.DeleteMe()
            }
            this.task_item_list = undefined
        }
        if (this.delay_update_size_id) {
            clearTimeout(this.delay_update_size_id)
            this.delay_update_size_id = undefined
        }

        if (this.reward_item) {
            this.reward_item.DeleteMe()
            this.reward_item = null
        }

        if (this.group_loop_mgr) {
            this.group_loop_mgr.DeleteMe()
            this.group_loop_mgr = null
        }

        if (this.func_board_item) {
            this.func_board_item.DeleteMe()
            this.func_board_item = null
        }

        if (this.time_id_) {
            clearTimeout(this.time_id_)
            this.time_id_ = null
        }

        MainUIManager.GetInstance().RemoveMoveComponent(this)
        this.ClearUIEffect(this._box_awaken_effect)
    }

    public LoadSuccess() {
        ResManager.GetInstance().LoadFont(this, "temple_awaken_font", this._lb_open_awaken_progress, 14)
        SetHtmlStyle(this._html_open_lv, { f: 18, c: "#ffffff", w: 180, ww: false })
        this.display_obj.drawCallOptimize = false

        this.mainUI_model.SetMainuiLoadedFlag(this.layout_file, true, this)
        this._panel_task.vScrollBarSkin = ""
        this._list_team.vScrollBarSkin = ""
        this._img_team_red.visible = false

        this.UpdateCacheAs()

        if (PlatformManager.IsEyouEnPlatform()) {
            this._lb_task_desc_en.visible = true
            this._lb_team_desc_en.visible = true
            this._lb_task_desc.visible = false
            this._lb_team_desc.visible = false
        } else {
            this._lb_task_desc_en.visible = false
            this._lb_team_desc_en.visible = false
            this._lb_task_desc.visible = true
            this._lb_team_desc.visible = true
        }

        this.display_obj.left = 10
        this.display_obj.bottom = 380

        this._lb_team_desc.text = "组队"
        this._lb_task_desc.text = "任务"
        this.InitEvent()
        this.SwitchView(MainUITaskTeamView.SwitchType.Task)
        this.switch_state = false

        MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, true, MainUIManager.MOVE_TYPE.Left)

        if (BossModel.GetInstance().main_ui_setting_flag != undefined) {
            this.UpdateBossSceneSetting(BossModel.GetInstance().main_ui_setting_flag)
        }
        // this._panel_task.content.cacheAs = 'normal'

        this._panel_task["changeScroll"] = () => {
            //@ts-ignore
            this._panel_task._scrollChanged = false;
            var contentW = this._panel_task.contentWidth || 1;
            var contentH = this.panel_height || 1;

            //@ts-ignore
            var vscroll = this._panel_task._vScrollBar;
            //@ts-ignore
            var hscroll = this._panel_task._hScrollBar;
            //@ts-ignore
            var vShow = vscroll && contentH > this._panel_task._height;
            //@ts-ignore
            var hShow = hscroll && contentW > this._panel_task._width;
            //@ts-ignore
            var showWidth = vShow ? this._panel_task._width - vscroll.width : this._panel_task._width;
            //@ts-ignore
            var showHeight = hShow ? this._panel_task._height - hscroll.height : this._panel_task._height;

            if (vscroll) {
                //@ts-ignore
                vscroll.x = this._panel_task._width - vscroll.width;
                vscroll.y = 0;
                //@ts-ignore
                vscroll.height = this._panel_task._height - (hShow ? hscroll.height : 0);
                //@ts-ignore
                vscroll.scrollSize = Math.max(this._panel_task._height * 0.033, 1);
                vscroll.thumbPercent = showHeight / contentH;
                vscroll.setScroll(0, contentH - showHeight, vscroll.value);
            }
            if (hscroll) {
                hscroll.x = 0;
                //@ts-ignore
                hscroll.y = this._panel_task._height - hscroll.height;
                //@ts-ignore
                hscroll.width = this._panel_task._width - (vShow ? vscroll.width : 0);
                //@ts-ignore
                hscroll.scrollSize = Math.max(this._panel_task._width * 0.033, 1);
                hscroll.thumbPercent = showWidth / contentW;
                hscroll.setScroll(0, contentW - showWidth, hscroll.value);
            }
        }
    }

    public InitEvent() {

        this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (rType?, key?) => {
            if (rType != ModuleType.TEAM_APPLY) {
                return
            }
            this._img_team_red.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.TEAM_APPLY)
        }
        )

        this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
            //蜃气楼出来 队伍是直接解散了，所以false
            let last_scene_id = SceneManager.GetInstance().GetLastSceneId()
            if (SceneManager.GetInstance().IsCrossWuxianBossScene(last_scene_id)
                || SceneManager.GetInstance().IsHolyBossScene(last_scene_id)) {
                this._img_team_red.visible = false
            }
        }
        )


        Util.AddClickEvent(this._box_task_tab, (target?, x?, y?) => {
            this.SwitchView(MainUITaskTeamView.SwitchType.Task)
            GlobalEventSystem.Fire(EventName.SHOW_BOSS_WAY_PANEL, true)
        }, this)

        Util.AddClickEvent(this._box_team_tab, (target?, x?, y?) => {
            if (!this.team_model.IsOpenTeam()) return
            let canShowTeam = this.CanShowTeam();
            if (canShowTeam && this.now_type == MainUITaskTeamView.SwitchType.Team) {
                this.team_model.Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamView", false)
            }

            this.SwitchView(MainUITaskTeamView.SwitchType.Team)
            GlobalEventSystem.Fire(EventName.SHOW_BOSS_WAY_PANEL, false)

        }, this)

        Util.AddClickEvent(this._img_arrow, (target?, x?, y?) => {
            if (this.tween_id) {
                SYTweenLite.Stop(this.tween_id)
                this.tween_id = null
            }

            this.switch_state = !this.switch_state
            this._img_arrow_icon.scaleX = this.switch_state ? -1 : 1

            GlobalEventSystem.Fire(EventName.SHOW_MAIN_UI_TASK, !this.switch_state)
            let endValue = this.switch_state && -this.display_obj.width - this.display_obj.x - 20 || 0

            let tween_type = this.is_boss_scene && SYTweenFunc.LINEAR || SYTweenFunc.EASE_OUT_BACK

            let interval = this.switch_state && MainUITaskTeamView.MoveInterval * 0.6 || MainUITaskTeamView.MoveInterval * 0.6
            this.tween_id = SYTweenLite.to(this, this._box_con, SYTweenLite.UiAnimationType.POSX, endValue, interval, () => {
                this.tween_id = false
            }, tween_type)
        }, this)


        let delay_timer_id = null
        this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
            if (delay_timer_id) {
                clearTimeout(delay_timer_id)
                delay_timer_id = null
            }
            if (!delay_timer_id) {
                delay_timer_id = setTimeout(() => {
                    this.SetTaskConSize()
                }, 100)
            }
        })

        let task_refresh = () => {
            this.SetTaskShow()
            this.SetNowTaskPos()
        }
        this.BindEvent(this.task_model, TaskModel.UPDATE_ALL_TASK_FROM_30000, task_refresh)

        let restore_fun = (layout_file, force) => {
            if (!Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) return
            if (!Util.IsTableEmpty(StoryModel.RestoreFingerLock)) return
            if (this.story_model.CanRestoreFinger(layout_file) || force) {
                this.ShowFinger()
            }
        }
        this.BindEvent(GlobalEventSystem, EventName.RESTORE_FINGER, (layout_file, force) => {
            //两个页面之间切换会有间隙，如果在间隙中间发送ShowFinger指令，主界面的箭头会异常显示 
            if (this.time_id_) {
                clearTimeout(this.time_id_)
                this.time_id_ = null
            }

            this.time_id_ = setTimeout(() => {
                restore_fun(layout_file, force)
            }, 100);
        })
        // this.BindEvent(TeamModel.GetInstance(), TeamEvent.UPDATE_MATCH_STATE, restore_fun)

        let onUpdateMainLineVo = (vo?, same_task_id?) => {
            if (vo) {
                let task_cfg = this.task_model.GetTaskCfg(vo.task_id)
                if (task_cfg) {
                    if (!same_task_id) {
                        this.ShowFinger()
                        return
                    } else if (this.task_model.IsCurrMainTaskHasFinish()) {
                        this.ShowFinger()
                    }
                }
            }
        }
        this.BindEvent(this.task_model, TaskModel.UPDATE_MAIN_LINE_TASK_VO, onUpdateMainLineVo)

        let opdate_one_task = (task_id?, task_tips_list?) => {
            let finish = this.task_model.IsAllStepFinish(task_id)
            if (finish && this.last_finish_id != task_id) {
                this.last_finish_id = task_id
                this.SetTaskShow()
                this.SetNowTaskPos()
            }
        }

        this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, opdate_one_task)

        let update_team_fun = () => {
            this.UpdateTeamData()
        }
        this.BindEvent(this.team_model, TeamEvent.TEAM_UPDATE_TERAM_INFO, update_team_fun)

        let create_team_func = () => {
            if (!this.team_model.IsOpenTeam()) return
            let in_assist = this.guild_model.GetAssistData()
            if (in_assist) {
                Message.show("正在协助中，无法组队")
                return
            }
            this.team_model.Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamView", true)
        }
        Util.AddClickEvent(this._img_create_team, create_team_func, this)

        let search_team_func = () => {
            if (!this.team_model.IsOpenTeam()) return
            let in_assist = this.guild_model.GetAssistData()
            if (in_assist) {
                Message.show("正在协助中，无法组队")
                return
            }
            this.team_model.Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamView", false)
        }
        Util.AddClickEvent(this._img_search_team, search_team_func, this)


        this.BindEvent(BossModel.GetInstance(), EventName.OPEN_BOSS_SCENE_VIEW, (show?, boss_type?) => {
            this.UpdateBossSceneSetting(show)
        }
        )
        this.BindEvent(SentientActModel.GetInstance(), SentientActEvent.OPEN_SENTIENTACT_VIEW, (show) => {
            this.UpdateBossSceneSetting(show)
        })
        this.BindEvent(GhostWalkModel.ins, GhostWalkEvent.ENTER_SCENE, (show) => {
            this.UpdateBossSceneSetting(show)
        })

        this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_beings_gate_kv', false);
            let sceneMgr = SceneManager.GetInstance();
            let lastSceneId = sceneMgr.GetLastSceneId();
            let sModel = SentientActModel.GetInstance();

            let isFromBossScene = !sceneMgr.IsBossScene() && sceneMgr.IsBossScene(lastSceneId);
            let isFromSentientActScene = (!sceneMgr.IsSentientActScene() && sceneMgr.IsSentientActScene(lastSceneId) && !sModel.IsSentientActDungeonScene(cfg));
            let isFromKfHolyAreaScene = !sceneMgr.IsKfHolyAreaScene() && sceneMgr.IsKfHolyAreaScene(lastSceneId);
            let isFromFeatBossScene = !sceneMgr.IsFeastBossScene() && sceneMgr.IsFeastBossScene(lastSceneId);
            let isFromSentientActDungeonScene = (!sModel.IsSentientActDungeonScene(cfg) && sModel.IsSentientActDungeonScene(cfg, lastSceneId) && !sceneMgr.IsSentientActScene());
            let isFromGhostWalkBossScene = !sceneMgr.IsGhostWalkScene() && sceneMgr.IsGhostWalkScene(lastSceneId);

            if (lastSceneId != 0 && (isFromBossScene || isFromSentientActScene || isFromSentientActDungeonScene || isFromKfHolyAreaScene || isFromFeatBossScene || isFromGhostWalkBossScene)) {
                MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_task);
                this.is_boss_scene = false;
                if (this.now_type == MainUITaskTeamView.SwitchType.Task) {
                    this._box_task.visible = true;
                    this._box_team.visible = false;
                } else {
                    this._box_task.visible = false;
                    this.UpdateTeamData();
                }
                this._lb_task_desc.text = '任务';
                this._box_task.alpha = 1;
                this.display_obj.visible = true;
                this.display_obj.alpha = 1;
                this.display_obj.left = 10;
                MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, true, MainUIManager.MOVE_TYPE.Left);

                MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_temple_awaken);
                this._box_temple_awaken.visible = true;
                this._box_temple_awaken.alpha = 1;
            }
        });

        /**
         * 记得在this.CanShowTask和this.CanShowTeam中添加自己的场景判断
         *  */
        this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_ACTIVITY_STATE, this.changeTaskBtnText.bind(this));

        this.BindEvent(TempleAwakenModel.GetInstance(), TempleAwakenEvent.UPDATE_VIEW, () => {
            this.SetTempleAwaken()
        })

        this.ClickAwakeFunc()


        this.BindEvent(BossModel.GetInstance(), BossModel.SELECT_TASK_TEAM_VIEW, (type?) => {
            this.SwitchView(type)
        })

        this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_TASK_VIEW_CACHE_AS_STATE, () => {
            this.CallLater(this.UpdateCacheAs)
        });
        // this.BindEvent(TeamModel.GetInstance(),TeamEvent.TEAM_UPDATE_MAINUI,(type?)=>{
        // this.SwitchView(type)
        // })

        this.BindEvent(MainUIModel.GetInstance(), MainUIModel.SHOW_FUNC_BOARD_VIEW, (scmd, mod_id) => {
            if (mod_id == 429) {

                //神殿觉醒 判断是否完成章节任务
                let now_chapter = Number(scmd.uid) % 10 + 1000 //检查的章节
                let main_chapter_info = TempleAwakenModel.GetInstance().GetMainChapterInfo()
                if (main_chapter_info[now_chapter]) {
                    if (main_chapter_info[now_chapter].status == 3) {
                        //章节完成
                        if (this.func_board_item) {
                            this.func_board_item.DeleteMe()
                            this.func_board_item = null
                        }
                        return
                    }
                }

                let pos = new Laya.Point(this._box_temple_awaken.width + 25, 0)
                if (!this.func_board_item || this.func_board_item.use_delete_method) {
                    this.func_board_item = null
                    this.func_board_item = new FuncBoardView(this._box_temple_awaken)
                    this.func_board_item.SetData(scmd, pos, FuncBoardView.DIR_LEFT)
                    this.func_board_item.Load()
                }
                else {
                    this.func_board_item.SetData(scmd, pos, FuncBoardView.DIR_LEFT)
                }

            }

        })
        //Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseEvent);
        if (RoleManager.GetInstance().GetMainRoleLevel() < 65) {
            Laya.stage.on(Laya.Event.MOUSE_DOWN, this, this.mouseEvent);
            SceneManager.GetInstance().BindOne("curr_joystick_dir", this.mouseEvent)
        }

        //Laya.stage.once(Laya.Event.MOUSE_OUT, this, this.mouseEvent);
    }
    private CanShowTask() {
        let sceneMgr = SceneManager.GetInstance()
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_beings_gate_kv', false);
        let is_sentien_act_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg);
        let isBossScene = sceneMgr.IsBossScene() && !sceneMgr.IsKfHolyAreaScene()

        return !sceneMgr.IsHolyBossScene() && !sceneMgr.IsCrossWuxianBossScene() && !sceneMgr.IsGhostWalkScene() && !is_sentien_act_dungeon_scene && !sceneMgr.IsSentientActScene() && !isBossScene
    }

    private CanShowTeam() {
        let sceneMgr = SceneManager.GetInstance()
        return !sceneMgr.IsHolyBossScene() && !sceneMgr.IsCrossWuxianBossScene()
    }

    private CancelTime = () => {
        if (this.guaji_time) {
            GlobalTimerQuest.CancelQuest(this.guaji_time)
        }
        if (this.delay_call_time) {
            clearTimeout(this.delay_call_time)
            this.delay_call_time = null
        }
    }

    private mouseEvent = () => {
        this.CancelTime()
        if (RoleManager.GetInstance().GetMainRoleLevel() < 65) {

            this.delay_call_time = setTimeout(() => {
                this.guaji_time = GlobalTimerQuest.AddPeriodQuest(() => {
                    let task = TaskModel.GetInstance().GetMainLineTaskVo()
                    if (!task) return

                    let bool = true
                    //开启自动推关/在推关副本内
                    if (AutoBrushModel.GetInstance().GetAutoBrushStrangeState() || SceneManager.GetInstance().IsMainLineDungeonScene()) {
                        bool = false
                    }

                    //使用遥感时
                    if (bool && SceneManager.GetInstance().curr_joystick_dir) {
                        bool = false
                    }

                    //存在引导时
                    if (bool && StoryModel.GetInstance().HasFingerIsShowing()) {
                        bool = false
                    }

                    //有大界面打开时
                    if (bool && !Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
                        bool = false
                    }

                    //有引导锁时
                    if (bool && !Util.IsTableEmpty(StoryModel.RestoreFingerLock)) {
                        bool = false
                    }

                    //有引导锁时
                    if (bool && !Util.IsTableEmpty(StoryModel.ShowFingerLock)) {
                        bool = false
                    }

                    //自动任务状态关闭时
                    if (bool && !TaskModel.GetInstance().GetAutoTaskSetting()) {
                        bool = false
                    }

                    //自动任务状态关闭时
                    if (bool && LoginModel.GetInstance().is_show_loading_view) {
                        bool = false
                    }

                    //当前打开对话界面且对话的目标是任务目标
                    if (bool && DialogueModel.GetInstance().dialog_is_open && DialogueModel.GetInstance().dialog_view) {
                        let npc_vo = DialogueModel.GetInstance().dialog_view.npc_dialog_vo
                        let npc_vo1 = SceneManager.Instance.GetNpcVo(task.id)
                        if (npc_vo && npc_vo1 && npc_vo.npc_id == npc_vo1.npc_id) {
                            bool = false
                        }
                    }

                    if (bool) {
                        TaskModel.GetInstance().DoTask()
                    }

                }, 10)
            }, 500)
        }
    }

    changeTaskBtnText(bool?) {
        this.mainui_act_state = bool;
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_beings_gate_kv', false);
        let is_sentien_act_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg);
        let text: string;
        if (bool) {
            text = '任务'
        } else if (SceneManager.GetInstance().IsGhostWalkScene()) {
            text = '位置';
        } else if (SceneManager.GetInstance().IsSentientActScene() || is_sentien_act_dungeon_scene) {
            text = '详情';
        } else if (SceneManager.GetInstance().IsBossScene() && !SceneManager.GetInstance().IsKfHolyAreaScene()) {
            text = '大妖';
        }
        text && (this._lb_task_desc.text = text);
    }

    public UpdateBossSceneSetting(show) {
        BossModel.GetInstance().main_ui_setting_flag = undefined
        if (SceneManager.GetInstance().IsFeastBossScene()) {
            return
        }
        if (show) {
            this.now_type = null
            this.SwitchView(MainUITaskTeamView.SwitchType.Task)
            MainUIManager.GetInstance().RemoveMoveOneComponent(this, this.display_obj)
            this.display_obj.visible = true
            this.display_obj.alpha = 1
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_task, true, MainUIManager.MOVE_TYPE.Stay)
            this.is_boss_scene = true
            this._box_temple_awaken.visible = true
            this._box_temple_awaken.alpha = 1
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_temple_awaken, true, MainUIManager.MOVE_TYPE.Stay)
        } else {

        }
        this.changeTaskBtnText(this.mainui_act_state);
        if (!this.CanShowTeam()) {
            this._lb_team_desc.text = "悬赏"
        } else {
            this._lb_team_desc.text = "队伍"
        }
    }

    public SwitchView(type?) {
        let canShowTask = this.CanShowTask();
        let canShowTeam = this.CanShowTeam();
        if (this.now_type == type && canShowTeam) {
            if (type == MainUITaskTeamView.SwitchType.Task) {
                this.task_model.Fire(TaskModel.TASK_OPEN_VIEW, "TaskView")	//打开界面
            }
            // return
        }

        this.now_type = type
        this._box_task.visible = this.now_type == MainUITaskTeamView.SwitchType.Task && canShowTask
        this._box_team.visible = this.now_type == MainUITaskTeamView.SwitchType.Team && canShowTeam
        this._box_non_team.visible = this.now_type == MainUITaskTeamView.SwitchType.Team && canShowTeam

        if (type == MainUITaskTeamView.SwitchType.Task) {
            if (this.is_boss_scene) {
                MainUIManager.GetInstance().AddMoveComponent(this, this._box_task, true, MainUIManager.MOVE_TYPE.Stay)
            } else {

            }
            ResManager.GetInstance().SetImageSprite(this, this._img_task_bg, "mainUI", "mainui_taskbtn_light")
            ResManager.GetInstance().SetImageSprite(this, this._img_team_bg, "mainUI", "mainui_taskbtn_normal")

            this._lb_team_desc.color = MainUITaskTeamView.DarkColor
            this._lb_task_desc.color = MainUITaskTeamView.LightColor
            this._lb_team_desc_en.color = MainUITaskTeamView.DarkColor
            this._lb_task_desc_en.color = MainUITaskTeamView.LightColor

            //if (! this.task_init ) {
            //this.task_init = true
            this.ShowTaskContent()


            if (!canShowTeam &&SceneManager.GetInstance().IsHolyBossScene()) {
                this._img_team_red.visible = BossModel.GetInstance().GetEudaemonTaskRed()
            }


            //}
        } else {
            ResManager.GetInstance().SetImageSprite(this, this._img_task_bg, "mainUI", "mainui_taskbtn_normal")
            if (this.is_boss_scene) {
                MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_task)
                this._box_task.visible = false
                this._box_task.alpha = 1
            } else {
            }

            ResManager.GetInstance().SetImageSprite(this, this._img_team_bg, "mainUI", "mainui_taskbtn_light")

            this._lb_team_desc.color = MainUITaskTeamView.LightColor
            this._lb_task_desc.color = MainUITaskTeamView.DarkColor
            this._lb_team_desc_en.color = MainUITaskTeamView.LightColor
            this._lb_task_desc_en.color = MainUITaskTeamView.DarkColor
            if (!canShowTeam) {
                BossModel.GetInstance().Fire(BossModel.FORCE_SHOW_TASK)
                if (SceneManager.GetInstance().IsHolyBossScene()) {
                    this._img_team_red.visible = false
                }
                return
            }
            this.UpdateTeamData()

        }
    }

    public UpdateTeamData() {
        let have_team = this.team_model.team_info && this.team_model.team_info.team_id != null
        if (have_team) {
            this._img_team_role_count_bg.visible = true
            let team_member_list = this.team_model.team_info.team_member_list
            if (team_member_list) {
                this._lb_team_role_count.text = team_member_list.length
            }
        }
        else {
            this._img_team_role_count_bg.visible = false
        }
        if (this.now_type != MainUITaskTeamView.SwitchType.Team) {
            return
        }

        this._box_non_team.visible = !have_team
        this._box_team.visible = have_team
        if (have_team) {
            let array_list = this.team_model.team_info.team_member_list
            let new_list = []
            for (let k = 0; k < array_list.length; k++) {
                var v = array_list[k]
                new_list[k] = v
            }
            if (new_list.length < TeamModel.TEAMER_MAX) {
                table.insert(new_list, {})
            }
            if (!this.group_loop_mgr) {
                this.group_loop_mgr = new LoopScrowViewMgr()
                this.group_loop_mgr.SetData(this._list_team, TeamMainRoleItem, new_list, LoopScrCon.Vertical, 1)
            } else {
                this.group_loop_mgr.replaceAll(new_list)
            }
        }
    }

    //显示任务内容
    public ShowTaskContent() {
        this.SetTempleAwaken()
        this.SetTaskShow()
        this.SetNowTaskPos()
    }

    public ShowFinger() {
        let main_line_task_vo = this.task_model.GetMainLineTaskVo()
        if (SceneManager.GetInstance().IsFieldScene()
            && Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)
            && Util.IsTableEmpty(StoryModel.ShowFingerLock)
            && main_line_task_vo
            && !LoginModel.GetInstance().is_show_loading_view
            && !this.task_model.NotShowFinger(main_line_task_vo)) {
            let need_show_one = true
            if (!this.task_model.DoTask(null, false)) {
                let [has_lv, lv_task_vo, daily_task_vo] = this.task_model.HasNotFinishLvTask()
                if (has_lv && daily_task_vo) { //日常任务特殊处理
                    if (!this.task_model.has_show_daily_task_finger) {
                        let step_cfg = { direction: 4, text: "<font color='#0a9f42'>日常任务</font>  加速升级~" }
                        this.ShowMainLineTaskArrow(step_cfg, true)
                    } else {
                        this.HideMainLineTaskArrow()
                    }
                    need_show_one = false
                // } else {
                //     if (main_line_task_vo.task_tips_type == TaskTipType.LV) {
                //         if ((this.task_model.click_lv_arrow_time && TimeUtil.getServerTime() - this.task_model.click_lv_arrow_time < TaskModel.lV_ARROW_TIME_LEN) || this.task_model.show_lv_times > 2) {
                //             return
                //         }
                //         this.task_model.show_lv_times = this.task_model.show_lv_times + 1
                //     }
                //     this.ShowMainLineTaskArrow()
                }
            }
            if (need_show_one) {
                this.NeedShowOneFinger()
            }
        } else {
            if (this.delay_timer_id) {
                clearTimeout(this.delay_timer_id)
                this.delay_timer_id = null
            }
            this.HideMainLineTaskArrow()
        }
    }

    public NeedShowOneFinger() {

        let main_line_task_vo = this.task_model.GetMainLineTaskVo()
        if (main_line_task_vo) {
            let step_cfg = this.task_model.GetNowGuideCfg(true)
            if (this.delay_timer_id) {
                clearTimeout(this.delay_timer_id)
                this.delay_timer_id = null
            }
            if (!step_cfg) {
                this.HideMainLineTaskArrow()
                return
            }
            let delay_fun = () => {
                this.ShowMainLineTaskArrow(step_cfg)
            }
            this.delay_timer_id = setTimeout(delay_fun, 10)
        }
    }

    public ShowMainLineTaskArrow(step_cfg?, force?) {
        let main_line_task_vo = this.task_model.GetMainLineTaskVo()
        if (main_line_task_vo && main_line_task_vo.task_id <= TaskModel.GuideTask && this.main_line_item && this._box_main_line.visible) {
            this.main_line_item.ShowMainLineArrow(step_cfg, force)
        }
    }

    public HideMainLineTaskArrow() {
        if (this.main_line_item) {
            this.main_line_item.HideMainLineArrow()
        }
    }

    public SetTaskShow() {

        if (!this.is_loaded) {
            return
        }
        let sort_fun = (a, b) => {
            if (a.sort_index == b.sort_index) {
                if (a.sort_sub_index == b.sort_sub_index) {
                    if (a.same_type_order_index == b.same_type_order_index) {
                        return a.task_id - b.task_id
                    } else {
                        return a.same_type_order_index - b.same_type_order_index
                    }
                } else {
                    return a.sort_sub_index - b.sort_sub_index
                }
            } else {
                return a.sort_index - b.sort_index
            }
        }
        let [has_lv, lv_task_vo, daily_task_vo] = this.task_model.HasNotFinishLvTask()
        let task_list = []
        let need_arrow = ((has_lv && daily_task_vo) && true || false) || this.task_model.MainLineTaskNeedShowArrow()

        let receive_tas_list = this.task_model.GetAllTaskList()
        if (receive_tas_list) {
            for (let task_id in receive_tas_list) {

                if (has_lv && daily_task_vo && daily_task_vo.task_id == task_id) {

                } else {
                    if ((!need_arrow || !this.task_model.IsMainTask(task_id) || (has_lv && daily_task_vo))
                        && !this.task_model.IsAwakeTask(task_id)
                        && !this.task_model.IsEudaemonTask(task_id)
                        && !this.task_model.IsKKHolyAreaTask(task_id)) {
                        // if(task_id == '200870'){
                        let [idx1, idx2, idx3] = this.task_model.GetSortIndex(task_id)
                        let task = {
                            task_id: task_id,
                            sort_index: idx1,
                            sort_sub_index: idx2,
                            same_type_order_index: idx3,
                            tips_list: receive_tas_list[task_id],
                        }

                        table.insert(task_list, task)
                    }
                }
            }
            if (need_arrow == false && task_list.length == 1) {
                table.remove(task_list, 0)
                need_arrow = true
            }
        }
        if (task_list.length > 0) {
            task_list.sort(sort_fun)
            // table.sort(task_list, sort_fun)
        }
        // console.warn("------sort_task2------", task_list)
        this.task_list = task_list
        this._box_main_line.visible = need_arrow == true
        if (need_arrow) {
            this.SetMainLineTask(has_lv && daily_task_vo || null)
        }
        if (!need_arrow || !has_lv || !daily_task_vo) {
            this.task_model.has_show_daily_task_finger = false
        }

        this.SetTaskConSize()
        this.SetTaskItem()
    }

    public SetTaskItem() {
        let list = this.task_list
        if (!list) return
        if (list.length > 0) {
            this._panel_task.visible = true
        }
        else {
            this._panel_task.visible = false
        }
        if (!this.task_item_list) {
            this.task_item_list = []
        }
        let len = list.length
        let list_len = this.task_item_list.length


        for (let i = 0; i < list.length; i++) {
            let item: MainUITaskItem = this.task_item_list[i]
            if (!item) {
                item = new MainUITaskItem(this._panel_task)
                item.Load()
                this.task_item_list[i] = item
                item.SetUpdateSizeCall(() => {
                    this.TryUpdateItemSize()
                })
            }
            item.SetVisible(true)
            item.SetData(list[i])
        }

        for (let i = len; i < list_len; i++) {
            this.task_item_list[i].SetPosition(-1, 1)
            this.task_item_list[i].SetVisible(false)
            this.task_item_list[i].SetData(null)
            this.task_item_list[i].height_cache = undefined
        }
    }

    public TryUpdateItemSize() {
        if (this.delay_update_size_id) {
            return
        }

        this.delay_update_size_id = setTimeout(() => {
            this.UpdateItemSize()
            this.delay_update_size_id = undefined
        }, 10);
    }

    public UpdateItemSize() {
        if (!this.task_item_list) {
            return
        }
        let h, item: MainUITaskItem, t_h = 0
        let list = this.task_list
        for (let i = 0; i < list.length; i++) {
            item = this.task_item_list[i]
            if (item) {
                item.SetPosition(0, t_h)
                h = item.GetHeight() + 2 //间距
                t_h += h
            }
        }
        this.panel_height = t_h
        this._panel_task["_setScrollChanged"]()
    }


    public SetMainLineTask(task_vo?) {
        let main_line_task_vo = this.task_model.GetMainLineTaskVo()
        let receive_task_list = this.task_model.GetHasReceiveTaskList()
        if (receive_task_list && Util.TableSize(receive_task_list) > 0 && (task_vo || main_line_task_vo)) {
            if (!this.main_line_item) {
                this.main_line_item = new MainUITaskMainLineItem(this._box_main_line)
                this.main_line_item.Load()
                this.main_line_item.SetUpdateSizeCall(() => {
                    this.SetTaskConSize()
                })
            }
            this.main_line_item.SetVisible(true)
            let task_id = 0
            if (task_vo) {
                task_id = task_vo.task_id
            } else {
                task_id = main_line_task_vo.task_id
            }
            let task = {
                task_id: task_id,
                sort_index: 0,
                sort_sub_index: 0,
                tips_list: receive_task_list[task_id]
            }

            this.main_line_item.SetData(task)
            //初始化完设一遍引导箭头
            this.ShowFinger()
        } else {
            if (this.main_line_item) {
                this.main_line_item.SetVisible(false)
            }
        }
    }

    public SetTaskConSize() {
        if (!this._box_main_line.visible) {
            this._panel_task.y = this._box_main_line.y
            this._panel_task.height = 214
        } else {
            let height = this.main_line_item && this.main_line_item.GetHeight() || 0
            this._panel_task.y = height + 2
            this._panel_task.height = 212 - height
        }
    }

    public SetNowTaskPos() {

        if (!this.is_loaded) {
            return
        }
        let index = 0
        if ((this.task_list && this.task_model.now_select_task_id)) {
            let vo = null

            let i = 0
            let length = this.task_list.length
            do {
                vo = this.task_list[i]
                if (vo) {
                    if (vo.task_id == this.task_model.now_select_task_id) {
                        index = i
                        break
                    }
                }
                i = i + 1
            } while ((i < length)
            )
            let gap = index * 70
        }
        // this.task_loop_mgr.CenterOnChild(index)
    }

    public SetTempleAwaken() {

        if (!this.is_loaded) {
            return
        }


        let info = TempleAwakenModel.GetInstance().GetNowTask()
        this._img_awaken_red.visible = false
        this.ClearUIEffect(this._box_awaken_effect)
        if (!info || Util.TableSize(info) <= 0) {
            return
        }
        if (info.is_complete) {
            this._box_unopen_awaken.visible = true
            this._box_open_awaken.visible = false
            this._html_open_lv.innerHTML = Util.StrToHTML("<font color='#00fa64'>已完成全部</font>")
            SetHtmlCenter(this._html_open_lv, { x: this.pos_x, w: 180 })
            return
        }


        if (info && info.can_receive) {
            this._img_awaken_red.visible = true
            // let pos={ x: 0, y: 0 }
            // let scale = 19.5
            // this.AddUIEffect("ui_shendianjuexing", this._box_awaken_effect, pos, scale, true)
        }

        let is_active = info.isactive
        this._box_unopen_awaken.visible = !is_active
        this._box_open_awaken.visible = is_active

        let open_state = info.isactive || info.is_lock_task
        if (this.cache_temple_awaken_open_state == false && this.cache_temple_awaken_open_state != open_state) {
            if (open_state) {
                this._box_temple_awaken.visible = true
                this._box_temple_awaken.x = 0//-224
                TempleAwakenModel.GetInstance().is_moving = true
                SYTweenLite.to(this, this._box_temple_awaken, SYTweenLite.UiAnimationType.POSX, 0, 0.5, () => {
                    this.tween_id = false
                    TempleAwakenModel.GetInstance().is_moving = false
                    GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.TempleAwakenBtn, true)
                }, SYTweenFunc.EASE_OUT_BACK)
            }
        }
        this.cache_temple_awaken_open_state = open_state

        if (is_active) {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_goods_icon, GameResPath.GetGoodsIconPath(info.goods_id + ""))
            ResManager.GetInstance().SetImageSprite(this, this._img_goods_name, "mainUI", `sdjx_${info.goods_name}`, true)

            //策划需要完成才算一级
            let cur_stage = info.now_stage >= 1 ? info.now_stage - 1 : 0;
            this._lb_open_awaken_progress.text = `${cur_stage}/${info.all_stage}`
            this._lb_open_awaken_task_desc.text = Trim(info.stage_name)
        } else {
            if (info.is_lock_task) {
                this._html_open_lv.innerHTML = Util.StrToHTML("<font color='#00fa64'>" + info.open_lv + "</font>级解锁新任务")
                SetHtmlCenter(this._html_open_lv, { x: this.pos_x, w: 180 })
            } else {
                // this._html_open_lv.innerHTML = Util.StrToHTML("人物<font color='#00fa64'>" + info.open_lv + "</font>级开启")
                // SetHtmlCenter(this._html_open_lv, { x: this.pos_x, w: 180 })
                this._box_temple_awaken.visible = false
            }

        }

        this.mainUI_model.LoginCheckPop()

        let color = (info && info.can_receive) && ColorUtil.TryParseHtmlString("#00fa64") || ColorUtil.TryParseHtmlString("#ffffff")
        this._lb_open_awaken_task_desc.color = color
    }

    public ClickAwakeFunc() {

        Util.AddClickEvent(this._box_temple_awaken, () => {
            let info = TempleAwakenModel.GetInstance().GetNowTask()
            if (!info || Util.TableSize(info) <= 0) { return }
            if (info.is_complete) {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TempleAwakenBaseView")
                return
            }
            let is_active = info.isactive
            if (is_active) {
                if (TempleAwakenModel.GetInstance().GetTaskComplete()) {
                    if (!TempleAwakenModel.GetInstance().GetFrontTaskComplete()) {
                        Message.show("请先完成任务")
                        return
                    }
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TempleAwakenBaseView")
                } else {
                    if (!TempleAwakenModel.GetInstance().GetFrontTaskComplete()) {
                        Message.show("请先完成任务")
                        return
                    }

                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TempleAwakenEnterView")
                }
            } else {
                if (info.is_lock_task) {
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TempleAwakenBaseView")
                } else {
                    Message.show(`需要等级达到${info.open_lv}方可开启觉醒之路`)
                }

            }
        }, this, false)
    }

    public UpdateCacheAs = () => {
        let cacheAs = "bitmap"

        let main_vo: MainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
        if (cacheAs == "bitmap" && main_vo && main_vo.turn < 1) {
            cacheAs = "none"
            if (!this.turn_change_id) {
                let turn_change_func = () => {
                    if (main_vo.turn >= 1) {
                        this.display_obj.cacheAs = "bitmap"
                        if (this.turn_change_id) {
                            main_vo.UnBind(this.turn_change_id)
                            this.turn_change_id = null
                        }
                    }
                }
                this.turn_change_id = main_vo.BindOne("turn", turn_change_func)
            }
        }


        if (cacheAs == "bitmap") {
            let main_line_task_item = this.main_line_item
            if (main_line_task_item && main_line_task_item.GetVisible() && main_line_task_item.has_set_effect) {
                cacheAs = "none"
            }
        }

        if (cacheAs == "bitmap") {
            if (this.task_item_list) {
                for (let item of this.task_item_list) {
                    if (item.GetVisible() && item.has_set_effect) {
                        cacheAs = "none"
                        break
                    }
                }
            }
        }
        // cacheAs = "none"
        if (this.display_obj.cacheAs != cacheAs) {
            this.display_obj.cacheAs = cacheAs
        }

    }

    createChildren() {
        if (this['GetComponents']) {
            this['GetComponents']();
            this.is_get = true;
        }
        this.story_target_name_dic = {}
        this.story_target_name_dic[StoryModel.StoryTargetName.TempleAwakenBtn] = this._box_temple_awaken
        super.createChildren()
    }


    _box_con: Laya.Box
    _box_temple_awaken: Laya.Box
    _img_temple_awaken_bg: Laya.Image
    _box_unopen_awaken: Laya.Box
    _img_unopen_awaken_icon: Laya.Image
    _img_awaken: Laya.Image
    _html_open_lv_bg: Laya.Image
    _html_open_lv: Laya.HTMLDivElement
    _box_open_awaken: Laya.Box
    _img_goods_icon: Laya.Image
    _lb_open_awaken_progress: Laya.Label
    _lb_open_awaken_task_desc_bg: Laya.Image
    _lb_open_awaken_task_desc: Laya.Label
    _img_goods_name: Laya.Image
    _img_awaken_red: Laya.Image
    _box_awaken_effect: Laya.Box
    _box_task_tab: Laya.Box
    _img_task_bg: Laya.Image
    _lb_task_desc: Laya.Label
    _lb_task_desc_en: Laya.Label
    _box_team_tab: Laya.Box
    _img_team_bg: Laya.Image
    _lb_team_desc: Laya.Label
    _lb_team_desc_en: Laya.Label
    _img_team_red: Laya.Image
    _img_team_role_count_bg: Laya.Image
    _lb_team_role_count: Laya.Label
    _box_task: Laya.Box
    _box_main_line: Laya.Box
    _panel_task: Laya.Panel
    _box_team: Laya.Box
    _list_team: Laya.List
    _box_non_team: Laya.Box
    _img_not_team_bg: Laya.Image
    _img_create_team: Laya.Image
    _lb_create_team: Laya.Label
    _img_search_team: Laya.Image
    _lb_search_team: Laya.Label
    _img_arrow: Laya.Image
    _img_arrow_icon: Laya.Image
    public GetComponents() {
        [
            this._box_con,
            this._box_temple_awaken,
            this._img_temple_awaken_bg,
            this._box_unopen_awaken,
            this._img_unopen_awaken_icon,
            this._img_awaken,
            this._html_open_lv_bg,
            this._html_open_lv,
            this._box_open_awaken,
            this._img_goods_icon,
            this._lb_open_awaken_progress,
            this._lb_open_awaken_task_desc_bg,
            this._lb_open_awaken_task_desc,
            this._img_goods_name,
            this._img_awaken_red,
            this._box_awaken_effect,
            this._box_task_tab,
            this._img_task_bg,
            this._lb_task_desc,
            this._lb_task_desc_en,
            this._box_team_tab,
            this._img_team_bg,
            this._lb_team_desc,
            this._lb_team_desc_en,
            this._img_team_red,
            this._img_team_role_count_bg,
            this._lb_team_role_count,
            this._box_task,
            this._box_main_line,
            this._panel_task,
            this._box_team,
            this._list_team,
            this._box_non_team,
            this._img_not_team_bg,
            this._img_create_team,
            this._lb_create_team,
            this._img_search_team,
            this._lb_search_team,
            this._img_arrow,
            this._img_arrow_icon,
        ]
            = this.GetChildrenByNames([

                "_box_con",
                "_box_temple_awaken",
                "_img_temple_awaken_bg",
                "_box_unopen_awaken",
                "_img_unopen_awaken_icon",
                "_img_awaken",
                "_html_open_lv_bg",
                "_html_open_lv",
                "_box_open_awaken",
                "_img_goods_icon",
                "_lb_open_awaken_progress",
                "_lb_open_awaken_task_desc_bg",
                "_lb_open_awaken_task_desc",
                "_img_goods_name",
                "_img_awaken_red",
                "_box_awaken_effect",
                "_box_task_tab",
                "_img_task_bg",
                "_lb_task_desc",
                "_lb_task_desc_en",
                "_box_team_tab",
                "_img_team_bg",
                "_lb_team_desc",
                "_lb_team_desc_en",
                "_img_team_red",
                "_img_team_role_count_bg",
                "_lb_team_role_count",
                "_box_task",
                "_box_main_line",
                "_panel_task",
                "_box_team",
                "_list_team",
                "_box_non_team",
                "_img_not_team_bg",
                "_img_create_team",
                "_lb_create_team",
                "_img_search_team",
                "_lb_search_team",
                "_img_arrow",
                "_img_arrow_icon",
            ])
        // this._lb_open_awaken_task_desc.fontSize = 2 * this._lb_open_awaken_task_desc.fontSize
        // this._lb_open_awaken_task_desc.scale(0.5, 0.5)
        // this._lb_open_awaken_task_desc.width = 2 * this._lb_open_awaken_task_desc.width
        // this._lb_open_awaken_task_desc.height = 2 * this._lb_open_awaken_task_desc.height
        this._lb_task_desc.fontSize = 2 * this._lb_task_desc.fontSize
        this._lb_task_desc.scale(0.5, 0.5)
        this._lb_task_desc_en.fontSize = 2 * this._lb_task_desc_en.fontSize
        this._lb_task_desc_en.scale(0.5, 0.5)
        this._lb_team_desc.fontSize = 2 * this._lb_team_desc.fontSize
        this._lb_team_desc.scale(0.5, 0.5)
        this._lb_team_desc_en.fontSize = 2 * this._lb_team_desc_en.fontSize
        this._lb_team_desc_en.scale(0.5, 0.5)
        this._lb_team_role_count.fontSize = 2 * this._lb_team_role_count.fontSize
        this._lb_team_role_count.scale(0.5, 0.5)
        this._lb_create_team.fontSize = 2 * this._lb_create_team.fontSize
        this._lb_create_team.scale(0.5, 0.5)
        this._lb_search_team.fontSize = 2 * this._lb_search_team.fontSize
        this._lb_search_team.scale(0.5, 0.5)
    }
}
window["MainUITaskTeamView"] = MainUITaskTeamView