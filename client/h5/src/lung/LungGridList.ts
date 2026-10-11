import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { LungModel } from "../commonModel/LungModel";
import { AtlasUrl, RefBoxVLayout } from "../util/Util";
import { LungGridItem } from "./LungGridItem";

export class LungGridList extends BaseItem1 {

	LoadSuccess
	InitEvents
	SetData
	SetGridItemList
	ShowAnimation
	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungGridList"
		let model = LungModel.GetInstance(),
			// local_egret = egret,
			grid_item_list_ = [],
			data_,
			needRefresh_,
			need_show_tween_ = true,
			init_y_ = 0,
			index_ = 0
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
			if (grid_item_list_) {
				for (let item of grid_item_list_) {
					item.DeleteMe()
				}
				grid_item_list_ = null
			}
			need_show_tween_ = true
			index_ = 0
			super.DeleteMe()

		}
		this.LoadSuccess = () => {
			init_y_ = this.con.y
			ResManager.GetInstance().SetTexture(this, this.bg, "resource/game/lung/texture/uilwmb_009.png", undefined, this, true)
		}

		this.InitEvents = () => {

			if (needRefresh_) {
				this.SetData(data_, index_)
				needRefresh_ = null
			}
		}

		this.SetData = (data, index) => {
			data_ = data
			index_ = index
			if (this.is_loaded) {
				if (data_) {
					if (data_.grid_list) {
						this.SetGridItemList(data_.grid_list)
					}
					let source = "uilwmb_013"
					if (data_.style == 2) {
						source = "uilwmb_014"
					} else if (data_.style == 3) {
						source = "uilwmb_015"
					}
					this.lung_style.skin = AtlasUrl("lung", source)
					this.ShowAnimation()
				}
			} else {
				needRefresh_ = true
			}
		}

		this.SetGridItemList = (grid_list) => {
			if (grid_list) {
				let item: LungGridItem
				for (let i = 0, length = grid_list.length; i < length; i++) {
					item = grid_item_list_[i]
					if (!item) {
						item = new LungGridItem(this.list_con)
						item.Load()
						grid_item_list_[i] = item
					}
					item.SetData(grid_list[i])
				}
			}
		}

		this.ShowAnimation = () => {
			if (this.is_loaded) {
				if (need_show_tween_) {
					Laya.Tween.clearAll(this.con)
					need_show_tween_ = false
					this.con.y = init_y_ - 200
					this.con.alpha = 0
					this.con.visible = true
					Laya.Tween.to(this.con, { y: init_y_, alpha: 1 }, 250, undefined, undefined, index_ * 50)
				} else {
					this.con.alpha = 1
					this.con.visible = true
				}
			}
		}
	}


con:Laya.Box
bg:Laya.Image
lung_style:Laya.Image
list_con:Laya.VBox
public GetComponents() {
[
this.con,
this.bg,
this.lung_style,
this.list_con,
]
 = this.GetChildrenByNames([

"con",
"bg",
"lung_style",
"list_con",
])
}
}
 window["LungGridList"]= LungGridList