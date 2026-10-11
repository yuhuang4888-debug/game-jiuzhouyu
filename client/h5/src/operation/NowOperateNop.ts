import { NowOperate } from "./NowOperate";
// TypeScript file
export class NowOperateNop extends NowOperate {
    excute_time = 0;
    public constructor(start_time) {
        super(start_time);
        this.excute_time = 0;
    }
    public Init() {
        return true;
    }
    public ExcuteImpl(elapse_time) {
        this.excute_time = this.excute_time + 1;
        if (this.excute_time > 3) {
            return true;
        }
        return false;
    }
}

window["NowOperateNop"] = NowOperateNop