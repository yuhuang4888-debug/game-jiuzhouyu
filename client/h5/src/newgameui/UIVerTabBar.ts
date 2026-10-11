import { BaseItem1 } from "../common/BaseItem1"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { UIVerTabBtn } from "./UIVerTabBtn"
import { SoundManager } from "../common/SoundManager"
import { Util } from "../util/Util"
/**
 * @description:树形TabBar控件
 * @example:
 *          //使用例子
 *          //选项卡配置， "0" 代表一级选项卡，"1" 代表二级选项卡
 *			local tab_data = [
 *               {"0":"紫色符文", "1":["君临", "帝王", "狂怒", "嗜血", "命运"]},
 *               {"0":"橙色符文", "1":["君临", "帝王", "狂怒", "嗜血", "命运"]},
 *               {"0":"红色符文", "1":["君临", "帝王", "狂怒", "嗜血", "命运"]},
 *			]
 *           //回调函数, 通过点击的tab_index，和sub_index 来确定应该要做什么操作
 *			let call_fun = (tab_index, sub_index)=>{
 *
 *		    }
 *			this.verTabBar = new UIVerTabBar(this.scroll_content)
 *
 *			this.verTabBar.SetTabBar(tab_data, call_fun, this.tab_scroll.height)
 *		    //选中第一个选项卡，并且选中第一个二级按钮
 *           this.verTabBar.SetSelectTab(0,0)
 */
