import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ArmorModel } from "../commonModel/ArmorModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { ResManager } from "../common/ResManager"
import "../equipArmor/EquipArmorView"
import "../equipArmor/ArmorAttrView"
import { RoleManager } from "../commonModel/RoleManager"
import { Config } from "../common/Config"

export class ArmorController extends BaseController {
	model
	view_dic
	user_msg_adapter

	public constructor() {
		super()

		this.model = ArmorModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.view_dic = []

		this.RegisterAll()
		this.InitEvent()
	}

	public RegisterAll() {
		// 战甲数据获取
		let On14401 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14401)
			this.model.SetData(scmd)
		}

		// 打造
		let On14402 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14402)
			if (scmd.code == 1) {
				this.model.UpdateData(scmd.stage_list)
				this.model.Fire(ArmorModel.MAKE_SUCCED)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		this.RegisterProtocal(14401, On14401)
		this.RegisterProtocal(14402, On14402)
	}

	public InitEvent() {
		this.Bind(EventName.GAME_START, () => {
			this.SendFmtToGame(14401, "cc", 0, 0)
		})

		let red_func = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_armour_equipment
			this.model.CheckRedSate(cfg)
		}
		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, red_func)
		RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, red_func)

		this.model.Bind(ArmorModel.REQUEST_SCMD, (...new_args) => {
			let args = new_args
			if (args[0] == 14401) {
				this.SendFmtToGame(14401, "cc", args[1], args[2])
			} else if (args[0] == 14402) {
				this.SendFmtToGame(14402, "ccc", args[1], args[2], args[3])
			}
		})

		this.model.Bind(ArmorModel.OPEN_VIEW, (view_class: string, ...new_args) => {
			let view = this.view_dic[view_class]
			if (!view) {
				let view_name = window[view_class]
				view = new view_name()
				this.view_dic[view_class] = view
			}
			view.Open()
		})

		this.model.Bind(ArmorModel.UPDATE_RED, () => {
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
		})
	}
}
window["ArmorController"] = ArmorController