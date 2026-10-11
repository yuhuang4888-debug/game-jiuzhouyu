import { Vector2 } from "../util/Vector2";
import { Runner } from "../util/Runner";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SceneManager } from "../scene/SceneManager";
import { Scene } from "../scene/Scene";
import { SourceOperateCrossSceneAction } from "./SourceOperateCrossSceneAction";
import { SourceOperateMove } from "./SourceOperateMove";
import { SourceOperateTargetAction } from "./SourceOperateTargetAction";
import { BaseClass } from "../common/BaseClass";
import { EventName, SceneEventType } from "../common/EventName";
import { AreaDataIndex } from "../scene/SceneConfig";
// TypeScript file
export class PathPoint {
    public start_point: Vector2;
    public end_point: Vector2;
    length:number
    dir:Vector2
    moved:number
    entered:boolean
    public constructor(start_point?: Vector2, end_point?: Vector2) {
        this.start_point = start_point;
        this.end_point = end_point;
    }
}
export enum OperateType {
    Unknown = 0,
    Move = 1,
    Attack = 2,
    Skill = 3
}
export enum SourceOperateType {
    Unknown = 1,
    Move = 2,
    CrossScene = 3,
    TargetAction = 4
}
window["PathPoint"] = PathPoint;
window["OperateType"] = OperateType;
window["SourceOperateType"] = SourceOperateType;
export class OperateManager extends BaseClass {
    //当前阶段是否需要运行
    need_run: Boolean = true;
    source_oper;
    now_oper;
    enter_playing_handle;
    quit_playing_handle;
    //最小移动周期
    min_move_tip_time = 0.3;
    jump_point_obj; //跳点对象
    not_fire_clear_event = false; //寻路过程中是否发送操作包已清除事件
    current_target_pos = new Vector2(0, 0);
    jump_end_not_continue
    public constructor() {
        super();
        Runner.GetInstance().AddRunObj(this, 1);
        this.InitEvent();
    }
    static Instance: OperateManager;
    public static GetInstance() {
        if (!OperateManager.Instance) {
            OperateManager.Instance = new OperateManager();
        }
        return OperateManager.Instance;
    }
    public InitEvent = () => {
        let on_scene_start_handler = () => {
            this.need_run = true;
        };
        GlobalEventSystem.Bind(SceneManager.START, on_scene_start_handler);
        let on_scene_dispose_handler = () => {
            this.need_run = false;
        };
        GlobalEventSystem.Bind(SceneManager.DISPOSE, on_scene_dispose_handler);
    };
    public Update = (now_time, elapse_time) => {
        let self = this;
        if (!self.need_run) {
            return;
        }
        if (self.source_oper) {
            if (!self.now_oper) {
                if (self.source_oper.IsFinish()) {
                    let next_target = self.source_oper.GetNextTarget();
                    let cross_scene = self.source_oper.GetCrossScene();
                    let source_oper = self.source_oper
                    source_oper.DeleteMe();
                    self.source_oper = null;
                    if(source_oper.type == SourceOperateType.Move){
                        GlobalEventSystem.DelayFire(SceneEventType.MAIN_ROLE_PATH_FINISHED, source_oper.id)
                    }

                    if (next_target) {
                        self.StartMoveAction(next_target.target, next_target.func, null, next_target.arg);
                    }
                    if (cross_scene) {
                        self.StartCrossSceneAction(cross_scene.id, cross_scene.pos, cross_scene.change_scene_callback, cross_scene.action_func, cross_scene.arg_list);
                    }
                }
                else {
                    self.now_oper = self.source_oper.GetOper();
                }
            }
        }
        if (self.now_oper) {
            if (self.now_oper.Excute(elapse_time)) {
                if (self.now_oper) {
                    self.now_oper.DeleteMe();
                    self.now_oper = null;
                }
            }
            else{
                if(self.now_oper.Update)
                    self.now_oper.Update()
            }
            return;
        }
    };
    public ClearSrcOper = (clear_now_scene?) => {
        if (clear_now_scene && this.source_oper && this.source_oper.type == SourceOperateType.CrossScene) {
            this.source_oper.ClearNowMoveSrcOper();
        }
        else {
            let source_oper = this.source_oper
            if (source_oper) {
                source_oper.DeleteMe();
                this.source_oper = null;
                if(source_oper.type == SourceOperateType.Move){
                    GlobalEventSystem.DelayFire(SceneEventType.MAIN_ROLE_PATH_FINISHED, source_oper.id)
                }
            }
        }
        if (this.now_oper) {
            this.now_oper.DeleteMe();
            this.now_oper = null;
        }
    };
    public IsNoOperWork = () => {
        return !this.source_oper && !this.now_oper;
    };
    public GetNowSrcOper = () => {
        return this.source_oper;
    };
    public StopMove = (clear_now_scene?) => {
        let main_role = Scene.GetInstance().GetMainRole();
        main_role.WaitForNextMove();
        this.ClearSrcOper(clear_now_scene);
    };
    public IsNearJumpArea = (point) => {
        let check = function (x_a, y_a) {
            let cur_pos_x = point.x + x_a;
            let cur_pos_y = point.y + y_a;
            let is_jump = SceneManager.GetInstance().IsAreaType(cur_pos_x, cur_pos_y, AreaDataIndex.JumpType);
            if (is_jump) {
                return true;
            }
        };
        if (check(0, 0) || check(1, 0) || check(0, 1) || check(-1, 0) || check(0, -1) || check(1, -1) || check(1, 1) || check(-1, 1) || check(-1, -1)) {
            return true;
        }
        return false;
    };
    public CurSourceOper = () => {
        let after_jump_data;
        let oper_type;
        if (this.source_oper) {
            oper_type = this.source_oper.type;
            if (oper_type == SourceOperateType.CrossScene) {
                after_jump_data = {
                    oper_type: oper_type,
                    target_scene_id: (this.source_oper as SourceOperateCrossSceneAction).target_scene_id,
                    target_scene_pos: (this.source_oper as SourceOperateCrossSceneAction).target_scene_pos,
                    change_scene_callback: (this.source_oper as SourceOperateCrossSceneAction).change_scene_callback,
                    action_func: (this.source_oper as SourceOperateCrossSceneAction).action_func,
                    arg_list: (this.source_oper as SourceOperateCrossSceneAction).arg_list
                };
            }
            else if (oper_type == SourceOperateType.Move) {
                if ((this.source_oper as SourceOperateMove).end_pos.x && (this.source_oper as SourceOperateMove).end_pos.y) {
                    after_jump_data = {
                        oper_type: oper_type,
                        end_pos: (this.source_oper as SourceOperateMove).end_pos,
                        action_func: (this.source_oper as SourceOperateMove).action_func,
                        arg_list: (this.source_oper as SourceOperateMove).arg_list
                    };
                }
            }
            this.ClearSrcOper();
        }
        return after_jump_data
    };
    public StartMoveAction = (end_pos, action_func, update_func,  ...other) => {
        this.ClearSrcOper();
        this.source_oper = new SourceOperateMove(end_pos, action_func, update_func, other);
        GlobalEventSystem.DelayFire(SceneEventType.MAIN_ROLE_PATH_START, this.source_oper.id)
    };
    public StartInitedMoveAction = (path, action_func, ...other) => {
        this.ClearSrcOper();
        this.source_oper = new SourceOperateMove(null, action_func, other);
        this.source_oper.SetPathList(path);
    };
    public StartTargetAction = (target_compress_id, range, action_func, action_period_func?, action_end_func?, clear_func?) => {
        this.ClearSrcOper();
        this.source_oper = new SourceOperateTargetAction(target_compress_id, range, action_func, action_period_func, action_end_func, clear_func);
        return true;
    };
    public StartCrossSceneAction = (scene_id, end_pos, change_scene_callback, action_func, ...other) => {
        this.ClearSrcOper();
        this.source_oper = new SourceOperateCrossSceneAction(scene_id, end_pos, change_scene_callback, action_func, other);
        return true;
    };
    public JumpEndHandler(){ 
	
        if (this.jump_end_not_continue ) { 
            this.ClearSrcOper()
            GlobalEventSystem.Fire(EventName.FINDWAY_ENDED)
            this.jump_end_not_continue = false
            return 
        }
        let after_jump_data = this.CurSourceOper()
        // console.warn("------JumpEndHandler------", after_jump_data)
        if (after_jump_data) {
            if (after_jump_data.oper_type == SourceOperateType.Move) {
                let end_pos = after_jump_data.end_pos
                if (!SceneManager.GetInstance().IsAreaType(end_pos.x, end_pos.y, AreaDataIndex.JumpType) ) {				
                    // console.warn("------跳完后继续寻路------")
                    this.StartMoveAction(after_jump_data.end_pos, after_jump_data.action_func, null, after_jump_data.arg_list)
                }
            }else{
                this.StartCrossSceneAction(after_jump_data.target_scene_id, after_jump_data.target_scene_pos, after_jump_data.change_scene_callback, after_jump_data.action_func, after_jump_data.arg_list)	
            }
        }
    }
}

window["OperateManager"] = OperateManager