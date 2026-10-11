import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class StarEquipActiveSuit extends BaseView1 {
	Open
	closeTimer
	type
	page
	num

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipActiveSuit"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_constellation_page": false
		}
		this.preload_client_config = {
			"ClientStarEquip": false
		}
		//this.open_callback = () => {
		////this:AddUIEffect("ui_popup_windowglow1", this.effectGp1, null, null, true)
		////lua_resM:SetOutsideImageSprite(this,this._Image1 , GameResPath.GetIcon("starEquip","uixzsy_036"),true)
		//}

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_light, GameResPath.GetIcon("starEquip", "uixzsy_036a"))
			ResManager.GetInstance().SetImageSprite(this, this._Image1, "starEquip", "uixzsy_036")
			ResManager.GetInstance().LoadFont(this, "chc", this.countLb)
		}

		this.destroy_callback = () => {
			//this:ClearUIEffect(this.effectGp0)
			//this:ClearUIEffect(this.effectGp1)
		}

		this.open_callback = () => {
			// this.AddUIEffect("ui_constellation_suit", Enum_UILayer.Activity, this.effectGp0, null, null, true)
			// this.CoverEffect(this._Label1, "Activity")
			// this.CoverEffect(this.countLb, "Activity")
			// this.CoverEffect(this.suitImg, "Activity")

			let ClientCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientStarEquip", true)
			if (ClientCfg) {
				ResManager.GetInstance().SetImageSprite(this, this.suitImg, "starEquip_asset", ClientCfg.suitImg[this.page + "@" + this.type], true)
			}
			let cfg_page = ResManager.GetInstance().GetGameConfigFromCache(this, "config_constellation_page", false)
			let suitCfg = cfg_page[this.page]
			if (suitCfg) {
				let suitArr = JSON.parse(this.type == 1 && suitCfg.normal_suit_attr || suitCfg.special_suit_attr)
				let max = suitArr[suitArr.length - 1][0]
				this.countLb.text = this.num + "/" + max + "件"
			}
		}

		this.Open = (...new_args) => {
			this.page = new_args[0]
			this.num = new_args[1]
			this.type = new_args[2]
			this.closeTimer = setTimeout(() => {
				//Laya.Tween.get(this):to({alpha=0}, 1500).call(() => {
				this.Close()
				//}
				//)
			}
				, 40000)
			super.Open()
		}

		this.close_callback = () => {
			if (this.closeTimer) {
				clearTimeout(this.closeTimer)
				this.closeTimer = null
			}
			//Laya.Tween.removeTweens(this)
		}
	}

	_img_light: Laya.Image
	_Image1: Laya.Image
	suitImg: Laya.Image
	_img_titlebg: Laya.Image
	_Label1: Laya.Label
	countLb: Laya.Label
	effectGp0: Laya.Box
	effectGp1: Laya.Box
	public GetComponents() {
		[
			this._img_light,
			this._Image1,
			this.suitImg,
			this._img_titlebg,
			this._Label1,
			this.countLb,
			this.effectGp0,
			this.effectGp1,
		]
			= this.GetChildrenByNames([
				"_img_light",
				"_Image1",
				"suitImg",
				"_img_titlebg",
				"_Label1",
				"countLb",
				"effectGp0",
				"effectGp1",
			])
	}
}
window["StarEquipActiveSuit"] = StarEquipActiveSuit