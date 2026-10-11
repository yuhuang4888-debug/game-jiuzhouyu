import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RevelationEvent } from "../commonModel/RevelationModel"
import { RevelationModel } from "../commonModel/RevelationModel"
import { RoleManager } from "../commonModel/RoleManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class RevelationShowView extends BaseView1 {
	InitView
	Open
	effect_group

	public constructor() {
		super()
		this.base_file = "pet"
		this.layout_file = "OutwardChangedView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 1
		this.is_center = true
		this.click_bg_toClose = true

		let resMgr = ResManager.GetInstance()
		// let horse_model_ = null
		let data_ = null

		this.load_callback = () => {
			Util.AddClickEvent(this.click_group, () => {
				this.Close()
			}, this, false)

			this.InitView()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			RevelationModel.GetInstance().Fire(RevelationEvent.OPEN_VIEW, "RevelationActiveView", { star: data_ - 1, num: 10 })
			data_ = null
		}

		this.Open = (...new_args) => {
			let data = new_args
			if (data) {
				data_ = data[0]
			}
			super.Open()
		}

		this.InitView = () => {
			if (!data_) {
				return
			}
			let suitCfg = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_figuire
			resMgr.SetOutsideImageSprite(this, this.table_img, GameResPath.GetIcon("pet", "uixxxjs_001"), true)
			// let res = null
			let cfg = suitCfg[data_]
			if (cfg) {
				let role_vo = RoleManager.GetInstance().GetMainRoleVo()
				let [res, texture_id] = Util.GetRevelationClothesRes(data_, role_vo.sex)
				let [hairs, hairs_text_id] = Util.GetRevelationHairRes(data_, role_vo.sex)
				let weapon_model_id = role_vo.GetWeaponClotheId()

				let data = {
					clothe_res_id : res,
					texture_id :  texture_id,
					type :UI_MODEL_TYPE.ROLE,
					can_rotate : true,
					layer_value : this.layer_value,
					scale : 0.7,
					// rotate = pos_cfg && pos_cfg.change_rotate,
					position: new Vector2(0.3, 1),
					head_wear_id : hairs,
					head_clothe_id : hairs_text_id,
					fashion_model_id : res,
					sex : role_vo.sex,
					career : role_vo.career,
					weapon_res_id : weapon_model_id,
				}
				ResManager.GetInstance().SetRoleModel(this, this.model_group, data)

				this.name_label.text = cfg.suit_name
			}

			// resMgr.SetUIEffect(this, "ui_1402", this.layer_value, this.image_bigglow_group, null, null, true)
			// let data = {
			// 	load_call_back =() => {
			// 		Util.AddClickEvent(this.click_group, () => {
			// 			this.Close()
			// 		}, this, false)
			// 	}
			// }
			// resMgr.SetUIEffect(this, "ui_1128", this.layer_value, this.image_text_group, null, null, true, data)
		}
	}

	image_text_group: Laya.Box
	tipstext: Laya.Label
	table_img: Laya.Image
	image_bigglow_group: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	success_image: Laya.Image
	outward_img: Laya.Image
	model_group: Laya.Box
	image_text: Laya.Image
	image_name: Laya.Image
	name_label: Laya.Label
	click_group: Laya.Box
	wx_share_con: Laya.Box
	click: Laya.Image
	public GetComponents() {
		[
			this.image_text_group,
			this.tipstext,
			this.table_img,
			this.image_bigglow_group,
			this._Image1,
			this._Image2,
			this.success_image,
			this.outward_img,
			this.model_group,
			this.image_text,
			this.image_name,
			this.name_label,
			this.click_group,
			this.wx_share_con,
			this.click,
		]
			= this.GetChildrenByNames([
				"image_text_group",
				"tipstext",
				"table_img",
				"image_bigglow_group",
				"_Image1",
				"_Image2",
				"success_image",
				"outward_img",
				"model_group",
				"image_text",
				"image_name",
				"name_label",
				"click_group",
				"wx_share_con",
				"click",
			])
	}
}
window["RevelationShowView"] = RevelationShowView