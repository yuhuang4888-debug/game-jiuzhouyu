import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MaskModel } from "../commonModel/MaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FashionPartPos, SceneBaseType } from "../scene/SceneConfig"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class MaskUseView extends BaseView1 {
	_img_001: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_btn_help: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_btn_close: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_lb_time: Laya.Label
	_lb_tips: Laya.Label
	_gp_model: Laya.Box
	_btn_go: Laya.Box
	_Image5: Laya.Image
	_Label3: Laya.Label
	cond_lv
	goods_vo
	mask_model
	role_mgr

	public constructor() {
		super()

		this.base_file = "mask"
		this.layout_file = "MaskUseView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.mask_model = MaskModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.cond_lv = 0
		this.preload_server_config = {
			"config_mask": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public Clear() {


	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}
			, this, true)

		Util.AddClickEvent(this._btn_help, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 511)
		}
			, this, true)

		Util.AddClickEvent(this._btn_go, () => {
			let lv = this.role_mgr.GetMainRoleVo().level
			if (lv < this.cond_lv) {
				Message.show("等级不足" + this.cond_lv + "级，无法进行使用")
			} else {
				GoodsModel.GetInstance().Fire(GoodsModel.USE_BAG_GOODS, this.goods_vo.goods_id, 1)
			}
		}
			, this, true)

		this.BindEvent(this.mask_model, MaskModel.UPDATE_INFO, (info?) => {
			if (info.end_time > 0) {
				this.mask_model.ShowUseMsg()
				this.Close()
			}
		}
		)
	}

	public LoadSuccess() {


		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_001, GameResPath.GetIcon("mask", "uimmr_001"))
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mask", false)
		let time = cfg[1].duration
		this._lb_time.text = time / 60 + "分钟"
		this.cond_lv = cfg[1].level
		this.UpdateUIModel()
		this.InitEvent()
		// 	if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 		let csf = this._Label3.GetComponent("ContentSizeFitter")
		// 		csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
		// 		csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
		// 		SetSizeDelta(this._Label3,125,50)
		// 		this._Label3.size  = 20
		// 		this._Label3.lineSpacing = 0.6
		// 		this._Label3.verticalAlign = "middle"
		// this._Label3.textAlign = "center"
		// 	}
	}

	public UpdateUIModel() {


		let main_role_vo = this.role_mgr.GetMainRoleVo()
		let model_id = MaskModel.GetRoleClothePosId(main_role_vo, FashionPartPos.Clothe)
		let weapon_model_id = MaskModel.GetRoleClothePosId(main_role_vo, FashionPartPos.Weapon)
		let head_model_id = MaskModel.GetRoleClothePosId(main_role_vo, FashionPartPos.Head)
		let call_back = () => {
			//if (this.fight_num ) {

			//}
		}
		let data = {
			type: UI_MODEL_TYPE.MAINROLE,
			career: main_role_vo.career,
			sex: main_role_vo.sex,
			layer_value: this.layer_value,

			weapon_res_id: weapon_model_id,
			clothe_res_id: model_id,
			head_wear_id: head_model_id,

			scale: 1,
			layout_file: "MaskUseView"
			//position: new Vector3(0, 0, 0),

			//load_call_back: call_back,
		}
		ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
	}

	public Open(...new_args) {

		let parms = new_args
		this.goods_vo = parms[0]
		super.Open()
	}



	public GetComponents() {
		[
			this._img_001,
			this._Image1,
			this._Image2,
			this._btn_help,
			this._Image3,
			this._Image4,
			this._btn_close,
			this._Label1,
			this._Label2,
			this._lb_time,
			this._lb_tips,
			this._gp_model,
			this._btn_go,
			this._Image5,
			this._Label3,
		]
			= this.GetChildrenByNames([

				"_img_001",
				"_Image1",
				"_Image2",
				"_btn_help",
				"_Image3",
				"_Image4",
				"_btn_close",
				"_Label1",
				"_Label2",
				"_lb_time",
				"_lb_tips",
				"_gp_model",
				"_btn_go",
				"_Image5",
				"_Label3",
			])
	}
}
window["MaskUseView"] = MaskUseView