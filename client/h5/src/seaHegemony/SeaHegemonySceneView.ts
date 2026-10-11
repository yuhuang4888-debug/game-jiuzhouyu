import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { table } from "../common/table"
import { MainUIModel } from "../commonModel/MainUIModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { OperateManager } from "../operation/OperateManager"
import { Scene } from "../scene/Scene"
import { MonsterType, MOVE_TYPE, SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { Mathf } from "../util/Mathf"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDeltaY, GlobalTimerQuest, SetSizeDeltaX, SetHtmlStyle, HtmlColorTxt } from "../util/Util"
import { SeaSceneTargetItem } from "./SeaSceneTargetItem"
import { SeaTargetPanel } from "./SeaTargetPanel"

export class SeaHegemonySceneView extends BaseView1 {
    AddRunner
    CancelDefTimer
    DefTimeFunc
    DesFunc
    GetRoleVoList
    InitView
    RemoveRunner
    SetTargetPanel
    ShowStartFight
    Update
    UpdateBossAutoFight
    request18617
    targetPanel: SeaTargetPanel
    curTarget
    breakTarget
    attackTarget
    defTimerId
    max_time
    setTagetPanelHid
    targetPanel_visible = false

    public constructor() {
        super()

        this.request18617 = true
        this.base_file = "seaHegemony"
        this.layout_file = "SeaHegemonySceneView"
        this.preload_server_config = { "config_seacraft_construction": false }
        this.layer_value = Enum_UILayer.Main
        this.back_login_toClose = true
        this.destroy_imm = true
        let firstAni = true
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        let local_timeUtil = TimeUtil
        let local_scene = Scene
        let scene = Scene.GetInstance()
        let roleMgr = RoleManager.GetInstance()
        let hid_activityState_ = false
        let sceneMgr = SceneManager.GetInstance()
        let local_rune = Runner.GetInstance()
        let local_mainuimodel = MainUIModel
        let local_mainui_ins = local_mainuimodel.GetInstance()
        let tween_list = []

        this.load_callback = () => {
            this.display_obj.top = Util.GetLiuhaiHeight() || 0
            MainUIManager.GetInstance().AddMoveComponent(this, this.targetGp, false, MainUIManager.MOVE_TYPE.Right)
            MainUIManager.GetInstance().AddMoveComponent(this, this.right_btn, false, MainUIManager.MOVE_TYPE.Right)
            MainUIManager.GetInstance().AddMoveComponent(this, this.leaveBtn, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this.panelGp, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this.timeGp, false, MainUIManager.MOVE_TYPE.Top)
            SetHtmlStyle(this.targetLb, { f: 20, c: "#fbfbfb", ww: false, w: 190 })

            this.InitView()
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18610, "c", 0)
            
        }

        this.destroy_callback = () => {
            this.DesFunc()

            if (tween_list) {
                for (let _ in tween_list) {
                    var tween_id = tween_list[_]
                    SYTweenLite.Stop(tween_id)
                }
                tween_list = []
            }
        }

        this.open_callback = () => {
            if (this.request18617) {
                local_modelIns.Fire(local_model.REQUEST_PROTO, 18617)
                this.request18617 = false
            }
        }

        this.ShowStartFight = () => {
            local_modelIns.Fire(local_model.OPEN_VIEW, "SeaFightChangeView", (firstAni && (1) || (2)))
            if (firstAni) {
                firstAni = false
            }
        }

