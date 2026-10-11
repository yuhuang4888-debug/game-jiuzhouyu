import { UIVerTabSubBtn } from "../newgameui/UIVerTabSubBtn"
import { ResManager } from "../common/ResManager"

export class longVerTabSubBtn extends UIVerTabSubBtn {
	public static Height = 58
	select_cache
	data
	cache_img

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.layout_file = "longVerTabSubBtn"
	}

	public LoadSuccess() {
		super.LoadSuccess()
		if (this.cache_img) {
			ResManager.GetInstance().SetImageSprite(this, this.btn_state, "longlanguage", "uilyqh_b" + this.cache_img)
			this.cache_img = null
		}
	}

	public SetSelected(bool?) {
		if (this.is_loaded) {
			this.down.visible = bool
			let source = null
			if (bool) {
				if (this.call_back) {
					this.call_back(this.parent_index, this.sub_index)
				}
				source = "a" + this.data
			} else {
				source = "b" + this.data
			}
			ResManager.GetInstance().SetImageSprite(this, this.btn_state, "longlanguage", "uilyqh_" + source)
		} else {
			this.select_cache = bool
		}
	}

	public SetSubData(text?, parent_index?, sub_index?, call_back?) {
		if (typeof (text) == "string") {
			super.SetSubData(text, parent_index, sub_index, call_back)
		} else {
			let text1 = text[1].split("@") //Split(text[2], "@")
			this.data = text1[0]
			if (this.is_loaded) {
				ResManager.GetInstance().SetImageSprite(this, this.btn_state, "longlanguage", "uilyqh_b" + text1[0])
			} else {
				this.cache_img = text1[0]
			}
			super.SetSubData(text1[1], parent_index, sub_index, call_back)
		}
	}

	sub_conta: Laya.Box
	btn_state: Laya.Image
	down: Laya.Image
	btn_text: Laya.Label
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.sub_conta,
			this.btn_state,
			this.down,
			this.btn_text,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"sub_conta",
				"btn_state",
				"down",
				"btn_text",
				"red_dot",
			])
	}
}
window["longVerTabSubBtn"] = longVerTabSubBtn