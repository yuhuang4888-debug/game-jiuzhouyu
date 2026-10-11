import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LoginModel } from "../login/LoginModel";
import { ClientConfig } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { SetHtmlCenter, Util } from "../util/Util";


export class AddVipServiceView extends BaseView1 {
	_img_bg: Laya.Image
	_img_title: Laya.Image
	_img_bg1: Laya.Image
	_img_link: Laya.Image
	bg3: Laya.Image
	_lab_title: Laya.HTMLDivElement
	Content: Laya.HBox
	_img_bg2: Laya.Image
	des: Laya.HTMLDivElement
	close: Laya.Image

	copyStr
	cfg
	item_list = []
	public constructor() {
		super()


		this.base_file = "addVipService"
		this.layout_file = "AddVipServiceView"
		this.use_background = true
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.preload_client_config = {
			"ClientAddVipService": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}
		this.close_callback = () => {
			if (this.item_list && Util.TableSize(this.item_list) > 0) {
				for (let _tmpi in this.item_list) {
					var item = this.item_list[_tmpi]
					item.DeleteMe()
					item = null
				}
				this.item_list = []
			}

		}
	}

	public LoadSuccess() {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientAddVipService", true)
		let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
		if (cfg) {
			for (let type in cfg) {
				if (cfg[type].tem && cfg[type].tem.length > 0) {
					if (cfg[type].tem.indexOf(play_name) > -1) {
						this.cfg = cfg[type]
					}
				}
			}
			if (!this.cfg) return
			ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetIcon("addVipService", "ui_gz_01"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("common2", "com_line_5"), true)
			ResManager.GetInstance().SetTexture(this, this._img_link, GameResPath.GetIcon("addVipService", `${this.cfg.code}`))
			ResManager.GetInstance().SetTexture(this, this._img_title, GameResPath.GetIcon("addVipService", `${this.cfg.title}`),undefined,undefined,true)
			this.SetDes()
			this.AddReward()
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this.close, () => {
			this.Close()
		}, this, true)

	}

	public SetDes() {
		this.des.style.fontSize = 26
		this.des.style.color = "#663915"
		this.des.width = 555
		this.des.style.wordWrap = true
		this.des.style.lineHeight = 20
		this.des.innerHTML = this.cfg.des
		this._lab_title.style.fontSize = 26
		this._lab_title.style.color = "#663915"
		this._lab_title.innerHTML = this.cfg.des1
		SetHtmlCenter(this._lab_title,{x:47,w:319})
	}
	public AddReward() {
		let list = this.cfg.reward
		if (list) {
			let item = null
			for (let i = 0; i < list.length; i++) {
				item = this.item_list[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					this.item_list[i] = item
					item.Load()
					item.SetItemSize(85, 85)
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(list[i][0], list[i][1])
				item.SetData(type_id, list[i][2])
			}
		}
	}


	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_bg1,
			this._img_link,
			this.bg3,
			this._lab_title,
			this.Content,
			this._img_bg2,
			this.des,
			this.close,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_bg1",
				"_img_link",
				"bg3",
				"_lab_title",
				"Content",
				"_img_bg2",
				"des",
				"close",
			])
	}
}
window["AddVipServiceView"] = AddVipServiceView