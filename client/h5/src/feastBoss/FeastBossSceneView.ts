import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { BossModel } from "../commonModel/BossModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class FeastBossSceneView extends BaseView1 {
    _exit: Laya.Image
    crystal_conta: Laya.Box
    _Image1: Laya.Image
    progressBar: Laya.Box
    hp_img: Laya.Image
    end_time_conta: Laya.HBox
    _Image2: Laya.Image
    end_time: Laya.Label
    _Image3: Laya.Image
    time_conta: Laya.Box
    _Image4: Laya.Image
    left_time: Laya.HTMLDivElement
    next_boss_show: Laya.Box
    _Image5: Laya.Image
    next_boss_time: Laya.Label
    _Image6: Laya.Image
    CancelClearBoxListTimer
    CancelCountTime
    CancelNextWaveCountTime
    CancelQuitTimer
    Empcrystal_conta
    FindWayToCrystal
    InitEvent
    LoadSuccess
    OnClearBoxListTime
    OnNextWaveTime
    OnQuitTime
    OnTime
    Remove
    SetCrystalMonster
    SetView
    StartClearBoxListTimer
    StartCountTime
    StartNextWaveTime
    StartQuitTimer
    Update
    _end_time
    back_login_toClose
    box_list
    change_scene_close
    clear_box_list_time_id
    close_callback
    complete_collect_id
    count_time_id
    crystal_hp_id
    crystal_mon_id
    crystal_monster_vo
    crystal_pos
    end_time_conta_cache
    model
    next_boss_show_cache
    next_wave_end_time
    next_wave_time
    next_wave_time_id
    quit_time
    quit_time_id
    time_conta_cache
    update_id

    public constructor() {
        super()

        this._end_time = 0
        this.quit_time = 0
        this.next_wave_time = 0
        this.box_list = []
        this.base_file = "feastBoss"
        this.layout_file = "FeastBossSceneView"
        this.layer_value = Enum_UILayer.Main
        this.destroy_imm = true
        this.is_center = true
        this.back_login_toClose = true
        this.model = BossModel.GetInstance()
        this.change_scene_close = true
        let runner = Runner.GetInstance()
        let scene = Scene.GetInstance()
        let local_Vector2 = Vector2
        let local_GlobalEventSystem = GlobalEventSystem
        let local_SceneEventType = SceneEventType
        let scene_mgr = SceneManager.GetInstance()
        let local_Util = Util
        let local_BossBaseModel = BossModel
        let local_TimeUtil = TimeUtil
        let auto_fight_mgr = AutoFightManager.GetInstance()
        let width = 86
        this.load_callback = () => {
            //width = this.hp_img.width

            // this.form.pivot = Vector2(0.5, 0.5)
            // this.form.anchorMin = Vector2(0, 0)
            // this.form.anchorMax = Vector2(1, 1)
            // this.form.anchoredPosition = Vector2(0, 0)
            // this.form.sizeDelta = Vector2(0,0)

            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            if (!this.update_id) {
                this.update_id = runner.AddRunObj(this, 1)
            }
            this.SetView()
            this.model.ClearFeastBossBoxMap()
        }

        this.close_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            this.model.ClearFeastBossBoxMap()
            this.CancelCountTime()
            if (this.crystal_hp_id && this.crystal_monster_vo) {
                this.crystal_monster_vo.UnBind(this.crystal_hp_id)
                this.crystal_hp_id = null
            }
            this.crystal_monster_vo = null
            if (this.update_id) {
                runner.RemoveRunObj(this.update_id)
                this.update_id = null
            }
            this.box_list = null
            this.CancelQuitTimer()
            this.CancelNextWaveCountTime()
            this.CancelClearBoxListTimer()
            this.model.feast_boss_nect_wave_time = null

            if (this.complete_collect_id != null) {
                GlobalEventSystem.UnBind(this.complete_collect_id)
                this.complete_collect_id = null
            }
        }

        this.LoadSuccess = () => {

        }

        this.Update = (now_time?, elapse_time?) => {
            if (this.box_list) {
                let monster = null
                for (let id in this.box_list) {

                    monster = scene.GetMonster(id)
                    if ((monster && monster.vo) && monster.vo.reborn_end_pos) {
                        let dir = new local_Vector2()
                        dir.x = monster.vo.reborn_end_pos.x - monster.real_pos.x
                        dir.y = monster.vo.reborn_end_pos.y - monster.real_pos.y
                        let dist = dir.normalise()
                        if (dist <= 40) {
                            monster.SetRealPos(monster.vo.reborn_end_pos.x, monster.vo.reborn_end_pos.y)
                            monster.vo.reborn_end_pos = null
                            this.box_list[id] = null
                        } else {
                            let x = monster.real_pos.x + dir.x * elapse_time * 1000
                            let y = monster.real_pos.y + dir.y * elapse_time * 1000
                            monster.SetRealPos(x, y)
                        }
                    }
                }
            }
        }

        this.InitEvent = () => {
            let click_fun = () => {
                this.FindWayToCrystal()
            }

            Util.AddClickEvent(this.crystal_conta, click_fun, this, true)
            this.BindEvent(
                local_GlobalEventSystem,
                local_SceneEventType.MONSTER_VO_ADD, (instance_id?, monster_vo?) => {
                    if (this.crystal_mon_id && this.crystal_mon_id == monster_vo.type_id) {
                        this.SetCrystalMonster()
                    } else {
                        if (monster_vo.reborn_end_pos) {
                            // [ts2lua]this.box_list下标访问可能不正确
                            this.box_list[instance_id] = monster_vo
                        }
                    }
                }
            )
            let onTargetRemoveHandler = (instance_id?, type_id?, vo?) => {
                if ((scene_mgr.IsFeastBossScene() && this.crystal_mon_id) && this.crystal_mon_id == type_id) {
                    this.StartQuitTimer()
                }
            }

            this.BindEvent(local_GlobalEventSystem, ObjectEventType.MONSTER_REALLY_DEAD, onTargetRemoveHandler)
            Util.AddClickEvent(
                this._exit, () => {
                    let ok_func = () => {
                        this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46004, local_BossBaseModel.BossType.feast)
                    }

                    Alert.Show("是否退出该活动场景?", Alert_Type.Two, ok_func, null, "退出", "取消")
                },
                this,
                true
            )
            let show_fun = () => {
                this.StartQuitTimer()
            }

            this.BindEvent(this.model, local_BossBaseModel.SHOW_FEASE_BOSS_END_TIME, show_fun)
            let show_next_wave_fun = (next_time?) => {
                this.StartNextWaveTime(next_time)
            }

            this.BindEvent(this.model, local_BossBaseModel.SHOW_FEASE_BOSS_NEXT_WAVE_TIME, show_next_wave_fun)
            this.BindEvent(
                MainUIModel.GetInstance(),
                MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
                    if (bool) {
                        this.time_conta_cache = this.time_conta.visible
                        this.end_time_conta_cache = this.end_time_conta.visible
                        this.next_boss_show_cache = this.next_boss_show.visible
                        this.time_conta.visible = false
                        this.end_time_conta.visible = false
                        this.next_boss_show.visible = false
                    } else {
                        if (this.time_conta_cache != null) {
                            this.time_conta.visible = this.time_conta_cache
                            this.time_conta_cache = null
                        }
                        if (this.end_time_conta_cache != null) {
                            this.end_time_conta.visible = this.end_time_conta_cache
                            this.end_time_conta_cache = null
                        }
                        if (this.next_boss_show_cache != null) {
                            this.next_boss_show.visible = this.next_boss_show_cache
                            this.next_boss_show_cache = null
                        }
                    }
                }
            )
            let end_fun = () => {
                this.StartQuitTimer()
            }

            this.BindEvent(this.model, local_BossBaseModel.FEAST_BOSS_END, end_fun)

            let refresh_info = () => {
                this.StartCountTime()
            }
            this.BindEvent(this.model, local_BossBaseModel.FEAST_BOSS_ACT_INFO, refresh_info)

            let collect_no_times_func = () => {
                this.FindWayToCrystal()
            }
            this.BindEvent(this.model, local_BossBaseModel.FEAST_BOSS_COLLECT_NO_TIMES, collect_no_times_func)

            this.complete_collect_id = GlobalEventSystem.Bind(EventName.COMPLETE_TO_COLLECT, (mon_id?, mon_ins_id?) => {
                this.model.CompleteCollect(mon_id, mon_ins_id)
            })

            this.BindEvent(GlobalEventSystem, EventName.ATTACK_CLICK_MON, (target?) => { //boss寻路（只有点击BOSS才会调用）
                let obj_type = target && target._type
                if ((!target || !obj_type) || obj_type != SceneBaseType.Monster) {
                    return
                }
                auto_fight_mgr.SetAutoFight(true)
            })
        }

        this.SetView = () => {
            this.time_conta.visible = false
            this.end_time_conta.visible = false
            this.next_boss_show.visible = false
            this.StartCountTime()
            this.SetCrystalMonster()
            if (this.model.feast_boss_nect_wave_time) {
                this.StartNextWaveTime(this.model.feast_boss_nect_wave_time)
            }
            this.StartClearBoxListTimer()
        }

        this.StartCountTime = () => {
            this.CancelCountTime()
            // [ts2lua]local_BossBaseModel:GetInstance().timer_mark_dic下标访问可能不正确
            let subtype = local_BossBaseModel.GetInstance().timer_mark_dic[local_BossBaseModel.FEAST_BOSS_ID]
            if (subtype != null) {
                let act_info = CustomActivityModel.GetInstance().GetActInfo(local_BossBaseModel.FEAST_BOSS_ID, subtype)
                if (act_info) {
                    let [is_in_activity_time, left_time, next_open_time, next_open_time_sec] = this.model.GetFeastBossTime(act_info.base_type, act_info.sub_type)
                    if (is_in_activity_time) {
                        let end_time = Number(left_time) - local_TimeUtil.getServerTime()
                        this._end_time = end_time
                        this.count_time_id = GlobalTimerQuest.AddPeriodQuest(() => {
                            this.OnTime()
                        }, 1)
                        this.time_conta.visible = true
                        this.end_time_conta.visible = false
                        this.OnTime()
                    }
                }
            }
        }

        this.OnTime = () => {
            this._end_time = this._end_time - 1
            if (this._end_time < 0) {
                this.CancelCountTime()
                if (this.time_conta) {
                    this.time_conta.visible = false
                }
                return
            }
            if (this.left_time) {
                this.left_time.style.color = "#ffffff"
                this.left_time.style.fontSize = 22
                this.left_time.style.wordWrap = false
                this.left_time.innerHTML = Util.StrToHTML("倒计时:<font color='#b3ff48'>" + local_TimeUtil.convertTime(this._end_time) + "</font>")
                let a = <Laya.HBox>this.left_time.parent
                if (a)
                    a.refresh()
            }
        }

        this.CancelCountTime = () => {
            if (this.count_time_id) {
                GlobalTimerQuest.CancelQuest(this.count_time_id)
                this.count_time_id = null
            }
        }

        this.StartQuitTimer = () => {
            this.CancelCountTime()
            this.CancelQuitTimer()
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value
            let quit_time = this.model.GetBossKeyValue(11, "feast_boss_quit_time",cfg)
            if (quit_time) {
                this.quit_time = quit_time
                this.quit_time_id = GlobalTimerQuest.AddPeriodQuest(() => {
                    this.OnQuitTime()
                }, 1)
                this.end_time_conta.visible = true
                this.time_conta.visible = false
                this.next_boss_show.visible = false
                this.OnQuitTime()
            } else {
                this.CancelQuitTimer()
            }
        }

        this.OnQuitTime = () => {
            this.quit_time = this.quit_time - 1
            if (this.quit_time < 0) {
                this.CancelQuitTimer()
                if (this.end_time_conta) {
                    this.end_time_conta.visible = false
                    this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46004, local_BossBaseModel.BossType.feast)
                }
                return
            }
            if (this.end_time) {
                this.end_time.text = String(this.quit_time)
                //LayoutRebuilder(this.end_time)
                this.end_time_conta.refresh()
            }
        }

        this.CancelQuitTimer = () => {
            if (this.quit_time_id) {
                GlobalTimerQuest.CancelQuest(this.quit_time_id)
                this.quit_time_id = null
            }
        }

        this.StartNextWaveTime = (time?) => {
            this.CancelNextWaveCountTime()
            if (time) {
                this.next_wave_end_time = time
                this.next_wave_time = time - local_TimeUtil.getServerTime()
                if (this.next_wave_time > 0) {
                    this.next_boss_show.visible = true
                    this.next_wave_time_id = GlobalTimerQuest.AddPeriodQuest(() => {
                        this.OnNextWaveTime()
                    }, 1)
                    this.OnNextWaveTime()
                }
            }
        }

        this.OnNextWaveTime = () => {
            this.next_boss_time.text = String(this.next_wave_time)
            //LayoutRebuilder(this.next_boss_time)
            //this.next_boss_show.refresh()
            this.next_wave_time = this.next_wave_end_time - local_TimeUtil.getServerTime() //this.next_wave_time - 1
            if (this.next_wave_time <= 0) {
                if (this.next_boss_time) {
                    this.next_boss_time.text = "0"
                }
                this.CancelNextWaveCountTime()
                return
            }
        }

        this.CancelNextWaveCountTime = () => {
            if (this.next_wave_time_id) {
                GlobalTimerQuest.CancelQuest(this.next_wave_time_id)
                this.next_wave_time_id = null
            }
            if (this.next_boss_show) {
                this.next_boss_show.visible = false
            }
        }

        this.SetCrystalMonster = () => {
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value
            this.crystal_mon_id = this.crystal_mon_id || this.model.GetBossKeyValue(11, "crystal_mon_id",cfg)
            if (this.crystal_mon_id) {
                this.crystal_monster_vo = scene_mgr.GetMonsterVoByTypeId(this.crystal_mon_id)
                if (this.crystal_monster_vo) {
                    this.hp_img.width = (this.crystal_monster_vo.hp / this.crystal_monster_vo.maxHp) * width
                    if (this.crystal_hp_id && this.crystal_monster_vo) {
                        this.crystal_monster_vo.UnBind(this.crystal_hp_id)
                        this.crystal_hp_id = null
                    }
                    this.crystal_hp_id =
                        this.crystal_monster_vo.BindOne(
                            "hp", (varName?, value?) => {
                                //this.progressBar.value = value
                                this.hp_img.width = (value / this.crystal_monster_vo.maxHp) * width
                            }
                        )
                }
            }
        }

        this.FindWayToCrystal = () => {
            let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value
            let mon_coord = this.model.GetBossKeyValue(11, "crystal_mon_coord",cfg)
            if (mon_coord) {
                this.crystal_pos = this.crystal_pos || JSON.parse(mon_coord)
                if (this.crystal_pos) {
                    let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
                    let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y

                    let target_pos = { x: 0, y: 0 }
                    // [ts2lua]this.crystal_pos下标访问可能不正确
                    target_pos.x = (this.crystal_pos[0] + 100) / LogicRealRatio_X
                    // [ts2lua]this.crystal_pos下标访问可能不正确
                    target_pos.y = (this.crystal_pos[1] - 300) / LogicRealRatio_Y
                    if (target_pos.x != 0 && target_pos.y != 0) {
                        let end_func = () => {
                            auto_fight_mgr.SetAutoFight(true)
                        }

                        auto_fight_mgr.SetAutoFight(false)
                        scene.MainRoleMove(new local_Vector2(target_pos.x, target_pos.y), 4, end_func)
                    }
                }
            }
        }

        this.StartClearBoxListTimer = () => {
            this.CancelClearBoxListTimer()
            this.clear_box_list_time_id = GlobalTimerQuest.AddPeriodQuest(() => {
                this.OnClearBoxListTime()
            }, 10)
            this.OnClearBoxListTime()
        }

        this.OnClearBoxListTime = () => {
            this.model.ClearNotCollectMon()
        }

        this.CancelClearBoxListTimer = () => {
            if (this.clear_box_list_time_id) {
                GlobalTimerQuest.CancelQuest(this.clear_box_list_time_id)
                this.clear_box_list_time_id = null
            }
        }
    }


    public GetComponents() {
        [
            this._exit,
            this.crystal_conta,
            this._Image1,
            this.progressBar,
            this.hp_img,
            this.end_time_conta,
            this._Image2,
            this.end_time,
            this._Image3,
            this.time_conta,
            this._Image4,
            this.left_time,
            this.next_boss_show,
            this._Image5,
            this.next_boss_time,
            this._Image6,
        ]
            = this.GetChildrenByNames([

                "_exit",
                "crystal_conta",
                "_Image1",
                "progressBar",
                "hp_img",
                "end_time_conta",
                "_Image2",
                "end_time",
                "_Image3",
                "time_conta",
                "_Image4",
                "left_time",
                "next_boss_show",
                "_Image5",
                "next_boss_time",
                "_Image6",
            ])
    }
}
window["FeastBossSceneView"] = FeastBossSceneView