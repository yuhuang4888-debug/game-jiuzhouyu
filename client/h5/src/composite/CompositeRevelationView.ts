import { CompositeHolySealView } from "./CompositeHolySealView"
import { GoodsModel } from "../commonModel/GoodsModel"

export class CompositeRevelationView extends CompositeHolySealView {
	BindBagList
	InitView
	LoadSuccess
	tabList
	tab_name_list

	public constructor(parent?) {
		super(parent)
		this.InitView = () => {
			this.tabList = this.composite_model.revelation_tab_id_list
			this.tab_name_list = this.composite_model.GetRevelationComposeNameList(this.cfg_menu, this.cfg_menu_id)
			super.InitView()
		}

		this.LoadSuccess = () => {
			super.LoadSuccess()
			this.title.text = "天启合成"
		}

		this.BindBagList = () => {
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_REVE_BAG_LIST, () => {
				this.RefreshRed()
				this.UpdateSuccessRatio()
			})
		}
	}
}
window["CompositeRevelationView"] = CompositeRevelationView