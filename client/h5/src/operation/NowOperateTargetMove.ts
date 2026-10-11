import { NowOperateMove } from "./NowOperateMove";
import { Status } from "../util/Status";
import { Scene } from "../scene/Scene";
import { Vector2 } from "../util/Vector2";
import { GameMath } from "../util/GameMath";
// TypeScript file
export class NowOperateTargetMove extends NowOperateMove {
    target;
    range;
    ///每隔一段时间重新检测路径
    check_time_delta = 1;
    check_time = Status.NowTime;
    public constructor(start_time, start_pos, end_pos, target, range) {
        super(start_time, start_pos, end_pos, null);
        this.target = target;
        this.range = range;
        //每隔一段时间重新检测路径
        this.check_time_delta = 1;
        this.check_time = Status.NowTime;
    }
    public ExcuteImpl(elaspe_time) {
        let main_role = Scene.GetInstance().GetMainRole();
        let self = this;
        //每隔一段时间重新检测路径，所以可以停止当前路径
        if (Status.NowTime - self.check_time >= self.check_time_delta) {
            main_role.WaitForNextMove(); //会有抖动
            self.is_end = true;
            //print("NowOperateTargetMove.ExcuteImpl   Stop Cur path 1", Status.NowTime, self.check_time)
            return true;
        }
        //如果与目标的距离达到范围内，也要停止当前路径
        let pos1 = main_role.GetRealPos();
        let pos2: Vector2 = self.target.GetRealPos();
        //let dir = pos2.getDir(pos1)
        // let distance = dir.length()
        let distance = GameMath.GetDistance(pos1.x, pos1.y, pos2.x, pos2.y, false);
        //距离在可动作范围内
        let d = (self.range > 5) ? (self.range - 5) : self.range;
        if (distance < d * d) {
            main_role.WaitForNextMove();
            self.is_end = true;
            //print("NowOperateTargetMove.ExcuteImpl   Stop Cur path 2", distance)
            return true;
        }
        return super.ExcuteImpl(elaspe_time);
    }
}

window["NowOperateTargetMove"] = NowOperateTargetMove