import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class EveningBossDamageItem extends BaseItem1 {

	is_need_fresh
	index
	data
	str_list = ["ui_phb_1a", "ui_phb_1b", "ui_phb_1c"]
	public constructor(parent) {
		super(parent)
		this.is_need_fresh = false
		this.base_file = "evening"
		this.layout_file = "EveningBossDamageItem"

		this.load_callback = () => {
			if (this.is_need_fresh) {
				this.SetData(this.data,this.index)
				this.is_need_fresh = false
			}
		}
	}


	public DeleteMe() {
		super.DeleteMe()
	}



	public SetData(data,idx) {
		this.data=data
		this.index=idx
		if(!this.is_loaded){
			this.is_need_fresh=true
			return
		}

		this._lb_name.text = this.data.player_name
		this._lb_hurt.text = `${Number(this.data.modulus).toFixed(2)}%`
		let is_three = this.index < 3
		this.img_rank.visible = is_three
		this._lb_rank.visible = !is_three
		if (is_three) {
			let str = this.str_list[this.index]
			ResManager.GetInstance().SetImageSprite(this, this.img_rank, "evening_asset", str, true)
		} else {
			this._lb_rank.text = `${this.index+1}`
		}
	}



img_rank:Laya.Image
_lb_rank:Laya.Label
_lb_name:Laya.Label
_lb_hurt:Laya.Label
img_line:Laya.Image
public GetComponents() {
[
this.img_rank,
this._lb_rank,
this._lb_name,
this._lb_hurt,
this.img_line,
]
 = this.GetChildrenByNames([

"img_rank",
"_lb_rank",
"_lb_name",
"_lb_hurt",
"img_line",
])
}
}
 window["EveningBossDamageItem"]= EveningBossDamageItem