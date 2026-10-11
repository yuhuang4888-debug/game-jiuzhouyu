import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildModel } from "../commonModel/GuildModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class GuildIdolRuneSmallItem extends BaseItem1 {
	LoadSuccess
	setData
	refresh
	hideBg
	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneSmallItem"
		this.layer_value = Enum_UILayer.Activity
		let _model = GuildModel.GetInstance()
		let type_id = null
		this.refresh = false
		let showGp = true
		let needLv = 0

		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			if (this.refresh ) {
				this.setData(type_id, showGp, needLv,this.hideBg)
				this.refresh  = false
			}
		}

		this.setData = (_type_id?, _showGp?, _needLv?,_hideBg?) => {
			if (_showGp == null) {
				_showGp = true
			}
			type_id = _type_id
			showGp = _showGp
			needLv = _needLv
			this.hideBg=_hideBg?_hideBg:false
			if (!this.is_loaded) {
				this.refresh  = true
				return
			}else{
				this.refresh =false
			}

			if (!_type_id) {
				this._gp_show.visible = false
				this._icon.visible = false
				let have_need_lv = _needLv && _needLv > 0
				this._lb_target.visible = have_need_lv
				if (have_need_lv) {
					this._lb_target.text = "LV." + _needLv
				}
				Util.SetImageGray(this._img_22, true)
			} else {
				Util.SetImageGray(this._img_22, false)
				this._gp_show.visible = _showGp
				this._lb_target.visible = _showGp
				ResManager.GetInstance().SetOutsideImageSprite(this, this._icon, GameResPath.GetGoodsIconPath(_type_id), true)
				if (_showGp) {
					this._lb_target.text = "LV." + _needLv
					let str = String(_type_id)
					let lv = Number(str.charAt(str.length - 1))//Number(string.sub(str, -1))
					lv = lv == 0 ? 10 : lv
					this._lb_lv.text = "LV." + lv
					let gray_bool = lv < _needLv
					Util.SetImageGray(this._img_22, gray_bool)
					Util.SetImageGray(this._icon, gray_bool)
					//Util.SetImageGray(this._Image1, gray_bool)
				}
			}

			this._img_22.visible = !this.hideBg
		}


	}

	public DeleteMe() {
		super.DeleteMe()
	}


_gp:Laya.Box
_img_22:Laya.Image
_icon:Laya.Image
_gp_show:Laya.Box
_Image2:Laya.Image
_lb_lv:Laya.Label
_lb_target:Laya.Label
public GetComponents() {
[
this._gp,
this._img_22,
this._icon,
this._gp_show,
this._Image2,
this._lb_lv,
this._lb_target,
]
 = this.GetChildrenByNames([

"_gp",
"_img_22",
"_icon",
"_gp_show",
"_Image2",
"_lb_lv",
"_lb_target",
])
}
}
 window["GuildIdolRuneSmallItem"]= GuildIdolRuneSmallItem