import { BaseItem1 } from "../common/BaseItem1"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Util } from "../util/Util"
import { UIVerTabSubBtn } from "./UIVerTabSubBtn"
import { SoundManager } from "../common/SoundManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { UIVerEvent } from "./UIVerTabBar"

//树形tabbar控件的一级按钮
export class UIVerTabBtn extends BaseItem1 {
	public Height = 68
	public Width = 158

	private needRefresh = false
	public sub_tab_list: Array<any>
	public sub_tab_item_list = []
	public need_refresh_sub_red_map
	public index = 0
	public show = false
	public create_item = false
	public call_back: Function
	public index_cache = -1
	public sub_index_cache
	public force_cache
	private refresh_red = false
	public red_state = false
	private SubBtn
	private SubBtn_icon_list
	private parent
	private loadcomplete
	res_mgr

	public constructor(parent, loadcomplete?) {
		super(parent)
		this.base_file = "newgameui"
		this.layout_file = "UIVerTabBtn"
		this.is_delay_callback = false

		this.res_mgr = ResManager.GetInstance()
		
		this.parent = parent
		//加载完后调用函数
		this.loadcomplete = loadcomplete
		this.load_callback = ()=>{
			if (PlatformManager.IsEyouEnPlatform()||PlatformManager.IsEyouThPlatform()) {
				this.tab_txt.height = 62
				this.tab_txt.width = 160
				this.tab_txt.leading = 0.1
				this.tab_txt.wordWrap =true
			}
			this.LoadSuccess()
			this.InitEvents()

			Util.AddClickEvent(this.tab, () => {
				this.loadcomplete()
			}, this)
		}
	}

