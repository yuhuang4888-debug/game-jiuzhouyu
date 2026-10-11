import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { BossModel } from "../commonModel/BossModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BossSuitRoomItem } from "./BossSuitRoomItem"
import { BossFieldRewardItem } from "../bossField/BossFieldRewardItem"
import { ShopModel } from "../commonModel/ShopModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"

export class BossSuitEnterView extends BaseItem1 {
	CustomMehod
	InitEvent
	InitView
	LoadSuccess
	SetRoom
	SetRoomType
	ShowModel
	ShowRewardItem
	SwitchView
	UpdateRemindState
	ReOpen_callback

	boss_type
	color_shape
	cur_boss_info
	cur_sorting_order
	model
	mon_icon
	reward_item_list
	room_item
	select_boss_id
	show_model
	cfg_boss
	cfg_type

	public constructor(parent?) {
		super(parent)
		this.base_file = "suitboss"
		this.layout_file = "BossSuitEnterView"

		this.boss_type = BossModel.BossType.suit
		this.reward_item_list = []
		this.model = BossModel.GetInstance()
		let local_BossBaseModel = BossModel
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.cfg_boss = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			this.cfg_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type", false)
			this.LoadSuccess()
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.Text.size = 20
				this.Text.lineSpacing = 0.5
				this.Text.verticalAlign = "middle"
				this.Text.textAlign = "center"
				SetSizeDelta(this.Text, 100, 50)
				SetAnchoredPosition(this.Text, 0, -18)
				SetAnchoredPositionX(this._btn_drop, 10)
			}
			*/
		}

		this.ReOpen_callback = () => {
			if (this.mon_icon) {
				this.ShowModel(this.mon_icon)
			}
		}

		this.LoadSuccess = () => {
			this._reward_con.vScrollBar.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_reward_bg, "resource/game/suitboss/other/ui_chief_qz4.png")
			this.model.suit_boss_first_status = false
			this.model.RefreshSuitRed(this.cfg_type)
			this.InitEvent()
			//this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this.InitView()
			this.ShowShop()
			this.CheckShopRed()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_shop, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldSoulShopView")
			}, this, true)
			this.BindEvent(this.model, local_BossBaseModel.UPDATE_BOSS_INFO, (boss_type?) => {
				if (boss_type == this.boss_type) {
					this.SetRoomType()
				}
			})

			Util.AddClickEvent(this._gp_model_con, () => {
				this.model.Fire(local_BossBaseModel.OPEN_TIPS_VIEW, this.select_boss_id)
			}, this, false)

			Util.AddClickEvent(this._gp_attention, () => {
				if (!this.cur_boss_info) { return }
				let state = this.cur_boss_info.is_remind
				if (!state) {
					if (this.model.suitboss_attention_num >= 5) {
						Message.show("最多只能关注5个蛮荒Boss")
						this.attention.visible = false
						return
					}
				}
				let status = state?0:1
				this.model.Fire(local_BossBaseModel.SCMD_REQUEST, 46007, this.boss_type, this.select_boss_id,status, 0)
			}, this)

			this.BindEvent(this.model, local_BossBaseModel.UPDATE_REMIND_STATE, (boss_type?, boss_id?) => {
				if ((this.cur_boss_info && boss_type == this.boss_type) && boss_id == this.cur_boss_info.boss_id) {
					this.UpdateRemindState()
				}
			})

			Util.AddClickEvent(this._btn_drop, () => {
				this.model.Fire(local_BossBaseModel.OPEN_DROP_RECORD_VIEW)
			}, this, true)

			// let show = false
			// let show_green_fun = (is_green?) => {
			// 	show = !show
			// 	if (this.color_shape) {
			// 		destroy(this.color_shape)
			// 		this.color_shape = null
			// 	}
			// 	if (show) {
			// 		if (!this.color_shape) {
			// 			this.color_shape = SetGreenOrBlackBg(this.form, is_green)
			// 		}
			// 	}
			// 	this._Group2.visible = !show
			// 	this._gp_drop.visible = !show
			// }
			// this.BindEvent(GlobalEventSystem, EventName.SHOW_GREEN_OR_BLACK_BG, show_green_fun)
		}

		this.InitView = () => {
			this.SetRoomType()
		}

		this.SetRoomType = () => {
			this.SetRoom(BossSuitRoomItem)
		}

		this.SetRoom = (room_class?) => {
			if (!this.room_item) {
				this.room_item = new room_class(this._gp_room_con)
				this.room_item.SetClickCallBack(this.SwitchView)
				if (this.select_boss_id) {
					this.room_item.SetSelectBoss(this.select_boss_id)
				}
				this.room_item.Load()
			}
		}

		this.SwitchView = (info?) => {
			this.cur_boss_info = info
			let cfg = this.cfg_boss[info.boss_id]
			this.select_boss_id = info.boss_id
			this._lb_boss_name.text = "Lv." + info.lv + " " + info.boss_name
			let reward_list = JSON.parse(cfg.ratio_goods)
			// let level = role_mgr.GetMainRoleVo().level
			// let open_lv = info.open_lv
			// let max_lv = info.max_lv
			//let open_state = level >= open_lv && level <= max_lv
			//this.Toggle_cbox_attention.isOn = info.is_remind
			this.attention.visible = info.is_remind
			let career = role_mgr.GetMainRoleVo().career
			let reward = []
			for (let key in reward_list) {
				let obj = reward_list[key]
				if (Number(obj[0]) == career) {
					reward = obj[1]
					break
				}
			}
			if (reward.length == 0) {
				reward = reward_list
			}
			let high_items =JSON.parse(info.item_hightlight)||[]
			this.ShowRewardItem(reward,high_items)
			if (this.mon_icon == info.icon) {
				return
			}
			this.mon_icon = info.icon
			this.ShowModel(info.icon)
		}

		this.ShowRewardItem = (reward_list?,high_items?) => {
			//let len = reward_list.length
			for (let _tmpi in this.reward_item_list) {
				let item = this.reward_item_list[_tmpi]
				item.SetVisible(false)
			}
			let list = []
			for (let _tmpi in reward_list) {
				let vo = reward_list[_tmpi]
				let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					table.insert(list, {
						type_id: goods_vo.type_id,
						goods_name: goods_vo.goods_name,
						color: goods_vo.color,
						count: vo[2],
						lock: lock,
						is_up:high_items&&high_items.indexOf(vo[1])!=-1||false
					})
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
			let len = list.length
			let i = len
			if (i < this.reward_item_list.length) {
				do {
					this.reward_item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.reward_item_list.length)
				)
			}
			for (let index in list) {
				let vo = list[index]
				let item: BossFieldRewardItem = this.reward_item_list[index]
				if (!item) {
					item = new BossFieldRewardItem(this._reward_con)
					this.reward_item_list[index] = item
					item.Load()
					item.SetPosition(Number(index) % 2 == 0 ? 0 : 97, Math.floor(Number(index) / 2) * 89)
				}
				item.SetData(vo)
				item.SetVisible(true)
			}
		}

		this.ShowModel = (mon_res?, ui_scale?) => {
			if (ui_scale == null) {
				ui_scale = 1
			}
			//if (this.show_model ) {
			//this.show_model.DeleteMe()
			//this.show_model = null
			//}
			//let pos = { x: 0, y: 0 }
			//let scale = ui_scale
			//let boss_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigBoss", true)
			//let cfg = local_BossBaseModel.GetShowModelCfg(this.boss_type, mon_res, boss_cfg)
			//if (cfg) {
			//	pos = cfg.offset
			//	scale = cfg.scale
			//}
			//let action_name_list = (cfg && cfg.action_name_list) && cfg.action_name_list || ["attack"]
			let action_name_list = ["attack"]
			table.insert(action_name_list, "idle")
			let data = {
				clothe_res_id: mon_res,
				type: UI_MODEL_TYPE.MONSTER,
				//layer_value: this.layer_value,
				//scale: 0.7 * scale,
				//position: pos,
				action_name_list: action_name_list,
				//custom_sorting_order = this.cur_sorting_order,
				layout_file:"BossSuitEnterView"
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)
			// this.CoverMode(this._Group2, this.layer_value, this.cur_sorting_order)
			// this.CoverMode(this._gp_drop, this.layer_value, this.cur_sorting_order)
			// this.CoverMode(this._scrl_show_reward_con, this.layer_value, this.cur_sorting_order)
		}

		this.CustomMehod = (index?, args?) => {
			this.select_boss_id = args && args[0]
		}

		this.UpdateRemindState = () => {
			let info = this.model.GetBossInfo(this.boss_type, this.cur_boss_info.boss_id)
			if (!info) {
				return
			}
			if (info.is_remind && !this.model.suit_boss_alert) {
				Alert.Show("关注成功，大妖复活时将会通知你。", Alert_Type.AlertTypeCheckBox, null, null, null, null, null, false, (bool?) => {
					this.model.suit_boss_alert = bool
				}, "本次登录不再提示", true)
			}
			this.attention.visible = info.is_remind
			if (info.is_remind) {
				this.model.suitboss_attention_num = this.model.suitboss_attention_num + 1
			} else {
				this.model.suitboss_attention_num = this.model.suitboss_attention_num - 1
			}
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
		if (this.show_model) {
			this.show_model.DeleteMe()
			this.show_model = null
		}

		this.mon_icon = false
		// if (this.color_shape) {
		// 	destroy(this.color_shape)
		// 	this.color_shape = null
		// }

		super.DeleteMe()
	}

	_Group1: Laya.Box
	_img_reward_bg: Laya.Image
	_Label1: Laya.Label
	_reward_con: Laya.Panel
	_Group3: Laya.Box
	_gp_model_con: Laya.Box
	_Image1: Laya.Image
	_lb_boss_name: Laya.Label
	_gp_attention: Laya.Box
	_Image3: Laya.Image
	attention: Laya.Image
	lb_atten: Laya.Label
	_gp_room_con: Laya.Box
	_btn_drop: Laya.Image
_img_shop:Laya.Image
_img_shop_red:Laya.Image
	public GetComponents() {
		[
			this._Group1,
			this._img_reward_bg,
			this._Label1,
			this._reward_con,
			this._Group3,
			this._gp_model_con,
			this._Image1,
			this._lb_boss_name,
			this._gp_attention,
			this._Image3,
			this.attention,
			this.lb_atten,
			this._gp_room_con,
			this._btn_drop,
this._img_shop,
this._img_shop_red,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_img_reward_bg",
				"_Label1",
				"_reward_con",
				"_Group3",
				"_gp_model_con",
				"_Image1",
				"_lb_boss_name",
				"_gp_attention",
				"_Image3",
				"attention",
				"lb_atten",
				"_gp_room_con",
				"_btn_drop",
"_img_shop",
"_img_shop_red",
			])
	}
}
window["BossSuitEnterView"] = BossSuitEnterView