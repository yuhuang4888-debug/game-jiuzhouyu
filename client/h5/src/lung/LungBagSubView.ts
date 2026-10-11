import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungEvent, LungModel } from "../commonModel/LungModel";
import { DungeonEnterView } from "../dungeon/DungeonEnterView";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { LungBagItem } from "./LungBagItem";
import { LungRadionButton } from "./LungRadionButton";

export const LungSubBagTab = [
	{ "index": 1, "name": "全部" },
	{ "index": 2, "name": "神纹" },
	{ "index": 3, "name": "神纹碎片" },
]
window["LungSubBagTab"] = LungSubBagTab
export class LungBagSubView extends BaseItem1 {
	LoadSuccess
	InitEvents
	SetData
	InitTab
	SelectRadioBtn
	SwtichView
	ShowResolveDot
	radio_loop_mgr: LoopScrowViewMgr
	goods_loop_mgr: LoopScrowViewMgr
	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungBagSubView"
		let model = LungModel.GetInstance(),
			goods_model = GoodsModel.GetInstance(),
			local_LungEvent = LungEvent,
			local_Util = Util,
			data_,
			needRefresh_,
			cur_index_ = -1
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
			// this._radioGroup.removeEventListener(eui.UIEvent.CHANGE, this.SelectRadioBtn, this)
			cur_index_ = -1
			// array_collection_ = null
			if (this.radio_loop_mgr) {
				this.radio_loop_mgr.DeleteMe()
				this.radio_loop_mgr = null
			}
			if (this.goods_loop_mgr) {
				this.goods_loop_mgr.DeleteMe()
				this.goods_loop_mgr = null
			}
			super.DeleteMe()

		}
		this.LoadSuccess = () => {
			ResManager.GetInstance().SetImageSpriteTrans(this, this.line1, GameResPath.GetIcon("common2", "uity_017"))
		}

		this.InitEvents = () => {
			let resolve_fun = () => {
				if (!goods_model.lungbag_goods_list || goods_model.lungbag_goods_list.length <= 0) {
					Message.show("暂无物品可以分解")
				} else {
					model.Fire(local_LungEvent.LUNG_OPEN_VIEW, "LungResolveView")
				}
			}
			local_Util.AddClickEvent(this.resolveBtn, resolve_fun, this, true)

			let getBtn_fun = () => {
				//Message.show("敬请期待")
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.Dragon)
				model.Fire(local_LungEvent.LUNG_CLOSE_VIEW, "LungBagView")
			}
			local_Util.AddClickEvent(this.getBtn, getBtn_fun, this, true)

			this.BindEvent(goods_model, GoodsModel.CHANGE_LUNG_BAG_LIST, () => {
				if (this.use_delete_method) return
				if (cur_index_ != undefined) {
					this.SwtichView(cur_index_, true)
				}
			})


			this.InitTab()
			if (needRefresh_) {
				this.SetData(data_)
				needRefresh_ = null
			}
		}

		this.SetData = (data) => {
			if (this.is_loaded) {
				data_ = data

			} else {
				needRefresh_ = true
			}
		}

		this.InitTab = () => {
			// this._radioGroup = new eui.RadioButtonGroup();
			// this._radioGroup.addEventListener(eui.UIEvent.CHANGE, this.SelectRadioBtn, this)
			// for (let i = 0; i < this.btn_group.numChildren; i++) {
			// 	let data = LungSubBagTab[i]
			// 	let btn = this.btn_group.getChildAt(i) as eui.RadioButton
			// 	btn.group = this._radioGroup
			// 	btn.label = data ? data.name : ""
			// 	btn.value = data ? data.index : i
			// }
			// this._radioGroup.selectedValue = cur_index_

			if (!this.radio_loop_mgr) {
				this.radio_loop_mgr = new LoopScrowViewMgr()
				this.radio_loop_mgr.SetData(this.btn_group, LungRadionButton, LungSubBagTab, LoopScrCon.Horizontal, 1, () => {
					let index = this.btn_group.selectedIndex
					this.SwtichView(index)
				})
			} else {
				this.radio_loop_mgr.replaceAll(LungSubBagTab)
			}
			// this.radio_loop_mgr.SetSelectIndex(cur_index_)


			// this.SwtichView(cur_index_, true)
		}

		// this.SelectRadioBtn = (e: eui.UIEvent) => {
		// 	let radioGroup: eui.RadioButtonGroup = e.target
		// 	let index = Number(radioGroup.selectedValue)

		// 	this.SwtichView(index)
		// }

		this.SwtichView = (index, force?) => {
			if (cur_index_ == index && !force) {
				return
			}
			cur_index_ = index
			let bag_goods = model.GetLungBagListByIndex(Number(index))
			if (!this.goods_loop_mgr) {
				this.goods_loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.goods_loop_mgr.SetData(this.scroll_group, LungBagItem, bag_goods, LoopScrCon.Vertical, 1)
			} else {
				this.goods_loop_mgr.replaceAll(bag_goods)
			}



			this.none_conta.visible = bag_goods.length <= 0

			// if (cur_index_ == index && !force) {
			// 	return
			// }
			// cur_index_ = index

			// let bag_goods = model.GetLungBagListByIndex(Number(index))

			// if (!array_collection_) {
			// 	array_collection_ = new eui.ArrayCollection()
			// 	array_collection_.source = bag_goods
			// 	this.scroll_group.dataProvider = array_collection_
			// 	this.scroll_group.itemRenderer = LungBagItem
			// } else {
			// 	// array_collection_.replaceAll(bag_goods)
			// 	array_collection_.source = bag_goods
			// 	array_collection_.refresh()
			// }
			// this.none_conta.visible = bag_goods.length <= 0
		}

		this.ShowResolveDot = () => {
			// let show = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT, LungDotSubType.StoneExchenge)
			// this.resolve_dot.visible = show
		}
	}



	
	img: Laya.Image
	line1: Laya.Image
	scroll_group: Laya.List
	resolveBtn: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	resolve_dot: Laya.Image
	btn_group: Laya.List
	none_conta: Laya.Box
	tips: Laya.Label
	tips_icon: Laya.Image
	getBtn: Laya.Box
	_Image2: Laya.Image
	_Label2: Laya.Label
	public GetComponents() {
		[
			this.img,
			this.line1,
			this.scroll_group,
			this.resolveBtn,
			this._Image1,
			this._Label1,
			this.resolve_dot,
			this.btn_group,
			this.none_conta,
			this.tips,
			this.tips_icon,
			this.getBtn,
			this._Image2,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"img",
				"line1",
				"scroll_group",
				"resolveBtn",
				"_Image1",
				"_Label1",
				"resolve_dot",
				"btn_group",
				"none_conta",
				"tips",
				"tips_icon",
				"getBtn",
				"_Image2",
				"_Label2",
			])
	}
}
window["LungBagSubView"] = LungBagSubView