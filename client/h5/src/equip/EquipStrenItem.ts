import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class EquipStrenItem extends BaseItem1 {
	attr_cfg
	award_item
	// canlevel
	// cantips
	data
	equip_type
	is_delay_callback
	model
	refresh_data
	scaleX
	scaleY
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
		this.layout_file = "EquipStrenItem"
		this.is_delay_callback = false

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
			//this.lock_icon.source = "equipCom_json.role_default_" + this.equip_type + "_png"
		}

		if (this.refresh_data) {
			this.SetData(this.data)
		}
	}

	public SetEquipPos(equip_type?) {
		this.equip_type = equip_type
	}

	public SetCfgs(...new_args) {
		this.limit_cfg = new_args[0]
		this.attr_cfg = new_args[1]
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
		let wear_info = GoodsModel.GetInstance().GetDynamic(data.goods_id, null, false, true)
		if (!wear_info || !this.limit_cfg) {
			return
		}
		let is_max = this.limit_cfg.stren_max <= wear_info.stren
		let lv = (is_max && (this.limit_cfg.stren_max) || (wear_info.stren))
		this.level.text = "+" + lv
		//let stren_info = this.model.GetStrengthInfo(data.equip_type)
		//let true_max = stren_info && this.limit_cfg.stren_max == stren_info.stren
		//this.tips.color = true_max && ColorUtil.GetColorLight(ColorType.GREEN, false) || ColorUtil.GetColorLight(ColorType.RED, false)
		this.tips.visible = is_max
		if (is_max) {
			this.StartMaxAction()
		} else {
			this.StopMaxAction()
		}
		let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
		let stren_key_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stren_lv_key", false)
		let stren_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stren_lv", false)
		let stren_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
		this.red_dot.visible = this.equip_type && this.model.CheckStrenRedDotOne(data, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
	}

	public UpdateAwardItem(data?) {
		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.award_con, null, "UI", null, true)
			this.award_item.Load()
			this.award_item.SetScale(0.9)
		}
		this.award_item.ExcuteCallback(() => {
			if (this.award_item) {
				this.award_item.SetData(data.type_id)
			}
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
				Message.show("穿戴装备后才可以强化该部位哦")
				return
			}
			this.model.Fire(EquipEvent.SELECT_STREN_EQUIP, this.data)
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

		this.BindEvent(this.model, EquipEvent.SELECT_STREN_EQUIP, (equip_info?) => {
			this.SetSelect(this.equip_type == equip_info.equip_type)
		})

		this.BindVar(this.model, "equip_str_info", (event_name?, value?, old_value?) => {
			if (!this.data) {
				return
			}
			if (value.equip_type == this.data.equip_type) {
				this.data.stren = value.stren
				this.SetData(this.data)
			}
		}
		)
		this.BindEvent(this.model, EquipEvent.ALL_STREN_FAIL, (scmd?) => {
			this.SetSelect(this.equip_type == scmd.res1)
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (rType?, key?) => {
			if (rType != ModuleType.EQUIP_STREN) {
				return
			}
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			let stren_key_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stren_lv_key", false)
			let stren_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stren_lv", false)
			let stren_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
			this.red_dot.visible = this.equip_type && this.model.CheckStrenRedDotOne(this.data, equip_attr_cfg, stren_key_cfg, stren_cfg, stren_max_cfg)
		}
		)
	}

	public SetSelect(visible?) {
		if (!this.is_loaded || !this.select_img || this.use_delete_method/* || Util.IsNull(this.select_img)*/) {
			return
		}
		this.select_img.visible = visible
	}

	//function EquipStrenItem.SetScale(scale)
	//this.scaleY = scale
	//this.scaleX = this.scaleY
	//}

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
			if (this.use_delete_method) {
				return
			}
			this.tl1 = SYTweenLite.to(this, this.level, SYTweenLite.UiAnimationType.ALPHA, 0, 1, () => {
				this.waittimer1 = setTimeout(() => {
					if (this.use_delete_method) {
						return
					}
					this.tl1 = SYTweenLite.to(this, this.level, SYTweenLite.UiAnimationType.ALPHA, 1, 1, aniFun1, SYTweenFunc.EASE_IN)
				}, 2)
			}, SYTweenFunc.EASE_IN)
		}
		aniFun1()

		let aniFun2
		aniFun2 = () => {
			if (this.use_delete_method) {
				return
			}
			this.tl2 = SYTweenLite.to(this, this.tips, SYTweenLite.UiAnimationType.ALPHA, 1, 1, () => {
				if (this.use_delete_method) {
					return
				}
				this.tl2 = SYTweenLite.to(this, this.tips, SYTweenLite.UiAnimationType.ALPHA, 0, 1, () => {
					this.waittimer2 = setTimeout(aniFun2, 2)
				}, SYTweenFunc.EASE_IN)
			}, SYTweenFunc.EASE_IN)
		}
		this.waittimer2 = setTimeout(aniFun2, 1)
		//if (! this.tl2 ) {
		//}
		//Laya.Tween.get(this.level, {loop=true}):to({alpha=0}, 1000):wait(2000).to({alpha=1}, 1000)
		//Laya.Tween.get(this.tips):wait(1000).call(() => {
		//Laya.Tween.get(this.tips, {loop=true}):to({alpha=1}, 1000):to({alpha=0}, 1000).wait(2000)
		//}
		//)
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
window["EquipStrenItem"] = EquipStrenItem