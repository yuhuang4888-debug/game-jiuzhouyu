import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"


export const DepositSetting =  {
	"402@2": "DepositSettingGuildEvening",
	"281@0": "DepositSettingTopPk"
}
window["DepositSetting"] = DepositSetting

export class DepositModel extends EventDispatcher {
	public static REQUEST_CCMD_EVENT = "REQUEST_CCMD_EVENT"
	public static UPDATE_INFO = "UPDATE_INFO"
	public static UPDATE_RECORD_LIST = "UPDATE_RECORD_LIST"
	public static DEPOSIT_SELECT = "DEPOSIT_SELECT"
	public static DEPOSIT_UNSELECT = "DEPOSIT_UNSELECT"
	public static DEPOSIT_BEHAVIOUR_SELECT = "DEPOSIT_BEHAVIOUR_SELECT"
	public static DEPOSIT_BEHAVIOUR_UNSELECT = "DEPOSIT_BEHAVIOUR_UNSELECT"
	public static UPDATE_DEPOSIT_VALUE = "UPDATE_DEPOSIT_VALUE"
	static Instance: any

	
	info
	cur_deposit_value
	now_dy_deposit_value
	// config_ac
	// config_activity_onhook_module

	public constructor() {
		super()
		if (DepositModel.Instance) {
			return
		}
		DepositModel.Instance = this
		this.info = null
		this.cur_deposit_value = 0
		this.now_dy_deposit_value = 0
	}

	public InitConfig = async () => {
		// await ResManager.GetInstance().LoadGameConfig(this, "config_ac", false, undefined, (obj)=>{
		// 	this.config_ac = obj
		// 	ResManager.GetInstance().DestoryGameConfig(this, "config_ac", false)
		// })
		// await ResManager.GetInstance().LoadGameConfig(this, "config_activity_onhook_module", false, undefined, (obj)=>{
		// 	this.config_activity_onhook_module = obj
		// 	ResManager.GetInstance().DestoryGameConfig(this, "config_activity_onhook_module", false)
		// })
	}

	public Clear() {


	}

	public static GetInstance() {

		if (!DepositModel.Instance) {
			new DepositModel()
		}
		return DepositModel.Instance
	}

	public GetInfo() {

		return this.info
	}

	public GetDepositData(module_id?, sub_module?) {

		for (let i = 0; i < this.info.activity_list.length; i++) {
			var v = this.info.activity_list[i]
			if (module_id == v.module_id && sub_module == v.sub_module) {
				return v
			}
		}
	}

	//设置活动是否托管
	public SetDeposit(module_id?, sub_module?, is_deposit?) {

		let data = this.GetDepositData(module_id, sub_module)
		if (!data) {
			data = {"module_id" : module_id, "sub_module" : sub_module, "behaviour_list" : []}
			table.insert(this.info.activity_list, data)
		}
		data.select_time = is_deposit && TimeUtil.getServerTime() || 0
	}

	public GetAcCfg(module_id?, sub_module?, ac_cfg?) {
		if (ac_cfg){
			for (let k in ac_cfg) {
				var v = ac_cfg[k]
				if (module_id == v.module && sub_module == v.module_sub) {
					return v
				}
			}
		}
	}

	public GetDepositCfg(module_id?, sub_module?, config_activity_onhook_module?) {
		if (config_activity_onhook_module){
			for (let k in config_activity_onhook_module) {
				var v = config_activity_onhook_module[k]
				if (module_id == v.module_id && sub_module == v.sub_module) {
					return v
				}
			}
		}
	}

	public SetDepositValue(value?,value_2?) {
		this.cur_deposit_value = value
		this.now_dy_deposit_value = value_2
		this.Fire(DepositModel.UPDATE_DEPOSIT_VALUE, this.cur_deposit_value)
	}

	public GetDepositValue() {
		return this.cur_deposit_value
	}

	public GetNowDayDepositValue(){
		return this.now_dy_deposit_value
	}

}


window["DepositModel"] = DepositModel