        this.InitView = () => {
            this.BindEvent(
                local_modelIns,
                local_model.UPDATE_MONSTER, () => {
                    this.SetTargetPanel()
                }
            )

            Util.AddClickEvent(
                this.ruleBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "SeaFightInstructionView",0)
                },
                this,
                true
            )

            Util.AddClickEvent(
                this.shipBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "SeaShipChangeView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.rewardBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "SeaReawrdPreView", local_modelIns.actType)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.totalBtn, () => {
                    local_modelIns.Fire(local_model.OPEN_VIEW, "SeaFightTotalView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.leaveBtn, () => {
                    let ok_func = () => {
                        local_modelIns.Fire(local_model.REQUEST_PROTO, 18614)
                    }

                    let str1=SeaHegemonyModel.GetInstance().actType==1?"海王争夺":"海域霸主"
                    let str = `确定要离开${str1}活动场景么？`
                    Alert.Show(str, Alert_Type.Two, ok_func, null, "确定", "取消")
                },
                this,
                true
            )
            this.BindEvent(
                GlobalEventSystem,
                EventName.SHOWRELIVEWINDOW, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18609)
                }
            )
            this.BindEvent(
                local_modelIns,
                local_model.ATTACK_DEF_DATA, () => {
                    //攻守方信息
                    this.ShowStartFight()
                    this.SetTargetPanel()
                }
            )

            this.BindEvent(GlobalEventSystem, EventName.SCENELOADVIEWE_CLOSE, () => {
                // loading_finished = true
                // if (need_show_start_fight) {
                //     this.ShowStartFight()
                //     loading_finished=false
                //     need_show_start_fight = false
                // }
            })

            this.BindEvent(
                GlobalEventSystem,
                NineSkyModel.NINE_SKY_FIGHTING_MSG, (attack_role_id?) => {
                    //SecretBossModel:GetInstance():setSufferedList(attack_role_id)
                }
            )
            this.BindEvent(
                GlobalEventSystem,
                EventName.BROADCAST_COLLECT_RESULT, (flag?) => {
                    if (flag == 25) {
                        AutoFightManager.GetInstance().SetAutoFight(false)
                    }
                }
            )
            this.BindEvent(
                GlobalEventSystem,
                SceneEventType.SCENE_CHANGED, () => {
                    local_modelIns.Fire(local_model.REQUEST_PROTO, 18617)
                }
            )
            let local_mainuimodel = MainUIModel
            local_mainui_ins.Fire(local_mainuimodel.CHANGE_ACTIVITY_STATE, false)
            if (!this.targetPanel) {
                this.targetPanel = new SeaTargetPanel(this.targetGp)
                this.targetPanel.Load()
            }
            this.AddRunner()
            this.SetTargetPanel()
            GlobalEventSystem.Fire(EventName.HIDE_GOD_ICON)
            setTimeout(() => {
                local_modelIns.Fire(local_model.REQUEST_PROTO, 18609)
            },
                2)
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18609)
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18607)


            let main_role
            var onMainRoleMoveHandler = (mx?, my?) => {
                let door_list = Scene.GetInstance().door_list;
                if (!main_role) {
                    main_role = Scene.GetInstance().main_role
                }
                if (!Util.IsTableEmpty(door_list) && main_role) {
                    //当前的起始坐标和终点坐标，必须用RealPos计算才能准确
                    let x1 = main_role.real_pos.x
                    let y1 = main_role.real_pos.y
                    for (let key in door_list) {
                        let door = door_list[key];
                        let x2 = door.x, y2 = door.y, distance = GameMath.GetDistance(x1, y1, x2, y2, false);
                        if (distance < 5000) {
                            let doorVo = door.GetVo();
                            if (doorVo) {
                                GlobalEventSystem.Fire(SceneEventType.MOVEREQUEST, doorVo.t_scene_x, doorVo.t_scene_y, MOVE_TYPE.DOOR_JUMP, doorVo.t_scene_x, doorVo.t_scene_y);
                                main_role.SetRealPos(doorVo.t_scene_x, doorVo.t_scene_y);
                                main_role.DoStand();
                                break;
                            }
                        }
                    }
                }
            }
            onMainRoleMoveHandler()
            this.BindEvent(GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_EVENT, onMainRoleMoveHandler)
        }

        this.SetTargetPanel = () => {
            let type = local_modelIns.fightType
            if (type == 0) {
                this.defGp.visible = true
                this.attackGp.visible = false
                let height = 331
                if (!this.curTarget) {
                    this.curTarget = new SeaSceneTargetItem(this.gp1)
                    this.curTarget.SetIndex(1)
                    this.curTarget.Load()
                }
                this.curTarget.SetData()
                if (!this.breakTarget) {
                    this.breakTarget = new SeaSceneTargetItem(this.gp2)
                    this.breakTarget.SetIndex(2)
                    this.breakTarget.Load()
                }
                if (local_modelIns.fightBeforeId) {
                    this.breakTarget.SetVisible(true)
                } else {
                    this.breakTarget.SetVisible(false)
                    height = 231
                }
                SetSizeDeltaY(this.bg1, height)
                this.breakTarget.SetData()
                this.targetLb.innerHTML = `目标：${HtmlColorTxt("守卫城堡", "'#fff1b9'")}`
            } else {
                this.defGp.visible = false
                this.attackGp.visible = true
                SetSizeDeltaY(this.bg1, 231)
                if (!this.attackTarget) {
                    this.attackTarget = new SeaSceneTargetItem(this.gp3)
                    this.attackTarget.SetIndex(3)
                    this.attackTarget.Load()
                }
                this.attackTarget.SetData()
                this.targetLb.innerHTML = `目标：${HtmlColorTxt("摧毁城堡", "'#fff1b9'")}`
            }
            this.CancelDefTimer()
            if (local_modelIns.StartInfo.end_time) {
                this.max_time = local_modelIns.StartInfo.end_time - local_modelIns.StartInfo.start_time
            }
            this.defTimerId = GlobalTimerQuest.AddPeriodQuest(() => {
                this.DefTimeFunc()
            }, 1)
        }

        this.DefTimeFunc = () => {
            if (this.timeLb1 && local_modelIns.StartInfo.end_time) {
                let time = local_modelIns.StartInfo.end_time - TimeUtil.getServerTime()
                let timeStr = local_timeUtil.convertTime(time)
                this.timeLb.text = `倒计时：${timeStr}`
                this.timeLb1.text = "剩余时间:" + timeStr
                //this.timeImg.width = Mathf.Min(1, 1200 - time / 1200) * 178
                SetSizeDeltaX(this.timeImg, Mathf.Min(1, time / (this.max_time || 1200)) * 185)
                if (time < 0) {
                    this.CancelDefTimer()
                }
            }
        }

        this.CancelDefTimer = () => {
            if (this.defTimerId) {
                GlobalTimerQuest.CancelQuest(this.defTimerId)
                this.defTimerId = null
            }
        }

        this.UpdateBossAutoFight = () => {
            let obj_vo_list = []
            let monster_list =scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, 800, null, null, null)[0]
            if (monster_list&& Util.TableSize(monster_list) > 0) {
                for (let key in monster_list) {
                    let monster = monster_list[key]
                    if (monster) {
                        let Vo = monster.GetVo()

                        //防守方 如果塔没有毁坏，不显示在攻击列表上
                        if (local_modelIns.fightType == 0) {
                            if (Vo && Vo.type == MonsterType.COLLECT) {
                                table.insert(obj_vo_list, Vo)
                            }
                        } else {
                            if (Vo && Vo.type != MonsterType.COLLECT) {
                                table.insert(obj_vo_list, Vo)
                            }
                        }

                    }
                }
            }

            let role_vo_list = this.GetRoleVoList()
            obj_vo_list = obj_vo_list.concat(role_vo_list)//table.merge(obj_vo_list, role_vo_list)

            if (obj_vo_list.length > 0) {
                if (!hid_activityState_ && local_mainui_ins.activity_icon_in_show) {
                    local_mainui_ins.Fire(local_mainuimodel.CHANGE_ACTIVITY_STATE, false)
                }
                this.targetPanel.setData(obj_vo_list)
                hid_activityState_ = true
                this.setTagetPanelHid(true)

             

                let cur_target =Scene.GetInstance().GetClickTarget()
                if(!cur_target){

                    let temp_vo = obj_vo_list[0]
                    let target = null
                    if (temp_vo.vo_type == SceneBaseType.Role) {
                        target = scene.GetRole(temp_vo.role_id)
                    } else if (temp_vo.vo_type == SceneBaseType.Monster) {
                        target = scene.GetMonsterByTypeId(temp_vo.id)
                    }


                    if ((AutoFightManager.GetInstance().GetAutoFightState() || cur_select_target == null) && cur_select_target != target) {
                        scene.MainRoleAttackMonster(target)
                        scene.SetClickTarget(target)
                        cur_select_target = target
                    }
                }
               

            } else {
                hid_activityState_ = false
                this.setTagetPanelHid(false)

                if (AutoFightManager.GetInstance().GetAutoFightState()) {
                    scene.MainRoleAttackMonster(null)
                    scene.SetClickTarget(null)
                    cur_select_target = null
                }

            }
        }
        let cur_select_target = null

        this.GetRoleVoList = () => {
            let main_role_vo = roleMgr.GetMainRoleVo()
            let main_role_id = roleMgr.GetMainRoleId()
            let list = []
            let role_vo_list = sceneMgr.GetAllRoleVos()
            let warGroup = main_role_vo.warGroup
            if (main_role_vo.boss_flag == 1) {
                table.insert(list, main_role_vo)
            }
            let canattack = []
            let difattack = []
            for (let role_id in role_vo_list) {

                // [ts2lua]role_vo_list下标访问可能不正确
                let role_vo = role_vo_list[role_id]
                if (role_vo.hp == 0 && role_vo.boss_flag != 1) {
                    break
                }
                if (role_id != String(main_role_id)) {
                    let bool1 = sceneMgr.IsCanAttackByMainRole(role_vo)
                    let bool2 = local_modelIns.CanAttackRole(role_vo)
                    if (bool1 && bool2) {
                        table.insert(canattack, role_vo)
                    }
                    else if (bool1 || bool2) {
                        table.insert(difattack, role_vo)
                    } else {
                        table.insert(list, role_vo)
                    }
                }
            }
            return canattack.concat(difattack).concat(list)//table.merge(canattack, table.merge(difattack, list))
        }

        let update_id_ = null
        let update_times_index_ = 0
        this.Update = (now_time?, elapse_time?) => {
            update_times_index_ = update_times_index_ + 1
            if (update_times_index_ % 20 == 0) {
                this.UpdateBossAutoFight()
            }
        }

        this.AddRunner = () => {
            if (!update_id_) {
                update_id_ = local_rune.AddRunObj(this)
            }
        }

        this.RemoveRunner = () => {
            if (update_id_) {
                local_rune.RemoveRunObj(update_id_)
                update_id_ = null
            }
        }

        this.setTagetPanelHid = (bool?) => {
            if (this.targetPanel && this.targetPanel_visible != bool) {
                this.targetPanel.SetVisible(bool)
                this.targetPanel_visible = bool
            }
        }

        this.DesFunc = () => {
            this.RemoveRunner()
            this.CancelDefTimer()
            firstAni = true
            this.request18617 = true


            if (this.curTarget) {
                this.curTarget.DeleteMe()
                this.curTarget = null
            }
            if (this.breakTarget) {
                this.breakTarget.DeleteMe()
                this.breakTarget = null
            }
            if (this.attackTarget) {
                this.attackTarget.DeleteMe()
                this.attackTarget = null
            }
            if (this.targetPanel) {
                this.targetPanel.DeleteMe()
                this.targetPanel = null
            }

        }
    }


