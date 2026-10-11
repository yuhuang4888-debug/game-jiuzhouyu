import { Mathf } from "../util/Mathf"
import { BaseItemRenderer } from "./BaseItemRenderer"
import { table } from "./table"

export const LoopScrCon = {
	Horizontal: 0,
	Vertical: 1,
}
window["LoopScrCon"] = LoopScrCon
export class LoopScrowViewMgr {
	parent: Laya.List
	data_list: any
	item_renderer: any
	scroll_con: any
	hasInit = false
	move_timer: number
	delay_reset_timer
	delay_last_timer
	delay_first_timer




	public constructor(layer_value?) {

	}
	//新项目适应 parent Laya.List
	// data数据源[]必须为数据    scroll_con 横向滑动还是竖向滑动 LoopScrCon
	//pre_count 没用了，现在需要在List的repeatX repeatY填写横竖的渲染单元格数量（界面处就可填
	//select_func  如果传入函数则表示为list启用选择功能 函数调用参数为data,index 默认选0
	//default_select_index 默认选中索引
	public SetData(parent?: Laya.List, item_renderer?, data?, scroll_con?, pre_count?, select_func?, default_select_index?, item_width?, item_height?, need_scroll = true) {

		if (!parent || !item_renderer || !data) {
			return
		}
		this.parent = parent
		this.data_list = data
		this.scroll_con = scroll_con
		this.item_renderer = item_renderer
		// this.canSelectAgain = cnf && cnf.canSelectAgain // 是否能重复选中
		// this.not_first_call = cnf && cnf.not_first_call //是否初始化时不调用select_func
		if (!this.hasInit) {
			if(need_scroll){
				if (scroll_con == LoopScrCon.Horizontal) {
					parent.hScrollBarSkin = "";
				} else if (scroll_con == LoopScrCon.Vertical) {
					parent.vScrollBarSkin = "";
				}
			}
			parent.itemRender = item_renderer
			parent.renderHandler = Laya.Handler.create(this, this.updateItem, null, false);

			if(item_width){
				BaseItemRenderer.SetItemSize(parent, item_width, item_height)
			}
			if (select_func) {
				parent.selectEnable = true;
				parent.selectHandler = Laya.Handler.create(this, select_func, null, false);
				parent.selectedIndex = default_select_index ? default_select_index : 0
			} else {
				parent.selectEnable = false;
			}

			parent.array = data

			this.hasInit = true
		} else {
			parent.array = data
			parent.refresh()
		}

	}

	private updateItem(cell:BaseItemRenderer, index: number): void {
		cell.selected = index == this.parent.selectedIndex
		cell.updateItem(cell.dataSource, index);
	}

	//更新数据源 基本和h5 replaceAll 方法相同
	public replaceAll(data?, onlyUpdateData?) {
		if (!this.hasInit) {
			return
		}
		this.data_list = data
		if(onlyUpdateData){
			this.parent.updateArray(data)
		}
		else{
			this.parent.array = data
			this.parent.refresh()
		}
	}


	//外部调用 设置选中的索引（传入数据在数组中的索引）
	public SetSelectIndex(real_index?, callFun?) {
		this.parent.selectedIndex = real_index
	}

	//向列表末尾添加指定项目。
	public addItem(item?) {

		table.insert(this.data_list, item)
		this.replaceAll(this.data_list)
	}

	//删除第一个项目并把它添加到列表末尾
	public RemoveAndAddFirst() {

		let item = table.remove(this.data_list, 1)
		table.insert(this.data_list, item)
		this.replaceAll(this.data_list)
	}

	//不需要设置的就传null
	//设置固定的长/宽
	public SetDefaultSize(width?, height?) {

		// this.default_width = width
		// this.default_height = height
	}

	//使用LoopScrowViewMgr时,会把用户设置的所有OnValueChanged移除，改为该代码的函数
	//需要调用自身函数的在这里传
	public SetOnValueChanged(value_callback?) {
		this.parent.scrollBar.on(Laya.Event.CHANGE, this, value_callback)
		// this.value_changed_callback = value_callback
	}

	public DeleteMe() {
		if (this.move_timer) {
			clearTimeout(this.move_timer)
			this.move_timer = undefined
		}
		if (this.delay_reset_timer) {
			clearTimeout(this.delay_reset_timer)
			this.delay_reset_timer = undefined
		}
		if (this.delay_last_timer) {
			clearTimeout(this.delay_last_timer)
			this.delay_last_timer = undefined
		}
		if (this.delay_first_timer) {
			clearTimeout(this.delay_first_timer)
			this.delay_first_timer = undefined
		}
		BaseItemRenderer.ClearList(this.parent)
		// this.ClearItem()
		// if (this.mTrans) {
		// 	SetLocalPosition(this.mTrans, 0, 0, 0)
		// }
		// this.mTrans = null  //当前挂载这个组件的物体
		// this.mPanel = null // scrowView 物体
		// this.mScroll = null // scrowView 组件
		// this.use_select = null
		// this.select_index = null
		// this.select_func = null
		// this.value_changed_callback = null
		
	}

