import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BossModel } from "../commonModel/BossModel"
import { FirstBloodModel } from "../commonModel/FirstBloodModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel } from "../commonModel/ShopModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { BossFieldRoomItem } from "./BossFieldRoomItem"
import { BossFieldRewardItem } from "./BossFieldRewardItem"

export class BossFieldEnterView extends BaseItem1 {
	timer
	boss_id
	boss_info
	boss_type
	boss_type2
	boss_type3
	color_shape
	model: BossModel
	monter_res
	request_timer
	room_item:BossFieldRoomItem
	select_boss_id
	select_boss_type
	show_model
	is_zero

	res_mgr: RoleManager
	goods_model: GoodsModel
	attention_state
	reward_item_list = []

	public constructor(parent?) {
		super(parent)

		this.base_file = "bossField"
		this.layout_file = "BossFieldEnterView"
		this.layer_value = Enum_UILayer.UI
		this.boss_type = BossModel.BossType.field
		this.boss_type2 = BossModel.BossType.fieldspecial
		this.boss_type3 = BossModel.BossType.field_infinite
		this.select_boss_type = BossModel.BossType.field

		this.model = BossModel.GetInstance()
		this.res_mgr = RoleManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			SetHtmlStyle(this._lb_vit, { f: 20, c: "#ffffff", ww: false, w: 483 })
			this.LoadSuccess()
			// this.RegisterMask(this._gp_show_reward_con)
		}
	}

	LoadSuccess = () => {

		// if (PlatformManager.IsEyouEnPlatform()) {
		// 	this._lb_first_blood.fontSize = 18
		// 	this._lb_drop_tips.fontSize = 18
		// 	this.vit.size = 18
		// }
		// if (PlatformManager.IsEyouIdnPlatform()) {
		// let csf = this._lb_boss_name.GetComponent("ContentSizeFitter")
		// csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize
		// this.vit.size  = 20
		// }
		this._panel_reward.vScrollBarSkin = ""
		this.InitEvent()
		this.InitView()
		this.initRequestTimer()
		this.UpdateView(false)
		this.ShowShop()
		this.CheckShopRed()
	}

	InitEvent = () => {

		this.BindEvent(this.model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {
			let bool = this.model.GuideTaskDone()
			if (boss_type == this.boss_type && bool) {
				this.UpdateView(true)
			}

			if (boss_type == this.boss_type2 && !bool) {
				this.UpdateView(true)
			}


			if (boss_type == this.boss_type3 && bool) {
				this.UpdateView(true)
			}
		}
		)

		this.BindEvent(this.model, BossModel.UPDATE_REMIND_STATE, (boss_type?, boss_id?) => {
			if ((boss_type == this.boss_type || boss_type == this.boss_type2) && boss_id == this.boss_id) { //
				this.UpdateRemindState()
			}
		}
		)

		Util.AddClickEvent(this._img_attention, () => {
			let state = !this.attention_state && 1 || 0
			this.model.Fire(BossModel.SCMD_REQUEST, 46007, this.select_boss_type, this.boss_id, state,0)
		}
			, this, true)

		Util.AddClickEvent(this._img_drop, () => {
			this.model.Fire(BossModel.OPEN_DROP_RECORD_VIEW)
		}
			, this, true)

		Util.AddClickEvent(this._img_shop, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldSoulShopView")
		}
			, this, true)



		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
			if (vo.currency_id == 36240001) {
				this.CheckShopRed()
			}
		}
		)

		this.model.Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
	}

	initRequestTimer = () => {
		this.RemoveTimer()
		let loop_func = () => {
			if (this.model.GuideTaskDone()) {
				this.model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type)
				this.model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type3)
			} else {
				this.model.Fire(BossModel.SCMD_REQUEST, 46000, this.boss_type2)
			}
		}
		this.request_timer = GlobalTimerQuest.AddPeriodQuest(loop_func, 10, -1)
		loop_func()
	}

	RemoveTimer = () => {
		if (this.request_timer) {
			GlobalTimerQuest.CancelQuest(this.request_timer)
			this.request_timer = null
		}
	}

	InitView = () => {
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_drop, GameResPath.GetIcon("suitboss", "uimh_024_1"))
		this.SetRoomType()
	}

	SetRoomType = () => {
		this.SetRoom("BossFieldRoomItem")
	}

	SetRoom = (room_class_name) => {
		let room_class: any = window[room_class_name]
		if (!room_class) return

		if (!this.room_item) {
			this.room_item = new room_class(this._box_room)
			this.room_item.Load()
		}
		let call_func = (boss?) => {
			this.SwitchView(boss)
		}
		this.room_item.SetClickCallBack(call_func)
		if (this.select_boss_id) {
			this.room_item.SetSelectBoss(this.select_boss_id)
		}
	}

	UpdateView = (is_init?) => {
		let boss_info
		let boss_info2
		if (this.model.GuideTaskDone()) {
			boss_info = Util.DeepCopy(this.model.GetBossTypeInfo(this.boss_type))
			boss_info2 = Util.DeepCopy(this.model.GetBossTypeInfo(this.boss_type3))

			if (!boss_info || !boss_info2) { return }
			let list = Util.DeepCopy(boss_info2.boss_info)
			boss_info.boss_info = list.concat(boss_info.boss_info)
		}else{
			boss_info = Util.DeepCopy(this.model.GetBossTypeInfo(this.boss_type2))
			if (!boss_info) { return }
		}
		
		if (this.room_item) {
			this.boss_info = boss_info
			this.room_item.SetData(boss_info, is_init,!this.model.GuideTaskDone())
		}
	}

	SwitchView = (info?) => {
		if (!info || !info.boss_id) {
			return
		}

		//let boss_cfg = Config.Bosscfg[info.boss_id]
		//if (! boss_cfg ) {
		//GameError:GetInstance():SendErrorToPHP("BossFieldEnterView can ! find boss cfg. id is = " + info.boss_id)
		//return
		//}

		this.boss_id = info.boss_id
		this.select_boss_type = info.boss_type

		let config_boss_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
		let boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.boss_id, false, config_boss_cfg)

		this._lb_boss_name.text = info.boss_name
		this._lb_boss_level.text = "LV." + info.lv
		let gp = <Laya.HBox>this._lb_boss_name.parent
		if (gp)
			gp.refresh()
		let reward_list = JSON.parse(info.ratio_goods)//ErlangParser.GetInstance().Parse(info.ratio_goods)

		let open_lv = info.open_lv
		let max_lv = info.max_lv
		let drop_lv = info.drop_lv
		let level = this.res_mgr.GetMainRoleVo().level
		let high_items = JSON.parse(info.item_hightlight)||[]


		let open_state = level >= open_lv && level <= max_lv
		this._img_attention.visible = this._lb_attention.visible = open_state

		this.is_zero = boss_cfg.layers == 0
		let can_drop = level - info.lv < drop_lv
		if (can_drop) {
			this._lb_drop_tips.visible = false
			this._lb_vit.visible = true
			if (PlatformManager.IsEyouIdnPlatform()) {
				this._lb_vit.innerHTML = "Konsumsi " + boss_cfg.tired_add + " Phys untuk bunuh Boss ini"
			} else {
				if (boss_cfg && boss_cfg.layers == 0) {
					this._lb_vit.innerHTML = "无限层大妖不消耗体力"
				}
				else {
					let hurt_limit = boss_cfg && boss_cfg.hurt_limit
					this._lb_vit.innerHTML = Util.StrToHTML("伤害达<font color='#eee661'>" + hurt_limit + "%</font>即可获得<font color='#eee661'>完整归属奖励</font>")// "击杀该大妖消耗" + boss_cfg.tired_add + "点体力"
				}
			}
			if(PlatformManager.IsEyouEnPlatform()){
				SetHtmlCenter(this._lb_vit, { x: 27, w: 483 })
			}else{
			SetHtmlCenter(this._lb_vit, { x: 3, w: 483 })
			}
		}
		else {
			this._lb_drop_tips.visible = true
			this._lb_vit.visible = false
		}

		this.UpdateRemindState()
		this.ShowRewardItem(reward_list,high_items)

		let merge_time = ServerTimeModel.GetInstance().GetMergeServerTime()
		let first_info = FirstBloodModel.GetInstance().GetShowFirstBlood(this.boss_id)
		let show_first_blood = (first_info && merge_time != null && merge_time <= 0) && true || false
		this._lb_first_blood.visible = show_first_blood
		this._img_bg4.visible = show_first_blood

		if (first_info && first_info.name.trim() != "") {
			this._lb_first_blood.text = "全服首次归属：" + first_info.name
		} else {
			this._lb_first_blood.text = "全服首次归属：暂无"
		}
		if (this.monter_res == info.icon) {
			return
		}
		this.monter_res = info.icon
		this.ShowModel()
	}

	ShowRewardItem = (reward_list?,high_items?) => {
		let career = this.res_mgr.GetMainRoleVo().career
		let _reward_list = []
		for (let key = 0; key < reward_list.length; key++) {
			let vo = reward_list[key]
			if (Number(vo[0]) == career) {
				_reward_list = vo[1]
				break
			}
		}
		let len = _reward_list.length
		let i = len
		if (i < this.reward_item_list.length) {
			do {
				this.reward_item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.reward_item_list.length)
			)
		}
		let list = []
		for (let _tmpi in _reward_list) {
			let vo = _reward_list[_tmpi]
			let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
			let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				table.insert(list, {
					type_id: goods_vo.type_id,
					goods_name: goods_vo.goods_name,
					color: goods_vo.color,
					count: vo[2],
					lock: lock,
					is_up:high_items&&high_items.indexOf(vo[1])!=-1||false
				}
				)
			}
		}

		if (!this.is_zero) {
			let act_goods = this.model.GetActiveDrop()
			if (act_goods) {
				let [type_id, lock] = this.goods_model.GetMappingTypeId(0, act_goods)
				let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					table.insert(list, {
						type_id: goods_vo.type_id,
						goods_name: goods_vo.goods_name,
						color: goods_vo.color,
						lock: lock,
						is_up:0
					}
					)
				}
			}
		}

		for (let index in list) {
			let vo = list[index]
			let item: BossFieldRewardItem = this.reward_item_list[index]
			if (!item) {
				item = new BossFieldRewardItem(this._panel_reward)
				this.reward_item_list[index] = item
				item.Load()
				item.SetPosition(Number(index) % 2 == 0 ? 0 : 97, Math.floor(Number(index) / 2) * 89)
			}
			item.SetData(vo)
			item.SetVisible(true)
		}
	}

	ShowModel = () => {
		let config_boss_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
		let cfg = BossModel.GetShowModelCfg(this.select_boss_type, this.monter_res, config_boss_cfg)

		let scale = 1
		let offset = new Vector3(0, 0, 0)
		if (cfg) {
			scale = cfg.scale
			offset = cfg.offset
		}

		let action_name_list = []
		// if (cfg) {
		// 	action_name_list = cfg.action_name_list || ["attack"]
		// }
		table.insert(action_name_list, "attack")
		table.insert(action_name_list, "idle")

		let data = {
			clothe_res_id: this.monter_res,
			type: UI_MODEL_TYPE.MONSTER,
			action_name_list: action_name_list,
			layout_file: "BossFieldEnterView"
		}
		ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
	}

	CustomMehod = (index?, args?) => {
		if (args && args[0]) {
			this.select_boss_id = Number(args[0])
		}
	}

	UpdateRemindState = () => {
		let info = this.model.GetBossInfo(this.select_boss_type, this.boss_id)
		if (!info) {
			return
		}
		this.attention_state = info.is_remind
		this.UpdateCbImage()
	}

	UpdateCbImage = () => {
		ResManager.GetInstance().SetImageSprite(this, this._img_attention, "common4", this.attention_state && "ui_26_2" || "ui_26")
	}

	ShowShop = () => {
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		this._img_shop.visible = lv >= 300
	}

	CheckShopRed = () => {
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
		this.RemoveTimer()
		// if (this.color_shape ) {
		// 	destroy(this.color_shape)
		// 	this.color_shape = null
		// }
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
		super.DeleteMe()
	}
	_box_model: Laya.Box
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_drop: Laya.Image
	_img_shop: Laya.Image
	_img_shop_red: Laya.Image
	_img_attention: Laya.Image
	_lb_boss_level: Laya.Label
	_lb_boss_name: Laya.Label
	_lb_title: Laya.Label
	_lb_attention: Laya.Label
	_lb_first_blood: Laya.Label
	_lb_drop_tips: Laya.Label
	_lb_vit: Laya.HTMLDivElement
	_box_room: Laya.Box
	_panel_reward: Laya.Panel
	public GetComponents() {
		[
			this._box_model,
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_drop,
			this._img_shop,
			this._img_shop_red,
			this._img_attention,
			this._lb_boss_level,
			this._lb_boss_name,
			this._lb_title,
			this._lb_attention,
			this._lb_first_blood,
			this._lb_drop_tips,
			this._lb_vit,
			this._box_room,
			this._panel_reward,
		]
			= this.GetChildrenByNames([
				"_box_model",
				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_drop",
				"_img_shop",
				"_img_shop_red",
				"_img_attention",
				"_lb_boss_level",
				"_lb_boss_name",
				"_lb_title",
				"_lb_attention",
				"_lb_first_blood",
				"_lb_drop_tips",
				"_lb_vit",
				"_box_room",
				"_panel_reward",
			])
	}
}
window["BossFieldEnterView"] = BossFieldEnterView