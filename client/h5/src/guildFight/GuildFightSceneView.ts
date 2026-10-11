import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDelta, GetLocalPositionX, GetLocalPositionY, GlobalTimerQuest, SetAnchoredPositionX } from "../util/Util"
import { GuildFightCallItem } from "./GuildFightCallItem"
import { GuildFightKillItem } from "./GuildFightKillItem"
import { GuildFightPanelItem } from "./GuildFightPanelItem"
import { Config } from "../common/Config"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"
import { MainUIManager } from "../common/MainUIManager"
import { BossTargetPanel } from "../boss/BossTargetPanel"
import { BossSceneManager } from "../commonController/BossSceneManager"

export class GuildFightSceneView extends BaseView1 {
    AddRunner
    CancelTime
    ClearGodBtn
    ClearKillAnimation
    CloseCallback
    EndtextTImer
    GetBossInfo
    GetBossPos
    GetRoleVoList
    InitCallView
    InitEvent
    LoadSuccess
    OwnerRole
    RemoveRunner
    SetEndTime
    SetKillItem
    Update
    UpdateBossAutoFight
    percentWidth
    percentHeight
    tween_ids
    _taget_panel
    attackTarget
    panelItem
    _god_btn
    setTagetPanelHid
    boss_scene_mgr
    public constructor() {
        super()

        this.base_file = "guildFight"
        this.layout_file = "GuildFightSceneView"
        this.layer_value = Enum_UILayer.Main
        this.percentWidth = 100
        this.percentHeight = 100
        this.back_login_toClose = true
        this.destroy_imm = true
        let model = GuildFightModel.GetInstance()
        let roleMgr = RoleManager.GetInstance()
        this.boss_scene_mgr=BossSceneManager.GetInstance()
        let local_util = Util
        let local_event = GuildFightEvent
        let local_global = GlobalEventSystem
        let local_eventname = EventName
        let local_mainuimodel = MainUIModel
        let local_mainui_ins = local_mainuimodel.GetInstance()
        let moveTime = local_mainuimodel.Move_Time_Interval
        //let locla_egret = Laya
        let local_time = TimeUtil
        let local_scene = Scene
        let scene = local_scene.GetInstance()
        let sceneMgr = SceneManager.GetInstance()
        let local_rune = Runner.GetInstance()
        let person_list_ = []
        let call_item_list_ = null
        let is_call_open_ = false
        let show_call_func_ = null
        let kill_item_ = null
        let timer_id_ = null
        let own_config_ = null
        let score_config_ = null
        let guild_kv_config_ = null
        // TODO dxj 未移植
        //let secret_model_ = SecretBossModel.GetInstance()
        let select_boss_id_ = 0
        let array_boss_ = null
        let update_times_index_ = 0
        let update_id_ = null
        let boss_pos_dic_ = null
        let hid_activityState_ = false
        let kill_tween_ids = null
        let kill_timer_ids = null
        let voice
        let voice_time
        this.tween_ids = []
        let kill_nummm=5
        this.load_callback = () => {
            this._sc.vScrollBarSkin = ""
            this.LoadSuccess()
        }

        this.close_callback = () => {
            MainUIManager.GetInstance().RemoveMoveComponent(this)
            this.CloseCallback()
        }

        this.preload_server_config = {
            "config_terri_mon": false,
            "config_guild_battle_own": false,
            "config_guild_battle_role_reward": false,
            "config_guild_battle_cfg": false,
            "config_territory_kv": false
        }
        this.LoadSuccess = () => {
            //MainUIManager.GetInstance().AddMoveComponent(this, this.timeGp, false, MainUIManager.MOVE_TYPE.Top)
            MainUIManager.GetInstance().AddMoveComponent(this, this._gp_god, false, MainUIManager.MOVE_TYPE.Buttom)
            MainUIManager.GetInstance().AddMoveComponent(this, this._box_btn, false, MainUIManager.MOVE_TYPE.Right)
            MainUIManager.GetInstance().AddMoveComponent(this, this.leave_img, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this.targetGp, false, MainUIManager.MOVE_TYPE.Right)
            MainUIManager.GetInstance().AddMoveComponent(this, this.panelGp, false, MainUIManager.MOVE_TYPE.Left)
            MainUIManager.GetInstance().AddMoveComponent(this, this.kill_tips_group, false, MainUIManager.MOVE_TYPE.Top)

            own_config_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_terri_mon", false)//Config.Terrimon
            score_config_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_battle_role_reward", false)//Config.Terriwarrolereward
            guild_kv_config_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_battle_role_reward", false)//Config.Territorykv
            if ((own_config_ && score_config_) && guild_kv_config_) {
                show_call_func_ = roleMgr.GetMainRoleVo().position == 1 || roleMgr.GetMainRoleVo().position == 2
                if (show_call_func_) {
                    this.call_img.visible = true
                } else {
                    this.call_img.visible = false
                }
                this.InitEvent()
            }
            if (!this._taget_panel) {
                this._taget_panel = new BossTargetPanel(this.targetGp)
                this._taget_panel.Load()
            }
            if (!this.panelItem) {
                this.panelItem = new GuildFightPanelItem(this.panelGp)
                this.panelItem.Load()
            }
            this.AddRunner()
            //ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("guildFight", "uizbz_026"))
            voice_time = setTimeout(() => {
                voice = CommonManager.GetInstance().PlayFightingVoice(3)
            }, 1200);
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.call_img, () => {
                    this.InitCallView()
                    if (show_call_func_) {
                        if (is_call_open_) {
                            is_call_open_ = false
                            this.call_group.visible = false
                        } else {
                            is_call_open_ = true
                            this.call_group.visible = true
                        }
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.close_call_img, () => {
                    if (is_call_open_) {
                        is_call_open_ = false
                        this.call_group.visible = false
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.leave_img, () => {
                    let ok_func = () => {
                        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50603, "c", 2)
                    }

                    Alert.Show("确定要离开领地战活动场景么？", Alert_Type.Two, ok_func, null, "确定", "取消")
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.SHOW_KILL_ITEM, (scmd?) => {
                    if (scmd) {
                        this.SetKillItem(scmd)
                    }
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_WAR_INFO, () => {
                    this.SetEndTime()
                }
            )
            Util.AddClickEvent(
                this.ruleImg, () => {
                    // let scmd =
                    // {
                    //     atter_server_id: 1,   // 击杀者server_id
                    //     role_id: 151551515,
                    //     role_name: "巴巴爸爸",
                    //     sex: 2,      // 性别
                    //     realm: 1,       // 阵营
                    //     career: 1,       // 职业
                    //     turn: 2,      // 转生数
                    //     lv: 380,
                    //     picture: "",
                    //     picture_ver: 0,
                    //     ckill_num: kill_nummm
                    // }
                    // kill_nummm+=2
                    // this.SetKillItem(scmd)
                    local_global.Fire(local_eventname.OPEN_INSTRUCTION_VIEW, InstructionType.KFGuildFightRule)
                },
                this,
                true
            )
            // this.BindEvent(
            //     local_global,
            //     NineSkyModel.NINE_SKY_FIGHTING_MSG, (attack_role_id?) => {
            //         // TODO dxj 未移植
            //         //secret_model_:setSufferedList(attack_role_id)
            //     }
            // )
            this.SetEndTime()
            local_mainui_ins.Fire(local_mainuimodel.CHANGE_ACTIVITY_STATE, false)
        }

        this.InitCallView = () => {
            if (!call_item_list_) {
                call_item_list_ = []
            }
            if (this.is_loaded) {
                let terriCfg = this.preload_server_config.config_terri_mon//ResManager.GetInstance().GetGameConfigFromCache(this, "config_terri_mon", false)//Config.Terrimon
                if (terriCfg && model.warInfo.own_list) {
                    let terrId = model.warInfo.territory_id
                    let list = []
                    for (let key in model.warInfo.own_list) {

                        // [ts2lua]model.warInfo.own_list下标访问可能不正确
                        table.insert(list, model.warInfo.own_list[key])
                    }

                    list.sort((a, b) => {
                        return a.mon_id - b.mon_id
                    })

                    // table.sort(list, (a?, b?) => {
                    //     if (a.mon_id != b.mon_id) {
                    //         return a.mon_id > b.mon_id
                    //     }
                    //     return false
                    // })

                    //王者守卫放第一
                    let ar_mor = []
                    let ar_king = []
                    let vo
                    let curCfg
                    for (vo of list) {
                        curCfg = terriCfg[`${terrId}@${vo.mon_id}`]
                        if (!curCfg) continue
                        if (curCfg && curCfg.mon_type == 1) {
                            ar_king.push([vo, curCfg])
                        } else {
                            ar_mor.push([vo, curCfg])
                        }
                    }
                    ar_king = ar_king.concat(ar_mor)

                    let vo1
                    for (let _tmpi in ar_king) {
                        vo1 = ar_king[_tmpi]
                        // [ts2lua]terriCfg下标访问可能不正确
                        let cfg = vo1[1]//terriCfg[terrId + "@" + vo.mon_id]
                        if (cfg) {
                            // [ts2lua]call_item_list_下标访问可能不正确
                            let item = call_item_list_[vo1[0].mon_id]
                            if (!item) {
                                item = new GuildFightCallItem(this.item_group)
                                item.Load()
                                item.SetCfg(cfg)
                                // if (cfg.mon_type == 1) {
                                //     // TODO dxj 
                                //     //this.item_group.setChildIndex(item, 0)
                                // }
                                // [ts2lua]call_item_list_下标访问可能不正确
                                call_item_list_[vo1[0].mon_id] = item
                            }
                            if (vo1) {
                                item.SetData(vo1[0])
                            }
                        }
                    }



                }
            }
        }

        this.SetEndTime = () => {
            if (this.is_loaded) {
                this.CancelTime()
                let time = model.warInfo.end_time
                if (time) {
                    timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                        this.EndtextTImer()
                    }, 1)
                    this.EndtextTImer()
                }
            }
        }

        this.EndtextTImer = () => {
            // let close_time = model.warInfo.end_time - local_time.getServerTime()
            // if (close_time <= 0) {
            //     this.CancelTime()
            //     return
            // }
            // this.time_label.text = local_time.timeConvert8(close_time)
        }

        this.CancelTime = () => {
            if (timer_id_) {
                GlobalTimerQuest.CancelQuest(timer_id_)
                timer_id_ = null
            }
        }

        this.CloseCallback = () => {

            if (voice_time) {
                clearTimeout(voice_time)
                voice_time = null
            }

            if (voice) {
                SoundManager.GetInstance().StopSoundEffect(voice)
                voice = null
            }


            this.ClearKillAnimation()
            if (this.tween_ids) {
                for (let _ in this.tween_ids) {
                    var tween_id = this.tween_ids[_]
                    SYTweenLite.Stop(tween_id)
                }
                this.tween_ids = []
            }
            if (call_item_list_) {
                for (let key in call_item_list_) {

                    // [ts2lua]call_item_list_下标访问可能不正确
                    call_item_list_[key].DeleteMe()
                    // [ts2lua]call_item_list_下标访问可能不正确
                    call_item_list_[key] = null
                }
            }
            call_item_list_ = null
            for (let _tmpi in person_list_) {
                var vo = person_list_[_tmpi]
                vo.DeleteMe()
            }
            person_list_ = []
            if (kill_item_) {
                kill_item_.DeleteMe()
                kill_item_ = null
            }
            if (this.panelItem) {
                this.panelItem.DeleteMe()
                this.panelItem = null
            }
            if (this._taget_panel) {
                this._taget_panel.DeleteMe()
                this._taget_panel = null
            }
            this.CancelTime()
            this.RemoveRunner()
            this.ClearGodBtn()
        }

        this.ClearKillAnimation = () => {

            
            if(anim_hander1){
                anim_hander1.recover()
                anim_hander1=null
            }



            //清理
            if(anim_time){
                GlobalTimerQuest.CancelQuest(anim_time)
                anim_time=null
            }
            Laya.Tween.clearAll( this.kill_tips_group)
        }


        let anim_hander1:Laya.Handler
        let anim_time

        // 测试数据 "{ckill_num = 3, career = 1}"
        this.SetKillItem = (scmd?) => {
            if (!kill_item_) {
                kill_item_ = new GuildFightKillItem(this.kill_tips_group)
                kill_item_.Load()
            }
            kill_item_.SetData(scmd)
            kill_item_.SetVisible(true)

            let item_w = 489
            let star_x = -item_w
            let center_x = (this._box_kill.width - item_w) / 2
            let end_x = this._box_kill.width + item_w
            this.kill_tips_group.pos(star_x,0)

            this.ClearKillAnimation()
            let anim_func1 = () => {
                anim_time=GlobalTimerQuest.AddDelayQuest(() => {
                    if(this.use_delete_method) return
                    this.kill_tips_group.pos(center_x, 0)
                    this.kill_tips_group.alpha = 1
                    Laya.Tween.to(this.kill_tips_group, { alpha: 0, x: end_x }, moveTime * 1000)
                },1.2)
               
            }
            if(!anim_hander1){
                anim_hander1=Laya.Handler.create(this,anim_func1,null,false)
            }
            Laya.Tween.to(this.kill_tips_group, { alpha: 1, x: center_x }, moveTime * 1000,Laya.Ease.sineInOut,anim_hander1)

            // let tween_id = SYTweenLite.to(this, this.kill_tips_group, SYTweenLite.UiAnimationType.ALPHA, center_x, moveTime)
            // table.insert(kill_tween_ids, tween_id)
            // let timer_id = GlobalTimerQuest.AddDelayQuest(() => {
            //     tween_id = SYTweenLite.to(this, this.kill_tips_group, SYTweenLite.UiAnimationType.POSX, end_x, moveTime)
            //     table.insert(kill_tween_ids, tween_id)
            // }, 1.2)
            // table.insert(kill_timer_ids, timer_id)
            // timer_id = GlobalTimerQuest.AddDelayQuest(() => {
            //     if (kill_item_) {
            //         kill_item_.SetVisible(false)
            //     }
            // }, 1.5)
            // table.insert(kill_timer_ids, timer_id)

           


           
           

        }

        this.ClearGodBtn = () => {
            if (this._god_btn) {
                this._god_btn.DeleteMe()
                this._god_btn = null
            }
        }

        this.UpdateBossAutoFight = () => {

            
            let obj_vo_list = []
            let local_cfg = Config

            let mon_list = scene.FindTargets(local_scene.FIND_TARGET_TYPE.monster, 1, null, null, null, null, null)[0]
            let roleGp = roleMgr.GetMainRoleVo().warGroup
            for (let key in local_scene.GetInstance().monster_list) {
                let monster = local_scene.GetInstance().monster_list[key]
                if (monster) {
                    let Vo = monster.GetVo()
                    if (Vo.warGroup == roleGp && roleGp > 0) {
                        obj_vo_list.push(Vo)
                    }
                }
            }
            let role_vo_list = this.boss_scene_mgr.GetSortSecneRoleList()//this.GetRoleVoList()

            // this.judgeTarget(role_vo_list)//判断目标

            if (mon_list.length > 0) {
                obj_vo_list = obj_vo_list.concat([mon_list[0]])
            }
            else if (select_boss_id_ > 0) {
                let vo = this.GetBossInfo()
                if (vo && vo.reborn_time > local_time.getServerTime()) {
                    let bossPos = this.GetBossPos()
                    if (bossPos) {
                        let distance = GameMath.GetDistance(scene.main_role.x, scene.main_role.y, bossPos.x, bossPos.y)
                        let monVo = local_cfg.GetConfigVo(local_cfg.ConfigHasDefaultValue.config_mon.name, vo.bossid, false)
                        let bossDistance = monVo.tracing_distance + 150 //boss攻击范围
                        if (distance <= bossDistance * bossDistance)
                            obj_vo_list = obj_vo_list.concat([vo])
                    }
                }
            }

            obj_vo_list = obj_vo_list.concat(role_vo_list)

            if (obj_vo_list.length > 0) {
                if (!hid_activityState_ && local_mainui_ins.activity_icon_in_show) {
                    local_mainui_ins.Fire(local_mainuimodel.CHANGE_ACTIVITY_STATE, false)
                }
                let boss = mon_list[0]
                if (boss && !local_mainui_ins.big_blood_in_show) {
                    let config = local_cfg.GetConfigVo(local_cfg.ConfigHasDefaultValue.config_mon.name, boss.GetVo().type_id, false)
                    local_global.Fire(local_eventname.SHOW_HITER_BIG_BLOOD_VIEW, true, boss.GetVo(), config.hp_num)
                }

                this._taget_panel.SetData(obj_vo_list)

                hid_activityState_ = true
                this.setTagetPanelHid(true)
            } else {
                hid_activityState_ = false
                this.setTagetPanelHid(false)
            }
        }

        this.GetRoleVoList = () => {
            let main_role_vo = roleMgr.GetMainRoleVo()
            let main_role_id = roleMgr.GetMainRoleId()
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

        this.GetBossPos = () => {
            // [ts2lua]boss_pos_dic_下标访问可能不正确
            return boss_pos_dic_ && boss_pos_dic_[select_boss_id_]
        }

        this.GetBossInfo = () => {
            if (!array_boss_) {
                return
            }
            let list = array_boss_.source
            if (list) {
                for (let _tmpi in list) {
                    var vo = list[_tmpi]
                    if (vo.bossid == select_boss_id_) {
                        return vo
                    }
                }
            }
        }

        this.setTagetPanelHid = (bool?) => {
            if (this._taget_panel) {
                this._taget_panel.SetVisible(bool)
            }
        }

        this.attackTarget = () => {
        }

        this.OwnerRole = () => {
            let main_vo = roleMgr.GetMainRoleVo()
            let role = null
            let role_vo_list =  this.boss_scene_mgr.GetSortSecneRoleList()//this.GetRoleVoList()
            for (let key in role_vo_list) {

                // [ts2lua]role_vo_list下标访问可能不正确
                let role_vo = role_vo_list[key]
                if (role_vo.vo_type == SceneBaseType.MainRole) {
                    break
                }
                if (!sceneMgr.IsCanAttackByMainRole(role_vo)) {
                    break
                }
                role = local_scene.GetInstance().GetRole(role_vo.role_id)
                if (role) {
                    break
                }
            }
            return role
        }

        update_times_index_ = 0
        this.Update = (now_time?, elapse_time?) => {
            update_times_index_ = update_times_index_ + 1
            if (update_times_index_ % 20 == 0) {
                this.UpdateBossAutoFight()
            }
        }

        this.AddRunner = () => {
            local_rune.AddRunObj(this)
        }

        this.RemoveRunner = () => {
            local_rune.RemoveRunObj(this.hashCode)
        }

        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50601)
        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50604)
        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50620)
    }


