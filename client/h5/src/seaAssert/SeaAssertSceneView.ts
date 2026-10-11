import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName, SceneEventType } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { MainUIController } from "../commonController/MainUIController"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { OperateManager } from "../operation/OperateManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameMath } from "../util/GameMath"
import { Mathf } from "../util/Mathf"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, Trim, Util } from "../util/Util"
import { SeaAssertSBossItem } from "./SeaAssertSBossItem"
import { SeaAssertSSkill } from "./SeaAssertSSkill"
import { SeaAssertTargetPanel } from "./SeaAssertTargetPanel"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"
import { Vector2 } from "../util/Vector2"
import { MainUIManager } from "../common/MainUIManager"

export class SeaAssertSceneView extends BaseView1 {
    CancelTimer
    Emp_gp_exit
    Emp_gp_introduc
    Emp_gp_open
    Emp_gp_right
    FindNPC
    FindWay
    GetRoleVoList
    InitEvent
    Scr_Scroller1
    SetAutoFightBtn
    Update
    UpdateBossAutoFight
    UpdateView
    close_callback
    destroy_imm
    lb_rank_child
    open_callback
    preload_server_config
    removeUpdate
    setTagetPanelHid
    updateBoss
    updatePanel
    updateSkill

    private _taget_panel: SeaAssertTargetPanel;

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertSceneView"
        this.layer_value = Enum_UILayer.Main
        this.destroy_imm = true
        this.back_login_toClose = true;

        let _model: SeaHegemonyModel = SeaHegemonyModel.GetInstance()
        let mainUI_model = MainUIModel.GetInstance()
        let local_MainUIModel = MainUIModel
        let local_GlobalEventSystem = GlobalEventSystem
        let runner = Runner.GetInstance()
        let update_id = null
        let ac_boss: LoopScrowViewMgr = null

        let skill_list = []
        let tween_list = []
        let scene = Scene.GetInstance()
        let local_scene = Scene
        let sceneMgr = SceneManager.GetInstance()

        let role_mgr = RoleManager.GetInstance()
        let local_GameMath = GameMath
        let last_time = 0
        let auto_fight_mgr = AutoFightManager.GetInstance()

        let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
        let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y
        let mainUI_controller = MainUIController.GetInstance()
        let local_SceneManager_Instance = SceneManager.GetInstance()
        let lcoal_EventName = EventName

        let left_init_x, left_init_width
        let right_init_x, right_init_width
        let panel_init_x, panel_init_width
        let introduc_init_x
        //let skill_init_y, skill_init_width
        let skill_canvas_group
        let update_times_index_ = 0
        let hid_activityState_: boolean = false;


        this.preload_server_config = {
            config_sea_craft_daily_kv: false,
            config_seacraft_camp: false,
            config_sea_craft_daily_building: false
        }

        this.load_callback = () => {


            // this.form.pivot = Vector2(0.5, 0.5)
            // this.form.anchorMin = Vector2(0, 0)
            // this.form.anchorMax = Vector2(1, 1)
            // this.form.anchoredPosition = Vector2(0, 0)
            // this.form.sizeDelta = Vector2(0, 0)


            left_init_x = this._left_btn.x
            right_init_x = this._gp_right.x
            introduc_init_x = this._gp_introduc.x
            panel_init_x = this._gp_panel.x
            //skill_init_y = this._gp_skill.anchoredPosition.y

            left_init_width = GetSizeDeltaX(this._left_btn) + 20;
            right_init_width = GetSizeDeltaX(this._gp_right) + 20;
            panel_init_width = GetSizeDeltaX(this._gp_panel) + 30;



            // skill_canvas_group = this._gp_skill.GetComponent("CanvasGroup")

            this.InitEvent()

            MainUIManager.GetInstance().AddMoveComponent(this, this._target_gp, false, MainUIManager.MOVE_TYPE.Stay)
            if (!this._taget_panel) {
                this._taget_panel = new SeaAssertTargetPanel(this._target_gp)
                this._taget_panel.Load()
            }
        }

