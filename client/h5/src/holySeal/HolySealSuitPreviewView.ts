import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { HolySealEquipItem } from "./HolySealEquipItem"
import { HolySealSuitAttrItem } from "./HolySealSuitAttrItem"
import { HolySealSuitPreviewItem } from "./HolySealSuitPreviewItem"
import { HolySealView } from "./HolySealView"

export class HolySealSuitPreviewView extends BaseView1 {
	//eui

	InitEvent
	UpdateView
	ItemTab
	SwitchItem
	Remove
	LoadSuccess

	bag_loop_mgr
	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealSuitPreviewView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		let model = HolySealModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_Util = Util,
			local_HolySealModel = HolySealModel,
			local_JSON = JSON,
			equip_list_,
			attr_list_,
			suit_list_,
			default_index_ = 0,
			now_index_

		this.load_callback = function () {
			this.LoadSuccess()
		}
		this.destroy_callback = function () {
			this.Remove()
		}
		this.preload_server_config = {
			"config_seal_suit": false
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this, this._img_bg1, GameResPath.GetIcon("holySeal", "ui_seal_bg1"))
			ResManager.GetInstance().SetTexture(this, this._img_bg2, GameResPath.GetIcon("holySeal", "ui_seal_01"))

			if (PlatformManager.IsEyouEnPlatform()) {
				this._img_tips.y = 625;
			}

			this.InitEvent()
			// this.InitView()

