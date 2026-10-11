import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { Enum_UILayer } from "../common/LayerManager"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { CompositeSelectEquipItem } from "./CompositeSelectEquipItem"

export class SelectUnrealMatView extends BaseView1 {
	cur_index
	mask
	model
	parms
	item_loop_list
	item_loop_mgr
	unreal_model
	res_mgr
	cfg_goods_sub
	cfg_decoration_attr

	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "SelectUnrealMatView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		this.use_background = true
		this.preload_server_config = {
			"GoodsSubtype": false,
			"config_decoration_attr": false
		}

		this.model = CompositeModel.GetInstance()
		this.unreal_model = UnrealModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.cur_index = null
		}

		this.destroy_callback = () => {
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = null
			}
		}
	}

	public LoadSuccess() {
		/*
		if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			SetAnchoredPositionX(this.need_label, 134)
		}
		*/
		//this.mask = this.GetChild("mat_scroller/mat_dataGroup").GetComponent("Image")
		//this.RegisterMask(this.mask)
		this.cfg_goods_sub = this.res_mgr.GetGameConfigFromCache(this, "GoodsSubtype", false)
		this.cfg_decoration_attr = this.res_mgr.GetGameConfigFromCache(this, "config_decoration_attr", false)
		this.item_loop_list = []
		this.item_loop_mgr = new LoopScrowViewMgr()
		this.item_loop_mgr.SetData(this.mat_scroller, CompositeSelectEquipItem, this.item_loop_list, LoopScrCon.Vertical)

		this.UpdateView()
		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this.close_btn, () => {
			this.Close()
		}, this, true)

		this.BindEvent(this.model, CompositeModel.SELECT_GOD_EQUIP, (item?) => {
			let info = this.item_loop_list[item.index]
			this.model.Fire(CompositeEvent.SELECT_UNREAL_GOODS, this.cur_index, info)
			this.Close()
		})
	}

	public SetData(index?, parms?) {
		this.parms = parms
		this.cur_index = index
	}

	public UpdateView() {
		let list = null
		let tips = null
		let hole_id = this.parms.hole_id
		if (2 == hole_id) {
			let goods_id = this.parms.irregular_mat_cfg[0] && this.parms.irregular_mat_cfg[0][0]
			let attr_cfg = null
			if (goods_id) {
				attr_cfg = this.unreal_model.GetUnrealData(goods_id, this.cfg_decoration_attr)
			}
			if (attr_cfg) {
				let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
				let key = UnrealModel.goods_type + "@" + goodsVo.equip_type
				let cfg = this.cfg_goods_sub[key]
				let unreal_pos_name = cfg.subtype_name
				tips = attr_cfg.stage + "阶" + attr_cfg.star + "星" + ColorUtil.GetColorName(goodsVo.color) + unreal_pos_name
			}
			list = this.model.GetUnrealCompositeList(this.parms.irregular_mat_cfg, this.cur_index)
		}
		this.need_label.text = tips
		if (list && list.length > 0) {
			this.SetGoodsList(list)
			this.tips_img.visible = false
			this.tips_label.visible = false
		} else {
			this.tips_img.visible = true
			this.tips_label.visible = true
		}
	}

	public SetGoodsList(list?) {
		this.item_loop_list = list
		this.item_loop_mgr.replaceAll(this.item_loop_list)
		/*
		if (list) {
			let flag = false
			if (!this.item_list) {
				this.item_list = []
			}
			let i = list.length
			if (i < this.item_list.length) {
				do {
					this.item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.item_list.length))
			}
			i = 0
			do {
				let item = this.item_list[i]
				let info = list[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					item.Load()
					this.item_list[i] = item
					item.SetClickCallBack(() => {
						this.model.Fire(CompositeEvent.SELECT_UNREAL_GOODS, this.cur_index, info)
						this.Close()
					}
					)
				}
				item.SetData(info.type_id, 1)
				item.SetUseMask(true)
				let attr_cfg = this.unreal_model.GetUnrealData(info.type_id)
				if (attr_cfg) {
					item.SetGrade(attr_cfg.stage)
					item.SetStar(attr_cfg.star)
				}
				item.SetVisible(true)
				i = i + 1
			} while ((i < list.length))
		}
		*/
	}

	bg: Laya.Image
	item_bg: Laya.Image
	tips_img: Laya.Image
	tips_label: Laya.Label
	mat_scroller: Laya.Panel
	mat_dataGroup: Laya.VBox
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
			this.mat_dataGroup,
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
				"mat_dataGroup",
				"close_btn",
				"gp_tips",
				"need_text",
				"need_label",
				"img_title",
				"lb_title",
			])
	}
}
window["SelectUnrealMatView"] = SelectUnrealMatView