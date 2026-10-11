import { SourceOperateMove } from "./SourceOperateMove";
import { SourceOperateType } from "./OperateManager";
import { LogicRealRatio_Z, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Scene } from "../scene/Scene";
import { MOVE_TYPE } from "../scene/SceneConfig";
import { Status } from "../util/Status";
import { SceneEventType } from "../common/EventName";
import { GameMath } from "../util/GameMath";
import { NowOperateTargetMove } from "./NowOperateTargetMove";
// TypeScript file
export class SourceOperateTargetAction extends SourceOperateMove {
    type = SourceOperateType.TargetAction;
    init_time = 0;
    target_compress_id;
    range;
    action_func;
    action_period_func;
    action_end_func;
    clear_func;
    is_path_valid = false;
    path_list;
    total_pair = 0;
    //最后一次动作时间
    last_action_time = 0;
    public constructor(target_compress_id, range, action_func, action_period_func, action_end_func, clear_func) {
        super(null, null, null);
        this.type = SourceOperateType.TargetAction;
        this.init_time = 0;
        this.target_compress_id = target_compress_id;
        this.range = Math.max(range, LogicRealRatio_Z);
        this.action_func = action_func;
        this.action_period_func = action_period_func;
        this.action_end_func = action_end_func;
        this.clear_func = clear_func ? clear_func : false;
        this.is_path_valid = false;
        this.path_list = null;
        this.total_pair = 0;
        //最后一次动作时间
        this.last_action_time = 0;
    }
    public DeleteMe() {
        if (this.clear_func) {
            this.clear_func();
        }
    }
    public GetTargetObj() {
        return Scene.GetInstance().GetObjByCompressedId(this.target_compress_id);
    }
    public Init() {
        this.init_time = Status.NowTime;
        this.path_list = [];
        //查看目标对象是否在场景中
        let obj = this.GetTargetObj();
        if (obj == null) {
            //print("SourceOperateTargetAction:Init can not find target obj")
            return false;
        }
        //print("target action init suc!")
        return true;
    }
    public GetOperImpl() {
        //print("excute target action")
        let now_oper = null;
        let now_time = Status.NowTime;
        //判断目标对象是否已经不存在
        let target_obj = this.GetTargetObj();
        if (target_obj == null) {
            this.is_finish = true;
            //print("target action can not find target!")
            GlobalEventSystem.Fire(SceneEventType.ACTION_TARGET_MISSING);
            return this.GenerateNop(0.2);
        }
        //重新以主角当前位置作为寻路起始位置
        let main_role = Scene.GetInstance().GetMainRole(), 
        //当前的起始坐标和终点坐标，必须用RealPos计算才能准确
        start_logic_pos = main_role.GetLogicPos(), end_logic_pos = target_obj.GetLogicPos(), x1 = main_role.x, y1 = main_role.y, x2 = target_obj.x, y2 = target_obj.y, distance = GameMath.GetDistance(x1, y1, x2, y2, false);
        //距离在可动作范围内
        if (distance <= this.range * this.range) {
            //在这停止移动
            if (main_role.move_flag == MOVE_TYPE.ACCELERATE) {
                GlobalEventSystem.Fire(SceneEventType.MOVEREQUEST, x1, y1, MOVE_TYPE.ACCELERATE);
            }
            else {
                GlobalEventSystem.Fire(SceneEventType.MOVEREQUEST, x1, y1, MOVE_TYPE.NORMOL_MOVE);
            }
            main_role.SetDirection(start_logic_pos, end_logic_pos);
            main_role.WaitForNextMove();
            this.action_func(); //执行相关动作
            this.last_action_time = Status.NowTime;
            now_oper = this.GenerateNop(0.2);
            this.is_finish = true;
        }
        else {
            this.path_list = [];
            if (!this.RecalcPathInfo(start_logic_pos, end_logic_pos, 0)) {
                this.is_finish = true;
                return this.GenerateNop(0.2); //计算路径失败直接停止该操作包(怪卡障碍点或者自己卡障碍点)
            }
            //取出下一个小路径执行
            let move_pair = this.path_list[this.now_use_pair - 1];
            if (move_pair == null) {
                this.is_finish = true;
                return this.GenerateNop(0.2);
            }
            now_oper = new NowOperateTargetMove(now_time, move_pair.start_point, move_pair.end_point, target_obj, this.range);
            this.now_use_pair = this.now_use_pair + 1;
        }
        return now_oper;
    }
}

window["SourceOperateTargetAction"] = SourceOperateTargetAction