    targetGp: Laya.Box
    call_group: Laya.Box
    bg: Laya.Image
    _sc: Laya.Panel
    item_group: Laya.VBox
    close_call_img: Laya.Image
    _Image2_title2: Laya.Image
    _lb_title2: Laya.Label
    _box_btn: Laya.Box
    ruleImg: Laya.Image
    call_img: Laya.Image
    leave_img: Laya.Image
    _box_kill: Laya.Box
    kill_tips_group: Laya.Box
    timeGp: Laya.Box
    _Image1: Laya.Image
    _Label2: Laya.Label
    time_label: Laya.Label
    _gp_god: Laya.Box
    panelGp: Laya.Box
    public GetComponents() {
        [
            this.targetGp,
            this.call_group,
            this.bg,
            this._sc,
            this.item_group,
            this.close_call_img,
            this._Image2_title2,
            this._lb_title2,
            this._box_btn,
            this.ruleImg,
            this.call_img,
            this.leave_img,
            this._box_kill,
            this.kill_tips_group,
            this.timeGp,
            this._Image1,
            this._Label2,
            this.time_label,
            this._gp_god,
            this.panelGp,
        ]
            = this.GetChildrenByNames([

                "targetGp",
                "call_group",
                "bg",
                "_sc",
                "item_group",
                "close_call_img",
                "_Image2_title2",
                "_lb_title2",
                "_box_btn",
                "ruleImg",
                "call_img",
                "leave_img",
                "_box_kill",
                "kill_tips_group",
                "timeGp",
                "_Image1",
                "_Label2",
                "time_label",
                "_gp_god",
                "panelGp",
            ])
    }
}
window["GuildFightSceneView"] = GuildFightSceneView