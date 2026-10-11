
import { EventDispatcher } from "../util/EventDispatcher"
import {table} from "../common/table"
export class CheatModel extends EventDispatcher {
	cheats_data
	type_list
	attrChange
	public static REQUEST_CHEAT_DATA = "CheatModel.REQUEST_CHEAT_DATA"   //请求秘籍数据
	public static UPDATE_CHEAT_INPUT_VIEW = "CheatModel.UPDATE_CHEAT_INPUT_VIEW"   //更新秘籍界面数据
	public static SEND_CHEAT_TO_SERVER = "CheatModel.SEND_CHEAT_TO_SERVER"   //发送秘籍到服务端
	public static UPDATE_TEST_ATTR_VIEW = "CheatModel.UPDATE_TEST_ATTR_VIEW"   //更新属性测试界面
	static Instance

	public constructor() {
		super()

		CheatModel.Instance = this
		this.cheats_data = null
		this.type_list = []
		this.attrChange = []
	}

	public static GetInstance() {

		if (CheatModel.Instance == null) {
			new CheatModel()
		}
		return CheatModel.Instance
	}

	//设置秘籍数据
	public SetCheatsData(data?) {

		this.cheats_data = data
		this.SetCheatsTypeList()
		this.Fire(CheatModel.UPDATE_CHEAT_INPUT_VIEW)
	}

	public GetCheatData() {

		return this.cheats_data
	}

	public GetCheatsDataByType(type_name?) {

		for (let i = 0; i < this.cheats_data.length; i++) {
			var vo = this.cheats_data[i]
			if (vo.func_name == type_name) {
				return vo.func_commands
			}
		}

		return null
	}

	public SetCheatsTypeList() {
		this.type_list = []
		for (let i = 0; i < this.cheats_data.length; i++) {
			var vo = this.cheats_data[i]
			table.insert(this.type_list, vo.func_name)
		}
	}

	public GetCheatsTypeList() {

		return this.type_list
	}

	public GetTestViewAttr() {

		// let attr_cfg = Config.ConfigItemAttr
		// let data = []
		// let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		// for (let i in attr_cfg) {
		// 	var v = attr_cfg[i]
		// 	if (i != "comment") {
		// 		let value = 0
		// 		if (this.attrChange[i]) {
		// 			value = this.attrChange[i]
		// 		} else {
		// 			let mainvo_str = v.mainvo_str
		// 			let n_value = 0
		// 			if (mainvo_str) {
		// 				n_value = role_vo[mainvo_str]
		// 			}
		// 			if (!n_value) {
		// 				value = 0
		// 			} else {
		// 				value = n_value
		// 				//if (v.kind == 2 ) {
		// 				//value=(Number(n_value) == 0 && 0 || Number(Math.floor(n_value + 0.5)/ 100)) + "%"
		// 				//}else{
		// 				//value=WordManager.ConvertToPercentValue(i, n_value)
		// 				//}
		// 			}
		// 		}
		// 		this.attrChange[i] = value
		// 		table.insert(data, { id= i, cfg = v, value = value })
		// 	}
		// }
		// table.sort(data, (a?, b?) => {
		// 	return a.id < b.id
		// })
		// return data
	}

	public AttrChange(id?, value?) {

		this.attrChange[id] = value
	}

	public RemoveAttrChange() {

		this.attrChange = []
	}

	public SendAttrChange() {

		//attr_[{1,10000}, {5, 1000}]
		if (this.attrChange == []) {
			return
		}
		let str = 'attr_['
		let first = true
		let d = ""
		for (let id in this.attrChange) {
			var value = this.attrChange[id]
			if (first) {
				d = ""
				first = false
			} else {
				d = ","
			}
			str = str + d + "{" + id + "," + value + "}"
		}
		str = str + "]"
		this.Fire(CheatModel.SEND_CHEAT_TO_SERVER, str)
		console.log("秘籍的内容是===：", str)
	}

	//所有属性设为0
	public ReSetAttr() {

		for (let i in this.attrChange) {
			var attr = this.attrChange[i]
			this.attrChange[i] = 0
		}
		this.Fire(CheatModel.UPDATE_TEST_ATTR_VIEW)
	}
}
window["CheatModel"] = CheatModel