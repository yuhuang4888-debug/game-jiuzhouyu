import { BaseView1 } from "../common/BaseView1"
import { Util, RefGridLayout, SetHtmlStyle } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ResManager } from "../common/ResManager"
import { ColorUtil } from "../util/ColorUtil"
import { MatViewType } from "../commonModel/CompositeModel"
import { SelectMatItem } from "../composite/SelectMatItem"

export class SelectCompositeMatView extends BaseView1 {
	InitEvent
	InitView
	SetData
	SetGoodsList
	mat_dataGroup
	item_loop_list
	item_loop_mgr = null

	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "SelectCompositeMatView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true					// 窗口背景,用灰色半透明背景
		this.background_alpha = 0					// 窗口背景的透明度
		this.click_bg_toClose = true				// 点击背景是否关闭该窗口

		let local_comModel = CompositeModel.GetInstance()
		let local_comEvent = CompositeEvent
		let local_wordMgr = WordManager
		let local_gModel = GoodsModel.GetInstance()
		let local_colorUtil = ColorUtil
		let type_id_ = null
		let item_list_ = []
		let total_count_ = null
		let cur_index_ = null
		let mater_type_ = null
		let type_ = null
		let need_refresh_ = false
		let local_MatViewType = MatViewType

		this.load_callback = () => {
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.need_label.size = 16
			}
			this.RegisterMask(this.mat_dataGroup)
			*/
			//this.mat_scroller.scrollBar.visible = false
			this.mat_scroller2.vScrollBar.visible = false
			this.need_label.width = 550
			this.need_label.style.fontSize = 20
			this.need_label.style.color = "#0a953e"
			this.need_label.style.align = "center"
			this.need_label.style.wordWrap = false
		
