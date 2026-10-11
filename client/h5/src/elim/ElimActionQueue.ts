import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { Util } from "../util/Util"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"


/**消消乐  消除步骤  把所有的消除步骤放进队列 */
export class ElimActionQueue extends BaseClass {
    //action_index
    actions:Array<any>
    is_wait_action

    public constructor() {
        super()

        this.actions = []
        //this.action_index = 0
    }

    public ClearAction(){
        this.actions.length = 0
    }

    public AddAction(action?) {

        if (!action) {
            return
        }
        table.insert(this.actions, action)

        //添加步骤操作
        if (this.is_wait_action) {
            this.is_wait_action = false
            MiniGameModel.GetInstance().SetWaitState(false)
            this.NextAction()
        }
    }

    public NextAction() {

        if (!this.actions || this.actions.length < 1) {
            this.is_wait_action = true
            MiniGameModel.GetInstance().SetWaitState(true)
            return
        }

        let action = this.actions.shift()
        this.ExcuteAction(action)

    }

    public ExcuteAction(action?) {

        if (!action) {
            return
        }
        let action_id = action[0]
        ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.ACTION_EXCUTE, action_id, action)
    }

    public Update() {

        if (!this.actions || this.actions.length < 1) {
            return
        }
    }
}