        this.SetAutoFightBtn = () => {
            let auto = false
            if ((local_SceneManager_Instance.IsSeaAsserScene() && scene.main_role) && scene.main_role.vo.brick_id > 0) {
                auto = _model.assertAutoFind
            } else {
                // auto = _model.GetAutoFightState()
            }
            let sp_name = auto ? "uizjmgj_001b" : "uizjmgj_003a"
            ResManager.GetInstance().SetImageSpriteTrans(this, this._auto_fight, GameResPath.GetIcon("mainUI", sp_name))
        }

        this.FindWay = () => {
            if (local_SceneManager_Instance.IsSeaAsserScene() && scene.main_role.vo.brick_id > 0) {
                _model.AssertFindWay(!_model.assertAutoFind)
                this.SetAutoFightBtn()
            }
        }

        this.FindNPC = () => {
            if (scene.main_role.vo.brick_id > 0) {
                this.FindWay()
                return
            }

            let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
            // [ts2lua]kv_cfg下标访问可能不正确
            let pos_cfg = kv_cfg["task_start_pos"].value
            let pos_list = JSON.parse(pos_cfg);
            let pos = new Vector2(pos_list[0] / LogicRealRatio_X, pos_list[1] / LogicRealRatio_Y);
            scene.MainRoleMove(
                pos,
                0, () => {
                    _model.OpenTaskView()
                }
            )
        }


