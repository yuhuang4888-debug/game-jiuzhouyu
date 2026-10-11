import { SourceOperateType } from "./OperateManager";
import { NowOperateNop } from "./NowOperateNop";
// TypeScript file
export class SourceOperate {
    is_finish = false;
    is_init_finish = false;
    type = SourceOperateType.Unknown;
    next_target;
    cross_scene;
    public GetOper() {
        if (!this.is_init_finish) {
            this.is_init_finish = true;
            if (!this.Init()) {
                this.is_finish = true;
                return null;
            }
        }
        return this.GetOperImpl();
    }
    public IsFinish() {
        return this.is_finish;
    }
    public GetNextTarget() {
        return this.next_target;
    }
    public GetCrossScene() {
        return this.cross_scene;
    }
    public GetSrcType() {
        return this.type;
    }
    public Init() {
        return false;
    }
    public GetOperImpl() {
        return null;
    }
    public GenerateNop(delta_time) {
        let nop = new NowOperateNop(delta_time);
        return nop;
    }
    public DeleteMe() {
    }
    public ClearNowMoveSrcOper() {
    }
    public SetPathList(path_list) {
    }
}

window["SourceOperate"] = SourceOperate