export class UIVerTabBar extends BaseItem1 {
	public scroll: Laya.Panel
	public scroll_group: Laya.VBox
	private _img_arrow: Laya.Image
	private needRefresh = false
	private need_refresh_scroller = false
	public tab_list: Array<any>
	public tab_item_list = []
	public sub_index = 0
	public index = 0
	public select_cache
	public force_show
	public call_back: Function
	private parent_height
	// private parent_wnd: Laya.Scroller;
	private tabbtn_func
	private btn
	private iconList
	private sub_btn
	private sub_iconList
	private hide_img_y
	private need_refresh_tab_redDot = false
	private tab_redDot = {}
	private need_refresh_subtab_redDot = false
	private sub_tab_redDot = {}
	private bindScroll = false
	private cont_cache_pos_y = false
	public constructor(parent) {
		super(parent)
		// this.parent_wnd = parent;
		this.base_file = "newgameui"
		this.layout_file = "UIVerTabBar"
		this.is_delay_callback = false

		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public DeleteMe() {
		this.need_refresh_tab_redDot = false
		this.tab_redDot = {}
		this.need_refresh_subtab_redDot = false
		this.sub_tab_redDot = {}
		if (this.scroll) {
			this.scroll.vScrollBar.off(Laya.UIEvent.CHANGE, this, this.change_arrow_img)
		}
		if (this.bindScroll) {
			// this.scroll.removeEventListener(Laya.UIEvent.CHANGE, this.change_arrow_img, this);
			this.hide_img_y = undefined
			this.bindScroll = false
		}
		if (this.tab_item_list) {
			for (let obj of this.tab_item_list) {
				obj.DeleteMe()
			}
			this.tab_item_list = []
		}
		super.DeleteMe()
	}
	public LoadSuccess() {
		// this.display_obj.x=500;
		this.scroll.vScrollBar.visible = false
	}
	public InitEvents() {
		let refresh_size_fun = (height) => {
			//this.scroll_group.height = height
			this.scroll_group.refresh()
			// if (this.parent_wnd) {
			//     this.parent_wnd.invalidateSize();
			// }
			//this.change_arrow_img()
		}
		this.BindEvent(GlobalEventSystem, EventName.TAB_BAR_REFRESH, refresh_size_fun)
		if (this.needRefresh) {
			this.SetTabBar(this.tab_list, this.call_back, this.parent_height, this.tabbtn_func, this.btn, this.iconList, this.hide_img_y, this.sub_btn, this.sub_iconList);
		}
		if (this.need_refresh_scroller) {
			this.RefreshSrollerPos();
		}
		if (this.need_refresh_tab_redDot) {
			for (let key in this.tab_redDot) {
				let show = this.tab_redDot[key];
				this.setTabRedDot(key, show);
			}
			this.need_refresh_tab_redDot = false;
		}
		if (this.need_refresh_subtab_redDot) {
			for (let key in this.sub_tab_redDot) {
				let show = this.sub_tab_redDot[key];
				let list = key.split("_");
				this.setSubTabRedDot(list[0], list[1], show);
			}
			this.need_refresh_subtab_redDot = false;
		}
		if (this.cont_cache_pos_y) {
			this.SetContentPos(this.cont_cache_pos_y)
			this.cont_cache_pos_y = false
		}
	}
	/**
	 * 树形TabBar控件（二级按钮）
	 * @param tab_list          tabbar选项卡的显示用数组
	 * @param call_back         回调函数
	 * @param parent_height     挂在该tabbar的父类容器的高度
	 * @param SubBtn            二级按钮的类型：文字、图片
	 */
	public SetTabBar(tab_list: Array<any>, call_back: Function, parent_height: number, tabbtn_func?, btn?, iconList?, hide_img_y?, SubBtn?, SubBtn_icon_list?) {
		this.ClearTab()
		this.parent_height = parent_height
		this.tab_list = tab_list
		this.call_back = call_back
		this.tabbtn_func = tabbtn_func
		this.btn = btn
		this.iconList = iconList
		this.hide_img_y = hide_img_y
		this.sub_btn = SubBtn
		this.sub_iconList = SubBtn_icon_list

		if (this.is_loaded) {
			let width = (this.btn && this.btn.width) ? this.btn.width : 158
			// let width = this.btn ? this.btn.width : 158
			this.display_obj.width = width
			if (!this.bindScroll && this.hide_img_y != null) {
				this.scroll.vScrollBar.on(Laya.UIEvent.CHANGE, this, this.change_arrow_img)
				this.scroll_group.on(Laya.Event.RESIZE, this, this.change_arrow_img)
				this.bindScroll = true
				this.scroll.height = parent_height //- 50
				this.display_obj.height = parent_height
				this.change_arrow_img()
			}
			else {
				this.scroll.height = parent_height
				this.display_obj.height = parent_height
			}
			this._img_arrow.y = parent_height + 30 //this.scroll.height + 12
			if (this.tab_list && this.tab_list.length > 0) {
				let item;
				for (let i = 0; i < this.tab_list.length; i++) {
					item = this.tab_item_list[i];
					if (!item) {
						let tabBtn = this.btn ? this.btn : UIVerTabBtn
						let loadcomplete = () => {
							// SoundManager.GetInstance().PlaySoundEffect("2_dianji");
							this.SetSelectTab(i);
							// this.scroll_group.validateNow();
							if (this.tabbtn_func) {
								this.tabbtn_func();
							}
						}
						item = new tabBtn(this.scroll_group, loadcomplete);
						this.tab_item_list[i] = item;
						item.Load();
					}
					let icon;
					if (this.iconList)
						icon = this.iconList[i];
					item.SetTabData(this.tab_list[i], i, call_back, icon, SubBtn, SubBtn_icon_list);
					//一级选项卡按钮被点击
				}
				if (this.select_cache) {
					this.select_cache = null;
					this.SetSelectTab(this.index, this.sub_index, this.force_show);
				}
			}
		}
		else {
			this.needRefresh = true;
		}
	}

	//设置选中的选项卡
	public SetSelectTab(index: number, sub_index?: number, force_show?: boolean) {
		this.sub_index = sub_index
		this.index = index
		this.force_show = force_show
		if (this.is_loaded) {
			for (let item of this.tab_item_list) {
				item.SetSelectMode(index, sub_index, force_show)
			}
			this.change_arrow_img()
		}
		else {
			this.select_cache = true
		}
	}

	private change_arrow_img() {
		let point = this.GetTabLastPos()
		if (point && this.hide_img_y && point.y > this.hide_img_y) {
			this._img_arrow.visible = true
			this.UpdateArrowRed()
			return
		}
		this._img_arrow.visible = false
	}

	//获取最下面的item的绝对坐标
	public GetTabLastPos() {
		if (this.tab_item_list) {
			let lasttabbtn: UIVerTabBtn = this.tab_item_list[this.tab_item_list.length - 1]
			if (!lasttabbtn || !lasttabbtn.is_loaded) {
				return null
			}
			if (lasttabbtn.show) {
				let lastsubbtn = lasttabbtn.sub_tab_item_list[lasttabbtn.sub_tab_item_list.length - 1]
				if (lastsubbtn && lastsubbtn.is_loaded) {
					//return lastsubbtn.localToGlobal(0, lasttabbtn.Height)
					return { x: 0, y: lastsubbtn.display_obj.y }
				}
				else {
					return false
				}
			}
			else {
				//return lasttabbtn.localToGlobal(0, lasttabbtn.Height)
				return { x: 0, y: lasttabbtn.display_obj.y }
			}
		}
		return null;
	}

	//箭头红点
	private UpdateArrowRed() {
		let red = false
		let height = Math.ceil(this.scroll.vScrollBar.value)
		if (this.tab_item_list) {
			for (let i in this.tab_item_list) {
				let item = this.tab_item_list[i]
				if (item.red_state) {
					let item_y = item.display_obj.y - height
					if (item_y && this.hide_img_y && item_y > this.hide_img_y) {
						red = true
						break
					} else if (item.show) {
						for (let j in item.sub_tab_item_list) {
							let sub_item = item.sub_tab_item_list[j]
							if (sub_item && sub_item.is_loaded && sub_item.red_state) {
								let sub_item_y = sub_item.display_obj.y - height
								if (sub_item_y && this.hide_img_y && sub_item_y > this.hide_img_y) {
									red = true
									break
								}
							}
						}
					}
				}
				if (red) {
					break
				}
			}
		}
		this.img_red.visible = red
	}

	public ClearTab() {
		if (this.tab_item_list) {
			for (let obj of this.tab_item_list) {
				obj.DeleteMe();
			}
			this.tab_item_list = [];
		}
		this.tab_list;
		this.tab_item_list = [];
		// this.sub_index = 0
		// this.index = 0
		// this.select_cache
		// this.force_show
		// this.call_back
		// this.parent_height
	}

	public RefreshSrollerPos() {
		if (this.is_loaded) {
			// this.scroll_group.validateNow();
			// let max_scroll = this.scroll_group.contentHeight - this.scroll.height;
			// this.scroll_group.scrollV = Math.max(0, Math.min((this.index) * 53, max_scroll));
			let max_scroll = this.scroll_group.viewport.height - this.scroll.height;
			this.scroll_group.viewport.y = Math.max(0, Math.min((this.index) * 53, max_scroll));
		}
		else {
			this.need_refresh_scroller;
		}
	}

	public SetContentPos(pos_y) {
		if (this.is_loaded) {
			this.scroll_group.viewport.y = pos_y
		}
		else {
			this.cont_cache_pos_y = pos_y
		}
	}

	public setTabRedDot(index, bool) {
		if (!this.is_loaded) {
			this.tab_redDot[index] = bool
			this.need_refresh_tab_redDot = true
			return
		}
		this.tab_item_list[index].SetRedDot(bool)
	}

	public setSubTabRedDot(index, subIndex, bool) {
		if (!this.is_loaded) {
			this.sub_tab_redDot[`${index}_${subIndex}`] = bool
			this.need_refresh_subtab_redDot = true
			return;
		}
		let t_item = this.tab_item_list[index]
		if (t_item) {
			t_item.SetSubRedDot(subIndex, bool)
		}
	}

	public GetIndex(){
		return this.index
	}
	img_red: Laya.Image
	public GetComponents() {
		[
			this.scroll,
			this.scroll_group,
			this._img_arrow,
			this.img_red,
		]
			= this.GetChildrenByNames([
				"scroll",
				"scroll_group",
				"_img_arrow",
				"img_red",
			])
	}
}

export class UIVerEvent {
	static LOADTAB_COMPLETE = "LOADTAB_COMPLETE";
}
window["UIVerTabBar"] = UIVerTabBar