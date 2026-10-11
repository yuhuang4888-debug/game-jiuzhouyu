import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { EventName } from "../common/EventName"
import { ColorUtil } from "../util/ColorUtil"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { PlatformManager } from "../PlatformManager"

export class EquipWashItem extends BaseItem1 {
	award_item
	data
	equip_type
	is_lock
	model
	needrefresh
	open_cfg

	public constructor(parent?) {
		super(parent)
		this.model = EquipModel.GetInstance();
		this.is_lock = true;
		this.base_file = "equip"
		this.layout_file = "EquipWashItem"
		this.dependent_res = ["equipCom"]

		this.load_callback = () => {
			if (this.needrefresh) {
				this.needrefresh = false
				this.SetData(this.data)
			}
			this.InitEvent()
		}
	}

	public SetEquipPos(equip_type?) {
		this.equip_type = equip_type
		ResManager.GetInstance().SetImageSprite(this, this._img_pos_icon, "equipCom_asset", "role_default_" + equip_type)
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp, () => {
			if (this.is_lock) {
				Message.show("部位未解锁")
				return
			}
			if (!this.data) {
				Message.show("未穿戴装备")
				return
			}
			this.model.Fire(EquipEvent.SELECT_WASH_EQUIP, this.data)
		}
			, this, true)
		this.BindEvent(this.model, EquipEvent.SELECT_WASH_EQUIP, (equip_info?) => {
			if (equip_info) {
				this.SetSelect(this.equip_type == equip_info.equip_type)
			}
		}
		)
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
		let OpenFunc = () => {
			if (!this.open_cfg) {
				return
			}
			if (RoleManager.GetInstance().mainRoleInfo.level > this.open_cfg.unlock_lv) {
				this.UpdateRed()
				this.tips.text = ""
				this.is_lock = false
				this._img_mask.visible = false
			}
		}
		this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, OpenFunc)

		let ref_Ref = () => {
			if (!this.data) {
				return
			}
			let bool = this.model.CheckWashProFreeRed(this.data)
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
			bool = bool || (!this.is_lock) && (this.model.CheckWashDivisionRed(this.data, equip_attr_cfg, equip_wash_cfg) || this.model.CheckWashFreeRed(this.data, equip_attr_cfg, equip_wash_cfg))
			this.red_dot.visible = bool
		}
		this.BindEvent(this.model, EquipEvent.UPDATE_DIVISION_RED, ref_Ref)
		this.BindEvent(this.model, EquipEvent.UPDATE_WASH_FREETIEM, ref_Ref)
	}

	public SetData(data?) {
		if (!data) {
			return
		}
		this.data = data
		if (!this.is_loaded) {
			this.needrefresh = true
			return
		}
		this._lb_level.visible = true
		this._lb_name.visible = true
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
		if (basic) {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_name.align = null
				this._lb_name.valign = null
				this._lb_name.width = 0
				this._lb_name.height = 0
				this._lb_name.pos(75, 150)
				this._lb_name.wordWrap = false
				this._lb_name.leading = 0.1
			}
			this._lb_name.color = ColorUtil.GetColorDark(basic.color, false)
			this._lb_name.text = basic.goods_name
		}

		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_level.text = "Purify Tier:" + data.division + "Tier"
		} else {
			this._lb_level.text = "洗炼段位:" + data.division + "段"
		}

		this.UpdateAwardItem(data)
		this.UpdateRed()
	}

	public UpdateRed() {
		if (!this.data) {
			return
		}
		let bool = this.model.CheckWashProFreeRed(this.data)
		this._img_free.visible = bool
		let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
		let equip_wash_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_wash", false)
		bool = bool || (!this.is_lock) && (this.model.CheckWashDivisionRed(this.data, equip_attr_cfg, equip_wash_cfg) || this.model.CheckWashFreeRed(this.data, equip_attr_cfg, equip_wash_cfg))
		this.red_dot.visible = bool
	}

	public UpdateAwardItem(data?) {
		if (!data) {
			return
		}

		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.award_group)
			this.award_item.Load()
			this.award_item.SetItemSize(85, 85)
			this.award_item.SetShowTips(false)
			this.award_item.SetUseMask(true)
		}
		this.award_item.ExcuteCallback(() => {
			this.award_item.SetData(data.type_id)
			this.SetWashStar(data.wash_attr)
		}
		)
	}

	public SetSelect(visible?) {
		this.select_img.visible = visible
	}

	public SetOpenData(cfg?) {
		this.open_cfg = cfg
		if (cfg) {
			if (!this.data) {
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_name.align = "center"
					this._lb_name.valign = "middle"
					this._lb_name.width = 151
					this._lb_name.height = 59
					this._lb_name.pos(75, 161)
					this._lb_name.wordWrap = true
					this._lb_name.leading = 0.1
				}
				if (PlatformManager.IsEyouEnPlatform()) {
					this._lb_name.text = "Require to equip " + WordManager.GetEquipPos(cfg.pos)
				} else {
				this._lb_name.text = "需先穿戴" + WordManager.GetEquipPos(cfg.pos)
				}
				/*
				if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
					this._lb_name.text = WordManager.GetEquipPos(cfg.pos) + "未装着"
				}
				*/
			}
			if (RoleManager.GetInstance().mainRoleInfo.level >= cfg.unlock_lv) {
				this.tips.visible = false
				this._img_mask.visible = false
				this.is_lock = false
			} else {
				this.tips.visible = true
				this._img_mask.visible = true
				this.tips.text = cfg.unlock_lv + "级\n解锁"
				/*
				if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
					this.tips.text = "Lv" + cfg.unlock_lv + "\n解放"
				}
				*/
				this.is_lock = true
			}
			this.UpdateRed()
		}
	}

	public DeleteMe() {
		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		super.DeleteMe()
	}

	public SetWashStar(attr?) {
		if (!attr) {
			return
		}

		let i = 0
		if (i < attr.length) {
			let data = ["g", "c", "b", "d", "e", "f", "a"]
			do {
				let pic = this["wash" + i] 
				if (pic) {
					ResManager.GetInstance().SetImageSprite(this, pic, "equip_asset", "uidz_041" + data[attr[i].color])
					pic.visible = true
				}
				i = i + 1
			} while ((i < attr.length))
		}
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
	_img_free: Laya.Image
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

window["EquipWashItem"] = EquipWashItem