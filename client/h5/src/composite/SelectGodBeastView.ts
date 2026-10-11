import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodBeastModel } from "../commonModel/GodBeastModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { CompositeSelectEquipItem } from "./CompositeSelectEquipItem"

export class SelectGodBeastView extends BaseView1 {
	InitEvent
	InitView
	LoadSuccess
	Scrmat_scroller
	SetData
	SetGoodsList
	_Group1
	cur_index
	item_list
	item_loop_list
	item_loop_mgr
	left_title_image
	mat_dataGroup
	model
	need_refresh
	protect_bg
	right_title_image
	type_id
	cfg_eud_equip_attr
	res_mgr

	public constructor() {
		super()
		this.item_list = []
		this.need_refresh = false
		this.base_file = "composite"
		this.layout_file = "SelectGodBeastView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_eudemons_equip_attr": false
		}

		this.model = CompositeModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.cfg_eud_equip_attr = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
			this.mat_scroller.scrollBar.visible = false
			this.LoadSuccess()
			this.InitEvent()

			if (this.need_refresh) {
				this.SetData(this.cur_index, this.type_id)
			}
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				SetAnchoredPositionX(this.need_label, 278)
				LayoutRebuilder(this._Group1)
			}
			*/
		}

		this.open_callback = () => {
		}

		this.close_callback = () => {
			this.cur_index = null
		}

		this.destroy_callback = () => {
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = []
			}
			//for (let _tmpi in this.item_list) {
			//let obj = this.item_list[_tmpi]
			//  if (obj ) {
			//    obj.DeleteMe()
			//  }
			//}
			//this.item_list = []
		}

		//this.preload_server_config = [config_eudemons_equip_attr=false]
		this.LoadSuccess = () => {
			//this.title_text.text = "点击放入装备"
			this.need_label.text = "点击装备即可放入"
			this.item_loop_list = []
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this.mat_scroller, CompositeSelectEquipItem, this.item_loop_list, LoopScrCon.Vertical)
			//function(item)
			//  this.model.selected_godbeast_list[this.cur_index] = this.item_loop_list[item.real_index].goods_id
			//  this.model.Fire(CompositeEvent.SELECT_GODBEAST_GOODS, this.cur_index, this.item_loop_list[item.real_index])
			//  this.Close()
			//}, {canSelectAgain = true, not_first_call = true})
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}, this, true)

			this.BindEvent(this.model, CompositeModel.SELECT_GOD_EQUIP, (item?) => {
				this.model.selected_godbeast_list[this.cur_index] = this.item_loop_list[item.index].goods_id
				this.model.Fire(CompositeEvent.SELECT_GODBEAST_GOODS, this.cur_index, this.item_loop_list[item.index])
				this.Close()
			})
		}

		this.InitView = () => {
			if (!this.type_id) {
				return
			}
			let list = this.model.GetGodBeastCompositeList(this.type_id)
			if (list && list.length > 0) {
				this.SetGoodsList(list)
				this.tips_img.visible = false
				this.tips_label.visible = false
			} else {
				//for (let _tmpi in this.item_list) {
				//let obj = this.item_list[_tmpi]
				//    if (obj ) {
				//        obj.DeleteMe()
				//    }
				//}
				//this.item_list = []
				this.tips_img.visible = true
				this.tips_label.visible = true
			}
		}

		this.SetData = (index?, parms?) => {
			this.type_id = parms
			this.cur_index = index
			if (!parms) {
				return
			}

			if (this.is_loaded) {
				this.need_refresh = false
				let equipVo = GodBeastModel.GetInstance().GetEquipData(Number(parms[0]), this.cfg_eud_equip_attr)
				let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(Number(parms[0]))
				this.need_label.text = ColorUtil.GetColorName(goodsVo.color) + equipVo.star + "星蜃妖装备"
				this.InitView()
			} else {
				this.need_refresh = true
			}
		}

		this.SetGoodsList = (list?) => {
			this.item_loop_list = list
			this.item_loop_mgr.replaceAll(this.item_loop_list)
			/*if (list ) {
				let flag = false
				let i = 0
				do {
					let item = this.item_list[i]
					if (! item)
					{
						item =  new EquipmentItem(this.mat_dataGroup)
						item.Load()
						this.item_list[i] = item
					}
					item.SetData(list[i].type_id, 1)
					item.SetClickCallBack(() => {
							// [ts2lua]this.model.selected_godbeast_list下标访问可能不正确
							this.model.selected_godbeast_list[this.cur_index] = list[i].goods_id
							this.model.Fire(CompositeEvent.SELECT_GODBEAST_GOODS, this.cur_index, list[i])
							this.Close()
						}
					)
					i = i + 1
				} while ((i < list.length))
				let i = list.length
				do {
					let item = this.item_list[i]
					if (item)
					{
						item.DeleteMe()
						this.item_list[i] = null
					}
					i = i + 1
				} while ((i < this.item_list.length))
			}*///
		}
	}

	bg: Laya.Image
	item_bg: Laya.Image
	tips_img: Laya.Image
	tips_label: Laya.Label
	mat_scroller: Laya.List
	close_btn: Laya.Image
	gp_tips: Laya.HBox
	need_text: Laya.Label
	need_label: Laya.Label
	img_title: Laya.Image
	lb_title: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.item_bg,
			this.tips_img,
			this.tips_label,
			this.mat_scroller,
			this.close_btn,
			this.gp_tips,
			this.need_text,
			this.need_label,
			this.img_title,
			this.lb_title,
		]
			= this.GetChildrenByNames([
				"bg",
				"item_bg",
				"tips_img",
				"tips_label",
				"mat_scroller",
				"close_btn",
				"gp_tips",
				"need_text",
				"need_label",
				"img_title",
				"lb_title",
			])
	}
}
window["SelectGodBeastView"] = SelectGodBeastView