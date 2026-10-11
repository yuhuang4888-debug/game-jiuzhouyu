import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { DemonModel } from "../commonModel/DemonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class DemonRotaryItem extends BaseItem1 {
	cache_order
	shows
	type_id

	public constructor(parent?) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonRotaryItem"
		this.load_callback = () => {
			this._img_clip.visible=false
			this.InitEvent()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.click, () => {
			if (this.type_id) {
				UIToolTipMgr.GetInstance().DefaultAppendTips(this.type_id, 0)
			}
		}, this, false)
	}

	public InitView(goods?, type?) {
		let url = GameResPath.GetIcon("demon", "uijlzp_007")// "demon_json.uijlzp_007_png"
		// if (type == 2) {
		// 	url = GameResPath.GetIcon("demon", "uijlzp_007b") //"demon_json.uijlzp_007b_png"
		// }
		this._bg.skin = url
		if (goods) {
			this.type_id = goods
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods)
			if (basic) {
				this._img_clip.visible =basic.type == 73 && basic.subtype == 2
				let icon_url = DemonModel.GetInstance().GetCirItemIcon(basic)
				ResManager.GetInstance().SetTexture(this, this._good, icon_url)
			}
			this._new.visible = false
			let shows = this.shows
			if (shows && shows != "[]") {
				shows = JSON.parse(shows)
				shows = shows[type - 1] && shows[type - 1][1]
				if (shows) {
					for (let _tmpi in shows) {
						let k = shows[_tmpi]
						let [_type, lock] = GoodsModel.GetInstance().GetMappingTypeId(k[0], k[1])
						if (_type == this.type_id) {
							this._new.visible = true
							break
						}
					}
				}
			}
		}
	}

	public SetCacheSortOrder(cache_order?) {
		this.cache_order = cache_order
	}

	public SetData(...parms) {
		if (parms[2]) {
			this.shows = parms[2]
		}
		this.InitView(parms[0], parms[1])
	}


_bg:Laya.Image
_eff:Laya.Box
_good:Laya.Image
_img_clip:Laya.Image
_new:Laya.Image
click:Laya.Image
public GetComponents() {
[
this._bg,
this._eff,
this._good,
this._img_clip,
this._new,
this.click,
]
 = this.GetChildrenByNames([

"_bg",
"_eff",
"_good",
"_img_clip",
"_new",
"click",
])
}
}
 window["DemonRotaryItem"]= DemonRotaryItem