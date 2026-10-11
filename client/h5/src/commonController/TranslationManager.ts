import { EventName } from "../common/EventName"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GetQualifiedClassName, SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY, SetHtmlStyle, SetSizeDelta, SetSizeDeltaX, Util } from "../util/Util"

export class TranslationManager extends EventDispatcher {
	static Instance: TranslationManager
	static GetInstance() {

		if (!TranslationManager.Instance) {
			new TranslationManager()
		}
		return TranslationManager.Instance
	}

	public constructor() {
		super()
		if (TranslationManager.Instance) {
			return
		}
		TranslationManager.Instance = this

		this.InitEvent()
	}

	public InitEvent() {
		GlobalEventSystem.Bind(EventName.GAME_START, () => {
		})
	}

	public UpdateViewComponent(self){
		if(!PlatformManager.IsEyouPlatform() || !self) return
		let class_name = GetQualifiedClassName(self)
		if(this[class_name]){
			this[class_name](self)
		}
	}

	/**
	 * 快速让lable水平、垂直居中 并换行等
	 * @param comp  lable
	 * @param x  
	 * @param y  
	 * @param width  外框宽度
	 * @param height 外框高度
	 * @param font_size 字体大小
	 * @param align center/left/right
	 * @param obj   一些其他的属性
	 */
	public HelpLableCenter(comp: Laya.Label, x, y, width, height, font_size?,align="center",obj = null) {
		if (!comp) return
		comp.centerX = NaN
		comp.centerY = NaN
		comp.right = NaN
		comp.left = NaN
		comp.top = NaN
		comp.bottom = NaN

		comp.width = width
		comp.height = height
		comp.wordWrap = true
		comp.leading = 0.1
		comp.align = align
		comp.valign = !obj?"middle":obj.valign
		comp.x = x
		comp.y = y
		if (font_size) {
			comp.fontSize = font_size
		}
	}

	/**
	 * 帮助N个组件水平排列
	 * @param list      需要排列的组件（需要在同一个父节点下）
	 * @param parent_   父节点
	 * @param space_x   间隔
	 * @param cell_w    如果大小一致 赋值会快一点
	 * @param is_hide   过滤visible
	 * @param align     水平居中样式
	 * @param off    only support "left" and "center" current
	 */
	public HelptoHriLayout(list, parent_, space_x = 0, cell_w = null, is_hide = true, align = "center", off_x = 0) {

		//***目前还没支持子元素缩放后的宽度

		let parent_width = parent_.width
		let i = 0
		let box_childs_len = list.length
		let cont_w = 0
		switch (align) {
			case "center":
				let num = 0
				i = 0
				let all_w = 0
				let cell: any
				for (i = 0; i < box_childs_len; i++) {
					cell = list[i]
					if (cell) {
						if (is_hide && !cell.visible) continue
						num++
						all_w += cell_w ? cell_w : (cell.contextWidth ? cell.contextWidth : cell.width)
					}
				}

				all_w += space_x * (num - 1)
				let centerX = (parent_width - all_w) / 2 + off_x
				let cur_x = centerX
				for (i = 0; i < box_childs_len; i++) {
					cell = list[i]
					if (cell) {
						if (is_hide && !cell.visible) continue
						let w = cell_w ? cell_w : (cell.contextWidth ? cell.contextWidth : cell.width)
						let acX = cell.anchorX ? cell.anchorX : 0
						cell.x = cur_x + (w * acX)
						cur_x += w + space_x
}
				}
				break
			case "left":
				cont_w = 0 + off_x
				for (i = 0; i < box_childs_len; i++) {
					let cell: any = list[i]
					if (cell) {
						if (is_hide && !cell.visible) continue
						let wid = 0
						if (cell_w) {
							wid = cell_w
						} else {
							wid = cell.contextWidth ? cell.contextWidth : cell.width
						}
						cell.x = cont_w
						cont_w += (space_x + wid)
					}
				}
				break
			case "right":
				cont_w = 0
				i = 0
				cont_w = Math.ceil(parent_width)
				for (i = box_childs_len - 1; i >= 0; i--) {
					let cell: any = list[i]
					if (cell) {
						if (is_hide && !cell.visible) continue
						let wid = 0
						if (cell_w) {
							wid = cell_w
						} else {
							wid = cell.contextWidth ? cell.contextWidth : cell.width
						}
						let cell_gap = i == (box_childs_len - 1) ? 0 : space_x
						let rx = cont_w - (cell_gap + wid)
						cell.x = rx
						cont_w = rx
					}
				}
				break
		}
	}
	/**
	 * 
	 * @param index 
	 * @param paren_ 
	 * @param type 1 =Labal
	 */
	private HelptoGetChildren(paren_, index, type = "lb") {
		switch (type) {
			case "lb":
				let lb1 = paren_.getChildAt(index)
				return lb1
			case "hb":
				let hbox= paren_.getChildAt(index)
				return hbox
			case "box":
				let box = paren_.getChildAt(index)
				return box
		}
	}
}
window["TranslationManager"] = TranslationManager
