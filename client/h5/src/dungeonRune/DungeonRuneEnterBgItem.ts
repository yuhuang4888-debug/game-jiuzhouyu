import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DungeonRuneEnterBgItem extends BaseItemRenderer {
	public WIDTH = 720
	public HEIGT = 280//140

	model: BaseDungeonModel
	public constructor(parent) {
		super()
		this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneEnterBgItem"
		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	LoadSuccess() {
		this._img_now_floor.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_02")
		// ResManager.GetInstance().SetTexture(this.base_item, this._img_now_floor, GameResPath.GetIcon("dungeonRune","ui_copy_02"))
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
				this._img_now_floor.visible = !this.model.RuneChallenged(now_floor) && this.model.RuneCanChallenge(now_floor)
				if (now_floor % 2 == 0) {
					this._gp_con.x = 41
				}
				else {
					this._gp_con.x = 466
				}

			}
		}
	}

	_gp_con: Laya.Box
	_img_now_floor: Laya.Image
	_img_bg: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_now_floor,
			this._img_bg,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_img_now_floor",
				"_img_bg",
			])
	}
}

window["DungeonRuneEnterBgItem"] = DungeonRuneEnterBgItem