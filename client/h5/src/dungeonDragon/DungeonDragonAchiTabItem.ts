import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"

export class DungeonDragonAchiTabItem extends BaseItemRenderer {
	public WIDTH = 126
	public HEIGT = 56

	public constructor(parent) {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonAchiTabItem"
		this.load_callback = () => {
			this.BindEvent(BaseDungeonModel.GetInstance(), BaseDungeonModel.UPDATE_WAVE_REWARD_DATA, (dun_id?) => {
				if (this.data&&this.data.dun_id == dun_id) {
					this.UpdateRed()
				}
			}
			)
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.UpdateRed()
	}

	public UpdateRed() {

		let data = BaseDungeonModel.GetInstance().GetWaveRewardData(this.data.dun_id)
		let bool = false
		if (data) {
			let list = data.list
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (vo.reward.length > 0 && vo.state == 0) {
					bool = true
					break
				}
			}
		}
		this._img_red.visible = bool


		let text_color = null
		let img_str = ""
		if (this.selected) {
			text_color ="#9b572f"
			img_str = "ui_btn_achv_highlight"
		} else {
			text_color = "#ffffff"
			img_str = "ui_btn_achv"
		}

		this._Label1.text = this.data.desc
		this._Label1.color = text_color
		ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4", img_str, true)
	}

	public DeleteMe() {

		super.DeleteMe()
	}


	_Image1: Laya.Image
	_Label1: Laya.Label
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Label1,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Label1",
				"_img_red",
			])
	}
}
window["DungeonDragonAchiTabItem"] = DungeonDragonAchiTabItem