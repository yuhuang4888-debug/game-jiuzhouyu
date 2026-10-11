
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
export class EveningAnswerItem extends BaseItemRenderer {
	is_set
	public WIDTH= 269
	public HEIGT = 33
	ar_color=["#cf6d00","#e03fea","#1d7fe5"]//1橙 2紫 3蓝

	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "evening"
		this.layout_file = "EveningAnswerItem"
		

		this.load_callback = () => {
			if (!this.is_set) {
				this.is_set = true
				this.SetDate()
			}
		}

		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if (!this.is_loaded) {
			this.is_set = false
		} else {
			this.is_set = true
			this.SetDate()
		}
	}

	SetDate() {
		if (!this.data) return
		let data = this.data
		if(data.ser_num==0){
			this._lb_name.text = `${data.name}  ${data.score}分`
		}else{
		this._lb_name.text = `S${data.ser_num}.${data.name}  ${data.score}分`
		}
		this._lb_name.color=this.GetNameColor(this.data.rank)

		let str_list = ["ui_phb_1a", "ui_phb_1b", "ui_phb_1c"]
		let bool = data.rank < 4
		this._img_rank.visible = bool
		this._lb_rank.visible = !bool
		if (bool) {
			let str = str_list[this.data.rank-1]
			ResManager.GetInstance().SetImageSprite(this, this._img_rank, "evening_asset", str)
		} else {
			this._lb_rank.text = data.rank
		}
	}

	
	GetNameColor(rank?):string{
		if(rank<=3)return this.ar_color[rank-1]
		return "#4a3a32"
	}

	public DeleteMe(){
		super.DeleteMe()
	}


_Group1:Laya.Box
_bg:Laya.Image
_img_rank:Laya.Image
_lb_rank:Laya.Label
_lb_name:Laya.Label
public GetComponents() {
[
this._Group1,
this._bg,
this._img_rank,
this._lb_rank,
this._lb_name,
]
 = this.GetChildrenByNames([

"_Group1",
"_bg",
"_img_rank",
"_lb_rank",
"_lb_name",
])
}
}
 window["EveningAnswerItem"]= EveningAnswerItem