			this.InitEvent()
		}

		this.close_callback = () => {
			cur_index_ = null
		}

		this.destroy_callback = () => {
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = null
			}
			for (let _tmpi in item_list_) {
				var obj = item_list_[_tmpi]
				if (obj) {
					obj.DeleteMe()
				}
			}
			item_list_ = []
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}
				, this, true)
			if (need_refresh_) {
				need_refresh_ = false
				this.SetData(cur_index_, type_id_, mater_type_, type_)
			}
		}

		this.InitView = () => {
			if (!type_id_) {
				return
			}
			let list = []
			if (type_ == local_MatViewType.EQUIP) {
				list = local_comModel.GetEquipCompositeList(type_id_)
			} else if (type_ == local_MatViewType.RING) {
				list = local_comModel.GetRingCompositeList(type_id_, local_comModel.selected_ring_list, local_comModel.ring_mat_list)
			} else if (type_ == local_MatViewType.RINGUP) {
				list = local_comModel.GetRingCompositeList(type_id_, local_comModel.selected_ring_up_list, local_comModel.ring_up_mat_list)
			}
			if (list && list.length > 0) {
				this.SetGoodsList(list)
				this.tips_img.visible = false
				this.tips_label.visible = false
			} else {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					if (obj) {
						obj.DeleteMe()
					}
				}
				item_list_ = []
				this.tips_img.visible = true
				this.tips_label.visible = true
			}
		}

		this.SetData = (index?, parms?, mater_type?, type?) => {
			if (!parms) {
				return
			}
			type_id_ = parms
			cur_index_ = index
			mater_type_ = mater_type
			type_ = type || local_MatViewType.EQUIP

			if (!this.is_loaded) {
				need_refresh_ = true
				return
			}
			let sex = RoleManager.GetInstance().mainRoleInfo.sex
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			let equipVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, Number(parms[0]), false, equip_attr_cfg)
			let goodsVo = local_gModel.GetGoodsBasicByTypeId(parms[0])
			let sex_word = null
			let type_word = null
			let badStar = null
			if (type_ == local_MatViewType.EQUIP && goodsVo) {
				sex = goodsVo.sex
			}
			if (sex == 1) {
				sex_word = "男"
			} else if (sex == 2) {
				sex_word = "女"
			}
			if (parms.length == 1) {
				type_word = local_wordMgr.GetEquipPos(goodsVo.equip_type)
				let goodsVo1 = local_gModel.GetGoodsBasicByTypeId(parms[0])
				if (goodsVo1 && (((goodsVo1.equip_type == 3 || goodsVo1.equip_type == 5) || goodsVo1.equip_type == 7) || goodsVo1.equip_type == 9)) {
					sex_word = ""
				}
			} else {
				let cache_type = []
				for (let _tmpi in parms) {
					var vo = parms[_tmpi]
					let goodsVo1 = local_gModel.GetGoodsBasicByTypeId(vo)
					if (cache_type.length == 0) {
						table.insert(cache_type, goodsVo1.equip_type)
						type_word = local_wordMgr.GetEquipPos(goodsVo1.equip_type)
					} else if (cache_type[0] != goodsVo1.equip_type) {
						if (cache_type[0] == 3 || cache_type[0] == 5) {
							type_word = "饰品"
						} else {
							type_word = "武防"
						}
					}
					if (type_ == local_MatViewType.EQUIP && !badStar) {
						let equipVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, Number(vo), false, equip_attr_cfg)
						if (equipVo && equipVo.class_type == 1) {
							badStar = equipVo.star
						}
					}
				}
				if (((cache_type[0] == 3 || cache_type[0] == 5) || cache_type[0] == 7) || cache_type[0] == 9) {
					sex_word = ""
				}
			}
			let star = (equipVo.star > 0 && (equipVo.star + "星") || (""))
			if (type_ == local_MatViewType.EQUIP) {
				if (badStar) {
					this.need_label.innerHTML = Util.StrToHTML("<font color='#4A3A32'>需要</font>" + equipVo.stage + "阶" + star + local_colorUtil.GetColorName(goodsVo.color) + sex_word + type_word + "或红色" + badStar + "星残旧装备")
				} else {
					this.need_label.innerHTML = Util.StrToHTML("<font color='#4A3A32'>需要</font>" + equipVo.stage + "阶" + star + local_colorUtil.GetColorName(goodsVo.color) + sex_word + type_word)
				}
			} else {
				this.need_label.innerHTML = Util.StrToHTML("<font color='#4A3A32'>需要</font>" + equipVo.stage + "阶" + star + local_colorUtil.GetColorName(goodsVo.color) + sex_word + type_word)
			}
			if (this.is_loaded) {
				need_refresh_ = false
				this.InitView()
			} else {
				need_refresh_ = true
			}
		}

		this.SetGoodsList = (list?) => {
			/*
			this.item_loop_list = list
			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this.mat_scroller, SelectMatItem, this.item_loop_list, LoopScrCon.Vertical)
			} else {
				this.item_loop_mgr.replaceAll(this.item_loop_list)
			}
			*/

			if (list) {
				let flag = false
				let i = 0
				do {
					let item = item_list_[i]
					if (!item) {
						item = new SelectMatItem(this.mat_scroller2)
						item.SetUseMask(true)
						item.Load()
						item.SetItemSize(85, 85)
						if (i == (list.length - 1)) {
							item.ExcuteCallback(() => {
								RefGridLayout(this.mat_scroller2, {
									h_gap: 2,
									v_gap: 10,
									column: 5,
									item_w: 85,
									item_h: 85
								}, false)
							})
						}
						item_list_[i] = item
					}
					let listdata = list[i]
					item.SetData(listdata.type_id, 1, listdata.bind)
					item.setImgVisible(listdata.goods_id)
					//}
					//)
					item.SetClickCallBack(() => {
						if (mater_type_ == 1) {
							if (type_ == local_MatViewType.EQUIP) {
								local_comModel.equipment_mat_list[cur_index_] = listdata.goods_id
							} else if (type_ == local_MatViewType.RING) {
								local_comModel.ring_mat_list[cur_index_] = listdata.goods_id
							} else if (type_ == local_MatViewType.RINGUP) {
								local_comModel.ring_up_mat_list[cur_index_] = listdata.goods_id
							}
						} else {
							if (type_ == local_MatViewType.EQUIP) {
								local_comModel.selected_equip_list[cur_index_] = listdata.goods_id
							} else if (type_ == local_MatViewType.RING) {
								local_comModel.selected_ring_list[cur_index_] = listdata.goods_id
							} else if (type_ == local_MatViewType.RINGUP) {
								local_comModel.selected_ring_up_list[cur_index_] = listdata.goods_id
							}
						}
						if (type_ == local_MatViewType.EQUIP) {
							local_comModel.Fire(local_comEvent.SELECT_EQUIP_GOODS, cur_index_, listdata)
						} else if (type_ == local_MatViewType.RING) {
							local_comModel.Fire(local_comEvent.SELECT_RING_GOODS, cur_index_, listdata, type_)
						} else if (type_ == local_MatViewType.RINGUP) {
							local_comModel.Fire(local_comEvent.SELECT_RING_UP_GOODS, cur_index_, listdata, type_)
						}
						this.Close()
					}
					)
					i = i + 1
				} while ((i < list.length))
				i = list.length
				do {
					let item = item_list_[i]
					if (item) {
						item.DeleteMe()
						item_list_[i] = null
					}
					i = i + 1
				} while ((i < item_list_.length))
			}
		}
	}

	bg: Laya.Image
	item_bg: Laya.Image
	tips_img: Laya.Image
	tips_label: Laya.Label
	mat_scroller: Laya.List
	close_btn: Laya.Image
	need_label: Laya.HTMLDivElement
	img_title: Laya.Image
	lb_title: Laya.Label
	mat_scroller2: Laya.Panel
	public GetComponents() {
		[
			this.bg,
			this.item_bg,
			this.tips_img,
			this.tips_label,
			this.mat_scroller,
			this.close_btn,
			this.need_label,
			this.img_title,
			this.lb_title,
			this.mat_scroller2,
		]
			= this.GetChildrenByNames([
				"bg",
				"item_bg",
				"tips_img",
				"tips_label",
				"mat_scroller",
				"close_btn",
				"need_label",
				"img_title",
				"lb_title",
				"mat_scroller2",
			])
	}
}
window["SelectCompositeMatView"] = SelectCompositeMatView