	public ClearItem() {

		// if (this.item_list) {
		// 	for (let _ in this.item_list) {
		// 		var item = this.item_list[_]
		// 		item.DeleteMe()
		// 		item = null
		// 	}
		// 	this.item_list = []
		// }
		// this.item_num = 0
	}

	public SetClickSound(click_sound?) {

		// this.sound_effect = click_sound
	}

	public ResetScrowViewPanel() {
		if (!this.parent) {
			return
		}
		if (this.delay_reset_timer) {
			clearTimeout(this.delay_reset_timer)
			this.delay_reset_timer = undefined
		}
		this.delay_reset_timer = setTimeout(() => {
			this.parent.scrollBar.value = 0
		}, 40)
	}

	//索引为index的item显示在第一个
	public FirstOnChild(index) {
		if (this.parent) {
			if (this.delay_first_timer) {
				clearTimeout(this.delay_first_timer)
				this.delay_first_timer = undefined
			}
			this.delay_first_timer = setTimeout(() => {
				if (this.parent.cells.length != 0) {
					let cell = this.parent.cells[0]
					let cellWidth = cell.width + this.parent.spaceX;
					let cellHeight = cell.height + this.parent.spaceY;
					let cellSize = this.scroll_con == LoopScrCon.Horizontal ? cellWidth : cellHeight
					let move_value = index * cellSize
					move_value = Mathf.Clamp(move_value, 0.01, this.data_list.length * cellSize)
					index = Mathf.Clamp(index, 0, this.data_list.length)
					this.parent.startIndex = index
					this.parent.scrollBar.value = move_value
				}
			}, 40)
		}
	}

	//索引为index的item显示在最后一个
	public LastOnChild(index) {
		if (this.parent) {
			if (this.delay_last_timer) {
				clearTimeout(this.delay_last_timer)
				this.delay_last_timer = undefined
			}
			this.delay_last_timer = setTimeout(() => {
				if (this.parent.cells.length != 0) {
					let cell = this.parent.cells[0]
					let cellWidth = cell.width + this.parent.spaceX;
					let cellHeight = cell.height + this.parent.spaceY;
					let cellSize = this.scroll_con == LoopScrCon.Horizontal ? cellWidth : cellHeight
					let repeat_value = this.scroll_con == LoopScrCon.Horizontal ? this.parent.repeatX : this.parent.repeatY
					index = index + 1 - repeat_value
					index = Mathf.Clamp(index, 0, this.data_list.length)
					let move_value = index * cellSize
					// 最小值为0会不显示
					this.parent.startIndex = index
					this.parent.scrollBar.value = move_value
				}
			}, 40)
		}
	}

	//将第index个物体移动到scroll中间
	public CenterOnChild(index) {
		// if (this.scroll_con) {
		// 	if (this.move_timer) {
		// 		egret.clearTimeout(this.move_timer)
		// 		this.move_timer = undefined
		// 	}
		// 	this.move_timer = egret.setTimeout(() => {
		// 		if (this.scroll_con.scrollPolicyV != eui.ScrollPolicy.OFF) {
		// 			let contentheight = this.scroll_con.viewport.contentHeight
		// 			let height = this.scroll_con.height
		// 			let item_height = contentheight / this.data_list.length * index
		// 			let move_x = 0
		// 			if (item_height > height / 2 && item_height < (contentheight - height / 2)) {
		// 				move_x = item_height - height / 2
		// 			}
		// 			else if (item_height <= height / 2) {
		// 				move_x = 0
		// 			}
		// 			else if (item_height > (contentheight - height / 2)) {
		// 				move_x = contentheight - height
		// 			}
		// 			this.scroll_con.viewport.scrollV = move_x
		// 			this.parent.validateNow()
		// 		} else if (this.scroll_con.scrollPolicyH != eui.ScrollPolicy.OFF) {
		// 			let contentwidth = this.scroll_con.viewport.contentWidth
		// 			let width = this.scroll_con.width
		// 			let item_width = contentwidth / this.data_list.length * index
		// 			let move_y = 0
		// 			if (item_width > width / 2 && item_width < (contentwidth - width / 2)) {
		// 				move_y = item_width - width / 2
		// 			}
		// 			else if (item_width <= width / 2) {
		// 				move_y = 0
		// 			}
		// 			else if (item_width > (contentwidth - width / 2)) {
		// 				move_y = contentwidth - width
		// 			}
		// 			this.scroll_con.viewport.scrollH = move_y
		// 			this.parent.validateNow()
		// 		}
		// 	}, this, 40)
		// }
	}
}
window["LoopScrowViewMgr"] = LoopScrowViewMgr