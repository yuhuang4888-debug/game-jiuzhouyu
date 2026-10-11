import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, SetLocalScale } from "../util/Util"

export class GuildIdolMainRuneItem extends BaseItem1 {
	InitEvent
	LoadSuccess
	setData
	setPos
	setScale
	setSelect
	data
	god_id
	public constructor(parent?) {
		super(parent)
		this.data=null
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolMainRuneItem"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let refresh = false
		let _scale = 1
		let pos = null
		this.god_id = null

		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._box, () => {
				if (this.data != null) {
					return
				}
				_model.RunePos =
				{
					pos: pos,
					god_id: this.god_id,
					type_id: 0
				}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuildIdolRuneSelView")
			}
				, this, true)

			Util.AddClickEvent(this._box, () => {
				if (!this.data) {
					return
				}
				this.setSelect(true)
				_model.Fire(GuildEvent.IDOL_RUNE_SELECT, pos, this.data)
			}
				, this)
		}

		this.LoadSuccess = () => {
			if (refresh) {
				this.setData(this.data,this.god_id)
				this.setScale(_scale)
				refresh = false
			}
		}

		this.setData = (_data1?, _god_id?) => {
			this.data = _data1
			this.god_id = _god_id
			if (!this.is_loaded) {
				refresh = true
				return
			}
			let have_data = _data1 != null
			this._img_add.visible = !have_data
			this._gp_lv.visible = have_data
			this._img.visible = have_data
			if (have_data) {
				let type_id = String(_data1.goods_type_id)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetGoodsIconPath(type_id), true)
				let lv = type_id.charAt(type_id.length - 1)
				lv = Number(lv) == 0 ? 10 + "" : lv
				this._lb_lv.text = "LV." + lv
			}
			let rune_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune
			let red_bool = (_data1 && _model.runeCanUpByTypeId(_data1.goods_type_id, rune_cfg)) || _model.runeCanPutByPos(this.god_id, pos)
			this._red.visible = red_bool
		}

		this.setScale = (scale?) => {
			_scale = scale
			if (!this.is_loaded) {
				refresh = true
				return
			}
			SetLocalScale(this.display_obj, scale)
		}

		this.setPos = (_pos?) => {
			pos = _pos
		}

		this.setSelect = (bool?) => {
			this._select.visible = bool
		}


	}

	public DeleteMe(){
		super.DeleteMe()
	}

	
_Image1:Laya.Image
_img:Laya.Image
_select:Laya.Image
_gp_lv:Laya.Box
_Image2:Laya.Image
_lb_lv:Laya.Label
_red:Laya.Image
_img_add:Laya.Image
_box:Laya.Box
public GetComponents() {
[
this._Image1,
this._img,
this._select,
this._gp_lv,
this._Image2,
this._lb_lv,
this._red,
this._img_add,
this._box,
]
 = this.GetChildrenByNames([

"_Image1",
"_img",
"_select",
"_gp_lv",
"_Image2",
"_lb_lv",
"_red",
"_img_add",
"_box",
])
}
}
 window["GuildIdolMainRuneItem"]= GuildIdolMainRuneItem