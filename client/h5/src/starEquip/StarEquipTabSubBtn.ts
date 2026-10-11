import { UIVerTabSubBtn } from "../newgameui/UIVerTabSubBtn"
import { ResManager } from "../common/ResManager"

export class StarEquipTabSubBtn extends UIVerTabSubBtn {
	call_back
	needRefresh
	parent_index
	select_cache
	sub_index
	cache_text

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipTabSubBtn"
	}

	public SetSubData(text?, parent_index?, sub_index?, call_back?) {
		this.parent_index = parent_index
		this.sub_index = sub_index
		this.call_back = call_back
		if (text){
			this.cache_text = text
		}
		
		if (this.is_loaded) {
			ResManager.GetInstance().SetImageSprite(this, this.icon, "starEquip", this.cache_text, true)
			if (this.select_cache != null) {
				this.SetSelected(this.select_cache)
				this.select_cache = null
			}
		} else {
			this.needRefresh = true
		}
	}

	public SetSelected(bool?) {
		if (this.is_loaded) {
			if (bool) {
				if (this.call_back) {
					this.call_back(this.parent_index, this.sub_index)
				}
				this.down.visible = true
			} else {
				this.down.visible = false
			}
		} else {
			this.select_cache = bool
		}
	}

	sub_conta: Laya.Box
	btn_state: Laya.Image
	down: Laya.Image
	icon: Laya.Image
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.sub_conta,
			this.btn_state,
			this.down,
			this.icon,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"sub_conta",
				"btn_state",
				"down",
				"icon",
				"red_dot",
			])
	}
}
window["StarEquipTabSubBtn"] = StarEquipTabSubBtn