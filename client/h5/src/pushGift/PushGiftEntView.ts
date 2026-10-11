import { Alert, Alert_Type } from "../alert/Alert"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { table } from "../common/table"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import "./PushGiftView"
import { ViewGiftPopModel } from './../commonModel/ViewGiftPopModel';

export class PushGiftEntView extends BaseWindowComponent {
	arg_list
	bg_list
	change_scene_close
	destroy_imm
	key2Index
	model: PushGiftModel
	money_list
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()

		this.money_list = [2, 1, 0]
		this.titleStr = "pushGift.uixsqg_title"
		this.destroy_imm = true
		this.change_scene_close = false

		this.model = PushGiftModel.GetInstance()

		this.key2Index = null

		this.window_load_back = () => {
			this.ShowRed()
			this.InintEvent()
			ViewGiftPopModel.GetInstance().ClearGifts();
		}
	}

	public ShowRed() {

		//红点信息
		if (this.key2Index) {
			for (let key in this.key2Index) {
				var index = this.key2Index[key]
				let value = 0
				if (key) {
					value = this.model.GetGiftRed(key)
				}
				this.SetTabRed(index, value && value > 0)
			}
		}
	}

	public InintEvent() {

		//红点信息
		this.BindEvent(this.model, PushGiftModel.UPDATE_TAB_RED, (key?, state?) => {
			if (this.key2Index[key] != null) {
				this.SetTabRed(this.key2Index[key], state)
			}
		})
	}

	public SetActInfo(gift_id?, sub_id?) {

		//gift_id, sub_id 打开指定页签的信息
		let tab_str_list = []
		let view_class_list = []
		let arg_list = []
		let bg_list = []
		let default_select_index = null
		let index = 0

		if (!this.key2Index) {
			this.key2Index = []
		}

		let list = this.model.GetGiftList()
		for (let key in list) {
			var info = list[key]
			if (info) {
				this.key2Index[key] = view_class_list.length //+ 1
				let title_name = ""
				for (let _s in info) {
					var _sinfo = info[_s]
					if (_sinfo != null) {
						title_name = _sinfo.title_name
						break
					}
				}
				let obj = { "label": title_name }
				table.insert(tab_str_list, obj)
				table.insert(view_class_list, "PushGiftView")
				table.insert(arg_list, { "id": key, "name": title_name })
				table.insert(bg_list, "uizstg_08.jpg")

				//如果有指定，换成指定的select_index
				if (gift_id) {
					if (key == gift_id) {
						default_select_index = index
					}
				}

				index = index + 1
			}
		}

		this.tabStrList = tab_str_list
		this.viewClassList = view_class_list
		this.arg_list = arg_list
		this.bg_list = bg_list
		if (default_select_index != null) {
			this.SetDefaultIndex(default_select_index)
		}
	}

	public BaseWindowCloseFunc() {

		let model = this.model
		let exit_fun = () => {
			if (!this.use_delete_method) {
				for (let key1 in model.will_del_gift) {
					for (let key2 in model.will_del_gift[key1]) {
						if (model.will_del_gift[key1][key2] == 1) {
							model.DeleteGiftList(key1, key2)
							model.will_del_gift[key1][key2] = -1
						}
					}
				}
				super.Close()
			}
		}
		let gift_empty = true
		for (let key in model.gift_data) {
			let sub_data = model.gift_data[key]
			for (let key2 in sub_data) {
				if (!model.will_del_gift[key] || !model.will_del_gift[key][key2]) {
					gift_empty = false
					break
				}
			}
			if (gift_empty == false)
				break
		}

		if (model.exit_tip_open && !gift_empty && model.gift_data.length > 0) {
			let check_fun = () => {
				model.exit_tip_open = !model.exit_tip_open
			}
			Alert.Show("错过就再也买不到了<br/>确定要离开吗？", Alert_Type.AlertTypeCheckBox, exit_fun, null, "狠心离开", "留下", null, null, check_fun)

		} else {
			exit_fun()
		}

	}

}


window["PushGiftEntView"] = PushGiftEntView