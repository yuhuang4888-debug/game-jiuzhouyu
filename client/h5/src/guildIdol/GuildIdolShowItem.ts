import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildModel } from "../commonModel/GuildModel"
import { SetLocalScale } from "../util/Util"

export class GuildIdolShowItem extends BaseItem1 {
	LoadSuccess
	setData
	setScale

	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolShowItem"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let _god_id = null
		let _color = null
		let _scale = 1
		let refresh = false
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			if (refresh) {
				this.setData(_god_id, _color)
				this.setScale(_scale)
			}
		}

		this.setData = (god_id?, color?) => {
			_god_id = god_id
			//_color = color
			_color = color == 6 && 7 || color
			if (!this.is_loaded) {
				refresh = true
				return
			}
			ResManager.GetInstance().SetImageSprite(this, this._img, "guildidol_asset", "show_" + _god_id, true)
			ResManager.GetInstance().SetImageSprite(this, this.item_bg, "common_asset", "com_goods_plate_" + _color, true)
		}

		this.setScale = (scale?) => {
			_scale = scale
			if (!this.is_loaded) {
				refresh = true
				return
			}
			SetLocalScale(this.display_obj, scale)
		}


	}


	item_bg: Laya.Image
	_img: Laya.Image
	public GetComponents() {
		[
			this.item_bg,
			this._img,
		]
			= this.GetChildrenByNames([

				"item_bg",
				"_img",
			])
	}
}
window["GuildIdolShowItem"] = GuildIdolShowItem