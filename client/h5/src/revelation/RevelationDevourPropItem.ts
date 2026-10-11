import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"

export class RevelationDevourPropItem extends BaseItem1 {
	res_mgr
	data_cur
	data_next
	need_refresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "revelation"
		this.layout_file = "RevelationDevourPropItem"
		
		this.res_mgr = ResManager.GetInstance()
		
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}
	
	private LoadSuccess() {
		this.curLb.style.wordWrap = false
		this.curLb.style.fontSize = 22
		this.curLb.style.color = "#663915"
		
		this.nextLb.style.wordWrap = false
		this.nextLb.style.fontSize = 22
		this.nextLb.style.color = "#663915"
		
		if (this.need_refresh) {
			this.need_refresh = false
			this.InitView()
		}
	}
	
	public SetData(curData?, nextData?) {
		this.data_cur = curData
		this.data_next = nextData
		
		if (this.is_loaded) {
			this.InitView()
		}else{
			this.need_refresh = true
		}
	}
	
	private InitView() {
		if (!this.data_next) {
			//this.arrow.visible = false
			//this.nextLb.visible = false
			if (this.data_cur[1] == 999) {
				this.nextLb.style.bold = true
				this.display_obj.height = 50
			} else {
				this.nextLb.style.bold = false
				this.display_obj.height = 37
			}
			this.nextLb.innerHTML = "<font color='#663915'>已满级</font>"
		} else {
			this.arrow.visible = true
			this.nextLb.visible = true
			if (this.data_next[1] == 999) {
				this.res_mgr.SetImageSprite(this, this.arrow, "revelation", "com_arrow_6")
				this.nextLb.innerHTML = Util.StrToHTML("<font color='#663915'>聚灵等级:</font> <font color='#0a953e'>" + WordManager.ConvertToPercentValue(this.data_next[1], this.data_next[2]) + "</font><br/>")
				this.nextLb.style.bold = true
				this.display_obj.height = 50
			} else {
				this.res_mgr.SetImageSprite(this, this.arrow, "revelation", "com_uparrow_02")
				this.nextLb.innerHTML = Util.StrToHTML("<font color='#663915'>" + WordManager.GetProperties(this.data_next[0]) + ":</font> <font color='#0a953e'>" + WordManager.ConvertToPercentValue(this.data_next[0], this.data_next[1]) + "</font>")
				this.nextLb.style.bold = false
				this.display_obj.height = 37
			}
		}
		
		if (!this.data_cur) {
			this.data_cur = [this.data_next[0], 0]
		}
		if (this.data_cur[1] == 999) {
			this.res_mgr.SetImageSprite(this, this.arrow, "revelation", "com_arrow_6")
			this.curLb.innerHTML = Util.StrToHTML("<font color='#663915'>聚灵等级:</font> <font color='#d15e00'>" + WordManager.ConvertToPercentValue(this.data_cur[1], this.data_cur[2]) + "</font><br/>")
			this.curLb.style.bold = true
		} else {
			this.res_mgr.SetImageSprite(this, this.arrow, "revelation", "com_uparrow_02")
			this.curLb.innerHTML = Util.StrToHTML("<font color='#663915'>" + WordManager.GetProperties(this.data_cur[0]) + ":</font> <font color='#d15e00'>" + WordManager.ConvertToPercentValue(this.data_cur[0], this.data_cur[1]) + "</font>")
			this.curLb.style.bold = false
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
window["RevelationDevourPropItem"] = RevelationDevourPropItem