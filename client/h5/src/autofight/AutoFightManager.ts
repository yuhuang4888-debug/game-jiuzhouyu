import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName, SceneEventType } from "../common/EventName"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameMath } from "../util/GameMath"
import { Status } from "../util/Status"
import { Vector2 } from "../util/Vector2"

export class AutoFightManager extends EventDispatcher {
    /**临时手动时间 */
    static TempModeTime = 3
    static Instance: AutoFightManager
    /**自动战斗、自动寻路的权重配置 */
    static AUTO_WEIGHT_LEVEL =
    {
        CLOSE: 0,
        MAX: 10,
    }

    public static GetInstance() {
        if (AutoFightManager.Instance == null) {
            new AutoFightManager()
        }
        return AutoFightManager.Instance
    }

    /**自动战斗、自动寻路处理成权重表示；0表示不处于此状态；大于0则处于，不同的值表示不同的权重，处理两者谁优先问题 */
    auto_fight_weight = 0
    /**是否在自动寻路状态，在挂机的过程中，自动寻路优先 */
    auto_findway_weight = 0
    /**是否临时手动中 */
    is_temp_mode
    /**开启自动挂机的时候记录下位置 */
    auto_fight_cache_pos = { x: 0, y: 0 }
    /**记录开始挂机前的坐标 */
    auto_begin_x = 0
    auto_begin_y = 0
    /**技能技能后摇没结束前的移动坐标 */
    go_to_pos
    /**飞鞋飞去任务对话的npcid */
    fly_talk_npc_id = 0
    fly_talk_npc_angle = 0
    /**正在使用小飞鞋 */
    is_flying_shoe = false
    /**飞鞋位置 */
    next_fly_pos

    public constructor() {
        super()
        if (AutoFightManager.Instance) {
            return
        }
        AutoFightManager.Instance = this
    }


    GetBeginAutoPos() {
        return [this.auto_begin_x, this.auto_begin_y]
    }

    SetBeginAutoPos(x?, y?) {
        this.auto_begin_x = x
        this.auto_begin_y = y
    }

    /**设置是否在自动挂机的状态值(boolean兼容为number) */
    SetAutoFight(value?) {
        if (typeof (value) == "boolean") {
            if (value) {
                value = AutoFightManager.AUTO_WEIGHT_LEVEL.MAX
            } else {
                value = AutoFightManager.AUTO_WEIGHT_LEVEL.CLOSE
            }
        }
        this.SetTempMode(false)  //取消临时挂机
        if (value != this.auto_fight_weight) {
            this.auto_fight_weight = value
            GlobalEventSystem.Fire(EventName.UPDATE_AUTO_FIGHT_STATE, this.auto_fight_weight > 0, this.auto_findway_weight > 0)
        }
    }

    GetAutoFightState() {
        return this.auto_fight_weight > 0
    }
    /**
     * 设置自动寻路状态
     * 设置是否在寻路的状态值(boolean兼容为number)
     * @param value 
     */
    SetAutoFindWay(value?) {
        if (typeof (value) == "boolean") {
            if (value) {
                value = AutoFightManager.AUTO_WEIGHT_LEVEL.MAX
            } else {
                value = AutoFightManager.AUTO_WEIGHT_LEVEL.CLOSE
            }
        }
        if (value != this.auto_findway_weight) {
            this.auto_findway_weight = value
            GlobalEventSystem.Fire(EventName.UPDATE_AUTO_FIGHT_STATE, this.auto_fight_weight > 0, this.auto_findway_weight > 0)
        }
    }

    GetAutoFindWayState() {
        return this.auto_findway_weight > 0
    }

    TrySetAutoFightPriority() {
        if (this.auto_fight_weight == AutoFightManager.AUTO_WEIGHT_LEVEL.MAX && this.auto_findway_weight == AutoFightManager.AUTO_WEIGHT_LEVEL.MAX) {
            this.auto_findway_weight = AutoFightManager.AUTO_WEIGHT_LEVEL.MAX - 1
        }
    }

   /**
    * 比较自动战斗与自动寻路的权重
    * @returns 0为权重相等；-1为自动战斗权重小于自动寻路权重；1为自动战斗权重大于自动寻路权重
    */
    CompareAutoFightAndAutoFindWay() {
        let val = 0
        if (this.auto_fight_weight > this.auto_findway_weight) {
            val = 1
        } else if (this.auto_fight_weight < this.auto_findway_weight) {
            val = -1
        }
        return val
    }

    /**开始自动战斗 */
    StartAutoFight(not_save_cookies?) {
        this.SetAutoFight(true)         // 设置自动战斗状态为true
        if (not_save_cookies == null || not_save_cookies == false) {
            this.SetAutoFightStateCookie(true)
        }
    }

    /**停止自动战斗 */
    StopAutoFight(not_save_cookies?) {
        this.SetAutoFight(false)
        if (not_save_cookies == null || not_save_cookies == false) {
            this.SetAutoFightStateCookie(false)
        }
    }

