import { BaseController } from "../common/BaseController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SvipMainModel} from "../commonModel/SvipMainModel"
import "../svip/SvipMainView"
import { EventName } from "../common/EventName";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { ActivityIconManager } from "../commonModel/ActivityIconManager";

export class SvipMainController extends BaseController {
    svip_view
    local_globalEventSystem
    eventName
    user_msger
    svip_main_model
    activity_icon_mgr
    public constructor() {
        super();
        this.local_globalEventSystem = GlobalEventSystem
        this.eventName = EventName
        this.user_msger = UserMsgAdapter.GetInstance()
        this.svip_main_model = SvipMainModel.GetInstance()
        this.activity_icon_mgr = ActivityIconManager.GetInstance()
        this.InitEvent()
        this.RegisterProto()
    }

    public InitEvent() {

        this.local_globalEventSystem.Bind(this.eventName.GAME_START, () => {
            this.SendFmtToGame(45120)
        })

        let open_svip_main_view_func = () => {
            let viewName = window["SvipMainView"]
            if(!this.svip_view){
                this.svip_view = new viewName()
            }
            if(this.svip_view.HasOpen()){
                return
            }
            else{
                this.svip_view.Open()
            }
        }
        this.local_globalEventSystem.Bind(this.eventName.OPEN_SVIP_MAIN_VIEW, open_svip_main_view_func)
    }

    public RegisterProto(){
        let On45120 = () => {
            let scmd = this.user_msger.GetSCMD(45120)
            this.svip_main_model.open_act_id = scmd.open_act_id
            this.svip_main_model.server_content_list = scmd.list
            if(scmd.open_act_id > 0){
                this.activity_icon_mgr.addIcon("45120")
            } else if(scmd.open_act_id == 0){
                this.activity_icon_mgr.deleteIcon("45120")
            }
        }
        this.RegisterProtocal(45120, On45120)
    }
}
window["SvipMainController"] = SvipMainController