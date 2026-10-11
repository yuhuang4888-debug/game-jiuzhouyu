import { BaseItem1 } from "../common/BaseItem1";

export class TaskUpAlerStartItem extends BaseItem1 {
    InitView

    public constructor(parent?) {
        super(parent)
        this.base_file = "task"
        this.layout_file = "TaskUpAlerStartItem"
        this.load_callback = () => {
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }
}

window["TaskUpAlerStartItem"] = TaskUpAlerStartItem