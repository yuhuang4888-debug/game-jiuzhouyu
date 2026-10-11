import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, SetLocalScale } from "../util/Util"
import { RoleManager } from "../commonModel/RoleManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { table } from "../common/table"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"

export class FirstRechargeTipsView extends BaseView1 {
	_img_bg0: Laya.Image
	_gp_show: Laya.Box
	_gp_circle: Laya.Box
	_gp_model: Laya.Box
	_gp_title: Laya.Image
	_gp_title1: Laya.Image
	_gp_desc: Laya.Image
	_gp_desc1: Laya.Image
	_gp_get: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	ClearModel
	DeleteMe
	InitEvent
	LoadCfg
	LoadSuccess
	Remove
	ShowEffect
	ShowModel
	change_scene_close
	destroy_callback
	destroy_imm
	is_center
	not_show_main_msg
	open_callback
	show_open_movie
	use_background

	public constructor() {
		super()


		this.base_file = "recharge"
		this.layout_file = "FirstRechargeTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.use_background = true
		this.is_center = true
		this.show_open_movie = true
		//this.not_show_main_msg = true
		this.destroy_imm = true
		let model = FirstRechargeModel.GetInstance()

		//let local_laya = Laya
		let client_cfg_ = null
		let model_list_ = null
		let floatList_ = null
		this.preload_client_config = {
			"ConfigFirstRecharge": false
		}
		this.load_callback = () => {

			this.LoadCfg()
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {

			this.ShowEffect()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadCfg = () => {
			client_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigFirstRecharge", true)

			// ResManager.GetInstance().SetUIEffect2(this,"ui_first_recharge2", this._gp_circle, null, 1, true)
			// ResManager.GetInstance().SetUIEffect2(this,"ui_first_recharge1", this._gp_title, null, 1, true)
			// ResManager.GetInstance().SetUIEffect2(this,"ui_first_recharge3", this._gp_desc, null, 1, true)

		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("recharge", "uihuo_005"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._gp_title, GameResPath.GetIcon("recharge", "uihuo_001"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._gp_desc, GameResPath.GetIcon("recharge", "uihuo_004"))
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_get, () => {
				this.show_open_movie = false
				// model.Fire(FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW)
				ViewPopLevelModel.GetInstance().SetViewPop('FirstRechargeView');
				this.Close()
			}
				, this, true)
		}

		this.ShowEffect = () => {
			if (client_cfg_) {
				let career = RoleManager.GetInstance().GetMainRoleVo().career
				let cfg = client_cfg_["tip_show"][career]

				for (let key in cfg) {

					let vo = cfg[key]
					let obj = null
					if ("image" == vo.type) {
						obj = this._gp_model
						SetLocalScale(this._gp_model, vo.scale)
						ResManager.GetInstance().SetImageSpriteTrans(this, obj, "client/assets/icon/recharge/" + vo.res_name + ".png")
					} else if ("effect" == vo.type) {
						obj = this._gp_model
						//let effect_ref = ResManager.GetInstance().SetUIEffect2(this,vo.res_name, obj, null, vo.scale, vo.is_loop)
					} else if ("model" == vo.type) {
						obj = this._gp_model
						//this.ShowModel(obj, vo.model_type, vo.res, vo.scale, co.Vector2(vo.model_x, vo.model_y))
					}

					//this._gp_model.anchoredPosition = Vector2(vo.x,vo.y)
					if (vo.float) {
						if (!floatList_) {
							floatList_ = []
						}
						let tween_obj = SYTweenLite.to(this, this._gp_model, SYTweenLite.UiAnimationType.POSY, vo.y - 200, 3, null, SYTweenFunc.PINGPONG, true)
						table.insert(floatList_, tween_obj)
					}
				}
			}
		}

		this.ShowModel = (parent?, type?, res?, ui_scale?, pos?) => {
			// let model_type = string.sub(res, 1, 2)
			// if (model_type == '15' ) {
			// 	let data = {
			// 		type=type,
			// 		res_id = res,
			// 		modelPartPos = FashionPartPos.Weapon, 
			// 		layer_value = this.layer_value,
			// 		position = Vector3(pos.x, pos.y, 0), 
			// 		scale = ui_scale,
			// 		can_rotate = true,
			// 		rotate = Vector3(0, 180, -50)
			// 	}
			// 	ResManager.GetInstance().SetPartModel(this,parent,data)
			// 	let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// 	this.CoverMode(this._gp_title,this.layer_value,curr_sorting_order)
			// 	this.CoverMode(this._gp_title1,this.layer_value,curr_sorting_order)
			// 	return
			// }
		}

		this.ClearModel = () => {
			//ResManager.GetInstance().ClearRoleMode(this)
		}

		this.Remove = () => {

		}

		this.DeleteMe = () => {
			//this:ClearModel()
			//图片 动画取消
			if (floatList_) {
				for (let _tmpi in floatList_) {
					var obj = floatList_[_tmpi]
					if (obj) {
						SYTweenLite.Stop(obj)
					}
				}
				floatList_ = null
			}
			super.DeleteMe()
		}


	}


	public GetComponents() {
		[
			this._img_bg0,
			this._gp_show,
			this._gp_circle,
			this._gp_model,
			this._gp_title,
			this._gp_title1,
			this._gp_desc,
			this._gp_desc1,
			this._gp_get,
			this._Image1,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_img_bg0",
				"_gp_show",
				"_gp_circle",
				"_gp_model",
				"_gp_title",
				"_gp_title1",
				"_gp_desc",
				"_gp_desc1",
				"_gp_get",
				"_Image1",
				"_Label1",
			])
	}
}
window["FirstRechargeTipsView"] = FirstRechargeTipsView