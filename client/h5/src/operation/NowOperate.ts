import { OperateType } from "./OperateManager";
import { Status } from "../util/Status";
// TypeScript file
export class NowOperate {
    start_time;
    is_init_finish = false;
    is_parallel = false;
    type = OperateType.Unknown;
    public constructor(start_time) {
        this.start_time = start_time;
    }
    public GetType() {
        return this.type;
    }
    public IsOverStartTime() {
        if (Status.NowTime >= this.start_time) {
            return true;
        }
        else {
            return false;
        }
    }
    public Excute(elapse_time) {
        if (!this.is_init_finish) {
            this.is_init_finish = true;
            if (!this.Init()) {
                return true;
            }
            else {
                return this.ExcuteImpl(elapse_time);
            }
        }
        return this.ExcuteImpl(elapse_time);
    }
    public GetStartTime() {
        return this.start_time;
    }
    public SetStartTime(start_time) {
        this.start_time = start_time;
    }
    public IsParallelOper() {
        return this.is_parallel;
    }
    public Init() {
        return true;
    }
    public ExcuteImpl(elapse_time) {
        return true;
    }
    public DeleteMe() {
    }
}

window["NowOperate"] = NowOperate