			this._lb_score.fontSize = 24
			ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_score)
			// this._list_suit_con.cacheContent = true
		}

		this.InitEvent = () => {
			local_Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			// this._list_suit_con.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.ItemTab, this);


			local_Util.AddClickEvent(this._img_tips, () => {
				// model.Fire(EventName.OPEN_VIEW, "HolySealTipsView", InstructionType.HolySealPreview)
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.HolySealPreview)
			}, this, true)


			this.BindEvent(model, local_HolySealModel.UPDATE_ALL_SUIT_DATA, (scmd) => {
				this.UpdateView(scmd)
			})

			model.Fire(local_HolySealModel.REQUEST_CCMD_EVENT, 65409)
		}

		this.UpdateView = (scmd) => {
			let suit_dic = {}
			for (let vo of scmd.suit) {
				suit_dic[vo.suit_id] = vo.num
			}
			if (!equip_list_)
				equip_list_ = {}
			let item: HolySealEquipItem
			for (let i = 1; i <= local_HolySealModel.EQUIP_COUNT; i++) {
				item = new HolySealEquipItem(this._gp_item_con)
				equip_list_[i] = item
				let pos = this.GetPos(i - 1)
				item.SetPosition(pos.x, pos.y)
				item.Load()
			}

			let list = []
			let suit_cfg = res_mgr.GetGameConfigFromCache(this, "config_seal_suit", false)
			for (let key in suit_cfg) {
				let cfg = suit_cfg[key]
				if (cfg) {
					let activating_count = 0
					let suit_data = {
						id: cfg.id,
						stage: cfg.stage,
						color: cfg.color,
						name: cfg.name,
						seal: local_JSON.parse(cfg.seal),
						attr: local_JSON.parse(cfg.attr),
						score: local_JSON.parse(cfg.score),
						activating_count: 0,
					}
					let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)
					let equip_data = model.GetHolySealData(suit_data.seal[0], config_seal_equip)
					let suit_type = model.GetSuitType(equip_data.pos)

					// let wear_holy_seal_list = GoodsModel.GetInstance().wear_holy_seal_list
					// for (let vo of wear_holy_seal_list) {
					// 	if (vo && local_HolySealModel.GetSuitType(vo.cell) == suit_type) {
					// 		let equip_data = model.GetHolySealData(vo.type_id)
					// 		if (equip_data.color >= suit_data.color && equip_data.stage >= suit_data.stage)
					// 			activating_count++
					// 	}
					// }
					let suit_count = suit_dic[cfg.id]
					if (suit_count) {
						suit_data.activating_count = suit_count
					}
					list.push(suit_data)
				}
			}

			suit_list_ = list

			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.replaceAll(list)
			}
			else {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this._list_suit_con, HolySealSuitPreviewItem, list, LoopScrCon.Horizontal, null, (index) => {
					// console.warn("@@@@@@@@@@",parms)

					this.SwitchItem(index)
				})
			}

			default_index_

			this.SwitchItem(default_index_)
		}

		this.ItemTab = (e, a) => {
			this.SwitchItem(e.itemIndex)
		}

		this.SwitchItem = (index) => {
			if (now_index_ == index)
				return

			let suit_data = suit_list_ && suit_list_[index]
			if (!suit_data)
				return

			let seal_list = {}
			let local_equip_type
			let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)
			for (let type_id of suit_data.seal) {
				let data = model.GetHolySealData(type_id, config_seal_equip)
				local_equip_type = data.pos
				seal_list[data.pos] = {
					equip_type: data.pos,
					type_id: type_id
				}
			}

			let suit_type = model.GetSuitType(local_equip_type)
			switch (suit_type) {
				case local_HolySealModel.Suit_Type.One:
					for (let i = 7; i < 12; i++) {
						seal_list[i] = {
							equip_type: i,
							type_id: 0
						}
					}
					break
				case local_HolySealModel.Suit_Type.Two:
					for (let i = 1; i < 7; i++) {
						seal_list[i] = {
							equip_type: i,
							type_id: 0
						}
					}
					break
			}

			let sub_type,data, item
			for (let i = 1; i <= local_HolySealModel.EQUIP_COUNT; i++) {
				sub_type = HolySealView.GetEquipTypeByPos(i)
				data = seal_list[sub_type]
				item = equip_list_[i]
				if (item && data) {
					item.SetData(data)
				}
			}

			// for (let index in seal_list) {
			// 	let item = equip_list_[index]
			// 	if (item) {
			// 		item.SetData(seal_list[index])
			// 	}
			// }

			let activating_count = suit_data.activating_count
			let attr = suit_data.attr
			if (!attr_list_)
				attr_list_ = []

			for (let key in attr) {
				let value = attr[key]
				let item = attr_list_[key]
				if (!item) {
					item = new HolySealSuitAttrItem(this._gp_attr_con)
					attr_list_[key] = item
					item.Load()
				}
				item.SetData(value, activating_count >= value[0])
			}

			//计算评分
			let total_score = 0
			let score = suit_data.score
			for (let vo of score) {
				total_score += vo[1]
			}

			let attr_list = []
			let seal = suit_data.seal
			for (let type_id of seal) {
				let holy_data = model.GetHolySealData(type_id, config_seal_equip)
				let base_attr = local_JSON.parse(holy_data.base_attr)
				for (let vo of base_attr) {
					attr_list.push(vo)
				}

				//极品属性
				let extra_attr = local_JSON.parse(holy_data.extra_attr)
				for (let vo of extra_attr) {
					attr_list.push(vo)
				}
			}
			total_score += local_Util.CalAttrPower(attr_list, false)
			this._lb_score.text = String(total_score)
		}

		this.Remove = () => {
			if (equip_list_) {
				let obj
				for (let i in equip_list_) {
					obj = equip_list_[i]
					if (obj) {
						obj.DeleteMe()
					}
				}
				equip_list_ = undefined
			}
			if (attr_list_) {
				for (let obj of attr_list_) {
					if (obj) {
						obj.DeleteMe()
					}
				}
				attr_list_ = undefined
			}


			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.DeleteMe()
				this.bag_loop_mgr = undefined
			}
			now_index_ = undefined
		}


	}

	GetPos(index?) {
		return ([
			//外圈 右到左
			{ x: 441, y: 173 },
			{ x: 310, y: 97 },
			{ x: 161, y: 124 },
			{ x: 63, y: 240 },
			{ x: 63, y: 391 },
			{ x: 161, y: 508 },
			//内圈 上左下右
			{ x: 336, y: 258 },
			{ x: 218, y: 380 },
			{ x: 336, y: 500 },
			{ x: 456, y: 380 },
			//中间

			{ x: 336, y: 380 }])[index]
	}


	_img_bg: Laya.Image
	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_bg5: Laya.Image
	_img_bg6: Laya.Image
	_gp_item_con: Laya.Box
	_scroll_attr: Laya.Panel
	_gp_attr_con: Laya.HBox
	image2: Laya.Image
	_Image17: Laya.Image
	_lb_title: Laya.Label
	_lb_title2: Laya.Label
	_lb_score: Laya.Label
	_list_suit_con: Laya.List
	_img_close: Laya.Image
	_img_tips: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg1,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_bg5,
			this._img_bg6,
			this._gp_item_con,
			this._scroll_attr,
			this._gp_attr_con,
			this.image2,
			this._Image17,
			this._lb_title,
			this._lb_title2,
			this._lb_score,
			this._list_suit_con,
			this._img_close,
			this._img_tips,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg1",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_bg5",
				"_img_bg6",
				"_gp_item_con",
				"_scroll_attr",
				"_gp_attr_con",
				"image2",
				"_Image17",
				"_lb_title",
				"_lb_title2",
				"_lb_score",
				"_list_suit_con",
				"_img_close",
				"_img_tips",
			])
	}
}
window["HolySealSuitPreviewView"] = HolySealSuitPreviewView