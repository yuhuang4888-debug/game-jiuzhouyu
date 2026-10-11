import { BaseItem1 } from "../common/BaseItem1"
import { SetAnchoredPosition, Util } from "../util/Util"
import { ArmorModel } from "../commonModel/ArmorModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { EquipmentItem } from "../common/EquipmentItem"

export class ArmorItem extends BaseItem1 {
	model
	res_mgr
	goods_model

	data
	need_refresh = false
	armour_cfg
	item
	type
	pos
	pos_list
	select = false

	public constructor(parent?) {
		super(parent)
		this.base_file = "equipArmor"
		this.layout_file = "ArmorItem"

		this.model = ArmorModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.item = null
		this.pos = 0
		this.pos_list = [
			{ x: 129, y: -77 },
			{ x: 1, y: 165 },
			{ x: 257, y: 164 }
		]

		this.load_callback = () => {
			this.armour_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_armour_equipment", false)
			this.InitEvent()
			if (this.need_refresh) {
				this.need_refresh = false
				this.SetData(this.data, this.type, this.pos)
			}
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}

		super.DeleteMe()
	}

	public InitEvent() {
		this.BindEvent(this.model, ArmorModel.SELECT_EQUIP, (data?) => {
			if(this.type != 1){
				return
			}
			this.select = this.data.pos == data.pos
			if (this.is_loaded) {
				this._img_select.visible = this.select
			}
			
		})

		this.BindEvent(this.model, ArmorModel.UPDATE_RED, () => {
			if(this.type != 1){
				return
			}
			this.UpdateRed()
		})

		Util.AddClickEvent(this.gp_con, () => {
			if(this.type != 1){
				return
			}
			this.model.Fire(ArmorModel.SELECT_EQUIP, this.data)
		}, this, true)
	}

	// type.1 底部装备, 2 顶部装备, 3 材料 
	public SetData(data?, type?, pos?) {
		if (!data) {
			return
		}
		this.data = data
		this.type = type
		this.pos = pos

		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}

		if (type == 1) {
			this.InitTypeOne()
		} else if (type == 2) {
			this.InitTypeTwo()
		} else if (type == 3) {
			this.InitTypeThree()
		}
	}

	public InitTypeOne() {
		this._lb_tips.align = "center"
		this._lb_tips.text = this.model.GetEquipTips(this.data.gtype_id, this.armour_cfg)
		this._img_final.visible = this.data.status == 1
		this._img_select.visible = this.select
		this.UpdateRed()

		if (!this.item) {
			this.item = new EquipmentItem(this._gp_item)
			this.item.Load()
			this.item.SetItemSize(90, 90)
			this.item.SetShowTips(false)
		}
		this.item.SetData(this.data.gtype_id, null, null, null, null, true)
		this.item.SetIconGaryCom(!this.model.CheckEquipStatus(this.data.gtype_id, this.armour_cfg))
	}

	public InitTypeTwo() {
		this._lb_tips.y = 70
		this._lb_tips.align = "center"
		this._lb_tips.text = this.model.GetEquipTips(this.data.gtype_id, this.armour_cfg)

		if (!this.item) {
			this.item = new EquipmentItem(this._gp_item)
			this.item.Load()
			this.item.SetItemSize(100, 100)
			this.item.SetShowTips(true)
		}
		this.item.SetData(this.data.gtype_id)
	}

	public InitTypeThree() {
		let lock = this.data.gtype_id == 0
		this._img_lock.visible = lock
		this._gp_item.visible = !lock
		this._lb_tips.text = ""
		if (!lock) {
			if (!this.item) {
				this.item = new EquipmentItem(this._gp_item)
				this.item.Load()
				this.item.SetItemSize(90, 90)
				this.item.SetShowTips(true)
			}
			this.item.SetData(this.data.gtype_id)

			let num = this.goods_model.GetTypeGoodsNum(this.data.gtype_id)
			if (num == 0 && this.model.CheckEquipStatus(this.data.gtype_id, this.armour_cfg)) {
				num = 1
			}

			let type_id = this.data.gtype_id
			if (type_id && (type_id == 82110101 || type_id == 82110102 || type_id == 82110201 || type_id == 82110202)) {
				this._lb_tips.align = "right"
				//this._lb_tips.textAlign = "right"
				if (num < this.data.num) {
					this._lb_tips.color = "#ff4747"
					this._lb_tips.text = num + "/" + this.data.num
				} else {
					this._lb_tips.color = "#ffffff"
					this._lb_tips.text = num + "/" + this.data.num
				}
				this._lb_tips.y = 62
			} else {
				this._lb_tips.y = 56
				this._lb_tips.align = "center"
				this._lb_tips.text = this.model.GetEquipTips(this.data.gtype_id, this.armour_cfg)
				this.item.SetIconGaryCom(num < this.data.num)
			}
		}
		let pos = this.pos_list[this.pos]
		this.display_obj.x = pos.x
		this.display_obj.y = pos.y
	}

	public UpdateRed() {
		let cfg = this.armour_cfg[this.data.gtype_id]
		if (cfg) {
			this._img_red.visible = this.model.CheckPosRed(cfg.stage, cfg.type, cfg.pos, this.armour_cfg)
		}
	}

	gp_con: Laya.Box
	_gp_item: Laya.Box
	_img_lock: Laya.Image
	_img_select: Laya.Image
	_lb_tips: Laya.Label
	_img_final: Laya.Image
	_img_red: Laya.Image
	public GetComponents() {
		[
			this.gp_con,
			this._gp_item,
			this._img_lock,
			this._img_select,
			this._lb_tips,
			this._img_final,
			this._img_red,
		]
			= this.GetChildrenByNames([
				"gp_con",
				"_gp_item",
				"_img_lock",
				"_img_select",
				"_lb_tips",
				"_img_final",
				"_img_red",
			])
	}
}
window["ArmorItem"] = ArmorItem