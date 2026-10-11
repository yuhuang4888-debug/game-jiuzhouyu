import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

//树形tabbar的二级按钮
export class UIVerTabSubBtn2 extends BaseItem1 {
	private vo
	private needRefresh = false
	private title
	private icon
	public parent_index = 1
	public sub_index = 1
	private call_back
	private select_cache
	public static Height = 90
	private refresh_red = false
	private red_state = false

	private need_set_callback
	private cantclick
	private clickText
	private callback

	public constructor(parent) {
		super(parent)
		this.base_file = "newgameui"
		this.layout_file = "UIVerTabSubBtn2"

		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public LoadSuccess() {
		// [this.sub_conta,this.btn_state,this.down,this.img,this.red_dot]=
		// this.GetChildrenByNames(["sub_conta","btn_state","down","img","red_dot"])
		///////初始状态 设置红点不可见
		//this.refresh_red = false
		this.red_dot.visible = false;
		//this.red_state = false;
		//////设置down图片不可见
		this.down.visible = false;
		///////       
		if (this.need_set_callback) {
			this.SetCallback(this.callback)
		}
		if (this.refresh_red) {
			this.SetRedDot(this.red_state);
		}
	}
	public InitEvents() {
		if (this.needRefresh) {
			this.SetSubData(this.title, this.parent_index, this.sub_index, this.call_back, this.icon);
		}

	}
	//设置按钮数据
	public SetSubData(text: string, parent_index: number, sub_index: number, call_back: Function, icon) {
		this.title = text
		this.icon = icon
		this.parent_index = parent_index
		this.sub_index = sub_index
		this.call_back = call_back
		if (this.is_loaded) {
			if (this.icon)
				// this.img.source = `newgameui_json.${this.icon}_png`
				ResManager.GetInstance().SetImageSprite(this, this.img,"newgameui",`${this.icon}`)
			// ResManager.GetInstance().SetTexture(this, this.img, `resource/game/newgameui/texture/icon/${this.icon}.png`);
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
			this.down.visible = bool
			if (bool) {
				// this.btn_state.source = "newgameui_json.ui_sub_tab2_png"
				if (this.call_back) {
					this.call_back(this.parent_index, this.sub_index);
				}
				// this.btn_state.x = 6
			}
			else {
				// this.btn_state.source = "newgameui_json.ui_sub_tab1_png"
				// this.btn_state.x = 8
			}
		}
		else {
			this.select_cache = bool;
		}
	}
	public SetRedDot(bool: boolean) {
		this.red_state = bool;
		if (this.is_loaded) {
			this.refresh_red = false;
			if (bool) {
				this.red_dot.visible = true;
			}
			else {
				this.red_dot.visible = false;
			}
		}
		else {
			this.refresh_red = true;
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

	public sub_conta: Laya.Box
	public btn_state: Laya.Image
	public down: Laya.Image
	public img: Laya.Image
	public red_dot: Laya.Image
	public GetComponents() {
		[
			this.sub_conta,
			this.btn_state,
			this.down,
			this.img,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"sub_conta",
				"btn_state",
				"down",
				"img",
				"red_dot",
			])
	}
}

window["UIVerTabSubBtn2"] = UIVerTabSubBtn2