    /**设置挂机cookie */
    SetAutoFightStateCookie(bool?) {
        CookieWrapper.Instance.SaveCookie(CookieWrapper.AUTO_FIGHT_STATE, bool)
    }

    /**获取挂机cookie */
    GetAutoFightStateCookie() {
        return CookieWrapper.Instance.GetCookie(CookieWrapper.AUTO_FIGHT_STATE)
    }

    /**把挂机攻击优先状态保存入cookies */
    SetAttackFirstCookies(_unLimit?, _npcFirst?, _roleFirst?) {
        let list = { "unLimit": _unLimit, "npcFirst": _npcFirst, "roleFirst": _roleFirst }
        CookieWrapper.Instance.SaveCookie(CookieWrapper.AUTO_FIGHT_ATTACK_FIRST_STATE, JSON.stringify(list))
    }

    /**从cookies中获取挂机攻击优先状态 */
    GetAttackFirstCookies() {
        let state_list: any = CookieWrapper.Instance.GetCookie(CookieWrapper.AUTO_FIGHT_ATTACK_FIRST_STATE)
        if (state_list == null) {
            return [false, true, false]
        } else {
            return [state_list.unLimit, state_list.npcFirst, state_list.roleFirst]
        }
    }

    /**保存下开始自动挂机的位置 */
    CacheAutoFightPos(x?, y?) {
        if (Scene.Instance.GetMainRole()) {
            let pos = Scene.Instance.GetMainRole().GetRealPos()
            if (pos.x != 0 && pos.y != 0) {
                if (x == null || y == null) {
                    x = pos.x
                    y = pos.y
                }
                this.auto_fight_cache_pos.x = x
                this.auto_fight_cache_pos.y = y
                // console.log("自动挂机记录下的坐标是==========：", x, y)
            }
            Scene.Instance.ClearLastAttack()
        }
    }


    /**判断技能是否是允许自动释放状态，默认是允许 */
    FindSkillIsAuto(id?) {
        // let is_auto = true
        // if (SkillManager.GetInstance(): GetHitSkillVo() && id == SkillManager.GetInstance().GetHitSkillVo().id && is_auto ) {        //羁绊技能默认不自动勾选
        //     is_auto = true
        // }
        // let auto_skill_list = CookieWrapper.Instance.GetCookie(CookieLevelType.Account, CookieKey.AUTO_FIAGHT_SKILL_LIST)

        // if (auto_skill_list) {
        //     for (let i = 0; i < auto_skill_list.length; i++) {
        //         var v = auto_skill_list[i]
        //         if (v.id == id) {
        //             is_auto = v.state
        //         }
        //     }
        // }
        return true
    }

    /**保存自动挂机的技能设置 */
    SetAutoFightSkillList(id?, state?) {
        // let auto_skill_list = CookieWrapper.Instance.GetCookie(CookieWrapper.AUTO_FIAGHT_SKILL_LIST)
        // let find = false
        // if (auto_skill_list) {
        //     for (let i = 0; i < auto_skill_list.length; i++) {
        //         var v = auto_skill_list[i]
        //         if (v.id == id) {
        //             find = true
        //             v.state = state
        //             break
        //         }
        //     }
        // } else {
        //     auto_skill_list = []
        // }
        // if (find == false) {
        //     let list = {}
        //     list.id = id
        //     list.state = state
        //     table.insert(auto_skill_list, list)
        // }
        // CookieWrapper.Instance.SaveCookie(CookieLevelType.Account, CookieTimeType.TYPE_ALWAYS, CookieKey.AUTO_FIAGHT_SKILL_LIST, auto_skill_list)
        // CookieWrapper.Instance.WriteAll()
    }


    /**获取优先攻击哪类目标 */
    GetTargetFirstAttack() {
        let [unLimit, npcFirst, roleFirst] = this.GetAttackFirstCookies()
        if (unLimit) {
            return Scene.FIND_TARGET_TYPE.all
        }
        if (npcFirst) {
            return Scene.FIND_TARGET_TYPE.monster
        }
        if (roleFirst) {
            return Scene.FIND_TARGET_TYPE.role
        }
        return Scene.FIND_TARGET_TYPE.all
    }

    /**登录后设置为上次挂机状态 */
    SceneStartRestoreAutoState() {
        let state = this.GetAutoFightStateCookie()
        if (!state) {
            return false
        }
        return state
    }

    /**挂机过程中，玩家点击地图或地面，保存下坐标，技能后摇结束后，前往该坐标 */
    CacheGoToPos(x?, y?, scene_id?) {
        if (x == null && y == null) {
            this.go_to_pos = false
        } else {
            this.go_to_pos = { "x": x, "y": y, "scene_id": scene_id }
        }
    }

    GetTempMode() {
        return this.is_temp_mode
    }

