import { BaseItem1 } from "../common/BaseItem1"
import { PlayBigEffect, Util } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { Status } from "../util/Status"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ErlangParser } from "../util/ErlangParser"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CompositeEquipResolveBagItem } from "./CompositeEquipResolveBagItem"
import { ComposeEquipResolveItem } from "./ComposeEquipResolveItem"

export class CompositeEquipResolveView extends BaseItem1 {
	ClearItemData
	InitDefaultView
	InitEvents
	LoadSuccess
	LocalDeleteMe
	SetData
	SetResolveView
	ShowBagView

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeEquipResolveView"

		let local_comModel = CompositeModel.GetInstance()
		let local_goodsModel = GoodsModel
		let local_gmodelIns = local_goodsModel.GetInstance()

		let have_set_ = false
		let arrayCollection_ = null
		let source_item_ = null
		let item_list_ = []
		let last_click_time_ = null

		this.load_callback = () => {
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.tips_text.size = 20
			}
			this.RegisterMask(this.item_group)
			this.RegisterMask(this.get_group)
			*/
			this.LoadSuccess()
			this.InitEvents()
		}

		this.LocalDeleteMe = () => {
			local_comModel.select_resolve_goods_id = null
			if (item_list_) {
				for (let _tmpi in item_list_) {
					let item = item_list_[_tmpi]
					item.DeleteMe()
					item = null
				}
				item_list_ = []
			}
			if (source_item_) {
				source_item_.DeleteMe()
				source_item_ = null
			}
			if (arrayCollection_) {
				arrayCollection_.DeleteMe()
				arrayCollection_ = null
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg1, "resource/game/composite/other/ui_merge_15.png")
			this.item_scroll.scrollBar.visible = false

			this.tips_text.width = 400
			this.tips_text.style.fontSize = 20
			this.tips_text.style.color = "#ffffff"
			this.tips_text.style.wordWrap = true
			let str = "只有暗金和9阶及以上粉色装备才可以拆解！<br\>拆解后<font color='#00fa64'>100%返还</font>其合成材料"
			this.tips_text.innerHTML = Util.StrToHTML(str)
			this.InitDefaultView()
		}

		this.InitEvents = () => {
			let select_fun = (goods_id?, data?) => {
				this.SetResolveView(data)
			}
			this.BindEvent(local_comModel, CompositeEvent.SELECT_EQUIP_RESOLVE_ITEM, select_fun)

			let resolve_fun = () => {
				let goods_vo = null
				if (local_comModel.select_resolve_goods_id) {
					goods_vo = local_gmodelIns.GetGoodsVoByGoodsId(local_comModel.select_resolve_goods_id)
				}
				if (goods_vo) {
					if (!last_click_time_ || Status.NowTime - last_click_time_ >= 0.5) {
						let ok_fun = () => {
							let goods_list = []
							let vo = { goods_id: local_comModel.select_resolve_goods_id, goods_num: 1 }
							table.insert(goods_list, vo)
							local_gmodelIns.Fire(local_goodsModel.RESOLVE_GOODS, goods_list)
						}

						let str = ""
						if (goods_vo) {
							str = "是否确定拆解<font color=" + ColorUtil.GetColorDark(goods_vo.color) + ">" + goods_vo.goods_name + "</font>?<br/>拆解可100%返还其合成材料"
						}
						Alert.Show(str, Alert_Type.Two, ok_fun, null, "确定拆解", "我再想想")
						last_click_time_ = Status.NowTime
					}
				} else {
					Message.show("没有选中拆解物品")
				}
			}

			Util.AddClickEvent(this.resolveBtn, resolve_fun, this, true)

			let success_fun = (vo?) => {
				if (vo && vo.code == 1) {
					// PlayBigEffect("ui_fenjietexiao");
					local_comModel.select_resolve_goods_id = null
					this.ClearItemData()
					if (vo.reward_list) {
						let list = []
						for (let _tmpi in vo.reward_list) {
							let tmp = vo.reward_list[_tmpi]
							let goods_vo = local_gmodelIns.GetGoodsVoByGoodsId(tmp.goods_id)
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

			this.BindEvent(local_gmodelIns, local_goodsModel.GOODS_DECOMPOSE_SUCCESS, success_fun)
			let refresh = () => {
				if (this.use_delete_method) {
					return
				}
				this.SetData()
				if (local_comModel.select_resolve_goods_id) {
					let data = local_gmodelIns.GetGoodsVoByGoodsId(local_comModel.select_resolve_goods_id)
					if (!data) {
						this.ClearItemData()
					}
				}
			}

			this.BindEvent(local_gmodelIns, local_goodsModel.CHANGE_BAG_LIST, refresh)
			if (!have_set_) {
				this.SetData()
			}
		}

		this.SetData = () => {
			if (!this.is_loaded) {
				return
			}
			have_set_ = true
			this.ShowBagView()
		}

		this.ShowBagView = () => {
			let bag_list = []
			let artifactbag_goods_list = local_gmodelIns.bag_goods_list
			if (artifactbag_goods_list) {
				let cfg = null
				for (let _tmpi in artifactbag_goods_list) {
					let vo = artifactbag_goods_list[_tmpi]
					if (vo.color >= 6 && vo.type == 10) {
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
			if (!arrayCollection_) {
				arrayCollection_ = new LoopScrowViewMgr()
				arrayCollection_.SetData(this.item_scroll, CompositeEquipResolveBagItem, bag_list, LoopScrCon.Vertical)
				//arrayCollection_ = eui. new ArrayCollection()
				//arrayCollection_.source = bag_list
				//this.item_group.dataProvider = arrayCollection_
				//this.item_group.itemRenderer = CompositeEquipResolveBagItem
			} else {
				arrayCollection_.replaceAll(bag_list)
			}
		}

		this.InitDefaultView = () => {
			if (!source_item_) {
				source_item_ = new ComposeEquipResolveItem(this.source_con)
				source_item_.Load()
			}
			source_item_.ClearData()
			let item = null
			let i = 0
			do {
				item = item_list_[i]
				if (!item) {
					item = new ComposeEquipResolveItem(this.get_group)
					item.Load()
					item_list_[i] = item
				}
				item.ClearData()
				i = i + 1
			} while ((i < 4))
		}

		this.SetResolveView = (data?) => {
			if (data) {
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, data.type_id, false)
				if (cfg) {
					if (source_item_) {
						source_item_.SetData(data, true)
					}
					let regular_mat = JSON.parse(cfg.regular_mat)
					let list = []
					if (regular_mat) {
						for (let _tmpi in regular_mat) {
							let vo = regular_mat[_tmpi]
							let obj = []
							obj[0] = vo[0]
							obj[1] = vo[1]
							obj[2] = vo[2]
							table.insert(list, obj)
						}
					}
					let i = 0
					do {
						let obj = []
						obj[0] = 0
						obj[1] = 38250023
						obj[2] = 1
						table.insert(list, obj)
						i = i + 1
					} while ((i < cfg.irregular_num))
					let item = null
					i = 0
					do {
						item = item_list_[i]
						if (!item) {
							item = new ComposeEquipResolveItem(this.get_group)
							//item:SetMaskId(1)
							item.Load()
							item_list_[i] = item
						}
						item.SetVisible(true)
						item.SetData(list[i], false)
						i = i + 1
					} while ((i < list.length))
					if (item_list_.length > list.length) {
						let i = list.length
						do {
							item_list_[i].SetVisible(false)
							i = i + 1
						} while ((i < item_list_.length))
					}
					let width = 85 * list.length + 10 * (list.length - 1)
					this.get_group.width = width
				} else {
					this.ClearItemData()
				}
			}
		}

		this.ClearItemData = () => {
			if (item_list_) {
				for (let _tmpi in item_list_) {
					let item = item_list_[_tmpi]
					item.ClearData()
				}
			}
			if (source_item_) {
				source_item_.ClearData()
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	tips_conta: Laya.Box
	_Image1: Laya.Image
	tips_text: Laya.HTMLDivElement
	_Image6: Laya.Image
	img_bg2: Laya.Image
	img_bg1: Laya.Image
	_Image2: Laya.Image
	item_scroll: Laya.List
	empty_conta: Laya.Box
	_Image3: Laya.Image
	empty_text: Laya.Label
	_Image4: Laya.Image
	source_con: Laya.Box
	get_group: Laya.HBox
	resolveBtn: Laya.Box
	_Image5: Laya.Image
	btn_label: Laya.Label
	public GetComponents() {
		[
			this.tips_conta,
			this._Image1,
			this.tips_text,
			this._Image6,
			this.img_bg2,
			this.img_bg1,
			this._Image2,
			this.item_scroll,
			this.empty_conta,
			this._Image3,
			this.empty_text,
			this._Image4,
			this.source_con,
			this.get_group,
			this.resolveBtn,
			this._Image5,
			this.btn_label,
		]
			= this.GetChildrenByNames([
				"tips_conta",
				"_Image1",
				"tips_text",
				"_Image6",
				"img_bg2",
				"img_bg1",
				"_Image2",
				"item_scroll",
				"empty_conta",
				"_Image3",
				"empty_text",
				"_Image4",
				"source_con",
				"get_group",
				"resolveBtn",
				"_Image5",
				"btn_label",
			])
	}
}
window["CompositeEquipResolveView"] = CompositeEquipResolveView