import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Util } from "../util/Util"

export class UnrealStrenCostItem extends BaseItem1 {


	model: UnrealModel
	need_refresh_data
	data
	item
	public constructor(parent) {
		super(parent)
		this.base_file = "unreal"
		this.layout_file = "UnrealStrenCostItem"
		this.model = UnrealModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	private async LoadSuccess() {
		this.item = new EquipmentItem(this._gp_con)
		this.item.Load()
		this.item.SetItemSize(85, 85)

		if (this.need_refresh_data) {

			this.need_refresh_data = false
			this.UpdateView()
		}
	}

	private InitEvent() {

	}

	private UpdateView() {
		if (this.data) {
			this.item.SetData(this.data.type_id)
			if (this.data.my_count > 100000){
				this._lb_cost.style.fontSize = 14
			}else if (this.data.my_count > 10000){
				this._lb_cost.style.fontSize = 18
			}else{
				this._lb_cost.style.fontSize = 20
			}
			this._lb_cost.style.color = "#ffffff"
			// this._lb_cost.style.align = "right"	
			this._lb_cost.width = 200
			// this._lb_cost.innerHTML = Util.StrToHTML(`${Util.HtmlColorTxt(this.data.my_count, "'#0a953e'")}/${this.data.cost_count}`)
			this._lb_cost.innerHTML = Util.StrToHTML(`${Util.HtmlColorTxt(this.data.my_count, this.data.color)}/${this.data.cost_count}`)
			let pos = 85 - 5 - this._lb_cost.contextWidth
			this._lb_cost.x = pos
			this._lb_cost.y = 60

		}
		// item.SetItemSize(85, 85)
	}


	public SetData(type_id, color, my_count, cost_count) {
		this.data = {
			type_id: type_id,
			color: color,
			my_count: my_count,
			cost_count: cost_count
		}
		if (this.is_loaded) {
			this.UpdateView()
		}
		else {
			this.need_refresh_data = true
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = undefined
		}
		super.DeleteMe()
	}
	

	_gp_con: Laya.Box
	_lb_cost: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._gp_con,
			this._lb_cost,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_lb_cost",
			])
	}
}
window["UnrealStrenCostItem"] = UnrealStrenCostItem