import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DungeonRuneEnterLineItem extends BaseItemRenderer {
	public WIDTH = 720
	public HEIGT = 280

	model: BaseDungeonModel
	public constructor(parent) {
		super()
		this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneEnterLineItem"
		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	LoadSuccess() {
		this._img_line.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_03")
		// ResManager.GetInstance().SetTexture(this.base_item, this._img_line, GameResPath.GetIcon("dungeonRune","ui_copy_03"))
		this.InitEvent()
	}

	InitEvent() {

	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.data) {
				let data = this.data
				let now_floor = data.dun_id - BaseDungeonModel.Rune_Floor_Modulus
				if(now_floor == 1){
					this._img_line.visible = false
				}
				else{
					this._img_line.visible = true
					if (now_floor % 2 == 0) {
						this._gp_con.x = 41
						this._img_line.scaleX = 1
						this._img_line.anchorX = 0
						this._img_line.x = 165
						this._img_line.y = 101
					}
					else {
						this._gp_con.x = 466
						this._img_line.scaleX = -1
						this._img_line.anchorX = 1
						this._img_line.x = -259
						this._img_line.y = 101
					}
				}

			}
		}
	}

	_gp_con: Laya.Box
	_img_line: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_line,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_line",
			])
	}
}

window["DungeonRuneEnterLineItem"] = DungeonRuneEnterLineItem