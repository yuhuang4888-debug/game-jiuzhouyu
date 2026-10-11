
import { BaseView1 } from "../common/BaseView1"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Runner } from "../util/Runner"
import "../task/TaskView"
import { GlobalTimerQuest, Util } from "../util/Util"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { ParticleManager } from "../particalEffect/ParticleManager"
import { Vector2 } from "../util/Vector2"
import { EffectResType } from "../scene/SceneConfig"
import { GameMath } from "../util/GameMath"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Message } from "../sysInfo/SysInfoController"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { TimeUtil } from "../util/TimeUtil"
import { table } from "../common/table"
import { SceneManager } from "../scene/SceneManager"
import { Config } from "../common/Config"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { ServerModel } from "../login/ServerModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { Alert, Alert_Type } from "../alert/Alert"
import { MainUIModel } from "../commonModel/MainUIModel"
export class SentientActSceneView extends BaseView1 {
    StartCountTime
    CancelCountTime
    ShowCountDown
    ShowQuitTime
    UpdateCount
    last_time
    model
    door_data = {}
    door_dir = {}
    is_find_way = false
    wavenum = 5
    item_list
    target_portal_id
    into_door_id
    public constructor() {
        super()

        this.base_file = "sentientAct"
        this.layout_file = "SentientActSceneView"
        this.layer_value = Enum_UILayer.Main
        this.destroy_imm = true
        this.back_login_toClose = true

        this.model = SentientActModel.GetInstance()

        let time_id_
        this.preload_server_config = {
            "config_beings_gate_kv": false,
            "config_dungeon": false,
            "config_dungeon_ui_content": false
        }
        this.load_callback = () => {
            this._panel_reward.hScrollBarSkin = ""
            this.InitEvent()
            this.LoadSuccsss()
        }

        this.open_callback = () => {
        }

        this.close_callback = () => {
            this.Remove()
        }
        this.StartCountTime = (index?, func?) => {
            if (!time_id_) {
                time_id_ = {}
            }
            this.CancelCountTime(index)
            time_id_[index] = GlobalTimerQuest.AddPeriodQuest(func, 1)

            func()
        }

        this.CancelCountTime = (index?) => {
            if (index == null) {
                if (!time_id_) {
                    return
                }
                for (let key in time_id_) {
                    GlobalTimerQuest.CancelQuest(time_id_[key])
                }
                time_id_ = undefined
            } else {
                if (!time_id_ || !time_id_[index]) {
                    return
                }
                GlobalTimerQuest.CancelQuest(time_id_[index])
                delete time_id_[index]
            }
        }
        this.ShowCountDown = (bool?) => {
            this._gp_count_down.visible = bool

        }
        this.ShowQuitTime = (end_time?, end_func?) => {
            if (!this._gp_quit_time.visible) {
                //ResManager.GetInstance().SetImageSpriteTrans(this, this._img_quit_bg, GameResPath.GetIcon("dungeonCommon", "uigh_040"), true)
                this._gp_quit_time.visible = true
            }
            this.ShowCountDown(false)
            this.StartCountTime(
                4, () => {
                    let left_time = end_time - TimeUtil.getServerTime()
                    if (left_time < 0) {
                        this._gp_quit_time.visible = false
                        this.CancelCountTime(4)
                        if (end_func) {
                            end_func()
                        }
                        return
                    }
                    if (this._lb_quit_time) {
                        this._lb_quit_time.changeText(`${left_time}`)
                    }
                }
            )
        }

        this.UpdateCount = (assist_num, enter_num) => {
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_beings_gate_kv", false)
            if (!cfg) return
            let max_help_count = cfg["beings_gate_dungeon_assist"].value
            let max_into_count = cfg["beings_gate_scene_enter"].value
            //let dungeon_data = BaseDungeonModel.GetInstance().GetDungeonInfo(DUN_TYPE.SentientAct)
            // let into_count = 0
            // if (dungeon_data && Util.TableSize(dungeon_data)) {
            //     for (let key in dungeon_data) {
            //         let data = dungeon_data[key]
            //         into_count += data.daily_count
            //     }
            // }
            this.into_num.text = `${max_into_count - enter_num}/${max_into_count}`
        }
    }


