import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { ModuleType } from "../common/RedDotManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GodBefallModel, GodBefallEvent } from "../commonModel/GodBefallModel"

export class GodBefallEquipItem extends BaseItemRenderer {
	WIDTH = 80
	HEIGT = 80
	_item
	_model
	_status
	res_mgr
	need_refresh = false
	cfg_starup_limit

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallEquipItem"

		this._model = GodBefallModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this._status = 0

		this.load_callback = () => {
			this.cfg_starup_limit = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_god_star_up_limit", false)
			this.InitEvent()
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public InitEvent() {
		if (!this._item) {
			this._item = new EquipmentItem(this._gp_item)
			//this._item.SetUseMask(true)
			this._item.Load()
			this._item.SetItemSize(80, 80)
		}

		Util.AddClickEvent(this.gp_con, () => {
			if (this._status == 1) {
				Message.show("请先激活降神")
			}
			else if (this._status == 2) {
				let equipVo = this._model.GetCurCanSetEquip(this.data.pos, this.cfg_starup_limit)
				if (equipVo) {
					this._model.Fire(GodBefallEvent.REQUEST_PROTO, 44012, "li", equipVo.goods_id, this.data.god_id)
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBefallWayView")
				}
			}
		}, this, true)
		
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mtype?, rtype?) => {
			if (mtype != ModuleType.GOD_QUICK_COM) {
				return
			}
			if (!this.data || !this.data.god_id) { return }
			let id = this.data.god_id * 10000 + this.data.pos
			if (rtype != id) {
				return
			}
			this.CheckRedDot()
		}
		)
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}

		super.DeleteMe()
	}

	public dataChanged() {
		let data = this.data
		if (!data) {
			return
		}

		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}

		if (data.unlock) {
			this._status = 1
			this.res_mgr.SetImageSprite(this, this._img_icon, "godBefall_asset", "gb_pos_" + data.pos)
		}
		else if (data.empty) {
			this._status = 2
			this.res_mgr.SetImageSprite(this, this._img_icon, "godBefall_asset", "gb_pos_" + data.pos)
		}
		else if (data.goods_id) {
			this._status = 3
			let info = this._model.GetEquipInfo(data.goods_id)
			if (info) {
				this._item.SetData(info.type_id, info.goods_num, info.bind)
				this._item.SetClickCallBack(() => {
					let data = this._model.GetEquipData(info.type_id)
					let list = (data && data.composite_rule && ([0, 1]) || ([0]))
					UIToolTipMgr.GetInstance().AppendGodEquipTips(info.type_id, info, list)
				})
			}
		}

		this._img_icon.visible = this._status == 2 || this._status == 1
		this._gp_item.visible = this._status == 3
		this._img_bg.visible = this._status != 3
		this.CheckRedDot()
	}

	public CheckRedDot() {
		if (this._status == 1) {
			this._reddot.visible = false
			return
		}

		let id = this.data.god_id * 10000 + this.data.pos
		if (this._status == 2) {
			let red = this._model.GetRedStatus(ModuleType.GOD_EQUIP, id) == true
			this._reddot.visible = red
		}
		else if (this._status == 3) {
			let red = this._model.GetRedStatus(ModuleType.GOD_QUICK_COM, id) == true||this.CheckHasReplace()
			this._reddot.visible = red
		}
	}

	/***检查是否有可替换的装备 */
	public CheckHasReplace(){
		if(!this.data)return false
		let vo = this._model.GetGodVoInDic(this.data.god_id)
		let red = this._model.CheckEquipCanReplaceOne(vo, this.data.pos)
		return red
	}

	gp_con: Laya.Box
	_img_bg: Laya.Image
	_gp_item: Laya.Box
	_img_icon: Laya.Image
	_img_lock: Laya.Image
	_img_up: Laya.Image
	_reddot: Laya.Image
	public GetComponents() {
		[
			this.gp_con,
			this._img_bg,
			this._gp_item,
			this._img_icon,
			this._img_lock,
			this._img_up,
			this._reddot,
		]
			= this.GetChildrenByNames([
				"gp_con",
				"_img_bg",
				"_gp_item",
				"_img_icon",
				"_img_lock",
				"_img_up",
				"_reddot",
			])
	}
}
window["GodBefallEquipItem"] = GodBefallEquipItem