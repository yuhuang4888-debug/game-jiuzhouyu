import { BaseItem1 } from "../common/BaseItem1"
import { Util, GetSizeDeltaY, SetSizeDeltaY } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { GodBefallModel, GodBefallEvent, GodBefallRedList } from "../commonModel/GodBefallModel"
import { GodBefallTabSubBtn } from "./GodBefallTabSubBtn"

export class GodBefallTabBtn extends BaseItem1 {
	public Height = 64
	public Width = 196
	public static width = 196

	call_back
	force_cache
	//height
	icon
	index = 0
	index_cache = -1
	needRefresh
	on_click_func
	parent

	red_state
	refresh_red
	show

	sub_index_cache
	sub_tab_item_list = []
	sub_tab_list
	create_item = false

	OutlineColor = {
		3: "#903ee2",
		4: "#c95b37",
		5: "#d04040",
		6: "#cc4199"
	}

	public constructor(parent?, on_click_func?) {
		super(parent)
		this.base_file = "godBefall"
		this.layout_file = "GodBefallTabBtn"
		this.is_delay_callback = false

		this.parent = parent
		this.needRefresh = false
		this.index = 0
		this.show = false
		this.on_click_func = on_click_func

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
			this.CheckAllRedStatus()
		}
	}

	public DeleteMe() {
		if (this.sub_tab_item_list) {
			for (let _tmpi in this.sub_tab_item_list) {
				let item = this.sub_tab_item_list[_tmpi]
				item.DeleteMe()
			}
			this.sub_tab_item_list = null
		}
		this.on_click_func = null
		this.parent = null
		super.DeleteMe()
	}

	public LoadSuccess() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this.tab_txt.fontSize = 20
		}
		this.sub_tab_item_list = []
		if (this.refresh_red) {
			this.SetRedDot(this.red_state)
		}
	}

	public InitEvents() {
		Util.AddClickEvent(this.tab, () => {
			if (this.on_click_func) {
				this.on_click_func()
			}
		}, this, true)

		let select_fun = (parent_idnex?, sub_index?, parent?) => {
			if (this.index == parent_idnex) {
				this.SetSelectSubIndex(parent_idnex, sub_index)
			} else {
				this.SetSelectSubIndex(999, 999)
			}
		}
		this.BindEvent(GlobalEventSystem, EventName.SUB_TAB_BTN_BE_SELECTED, select_fun)

		this.BindEvent(GodBefallModel.GetInstance(), GodBefallEvent.UPDATE_GOD_VO, (id?) => {
			this.CheckAllRedStatus()
		})

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_GOD_LIST, () => {
			this.CheckAllRedStatus()
		})

		this.BindEvent(GodBefallModel.GetInstance(), GodBefallEvent.UPDATE_GOODS_RED, () => {
			this.CheckAllRedStatus()
		})

		if (this.needRefresh) {
			this.SetTabData(this.sub_tab_list, this.index, this.call_back)
		}
	}

	public SetTabData(list?, index?, call_back?, icon?) {
		this.sub_tab_list = list
		this.index = index
		this.call_back = call_back
		this.icon = icon

		if (this.is_loaded) {
			if (this.sub_tab_list) {
				this.tab_txt.text = Util.StrToHTML(this.sub_tab_list[0])
				let data = this.sub_tab_list[2]
				ResManager.GetInstance().SetImageSprite(this, this.btn_img, "godBefall", "ui_shape_btn_" + data.key)
				//this.tab_txt.strokeColor = color
				//this._img_icon.source = "common_asset.gbl_" + data.color + ""
				//ResManager.GetInstance().SetImageSprite(this, this._img_icon, "common_asset", "gbl_" + data.color)
				if (this.OutlineColor[data.color]) {
					this.tab_txt.strokeColor = this.OutlineColor[data.color]
				}

				if (this.show || (this.index_cache != undefined && this.index_cache == this.index)) {
					this.CreateItem()
				} else {
					this.index_cache = -1
				}
				this.CheckAllRedStatus()
			}
		} else {
			this.needRefresh = true
		}
	}

	public CreateItem() {
		if (this.create_item) {
			return
		}
		this.create_item = true

		//let red = false
		let item = null
		let i = 0
		do {
			item = this.sub_tab_item_list[i]
			if (!item) {
				item = new GodBefallTabSubBtn(this.subCon)
				this.sub_tab_item_list[i] = item
				item.Load()
			}
			let id = this.sub_tab_list[1][i]
			item.SetSubData(id, this.index, i, this.call_back)
			/*
			let onBtnClickHandler = () => {
				//LuaSoundManager:GetInstance():PlayEffect(this, "2_dianji")
				GlobalEventSystem.Fire(EventName.SUB_TAB_BTN_BE_SELECTED, this.index, i, this.parent)
			}

			//item:ExcuteCallback(
			//() => {
			//        Util.AddClickEvent(item.objsub_conta, onBtnClickHandler, this)
			//    }
			//)
			*/
			i = i + 1
		} while ((i < this.sub_tab_list[1].length))
		
		this.RefreshSize()
		if (this.index_cache > -1) {
			this.SetSelectMode(this.index_cache, this.sub_index_cache, this.force_cache)
			this.index_cache = -1
		}
	}

	public RefreshSize() {
		if (this.show) {
			let height = this.sub_tab_item_list.length * GodBefallTabSubBtn.Height + this.subCon.y
			this.display_obj.height = height
		} else {
			this.display_obj.height = this.tab.height
		}
		GlobalEventSystem.Fire(EventName.TAB_BAR_REFRESH)
	}

	public SetSelectMode(index?, sub_index?, force_show?) {
		if (this.is_loaded) {
			if (this.index == index) {
				this.show = !this.show
			} else {
				this.show = false
			}
			if (force_show && this.index == index) {
				this.show = true
			}
			if (this.show && index != null) {
				this.CreateItem()
				this.ShowSubBtnVisible(true)
				if (sub_index != null) {
					this.SetSelectSubIndex(index, sub_index)
				}
			} else {
				this.ShowSubBtnVisible(false)
			}
			this.RefreshSize()
		} else {
			this.index_cache = index
			this.sub_index_cache = sub_index
			this.force_cache = force_show
		}
	}

	public ShowSubBtnVisible(show?) {
		if ((this.subCon && this.sub_tab_item_list) && this.sub_tab_item_list.length != 0) {
			this.subCon.visible = show
		}
	}

	public SetSelectSubIndex(index?, sub_index?) {
		for (let _tmpi in this.sub_tab_item_list) {
			let item = this.sub_tab_item_list[_tmpi]
			if (item.parent_index == index && item.sub_index == sub_index) {
				item.SetSelected(true)
			} else {
				item.SetSelected(false)
			}
		}
	}

	public SetRedDot(bool?) {
		this.red_state = bool
		if (this.is_loaded) {
			this.refresh_red = false
			if (bool) {
				this.red_dot.visible = true
			} else {
				this.red_dot.visible = false
			}
		} else {
			this.refresh_red = true
		}
	}

	public CheckAllRedStatus() {
		if (!this.sub_tab_list) {
			return
		}
		let item = null
		let mark = false
		let i = 0
		do {
			let id = this.sub_tab_list[1][i]
			let red = this.GetGodRedDot(id)
			if (!mark) {
				mark = red
			}

			item = this.sub_tab_item_list[i]
			if (item) {
				item.SetRedDot(red)
			}
			i = i + 1
		} while ((i < this.sub_tab_list[1].length)
		)
		this.SetRedDot(mark)
	}

	public GetGodRedDot(id?) {
		let red = RedDotManager.GetInstance().CheckAnyRedStatusMultModule(GodBefallRedList, id)
		if (!red) {
			red = GodBefallModel.GetInstance().GetGodSepcRedStatusAll(id)
		}
		return red
	}

	conta: Laya.Box
	tab: Laya.Box
	btn_img: Laya.Image
	tab_txt: Laya.Label
	arrow: Laya.Image
	_img_icon: Laya.Image
	subCon: Laya.VBox
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.conta,
			this.tab,
			this.btn_img,
			this.tab_txt,
			this.arrow,
			this._img_icon,
			this.subCon,
			this.red_dot,
		]
			= this.GetChildrenByNames([
				"conta",
				"tab",
				"btn_img",
				"tab_txt",
				"arrow",
				"_img_icon",
				"subCon",
				"red_dot",
			])
	}
}
window["GodBefallTabBtn"] = GodBefallTabBtn