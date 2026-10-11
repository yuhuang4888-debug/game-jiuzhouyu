import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { RoleManager } from "../commonModel/RoleManager"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../weekCard/WeekCardEnterView"
import "../weekCard/WeekCardItem"
import "../weekCard/WeekCardMainView"
import "../weekCard/WeekCardTipView"

export class WeekCardController extends BaseController {
    InitInfo

    model = WeekCardModel.GetInstance()
    public constructor() {
        super()
        this.InitInfo = () => {
            GlobalEventSystem.Bind(EventName.GAME_START, () => {
                this.SendFmtToGame(45201)
                this.SendFmtToGame(45203)


            })
            GlobalEventSystem.Bind(ActivityIconManager.DELETE_ICON, (icon_type) => {
                if (icon_type == 159) {
                    ActivityIconManager.GetInstance().addIcon(452)
                }
            })
            RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
                WeekCardModel.GetInstance().Fire(WeekCardModel.UPDATE_ICON)
            })
            this.model.Bind(
                WeekCardModel.REQUEST_PROTO, (id, fmt, ...new_args) => {
                    this.SendFmtToGame(id, fmt, ...new_args)
                }
            )
            this.model.Bind(
                WeekCardModel.UPDATE_ICON, () => {
                    if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge()) {
                        ActivityIconManager.GetInstance().addIcon(452)
                    }
                    else {
                        ActivityIconManager.GetInstance().deleteIcon(452)
                    }
                }
            )

            let user_msg_adapter = UserMsgAdapter.GetInstance()
            let Handler45201 = () => {
                let scmd = user_msg_adapter.GetSCMD(45201)
                this.model.SetWeekCardData(scmd)
                this.model.Fire(WeekCardModel.UPDATE_VIEW, scmd)
            }

            this.RegisterProtocal(45201, Handler45201)

            let Handler45202 = () => {
                let scmd = user_msg_adapter.GetSCMD(45202)
                if (scmd.code == 1) {
                    this.SendFmtToGame(45201)
                    let data = []
                    for (let _tmpi in scmd.reward_list) {
                        var reward = scmd.reward_list[_tmpi]
                        let vo = {
                            "0": reward.style,
                            "1": reward.typeId,
                            "2": reward.count
                        }
                        table.insert(data, vo)
                    }
                    if (data.length > 0) {

                        let view = new CongratulationObtainView(data, 10)
                        view.Open()
                    }
                }
                else
                    Util.ErrorCodeShow(scmd.code)
            }

            this.RegisterProtocal(45202, Handler45202)

            let Handler45203 = () => {
                let scmd = user_msg_adapter.GetSCMD(45203)
                if (scmd.type == 1) {
                    let data = []
                    for (let _tmpi in scmd.reward) {
                        var reward = scmd.reward[_tmpi]
                        let vo = {
                            "0": reward.style,
                            "1": reward.type_id,
                            "2": reward.count
                        }
                        table.insert(data, vo)
                    }
                    this.model.SetHaveReward(data.length > 0)
                    this.model.SetReward(data)
                }
                else if (scmd.type == 2) {
                    let data = []
                    for (let _tmpi in scmd.reward) {
                        var reward = scmd.reward[_tmpi]
                        let vo = {
                            "0": reward.style,
                            "1": reward.type_id,
                            "2": reward.count
                        }
                        table.insert(data, vo)
                    }
                    this.model.SetHaveReward(false)
                    if (data.length > 0) {

                        let view = new CongratulationObtainView(data, 10)
                        view.Open()
                    }
                    this.SendFmtToGame(45201)
                }
                else if (scmd.type == 3) {
                    this.model.spacial_red = true
                    GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 452, this.model.spacial_red)
                }
                this.model.Fire(WeekCardModel.UPDATE_VIEW)
            }

            this.RegisterProtocal(45203, Handler45203)

        }

        this.InitInfo()
    }
}

window["WeekCardController"] = WeekCardController