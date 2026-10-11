import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { Status } from "../util/Status"
import { ColorUtil } from "../util/ColorUtil"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { ComGoodsResloveItem } from "./ComGoodsResloveItem"
import { ComGoodsResloveBagItem } from "./ComGoodsResloveBagItem"
import { ResManager } from "../common/ResManager"

export class ComGoodsResloveView extends BaseItem1 {
	ClearItemData
	Content
	Content1
	EmpresolveBtn
	InitDefaultView
	InitEvents
	LoadSuccess
	LocalDeleteMe
	Scrget_scroll
	Scritem_scroll
	SetData
	SetResolveView
	ShowBagView
	arrayCollection
	bg2
	have_set
	item_list
	last_click_time
	model
	source_item

	public constructor(parent?) {
		super(parent)
		this.have_set = false
		this.item_list = []
		this.base_file = "composite"
		this.layout_file = "ComGoodsResloveView"
		this.layer_value = Enum_UILayer.UI

		this.model = CompositeModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel

		this.load_callback = () => {
			//this.RegisterMask(this.item_group)
			this.LoadSuccess()
			this.InitEvents()
			/*
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.tips_text.size = 16
				this.empty_text.size = 18
			}
			*/
		}

		this.LocalDeleteMe = () => {
			this.model.comGoodsSelectId = null
			if (this.item_list) {
				for (let _tmpi in this.item_list) {
					let item = this.item_list[_tmpi]
					item.DeleteMe()
					item = null
				}
				this.item_list = []
			}
			if (this.arrayCollection) {
				this.arrayCollection.DeleteMe()
				this.arrayCollection = null
			}
			if (this.source_item) {
				this.source_item.DeleteMe()
				this.source_item = null
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image6, "resource/game/composite/other/ui_merge_15.png")
			this.item_scroll.scrollBar.visible = false
			this.get_scroll.hScrollBar.visible = false

			this.tips_text.width = 300
			this.tips_text.style.fontSize = 20
			this.tips_text.style.color = "#ffffff"
			this.tips_text.style.wordWrap = true
			let str = "只有空闲宝石才可以拆解！<br/>拆解后<font color='#0a953e'>100%返还</font>其合成材料"
			this.tips_text.innerHTML = Util.StrToHTML(str)

			this.empty_text.text = "当前没有可以进行拆解的宝石呢~"

			this.InitDefaultView()
		}

		this.InitEvents = () => {
			let select_fun = (goods_id?, data?) => {
				this.SetResolveView(data)
			}
			this.BindEvent(this.model, CompositeEvent.SELECT_EQUIP_RESOLVE_ITEM, select_fun)

			let resolve_fun = () => {
				let goods_vo = null
				if (this.model.comGoodsSelectId) {
					goods_vo = goods_model.GetGoodsVoByGoodsId(this.model.comGoodsSelectId)
				}
				if (goods_vo) {
					if (!this.last_click_time || Status.NowTime - this.last_click_time >= 0.5) {
						let ok_fun = () => {
							let goods_list = []
							let vo = { goods_id: this.model.comGoodsSelectId, goods_num: 1 }
							table.insert(goods_list, vo)
							goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, goods_list)
						}

						let str = ""
						if (goods_vo) {
							str = "是否确定拆解<font color=" + ColorUtil.GetColorDark(goods_vo.color) + ">" + goods_vo.goods_name + "</font>?<br/>拆解可100%返还其合成材料"
						}
						Alert.Show(str, Alert_Type.Two, ok_fun, null, "确定拆解", "我再想想")
						this.last_click_time = Status.NowTime
					}
				} else {
					Message.show("没有选中拆解物品")
				}
			}

			Util.AddClickEvent(this.resolveBtn, resolve_fun, this, true)
			let success_fun = (vo?) => {
				if (vo && vo.code == 1) {
					this.model.comGoodsSelectId = null
					this.ClearItemData()
					if (vo.reward_list) {
						let list = []
						for (let _tmpi in vo.reward_list) {
							let tmp = vo.reward_list[_tmpi]
							let goods_vo = goods_model.GetGoodsVoByGoodsId(tmp.goods_id)
							if (goods_vo) {
								let obj = []
								if (goods_vo.type == 10) {
									obj = [0, goods_vo.type_id, tmp.goods_num, tmp.goods_id]
								} else {
									obj = [0, goods_vo.type_id, tmp.goods_num]
								}
								table.insert(list, obj)
							}
						}
						if (list.length > 0) {
							let success_view = new CongratulationObtainView(list, 10)
							success_view.Open()
						}
					}
				}
			}

			this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, success_fun)
			let refresh = () => {
				if (this.use_delete_method) {
					return
				}
				this.SetData()
				if (this.model.comGoodsSelectId) {
					let data = goods_model.GetGoodsVoByGoodsId(this.model.comGoodsSelectId)
					if (!data) {
						this.ClearItemData()
					}
				}
			}

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_BAG_LIST, refresh)
			if (!this.have_set) {
				this.SetData()
			}
		}

		this.SetData = () => {
			if (!this.is_loaded) {
				return
			}
			this.have_set = true
			this.ShowBagView()
		}

		this.ShowBagView = () => {
			let bag_list = []
			let bagList = goods_model.bag_goods_list
			if (bagList) {
				let cfg = null
				for (let _tmpi in bagList) {
					let vo = bagList[_tmpi]
					if (vo.type == 14) {
						cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, vo.type_id, false)
						if (cfg) {
							table.insert(bag_list, vo)
						}
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return a.type_id < b.type_id
			}
			table.sort(bag_list, sort_fun)

			this.empty_conta.visible = bag_list.length == 0
			if (!this.arrayCollection) {
				//this.arrayCollection = eui. new ArrayCollection()
				//this.arrayCollection.source = bag_list
				//this.item_group.dataProvider = this.arrayCollection
				//this.item_group.itemRenderer = ComGoodsResloveBagItem
				this.arrayCollection = new LoopScrowViewMgr()
				this.arrayCollection.SetData(this.item_scroll, ComGoodsResloveBagItem, bag_list, LoopScrCon.Vertical)
			} else {
				this.arrayCollection.replaceAll(bag_list)
			}
		}

		this.InitDefaultView = () => {
			if (!this.source_item) {
				this.source_item = new ComGoodsResloveItem(this.source_con)
				this.source_item.Load()
				this.source_item.SetScale(1.05)
			}
			this.source_item.ClearData()
			let item = null
			let i = 0
			do {
				item = this.item_list[i]
				if (!item) {
					item = new ComGoodsResloveItem(this.get_group)
					item.Load()
					this.item_list[i] = item
				}
				item.ClearData()
				i = i + 1
			} while ((i < 3))
		}

		this.SetResolveView = (data?) => {
			if (data) {
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, data.type_id, false)
				if (cfg) {
					if (this.source_item) {
						this.source_item.SetData(data, true)
					}
					let regular_mat = JSON.parse(cfg.regular_mat)
					let list = []
					if (regular_mat) {
						if (regular_mat.length == 1) {
							let vo = regular_mat[0]
							let obj = []
							let i = 0
							do {
								obj[0] = vo[0]
								obj[1] = vo[1]
								obj[2] = 1
								table.insert(list, obj)
								i = i + 1
							} while ((i < 3))
						} else {
							for (let _tmpi in regular_mat) {
								let vo = regular_mat[_tmpi]
								let obj = []
								obj[0] = vo[0]
								obj[1] = vo[1]
								obj[2] = vo[2]
								table.insert(list, obj)
							}
						}
					}
					let item = null
					let i = 0
					do {
						item = this.item_list[i]
						if (!item) {
							item = new ComGoodsResloveItem(this.get_group)
							item.Load()
							this.item_list[i] = item
						}
						item.SetVisible(true)
						item.SetData(list[i], false)
						i = i + 1
					} while ((i < list.length))
					if (this.item_list.length > list.length) {
						let i = list.length
						do {
							this.item_list[i].visible = false
							i = i + 1
						} while ((i < this.item_list.length))
					}
				} else {
					this.ClearItemData()
				}
			}
		}

		this.ClearItemData = () => {
			if (this.item_list) {
				for (let _tmpi in this.item_list) {
					let item = this.item_list[_tmpi]
					item.ClearData()
				}
			}
			if (this.source_item) {
				this.source_item.ClearData()
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_Image4: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	tips_conta: Laya.Box
	_Image1: Laya.Image
	tips_text: Laya.HTMLDivElement
	_Image2: Laya.Image
	item_scroll: Laya.List
	empty_conta: Laya.Box
	_Image3: Laya.Image
	Image: Laya.Image
	Image1: Laya.Image
	empty_text: Laya.Label
	source_con: Laya.Box
	get_scroll: Laya.Panel
	get_group: Laya.HBox
	resolveBtn: Laya.Box
	_Image5: Laya.Image
	btn_label: Laya.Label
	public GetComponents() {
		[
			this._Image4,
			this._Image6,
			this._Image7,
			this.tips_conta,
			this._Image1,
			this.tips_text,
			this._Image2,
			this.item_scroll,
			this.empty_conta,
			this._Image3,
			this.Image,
			this.Image1,
			this.empty_text,
			this.source_con,
			this.get_scroll,
			this.get_group,
			this.resolveBtn,
			this._Image5,
			this.btn_label,
		]
			= this.GetChildrenByNames([
				"_Image4",
				"_Image6",
				"_Image7",
				"tips_conta",
				"_Image1",
				"tips_text",
				"_Image2",
				"item_scroll",
				"empty_conta",
				"_Image3",
				"Image",
				"Image1",
				"empty_text",
				"source_con",
				"get_scroll",
				"get_group",
				"resolveBtn",
				"_Image5",
				"btn_label",
			])
	}
}
window["ComGoodsResloveView"] = ComGoodsResloveView