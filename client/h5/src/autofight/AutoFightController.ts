import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName, SceneEventType } from "../common/EventName"
import { OperateManager } from "../operation/OperateManager"
import { SourceOperateMove } from "../operation/SourceOperateMove"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { FLY_SHOE_DISTANCE, MOVE_TYPE } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { Role } from "../scene/sceneobj/Role"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { Vector2 } from "../util/Vector2"
import { AutoFightManager } from "./AutoFightManager"
let local_GlobalEventSystem = GlobalEventSystem
let local_EventName = EventName
export class AutoFightController extends BaseController {
    fly_data
    last_fly_pos
    auto_fight_mgr:AutoFightManager

    public constructor() {
        super()
        this.auto_fight_mgr = AutoFightManager.GetInstance()
        this.fly_data = {}
        this.InitEvents()
    }

    public InitEvents(){
        var findway_ended_func = () => {
            this.auto_fight_mgr.SetAutoFindWay(false)
        }
        var findway_started_func = () => {
            this.auto_fight_mgr.SetAutoFindWay(true)
        }
        local_GlobalEventSystem.Bind(local_EventName.FINDWAY_ENDED, findway_ended_func)
        local_GlobalEventSystem.Bind(local_EventName.FINDWAY_STARTED, findway_started_func)

        //监听玩家摇杆和键盘操作
        var joy_stick_dragend = () => {
            if (Scene.Instance.main_role && this.auto_fight_mgr.GetAutoFightState()) {
                this.auto_fight_mgr.CacheAutoFightPos()
                this.auto_fight_mgr.CacheGoToPos()
                findway_ended_func()
                // Scene.Instance.CheckCancelCurrClickTarget()
            }
        }
        //GlobalEventSystem:Bind(UIJoyStick.EVENT_TOUCH_END, joy_stick_dragend)


        var onSceneStart = () => {  
            //切换地图后，新地图的初始位置为新的挂机点
            if (this.auto_fight_mgr.GetAutoFightState()) {
                this.auto_fight_mgr.CacheAutoFightPos()
            }
            let main_role = Scene.Instance.GetMainRole()
            if (this.auto_fight_mgr.next_fly_pos) {
                console.log("----------------next_fly_pos", SceneManager.GetInstance().IsBlockXY(this.auto_fight_mgr.next_fly_pos.x / SceneObj.GetLogicRealRatio().x, this.auto_fight_mgr.next_fly_pos.y / SceneObj.GetLogicRealRatio().y), this.auto_fight_mgr.next_fly_pos.x / SceneObj.GetLogicRealRatio().x, this.auto_fight_mgr.next_fly_pos.y / SceneObj.GetLogicRealRatio().y)
                if (SceneManager.GetInstance().IsBlockXY(this.auto_fight_mgr.next_fly_pos.x / SceneObj.GetLogicRealRatio().x, this.auto_fight_mgr.next_fly_pos.y / SceneObj.GetLogicRealRatio().y)) {
                    let sceneInfo = SceneManager.GetInstance().GetSceneInfo()
                    if (sceneInfo && sceneInfo.x && sceneInfo.y) {
                        let data = SourceOperateMove.FindFastestPos(new Vector2(Number(sceneInfo.x), Number(sceneInfo.y)), new Vector2(this.auto_fight_mgr.next_fly_pos.x, this.auto_fight_mgr.next_fly_pos.y), 100)
                        this.auto_fight_mgr.next_fly_pos.x = data.x
                        this.auto_fight_mgr.next_fly_pos.y = data.y
                    }
                }

                main_role.SetRealPos(this.auto_fight_mgr.next_fly_pos.x, this.auto_fight_mgr.next_fly_pos.y, true)
                local_GlobalEventSystem.Fire(SceneEventType.MOVEREQUEST, this.auto_fight_mgr.next_fly_pos.x, this.auto_fight_mgr.next_fly_pos.y, MOVE_TYPE.BLINK)
                if (this.fly_data.callback) {
                    this.fly_data.callback()
                    this.fly_data.callback = null
                }
                this.auto_fight_mgr.next_fly_pos = null
            }
        }
        local_GlobalEventSystem.Bind(SceneManager.START, onSceneStart)

        var use_fly_shoe = (scene_id, x, y, callback) => {
            this.FlyToPos(scene_id, x, y, callback)
        }
        local_GlobalEventSystem.Bind(local_EventName.USE_FLY_SHOE, use_fly_shoe)

        let success_return = () => {
            this.MainRoleFly()
        }
        local_GlobalEventSystem.Bind(SceneEventType.REQUEST_USE_FLY_SHOE_RETURN, success_return)
    }