targetGp:Laya.Box
leaveBtn:Laya.Image
right_btn:Laya.Box
shipBtn:Laya.Image
rewardBtn:Laya.Image
totalBtn:Laya.Image
ruleBtn:Laya.Image
timeGp:Laya.Box
_Image2:Laya.Image
timeLb:Laya.Label
panelGp:Laya.Box
bg1:Laya.Image
bg2:Laya.Image
targetLb:Laya.HTMLDivElement
defGp:Laya.Box
lb1:Laya.Label
_Image3:Laya.Image
timeImg:Laya.Image
timeLb1:Laya.Label
gp1:Laya.Box
gp2:Laya.Box
attackGp:Laya.Box
lb2:Laya.Label
gp3:Laya.Box
public GetComponents() {
[
this.targetGp,
this.leaveBtn,
this.right_btn,
this.shipBtn,
this.rewardBtn,
this.totalBtn,
this.ruleBtn,
this.timeGp,
this._Image2,
this.timeLb,
this.panelGp,
this.bg1,
this.bg2,
this.targetLb,
this.defGp,
this.lb1,
this._Image3,
this.timeImg,
this.timeLb1,
this.gp1,
this.gp2,
this.attackGp,
this.lb2,
this.gp3,
]
 = this.GetChildrenByNames([

"targetGp",
"leaveBtn",
"right_btn",
"shipBtn",
"rewardBtn",
"totalBtn",
"ruleBtn",
"timeGp",
"_Image2",
"timeLb",
"panelGp",
"bg1",
"bg2",
"targetLb",
"defGp",
"lb1",
"_Image3",
"timeImg",
"timeLb1",
"gp1",
"gp2",
"attackGp",
"lb2",
"gp3",
])
}
}
 window["SeaHegemonySceneView"]= SeaHegemonySceneView