        this.InitEvent = () => {
            Util.AddClickEvent(
                this._auto_fight, () => {
                    this.FindWay()
                },
                this,
                true
            )

            Util.AddClickEvent(
                this._gp_exit, () => {
                    _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18708)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._gp_open, () => {
                    OpenFun.OpenFunHandler(201)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._gp_introduc, () => {
                    local_GlobalEventSystem.Fire(lcoal_EventName.OPEN_INSTRUCTION_VIEW, InstructionType.SeaAssert)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._lb_rank, () => {
                    _model.Fire(SeaHegemonyModel.OPEN_VIEW, "SeaAssertRankView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._img_go, () => {
                    auto_fight_mgr.SetAutoFight(false)
                    this.FindNPC()
                    //local_laya.Tween.removeTweens(this._img_go)
                    //this._img_go.rotation = 0
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._img_down, () => {
                    _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18706)
                },
                this
            )
            this.BindEvent(
                mainUI_model,
                local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
                    this.CancelTimer()
                    if (bool) {
                        let tween_id = SYTweenLite.to(this, this._left_btn, SYTweenLite.UiAnimationType.ANCHORED_POSX, left_init_x - left_init_width, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_right, SYTweenLite.UiAnimationType.ANCHORED_POSX, right_init_x + right_init_width, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_introduc, SYTweenLite.UiAnimationType.ANCHORED_POSX, introduc_init_x - left_init_width, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_panel, SYTweenLite.UiAnimationType.ANCHORED_POSX, panel_init_x - panel_init_width, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_skill, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        // tween_id = SYTweenLite.to(this, this.skill_canvas_group, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval)
                        // table.insert(tween_list, tween_id)

                        //tween_id = SYTweenLite.to(this, this._gp_skill, SYTweenLite.UiAnimationType.ANCHORED_POSY, skill_init_y - 500, local_MainUIModel.Move_Time_Interval)
                        //table.insert(tween_list, tween_id)
                    } else {
                        let tween_id = SYTweenLite.to(this, this._left_btn, SYTweenLite.UiAnimationType.ANCHORED_POSX, left_init_x, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_right, SYTweenLite.UiAnimationType.ANCHORED_POSX, right_init_x, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_introduc, SYTweenLite.UiAnimationType.ANCHORED_POSX, introduc_init_x, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_panel, SYTweenLite.UiAnimationType.ANCHORED_POSX, panel_init_x, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        tween_id = SYTweenLite.to(this, this._gp_skill, SYTweenLite.UiAnimationType.ALPHA, 1, local_MainUIModel.Move_Time_Interval)
                        table.insert(tween_list, tween_id)

                        // tween_id = SYTweenLite.to(this, skill_canvas_group, SYTweenLite.UiAnimationType.ALPHA, 1, local_MainUIModel.Move_Time_Interval)
                        // table.insert(tween_list, tween_id)

                        //tween_id = SYTweenLite.to(this, this._gp_skill, SYTweenLite.UiAnimationType.ANCHORED_POSY, skill_init_y, local_MainUIModel.Move_Time_Interval)
                        //table.insert(tween_list, tween_id)
                    }
                }
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_SCENE_DATA, () => {
                    if (!this.is_loaded) {
                        return;
                    }
                    this.updatePanel()
                    this.updateBoss()
                }
            )

            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_BRICK_DOWN, () => {
                    OperateManager.Instance.StopMove()
                }
            )

            this.BindEvent(
                _model,
                SeaHegemonyModel.MOVE_TO_NPC, (npc_id?) => {
                    if (npc_id == 500001) {
                        this.FindWay()
                    }
                    else if (npc_id == 500002) {
                        this.FindNPC()
                    }
                }
            )

            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_BRICK_ID_CHANGE, () => {
                    if (scene.main_role.vo.brick_id > 0) {
                        auto_fight_mgr.SetAutoFight(false)
                        this._gp_skill.visible = true
                        this._target_gp.visible = false
                        //this._gp_right.visible = true 
                        _model.AssertFindWay(true)
                        mainUI_controller.SetMainUIViewVisible(14, false)
                    } else {
                        _model.AssertFindWay(false)
                        this._gp_skill.visible = false
                        //this._gp_right.visible = false 
                        this._target_gp.visible = true
                        mainUI_controller.SetMainUIViewVisible(14, true)
                    }
                }
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_BRICK_FINISH, () => {
                    if (!this.is_loaded) {
                        return;
                    }
                    this._gp_skill.visible = false
                    this.updatePanel()
                }
            )
            
            this.BindEvent(
                GlobalEventSystem,
                lcoal_EventName.FINDWAY_ENDED, () => {
                    _model.assertAutoFind = false,
                    _model.Fire(SeaHegemonyModel.ASSERT_FIND_WAY)
                    this.SetAutoFightBtn()
                }
            )

            this.BindVar(SceneManager.GetInstance(),"curr_joystick_dir", () => {
                    _model.assertAutoFind = false,
                    _model.Fire(SeaHegemonyModel.ASSERT_FIND_WAY)
                    this.SetAutoFightBtn()
                }
            )


            this.BindEvent(
                local_GlobalEventSystem,
                SceneEventType.SCENE_REENTER, () => {
                    if (!this.is_loaded) {
                        return;
                    }
                    this.UpdateView()
                    this.updatePanel()
                    this.updateBoss()
                }
            )
        }

        this.open_callback = () => {
            this.UpdateView()
        }

        this.UpdateView = () => {

            if (scene.main_role && scene.main_role.vo.brick_id > 0) {
                mainUI_controller.SetMainUIViewVisible(14, false);
            }
            _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18703)
            _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18701)
            this._lb_rank.text = Util.StrToHTML("贡献排名")

            if (!this.lb_rank_child) {
                // let child = AddUnderlineText(this._lb_rank, this._lb_rank, "#00ff00", 6, 8, null, false, 7)
                // if (child) {
                //     this.lb_rank_child = child
                //     let fitter = child.gameObject.AddComponent(typeof (UnityEngine.UI.ContentSizeFitter))
                //     fitter.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize
                //     fitter.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize
                // }
            }

            this.removeUpdate()
            this.updateSkill()
            if (!update_id) {
                update_id = runner.AddRunObj(this)
            }
            this._gp_skill.visible = scene.main_role && scene.main_role.vo.brick_id > 0
            if (scene.main_role && scene.main_role.vo.brick_id > 0) {
                auto_fight_mgr.SetAutoFight(false)
            }
            _model.assertSendTask = 0
        }

