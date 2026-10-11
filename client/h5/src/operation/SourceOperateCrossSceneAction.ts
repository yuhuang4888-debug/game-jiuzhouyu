import { SourceOperate } from "./SourceOperate";
import { SourceOperateType } from "./OperateManager";
import { SceneManager } from "../scene/SceneManager";
import { Status } from "../util/Status";
import { Scene } from "../scene/Scene";
import { SourceOperateMove } from "./SourceOperateMove";
import { Vector2 } from "../util/Vector2";
import { LogicRealRatio_X, LogicRealRatio_Y, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SceneEventType, EventName } from "../common/EventName";
// TypeScript file
export class SourceOperateCrossSceneAction extends SourceOperate {
    type = SourceOperateType.CrossScene;
    init_time = 0;
    src_scene_id = SceneManager.Instance.GetSceneId();
    target_scene_id;
    target_scene_pos;
    change_scene_callback;
    action_func;
    arg_list;
    is_path_valid = false;
    path_list;
    now_move_src_oper;
    scene_path: Array<any>;
    now_scene_id;
    public constructor(scene_id, end_pos, change_scene_callback, action_func, arg_list) {
        super();
        this.type = SourceOperateType.CrossScene;
        this.init_time = 0;
        this.src_scene_id = SceneManager.Instance.GetSceneId();
        this.target_scene_id = scene_id;
        this.target_scene_pos = end_pos;
        this.change_scene_callback = change_scene_callback;
        this.action_func = action_func;
        this.arg_list = arg_list;
        this.is_path_valid = false;
        this.path_list = null;
        this.now_move_src_oper;
        this.scene_path = null;
        this.now_scene_id = null;
    }
    public DeleteMe() {
        if (this.now_move_src_oper) {
            this.now_move_src_oper.DeleteMe();
            this.now_move_src_oper = false;
        }
    }
    public Init() {
        this.init_time = Status.NowTime;
        let target_scene_info = SceneManager.GetInstance().GetSceneInfo(this.target_scene_id);
        if (!target_scene_info) {
            return false;
        }
        // this.scene_path = SceneConnectMap.Instance.FindPath(this.src_scene_id, this.target_scene_id)
        // if (List.Empty(this.scene_path))
        // {
        //     return false
        // }
        // return true
    }
    public ClearNowMoveSrcOper() {
        if (this.now_move_src_oper) {
            this.now_move_src_oper.DeleteMe();
            this.now_move_src_oper = false;
        }
    }
    public GetOperImpl() {
        let now_scene_id = SceneManager.Instance.GetSceneId();
        //由于现在走到传送门附近就会触发传送，所以可能now_move_src_oper还没完成，就传到另一个场景，导致主角卡住不动了
        //切换了场景，就要删掉
        if (this.now_scene_id != now_scene_id) {
            this.ClearNowMoveSrcOper();
        }
        if (this.now_move_src_oper && !this.now_move_src_oper.IsFinish()) {
            return this.now_move_src_oper.GetOper();
        }
        if (this.src_scene_id != now_scene_id && this.change_scene_callback) {
            let is_finish = this.change_scene_callback(now_scene_id);
            if (is_finish != null && is_finish == true) {
                this.is_finish = true; //由外部来终止这个操作包
                return this.GenerateNop(0.2);
            }
        }
        if (this.now_scene_id == now_scene_id) {
            return this.GenerateNop(0.2);
        }
        else if (!Scene.GetInstance().IsSceneLoaded()) {
            return this.GenerateNop(0.2);
        }
        if (this.target_scene_id == now_scene_id) {
            if (this.target_scene_pos) {
                this.now_move_src_oper = new SourceOperateMove(this.target_scene_pos, null);
                this.target_scene_pos = null;
            }
            else {
                this.is_finish = true;
                if (this.action_func) {
                    this.action_func(this.arg_list);
                }
                return this.GenerateNop(0.2);
            }
        }
        else {
            if (this.scene_path == null) {
                return null;
            }
            let path_now_scene_id = this.scene_path.shift();
            if (path_now_scene_id != now_scene_id) {
                this.is_finish = true;
                return this.GenerateNop(0.2);
            }
            let now_target_scene_id = this.scene_path[0];
            let door_info = SceneManager.Instance.GetSceneDoorInfo(now_target_scene_id, path_now_scene_id);
            if (!door_info) {
                this.is_finish = true;
                return this.GenerateNop(0.2);
            }
            this.now_scene_id = now_scene_id;
            let door_pos = new Vector2(door_info.x / LogicRealRatio_X, door_info.y / LogicRealRatio_Y);
            let cross_scene_req = () => {
                // EventSystem.Fire(GlobalEventSystem,SceneEventType.REQUEST_CHANGE_SCENE, door_info.id)
                GlobalEventSystem.Fire(SceneEventType.BROADCAST_CROSS_SCENE, door_info.id);
            };
            this.now_move_src_oper = new SourceOperateMove(door_pos, cross_scene_req, this.arg_list);
            GlobalEventSystem.Fire(EventName.FINDWAY_STARTED);
        }
        return this.now_move_src_oper.GetOper();
    }
}

window["SourceOperateCrossSceneAction"] = SourceOperateCrossSceneAction