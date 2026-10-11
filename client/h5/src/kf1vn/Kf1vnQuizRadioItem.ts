import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { ShopModel } from "../commonModel/ShopModel"
import { ColorUtil } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class Kf1vnQuizRadioItem extends BaseItem1 {
	is_delay_callback
	item
	model
	needRefresh
	select_cache
	vo
	cache_id

	public constructor(parent?) {
		super(parent)

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnQuizRadioItem"
		this.model = Kf1vnModel.GetInstance()
		this.is_delay_callback = false
		this.cache_id=null
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {


	}

	public InitEvents() {

		Util.AddClickEvent(this._box_click, () => {
			if (this.vo) {
				if(this.select_cache){
					this.model.Fire(Kf1vnEvent.KF1VN_SELECT_RADIO_ITEM, null, null)
				}else{
				this.model.Fire(Kf1vnEvent.KF1VN_SELECT_RADIO_ITEM, this.vo[0], this.vo)
				}
			}
		}
			, this, true)

		this.BindEvent(this.model, Kf1vnEvent.KF1VN_SELECT_RADIO_ITEM, (id?) => {
			if(id==null){
				this.SetSelect(false)
			}else{
				if(this.vo){
			this.SetSelect(this.vo && this.vo[0] == id)
				}else{
					this.cache_id=id
				}
			}
		}
		)

		if (this.needRefresh) {
			this.SetData(this.vo)
		}
	}

	public SetData(vo?) {

		this.vo = vo
		if (this.is_loaded && this.vo) {
			if (!this.item) {
				this.item = new BaseAwardItem(this.cost_icon)
				this.item.Load()
				this.item.SetShowTips(false)
				this.item.SetItemSize(30, 30)
				this.item.SetItembgVisible(false)
			}
			if (this.vo[1] && this.vo[1][0]) {
				let tmp = this.vo[1][0]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(tmp[0], tmp[1])
				this.item.SetData(type_id)
				let[ enough, gap, my_have, alert_str] = ShopModel.GetInstance().MoneyIsEnough(tmp[0], tmp[2])
				this.cost_num.text = tmp[2]
				if (!enough) {
					this.cost_num.color = ColorUtil.TryParseHtmlString("#ff4f50")
				}
			}
			if (this.select_cache != null) {
				this.SetSelect(this.select_cache)
				this.select_cache = null
			}else{
				if(this.cache_id){
					this.SetSelect(this.vo && this.vo[0] == this.cache_id)
				}else{
					this.SetSelect(false)
				}
			}
		} else {
			this.needRefresh = true
		}
	}

	public SetSelect(bool?) {
		this.select_cache = bool
		if (this.is_loaded) {
			ResManager.GetInstance().SetImageSprite(this, this.radio_img, "common_asset", bool == true && "com_ui_gx1" || "com_ui_gx")
		}
	}

	radio_img: Laya.Image
	cost_num: Laya.Label
	cost_icon: Laya.Box
	_box_click: Laya.Box
	public GetComponents() {
		[
			this.radio_img,
			this.cost_num,
			this.cost_icon,
			this._box_click,
		]
			= this.GetChildrenByNames([

				"radio_img",
				"cost_num",
				"cost_icon",
				"_box_click",
			])
	}
}
window["Kf1vnQuizRadioItem"] = Kf1vnQuizRadioItem