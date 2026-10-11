import { NowOperate } from "./NowOperate";
import { OperateType } from "./OperateManager";
import { Vector2 } from "../util/Vector2";
import { Status } from "../util/Status";
import { GlobalEventSystem, LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar";
import { SceneEventType } from "../common/EventName";
import { SceneManager } from "../scene/SceneManager";
import { Scene } from "../scene/Scene";
// TypeScript file
let global_event = GlobalEventSystem;
export class NowOperateMove extends NowOperate {
    type = OperateType.Move;
    start_pos;
    end_pos: Vector2;
    move_end_time = Status.NowTime;
    is_end = false;
    move_end_handle;
    change_scene_handle;
    is_already_do_move = false; //是否已经执行移动操作
    update_func
    public constructor(start_time, start_pos, end_pos, update_func) {
        super(start_time);
        this.type = OperateType.Move;
        this.start_pos = start_pos;
        this.end_pos = end_pos;
        this.update_func = update_func
        this.move_end_time = Status.NowTime;
        this.is_end = false;
        this.is_already_do_move = false; //是否已经执行移动操作
    }
    public DeleteMe() {
        super.DeleteMe();
        if (this.move_end_handle) {
            global_event.UnBind(this.move_end_handle);
        }
        if (this.change_scene_handle) {
            global_event.UnBind(this.change_scene_handle);
        }
        this.update_func = undefined
    }
    public Init() {
        //先检测能否立即移动再执行该操作
        this.DoMoveAction();
        return true;
    }
    public DoMoveAction() {
        let self = this;
        self.is_already_do_move = true;
        //监听主角移动结束
 
        let move_end_callback = () => {
            self.is_end = true;
            global_event.UnBind(self.move_end_handle);
            delete self.move_end_handle;
        };
        //切换场景的时候，也要结束当前操作包
        let change_scene_func = () => {
            self.is_end = true;
            global_event.UnBind(self.change_scene_handle);
            delete self.change_scene_handle;
        };
        self.move_end_handle = global_event.Bind(SceneEventType.MAIN_ROLE_MOVE_END, move_end_callback);
        self.change_scene_handle = global_event.Bind(SceneManager.START, change_scene_func);
        //主角开始移动
        let main_role = Scene.GetInstance().GetMainRole();
        main_role.DoMove(new Vector2(self.end_pos.x * LogicRealRatio_X, self.end_pos.y * LogicRealRatio_Y));
    }
    public ExcuteImpl(elaspe_time) {
        //如果还未执行移动操作，则在合适的时间执行该操作
        if (!this.is_already_do_move) {
            this.DoMoveAction();
        }
        return this.is_end;
    }
    public Update(elaspe_time){
        if(this.update_func && typeof(this.update_func) == "function"){
            this.update_func()
        }
    }
}

window["NowOperateMove"] = NowOperateMove