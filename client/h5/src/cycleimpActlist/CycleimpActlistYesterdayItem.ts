
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { SetHtmlCenter, Util } from "../util/Util"
export class CycleimpActlistYesterdayItem extends BaseItemRenderer {


	public static width = 463
	public static height = 60
	WIDTH = 552
	HEIGT = 48
	public constructor(parent) {
		super()


		this.base_file = "cycleimpActlist"
		this.layout_file = "CycleimpActlistYesterdayItem"
		this.load_callback = () => {

		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let rank = this.data.rank
			let bool = rank < 4
			this._img_rank.visible = bool
			this._lb_rank.visible = !bool
			let url1 = "ui_activity_11"
			if (bool) {
				let url = ""

				if (1 == rank) {
					url = "rank_icon_1"
					url1 = "ui_activity_08"
				} else if (2 == rank) {
					url = "rank_icon_2"
					url1 = "ui_activity_09"
				} else if (3 == rank) {
					url = "rank_icon_3"
					url1 = "ui_activity_10"
				}
				ResManager.GetInstance().SetImageSprite(this, this._img_rank, "cycleimpActlist", url)
			} else {
				this._lb_rank.text = rank
			}
			ResManager.GetInstance().SetImageSprite(this, this._img_rank1, "cycleimpActlist", url1)
			this._lb_level.style.fontSize = 20
			this._lb_level.width = 174
			this._lb_level.style.align = "center"
			this._lb_level.style.color = "#d15e00"
			if (this.data.role_id) {
				this._lb_level.innerHTML = this.data.role_score + "分"
				this._lb_name.text = "S" +this.data.server_id + "." + this.data.role_name
			} else {
				this._lb_name.text = "虚位以待"
				this._lb_level.visible = false
			}

			SetHtmlCenter(this._lb_level,{x:374,w:174})
		}
	}


	public DeleteMe() {
		super.DeleteMe()
	}



_img_rank1:Laya.Image
_img_rank:Laya.Image
_lb_rank:Laya.Label
_lb_name:Laya.Label
_lb_level:Laya.HTMLDivElement
public GetComponents() {
[
this._img_rank1,
this._img_rank,
this._lb_rank,
this._lb_name,
this._lb_level,
]
 = this.GetChildrenByNames([

"_img_rank1",
"_img_rank",
"_lb_rank",
"_lb_name",
"_lb_level",
])
}
}
 window["CycleimpActlistYesterdayItem"]= CycleimpActlistYesterdayItem