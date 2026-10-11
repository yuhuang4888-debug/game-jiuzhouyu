import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"

export class longlangStrAttr extends BaseItem1 {
	SetData
	need_refresh = false
	cache_cur
	cache_next

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.layout_file = "longlangStrAttr"

		this.load_callback = () => {
			this.curLb.style.fontSize = 20
			this.curLb.style.color = "#663915"
			this.curLb.style.wordWrap = false
			
			this.nextLb.style.fontSize = 20
			this.nextLb.style.color = "#663915"
			this.nextLb.style.wordWrap = false
			
			if(this.need_refresh){
				this.need_refresh = false
				this.SetData(this.cache_cur, this.cache_next)
			}
		}

		this.SetData = (cur?, next?) => {
			if (!this.is_loaded) {
				this.need_refresh = true
				this.cache_cur = cur
				this.cache_next = next
				return
			}
			this.curLb.innerHTML = Util.StrToHTML(WordManager.GetProperties(cur[0]) + ":<font color='#d15e00'>" + cur[1] + "</font>")
			this.nextLb.visible = next && true
			if (next) {
				this.nextLb.innerHTML = Util.StrToHTML(WordManager.GetProperties(next[0]) + ":<font color='#0a953e'>" + next[1] + "</font>")
			}
		}
	}

	curLb: Laya.HTMLDivElement
	nextLb: Laya.HTMLDivElement
	arrow: Laya.Image
	public GetComponents() {
		[
			this.curLb,
			this.nextLb,
			this.arrow,
		]
			= this.GetChildrenByNames([
				"curLb",
				"nextLb",
				"arrow",
			])
	}
}
window["longlangStrAttr"] = longlangStrAttr