import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class EquipSmeltItem extends BaseItem1 {
	attr_cfg
	award_item
	data
	equip_type
	model
	refresh_data
	tl1
	tl2
	waittimer1
	waittimer2
	limit_cfg: any
	effect_obj: Laya.Sprite3D
	effect_cache = false

	public constructor(parent?) {
		super(parent)
		this.base_file = "equip"
		this.layout_file = "EquipSmeltItem"

		this.model = EquipModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public DeleteMe() {
		if (this.effect_obj) {
			this.effect_obj.destroy()
		}

		this.effect_cache = false
		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		this.StopMaxAction()
		super.DeleteMe()
	}

	public LoadSuccess() {
		this.AddUIEffect("QiangHua", this.group_eff, null, 8, null, null, null, (obj) => {
			this.effect_obj = obj
			if (!this.effect_cache) {
				this.effect_obj.active = false
			} else {
				this.effect_cache = false
			}
		}, null, null, null, null, false)

		if (this.equip_type) {
			ResManager.GetInstance().SetImageSprite(this, this.lock_icon, "equipCom_asset", "role_default_" + this.equip_type)
		}
		if (this.refresh_data) {
			this.SetData(this.data)
		}
	}

	public SetEquipPos(equip_type?) {
		this.equip_type = equip_type
	}

	public SetCfgs(...new_args) {
		if (new_args) {
			this.limit_cfg = new_args[0]
			this.attr_cfg = new_args[1]
		}
	}

	public SetData(data?) {
		this.data = data
		if (!this.is_loaded) {
			this.refresh_data = true
			return
		}
		this.click_bg.visible = Boolean(this.equip_type)
		this.icon_bg.visible = Boolean(this.equip_type)
		this.UpdateAwardItem(data)
		let smelt_info = this.model.GetSmeltInfo(data.equip_type)
		if (!smelt_info || !this.limit_cfg) {
			return
		}
		let is_max = this.limit_cfg.refine_max <= smelt_info.refine
		let lv = (is_max && (this.limit_cfg.refine_max) || (smelt_info.refine))
		this.level.text = "+" + lv
		let true_max = this.limit_cfg.refine_max == smelt_info.refine_high
		this.tips.color = true_max && ColorUtil.GetColorLight(ColorType.GREEN, false) || ColorUtil.GetColorLight(ColorType.RED, false)
		this.tips.visible = is_max
		if (is_max) {
			this.StartMaxAction()
		} else {
			this.StopMaxAction()
		}
	}

	public UpdateAwardItem(data?) {
		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.award_con)
			this.award_item.Load()
			this.award_item.SetScale(0.9)
		}

		this.award_item.ExcuteCallback(() => {
			this.award_item.SetData(data.type_id)
			this.icon_bg.visible = false
		})

		this.award_item.SetClickCallBack(() => {
			UIToolTipMgr.GetInstance().AppendEquipTips(data.type_id, null, null, data, 1)
		})
	}

	public InitEvent() {
		Util.AddClickEvent(this.click_bg, () => {
			if (!this.equip_type) {
				return
			}
			if (!this.data) {
				Message.show("穿戴装备后才可以精炼该部位哦")
				return
			}
			this.model.Fire(EquipEvent.SELECT_SMELT_EQUIP, this.data)
		}, this)

		this.BindEvent(this.model, EquipEvent.PLAY_END_EFFECT, (equip_type) => {
			if (this.equip_type == equip_type && this.data) {
				if (this.effect_obj) {
					this.effect_obj.active = false
					this.effect_obj.active = true
				} else {
					this.effect_cache = true
				}
			}
		})

		this.BindEvent(this.model, EquipEvent.SELECT_SMELT_EQUIP, (equip_info?) => {
			this.SetSelect(this.equip_type == equip_info.equip_type)
		})

		this.BindVar(this.model, "equip_smelt_info", (event_name?, value?, old_value?) => {
			if (!this.data) {
				return
			}
			if (value.equip_type == this.data.equip_type) {
				this.SetData(this.data)
			}
		})

		this.BindEvent(this.model, EquipEvent.ALL_SMELT_FAIL, (scmd?) => {
			this.SetSelect(this.equip_type == scmd.res1)
		})

		this.BindEvent(this.model, EquipEvent.UPDATE_SMELT_ITEM_RED, (type?, is_red?) => {
			if (this.equip_type == type) {
				this.red_dot.visible = is_red
			}
		})
	}

	public SetSelect(visible?) {
		if (!this.is_loaded) {
			return
		}
		this.select_img.visible = visible
	}

	public UpdateEffect() {
		// this.AddUIEffect2("ui_Strengthen_glow", this.group_eff, null, null, null, null, null, null, null, true)
	}

	public StartMaxAction() {
		if (!this.is_loaded) {
			return
		}
		this.StopMaxAction()
		let aniFun1
		aniFun1 = () => {
			this.tl1 = SYTweenLite.to(this, this.level, SYTweenLite.UiAnimationType.ALPHA, 0, 1, () => {
				this.waittimer1 = setTimeout(() => {
					this.tl1 = SYTweenLite.to(this, this.level, SYTweenLite.UiAnimationType.ALPHA, 1, 1, aniFun1, SYTweenFunc.EASE_IN)
				}, 2)
			}, SYTweenFunc.EASE_IN)
		}
		aniFun1()
		let aniFun2
		aniFun2 = () => {
			this.tl2 = SYTweenLite.to(this, this.tips, SYTweenLite.UiAnimationType.ALPHA, 1, 1, () => {
				this.tl2 = SYTweenLite.to(this, this.tips, SYTweenLite.UiAnimationType.ALPHA, 0, 1, () => {
					this.waittimer2 = setTimeout(aniFun2, 2)
				}, SYTweenFunc.EASE_IN)
			}, SYTweenFunc.EASE_IN)
		}
		this.waittimer2 = setTimeout(aniFun2, 1)
	}

	public StopMaxAction() {
		if (!this.is_loaded) {
			return
		}
		this.level.alpha = 1
		this.tips.alpha = 0
		if (this.waittimer1) {
			clearTimeout(this.waittimer1)
			this.waittimer1 = null
		}
		if (this.tl1) {
			SYTweenLite.Stop(this.tl1)
			this.tl1 = null
		}
		if (this.waittimer2) {
			clearTimeout(this.waittimer2)
			this.waittimer2 = null
		}
		if (this.tl2) {
			SYTweenLite.Stop(this.tl2)
			this.tl2 = null
		}
	}

	icon_bg: Laya.Image
	lock_icon: Laya.Image
	award_con: Laya.Box
	select_img: Laya.Image
	level: Laya.Label
	tips: Laya.Label
	grade: Laya.Label
	red_dot: Laya.Image
	group_eff: Laya.Box
	click_bg: Laya.Image
	public GetComponents() {
		[
			this.icon_bg,
			this.lock_icon,
			this.award_con,
			this.select_img,
			this.level,
			this.tips,
			this.grade,
			this.red_dot,
			this.group_eff,
			this.click_bg,
		]
			= this.GetChildrenByNames([
				"icon_bg",
				"lock_icon",
				"award_con",
				"select_img",
				"level",
				"tips",
				"grade",
				"red_dot",
				"group_eff",
				"click_bg",
			])
	}
}
window["EquipSmeltItem"] = EquipSmeltItem