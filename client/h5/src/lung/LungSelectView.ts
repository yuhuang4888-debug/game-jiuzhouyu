import { BaseView1 } from "../common/BaseView1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungEvent, LungModel } from "../commonModel/LungModel";
import { DungeonEnterView } from "../dungeon/DungeonEnterView";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { LungSelectItem } from "./LungSelectItem";


export class LungSelectView extends BaseView1 {

	LoadSuccess
	InitEvent
	OpenCallback
	SetBagItemList
	FormatBagList
	SortFun
	Local_Open
	bag_loop_mgr:LoopScrowViewMgr
	public constructor() {
		super();
		this.base_file = "lung";
		this.layout_file = "LungSelectView";
		this.layer_value = Enum_UILayer.Activity;
		this.destroy_imm = true;
		this.is_center = true
		this.use_background = true;
		this.click_bg_toClose = true;
		this.show_open_movie = true;
		let model = LungModel.GetInstance(),
			local_Util = Util,
			_type_: number = 1,			//1代表镶嵌， 2 代表替换
			pos_id_: number = 1,
			item_list_
		// array_collection_: eui.ArrayCollection
		this.load_callback = function () {
			this.LoadSuccess();
			this.InitEvent();
		}
		this.open_callback = function () {
			this.OpenCallback();
		}
		this.destroy_callback = function () {
			for (let item of item_list_) {
				item.DeleteMe()
			}
			item_list_ = null
			// array_collection_ = null
			if (this.bag_loop_mgr){
				this.bag_loop_mgr.DeleteMe()
				this.bag_loop_mgr = null
			}
		}

		this.preload_server_config = {
			"config_dragon_pos": false
		}

		this.LoadSuccess = () => {
			this.scroll_group.scrollBar.visible = false
			item_list_ = []
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("lung", "uisy_023"))
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			local_Util.AddClickEvent(this.closeBtn, close_fun, this, true)

			let getBtn_fun = () => {
				//Message.show("敬请期待")
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.Dragon)
				model.Fire(LungEvent.LUNG_CLOSE_VIEW, "LungSelectView")
			}
			local_Util.AddClickEvent(this.getBtn, getBtn_fun, this, true)
		}

		this.Local_Open = (parms) => {
			[_type_, pos_id_] = parms
			super.Open()
		}

		this.OpenCallback = () => {
			this.SetBagItemList(GoodsModel.GetInstance().lungbag_goods_list)
		}

		this.SetBagItemList = (lung_goods_list: Array<any>) => {
			let bag_list = []
			bag_list = this.FormatBagList(lung_goods_list, _type_, pos_id_)
			let len = Util.TableSize(bag_list, true)
			console.warn("len-----:", len)
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this.scroll_group, LungSelectItem, bag_list, LoopScrCon.Vertical, undefined)
			} else {
				this.bag_loop_mgr.replaceAll(bag_list)
			}


			// if (!array_collection_) {
			// 	array_collection_ = new eui.ArrayCollection()
			// 	array_collection_.source = bag_list
			// 	this.scroll_group.dataProvider = array_collection_
			// 	this.scroll_group.itemRenderer = LungSelectItem
			// } else {
			// 	array_collection_.replaceAll(bag_list)
			// }

			this.none_conta.visible = bag_list.length <= 0
		}

		//背包
		this.FormatBagList = (list: Array<any>, _type: number, pos_id: number) => {
			let new_list = []
			let is_fit = false
			let basic
			let is_exclude
			let is_include
			let dragon_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dragon_pos", false)
			// let dragon_pos = model.GetPosCfg()
			if (list) {
				for (let obj of list) {
					if (obj.type == LungModel.LungGoodsType) {
						let item_data
						item_data = {}
						is_fit = false
						item_data.goods_vo = obj
						item_data.type = _type
						item_data.pos_id = pos_id_
						item_data.wear_state = model.GetInstertState(pos_id, obj.subtype, obj.type_id, _type, dragon_pos)
						new_list.push(item_data)
					}
				}
			}
			this.SortFun(new_list)
			return new_list
		}

		this.SortFun = (list: Array<any>) => {
			if (list) {
				let sort_fun = (a, b) => {
					if (a.wear_state == b.wear_state) {
						if (a.goods_vo && b.goods_vo) {
							if (a.goods_vo.color == b.goods_vo.color) {
								if (a.goods_vo.subtype == b.goods_vo.subtype) {
									return b.goods_vo.level - a.goods_vo.level
								} else {
									return b.goods_vo.subtype - a.goods_vo.subtype
								}
							} else {
								return b.goods_vo.color - a.goods_vo.color
							}
						} else {
							return 1
						}
					} else {
						return a.wear_state - b.wear_state
					}
				}
				list.sort(sort_fun)
			}
		}
	}

	public Open(...parms) {
		this.Local_Open(parms)
	}
	
	_Image1: Laya.Image
	_Image2: Laya.Image
	closeBtn: Laya.Image
	_Image3: Laya.Image
	title: Laya.Image
	_Scroller1: Laya.Panel
	scroll_group: Laya.List
	none_conta: Laya.Box
	_Label1: Laya.Label
	_Image4: Laya.Image
	getBtn: Laya.Box
	_Image5: Laya.Image
	_Label2: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.closeBtn,
			this._Image3,
			this.title,
			this._Scroller1,
			this.scroll_group,
			this.none_conta,
			this._Label1,
			this._Image4,
			this.getBtn,
			this._Image5,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"closeBtn",
				"_Image3",
				"title",
				"_Scroller1",
				"scroll_group",
				"none_conta",
				"_Label1",
				"_Image4",
				"getBtn",
				"_Image5",
				"_Label2",
			])
	}
}

window["LungSelectView"] = LungSelectView