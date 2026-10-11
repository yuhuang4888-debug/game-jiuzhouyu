import { BaseView1 } from "../common/BaseView1"
import { Vector3 } from "../util/Vector3"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class SuitActivityActiveView extends BaseView1 {
	InitView
	Open
	roleModel

	public constructor() {
		super()
		this.base_file = "pet"
		this.layout_file = "OutwardChangedView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 1
		this.click_bg_toClose = true
		let resMgr = ResManager.GetInstance()
		let horse_model_ = null
		let data_ = null

		this.load_callback = () => {
			this.InitView()
		}

		this.open_callback = () => {
			//this.InitView()
		}

		this.destroy_callback = () => {
			//RevelationModel:GetInstance():Fire(RevelationEvent.OPEN_VIEW, "RevelationActiveView", {star = data_ - 1 ,num = 10})
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
			let suitCfg = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
			resMgr.SetOutsideImageSprite(this, this.table_img, GameResPath.GetIcon("pet", "uixxxjs_001"), true)
			let res = null
			let cfg = suitCfg[data_ + "@" + RoleManager.GetInstance().GetMainRoleCareer()]
			if (cfg) {
				let role_vo = RoleManager.GetInstance().GetMainRoleVo()
				let pos_x = role_vo.sex == 1 ? 0.2 : -0.2
				//let res ,
				//locla texture_id = cfg.fashion_id ,cfg.fashion_color //RevelationModel.GetClothesRes(data_,role_vo.sex)
				//let hairs , hairs_text_id = RevelationModel.GetHairRes(data_,role_vo.sex)
				//let weapon_model_id, weapon_texture_id = role_vo.GetWeaponClotheId()
				if (!this.roleModel) {
					let data = {
						clothe_res_id : cfg.fashion_id,
						texture_id :  cfg.fashion_color,
						type : UI_MODEL_TYPE.ROLE,
						can_rotate : true,
						layer_value : this.layer_value,
						scale : 0.65,
						//rotate = pos_cfg && pos_cfg.change_rotate,
						//position = pos_cfg && pos_cfg.change_position,
						position : new Vector3(pos_x, 1, 0),
						head_wear_id : cfg.hair_id,
						head_clothe_id : cfg.hair_color,
						fashion_model_id : cfg.fashion_id,
						sex : role_vo.sex,
						career : role_vo.career,
						weapon_res_id : cfg.equip_id,
						weapon_clothe_id : cfg.equip_color,
						//action_name_list : action_list
					}
					ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
				}
				this.name_label.text = cfg.name
			}
			/*
			resMgr.SetUIEffect(this, "ui_1402", this.layer_value, this.image_bigglow_group, null, null, true)
			let data = {
				load_call_back :() => {
					Util.AddClickEvent(this.click_group, () => {
						this.Close()
					}, this, false)
				}
			}
			resMgr.SetUIEffect(this, "ui_1128", this.layer_value, this.image_text_group, null, null, true, data)
			*/
			Util.AddClickEvent(this.click_group, () => {
				this.Close()
			}, this, false)
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
window["SuitActivityActiveView"] = SuitActivityActiveView