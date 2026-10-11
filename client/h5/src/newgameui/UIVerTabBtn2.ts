import { BaseItem1 } from "../common/BaseItem1"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIVerTabSubBtn } from "./UIVerTabSubBtn"
import { SoundManager } from "../common/SoundManager"
import { Util } from "../util/Util"
import { GameResPath } from "../util/GameResPath"
import { UIVerTabSubBtn2 } from "./UIVerTabSubBtn2"

export class UIVerTabBtn2 extends BaseItem1 {
	public Height = 100
	public Width = 158

	private needRefresh = false
	public sub_tab_list: Array<any>
	public sub_tab_item_list = []
	public need_refresh_sub_red_map
	public index = 0
	public show = false
	public creat_item = false
	public call_back: Function
	private index_cache = -1
	private sub_index_cache
	private force_cache
	private refresh_red = false
	private red_state = false
	private icon
	private SubBtn
	private SubBtn_icon_list
	private parent
	private loadcomplete

	public constructor(parent, loadcomplete?) {
		super(parent)
		this.base_file = "newgameui"
		this.layout_file = "UIVerTabBtn2"
		this.is_delay_callback = false

		this.parent = parent
		this.loadcomplete = loadcomplete
		this.load_callback = function () {
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
			this.creat_item = false
		}

		super.DeleteMe()
	}

	public LoadSuccess() {
		// [this.conta,this.tab,this.btn_img,this.img,this.bg,this.subCon,this.red_dot]=
		// this.GetChildrenByNames(["conta","tab","btn_img","img","bg","subCon","red_dot"])
		///////初始状态 设置红点不可见
		//this.refresh_red = false
		this.red_dot.visible = false
		//this.red_state = false
		this.subCon.visible = false
		///////       
		this.sub_tab_item_list = []
		if (this.refresh_red) {
			this.SetRedDot(this.red_state)
		}
	}

	public InitEvents() {
		let select_fun = (parent_idnex, sub_index, parent) => {
			if (this.parent == parent) {
				if (this.index == parent_idnex) {
					this.SetSelectSubIndex(parent_idnex, sub_index)
				}
				else {
					this.SetSelectSubIndex(999, 999) //不选中
				}
			}
		}
		this.BindEvent(GlobalEventSystem, EventName.SUB_TAB_BTN_BE_SELECTED, select_fun)

		if (this.needRefresh) {
			this.SetTabData(this.sub_tab_list, this.index, this.call_back, this.icon, this.SubBtn, this.SubBtn_icon_list);
		}
	}
	//设置选项卡数据
	public SetTabData(list: Array<any>, index, call_back: Function, icon?, SubBtn?, SubBtn_icon_list?) {
		this.sub_tab_list = list
		this.index = index
		this.call_back = call_back
		this.icon = icon
		this.SubBtn = SubBtn
		this.SubBtn_icon_list = SubBtn_icon_list

		if (this.is_loaded) {
			if (this.icon) {
				ResManager.GetInstance().SetImageSprite(this, this.img,"newgameui",`${this.icon}`)
			}
			if (this.show || (this.index_cache != undefined && this.index_cache == this.index)) {
				this.CreatItem()
			} else {
				this.index_cache = -1
			}
		}
		else {
			this.needRefresh = true;
		}
	}

	public CreatItem() {
		if (this.creat_item) {
			return
		}
		this.creat_item = true

		let item
		for (let i = 0; i < this.sub_tab_list[1].length; i++) {
			item = this.sub_tab_item_list[i]
			if (!item) {
				let tabBtn = this.SubBtn ? this.SubBtn : UIVerTabSubBtn
				item = new tabBtn(this.subCon)
				this.sub_tab_item_list[i] = item
				item.Load()
			}
			item.SetSubData(this.sub_tab_list[1][i], this.index, i, this.call_back, this.SubBtn_icon_list && this.SubBtn_icon_list[i])
			if (this.need_refresh_sub_red_map && this.need_refresh_sub_red_map[i] != null) {
				item.SetRedDot(this.need_refresh_sub_red_map[i])
				this.need_refresh_sub_red_map[i] = null
			}
			//二级选项卡按钮被点击
			let onBtnClickHandler = () => {
				SoundManager.GetInstance().PlaySoundEffect("2_dianji");
				GlobalEventSystem.Fire(EventName.SUB_TAB_BTN_BE_SELECTED, this.index, i, this.parent)
			};
			if (item.sub_conta) {
				Util.AddClickEvent(item.sub_conta, onBtnClickHandler, this)
			}
		}
		this.RefreshSize()
		if (this.index_cache > -1) {
			this.SetSelectMode(this.index_cache, this.sub_index_cache, this.force_cache)
			this.index_cache = -1
		}
	}

	//刷新大小
	public RefreshSize() {
		if (this.show) {
			let subHeight = 0
			if (this.SubBtn == undefined) {
				subHeight = UIVerTabSubBtn.Height
			} else {
				subHeight = this.SubBtn.Height
			}
			let height = this.sub_tab_list[1].length * (subHeight + 6) + this.subCon.y
			//this.bg.visible = true;
			//this.bg.height = this.sub_tab_list[1].length * (subHeight + 6) + 85;
			//this.display_obj.height = this.bg.height + this.bg.y + 10;
			this.display_obj.height = height
		}
		else {
			this.display_obj.height = this.tab.height
			//this.bg.visible = false;
		}
		GlobalEventSystem.Fire(EventName.TAB_BAR_REFRESH);
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
				this.CreatItem()

				this.ShowSubBtnVisible(true)
				if (sub_index != null) {
					this.SetSelectSubIndex(index, sub_index)
				}
			}
			else {
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
			this.subCon.visible = show;
		}
	}
	//设置选中的二级按钮
	public SetSelectSubIndex(index: number, sub_index: number) {
		for (let item of this.sub_tab_item_list) {
			if (item.parent_index == index && item.sub_index == sub_index) {
				item.SetSelected(true);
			}
			else {
				item.SetSelected(false);
			}
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

	public SetSubRedDot(sub_index, red_state) {
		if (this.sub_tab_item_list[sub_index]) {
			this.sub_tab_item_list[sub_index].SetRedDot(red_state)
		}
		else {
			this.need_refresh_sub_red_map = this.need_refresh_sub_red_map || []
			this.need_refresh_sub_red_map[sub_index] = red_state
		}
	}

	public localToGlobal(x, y) {
		var point: Laya.Point = new Laya.Point(x, y)
		return this.display_obj.localToGlobal(point)
	}

	public getHeight() {
		return this.display_obj.height
	}

	conta: Laya.Box
	tab: Laya.Box
	btn_img: Laya.Image
	img: Laya.Image
	subCon: Laya.VBox
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.conta,
			this.tab,
			this.btn_img,
			this.img,
			this.subCon,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"conta",
				"tab",
				"btn_img",
				"img",
				"subCon",
				"red_dot",
			])
	}
}
window["UIVerTabBtn2"] = UIVerTabBtn2