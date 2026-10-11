import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { UnrealModel } from "../commonModel/UnrealModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorType } from "../util/ColorUtil";

export class UnrealBagItem extends BaseItemRenderer {
	public WIDTH = 85
	public HEIGT = 85

	private _item: EquipmentItem;
	private model: UnrealModel;
	attr_cfg
	public constructor() {
		super()
		this.base_file = "unreal"
		this.layout_file = "UnrealBagItem"
		this.model = UnrealModel.GetInstance()
		this.Load()

	}

	public createChildren() {
		super.createChildren()
	}

	public load_callback() {
		this.display_obj.scaleX = 0.73
        this.display_obj.scaleY = 0.73
		if (!this._item) {
			this._item = new EquipmentItem(this.con)
			this._item.Load()
		}
	}

	protected dataChanged() {
		if (super.dataChanged()) {
			if (!this.data) return
			let data = this.data
			this._item.SetData(data.type_id)
			this._item.SetClickCallBack(this.ClickCallBack)
			let decoration_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_decoration_attr", false)
			this.attr_cfg = this.model.GetUnrealData(this.data.type_id, decoration_attr_cfg)
			if (data.type_id > 0) {
				let equip = this.model.GetWearEquipByPos(data.equip_type)
				this._img_up.visible = this.model.CheckCellUnLockState(data.equip_type) && (!equip || data.rating > equip.rating)
			}
			else
				this._img_up.visible = false

			let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
			this._img_un_open.visible = role_lv < data.level
			this._un_open.visible = !this.model.CheckCellUnLockState(data.equip_type)
			// this._red.visible = this.model.UnrealDismantleRedState(data)
		}
	}

	private ClickCallBack = () => {
		if (this.data && this.attr_cfg) {
			if (this.data.color < ColorType.ORANGE || (this.attr_cfg.stage < UnrealModel.DISMANTLE_STAGE)) {
				UIToolTipMgr.GetInstance().AppendUnrealTips(this.data.type_id, this.data, undefined, [0, 2])
			}
			else {
				UIToolTipMgr.GetInstance().AppendUnrealTips(this.data.type_id, this.data, undefined, [0, 1, 2])
			}
		}
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		super.DeleteMe()
	}
	con: Laya.Box
	_img_up: Laya.Image
	_img_un_open: Laya.Image
	_un_open: Laya.Image
	_red: Laya.Image
	public GetComponents() {
		[
			this.con,
			this._img_up,
			this._img_un_open,
			this._un_open,
			this._red,
		]
			= this.GetChildrenByNames([

				"con",
				"_img_up",
				"_img_un_open",
				"_un_open",
				"_red",
			])
	}
}
window["UnrealBagItem"] = UnrealBagItem