        this.CancelTimer = () => {
            if (tween_list) {
                for (let _ in tween_list) {
                    var tween_id = tween_list[_]
                    SYTweenLite.Stop(tween_id)
                }
                tween_list = []
            }
        }

        this.close_callback = () => {
            mainUI_controller.SetMainUIViewVisible(14, true)
            this.CancelTimer()
            this.removeUpdate()
            //if (this._list_boss ) {
            //    this._list_boss.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.bossTouch, this)
            //}
            if (ac_boss) {
                ac_boss.DeleteMe()
                ac_boss = null
            }
            for (let key in skill_list) {

                // [ts2lua]skill_list下标访问可能不正确
                let skill_item = skill_list[key]
                skill_item.DeleteMe()
            }
            skill_list = []

            if (this._taget_panel) {
                this._taget_panel.DeleteMe()
                this._taget_panel = null
            }
            this.lb_rank_child = null
        }

        update_times_index_ = 0
        this.Update = (now_time?, elapse_time?) => {
            if (now_time - last_time > 0.5) {
                last_time = now_time
                let main_role = scene.main_role
                if (((main_role && main_role.vo) && main_role.vo.brick_id != 0) && !_model.assertTaskViewOpen) {
                    let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
                    // [ts2lua]kv_cfg下标访问可能不正确
                    let end_pos_cfg = kv_cfg["task_end_pos"].value
                    let end_pos = JSON.parse(end_pos_cfg);
                    // [ts2lua]kv_cfg下标访问可能不正确
                    let end_pos_range = Number(kv_cfg["task_end_range"].value)
                    let real_pos = main_role.real_pos
                    let distance = local_GameMath.GetDistance(real_pos.x, real_pos.y, end_pos[0], end_pos[1])
                    if (distance <= end_pos_range * end_pos_range) {
                        // [ts2lua]kv_cfg下标访问可能不正确
                        let max = kv_cfg["defend_count"].value
                        let data = _model.assertSceneData
                        let severTime = TimeUtil.getServerTimeMs()
                        if (severTime - _model.assertSendTask > 800 && data) {
                            _model.assertSendTask = severTime
                            _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18709, "c", _model.assertSceneData.sea_id)
                        }
                    }
                }
            }

