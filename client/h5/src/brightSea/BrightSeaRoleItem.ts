import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class BrightSeaRoleItem extends BaseItem1 {
	LoadDiamondSeaEffect
	cache_sort_order
	data
	has_set_cover
	index
	model
	need_refresh_data
	role_head
	role_mgr
	start_posY
	end_posY
	tween_id

	water_scale
	water_scale2
	water_pos


	public constructor(parent?) {
		super(parent)

		//ui_diamondsea_2 水的涟漪
		//ui_diamondsea_1 溅起的水花

		this.base_file = "brightSea"
		this.layout_file = "BrightSeaRoleItem"
		this.model = BrightSeaModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.need_refresh_data = false
		this.water_scale = 8
		this.water_scale2 = 3
		this.water_pos = { x: -1.5, y: -2.5 }
		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.LoadDiamondSeaEffect = () => {

			this.AddUIEffect("ui_diamondsea_2", this._con_eff2, null, this.water_scale, true)
		}
	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateView()
		}

		let value=-13.5
		this.end_posY = value
		this.start_posY = value-10
		this.ClearTween()
		this._con_model.y = this.start_posY
		this.tween_id = SYTweenLite.to(this, this._con_model, SYTweenLite.UiAnimationType.POSY, this.end_posY, 2, null, SYTweenFunc.PINGPONG,true)

		this.LoadDiamondSeaEffect()
	}


	public InitEvent() {

		Util.AddClickEvent(this._img_ship, () => {
			if (!this.data) return
			if (this.data.role_id == this.role_mgr.GetMainRoleId()) {
				Message.show("不能抢夺自己~")
				return
			}
			if (this.data.auto_id) {
				this.model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaPlunderLogView", this.data.auto_id)
			}
		}, this)

		this.BindEvent(this.model, BrightSeaEvent.CRUISE_CALLBACK, () => {
			if (!this.data) return

			if (this.data.role_id == this.role_mgr.GetMainRoleId()) {
				this.AddUIEffect("ui_diamondsea_2", this._con_eff2, null, this.water_scale, true)
				this.AddUIEffect("ui_diamondsea_1", this._con_eff1, this.water_pos, this.water_scale2, true)
			}
		})
	}



	public LoadModel(model_res?) {

		let data = {
			type: UI_MODEL_TYPE.MONSTER,
			texture_id:this.model.GetModelShipTextureId(model_res),
			fashion_model_id: model_res,
			clothe_res_id: model_res,
			layer_value: this.layer_value,
			scale: 5 * this.data.model_ratio,
			rotate: 125,
			can_rotate: false
		}
		ResManager.GetInstance().SetRoleModel(this, this._con_model, data)


	}



	public ClearTween() {

		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
	}


	public UpdateView() {

		if (!this.data) {
			return
		}

		let color = ColorUtil.GetColorLight(this.data.shipping_id + 1)
		this._lb_name.color = ColorUtil.GetReplaceChar(color)
		this._lb_name.text = this.data.role_name

		if (this.data.role_id == this.role_mgr.GetMainRoleId()) {
			this._con_head.visible = true
			//let head_res = this.model.GetHeadRes(this.role_mgr.GetMainRoleVo())
			//lua_resM:SetOutsideImageSprite(this, this._head, head_res)

			if (!this.role_head) {
				this.role_head = new CustomHeadItem(this._head)
				this.role_head.Load()
				this.role_head.SetScale(0.5)
			}
			let role_info = RoleManager.GetInstance().GetMainRoleVo()
			this.role_head.SetRoleVoData(role_info)

			this.role_head.SetActiveBg2(false)
			this.role_head.SetActiveLevel(false)
			this.role_head.SetActiveFrame(false)
		} else {
			this._con_head.visible = false
		}

		let res_name = this.model.GetModelResByShipId(this.data.shipping_id)
		this.LoadModel(res_name)
	}

	public SetData(data?, index?) {

		this.data = data
		this.index = index
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public DeleteMe() {

		this.ClearTween()
		if (this.role_head) {
			this.role_head.DeleteMe()
			this.role_head = null
		}
		this.ClearUIEffect(this._con_eff2)
		this.ClearUIEffect(this._con_eff1)
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
		super.DeleteMe()
	}



	_con_head: Laya.Box
	head_bg: Laya.Image
	_head: Laya.Box
	bg: Laya.Image
	_lb_name: Laya.Label
	_img_ship: Laya.Box
	_con_eff1: Laya.Box
	_con_eff2: Laya.Box
	_con_model: Laya.Box
	public GetComponents() {
		[
			this._con_head,
			this.head_bg,
			this._head,
			this.bg,
			this._lb_name,
			this._img_ship,
			this._con_eff1,
			this._con_eff2,
			this._con_model,
		]
			= this.GetChildrenByNames([

				"_con_head",
				"head_bg",
				"_head",
				"bg",
				"_lb_name",
				"_img_ship",
				"_con_eff1",
				"_con_eff2",
				"_con_model",
			])
	}
}
window["BrightSeaRoleItem"] = BrightSeaRoleItem