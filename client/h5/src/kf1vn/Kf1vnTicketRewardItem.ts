import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { GameResPath } from "../util/GameResPath"

export class Kf1vnTicketRewardItem extends BaseItemRenderer {

model
parent_wnd
item_list
public WIDTH = 615
public HEIGT= 120
public constructor(parent){
super() 
	
	this.base_file = "kf1vn"
	this.layout_file = "Kf1vnTicketRewardItem"
	this.model = Kf1vnModel.GetInstance()
	this.item_list = []
	this.Load()
}

public load_callback(){ 
	this.InitEvents()
}

public InitEvents(){ 
	

}

public dataChanged(){ 
	if(!super.dataChanged())return
	if (this.data ) {
		let gap = this.data.rank_max - this.data.rank_min
		this.rank_icon.visible = gap == 0 
		if (gap == 0 && this.data.rank_min <= 3 ) {
			this.rank_label.visible = false 
			ResManager.GetInstance().SetImageSprite(this, this.rank_icon, "kf1vn", "rank" + this.data.rank_min)
		}else{
			this.rank_label.visible = true 
			this.rank_label.text = this.data.rank_min + (" - ") + this.data.rank_max
		}
		let list = JSON.parse(this.data.rewards)
		if (list ) {
			let item = null
			let i = 0
			do {
				item = this.item_list[i]
				if (! item ) {
					item =  new BaseAwardItem(this.Content)
					this.item_list[i] = item
					item.Load()
					item.SetItemSize(90, 90)
				}
				let[ type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(list[i][0], list[i][1])
				item.SetData(type_id, list[i][2])
				i=i+1
			} while ((i < list.length))
		}
	}
}

public DeleteMe(){ 
	
	if (this.item_list ) {
		for (let _tmpi in this.item_list) {
			var item = this.item_list[_tmpi]
			item.DeleteMe()
		}
		this.item_list = null
	}
	super.DeleteMe()
}


bg_img:Laya.Image
rank_icon:Laya.Image
rank_label:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this.bg_img,
this.rank_icon,
this.rank_label,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"bg_img",
"rank_icon",
"rank_label",
"_Scroller1",
"Content",
])
}
}
 window["Kf1vnTicketRewardItem"]= Kf1vnTicketRewardItem