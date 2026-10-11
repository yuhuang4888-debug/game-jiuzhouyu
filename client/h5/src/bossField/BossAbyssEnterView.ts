import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { Util, Trim } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { FirstBloodModel } from "../commonModel/FirstBloodModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { BossModel } from "../commonModel/BossModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BossAbyssRoomItem } from "./BossAbyssRoomItem"
import { ShopModel } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"

export class BossAbyssEnterView extends BaseItem1 {
	CustomMehod
	InitEvent
	InitView
	LoadSuccess
	ReOpen_callback
	SetAttention
	SetRoom
	SetRoomType
	ShowModel
	ShowRewardItem
	SwitchView
	UpdateRemindState
	UpdateView

	boss_id
	boss_info
	boss_type
	//color_shape
	icon
	model
	reward_item_list
	room_item
	select_boss_id
	show_model

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossField"
		this.layout_file = "BossAbyssEnterView"

		this.model = BossModel.GetInstance()
		let local_BossBaseModel = BossModel
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let cbSelect = false
		this.boss_type = BossModel.BossType.abyss
		this.reward_item_list = []

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label1.pos(70,17)
				this._gp_attention.pos(316,70)
			}
			this._reward_con.vScrollBar.visible = false
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_drop_tips.size = 18
			// 	this.Text.size = 20
			// 	this.Text.lineSpacing = 0.5
			// 	this.Text.verticalAlign = "middle"
			// 	this.Text.textAlign = "center"
			// 	SetSizeDelta(this.Text, 100, 50)
			// 	SetAnchoredPosition(this.Text, 0, -18)
			// 	SetAnchoredPositionX(this._btn_drop, 10)
			// }
			this.InitEvent()
			this.InitView()
			this.ShowShop()
			this.CheckShopRed()
		}

		this.ReOpen_callback = () => {
			if (this.icon) {
				this.ShowModel(this.icon)
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_shop, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldSoulShopView")
			}, this, true)
			this.BindEvent(this.model, local_BossBaseModel.UPDATE_BOSS_INFO, (boss_type?) => {
				if (boss_type == this.boss_type) {
					this.UpdateView()
				}
			})

			this.BindEvent(this.model, local_BossBaseModel.UPDATE_REMIND_STATE, (boss_type?, boss_id?) => {
				if (boss_type == this.boss_type && boss_id == this.boss_id) {
					this.UpdateRemindState()
				}
			})

			Util.AddClickEvent(this._gp_attention, () => {
				let state = !cbSelect ? 1 : 0
				this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46007, this.boss_type, this.boss_id, state,0)
			}, this)

			Util.AddClickEvent(this._btn_drop, () => {
				this.model.Fire(local_BossBaseModel.OPEN_DROP_RECORD_VIEW)
			}, this, true)

			// Util.AddClickEvent(this._gp_model_con, () => {
			// 	this.model.Fire(local_BossBaseModel.OPEN_TIPS_VIEW, this.boss_id)
			// }, this)

			// let show = false
			// let show_green_fun = (is_green?) => {
			// 	show = !show
			// 	if (this.color_shape) {
			// 		destroy(this.color_shape)
			// 		this.color_shape = null
			// 	}
			// 	if (show) {
			// 		if (!this.color_shape) {
			// 			this.color_shape = SetGreenOrBlackBg(this.display_obj, is_green)
			// 		}
			// 	}
			// 	this._Image2.visible = !show
			// 	this._lb_boss_name.visible = !show
			// 	this._gp_attention.visible = !show
			// 	this._lb_drop_tips.visible = !show
			// 	this._gp_drop.visible = !show
			// }
			// this.BindEvent(GlobalEventSystem, EventName.SHOW_GREEN_OR_BLACK_BG, show_green_fun)
		}

		this.InitView = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_drop, GameResPath.GetIcon("suitboss", "uimh_024"))
			this.SetRoomType()
			this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46000, this.boss_type)
		}

		this.SetRoomType = () => {
			this.SetRoom(BossAbyssRoomItem)
		}

		this.SetRoom = (room_class?) => {
			if (!this.room_item) {
				this.room_item = new room_class(this._gp_room_con)
				this.room_item.Load()
			}
			this.room_item.SetClickCallBack(this.SwitchView)
			if (this.select_boss_id) {
				this.room_item.SetSelectBoss(this.select_boss_id)
			}
		}

		this.UpdateView = () => {
			let boss_info = this.model.GetBossTypeInfo(this.boss_type)
			if (this.room_item) {
				this.boss_info = boss_info
				this.room_item.SetData(boss_info)
			}
		}

		this.SwitchView = (info?, now_layer?) => {
			if (!info || !info.boss_id) {
				return
			}
			let boss_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			let boss_cfg = boss_cfg_[info.boss_id]
			this.boss_id = info.boss_id
			this._lb_boss_name.text = "Lv." + info.lv + " " + info.boss_name
			let reward_list = JSON.parse(boss_cfg.ratio_goods)
			let level = role_mgr.GetMainRoleVo().level
			//let open_lv = info.open_lv
			//let max_lv = info.max_lv
			let drop_lv = boss_cfg.drop_lv
			this._gp_tips.visible = level - info.lv >= drop_lv
			//let bgConfig = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientBossBg", true)
			//let bg = bgConfig && bgConfig[this.boss_type]
			//if (bg && bg[now_layer] && bg[now_layer ]["big_bg"] ) {
			//this.model.Fire(local_BossBaseModel.CHANGE_WINDOW_BG,bg[now_layer ]["big_bg"])
			//}
			this.UpdateRemindState()
			this.ShowRewardItem(reward_list)
			if (this.icon == info.icon) {
				return
			}
			this.icon = info.icon
			this.ShowModel(this.icon)
			let merge_time = ServerTimeModel.GetInstance().GetMergeServerTime()
			let first_info = FirstBloodModel.GetInstance().GetShowFirstBlood(this.boss_id)
			let show_first_blood = (first_info && (merge_time || merge_time == 0) && merge_time <= 0) && true || false
			this._lb_first_blood.visible = show_first_blood
			this.first_bg.visible = show_first_blood
			if (first_info && Trim(first_info.name) != "") {
				this._lb_first_blood.text = "全服首次归属：" + first_info.name
			} else {
				this._lb_first_blood.text = "全服首次归属：暂无"
			}
		}

		this.ShowRewardItem = (reward_list?) => {
			let career = role_mgr.GetMainRoleVo().career
			let _reward_list = []
			for (let key in reward_list) {
				let obj = reward_list[key]
				if (Number(obj[0]) == career) {
					_reward_list = obj[1]
					break
				}
			}
			let len = _reward_list.length
			let i = len
			if (i < this.reward_item_list.length) {
				do {
					this.reward_item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.reward_item_list.length))
			}
			let list = []
			for (let _tmpi in _reward_list) {
				let vo = _reward_list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					table.insert(list, { type_id: goods_vo.type_id, goods_name: goods_vo.goods_name, color: goods_vo.color, count: vo[2], lock: lock })
				}
			}
			let act_goods = this.model.GetActiveDrop()
			if (act_goods) {
				let [type_id, lock] = goods_model.GetMappingTypeId(0, act_goods)
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					table.insert(list, { type_id: goods_vo.type_id, goods_name: goods_vo.goods_name, color: goods_vo.color, lock: lock })
				}
			}
			let index = 0
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				let item = this.reward_item_list[index]
				if (!item) {
					item = new EquipmentItem(this._reward_con)
					this.reward_item_list[index] = item
					item.SetUseMask(true)
					item.Load()
					item.SetItemSize(80, 80)
					item.SetPosition(Number(index) % 2 == 0 ? 0 : 97, Math.floor(Number(index) / 2) * 89)
				}
				item.SetData(vo.type_id, vo.count, vo.lock)
				item.SetVisible(true)
				index = index + 1
			}
		}

		this.ShowModel = (mon_res?) => {
			//let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			//let modelCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigBoss", true)
			//let _modelCfg = local_BossBaseModel.GetShowModelCfg(this.boss_type, mon_res, modelCfg)
			//let offset = _modelCfg && _modelCfg.offset || { x: 0, y: 0 }
			//let ui_scale = _modelCfg && _modelCfg.scale || 1
			//let action_name_list = (_modelCfg && _modelCfg.action_name_list) && _modelCfg.action_name_list || ["attack"]
			let action_name_list = ["attack"]
			table.insert(action_name_list, "idle")

			// let callBack = () => {
			// 	this.CoverMode(this._Image2, this.layer_value, curr_sorting_order)
			// 	this.CoverMode(this._lb_boss_name, this.layer_value, curr_sorting_order)
			// 	this.CoverMode(this._gp_attention, this.layer_value, curr_sorting_order)
			// 	this.CoverMode(this._lb_drop_tips, this.layer_value, curr_sorting_order)
			// 	this.CoverMode(this._gp_drop, this.layer_value, curr_sorting_order)
			// 	this.CoverMode(this.first_bg, this.layer_value, curr_sorting_order)
			// }

			let data = {
				clothe_res_id: mon_res,
				type: UI_MODEL_TYPE.MONSTER,
				//layer_value: this.layer_value,
				//scale: 0.7 * ui_scale,
				//position: offset,
				//load_call_back = callBack,
				action_name_list: action_name_list,
				//custom_sorting_order = curr_sorting_order
				layout_file: "BossAbyssEnterView"
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)
		}

		this.CustomMehod = (index?, args?) => {
			if ((args && args[0]) && Number(args[0]) > 1) {
				this.select_boss_id = Number(args[0])
			}
		}

		this.UpdateRemindState = () => {
			let info = this.model.GetBossInfo(this.boss_type, this.boss_id)
			if (!info) {
				return
			}
			cbSelect = info.is_remind
			this.SetAttention()
		}

		this.SetAttention = () => {
			this.attention.visible = cbSelect
			// if (cbSelect) {
			// 	ResManager.GetInstance().SetImageSprite(this, this.attention, "boss_asset", "uiboss_033")
			// } else {
			// 	ResManager.GetInstance().SetImageSprite(this, this.attention, "boss_asset", "uiboss_032")
			// }
		}
	}

	private ShowShop = () => {
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		this._img_shop.visible = lv >= 300
	}
	private CheckShopRed = () => {
		let red = ShopModel.GetInstance().CheckSoulOfWarRed()
		this._img_shop_red.visible = red
	}
	public DeleteMe() {
		if (this.room_item) {
			this.room_item.DeleteMe()
			this.room_item = null
		}
		for (let _tmpi in this.reward_item_list) {
			let vo = this.reward_item_list[_tmpi]
			vo.DeleteMe()
		}
		this.reward_item_list = []
		//if (this.show_model ) {
		//this.show_model.DeleteMe()
		//this.show_model = null
		//}
		this.icon = false
		// if (this.color_shape) {
		// 	destroy(this.color_shape)
		// 	this.color_shape = null
		// }
		super.DeleteMe()
	}

	_bg: Laya.Image
	_Group1: Laya.Box
	_gp_model_con: Laya.Box
	_Image1: Laya.Image
	_lb_boss_name: Laya.Label
	_gp_attention: Laya.Box
	_Image3: Laya.Image
	attention: Laya.Image
	lb_atten: Laya.Label
	_btn_drop: Laya.Image
	_gp_tips: Laya.Image
	_lb_drop_tips: Laya.Label
	_img_shop: Laya.Image
	_img_shop_red: Laya.Image
	_Group2: Laya.Box
	_img_drop: Laya.Image
	_Label1: Laya.Label
	_reward_con: Laya.Panel
	_gp_room_con: Laya.Box
	first_bg: Laya.Image
	_lb_first_blood: Laya.Label
	public GetComponents() {
		[
			this._bg,
			this._Group1,
			this._gp_model_con,
			this._Image1,
			this._lb_boss_name,
			this._gp_attention,
			this._Image3,
			this.attention,
			this.lb_atten,
			this._btn_drop,
			this._gp_tips,
			this._lb_drop_tips,
			this._img_shop,
			this._img_shop_red,
			this._Group2,
			this._img_drop,
			this._Label1,
			this._reward_con,
			this._gp_room_con,
			this.first_bg,
			this._lb_first_blood,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_Group1",
				"_gp_model_con",
				"_Image1",
				"_lb_boss_name",
				"_gp_attention",
				"_Image3",
				"attention",
				"lb_atten",
				"_btn_drop",
				"_gp_tips",
				"_lb_drop_tips",
				"_img_shop",
				"_img_shop_red",
				"_Group2",
				"_img_drop",
				"_Label1",
				"_reward_con",
				"_gp_room_con",
				"first_bg",
				"_lb_first_blood",
			])
	}
}
window["BossAbyssEnterView"] = BossAbyssEnterView