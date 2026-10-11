import { UIVerTabBtn } from "../newgameui/UIVerTabBtn"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { SetSizeDeltaY, GetSizeDeltaY } from "../util/Util"
import { ResManager } from "../common/ResManager"

export class longVerTabBtn extends UIVerTabBtn {
	public Height = 68
	public Width = 198
	public static width = 198
	force_cache
	index_cache
	show
	sub_index_cache

	public constructor(parent, loadcomplete?) {
		super(parent, loadcomplete)
		this.base_file = "longlanguage"
		this.layout_file = "longVerTabBtn"
	}

	public RefreshSize() {
		if (this.show) {
			let height = this.sub_tab_list[1].length * 64 + this.subCon.y
			SetSizeDeltaY(this.display_obj, height)
		} else {
			SetSizeDeltaY(this.display_obj, GetSizeDeltaY(this.tab))
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
				this.tab_txt.color = "#9b572f"
				ResManager.GetInstance().SetImageSprite(this, this.btn_img, "longlanguage", "ui_long_btn0")
				this.ShowSubBtnVisible(true)
				if (sub_index != null) {
					this.SetSelectSubIndex(index, sub_index)
				}
			} else {
				this.tab_txt.color = "#ffffff"
				ResManager.GetInstance().SetImageSprite(this, this.btn_img, "longlanguage", "ui_long_btn1")
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
	subCon: Laya.VBox
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.conta,
			this.tab,
			this.btn_img,
			this.tab_txt,
			this.subCon,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"conta",
				"tab",
				"btn_img",
				"tab_txt",
				"subCon",
				"red_dot",
			])
	}
}
window["longVerTabBtn"] = longVerTabBtn