    //飞鞋请求
    FlyToPos(scene_id, x, y, callback?){
        let main_role = Scene.Instance.GetMainRole()
        let vo
        vo = {}
        vo.scene_id = scene_id
        if (!SceneManager.GetInstance().IsCanUseFlyShoeScene()) {
            Message.show("非主城和野外安全区，不能使用飞鞋")
            return
        }

        if (main_role) {
            let main_role_buff = main_role.buff_manager
            if (main_role_buff && main_role_buff.CheckBuffControl()) {
                Message.show("当前状态不能传送")
                return
            }
        }

        this.fly_data.scene_id = scene_id
        this.fly_data.x = x
        this.fly_data.y = y
        this.fly_data.callback = callback

        this.MainRoleFly()
    }

    MainRoleFly(){
        OperateManager.Instance.StopMove(true)
        local_GlobalEventSystem.Fire(local_EventName.FINDWAY_ENDED)

        let scene_id = SceneManager.Instance.GetSceneId()
        let main_role = Scene.Instance.GetMainRole()
        if (!this.fly_data || !this.fly_data.x || !this.fly_data.y) {
            return
        }

        let pos = new Vector2(this.fly_data.x, this.fly_data.y)
        let distance = GameMath.GetDistance(pos.x, pos.y, main_role.real_pos.x, main_role.real_pos.y, true)
        this.auto_fight_mgr.next_fly_pos = null
        this.auto_fight_mgr.is_flying_shoe = true

        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo
        if (this.fly_data.scene_id == scene_id) {
            let start_height = 0 
            let end_height = 0
            if (distance <= FLY_SHOE_DISTANCE.NormalMoveDistance && (end_height - start_height) < 8) { // 直接走过去
                let findVo = new FindVo()
                findVo.type = FindVo.POINT
                findVo.sceneId = SceneManager.Instance.GetSceneId()
                findVo.id = 0
                findVo.x = pos.x / SceneObj.GetLogicRealRatio().x
                findVo.y = pos.y / SceneObj.GetLogicRealRatio().y
                findVo.call_back = this.fly_data.callback
                local_GlobalEventSystem.Fire(local_EventName.FIND, findVo)
                console.log("普通走路")
                //距离大于三段跳、或者高度相差太多、或者是将神
            } else if (distance > FLY_SHOE_DISTANCE.ThreeJumpDistance || RoleManager.Instance.mainRoleInfo.god_id > 0 || (end_height - start_height) > 5) {  //直接飞过去
                this.last_fly_pos = pos

                let second_callback = (...new_args) => {
                    if (pos.x == this.last_fly_pos.x && pos.y == this.last_fly_pos.y) {
                        if (this.fly_data.callback) {
                            this.fly_data.callback()
                        }
                        if (main_role.need_dead_after_fly_shoe) {
                            setTimeout(() => {
                                main_role.need_dead_after_fly_shoe = false
                                //这里需要重置下is_dead 因为之前可能变为true 导致进不去死亡状态
                                main_role.is_dead = false
                                main_role.ForceDoDead()
                            }, 100)
                        }
                    }
                }

                let first_callback = () => {
                    main_role.DoFlyShoeEffect(pos, 1, second_callback)
                    setTimeout(() => {
                        main_role.SetFollowObjShowState(true, SceneObj.ModelHideFlag.IndependentHide)
                    }, 500)
                }

                main_role.SetFollowObjShowState(false, SceneObj.ModelHideFlag.IndependentHide)
                main_role.DoFlyShoeEffect(pos, 2, first_callback)
            } else if (FLY_SHOE_DISTANCE.NormalMoveDistance < distance && distance <= FLY_SHOE_DISTANCE.TwoJumoDistance) {  //两段跳
                let add_speed = 0
                if (end_height - start_height > 0) {
                    add_speed = Math.floor(end_height - start_height) * 100
                }

                let move_vspeed = cfg.jump_vspeed[Role.MULTI_JUMP_TYPE.Jump_4]
                local_GlobalEventSystem.Fire(SceneEventType.TASK_MUL_JUMP, Role.MULTI_JUMP_TYPE.Jump_4, pos, this.fly_data.callback, move_vspeed + add_speed)
            } else if (FLY_SHOE_DISTANCE.TwoJumoDistance < distance && distance <= FLY_SHOE_DISTANCE.ThreeJumpDistance) {  //三段跳
                let add_speed = 0
                if (end_height - start_height > 0) {
                    add_speed = Math.floor(end_height - start_height) * 100
                }
                let move_vspeed = cfg.jump_vspeed[Role.MULTI_JUMP_TYPE.Jump_5]
                local_GlobalEventSystem.Fire(SceneEventType.TASK_MUL_JUMP, Role.MULTI_JUMP_TYPE.Jump_5, pos, this.fly_data.callback, move_vspeed + add_speed)
            }
        } else {
            let scene_id = this.fly_data.scene_id
            if (scene_id != 0) {
                local_GlobalEventSystem.Fire(SceneEventType.REQUEST_CHANGE_SCENE, Number(scene_id), pos.x, pos.y, 1)
                this.auto_fight_mgr.next_fly_pos = pos
            }
        }
    }
}
window["AutoFightController"] = AutoFightController