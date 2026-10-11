import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { AttentionEvent, AttentionModel } from "../commonModel/AttentionModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "../addVipService/addVipServiceView"
import { AddVipServiceEvent, AddVipServiceModel } from "../commonModel/AddVipServiceModel"
import { RoleManager } from "../commonModel/RoleManager"

export class AddVipServiceController extends BaseController {
    InitEvent
    InitInfo
    model
    obtain_view
    view_dic

    public constructor() {
        super()


        this.model = AddVipServiceModel.GetInstance()
        this.view_dic = []
        let local_AddVipServiceEvent = AddVipServiceEvent
        this.InitEvent = () => {
            this.model.Bind(local_AddVipServiceEvent.ADDVIPSERVICE_OPEN_VIEW, (view_name: string, ...new_args) => {
                let view = this.view_dic[view_name]
                if (!view) {

                    let view_class = window[view_name]
                    view = new view_class()

                    this.view_dic[view_name] = view
                }
                if (view && view != true) {
                    view.Open(...new_args)
                }
            })

            GlobalEventSystem.Bind(EventName.GAME_START, () => {
                this.model.CheckIconOpen()
            })

            RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL,(level?)=>{
                if(level >= 90){
                    this.model.CheckIconOpen()
                }
            })

        }
        this.InitEvent()
    }

}
window["AddVipServiceController"] = AddVipServiceController