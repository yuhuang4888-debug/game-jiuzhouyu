import { attributePotionModel } from "../commonModel/attributePotionModel"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { Util } from "../util/Util"
import { attributePotionItem } from "./attributePotionItem"
import { attributePotionTab } from "./attributePotionTab"

export class attributePotionView extends BaseView1 {
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	item_loop_mgr
	open_callback
	remove
	setDefaultTab
	show_open_movie
	tab_loop_mgr
	updateItem
	updateTab
	use_background
	_select_tab
	_ty
	beginY
	InitEvent
	ClickFun
	public constructor() {
		super()


		this._select_tab = 1;
		this.base_file = "attributePotion"
		this.layout_file = "attributePotionView"
		this.show_open_movie = true
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		let _model = attributePotionModel.GetInstance()
		this.destroy_imm = true
		this.load_callback = () => {
			this.InitEvent()
			this.Content.on(Laya.Event.MOUSE_DOWN, this, this.OnMouseDown);
		}



		this.open_callback = () => {
			// let mask = this.getChil("_Scroller1/_item_list").GetComponent("Image") 
			// this.RegisterMask(mask)
			this.BindEvent(_model, attributePotionModel.CHANGE_ITEM, (attrlv?) => {
				let itemList = _model.getItemList(attrlv)
				if (!this.item_loop_mgr) {
					this.item_loop_mgr = new LoopScrowViewMgr(this.layer_value)
					this.item_loop_mgr.SetData(this.Content, attributePotionItem, itemList, LoopScrCon.Vertical, 1)
				} else {
					this.item_loop_mgr.replaceAll(itemList)
				}
			})
			this.updateTab()
			// ResManager.GetInstance().SetOutsideImageSprite(this,this._Image1,"../../resource/game/common/texture/uity_080.png");

		}

		this.close_callback = () => {
			this.remove()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			this.BindEvent(_model, attributePotionModel.TIME_DATA_RETURN, () => {
				let { flag, index } = _model.canUseTab()
				if (flag) {
					this._select_tab = index
					if (this.tab_loop_mgr) {
						this.tab_loop_mgr.SetSelectIndex(this._select_tab - 1)
					}
				}
				this.updateTab()
			}
			)
		}

		this.setDefaultTab = (index?) => {
			this._select_tab = index
		}

		this.updateTab = () => {
			let data = _model.getTimeData(this._select_tab)
			let selectTabIndex = this._select_tab
			if (!data) {
				return
			}
			let tabList = _model.tabList

			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this.Content1, attributePotionTab, tabList, null, 1, this.ClickFun)
				// this.tab_loop_mgr.SetSelectIndex(this._select_tab)
				this._select_tab = selectTabIndex
				this.Content1.selectedIndex = this._select_tab - 1

				// this.tab_loop_mgr.soureArr.refresh()
			} else {
				this._select_tab = selectTabIndex
				this.Content1.selectedIndex = this._select_tab - 1
				this.tab_loop_mgr.replaceAll(tabList)
			}
			this.updateItem()
		}

		this.ClickFun = (e) => {
			this._select_tab = e + 1
			// this.tab_loop_mgr.soureArr.refresh()
			this.Content1.selectedIndex = e
			// this._select_tab = this.tab_loop_mgr.select_index

			let data = _model.getTimeData(this._select_tab)
			if (data) {
				console.log("click fun: " + this._select_tab);
				this.updateItem()
			}
		}

		this.updateItem = () => {
			let itemList = _model.getItemList(this._select_tab)
			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.item_loop_mgr.SetData(this.Content, attributePotionItem, itemList, LoopScrCon.Vertical, 1)
			} else {
				this.item_loop_mgr.replaceAll(itemList)
			}
		}

		this.remove = () => {
			_model.Setview_Open(false)
			this._select_tab = 1
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = null
			}
		}


	}

	public OnMouseDown() {
		Laya.Tween.clearAll(this.Content)
		this.beginY = this.Content.y
		this._ty = Laya.stage.mouseY;
		Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
		Laya.stage.once(Laya.Event.MOUSE_UP, this, this.mouseUp);
		Laya.stage.once(Laya.Event.MOUSE_OUT, this, this.mouseUp);
		// this.value_text.text=this.value.toString()
	}

	private mouseMove(e: Event): void {
		let stage = Laya.stage;
		this.Content.y += (stage.mouseY - this._ty) / 3
		this._ty = stage.mouseY;
	}


	private mouseUp(e: Event): void {
		Laya.Tween.to(this.Content, { y: 0 }, 1000, Laya.Ease.circOut, Laya.Handler.create(this, () => {
		}))
		let stage = Laya.stage;
		stage.off(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
		stage.off(Laya.Event.MOUSE_UP, this, this.mouseUp);
		stage.off(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	}


_Image1:Laya.Image
_Image2:Laya.Image
_btn_close:Laya.Box
_Image11:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.List
Content1:Laya.List
_Image3:Laya.Image
public GetComponents() {
[
this._Image1,
this._Image2,
this._btn_close,
this._Image11,
this._Scroller1,
this.Content,
this.Content1,
this._Image3,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"_btn_close",
"_Image11",
"_Scroller1",
"Content",
"Content1",
"_Image3",
])
}
}
 window["attributePotionView"]= attributePotionView