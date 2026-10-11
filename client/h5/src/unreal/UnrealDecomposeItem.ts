import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { UnrealModel } from "../commonModel/UnrealModel"
import { ColorType } from "../util/ColorUtil"
import { AtlasUrl, Util } from "../util/Util"

export class UnrealDecomposeItem extends BaseItemRenderer {
	public WIDTH = 85
	public HEIGT = 85


	private _item: EquipmentItem
	private _model: UnrealModel

	attr_cfg

	hook_state = false

	public constructor() {
		super()
		this.base_file = "unreal"
		this.layout_file = "UnrealDecomposeItem"
		this._model = UnrealModel.GetInstance()
		this.Load()
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		this.attr_cfg = null
		super.DeleteMe()
	}

	public load_callback() {
		if (!this._item) {
			this._item = new EquipmentItem(this.con)
			this._item.Load()
			this._item.SetItemSize(85, 85)

		}
		// this._item.is_loaded = true
		// this._item.load_callback()

		this.attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_decoration_attr", false)

		this.dataChanged()
		Util.AddClickEvent(this._img_hook, () => {
			if (this.data ) {
				let select_state = !this.data.is_selected
				if (select_state ) {
					let data = this.data.equip_info
					let star = this._model.GetUnrealData(data.type_id, this.attr_cfg).star
					let wear_equip = this._model.GetWearEquipByPos(data.equip_type)
					if (! this._model.alert_decompose 
						&& (! wear_equip 
							|| (data.color == ColorType.ORANGE && star >= 2)
							|| data.color > ColorType.ORANGE
							|| (data.color > wear_equip.color 
								|| (wear_equip.color == data.color 
									&& this._model.CheckUnrealQuality(data.type_id,wear_equip.type_id, this.attr_cfg)
									)
								)
							)
						 ) {
						Alert.Show("当前物品评分较高,是否确认分解?", 
								Alert_Type.AlertTypeCheckBox,() => {
									this.Select(true)
								},
								null,
								null,
								null,
								null,
								false,(bool?) => {
									this._model.alert_decompose = bool
								},
								"本次登录不再提示"
							)
					}else{
						this.Select(true)
					}
	
				}else{
					this.Select(false)
				}
			}
			// if (this.data)
			// 	this.Select(!this.data.is_selected)
		}, this, true)
	}

	public async createChildren() {
		super.createChildren()
		
	}

	private UpdateHookState() {
		if (this.data && this.data.is_selected) {
			this._img_hook.skin = AtlasUrl("common", "com_ui_gx1")
		}
		else {
			this._img_hook.skin = AtlasUrl("common", "com_ui_gx")
		}
	}

	protected dataChanged() {
		if (super.dataChanged() && this.data) {
			let data = this.data.equip_info
			this._item.SetData(data.type_id)
			this._item.SetClickCallBack(this.ClickCallBack)

			let attr_cfg = this.attr_cfg && this.attr_cfg[data.type_id]
			if (attr_cfg) {
				this._item.SetGrade(attr_cfg.stage)
				this._item.SetStar(attr_cfg.star)
			}

			this.Select(this.data.is_selected, false)
		}
	}

	private ClickCallBack = () => {
		if (this.data && this.data.equip_info.type == UnrealModel.goods_type)
			UIToolTipMgr.GetInstance().AppendUnrealTips(this.data.equip_info.type_id, this.data.equip_info, undefined, [0])
	}

	private Select(select, is_fire = true) {
		let data = this.data
		data.is_selected = select == undefined ? !data.is_selected : select
		this.hook_state = select
		this.UpdateHookState()
		if (is_fire) {
			this._model.Fire(UnrealModel.SELECT_BREAK_DOWN_ITEM, this.data)
		}
	}

	con: Laya.Box
	_img_hook: Laya.Image
	public GetComponents() {
		[
			this.con,
			this._img_hook,
		]
			= this.GetChildrenByNames([

				"con",
				"_img_hook",
			])
	}
}
window["UnrealDecomposeItem"] = UnrealDecomposeItem