    public LoadSuccsss() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.pannel_bg, GameResPath.GetIcon("sentientAct", "monster_bg"))
        //MainUIManager.GetInstance().AddMoveComponent(this, this._box_exit, false, MainUIManager.MOVE_TYPE.Left)
        MainUIManager.GetInstance().AddMoveComponent(this, this._box_wayfinding, false, MainUIManager.MOVE_TYPE.Stay)

        let height = SceneManager.GetInstance().IsSentientActScene() ? 220 : 235
        this.pannel_bg.height = height
        Runner.GetInstance().AddRunObj(this)
        //this._gp_quit_time.visible = !SceneManager.GetInstance().IsSentientActScene()
        let act_data = this.model.GetActData()
        this._gp_count_down.visible = act_data.end_time || !SceneManager.GetInstance().IsSentientActScene()
        this.UpdateGp()
        this.UpdateView()
        //this.InitReward()

    }

    public InitEvent() {

        Util.AddClickEvent(this._box_exit, () => {
            if (SceneManager.GetInstance().IsSentientActScene())
                this.model.Fire(SentientActEvent.REQUEST_PROTO, 24105)
            else{
                Alert.Show("退出副本将不会返还已消耗次数，是否确认退出？", Alert_Type.Two, () => {
                    this.model.Fire(SentientActEvent.REQUEST_PROTO, 61002)
                }, null, "确定", "取消", null, null, null, null, null, null, null, null, null, null, false)
            }
                
        }, this, true)

        Util.AddClickEvent(this.find_btn, () => {
            let data = this.model.GetPortalData()
            let num = data && data.length ? data.length : 0
            if (num > 0) {
                if (!this.is_find_way) {
                    let [pos, target] = this.FindNearDoor()
                    this.StartFindWay(pos, target)
                }
            }
            else
                Message.show("暂无可挑战传送门")

            // else{
            //     Message.show("正在寻路中...")
            // }

        }, this, true)

        this.BindEvent(
            BaseDungeonModel.GetInstance(),
            BaseDungeonModel.UPDATE_DUNGEON_INFO, (vo?) => {

                let end_time = vo.end_time
                this.StartCountTime(
                    2, () => {
                        let left_time = end_time - TimeUtil.getServerTime()
                        if (left_time < 0) {
                            this.ShowCountDown(false)
                            this.CancelCountTime(2)
                            return
                        }

                        //this.ShowCountDown(true)
                        this._lb_count_down.text = TimeUtil.timeConvert8(left_time)
                    }
                )
            }
        )

        this.BindEvent(
            BaseDungeonModel.GetInstance(),
            BaseDungeonModel.UPDATE_DUNGEON_END_TIME, (end_time?) => {
                this.ShowQuitTime(end_time)
            }
        )

        this.BindEvent(
            BaseDungeonModel.GetInstance(),
            BaseDungeonModel.UPDATE_MONSTER_NUM, (scmd?) => {
                this.UpdateWaveNum(scmd)
            }
        )
        this.BindEvent(GlobalEventSystem, EventName.SHOW_MAIN_UI_TASK, (show?) => {

        })
        this.BindEvent(this.model, SentientActEvent.UPDATE_DOOR_DATA, () => {
            if (SceneManager.GetInstance().IsSentientActScene()) {
                let data = this.model.GetPortalData()
                this.SetDoorData(data)
                this.UpdateDoorNum()
                this.CreatDoor()
                // GlobalTimerQuest.AddDelayQuest(() => {
                //     if (!this.is_find_way) {
                //         let [pos, target] = this.FindNearDoor()
                //         this.StartFindWay(pos, target)
                //     }
                // }, 3)
            }


        })
        this.BindEvent(GlobalEventSystem, EventName.SHOW_BOSS_WAY_PANEL, (show?) => {

            this._box_wayfinding.visible = show

            if (show) {
                MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_wayfinding)
                MainUIManager.GetInstance().AddMoveComponent(this, this._box_wayfinding, false, MainUIManager.MOVE_TYPE.Stay)
            } else {
                MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_wayfinding, false)
            }
        })

        this.BindEvent(
            TeamModel.GetInstance(),
            TeamEvent.TEAM_BUILD_SUCCESS, () => {
                if (TeamModel.GetInstance().single_match_state == 9) {
                    let sub_type = 1
                    this.model.Fire(SentientActEvent.REQUEST_PROTO, 24103, "l", this.target_portal_id)
                    TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24020, "ic", 9, sub_type)

                    TeamModel.GetInstance().single_match_state = false
                }
            }
        )

        this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_beings_gate_kv", false)
            let last_scene_id = SceneManager.GetInstance().GetLastSceneId()
            let is_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg)
            let is_last_dungeon_scene = SentientActModel.GetInstance().IsSentientActDungeonScene(cfg, last_scene_id)
            let is_sentien_act_scene = SceneManager.GetInstance().IsSentientActScene()
            let is_last_sentien_act_scene = SceneManager.GetInstance().IsSentientActScene(last_scene_id)
            if (is_dungeon_scene && is_last_sentien_act_scene) {
                this.ClearDoor()
            }
            let act_data = this.model.GetActData()
            let end_time = act_data.end_time
            this._gp_count_down.visible = end_time > 0 || !SceneManager.GetInstance().IsSentientActScene()
            if (is_sentien_act_scene && is_last_dungeon_scene) {
                MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
                this.model.Fire(SentientActEvent.REQUEST_PROTO, 24102)
                this.model.Fire(SentientActEvent.REQUEST_PROTO, 24101)
                this.into_door_id = null
                this._gp_quit_time.visible = false
                //this._gp_count_down.visible = false
                this.StartCountTime(
                    2, () => {
                        let left_time = end_time - TimeUtil.getServerTime()
                        if (left_time < 0) {
                            this.ShowCountDown(false)
                            this.CancelCountTime(2)
                            return
                        }

                        //this.ShowCountDown(true)
                        this._lb_count_down.text = TimeUtil.timeConvert8(left_time)
                    }
                )
            }
            if (is_dungeon_scene) {
                //this._gp_quit_time.visible = true
                //this._gp_count_down.visible = true
            }
            let height = is_dungeon_scene ? 235 : 220
            this.pannel_bg.height = height
            this.UpdateGp()
        }
        )
        this.BindEvent(
            this.model,
            SentientActEvent.UPDATE_COUNT, (assist_num, enter_num) => {
                this.UpdateCount(assist_num, enter_num)

            }
        )
        this.BindEvent(
            this.model,
            SentientActEvent.FIND_WAY, () => {
                let [pos, target] = this.FindNearDoor()
                this.StartFindWay(pos, target)

            }
        )

        this.BindEvent(
            this.model,
            SentientActEvent.DELETE_DOOR, (portal_id) => {
                this.DeleteDoor(portal_id)

            }
        )

        this.BindEvent(
            this.model,
            SentientActEvent.UPDATE_ACT_STATE, (state, time) => {
                this.UpdateActState(state, time)
                if (SceneManager.GetInstance().IsSentientActScene()) {
                    let act_data = this.model.GetActData()
                    let end_time = act_data.end_time
                    this._gp_count_down.visible = end_time > 0 || !SceneManager.GetInstance().IsSentientActScene()

                    this.StartCountTime(
                        2, () => {
                            let left_time = end_time - TimeUtil.getServerTime()
                            if (left_time < 0) {
                                this.ShowCountDown(false)
                                this.CancelCountTime(2)
                                return
                            }

                            //this.ShowCountDown(true)
                            this._lb_count_down.text = TimeUtil.timeConvert8(left_time)
                        }
                    )
                }


            }
        )
        this.BindEvent(
            this.model,
            SentientActEvent.UPDATE_DUNGEON_INFO, (data) => {
                let dun_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
                let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, data.dun_id, false, dun_cfg)
                this.wavenum = cfg.wave_num
                this.InitReward(data.dun_id)
            }
        )
        this.model.Fire(SentientActEvent.REQUEST_PROTO, 24107)

        this.model.Fire(SentientActEvent.REQUEST_PROTO, 24101)
        this.model.Fire(SentientActEvent.REQUEST_PROTO, 24102)
        this.model.Fire(SentientActEvent.REQUEST_PROTO, 61004)
        if (SceneManager.GetInstance().GetCurrDunId()) {
            let dun_id = SceneManager.GetInstance().GetCurrDunId()
            let dun_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
            let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false, dun_cfg)
            this.wavenum = cfg.wave_num
            this.InitReward(dun_id)
        }

    }

    public Remove() {
        this.CancelCountTime()
        Runner.GetInstance().RemoveRunObj(this.hashCode)
        MainUIManager.GetInstance().RemoveMoveComponent(this)
        this.ClearDoor()

        if (this.item_list) {
            for (let _tmpi in this.item_list) {
                var obj = this.item_list[_tmpi]
                obj.DeleteMe()
            }
            this.item_list = null
        }

    }
    private ClearDoor() {
        for (let key in this.door_dir) {
            let effect_id = this.door_dir[key]
            if (effect_id) {
                ParticleManager.GetInstance().DelEffect(effect_id)
                delete this.door_dir[key]
                

            }
        }
        for (let key in this.door_data) {
            delete this.door_data[key]
        }
    }

    public InitView() {


    }

    private InitReward(dun_id) {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_ui_content", false)
        let dunInfo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, dun_id, false, cfg)
        if (!dunInfo) return
        let rewards = dunInfo.rewards
        rewards = JSON.parse(rewards)
        //let reward_lv = []
        // let world_lv = RoleManager.GetInstance().GetMainRoleVo().worldLv || 1
        // for (let k in rewards) {
        //     let v = rewards[k]
        //     if (Number(v[0]) >= world_lv) {
        //         reward_lv = v[1]
        //         break
        //     }
        //     reward_lv = v[1]
        // }
        if (!this.item_list) {
            this.item_list = []
        }
        for (let key in rewards) {
            let item = this.item_list[key]
            if (!item) {
                item = new EquipmentItem(this._panel_reward)
                this.item_list[key] = item
                item.SetItemSize(60, 60)
                item.Load()
            }
            item.SetPosition(Number(key) * 65, 0)
            let vo = rewards[key]
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
            if (goods_vo) {
                item.SetData(goods_vo.type_id, vo[2], lock)

            }
        }
    }
    private UpdateActState(state, time?) {
        this.door_gp.visible = state
        this.end_gp.visible = !state
        this.find_btn.visible = state
        if (!state) {
            this.ClearDoor()
            this.StartCountTime(
                99, () => {
                    let left_time = time - TimeUtil.getServerTime()
                    if (left_time < 0) {
                        this.CancelCountTime(99)
                        return
                    }
                    if (this.time) {
                        this.time.changeText(`${TimeUtil.convertTime(left_time)}`)
                    }
                }
            )
        }

    }


    public UpdateView() {
        this.UpdateDoorNum()

    }

    private UpdateDoorNum() {

        let num = this.model.GetDoorNum()
        this.door_num.text = `${num}个`
    }

    public SetDoorData(data) {
        for (let key in data) {
            let vo = data[key]
            let portal_id = vo.portal_id
            this.door_data[portal_id] = vo
        }
    }

    private CreatDoor() {
        for (let key in this.door_data) {
            let vo = this.door_data[key]
            if (this.door_dir[key]) continue
            if (vo && vo.x && vo.y) {
                this.door_dir[key] = ParticleManager.GetInstance().AddPosEffect("sence_effect_chuansongmen_1", new Vector2(vo.x, vo.y), true,
                    null, null, false, null, null, null, 1, true, null, null, null, null, EffectResType.Other)
            }

        }
    }

    private DeleteDoor(portal_id) {
        let effect_id = this.door_dir[portal_id]
        if (effect_id) {
            ParticleManager.GetInstance().DelEffect(effect_id)
            delete this.door_dir[portal_id]
            delete this.door_data[portal_id]

            effect_id = null
        }
    }
    private MoveCompleted(pos, target) {
        this.is_find_way = false
        let mainRole = Scene.GetInstance().main_role
        if (GameMath.GetDistance(mainRole.real_pos.x, mainRole.real_pos.y, pos.x, pos.y) <= 300 * 300 && !this.into_door_id) {
            this.target_portal_id = target
            Scene.GetInstance().clearGoToData()
            this.into_door_id = target
            let team_info = TeamModel.GetInstance().team_info
            if (team_info) {
                if (this.IsLeader()) {
                    this.model.Fire(SentientActEvent.REQUEST_PROTO, 24103, "l", this.target_portal_id)
                    TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24020, "ic", 9, 1)

                }
                else
                    Message.show("请等待队长发起挑战")
            }
            else {
                TeamModel.GetInstance().single_match_state = 9
                let sub_type = 1
                let cfg = TeamModel.GetInstance().GetTaegetCfgById(9, sub_type)
                if (cfg) {
                    TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", 9, sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
                }
            }
        }
    }

    public StartFindWay(pos, target) {
        //this.is_find_way = true
        if (pos && target) {
            let move_completed_callback = () => {
                if(this.into_door_id) this.into_door_id = null
                this.MoveCompleted(pos, target)
            }
            Scene.GetInstance().MainRoleMove(new Vector2(pos.x / SceneObj.GetLogicRealRatio().x, pos.y / SceneObj.GetLogicRealRatio().y), 3, move_completed_callback)
        }
    }
    private IsLeader() {
        let team_info = TeamModel.GetInstance().team_info
        if (team_info) {
            let role_list = team_info.team_member_list
            if (role_list) {
                for (let _tmpi in role_list) {
                    let vo = role_list[_tmpi]
                    if (vo.id == RoleManager.GetInstance().GetMainRoleId() && vo.team_position == 1) {
                        return true
                    }
                }
            }

        }
        return false
    }

    private FindNearDoor() {
        let pos
        let distance = 0
        let target
        for (let key in this.door_data) {
            let vo = this.door_data[key]
            if (vo) {
                let mainRole = Scene.GetInstance().main_role
                let dis = GameMath.GetDistance(mainRole.real_pos.x, mainRole.real_pos.y, vo.x, vo.y)
                if (distance == 0 || dis < distance) {
                    distance = dis
                    pos = new Vector2(vo.x, vo.y)
                    target = key
                    //this.target_portal_id = key
                }
            }
        }
        return [pos, target]
    }

    private UpdateGp() {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_beings_gate_kv", false)
        let is_dungeon_scene = this.model.IsSentientActDungeonScene(cfg)
        this.dungeon_gp.visible = is_dungeon_scene
        this.find_way_gp.visible = !is_dungeon_scene
    }

    private UpdateWaveNum(scmd?) {
        if (scmd) {
            this.wave_num.style.color = "#ffffff"
            this.wave_num.style.fontSize = 18
            this.wave_num.style.wordWrap = false
            this.monster_num.style.color = "#ffe222"
            this.monster_num.style.fontSize = 18
            this.monster_num.style.wordWrap = false
            this.wave_num.innerHTML = `当前波数 (${scmd.wave_num}/${this.wavenum})`
            this.monster_num.innerHTML = `怪物数量 (${scmd.mon_num - scmd.dead_mon_num}/${scmd.mon_num})`
        }

    }



    public Update(now_time?, elapse_time?) {

        if (!this.last_time || now_time - this.last_time > 1) {
            this.last_time = now_time
            for (let key in this.door_data) {
                let vo = this.door_data[key]
                if (vo) {
                    let pos = new Vector2(vo.x, vo.y)
                    this.MoveCompleted(pos, key)
                    //this.target_portal_id = key
                }
            }
            if (this.into_door_id) {
                let data = this.door_data[this.into_door_id]
                if (data && data.x && data.y) {
                    let pos = new Vector2(data.x, data.y)
                    let mainRole = Scene.GetInstance().main_role
                    if (GameMath.GetDistance(mainRole.real_pos.x, mainRole.real_pos.y, pos.x, pos.y) > 300 * 300) {
                        this.into_door_id = null
                    }
                }

            }
        }
    }



    _box_wayfinding: Laya.Box
    pannel_bg: Laya.Image
    find_way_gp: Laya.Box
    door_gp: Laya.Box
    door_num: Laya.Label
    into_num: Laya.Label
    end_gp: Laya.Box
    time: Laya.Label
    find_btn: Laya.Box
    dungeon_gp: Laya.Box
    wave_num: Laya.HTMLDivElement
    monster_num: Laya.HTMLDivElement
    _panel_reward: Laya.Panel
    _box_exit: Laya.Box
    _img_exit: Laya.Image
    _gp_count_down: Laya.Box
    _Image1: Laya.Image
    _Group1: Laya.HBox
    _Label1: Laya.Label
    _lb_count_down: Laya.Label
    _gp_quit_time: Laya.Box
    _img_quit_bg: Laya.Image
    _Image6: Laya.Image
    _lb_quit_time: Laya.Label
    public GetComponents() {
        [
            this._box_wayfinding,
            this.pannel_bg,
            this.find_way_gp,
            this.door_gp,
            this.door_num,
            this.into_num,
            this.end_gp,
            this.time,
            this.find_btn,
            this.dungeon_gp,
            this.wave_num,
            this.monster_num,
            this._panel_reward,
            this._box_exit,
            this._img_exit,
            this._gp_count_down,
            this._Image1,
            this._Group1,
            this._Label1,
            this._lb_count_down,
            this._gp_quit_time,
            this._img_quit_bg,
            this._Image6,
            this._lb_quit_time,
        ]
            = this.GetChildrenByNames([

                "_box_wayfinding",
                "pannel_bg",
                "find_way_gp",
                "door_gp",
                "door_num",
                "into_num",
                "end_gp",
                "time",
                "find_btn",
                "dungeon_gp",
                "wave_num",
                "monster_num",
                "_panel_reward",
                "_box_exit",
                "_img_exit",
                "_gp_count_down",
                "_Image1",
                "_Group1",
                "_Label1",
                "_lb_count_down",
                "_gp_quit_time",
                "_img_quit_bg",
                "_Image6",
                "_lb_quit_time",
            ])
    }
}
window["SentientActSceneView"] = SentientActSceneView