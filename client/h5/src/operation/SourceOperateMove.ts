import { SourceOperate } from "./SourceOperate";
import { Vector2 } from "../util/Vector2";
import { LogicRealRatio_X, LogicRealRatio_Y, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager";
import { MapManager } from "../scene/MapManager";
import { PathPoint, SourceOperateType } from "./OperateManager";
import { EventName, SceneEventType } from "../common/EventName";
import { Status } from "../util/Status";
import { NowOperateMove } from "./NowOperateMove";
// TypeScript file
export class SourceOperateMove extends SourceOperate {
    static start_logic_pos = new Vector2();
    static end_logic_pos = new Vector2();
    static dir = new Vector2();
    public static MoveType = {
        MoveToTarget: 1,
        MoveToDirection: 2,
        InitedPath: 3,
    };
    public static operate_move_id = 0;
    //沿着两个点的方向寻找离起点最近的一个非障碍点  start_pos,end_pos为真实像素点
    public static FindNearestPos(start_pos, end_pos, jump_state?) {
        let start_logic_pos = new Vector2(start_pos.x / LogicRealRatio_X, start_pos.y / LogicRealRatio_Y);
        let end_logic_pos = new Vector2(end_pos.x / LogicRealRatio_X, end_pos.y / LogicRealRatio_Y);
        let tem_dir = new Vector2(end_logic_pos.x - start_logic_pos.x, end_logic_pos.y - start_logic_pos.y);
        let dist = tem_dir.normalise();
        let r = Scene.GetInstance().DetectLastUnblockPoint(new Vector2(start_logic_pos.x, start_logic_pos.y), new Vector2(tem_dir.x, tem_dir.y), dist); //dist是逻辑坐标系的
        if (r.z == 1) {
            return [r.x * LogicRealRatio_X, r.y * LogicRealRatio_Y];
        }
        return [end_pos.x, end_pos.y];
    }
    //沿着两个点的方向寻找离起点最远的一个非障碍点  start_pos,end_pos为真实像素点
    public static FindFastestPos(start_pos, end_pos, user_len = 20) {
        let len = user_len
        let tem_dir = null;
        let dist = null;
        tem_dir = new Vector2(start_pos.x - end_pos.x, start_pos.y - end_pos.y);
        dist = tem_dir.normalise();
        if (!user_len) {
            len = Math.ceil(dist / 60);
        }
        let x = 0;
        let y = 0;
        for (let i = 1; i <= len; i++) {
            x = end_pos.x + tem_dir.x * i / len * dist;
            y = end_pos.y + tem_dir.y * i / len * dist;
            if (!SceneManager.GetInstance().IsBlockXY(Math.floor(x / LogicRealRatio_X), Math.floor(y / LogicRealRatio_Y))) {
                let result = true;
                if (i >= (len - 1)) {
                    result = false;
                }
                else {
                    //退后一格
                    x = x + tem_dir.x * LogicRealRatio_X; // * 0.5
                    y = y + tem_dir.y * LogicRealRatio_Y; // * 0.5
                }
                return { x: x, y: y, result: result };
            }
        }
        return { x: start_pos.x, y: start_pos.y, result: false };
    }
    public static FindNoBlockPos(now_pos) {
        now_pos = new Vector2(Math.floor(now_pos.x), Math.floor(now_pos.y));
        let width = Math.floor(MapManager.GetInstance().GetSceneWidth() / LogicRealRatio_X);
        let height = Math.floor(MapManager.GetInstance().GetSceneHeight() / LogicRealRatio_Y);
        if (now_pos.x < 0) {
            now_pos.x = 0;
        }
        else if (now_pos.x > width) {
            now_pos.x = width;
        }
        if (now_pos.y < 0) {
            now_pos.y = 0;
        }
        else if (now_pos.y > height) {
            now_pos.y = height;
        }
        let max_offset = Math.max(Math.ceil(width / 2), Math.ceil(height / 2));
        let new_pos = null;
        let offset = 0;
        while (offset < max_offset) {
            offset = offset + 1;
            for (let x = now_pos.x - offset; x < now_pos.x + offset; x++) {
                //上
                let y = now_pos.y - offset;
                if (y >= 0 && !SceneManager.GetInstance().IsBlockXY(x, y)) {
                    new_pos = new Vector2(x, y);
                    break;
                }
                //下
                y = now_pos.y + offset;
                if (y < height && !SceneManager.GetInstance().IsBlockXY(x, y)) {
                    new_pos = new Vector2(x, y);
                    break;
                }
            }
            if (new_pos != null) {
                break;
            }
            for (let y = now_pos.y - offset + 1; y < now_pos.y + offset - 1; y++) {
                //左
                let x = now_pos.x - offset;
                if (x >= 0 && !SceneManager.GetInstance().IsBlockXY(x, y)) {
                    new_pos = new Vector2(x, y);
                    break;
                }
                //右
                x = now_pos.x + offset;
                if (x < width && !SceneManager.GetInstance().IsBlockXY(x, y)) {
                    new_pos = new Vector2(x, y);
                    break;
                }
            }
            if (new_pos != null) {
                break;
            }
        }
        if (new_pos) {
            new_pos.x = new_pos.x + 0.5;
            new_pos.y = new_pos.y + 0.5;
        }
        return new_pos;
    }
    public FindNoBlockPath(start_logic_pos: Vector2, end_logic_pos: Vector2) {
        let logic_dir = end_logic_pos.getDir(start_logic_pos);
        let max_dist = logic_dir.normalise();
        let r = Scene.GetInstance().DetectFirstUnblockPoint(new Vector2(start_logic_pos.x, start_logic_pos.y), new Vector2(logic_dir.x, logic_dir.y), max_dist);
        return r;
    }
    // static temp_path_list: Array<PathPoint> = [];
    public static FindPathList(start_pos, end_pos, range, temp_path_list?, is_main_role?) {
        let path_info = Scene.GetInstance().FindWay(start_pos.x, start_pos.y, end_pos.x, end_pos.y, range);
        if (!path_info) {
            return { result: false, path_list: [] };
        }
        let path_list;
        if(temp_path_list){
            path_list = temp_path_list
        }
        else{
            path_list = [];
        }
        let is_path_valid = false;
        let total_point = path_info.length;
        if (total_point >= 2) {
            is_path_valid = true;
            //将返回的路径转换为起点终点对的形式,方便使用
            let tmp_start_pos = path_info[total_point - 1];
            let now_index = total_point - 2;
            let now_pair: PathPoint;
            let tmp_end_pos;
            let index = 0;
            while (now_index >= 0) {
                tmp_end_pos = path_info[now_index];
                now_pair = path_list[index];
                if (now_pair) {
                    now_pair.start_point = tmp_start_pos;
                    now_pair.end_point = tmp_end_pos;
                }
                else {
                    now_pair = new PathPoint(tmp_start_pos, tmp_end_pos);
                    path_list[index] = now_pair;
                }
                // path_list.push(now_pair)
                --now_index;
                ++index;
                tmp_start_pos = tmp_end_pos;
            }
            path_list.length = index;
        }
        if (is_path_valid && is_main_role) {
            // console.trace();
            GlobalEventSystem.Fire(EventName.BROADCAST_ROLE_WAY_POINT, path_info, true);
        }
        return { result: is_path_valid, path_list: path_list };
    }
    type = SourceOperateType.Move;
    init_time = 0;
    // print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT", type(end_pos))
    end_pos = new Vector2();
    action_func;
    update_func;
    arg_list;
    is_path_valid = false;
    path_list: Array<PathPoint> = null;
    now_use_pair = null;
    total_pair = null;
    move_type = local_SourceOperateMove.MoveType.MoveToTarget;
    id = local_SourceOperateMove.operate_move_id;
    public constructor(end_pos, action_func, update_func, arg_list?) {
        super();
        this.type = SourceOperateType.Move;
        this.init_time = 0;
        if (end_pos) {
            this.end_pos.x = end_pos.x;
            this.end_pos.y = end_pos.y;
        }
        this.action_func = action_func;
        this.update_func = update_func
        this.arg_list = arg_list;
        this.is_path_valid = false;
        this.path_list = null;
        this.now_use_pair = null;
        this.total_pair = null;
        this.move_type = local_SourceOperateMove.MoveType.MoveToTarget;
        local_SourceOperateMove.operate_move_id = local_SourceOperateMove.operate_move_id + 1;
        this.id = local_SourceOperateMove.operate_move_id;
    }
    public DeleteMe() {
        this.action_func = this.update_func = undefined
    }
    public SetPathList(path) {
        this.path_list = path;
        this.total_pair = this.path_list.length;
        this.now_use_pair = 1;
        this.is_path_valid = true;
        this.move_type = local_SourceOperateMove.MoveType.InitedPath;
        this.is_init_finish = true;
    }
    public RecalcPathInfo(start_pos, end_pos, range) {
        // 增加直线的判断	
        let self = this;
        local_SourceOperateMove.start_logic_pos.x = start_pos.x;
        local_SourceOperateMove.start_logic_pos.y = start_pos.y;
        local_SourceOperateMove.end_logic_pos.x = end_pos.x;
        local_SourceOperateMove.end_logic_pos.y = end_pos.y;
        local_SourceOperateMove.dir.x = end_pos.x - start_pos.x;
        local_SourceOperateMove.dir.y = end_pos.y - start_pos.y;
        let dist = local_SourceOperateMove.dir.normalise();
        //对目标点进行直线探测
        let rlt = Scene.GetInstance().IsStraightLine(local_SourceOperateMove.start_logic_pos, local_SourceOperateMove.end_logic_pos);
        if (rlt) {
            //直线探测成功
            let real_end = local_SourceOperateMove.end_logic_pos;
            if (dist <= range) {
                real_end = local_SourceOperateMove.start_logic_pos;
            }
            else {
                real_end.x = local_SourceOperateMove.end_logic_pos.x - local_SourceOperateMove.dir.x * range;
                real_end.y = local_SourceOperateMove.end_logic_pos.y - local_SourceOperateMove.dir.y * range;
            }
            let path_point: PathPoint = new PathPoint();
            path_point.start_point = local_SourceOperateMove.start_logic_pos;
            path_point.end_point = real_end;
            self.path_list.push(path_point);
            self.total_pair = self.path_list.length;
            self.now_use_pair = 1;
            self.is_path_valid = true;
        }
        else {
            //A*寻路
            let info = local_SourceOperateMove.FindPathList(local_SourceOperateMove.start_logic_pos, local_SourceOperateMove.end_logic_pos, range);
            let is_path_valid = info.result;
            let path_list = info.path_list;
            if (is_path_valid) {
                //分拆路径
                self.path_list = path_list;
                //设置初始化状态, 当前待执行的路径为第一个小路径
                self.total_pair = self.path_list.length;
                self.now_use_pair = 1;
                self.is_path_valid = true;
            }
            else if (SceneManager.GetInstance().IsBlockXY(local_SourceOperateMove.end_logic_pos.x, local_SourceOperateMove.end_logic_pos.y)) {
                let r = Scene.GetInstance().DetectLastUnblockPoint(local_SourceOperateMove.start_logic_pos, local_SourceOperateMove.dir, dist); //dist是逻辑坐标系的
                if (r.z == 1) {
                    let pair: PathPoint = new PathPoint();
                    pair.start_point = local_SourceOperateMove.start_logic_pos;
                    let gv2 = r;
                    pair.end_point = new Vector2(gv2.x, gv2.y);
                    self.path_list.push(pair);
                    self.total_pair = 1;
                    self.now_use_pair = 1;
                    self.is_path_valid = true;
                }
            }
            else if (SceneManager.GetInstance().IsBlockXY(local_SourceOperateMove.start_logic_pos.x, local_SourceOperateMove.start_logic_pos.y)) {
                let r = Scene.GetInstance().DetectLastUnblockPoint(local_SourceOperateMove.start_logic_pos, local_SourceOperateMove.dir, dist); //dist是逻辑坐标系的
                if (r.z == 1) {
                    let pair: PathPoint = new PathPoint();
                    pair.start_point = local_SourceOperateMove.start_logic_pos;
                    let gv2 = r;
                    pair.end_point = new Vector2(gv2.x, gv2.y);
                    self.path_list.push(pair);
                    self.total_pair = 1;
                    self.now_use_pair = 1;
                    self.is_path_valid = true;
                }
            }
        }
        // if (self.is_path_valid)
        // {
        //     egret.callLater(() =>{
        //         GlobalEventSystem.Fire(SceneEventType.CREATE_FINDWAY_POINT, self.path_list)
        //     }, this)
        // GlobalEventSystem.FireNextFrame(SceneEventType.CREATE_FINDWAY_POINT, self.path_list)
        // }
        return self.is_path_valid;
    }
    public static FindNearestUnblockPoint(point: Vector2) {
        let curr_x_add = 0;
        let curr_y_add = 0;
        let now_pos = new Vector2(point);
        let width = Math.floor(MapManager.GetInstance().GetSceneWidth() / LogicRealRatio_X);
        let height = Math.floor(MapManager.GetInstance().GetSceneHeight() / LogicRealRatio_Y);
        if (now_pos.x < 0)
            now_pos.x = 0;
        else if (now_pos.x > width)
            now_pos.x = width;
        if (now_pos.y < 0)
            now_pos.y = 0;
        else if (now_pos.y > height)
            now_pos.y = height;
        let max_offset = Math.ceil(Math.max(width, height) * 0.5);
        let offset = 0;
        while (offset < max_offset) {
            offset++;
            for (let i = 1; i <= 9; i++) {
                curr_x_add = 0;
                curr_y_add = 0;
                if (i == 1 || i == 4 || i == 7) {
                    curr_x_add = -1;
                }
                else if (i == 3 || i == 6 || i == 9) {
                    curr_x_add = 1;
                }
                if (i == 7 || i == 8 || i == 9) {
                    curr_y_add = -1;
                }
                else if (i == 1 || i == 2 || i == 3) {
                    curr_y_add = 1;
                }
                now_pos.x = point.x + curr_x_add * offset;
                now_pos.y = point.y + curr_y_add * offset;
                if (!MapManager.GetInstance().IsBlockXY(now_pos.x, now_pos.y)) {
                    return now_pos;
                }
            }
        }
    }
    public Init() {
        this.path_list = [];
        let main_role = Scene.GetInstance().GetMainRole();
        //如果当前点在障碍内，就先走出来，再从走出来的点进行寻路
        if (SceneManager.GetInstance().IsBlockXY(main_role.logic_pos.x, main_role.logic_pos.y)) {
            let start_logic_pos = new Vector2(main_role.GetLogicPos());
            let unblock_pos = local_SourceOperateMove.FindNoBlockPos(start_logic_pos);
            if (unblock_pos) {
                let path_point: PathPoint = new PathPoint();
                path_point.start_point = start_logic_pos;
                path_point.end_point = unblock_pos;
                this.path_list.push(path_point);
                //把走出来的点作为起始点
                start_logic_pos = unblock_pos;
            }
        }
        if (this.move_type == local_SourceOperateMove.MoveType.MoveToTarget) {
            this.init_time = Status.NowTime;
            if (!this.end_pos) {
                return false;
            }
            let end_logic_pos = this.end_pos;
            let is_get_path_suc = this.RecalcPathInfo(main_role.GetLogicPos(), end_logic_pos, 0);
            return is_get_path_suc;
        }
        return false;
    }
    public GetOperImpl() {
        let self = this;
        let now_oper = null;
        let now_time = Status.NowTime;
        if (!self.now_use_pair || !self.total_pair)
            return;
        if (self.now_use_pair > self.total_pair) {
            //行走完成直接执行相关动作
            self.is_finish = true;
            if (self.action_func) {
                self.action_func(self.arg_list);
                //print("self.action_func(unpack(self.arg_list))",self.action_func,"  ",unpack(self.arg_list))
            }
            now_oper = self.GenerateNop(0.2);
        }
        else {
            //取出下一个小路径执行
            let move_pair = self.path_list[self.now_use_pair - 1];
            if (move_pair != null) {
                now_oper = new NowOperateMove(now_time, move_pair.start_point, move_pair.end_point,self.update_func);
                self.now_use_pair = self.now_use_pair + 1;
            }
        }
        return now_oper;
    }
}
var local_SourceOperateMove = SourceOperateMove
window["SourceOperateMove"] = SourceOperateMove