import { UIVerTabBtn } from "../newgameui/UIVerTabBtn"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDeltaY } from "../util/Util"

export class StarEquipComTabBtn extends UIVerTabBtn {
	public static width = 158
	public constructor(parent?, loadcomplete?) {
		super(parent, loadcomplete)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipComTabBtn"
	}

	public RefreshSize() {
		if (this.show) {
			let height = this.sub_tab_list[1].length * 116 + 64
			SetSizeDeltaY(this.display_obj, height)
		} else {
			SetSizeDeltaY(this.display_obj, 68)
		}
		GlobalEventSystem.Fire(EventName.TAB_BAR_REFRESH)
	}

	public SetSelectMode(index?, sub_index?, force_show?) {
		if (this.is_loaded) {
			if (this.index == index) {
				this.show = !this.show
			} else {
				this.show = false
			}
			if (force_show && this.index == index) {
				this.show = true
			}
			if (this.show && index != null) {
				this.CreateItem()
				//SetLocalRotation(this.arrow, 180, 0, 0, 1)
				this.res_mgr.SetImageSprite(this, this.btn_img, "starEquip", "uijs_011a")
				this.res_mgr.SetImageSprite(this, this.arrow, "starEquip", "uilyqh_004a")
				this.tab_txt.color = "#9b572f"
				this.ShowSubBtnVisible(true)
				if (sub_index != null) {
					this.SetSelectSubIndex(index, sub_index)
				}
			} else {
				//SetLocalRotation(this.arrow, 0, 0, 0, 1)
				this.res_mgr.SetImageSprite(this, this.btn_img, "starEquip", "uijs_011b")
				this.res_mgr.SetImageSprite(this, this.arrow, "starEquip", "uilyqh_004b")
				this.tab_txt.color = "#ffffff"
				this.ShowSubBtnVisible(false)
			}
			this.RefreshSize()
		} else {
			this.index_cache = index
			this.sub_index_cache = sub_index
			this.force_cache = force_show
		}
	}

	conta: Laya.Box
	tab: Laya.Box
	btn_img: Laya.Image
	tab_txt: Laya.Label
	arrow: Laya.Image
	subCon: Laya.VBox
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.conta,
			this.tab,
			this.btn_img,
			this.tab_txt,
			this.arrow,
			this.subCon,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"conta",
				"tab",
				"btn_img",
				"tab_txt",
				"arrow",
				"subCon",
				"red_dot",
			])
	}
}
window["StarEquipComTabBtn"] = StarEquipComTabBtn