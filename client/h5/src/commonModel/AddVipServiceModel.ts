import { ResManager } from "../common/ResManager"
import { LoginModel } from "../login/LoginModel"
import { PlatformManager } from "../PlatformManager"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { ActivityIconManager } from "./ActivityIconManager"
import { FirstRechargeModel } from "./FirstRechargeModel"


export let AddVipServiceEvent = {
    ADDVIPSERVICE_OPEN_VIEW: "ADDVIPSERVICE_OPEN_VIEW",
    ADDVIPSERVICE_CLOSE_VIEW: "ADDVIPSERVICE_CLOSE_VIEW",
    ADDVIPSERVICE_REQUEST_CCMD_EVENT: "ADDVIPSERVICE_REQUEST_CCMD_EVENT",
    ADDVIPSERVICE_UPDATE_WXCOLLECTION: "ADDVIPSERVICE_UPDATE_WXCOLLECTION"
}

export class AddVipServiceModel extends EventDispatcher {
    AttentionEnState
    AttentionIconFun
    ControllState
    GetAttentionState
    GetIconCfg
    GuideCodeIcon
    InitConfig
    InitWXCollectCfg
    SetHasShowTag
    ShouldInToWefareIcon
    ShowAttentionRedDot
    ShowBiLiBiLiArrow
    UpdateWXCollection
    act_data
    info
    should_restart
    wx_collect_cfg
    wx_collection_state
    is_show_add_vip_service_icon = false
    static Instance
    public constructor() {
        super()

        if (AddVipServiceModel.Instance) {
            return
        }
        AddVipServiceModel.Instance = this
        this.InitConfig = () => {

        }
    }

    public CheckIconOpen() {
        if (!PlatformManager.GetInstance().is_alpha && this.is_show_add_vip_service_icon) {

            ResManager.GetInstance().LoadGameConfig(this, "ClientAddVipService", true, null, (cfg) => {
                let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
                let is_can_add = false
                for (let key in cfg.tem) {
                    if (cfg.tem[key] == play_name) {
                        ActivityIconManager.GetInstance().addIcon(114)
                    }
                }
            })

        }
    }


    public static GetInstance() {

        if (!AddVipServiceModel.Instance) {
            AddVipServiceModel.Instance = new AddVipServiceModel()
        }
        return AddVipServiceModel.Instance
    }
}
window["AddVipServiceModel"] = AddVipServiceModel