import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { SetAnchoredPosition } from "../util/Util"

export class OptionalLottoWindow extends BaseWindowComponent {
	SetActInfo
	change_scene_close
	destroy_imm
	money_list
	not_show_item_use
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()

		this.titleStr = "customActivity.uizztb_001"
		this.money_list = [2, 1, 0]
		this.destroy_imm = true
		this.viewClassList = ["OptionalLottoView"]
		this.tabStrList = [{ label: "自选抽奖礼包" }]
		this.change_scene_close = false
		this.dependent_res = ["customActivity"]
		this.not_show_item_use = true
		this.is_show_tab = false
		this.window_load_back = () => {
			//this.SetDownState(false)//隐藏tab栏
			SetAnchoredPosition(this._img_return, 720, 1073)
		}

		this.SetActInfo = (info?, pram?) => {
			this.SetIndexParameter(0, info)
		}


	}

}
window["OptionalLottoWindow"] = OptionalLottoWindow