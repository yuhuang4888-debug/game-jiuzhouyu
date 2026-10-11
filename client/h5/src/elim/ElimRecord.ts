import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { ElimGameMgr } from "./ElimGameMgr"


export class ElimRecord extends BaseClass {
    record

    public constructor() {
        super()

        this.record = []
    }

    public DeleteMe() {

        this.record = null
    }

    public Clean() {

        if (!this.record) {
            this.record = []
        }
    }

    public AddAction(action_id, ...new_args) {

        let action = new_args
        action.splice(0, 0, action_id)
        //table.insert(action, 0, action_id)
        table.insert(this.record, action)

        ElimGameMgr.GetInstance().AddAction(action)
    }
}