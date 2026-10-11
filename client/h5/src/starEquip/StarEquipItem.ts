import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, SetSizeDeltaY } from "../util/Util"
import { ColorType } from "../util/ColorUtil"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { StarEquipModel } from "../commonModel/StarEquipModel"

export class StarEquipItem extends BaseItem1 {
	cache_sort_order
	data
	model
	need_refresh
	cfg_starequip

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipItem"
		this.preload_client_config = {
			"ClientStarEquip": false
		}

		this.model = StarEquipModel.GetInstance()
		this.load_callback = () => {
			this.LoadSucces()
			this.Initvent()
		}
	}

	public LoadSucces() {
		this.cfg_starequip = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientStarEquip", true)
		if (this.need_refresh) {
			this.UpdateView()
		}
	}

	public Initvent() {
		Util.AddClickEvent(this.conGp, () => {
			if (this.data) {
				if (this.data.goods_id) {
					//let btnList = [StarEquipToolTip.Btn.outEquip, StarEquipToolTip.Btn.replace]
					let btnList = [2, 3]
					if ((this.data.addition_attrlist.length == 0 && this.data.color > 4) && this.data.subtype < 7) {
						//table.insert(btnList, StarEquipToolTip.Btn.transfrom)
						table.insert(btnList, 5)
					}
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(this.data.type_id, this.data, null, btnList)
				} else {
					let list = this.model.GetPageTypeEquip(this.data.page, this.data.subtype)
					if (list.length > 0) {
						this.model.Fire(StarEquipModel.OPEN_VIEW, "StarChangeEquipView", this.data)
					} else {
						let defaultId = this.cfg_starequip.defaultEquip[this.data.page + "@" + this.data.subtype]
						if (defaultId) {
							MaterialsTool.GetInstance().materialsTips(defaultId)
						}
					}
				}
			}
		}, this, true)

		this.BindEvent(this.model, StarEquipModel.REFRESH_RED, (type?) => {
			if (type == 1 && this.data) {
				let Num = this.model.equipRedList[this.data.page] && this.model.equipRedList[this.data.page][this.data.subtype]
				this.reddot.visible = Num && Num > 0
			}
		})
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh = true
		}
	}

	public UpdateView() {
		let star = this.data.star
		let type = this.data.subtype
		let color = this.data.color
		let bgRes = null
		//let flagRes = null
		let red = null
		//this.ClearUIEffect(this.effectGp)
		if (this.data.goods_id) {
			let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
			if (goodsBasic) {
				if (!this.use_delete_method) {
					this.iconImg.skin = null
					ResManager.GetInstance().SetOutsideImageSprite(this, this.iconImg, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon), () => {
						if (!this.data.goods_id) {
							ResManager.GetInstance().SetImageSprite(this, this.iconImg, "starEquip", "s0" + (type == 10 && 10 || ("0" + type)))
						}
					})
				}
			}
			if (color == 1) {
				bgRes = "uixzsy_005a"
			} else if (color == 2) {
				bgRes = "uixzsy_005b"
			} else if (color == 3) {
				bgRes = "uixzsy_005c"
			} else if (color == 4) {
				bgRes = "uixzsy_005d"
			} else if (color == 5) {
				bgRes = "uixzsy_005e"
			} else if (color == 7) {
				bgRes = "uixzsy_005f"
			}
			if (star) {
				ResManager.GetInstance().SetImageSprite(this, this.starEquipStarBg, "common", "flag" + color)
			}
			if (color > ColorType.PURPLE) {
				//this.AddUIEffect("ui_constellation_" + ColorUtil.GetColorEffectStr(color), "UI", this.effectGp, null, null, true, { custom_sorting_order = this.cache_sort_order })
			}

			// if (this.cache_sort_order) {
			// 	this.CoverEffect(this.bg, "UI", this.cache_sort_order + 1)
			// 	this.CoverEffect(this.iconImg, "UI", this.cache_sort_order + 2)
			// 	this.CoverEffect(this.starEquipGp, "UI", this.cache_sort_order + 3)
			// 	this.CoverEffect(this.reddot, "UI", this.cache_sort_order + 3)
			// }
			this.starEquipGp.visible = star && star > 0
			if (star) {
				if (star == 5) {
					for (let i = 0; i <= 3; i++) {
						this["starE" + i].visible = i == 1
					}
					this.starEquipNum.visible = true
					SetSizeDeltaY(this.starEquipStarBg, 63)
				} else {
					this.starEquipNum.visible = false
					for (let i = 0; i <= 3; i++) {
						this["starE" + i].visible = star > i
					}
					SetSizeDeltaY(this.starEquipStarBg, 23 + star * 20)
				}
			}
			ResManager.GetInstance().SetImageSprite(this, this.bg, "starEquip", bgRes)
			ResManager.GetInstance().SetImageSprite(this, this._img_bg, "common", "com_goods_plate_" + color)
			this.bg.visible = true
			this._img_bg.visible = true
			red = this.model.equipRedList[this.data.page] && this.model.equipRedList[this.data.page][this.data.subtype]
		} else {
			ResManager.GetInstance().SetImageSprite(this, this.iconImg, "starEquip", "s0" + (type == 10 && 10 || ("0" + type)))
			this.starEquipGp.visible = false
			this.bg.visible = false
			this._img_bg.visible = false
			red = this.model.equipRedList[this.data.page] && this.model.equipRedList[this.data.page][this.data.subtype]
		}
		this.reddot.visible = red && red > 0
	}

	public DeleteMe() {
		//if (this.effectGp ) {
		//this:ClearUIEffect(this.effectGp)
		//}
		super.DeleteMe()
	}

	public SetBaseCove(sort_order?) {
		this.cache_sort_order = sort_order
	}

	conGp: Laya.Box
	effectGp: Laya.Box
	_img_bg: Laya.Image
	bg: Laya.Image
	iconImg: Laya.Image
	starEquipGp: Laya.Box
	starEquipStarBg: Laya.Image
	starEquipNum: Laya.Image
	starE0: Laya.Image
	starE1: Laya.Image
	starE2: Laya.Image
	starE3: Laya.Image
	reddot: Laya.Image
	public GetComponents() {
		[
			this.conGp,
			this.effectGp,
			this._img_bg,
			this.bg,
			this.iconImg,
			this.starEquipGp,
			this.starEquipStarBg,
			this.starEquipNum,
			this.starE0,
			this.starE1,
			this.starE2,
			this.starE3,
			this.reddot,
		]
			= this.GetChildrenByNames([

				"conGp",
				"effectGp",
				"_img_bg",
				"bg",
				"iconImg",
				"starEquipGp",
				"starEquipStarBg",
				"starEquipNum",
				"starE0",
				"starE1",
				"starE2",
				"starE3",
				"reddot",
			])
	}
}
window["StarEquipItem"] = StarEquipItem