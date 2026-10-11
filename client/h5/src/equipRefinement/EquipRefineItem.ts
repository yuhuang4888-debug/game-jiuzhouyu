import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class EquipRefineItem extends BaseItem1 {
	InitEvent
	InitView
	RefRefinementLv
	data
	item
	model

	public constructor(parent?) {
		super(parent)
		this.base_file = "equip"
		this.layout_file = "EquipWashItem"
		this.model = EquipModel.GetInstance()

		this.load_callback = () => {
			this._lb_level.visible = false
			this.InitEvent()
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this._lb_level.size = 16
				this._lb_name.size = 18
				let csf = this._lb_name.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDelta(this._lb_name, 150, 50)
				SetAnchoredPosition(this._lb_name, 0, -124)
				this._lb_name.verticalAlign = "middle"
				this._lb_name.textAlign = "center"
				this._lb_name.lineSpacing = 0.7
			}
			*/
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp, () => {
				this.model.ChangeVar("equip_refinement_select", this.data, false, true)
			}
				, this, true)

			this.BindVar(this.model, "equip_refinement_select", (event_name?, value?, old_value?) => {
				if (!this.data) {
					return
				}
				this.SetSelect(value.equip_type == this.data.equip_type)
			}
			)

			this.BindEvent(this.model, EquipEvent.UPDATA_REFI_VIEW, () => {
				let equip_infos = this.model.GetWearEquipDynamics()
				if (!equip_infos || equip_infos.length == 0) {
					return
				}
				for (let _tmpi in equip_infos) {
					let vo = equip_infos[_tmpi]
					if (vo.equip_type == this.data.equip_type) {
						this.data = vo
						this.RefRefinementLv()
						break
					}
				}
			}
			)

			this.BindEvent(this.model, EquipEvent.UPDATE_REFI_RED, () => {
				this.RefRed()
			}
			)
		}

		this.RefRefinementLv = () => {
			let data = this.data
			if (!data) {
				return
			}
			if (data.refinement_lv != undefined) {
				this._bit_refine_lv.visible = EquipModel.GetInstance().CheckCanRefine(data)
				this._bit_refine_lv.text = "神炼+" + data.refinement_lv
			}else{
				this._bit_refine_lv.text = ""
			}
		}

		this.InitView = () => {
			let data = this.data
			if (!data) {
				return
			}
			if (!this.item) {
				this.item = new EquipmentItem(this.award_group)
				this.item.Load()
				this.item.SetShowTips(false)
				this.item.SetUseMask(true)
				this.item.SetItemSize(85, 85)
			}
			this.item.ExcuteCallback(() => {
				this.item.SetData(data.type_id)
			}
			)
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
			if (basic) {
				let color = ColorUtil.GetColorDark(basic.color, false)
				this._lb_name.color = color
				this._lb_name.text = basic.goods_name
			}
			this.RefRefinementLv()
			this.RefRed()
		}
	}

	public RefRed() {
		if (!this.data) {
			return
		}
		let red = RedDotManager.GetInstance().CheckRedStatus(ModuleType.REFINEMENT_RED, this.data.equip_type)
		this.red_dot.visible = red
	}

	public SetSelect(visible?) {
		this.select_img.visible = visible
	}

	public SetData(...new_args) {
		this.data = new_args[0]
		this.SetSelect(new_args[1])
		this.InitView()
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		
		super.DeleteMe()
	}
	
	_gp: Laya.Box
	_Image1: Laya.Image
	select_img: Laya.Image
	icon_bg: Laya.Image
	_img_pos_icon: Laya.Image
	award_group: Laya.Box
	prop_group: Laya.Box
	wash0: Laya.Image
	wash1: Laya.Image
	wash2: Laya.Image
	wash3: Laya.Image
	_img_mask: Laya.Image
	tips: Laya.Label
	_img_free: Laya.Label
	_lb_name: Laya.Label
	_lb_level: Laya.Label
	_bit_refine_lv: Laya.Label
	red_dot: Laya.Image
	public GetComponents() {
		[
			this._gp,
			this._Image1,
			this.select_img,
			this.icon_bg,
			this._img_pos_icon,
			this.award_group,
			this.prop_group,
			this.wash0,
			this.wash1,
			this.wash2,
			this.wash3,
			this._img_mask,
			this.tips,
			this._img_free,
			this._lb_name,
			this._lb_level,
			this._bit_refine_lv,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"_gp",
				"_Image1",
				"select_img",
				"icon_bg",
				"_img_pos_icon",
				"award_group",
				"prop_group",
				"wash0",
				"wash1",
				"wash2",
				"wash3",
				"_img_mask",
				"tips",
				"_img_free",
				"_lb_name",
				"_lb_level",
				"_bit_refine_lv",
				"red_dot",
			])
	}
}

window["EquipRefineItem"] = EquipRefineItem