            update_times_index_ = update_times_index_ + 1
            if (update_times_index_ % 20 == 0) {
                this.UpdateBossAutoFight()
            }
        }

        this.removeUpdate = () => {
            if (update_id) {
                runner.RemoveRunObj(update_id)
                update_id = null
            }
        }

        this.updatePanel = () => {
            let data = _model.assertSceneData
            if (!data) {
                return
            }
            let name_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_camp", false)
            // [ts2lua]name_cfg下标访问可能不正确
            let cfg = name_cfg[data.sea_id];
            this._lb_name2.text = _model.seaHegemonyData?.camp == data.sea_id ? cfg.name + '【己方】' : cfg.name;
            let brick_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_building", false)
            let brick_info = _model.getBrickCfg(brick_cfg, data.brick_num)
            let state = _model.getBrickState(brick_info.status)
            this._lb_name.text = Trim(cfg.name) + state
            this._lb_num.text = data.brick_num
            let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
            // [ts2lua]kv_cfg下标访问可能不正确
            let max = kv_cfg["carry_brick_count"].value
            // [ts2lua]lua中0和空字符串也是true，此处data.carry_count >= max需要确认
            let color = (data.carry_count >= max ? '#FE1A1A' : ("#0A953E"))
            this._lb_work_time.text = Mathf.Max(max - data.carry_count, 0) + "/" + max;
            this._lb_work_time.color = color;
            // [ts2lua]kv_cfg下标访问可能不正确
            max = kv_cfg["defend_count"].value;
            // [ts2lua]lua中0和空字符串也是true，此处data.defend_count >= max需要确认
            color = (data.defend_count >= max ? '#FE1A1A' : ("#0A953E"))
            this._lb_boss_time.text = Mathf.Max(max - data.defend_count, 0) + "/" + max;
            this._lb_boss_time.color = color;
            //if ((data.sea_id != _model.seaHegemonyData.camp && data.carry_count < max) && scene.main_role.vo.brick_id <= 0 ) {
            //local_laya.Tween.get(this._img_go, {loop = true}):to({rotation = -10}, 100):to({rotation = 10}, 300):to({rotation = 0}, 100).wait(900)
            //}
        }

        this.updateBoss = () => {
            if (!_model.assertSceneData) {
                return
            }
            let data = _model.assertSceneData.boss_list
            if (!ac_boss) {
                // this._list_boss.dataProvider = ac_boss
                // this._list_boss.itemRenderer = SeaAssertSBossItem
                // this._list_boss.selectedIndex = 0
                // this._list_boss.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.bossTouch, this)
                ac_boss = new LoopScrowViewMgr(this.layer_value)
                ac_boss.SetData(this._Scroller1, SeaAssertSBossItem, data, LoopScrCon.Vertical, 1, (item: SeaAssertSBossItem) => {
                    if (item && item.Selected) {
                        item.Selected()
                    }
                })
            } else {
                ac_boss.replaceAll(data)
            }
        }

        this.updateSkill = () => {
            let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
            // [ts2lua]kv_cfg下标访问可能不正确
            let skill_cfg = kv_cfg["skill_ids"]
            let list = JSON.parse(skill_cfg.value)

            for (let i = 0; i < list.length; i++) {
                const element = list[i];
                let skillId = list[i]
                let skill_item = skill_list[i]
                if (!skill_item) {
                    skill_item = new SeaAssertSSkill(this._gp_skill)
                    skill_item.Load()
                    table.insert(skill_list, skill_item)
                }
                skill_item.setData(Number(skillId))
            }

        }

        this.UpdateBossAutoFight = () => {
            let obj_vo_list = []
            let local_cfg = Config
            let find_count = 1;
            let mon_list = scene.FindTargets(local_scene.FIND_TARGET_TYPE.monster, find_count, null, 500, null, null, null)[0]
            let roleGp = role_mgr.GetMainRoleVo().warGroup
            for (let key in local_scene.GetInstance().monster_list) {

                // [ts2lua]local_scene:GetInstance().monster_list下标访问可能不正确
                let monster = local_scene.GetInstance().monster_list[key]
                if (monster) {
                    let Vo = monster.vo;
                    if (Vo.warGroup == roleGp && roleGp > 0) {
                        table.insert(obj_vo_list, monster)
                    }
                }
            }
            let role_vo_list = this.GetRoleVoList()
            if (mon_list && mon_list.length > 0) {
                obj_vo_list = obj_vo_list.concat(mon_list);
            }
            obj_vo_list = obj_vo_list.concat(role_vo_list)
            if (obj_vo_list.length > 0) {
                if (!hid_activityState_ && mainUI_model.activity_icon_in_show) {
                    mainUI_model.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
                }
                let boss = mon_list[0]
                if (boss && !mainUI_model.big_blood_in_show) {
                    let config = local_cfg.GetConfigVo(local_cfg.ConfigHasDefaultValue.config_mon.name, boss.vo.type_id, false)
                    let realPos = boss.GetRealPos()
                    let mainRealPos = scene.main_role.GetRealPos()
                    let distance = GameMath.GetDistance(mainRealPos.x, mainRealPos.y, realPos.x, realPos.y)
                    if (config) {
                        let bossDistance = config.tracing_distance + 150;
                        if (distance <= bossDistance * bossDistance) {
                            local_GlobalEventSystem.Fire(lcoal_EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, boss.vo, config.hp_num)
                        }
                    }
                }
                if (this._taget_panel) {
                    this._taget_panel.setData(obj_vo_list)
                }
                hid_activityState_ = true
                this.setTagetPanelHid(true)
            } else {
                hid_activityState_ = false
                this.setTagetPanelHid(false)
            }
        }

        this.setTagetPanelHid = (bool?) => {
            if (this._taget_panel) {
                this._taget_panel.SetVisible(bool)
            }
        }

        this.GetRoleVoList = () => {
            let main_role_vo = role_mgr.GetMainRoleVo()
            let main_role_id = role_mgr.GetMainRoleId()
            let list = []
            let role_vo_list = sceneMgr.GetAllRoleVos()
            if (main_role_vo.boss_flag == 1) {
                table.insert(list, main_role_vo)
            }
            for (let role_id in role_vo_list) {

                // [ts2lua]role_vo_list下标访问可能不正确
                let role_vo = role_vo_list[role_id]

                //if (role_vo.hp == 0 && role_vo.boss_flag != 1 ) {
                //    break
                //}
                //if (role_id != String(main_role_id) ) {
                //    table.insert(list, role_vo)
                //}

                if (!(role_vo.hp == 0 && role_vo.boss_flag != 1)) {
                    if (role_id != String(main_role_id)) {
                        table.insert(list, role_vo)
                    }
                }
            }
            return list
        }

    }

    public DeleteMe() {
        super.DeleteMe();
    }

    _gp_skill: Laya.HBox
    _img_down: Laya.Image
    _gp_panel: Laya.Box
    _Image3: Laya.Image
    _lb_rank: Laya.Label
    _lb_name2: Laya.Label
    _Label1: Laya.Label
    _Label2: Laya.Label
    _lb_work_time: Laya.Label
    _lb_boss_time: Laya.Label
    _img_go: Laya.Image
    _lb_name: Laya.Label
    _Label3: Laya.Label
    _lb_num: Laya.Label
    _Scroller1: Laya.List
    _gp_introduc: Laya.Box
    _Image1: Laya.Image
    _left_btn: Laya.Box
    _gp_exit: Laya.Box
    _exit: Laya.Image
    _gp_open: Laya.Box
    _Image2: Laya.Image
    _gp_right: Laya.Box
    _auto_fight: Laya.Image
    _target_gp: Laya.Box
    public GetComponents() {
        [
            this._gp_skill,
            this._img_down,
            this._gp_panel,
            this._Image3,
            this._lb_rank,
            this._lb_name2,
            this._Label1,
            this._Label2,
            this._lb_work_time,
            this._lb_boss_time,
            this._img_go,
            this._lb_name,
            this._Label3,
            this._lb_num,
            this._Scroller1,
            this._gp_introduc,
            this._Image1,
            this._left_btn,
            this._gp_exit,
            this._exit,
            this._gp_open,
            this._Image2,
            this._gp_right,
            this._auto_fight,
            this._target_gp,
        ]
            = this.GetChildrenByNames([

                "_gp_skill",
                "_img_down",
                "_gp_panel",
                "_Image3",
                "_lb_rank",
                "_lb_name2",
                "_Label1",
                "_Label2",
                "_lb_work_time",
                "_lb_boss_time",
                "_img_go",
                "_lb_name",
                "_Label3",
                "_lb_num",
                "_Scroller1",
                "_gp_introduc",
                "_Image1",
                "_left_btn",
                "_gp_exit",
                "_exit",
                "_gp_open",
                "_Image2",
                "_gp_right",
                "_auto_fight",
                "_target_gp",
            ])
    }
}
window["SeaAssertSceneView"] = SeaAssertSceneView