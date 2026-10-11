import { BaseItem1 } from "../common/BaseItem1"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

//树形tabbar的二级按钮
export class UIVerTabSubBtn extends BaseItem1 {
	private vo
	protected needRefresh = false
	private title
	public parent_index = 1
	public sub_index = 1
	protected call_back
	protected select_cache
	public static Height = 50
	private refresh_red = false
	public red_state = false

	private need_set_callback
	private cantclick
	private clickText
	private callback

	public constructor(parent) {
		super(parent)
		this.base_file = "newgameui"
		this.layout_file = "UIVerTabSubBtn"
		
		this.load_callback = ()=> {
			if (PlatformManager.IsEyouEnPlatform()||PlatformManager.IsEyouThPlatform()) {
				this.btn_text.height = 45
				this.btn_text.width = 152
				this.btn_text.leading = 0.1
				this.btn_text.wordWrap =true
			}
			this.LoadSuccess()
			this.InitEvents()
		}
	}
	
	public DeleteMe() {
		super.DeleteMe()
	}
	
	public LoadSuccess() {
		///////初始状态 设置红点不可见
		//this.refresh_red = false
		this.red_dot.visible = false
		//this.red_state = false
		//////设置down图片不可见
		this.down.visible = false
		///////
		if (PlatformManager.IsEyouEnPlatform()||PlatformManager.IsEyouThPlatform()) {
			this.btn_text.fontSize = 18
		}
		if (this.need_set_callback) {
			this.SetCallback(this.callback)
		}
		if (this.refresh_red) {
			this.SetRedDot(this.red_state)
		}
	}
	
	public InitEvents() {
		if (this.needRefresh) {
			this.SetSubData(this.title, this.parent_index, this.sub_index, this.call_back)
		}
	}
	
	//设置按钮数据
	public SetSubData(text: string, parent_index: number, sub_index: number, call_back: Function) {
		let stringList = text.split("@")
		if (stringList.length > 1) {
			this.title = stringList[0]
			this.cantclick = true
			this.clickText = stringList[1]
		} else {
			this.title = text
		}
		this.parent_index = parent_index
		this.sub_index = sub_index
		this.call_back = call_back
		if (this.is_loaded) {
			this.btn_text.text = this.title
			if (this.select_cache != null) {
				this.SetSelected(this.select_cache)
				this.select_cache = null
			}
		}
		else {
			this.needRefresh = true
		}
	}
	
	//设置选中状态
	public SetSelected(bool: boolean) {
		if (this.is_loaded) {
			if (bool) {
				this.down.visible = true
				if (this.call_back) {
					this.call_back(this.parent_index, this.sub_index)
				}
			}
			else {
				this.down.visible = false
			}
		}
		else {
			this.select_cache = bool
		}
	}
	public SetRedDot(bool: boolean) {
		this.red_state = bool
		if (this.is_loaded) {
			this.refresh_red = false
			if (bool) {
				this.red_dot.visible = true
			}
			else {
				this.red_dot.visible = false
			}
		}
		else {
			this.refresh_red = true
		}
	}

	public SetCallback(callback) {
		if (this.is_loaded) {
			this.need_set_callback = false
			if (this.cantclick && this.clickText) {
				Util.AddClickEvent(this.sub_conta, () => {
					Message.show(this.clickText)
				}, this)
			} else {
				Util.AddClickEvent(this.sub_conta, () => {
					callback()
				}, this)
			}
		} else {
			this.need_set_callback = true
			this.callback = callback
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
window["UIVerTabSubBtn"] = UIVerTabSubBtn