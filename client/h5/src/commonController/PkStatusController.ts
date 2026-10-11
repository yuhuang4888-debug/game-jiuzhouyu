
//require("game.pkstatus.PkStatusModel")
//require("game.pkstatus.FightModeItem")
//require("game.pkstatus.FightModeView")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { PkStatusModel } from "../commonModel/PkStatusModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

export class PkStatusController extends BaseController {
	InitInfo

	public constructor() {
		super()


		let local_PKStatusModel_Instance = PkStatusModel.GetInstance()
		let local_PKStatusModel = PkStatusModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_RoleManager_Instance = RoleManager.GetInstance()

		this.InitInfo = () => {

			local_PKStatusModel_Instance.Bind(local_PKStatusModel.CHANGE_PK_STATUS, (type?) => {
				this.SendFmtToGame(13012, "c", type)
			})

			this.RegisterProtocal(13012, () => {
				let [error_code, pk_status, remain_time] = this.ReadFmt("ici")
				if (error_code == 1) {
					if (remain_time == 0) {
						local_RoleManager_Instance.mainRoleInfo.ChangeVar("pk_status", pk_status)
						local_PKStatusModel_Instance.Fire(local_PKStatusModel.CHANGE_SUCCESS)
					} else {
						local_RoleManager_Instance.mainRoleInfo.ChangeVar("peace_cd_time", remain_time)
					}
				} else {
					Util.ErrorCodeShow(error_code)
				}
			})

			this.RegisterProtocal(12074, () => {
				let [target_type, role_id, new_pk_status] = this.ReadFmt("clc")
				let main_role_id = local_RoleManager_Instance.GetMainRoleId()
				if (main_role_id == role_id) {
					return
				}
				let roleVo = SceneManager.GetInstance().GetRoleVo(role_id)
				if (roleVo) {
					roleVo.ChangeVar("pk_status", new_pk_status)
				}
			})


		}

		this.InitInfo()
	}
}

window["PkStatusController"] = PkStatusController