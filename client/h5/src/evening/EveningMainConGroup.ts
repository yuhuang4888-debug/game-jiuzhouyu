import { BaseItem1 } from "../common/BaseItem1"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { RefBoxVLayout } from "../util/Util"
import { Evening1MainConItem } from "./Evening1MainConItem"

export class EveningMainConGroup extends BaseItem1 {
	_ac_item
	_data
	_model
	item_list

	is_set
	count_num:number
	public constructor(parent?) {
		super(parent)
		this.is_set = false
		this.base_file = "evening"
		this.layout_file = "EveningMainConGroup"
		this._model = GuildActivityModel.GetInstance()
		this.item_list = []
		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin=""
			if (!this.is_set && this._data) {
				this.UpdateData()
			}
		}
	}

	public DeleteMe() {

		// if (this._ac_item ) {
		// 	this._ac_item.DeleteMe()
		// 	this._ac_item = null
		// }
		for (let i = 0; i < this.item_list.length; i++) {
			var item = this.item_list[i]
			item.DeleteMe()
		}
		this.item_list = []

		super.DeleteMe()
	}

	public UpdateData(data?) {
		if (!this._data) return
		let list = this._data.content
		this.count_num=0
		for (let i = 0; i < list.length; i++) {
			var v = list[i]
			this.item_list[i] = this.item_list[i] || new Evening1MainConItem(this.Content)
			this.item_list[i].Load()
			this.item_list[i].SetData(v)


			this.item_list[i].ExcuteCallback(() => {
				this.count_num++
				if(this.count_num>=list.length){
					RefBoxVLayout(this.Content,2)
				}
			})
		}


		
	}

	public SetData(data?) {
		this._data = data

		if (this.is_loaded) {
			this.UpdateData()
			this.is_set = true
		} else {
			this.is_set = false
		}

	}


_Image2:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.Box
public GetComponents() {
[
this._Image2,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"_Image2",
"_Scroller1",
"Content",
])
}
}
 window["EveningMainConGroup"]= EveningMainConGroup