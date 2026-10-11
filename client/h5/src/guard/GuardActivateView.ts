import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuardModel } from "../commonModel/GuardModel"
import { GuardActivateItem } from "./GuardActivateItem"
import { GameResPath } from "../util/GameResPath"

export class GuardActivateView extends BaseView1 {
	un_activate_list = null
	item_list = []

	public constructor() {
		super()
		this.base_file = "guard"
		this.layout_file = "GuardActivateView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.not_show_attr_main_msg = true
		this.is_center = true
		this.destroy_imm = true
		this.is_lastView_close = true
		this.not_show_main_msg = true

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("guard", "ui_guard_05"))
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.Remove()
			// ViewOrderModel.GetInstance().OpenNextTypeView(EnumViewOrder.eGuardExpired);
		}
	}

	public Open(list?) {
		this.un_activate_list = list
		super.Open()
	}
	
	private Remove() {
		if (this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
			}
			this.item_list = []
		}
	}
	
	private InitEvent() {
		Util.AddClickEvent(this.btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.btn_active, () => {
			for (let i in this.un_activate_list) {
				GuardModel.GetInstance().Fire(GuardModel.OPEN_VIEW, this.un_activate_list[i])
				this.Close()
				return
			}
		}, this, true)
	}
	
	private InitView() {
		if (this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.display_obj.visible = false
			}
		}

		this.gp_item.height = this.un_activate_list.length * 120
		for (let i in this.un_activate_list) {
			let item = this.item_list[i]
			if (!item) {
				item = new GuardActivateItem(this.gp_item)
				item.Load()
				this.item_list[i] = item
			}
			
			let callback = () => {
				if (this.use_delete_method) {
					return
				}
				//SetSizeDeltaY(this._img_028, - GetSizeDeltaY(this._gp_view) - 20)
				item.display_obj.visible = true
				item.SetData(this.un_activate_list[i])
				//if (Number(i) == 1) {
				//	item.transform.SetSiblingIndex(0)
				//}
				//LayoutRebuilder(this._gp_item)
				//LayoutRebuilder(this._gp_view)
				//SetSizeDeltaY(this._img_028,GetSizeDeltaY(this._gp_view))
				//SetSizeDeltaY(this.display_obj, GetSizeDeltaY(this._gp_view) + 250)
			}

			item.ExcuteCallback(callback)
		}
		if (this.un_activate_list.length == 2) {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_043, GameResPath.GetIcon("guard", "uimfz_043"))
			//this._img_043.visible = true
		} else {
			//let com = this._gp_view.GetComponent("UnityEngine.UI.VerticalLayoutGroup")
			//com.spacing = 40
			//SetAnchoredPositionY(this._gp_view, -80)
		}
		//LayoutRebuilder(this._gp_item)
		//LayoutRebuilder(this._gp_view)
		//SetSizeDeltaY(this._img_028,GetSizeDeltaY(this._gp_view))
		//SetSizeDeltaY(this.display_obj, GetSizeDeltaY(this._gp_view) + 250)
	}

	img_bg: Laya.Image
	img_title: Laya.Image
	btn_active: Laya.Image
	lb_active: Laya.Label
	gp_item: Laya.VBox
	btn_close: Laya.Image
	public GetComponents() {
		[
			this.img_bg,
			this.img_title,
			this.btn_active,
			this.lb_active,
			this.gp_item,
			this.btn_close,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"img_title",
				"btn_active",
				"lb_active",
				"gp_item",
				"btn_close",
			])
	}
}
window["GuardActivateView"] = GuardActivateView