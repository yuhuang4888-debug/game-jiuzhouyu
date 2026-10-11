import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RevelationModel } from "../commonModel/RevelationModel"
import { RevelationToolTips } from "../common/RevelationToolTips"

export class Revelation1EquipItem extends BaseItem1 {
	model
	res_mgr
	goods_model

	cache_sort_order
	data
	need_refresh_data
	other_player
	suit_info
	public constructor(parent?) {
		super(parent)
		this.base_file = "revelation"
		this.layout_file = "RevelationEquipItem"

		this.model = RevelationModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.preload_server_config = {
			"config_revelation_equip_attr" : false
		}

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_con, () => {
			if (this.data && this.data.type_id && this.data.type_id != 0) {
				if(this.other_player){
					let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_revelation_equip_attr",false)
					let info = cfg[this.data.type_id]
					let num = 0
					for(let key in this.suit_info){
						if(info.star == this.suit_info[key].star){
							num = this.suit_info[key].num
						}
					}
					this.data["goods_id"] = this.data.type_id
					UIToolTipMgr.GetInstance().AppendRevelationTooltips(this.data.type_id, this.data, null, [RevelationToolTips.Btn.close],num)
				}else{
					UIToolTipMgr.GetInstance().AppendRevelationTooltips(this.data.type_id, this.data, null, [RevelationToolTips.Btn.unload])
				}
			}
		}, this, true)
	}

	public SetData(data?,other_player?,suit_info?) {
		this.data = data
		this.other_player = other_player
		this.suit_info = suit_info
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView(no_effect?) {
		if (!this.data) {
			return
		}
		let type_id = this.data.type_id
		if (type_id == 0) {
			this._img_bg.visible = false
			this.star_group.visible = false
			
			this.res_mgr.SetImageSprite(this, this._img_icon, "revelation", "ui_Apocalypse_zb" + this.data.equip_type)
			//this.CoverEffect(this._img_icon, "UI", this.cache_sort_order)
			this.ClearUIEffect(this.effectGp)
		} else {
			let goods_basic = this.goods_model.GetGoodsBasicByTypeId(type_id)
			if (goods_basic) {
				if (!no_effect) 
				{
					this.AddUIEffect("UI_1609_01", this.effectGp, null, 10, true)
					// this.CoverEffect(this._img_icon, "UI", this.cache_sort_order)
					// this.CoverEffect(this.star_group, "UI")
					// this.CoverEffect(this.star_group, "UI")
				}
				this._img_icon.skin = undefined
				this.res_mgr.SetOutsideImageSprite(this, this._img_icon, "resource/game/goodsIcon/" + goods_basic.goods_icon + ".png")

				let equip_data = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_attr", false)[type_id]
				if (equip_data) {
					this.star_group.visible = true
					let i = 0
					do {
						this["star_" + i].visible = i < equip_data.star
						i = i + 1
					} while ((i < 4))
				}
			}
		}
		return true
	}

	public DeleteMe() {
		this.ClearUIEffect(this.effectGp)
		super.DeleteMe()
	}

	public SetBaseCove(sort_order?) {
		this.cache_sort_order = sort_order
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	effectGp: Laya.Box
	star_group: Laya.Box
	star_0: Laya.Image
	star_1: Laya.Image
	star_2: Laya.Image
	star_3: Laya.Image
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._img_icon,
			this.effectGp,
			this.star_group,
			this.star_0,
			this.star_1,
			this.star_2,
			this.star_3,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_img_bg",
				"_img_icon",
				"effectGp",
				"star_group",
				"star_0",
				"star_1",
				"star_2",
				"star_3",
			])
	}
}
window["Revelation1EquipItem"] = Revelation1EquipItem