    SetTempMode(bool?) {
        if(this.is_temp_mode == bool) return
        if (bool) {
            Scene.GetInstance().user_manul_time = Status.NowTime
        }
        this.is_temp_mode = bool
        GlobalEventSystem.Fire(EventName.AUTO_FIGHT_TEMP_MODE)
    }

    SetFlyTalkNpcInfo(npc_id?, angle?) {
        this.fly_talk_npc_id = npc_id
        this.fly_talk_npc_angle = angle
    }

    ClearFlyTalkNpcInfo() {
        this.fly_talk_npc_id = 0
        this.fly_talk_npc_angle = 0
    }

    GetFlyTalkNpcId() {
        return this.fly_talk_npc_id
    }

    GetFlyTalkAngle() {
        return this.fly_talk_npc_angle
    }

    StartFieldSceneAutoFight() {
        let task_model = TaskModel.GetInstance()

        let task_vo = task_model.GetMainLineTaskVo()
        if (task_vo
            && task_model.IsCurrMainLineTaskTipType(TaskTipType.PassMainDungeon)
            && task_vo.task_id >= TaskModel.BRUSH_BOSS_TASK_ID
            && task_vo.scene_x != 0
            && task_vo.scene_y != 0
            && task_vo.scene_id != 0
        ) {
            let pos = [task_vo.scene_x, task_vo.scene_y]
            this.ChangeFieldScene(task_vo.scene_id, pos)
            return
        }

        let target_cfg = this.GetFieldSceneAutoFightCfg()
        if (target_cfg) {
            if (SceneManager.GetInstance().IsFieldScene()) {
                let pos_arr = JSON.parse(target_cfg.xy)
                if (pos_arr) {
                    let pos = pos_arr[Math.ceil(Math.random() * pos_arr.length) - 1]
                    if (pos) {
                        this.ChangeFieldScene(target_cfg.scene_id, pos)
                    }
                }
            } else {
                Message.show("当前场景不能前往")
            }
        } else {
            Message.show("没有合适的挂机区域哦~")
        }
    }

    ChangeFieldScene(scene_id, pos) {
        let task_model = TaskModel.GetInstance()
        pos[0] = Number(pos[0])
        pos[1] = Number(pos[1])
        let end_func = () => {
            AutoFightManager.GetInstance().SetAutoFight(true)
            task_model.monster_center_pos = null
            Scene.GetInstance().SetClickTarget(null)
        }
        let move_fun = () => {
            task_model.monster_center_pos = new Vector2(pos[0], pos[1])
            Scene.GetInstance().MainRoleMove(new Vector2(pos[0] / SceneObj.GetLogicRealRatio().x, pos[1] / SceneObj.GetLogicRealRatio().y), 0, end_func)
        }
        if (scene_id == SceneManager.GetInstance().GetSceneId()) {
            move_fun()
        } else {
            let change_scene_call = () => {
                move_fun()
            }
            GlobalEventSystem.Fire(SceneEventType.REQUEST_CHANGE_SCENE, Number(scene_id), pos[0], pos[1], 1, change_scene_call)
        }
    }

    GetFieldSceneAutoFightCfg() {
        let target_cfg = null
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_onhook
        if (cfg) {
            let level = RoleManager.GetInstance().mainRoleInfo.level
            let tmp = null
            for (let key in cfg) {
                tmp = cfg[key]
                if (level >= tmp.min_lv && level < tmp.max_lv) {
                    target_cfg = tmp
                    break
                }
            }
        }
        return target_cfg
    }

    NowAreaIsFitAutoFight() {
        let config_onhook = Config.PRELOAD_SERVER_CONFIG.config_onhook
        if (config_onhook) {
            let is_fit = false
            let cfg = null
            let main_role = Scene.GetInstance().main_role
            let logic_pos = main_role.GetLogicPos()
            let level = main_role.vo.level
            let pos_arr = null
            let distance = null
            let [monster_list, role_list] = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, 0, null, 10000, null, null, null)
            for (let key in config_onhook) {
                cfg = config_onhook[key]
                if (level >= cfg.min_lv && level < cfg.max_lv) {
                    if (monster_list && monster_list.length > 0 && monster_list[1].vo && monster_list[1].vo.type_id == cfg.name) {
                        is_fit = true
                    }
                    if (!is_fit) {
                        pos_arr = JSON.parse(cfg.xy)
                        if (pos_arr) {
                            for (let _tmpi in pos_arr) {
                                var vo = pos_arr[_tmpi]
                                distance = GameMath.GetDistance(logic_pos.x, logic_pos.y, vo[1] / SceneObj.GetLogicRealRatio().x, vo[2] / SceneObj.GetLogicRealRatio().y, true)
                                if (distance < 10) {
                                    is_fit = true
                                    break
                                }
                            }
                        }
                    }
                    if (is_fit) {
                        break
                    }
                }
            }
            return is_fit
        }
    }
}

window["AutoFightManager"] = AutoFightManager