	public DeleteMe() {
		if (this.sub_tab_item_list) {
			for (let item of this.sub_tab_item_list) {
				item.DeleteMe()
				item = null
			}
			this.sub_tab_item_list = null
			this.create_item = false
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		///////初始状态 设置红点不可见
		//this.refresh_red = false
		this.red_dot.visible = false
		//this.red_state = false
		///////
		if (PlatformManager.IsEyouEnPlatform()||PlatformManager.IsEyouThPlatform()) {
			this.tab_txt.fontSize = 20
		}
		this.sub_tab_item_list = []
		if (this.refresh_red) {
			this.SetRedDot(this.red_state)
		}
	}

	public InitEvents() {
		let select_fun = (parent_idnex, sub_index, parent) => {
			if (this.parent == parent) {
				if (this.index == parent_idnex) {
					this.SetSelectSubIndex(parent_idnex, sub_index);
				}
				else {
					this.SetSelectSubIndex(999, 999); //不选中
				}
			}
		}
		this.BindEvent(GlobalEventSystem, EventName.SUB_TAB_BTN_BE_SELECTED, select_fun)

		if (this.needRefresh) {
			this.SetTabData(this.sub_tab_list, this.index, this.call_back, null, this.SubBtn, this.SubBtn_icon_list)
		}
	}

	//设置选项卡数据
	public SetTabData(list: Array<any>, index, call_back: Function, icon?, SubBtn?, SubBtn_icon_list?) {
		this.sub_tab_list = list
		this.index = index
		this.call_back = call_back
		this.SubBtn = SubBtn
		this.SubBtn_icon_list = SubBtn_icon_list

		if (this.is_loaded) {
			if (this.sub_tab_list) {
				this.tab_txt.text = this.sub_tab_list[0]
				if (this.show || (this.index_cache!=undefined && this.index_cache == this.index)) {
					this.CreateItem()
				}else {
					this.index_cache = -1
				}
			}
		}
		else {
			this.needRefresh = true
		}
	}

	public CreateItem() {
		if (this.create_item) {
			return
		}
		this.create_item = true

		let item
		for (let i = 0; i < this.sub_tab_list[1].length; i++) {
			item = this.sub_tab_item_list[i]
			if (!item) {
				let tabBtn = this.SubBtn ? this.SubBtn : UIVerTabSubBtn
				item = new tabBtn(this.subCon)
				this.sub_tab_item_list[i] = item
				if (this.need_refresh_sub_red_map && this.need_refresh_sub_red_map[i] != null) {
					item.SetRedDot(this.need_refresh_sub_red_map[i])
					this.need_refresh_sub_red_map[i] = null
				}
				item.Load()
			}
			item.SetSubData(this.sub_tab_list[1][i], this.index, i, this.call_back, this.SubBtn_icon_list && this.SubBtn_icon_list[i])
			//二级选项卡按钮被点击
			let onBtnClickHandler = () => {
				SoundManager.GetInstance().PlaySoundEffect("2_dianji")
				GlobalEventSystem.Fire(EventName.SUB_TAB_BTN_BE_SELECTED, this.index, i, this.parent)
			};
			item.SetCallback(onBtnClickHandler)
		}
		this.RefreshSize()
		if (this.index_cache > -1) {
			this.SetSelectMode(this.index_cache, this.sub_index_cache, this.force_cache)
			this.index_cache = -1
		}
	}

	public SetSubRedDot(sub_index, red_state) {
		if (this.sub_tab_item_list[sub_index]) {
			this.sub_tab_item_list[sub_index].SetRedDot(red_state)
		}
		else {
			this.need_refresh_sub_red_map = this.need_refresh_sub_red_map || []
			this.need_refresh_sub_red_map[sub_index] = red_state
		}
	}

	//刷新大小
	public RefreshSize() {
		let subHeight = 0
		if (this.SubBtn == undefined) {
			subHeight = UIVerTabSubBtn.Height
		} else {
			subHeight = this.SubBtn.Height
		}
		if (this.show) {
			let height = this.sub_tab_list[1].length * (subHeight + 6) + this.subCon.y;
			this.display_obj.height = height;
		}
		else {
			this.display_obj.height = this.tab.height;
		}
		GlobalEventSystem.Fire(EventName.TAB_BAR_REFRESH, this.display_obj.height)
	}

	public SetSelectMode(index: number, sub_index?: number, force_show?: boolean) {
		if (this.is_loaded) {
			if (this.index == index) {
				this.show = !this.show
			}
			else {
				this.show = false
			}
			if (force_show && this.index == index) {
				this.show = true
			}
			if (this.show && index != null) {
				this.CreateItem()
				this.res_mgr.SetImageSprite(this, this.btn_img, "common4", "ui_btn_achv_highlight")
				this.tab_txt.color = "#9b572f"
				this.ShowSubBtnVisible(true)
				if (sub_index != null) {
					this.SetSelectSubIndex(index, sub_index)
				}
			}
			else {
				this.res_mgr.SetImageSprite(this, this.btn_img, "common4", "ui_btn_achv")
				this.tab_txt.color = "#ffffff"
				this.ShowSubBtnVisible(false)
			}
			this.RefreshSize()
		}
		else {
			this.index_cache = index
			this.sub_index_cache = sub_index
			this.force_cache = force_show
		}
	}

	//二级按钮容器
	public ShowSubBtnVisible(show: boolean) {
		if (this.subCon && this.sub_tab_item_list && this.sub_tab_item_list.length != 0) {
			this.subCon.visible = show
		}
	}

	//设置选中的二级按钮
	public SetSelectSubIndex(index: number, sub_index: number) {
		for (let item of this.sub_tab_item_list) {
			if (item.parent_index == index && item.sub_index == sub_index) {
				item.SetSelected(true)
			}
			else {
				item.SetSelected(false)
			}
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

	public localToGlobal(x, y) {
		let point: Laya.Point = new Laya.Point(x, y)
		return point
		//return this.display_obj.localToGlobal(point)
	}

	public getHeight() {
		return this.display_obj.height
		//return this.Height
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
window["UIVerTabBtn"] = UIVerTabBtn