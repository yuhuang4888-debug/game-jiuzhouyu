import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import "./vipGiftView"

export class vipGiftWindowView extends BaseWindowComponent {
	SetActInfo
	change_scene_close
	destroy_imm
	money_list
	tabStrList
	titleStr
	viewClassList
	window_load_back

	public constructor() {
		super()

		//this.dependent_res = ["customActivity"]
		this.titleStr = "customActivity.uihd_001"
		this.money_list = [2, 1, 0]
		this.destroy_imm = true
		this.viewClassList = ["vipGiftView"]
		this.tabStrList = [{ label: "VIP特惠礼包" }]
		this.change_scene_close = false
		this.is_show_tab=false
		this.window_load_back = () => {
			this.BindEvent(CustomActivityModel.GetInstance(),CustomActivityModel.CLOSE_VIPGIFT_VIEW,()=>{
				this.BaseWindowCloseFunc()
			})
			// this.SetDownState(false)//隐藏tab栏
		}
		


		this.SetActInfo = (info?, pram?) => {
			this.SetIndexParameter(0, info)
		}
	}
}
window["vipGiftWindowView"]=vipGiftWindowView
