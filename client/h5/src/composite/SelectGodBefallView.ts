import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { CompositeSelectEquipItem } from "./CompositeSelectEquipItem"
import { EquipModel } from "../commonModel/EquipModel"

export class SelectGodBefallView extends BaseView1 {
	InitEvent
	InitView
	LoadSuccess
	SetData
	SetGoodsList
	_Group1
	cur_index

	item_list
	item_loop_list
	item_loop_mgr
	mat_dataGroup
	model
	need_refresh
	type_id
	cfg_equip_attr
	res_mgr

	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "SelectGodBefallView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_equip_attr": false
		}

		this.item_list = []
		this.need_refresh = false
		this.model = CompositeModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.cfg_equip_attr = this.res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)
			this.mat_scroller.scrollBar.visible = false
			this.LoadSuccess()
			this.InitEvent()

			if (this.need_refresh) {
				this.SetData(this.cur_index, this.type_id)
			}
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
			//    if (obj ) {
			//        obj.DeleteMe()
			//    }
			//}
			//this.item_list = []
		}

		//this.preload_server_config = [Equipattr = false]
		this.LoadSuccess = () => {
			//this.title_text.text = "点击放入装备"
			this.need_label.text = "点击装备即可放入"

			this.item_loop_list = []
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this.mat_scroller, CompositeSelectEquipItem, this.item_loop_list, LoopScrCon)
			//function(item) 
			//    // [ts2lua]this.model.selected_god_list下标访问可能不正确
			//    //console.log("_______", this.cur_index, item.real_index)
			//    this.model.selected_god_list[this.cur_index] = this.item_loop_list[item.real_index].goods_id
			//    this.model.Fire(CompositeEvent.SELECT_GOD_GOODS, this.cur_index, this.item_loop_list[item.real_index])
			//    this.Close()
			//}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this.close_btn, () => {
					this.Close()
				},
				this,
				true
			)

			this.BindEvent(
				this.model,
				CompositeModel.SELECT_GOD_EQUIP, (item?) => {
					this.model.selected_god_list[this.cur_index] = this.item_loop_list[item.index].goods_id
					this.model.Fire(CompositeEvent.SELECT_GOD_GOODS, this.cur_index, this.item_loop_list[item.index])
					this.Close()
				}
			)
		}

		this.InitView = () => {
			if (!this.type_id) {
				return
			}
			let list = this.model.GetGodCompositeList(this.type_id)
			list = list || {}
			this.SetGoodsList(list)

			if (list && list.length > 0) {
				this.tips_img.visible = false
				this.tips_label.visible = false
			} else {
				//for (let _tmpi in this.item_list) {
				// let obj = this.item_list[_tmpi]
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
				let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(Number(parms[0]))
				let star = EquipModel.GetInstance().GetStarByTypeId(goodsVo.type_id, this.cfg_equip_attr)
				this.need_label.text = star + "星" + goodsVo.goods_name
				this.InitView()
			} else {
				this.need_refresh = true
			}
		}

		this.SetGoodsList = (list?) => {
			this.item_loop_list = list
			this.item_loop_mgr.replaceAll(this.item_loop_list)

			//if (list ) {
			//    let flag = false
			//    for (let i = 1; i <= list.length; i++){
			//        let item = this.item_list[i]
			//        if (! item ) {
			//            item =  new EquipmentItem(this.mat_dataGroup)
			//            item.Load()
			//            this.item_list[i] = item
			//        }
			//        item.SetData(list[i].type_id, 1, list[i].bind)
			//        item.index = i
			//        item.SetClickCallBack(
			//           
			//        )
			//    }
			//}
		}
	}

	bg: Laya.Image
	item_bg: Laya.Image
	tips_img: Laya.Image
	tips_label: Laya.Label
	mat_scroller: Laya.List
	close_btn: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	gp_tips: Laya.HBox
	need_text: Laya.Label
	need_label: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.item_bg,
			this.tips_img,
			this.tips_label,
			this.mat_scroller,
			this.close_btn,
			this.img_title,
			this.lb_title,
			this.gp_tips,
			this.need_text,
			this.need_label,
		]
			= this.GetChildrenByNames([
				"bg",
				"item_bg",
				"tips_img",
				"tips_label",
				"mat_scroller",
				"close_btn",
				"img_title",
				"lb_title",
				"gp_tips",
				"need_text",
				"need_label",
			])
	}
}
window["SelectGodBefallView"] = SelectGodBefallView