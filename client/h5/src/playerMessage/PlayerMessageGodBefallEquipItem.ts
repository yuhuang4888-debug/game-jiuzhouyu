import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { ModuleType } from "../common/RedDotManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysinfo/SysInfoController"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GodBefallModel, GodBefallEvent } from "../commonModel/GodBefallModel"
import { BaseItem1 } from "../common/BaseItem1"
import { GoodsModel } from "../commonModel/GoodsModel"

export class PlayerMessageGodBefallEquipItem extends BaseItem1 {

	_item
	_model
	_status
	res_mgr
	need_refresh = false
	cfg_starup_limit
    data
    SetData
	public constructor(parent?) {
		super(parent)
		this.base_file = "godBefall"
		this.layout_file = "GodBefallEquipItem"

		this._model = GodBefallModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this._status = 0

		this.load_callback = () => {
			this.cfg_starup_limit = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_star_up_limit", false)
			this.InitEvent()
			if (this.need_refresh) {
				this.need_refresh = false
				this.UpdateView()
			}
		}
        this.SetData = (data?) => {
            this.data = data
            if (this.is_loaded) {
                this.UpdateView
            } else {
                this.need_refresh = true
            }
        }
	}

	public InitEvent() {
		if (!this._item) {
			this._item = new EquipmentItem(this._gp_item)
			//this._item.SetUseMask(true)
			this._item.Load()
			this._item.SetItemSize(90, 90)
		}
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}

		super.DeleteMe()
	}

	public UpdateView() {
		let data = this.data
		if (!data) {
			return
		}

		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}

		 if (data.goods_id) {
			this._status = 3
			let info = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.goods_id)
			if (info) {
				this._item.SetData(info.type_id, info.goods_num, info.bind)
				this._item.SetClickCallBack(() => {
					UIToolTipMgr.GetInstance().AppendGodEquipTips(info.type_id, info, [3])
				})
			}
		}else {
			this._status = 2
			this.res_mgr.SetImageSprite(this, this._img_icon, "playerMessage", "gb_pos_" + data.pos)
		}

		this._img_icon.visible = this._status == 2 || this._status == 1
		this._gp_item.visible = this._status == 3
		this._img_bg.visible = this._status != 3
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
window["PlayerMessageGodBefallEquipItem"] = PlayerMessageGodBefallEquipItem