import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { EquipDefine } from "../commonModel/EquipModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { PlayerMessageEquipItem } from "../equip/PlayerMessageEquipItem"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { GameResPath } from "../util/GameResPath"
import { Util, SetSizeDeltaX, GlobalTimerQuest, SetSizeDelta, SetHtmlCenter, SetLocalPosition, SetLocalPositionX, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { FightCompareItem } from "./FightCompareItem"
import { PlayerMsgTabBtn } from "./PlayerMsgTabBtn"
import { BaseItem1 } from "../common/BaseItem1"
import { PlayerMessageDragonBall } from "../playerMessage/PlayerMessageDragonBall"
import { GuardActivateItem } from "../guard/GuardActivateItem"
import { PlayerMessageOutWard } from "../playerMessage/PlayerMessageOutWard"
import { PlayerMessageHolySealView } from "../playerMessage/PlayerMessageHolySealView"
import { PlayerMessageLongLanguageView } from "../playerMessage/PlayerMessageLongLanguageView"
import { PlayerMessageRevelationView } from "../playerMessage/PlayerMessageRevelationView"
import { PlayerMessagePetView } from "../playerMessage/PlayerMessagePetView"
import { PlayerMessageGodBefallView } from "../playerMessage/PlayerMessageGodBefallView"
import { TreasureExchangeItem } from "../runeTreasure/TreasureExchangeItem"
import { PlayerMessageLungView } from "../playerMessage/PlayerMessageLungView"
import { PlayerMessageRuneView } from "../playerMessage/PlayerMessageRuneView"
import { PlayerMessageUnreal } from "../playerMessage/PlayerMessageUnreal"
import { PlayerMessageGodbeast } from "../playerMessage/PlayerMessageGodbeast"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { table } from "../common/table"
import { PlayerMessageFaeriesItem } from "./PlayerMessageFaeriesItem"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { CommonManager } from "../common/CommonManager"


export class PlayerMessageView extends BaseView1 {

	CreateModel
	DeleteEquipItems
	InitEvent
	LoadSuccess
	ReOpen_callback
	Remove
	SelectIndex
	TabInfo
	_data
	_head_main
	back_login_toClose
	change_scene_close
	click_bg_toClose
	close_callback
	destroy_imm
	fightItem
	initEquip
	initTab
	is_center
	refresh_data
	show_open_movie
	time_id
	updateEquipItems
	updateView
	use_background

	_vip_icon_obj
	_icon_medal_obj
	destiny_img_trans
	_Image1_fight_bg
	UpdateGuard
	UpdateBaseGp
	BaseGp_item_list
	basegp_select
	UpdateIllusionGp
	UpdateIllusionShow
	illusion_item_list
	illusion_select
	petItem
	godBefallItem
	UpdateSecretTreasureGp
	secrettreasureitem
	fight_item
	UpdateFaeries
	item_list
	CheckFunIsOpen
	public constructor() {
		super()

		this.TabInfo = [
			{ index: 0, name: "玩家信息", title: "查看玩家信息", view_name: "" },
			{ index: 1, name: "幻化", title: "幻化信息", view_name: "" },
			{ index: 2, name: "通灵", title: "幻化信息", view_name: "SecretTreasureMainView" },
			{ index: 3, name: "式神", title: "幻化信息", view_name: "PartnerAwakeMainView"  },
			{ index: 4, name: "降神", title: "幻化信息", view_name: "GodBefallMainView"  },
			{ index: 5, name: "对比", title: "幻化信息", view_name: ""  }
		];

		let view_1_tab = [
			{index: 1, view_name : "DragonBallView"},
			{index: 2, view_name : "HolySealView"},
			{index: 3, view_name : "longlanguageView"},
		]

		let btn_name_tab = [
			"dragonBall_btn",
			"holySeal_btn",
			"shenji_btn",
		]

		let view_tab = [
			{index: 1, view_name : "SecretTreasureMainView"},
			{index: 2, view_name : "LungStoveMainView"},
			{index: 3, view_name : "UnrealBagView"},
			{index: 4, view_name : "GodBeastView"},
		]

		this.base_file = "playerMessage"
		this.layout_file = "PlayerMessageView"
		this.layer_value = Enum_UILayer.Activity
		this.change_scene_close = true
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.back_login_toClose = true
		this.refresh_data = false
		this.BaseGp_item_list = []
		this.basegp_select = 0
		this.illusion_item_list = []
		this.illusion_select = 0
		this.secrettreasureitem = []
		this.item_list = []
		let modelY = null
		let equip_item_list = []
		let attr_cfg = null
		let limit_cfg = null
		let god_equip_kv_cfg = null
		let role_model = null
		let _model = FriendModel.GetInstance()
		let offsetCfg = null
		let stageCfg = null
		let local_ResManager = ResManager.GetInstance()
		let tab_list = []
		let mainro = RoleManager.GetInstance().GetMainRoleVo()
		this.preload_client_config = { "ConfigPlayerMessageShow": false, "ClientEffDsgtShow": false }
		this.preload_server_config = { "config_equip_attr": false, "config_equip_strengthen_max": false, "config_dsgt": false, "config_god_equip_kv": false }
		// let arena_model = ArenaModel.GetInstance() 
		let common_mgr = CommonManager.GetInstance()
		let only_come_once = null

		this.load_callback = () => {
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)
			this.LoadSuccess()
			this.InitEvent()
		}

		this.ReOpen_callback = () => {
			this.CreateModel()
		}
		this.close_callback = () => {
			_model.SetplayerId(0)
			_model.cleanEquipRequestTime()
			this.Remove()
		}

		

		this.SelectIndex = (index?) => {
			this.baseGp.visible = false
			this.illusionGp.visible = false
			this.petGp.visible = false
			this.GodBefallGp.visible = false
			this.secrettreasureGp.visible = false
			this.fightGp.visible = false
			this.group_faeries.visible = false
			if (index == 0) {
				this.baseGp.visible = true
				this.UpdateBaseGp(1)
			} else if (index == 1) {
				_model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 5)
				this.illusionGp.visible = true
				this.UpdateIllusionGp(1)
			} else if (index == 2) {//通灵
				this.secrettreasureGp.visible = true
				let min_index = this.CheckFunIsOpen(view_tab, "secrettreasure_btn_", this.secrettreasure_tab)
				this.UpdateSecretTreasureGp(min_index)
			} else if (index == 3) {//神巫 妖灵
				this.petGp.visible = true
				this._model_group.visible = false
				if (!this.petItem) {
					this.petItem = new PlayerMessagePetView(this.petGp)
					this.petItem.SetData(this._data)
					this.petItem.Load()
				}
			} else if (index == 4) {//降神
				this.GodBefallGp.visible = true
				this._model_group.visible = false
				if (!this.godBefallItem) {
					this.godBefallItem = new PlayerMessageGodBefallView(this.GodBefallGp)
					this.godBefallItem.SetData(this._data)
					this.godBefallItem.Load()
				}

			} else if (index == 5) {
				this.fightGp.visible = true
				this._model_group.visible = false
				if (!this.fightItem) {
					this.fightItem = new FightCompareItem(this.fightGp)
					this.fightItem.InitData(this._data)
					this.fightItem.Load()
				}
				// _model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 5)

			}
			// if (!this.fightItem) {
			// 	this.fightItem = new FightCompareItem(this.fightGp)
			// 	this.fightItem.InitData(this._data)
			// 	this.fightItem.Load()
			// }
			// this.fightGp.visible = index == 1
			//this.titleLb.text = this.TabInfo[index].
			let source = ""
			if (index == 0) {
				source = "uifckwj_001"
			} else if (index == 1) {
				source = "uifckwj_001"
			} else if (index == 2) {
				source = "uifckwj_001"
			} else if (index == 3) {
				source = "uifckwj_001"
			} else if (index == 4) {
				source = "uifckwj_001"
			} else if (index == 5) {
				source = "ui_phb_003"
			}
			// let source = index == 0 && "uifckwj_001" || "ui_phb_003"
			ResManager.GetInstance().SetImageSprite(this, this.title_img, "playerMessage", source, true)
		}
		this.InitEvent = () => {
			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			// this.tabBtnList.on(Laya.Event.MOUSE_DOWN,(e?, a?) => {
			// 	this.SelectIndex(e.itemIndex)
			// }
			// , this)
			// Util.AddClickEvent(this.tabBtnList, (e?) => {
			// 	this.SelectIndex(e)
			// }
			// 	, this)

			// this.BindEvent(_model, FriendEvent.SELECT_TAB, (index?) => {
			// 	this.SelectIndex(index)
			// })

			Util.AddClickEvent(this.all_btn, () => {
				this.UpdateBaseGp(1)
			}, this, true)

			Util.AddClickEvent(this.dragonBall_btn, () => {
				this.UpdateBaseGp(2)
			}, this, true)

			Util.AddClickEvent(this.holySeal_btn, () => {
				this.UpdateBaseGp(3)
			}, this, true)

			Util.AddClickEvent(this.shenji_btn, () => {
				this.UpdateBaseGp(4)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_1, () => {
				this.UpdateIllusionGp(1)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_2, () => {
				this.UpdateIllusionGp(2)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_3, () => {
				this.UpdateIllusionGp(3)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_4, () => {
				this.UpdateIllusionGp(4)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_5, () => {
				this.UpdateIllusionGp(5)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_6, () => {
				this.UpdateIllusionGp(6)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_7, () => {
				this.UpdateIllusionGp(7)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_8, () => {
				this.UpdateIllusionGp(8)
			}, this, true)

			Util.AddClickEvent(this.illusion_icon_9, () => {
				this.UpdateIllusionGp(9)
			}, this, true)

			this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_GUARD, (scmd?) => {
				this.UpdateGuard(scmd)
			})

			this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_FAERIES_EVENT, (list?) => {
				this.UpdateFaeries(list)
			})
			

			this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_ILLUSION, (scmd?) => {
				// this.UpdateIllusionGp()
				this.UpdateIllusionShow(scmd)
			})

			Util.AddClickEvent(this.secrettreasure_btn_1, () => {
				this.UpdateSecretTreasureGp(1)
			}, this, true)

			Util.AddClickEvent(this.secrettreasure_btn_2, () => {
				this.UpdateSecretTreasureGp(2)
			}, this, true)

			Util.AddClickEvent(this.secrettreasure_btn_3, () => {
				this.UpdateSecretTreasureGp(3)
			}, this, true)

			Util.AddClickEvent(this.secrettreasure_btn_4, () => {
				this.UpdateSecretTreasureGp(4)
			}, this, true)
		}

		this.LoadSuccess = () => {
			only_come_once = true
			let SetElement = ()=> {
				this.guard_3.visible = false
				this.guard_4.visible = false
				SetLocalPosition(this.guard_1, 80, -120)
				SetLocalPosition(this.guard_2, 410, -120)
			}
			SetElement()
			this.SelectIndex(0)
			this._vip_icon_obj = this._vip_icon
			this._icon_medal_obj = this._icon_medal
			this.destiny_img_trans = this.destiny_img
			// this._Image1_fight_bg = this._fight_bg
			local_ResManager.SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("playerMessage", "ui_rwxx_basal_01"))
			local_ResManager.SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("friend", "uickwj_004"), true)
			// local_ResManager.SetOutsideImageSprite(this, this._banner_bg, GameResPath.GetIcon("friend", "ui_phb_ckxx_002"), true)
			local_ResManager.SetTexture(this, this.img_line, GameResPath.GetIcon("playerMessage", "com_line_1"))
			local_ResManager.SetTexture(this, this.illusionBg, GameResPath.GetIcon("playerMessage", "ui_rwxx_bg_04"))
			local_ResManager.SetTexture(this, this.image_faeries_bg, GameResPath.GetIcon("playerMessage", "bg_01"))
			SetLocalPosition(this.illusionBg, 12, 72)
			SetSizeDelta(this.illusionBg, 602, 680)
			//local_ResManager:SetOutsideImageSprite(this, this._stage_bg, GameResPath.GetIcon("friend","uickwj_003"),true)
			//local_ResManager:SetImageSprite(this, this._icon_bg, "friend_asset","uickwj_004",true)
			// local_ResManager.SetOutsideImageSprite(this, this._fight_bg, GameResPath.GetIcon("friend", "com_fight_fire_1"), true)

			// local_ResManager.SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("friend", "uickwj_002"), true)
			// local_ResManager.SetOutsideImageSprite(this, this._stage_bg, GameResPath.GetIconJpg("friend", "uifckwj_001n"), true)
			offsetCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigPlayerMessageShow", true)
			stageCfg = local_ResManager.GetGameConfigFromCache(this, "Achievementstarreward", false)
			attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			limit_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
			god_equip_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_equip_kv", false)
			modelY = this._model_group.y
			// SetLocalPositionX(this._guild_lb, this._gp_message.width / 2)
			this.initTab = () => {
				let index = 0
				for (let i = 0; i < this.TabInfo.length; i++) {
					let item = new PlayerMsgTabBtn(this.tabBtnList)
					item.Load()
					item.SetData(this.TabInfo[i], i, this._data.dummy_type)
					tab_list[i] = item
					item.ExcuteCallback(() => {
						Util.AddClickEvent(item.clickBox, () => {
							this.SelectIndex(i)
							_model.Fire(FriendEvent.SELECT_TAB, i)
						}
							, this)
						if(this.TabInfo[i].view_name == ""){
							item.SetVisible(true)
						}
						item.SetVisible(common_mgr.CheckFuncOpenState(this.TabInfo[i].view_name, true))
						RefBoxChildsLayout(this.tabBtnList, 0, 103, true, "left")
					})
				}
			}

			this.initEquip = () => {
				let group_con = null
				let item = null
				for (let i = 0; i < EquipDefine.EQUIP_COUNT; i++) {
					item = equip_item_list[i]
					if (!item) {
						group_con = i % 2 == 1 && this.equipment_right_group || this.equipment_left_group
						item = new PlayerMessageEquipItem(group_con)
						item.SetEquipPos(i + 1)
						item.Load()
						equip_item_list[i] = item
					}
				}
				this.updateView()
				this.updateEquipItems()
				this.UpdateBaseGp(1)
			}

			this.updateView = () => {
				if (!this._data) {
					return
				}
				// if (this._head_main == null) {
				// 	this._head_main = new CustomHeadItem(this.head)
				// 	this._head_main.Load()
				// }
				// this._head_main.SetRoleVoData(this._data)
				//容错
				FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 1)
				this._data.turn = this._data.turn || 0
				this._data.vip_flag = this._data.vip_flag || 0
				this._data.supreme_vip = this._data.supreme_vip || 0
				this._data.dsgt_id = this._data.dsgt_id || 0
				this._data.combat = this._data.combat || 0
				this._data.equip_list = this._data.equip_list || {}
				this._data.figure_list = this._data.figure_list || {}
				this._name_lb.text = this._data.name
				if (this._data.guild_name == "") {
					this._guild_lb.text = "未加入结社"
				} else if (this._data.guild_name && this._data.position_name) {
					this._guild_lb.text = this._data.guild_name + "[" + this._data.position_name + "]"
				} else {
					this._guild_lb.text = ""
				}
				let lv = this._data.level > 370 && this._data.level - 370 || this._data.level
				if (PlatformManager.IsEyouEnPlatform()) {
					this._level_lb.text = "Lv." + lv
					// } else if (PlatformManager.GetInstance().IsEyouIdnPlatform() ) {
					// 	this._level_lb.text = "Lv." + lv
					// }else{
				} else {
					this._level_lb.text = lv + "级"
				}
				if (this._data.level > 370) {
					SetSizeDeltaX(this.destiny_img_trans, 33)
					this.destiny_img_trans.visible = true
				} else {
					SetSizeDeltaX(this.destiny_img_trans, 0)
					this.destiny_img_trans.visible = false
				}
				if (PlatformManager.IsEyouIdnPlatform()) {
					this._turn_lb.text = this._data.turn > 0 && "RKN" + this._data.turn || ""
				} else {
					this._turn_lb.text = this._data.turn > 0 && this._data.turn + "转" || ""
					let text = this._turn_lb.text
					if(text == ""){
						this._turn_lb.visible = false
					}else{
						this._turn_lb.visible = true
					}
				}
				
				RefBoxChildsLayout(this._Group2, 0, null, true, "center")
				let str
				let vip_Lv = this._data.vip_flag
				let is_hide_vip = this._data.is_hide_vip
				this._vip_icon_obj.visible = vip_Lv > 0
				if (this._vip_icon_obj.visible) {
					this._vip_icon_obj.width = 25
					if(is_hide_vip > 0){
						str = "VIP-x"
						// this._vip_icon_obj.transform.localScale = new Vector3(1.5, 1.5, 1.5)
						if (this._data.supreme_vip == 1) {
							str = "SVIP-x"
							// this._vip_icon_obj.transform.localScale = new Vector3(1, 1, 1)
						}
					}
					else{
						str = "uivip_zjm_" + vip_Lv
						// this._vip_icon_obj.transform.localScale = new Vector3(1.5, 1.5, 1.5)
						if (this._data.supreme_vip == 1) {
							str = "VIP_" + vip_Lv
							// this._vip_icon_obj.transform.localScale = new Vector3(1, 1, 1)
						}
					}
					ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str, true)
				} else {
					this._vip_icon_obj.width = 0
				}
				this.ClearUIEffect(this._gp_title)
				this._title_img.visible = false
				let dsgt_info_list = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", true)
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientEffDsgtShow", true)
				this._gp_title.visible = this._data.dsgt_id > 0
				let dsgt = dsgt_info_list[this._data.dsgt_id]
				if (dsgt && this._gp_title.visible) {
					if (dsgt.type == 1) {
						let cfg = cfgs["PlayerMessageView"][dsgt.id]
						if (!cfg) {
							cfg = cfg["PlayerMessageView"]["def"]
						}
						this.AddUIEffect(dsgt.resource_id, this._gp_title, { x: cfg.x, y: cfg.y }, cfg.scale, true, null, null, null, null, null, null, null, false)
					} else {
						this._title_img.visible = true
						let url = "resource/game/dsgtIcon/" + dsgt.resource_id + ".png"
						local_ResManager.SetOutsideImageSprite(this, this._title_img, url, true, () => {
							if (dsgt.main_type == 7) {
								this._title_img.width = 250
								this._title_img.height = 65
								let name = this._data.marriage_name
								let title = name + "的伴侣"
								this._lb_title.text = title
								// LayoutRebuilder(this._lb_title)
								// SetSizeDeltaX(this._title_img, this._lb_title.width + 80)
							} else {
								this._lb_title.text = ''
								// SetSizeDeltaX(this._title_img, 0)
							}
						})
					}
				}

				if(this.fight_item)this.fight_item.Updatefighting(this._data.combat)
				this.CreateModel()
				//this._icon_medal_obj.visible = this._data.achv_stage > 0 
				//if (this._icon_medal_obj.visible ) {
				//let _cfg = stageCfg && stageCfg[this._data.achv_stage]
				//if (_cfg ) {
				//local_ResManager:SetImageSprite(this, this._icon_medal,"achv_asset", "image_" + _cfg.pic)
				//}
				//}
				if (this.time_id) {
					GlobalTimerQuest.CancelQuest(this.time_id)
					this.time_id = null
				}
				this.time_id = GlobalTimerQuest.AddDelayQuest(() => {
					// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._gp_message)
				}, 0.2)

				//假人暂时屏蔽评分
				if (0 == this._data.role_id && tab_list[2]) {
					tab_list[2].SetVisible(false)
				}
			}

			this.updateEquipItems = () => {
				if (!limit_cfg) {
					return
				}
				let _attr_cfg = null
				let _limit_cfg = null
				let item = null
				let equip = null
				let equipInfos = _model.processEquipListData(this._data.equip_list)

				for (let i = 0; i < EquipDefine.EQUIP_COUNT; i++) {
					let pos = EquipDefine.EQUIP_POS[i]
					item = equip_item_list[pos - 1]
					equip = equipInfos[pos]
					if (equip) {
						if (equip.type_id == 319) {
							item.SetData(null, this._data.role_id, this._data.server_id)
						} else {
							let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
							_attr_cfg = Config.GetConfigVo("config_equip_attr", equip.type_id, false, attr_cfg)
							if (!_attr_cfg) {
								break
							}
							_limit_cfg = limit_cfg[_attr_cfg.stage + "@" + equip.color + "@" + equip.cell]
							item.SetCfgs(_limit_cfg, _attr_cfg, god_equip_kv_cfg)
							item.SetData(equip, this._data.role_id, this._data.server_id)
						}
					} else {
						item.SetData(null, this._data.role_id, this._data.server_id)
					}
				}
			}

			this.DeleteEquipItems = () => {
				for (let key in equip_item_list) {

					if (equip_item_list[key]) {
						let item = equip_item_list[key]
						item.DeleteMe()
					}
				}
				equip_item_list = []
			}

			this.CreateModel = () => {
				let call_back = () => {

				}

				let getTextureId = (vo?, type?) => {
					let model_res_list1 = vo.fashion_model_list
					if (model_res_list1 && !Util.IsTableEmpty(model_res_list1)) {
						for (let k = 0; k < model_res_list1.length; k++) {
							var v = model_res_list1[k]
							if (v.part_pos == type) {
								return v.fashion_model_id, v.fashion_chartlet_id
							}
						}
					}
					let model_res_list = vo.level_model_list
					if (model_res_list && !Util.IsTableEmpty(model_res_list)) {
						for (let k = 0; k < model_res_list.length; k++) {
							var v = model_res_list[k]
							if (v.part_pos == type) {
								return v.level_model_id, 0
							}
						}
					}
				}

				//  let head_res = mainro.GetRoleHeadId(this._data)
				// //let head_res, head_clothe_id = getTextureId(this._data, FashionPartPos.Head)
				let [role_res, role_color] = Util.GetRoleClotheId(this._data)
				// let model_id =mainro. GetRoleClotheId(this._data)
				// let weapon_res= mainro.GetWeaponClotheId(this._data)
				// let wing_res = mainro.GetFigureId(this._data.figure_list, FigureProtoVo.FigureType.Wing)
				let wing_res = Util.GetWingClotheId(this._data)
				// let horse_res = mainro.GetFigureId(this._data.figure_list, FigureProtoVo.FigureType.Horse)
				let type = SceneBaseType.Role
				let rotate = null
				let _scale = 250
				// if (horse_res && horse_res > 0 ) {
				// 	type =SceneBaseType.Include_Horse
				// 	rotate =new  Vector3(0,120,0)
				// 	_scale = 160
				// }
				let model_id = this._data.level_model_list[0].level_model_id
				let weapon_res = Util.GetWeaponClotheId(this._data)
				let back_ornament_res = Util.GetBackOrnamentId(this._data)
				// let head_res=this._data.level_model_list[2].level_model_id
				let [head_res, head_texture_id] = Util.GetRoleHeadId(this._data)
				let liveness_id = Util.GetLivenessId(this._data)
				let data = {
					type: 1,//这个type是2就无法显示model
					career: this._data.career,
					sex: this._data.sex,
					scale: 0.74,
					position: new Vector3(0.4, 0.75, 0),

					clothe_res_id: role_res,
					fashion_model_id: role_res,
					texture_id: role_color,

					weapon_res_id: weapon_res,
					weapon_clothe_id: 0,

					wing_id: wing_res,

					head_wear_id: head_res,
					head_clothe_id: head_texture_id ? head_texture_id : 0,

					back_ornament_id: back_ornament_res,
					
					// liveness_id: liveness_id,
				}
				ResManager.GetInstance().SetRoleModel(this, this._model_group, data)
			}

			if (!this._data) {
				this.refresh_data = true
			} else {
				this.initTab()
				this.initEquip()
			}
		}
		//二级页签
		this.UpdateBaseGp = (index?) => {
			this.illusionGp.visible = false
			this.msgGp.visible = false
			this.fightGp.visible = false
			this.longlanguage.visible = false
			this.holyseal.visible = false
			this.dragonball.visible = false
			let base_item = this.BaseGp_item_list[index]
			this._model_group.visible = false
			if (index == 1) {
				this.msgGp.visible = true
				this._model_group.visible = true
			} else if (index == 2) {
				this.dragonball.visible = true
				if (!base_item) {
					base_item = new PlayerMessageDragonBall(this.dragonball)
					this.BaseGp_item_list[index] = base_item
					base_item.Load()
					base_item.ExcuteCallback(() => {
						base_item.SetData(this._data)
						FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 2)
					})
				} else {
					FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 2)
				}
			} else if (index == 3) {
				this.holyseal.visible = true
				if (!base_item) {
					base_item = new PlayerMessageHolySealView(this.holyseal)
					this.BaseGp_item_list[index] = base_item
					base_item.Load()
					base_item.ExcuteCallback(() => {
						base_item.SetData(this._data)
						FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 3)
					})
				} else {
					FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 3)
				}
			} else if (index == 4) {
				this.longlanguage.visible = true
				if (!base_item) {
					base_item = new PlayerMessageLongLanguageView(this.longlanguage)
					this.BaseGp_item_list[index] = base_item
					base_item.Load()
					base_item.ExcuteCallback(() => {
						base_item.SetData(this._data)
						FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 4)
					})
				} else {
					FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 4)
				}
			}

			for (let i = 1; i < 5; i++) {
				if (i == index) {
					this["select_" + i].visible = true
				} else {
					this["select_" + i].visible = false
				}
			}
			this.group_faeries.visible = index == 1 ? true : false
			let min_index = this.CheckFunIsOpen(view_1_tab, btn_name_tab, this.self_tabGp) //这里默认第一个不会被隐藏，所以不需要处理
		}

		//仙灵
		this.UpdateFaeries = (scmd) =>{
			let fairy_list = scmd.fairy_list
			table.sort(fairy_list, (a?, b?) => {
				return a.type < b.type
			})
			for (let idx in fairy_list) {
				let index = Number(idx)
				let data = fairy_list[index]
				let item = this.item_list[index]
				if(!item){
					item = new PlayerMessageFaeriesItem(this.group_faeries)
					this.item_list[index] = item
					item.SetPosition(122 * index, -10)
					item.Load()
				}
				item.ExcuteCallback(() => {
					item.SetDate(index, data)
				})
			}
		}

		//设置属性是否激活
		//1.2 是低级属性
		//3.4 是高级属性
		this.UpdateGuard = (scmd) => {
			let guard_arry = scmd.magic_circle
			let guard_dic = []
			let init = () =>{
				for(let i = 1;  i < 3; i++){
					this["lb_guard_" + i].color = "#898989"
					this["lb_guard_" + i].text = "未激活"
					ResManager.GetInstance().SetImageSprite(this, this["img_guard_" + i], "playerMessage_asset", "guard" + i, false)
				}
			}
			init()
			let guard_proproty:{[key : string]: any} = {
				lv:undefined,
				type:undefined,
				is_open:undefined,
				type_id:undefined,
				img_name:undefined,
				is_active_text:undefined,
				is_active_text_colot:undefined
			}
			if(guard_arry.length <= 0){
				return
			}
			for (let key in guard_arry) {
				guard_proproty = {}
				let lv = guard_arry[key].lv
				let is_open = guard_arry[key].is_open
				if(lv == 1 || lv == 2){
					guard_proproty.type = "low_type"
				}else if(lv == 3 || lv == 4){
					guard_proproty.type = "height_type"
				}
				guard_proproty.lv = lv
				guard_proproty.is_open = is_open
				guard_proproty.type_id = lv % 2 > 0 ? 1 : 2
				guard_proproty.img_name = "guard" + lv

				if(is_open == 1){
					guard_proproty.is_active_text = "已激活"
					guard_proproty.is_active_text_colot = "#0EC658"
				}else{
					guard_proproty.is_active_text = "未激活"
					guard_proproty.is_active_text_colot = "#898989"
				}
				table.insert(guard_dic,guard_proproty)
			}
			//写具体的图片更换逻辑
			for (let key in guard_dic) {
				let type_id = guard_dic[key].type_id
				this["lb_guard_" + type_id].color = guard_dic[key].is_active_text_colot
				this["lb_guard_" + type_id].text = guard_dic[key].is_active_text
				ResManager.GetInstance().SetImageSprite(this, this["img_guard_" + type_id], "playerMessage_asset", guard_dic[key].img_name, false)
			}
		}

		//幻化二级页签
		this.UpdateIllusionGp = (index?) => {
			let check_fun = () => {
				if(!only_come_once){
					return
				}
				let view_name_tab = []
				let view_name = null
				for(let k = 1; k < 9; k++){
					if(k == 1){
						view_name = "FashionBaseView"
					}else if(k == 2) {
						view_name = "RevelationEquipView"
					}else if(k == 3) {
						view_name = "WingsComponentView"
					}else if(k == 4) {
						view_name = "ArtifactComponentView"
					}else if(k == 5) {
						view_name = "HolyDeviceComponentView"
					}else if(k == 6) {
						view_name = "HorseComponentView"
					}else if(k == 7) {
						view_name = "PartnerComponentView"
					}else if(k == 8) {
						view_name = "BackOrnamentComponentView"
					}
					table.insert(view_name_tab, view_name)
				}
				//这里单独写，写在一起的话有点然在一起了
				for (let index in view_name_tab) {
					let i = Number(index)
					let btn_str = "box_" + (i + 2)
					this[btn_str].visible = common_mgr.CheckFuncOpenState(view_name_tab[i], true)
					RefBoxChildsLayout(this.box_top, 20, null, true, "center")
					RefBoxChildsLayout(this.box_bottom, 20, null, true, "center")
				}
				SetLocalPosition(this.illusion_tab, -15, 706)
				only_come_once = false
			}
			check_fun()
			this.illusion_allGp.visible = false
			if (index == 1) {
				this._model_group.visible = true
				this.illusion_allGp.visible = true
			} else {
				this._model_group.visible = false
			}
			this.baseGp.visible = false
			this.group_faeries.visible = false
			for (let i = 1; i < 10; i++) {
				if (index == i) {
					this["illusion_select_" + i].visible = true
				} else {
					this["illusion_select_" + i].visible = false
				}
			}
			let illusion_item = this.illusion_item_list[index]
			for (let key in this.illusion_item_list) {
				if (this.illusion_item_list[key] && this.illusion_item_list[key].display_obj) {
					this.illusion_item_list[key].display_obj.visible = false
				}
			}
			let type_id = null
			if (index == 8) {
				type_id = 2
			} else if (index == 7) {
				type_id = 1
			}
			else if (index == 6) {
				type_id = 5
			}
			else if (index == 5) {
				type_id = 4
			}
			else if (index == 4) {
				type_id = 3
			} else if (index == 2) {
				type_id = 6 //人物时装
			} else if(index == 9){
				type_id = 12
			}
			if (index == 1) return
			if (!illusion_item) {
				if (index == 3) {
					illusion_item = new PlayerMessageRevelationView(this.other_illusionGp)
				} else {
					illusion_item = new PlayerMessageOutWard(this.other_illusionGp)
				}
				this.illusion_item_list[index] = illusion_item
				illusion_item.SetData(type_id, this._data)
				illusion_item.Load()
				illusion_item.ExcuteCallback(() => {
					if (index == 3) {
						_model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 6)
					} else {
						_model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this._data.server_id, this._data.role_id, 5)
					}
				})
			} else if (illusion_item.display_obj) {
				illusion_item.display_obj.visible = true
			}

			
		}

		this.UpdateIllusionShow = (scmd) => {
			this.illusion_number.innerHTML = "幻化激活总数量：<font color = '#88ff43'>" + scmd.illusion_num.toString() + "</font>"
			let info = null
			for (let key in scmd.fashion_pos) {
				if (scmd.fashion_pos[key].pos_id == 1)
					info = scmd.fashion_pos[key]
			}
			this.fashion_lv.innerHTML = "时装等级：<font color = '#88ff43'>Lv." + info.pos_lv.toString() + "</font>"
			this.lb_fight.text = scmd.sum_power

		}

		//通灵二级页签选择
		this.UpdateSecretTreasureGp = (index?) => {
			this.runeGp.visible = false
			this.lungGp.visible = false
			this.godbestGp.visible = false
			this.umrealbagGp.visible = false
			this._model_group.visible = false
			for (let i = 1; i < 5; i++) {
				if (index == i) {
					this["secrettreasure_select_" + i].visible = true
				} else {
					this["secrettreasure_select_" + i].visible = false
				}
			}
			let item = this.secrettreasureitem[index]
			if (index == 1) {
				this.runeGp.visible = true
				if (!item) {
					item = new PlayerMessageRuneView(this.runeGp)
					item.SetData(this._data)
					item.Load()
					this.secrettreasureitem[index] = item
				}
			} else if (index == 2) {
				this.lungGp.visible = true
				if (!item) {
					item = new PlayerMessageLungView(this.lungGp)
					item.SetData(this._data)
					item.Load()
					this.secrettreasureitem[index] = item
				}
			} else if (index == 4) {
				this.godbestGp.visible = true
				if (!item) {
					item = new PlayerMessageGodbeast(this.godbestGp)
					item.SetData(this._data)
					item.Load()
					this.secrettreasureitem[index] = item
				}
			} else if (index == 3) {
				this.umrealbagGp.visible = true
				if (!item) {
					item = new PlayerMessageUnreal(this.umrealbagGp)
					item.SetData(this._data)
					item.Load()
					this.secrettreasureitem[index] = item
				}
			}
		}

		this.CheckFunIsOpen = (view_table?, btn?, box?) =>{
			let bool = false
			let index_tab = []
			for (let key in view_table) {
				let i = Number(key)
				if(common_mgr.CheckFuncOpenState(view_table[i].view_name, true)){
					bool = true
					table.insert(index_tab, i + 1)
				}else{
					bool = false
				}
				if(typeof(btn) == "string"){
					this[btn + (i + 1)].visible = bool
				}else if(typeof(btn) == "object") {
					this[btn[i]].visible = bool
				}
				RefBoxChildsLayout(box, 30, null, true, "center")
			}

			if(index_tab.length > 0){
				let sort = (a?,b?)=>{
					return a < b
				}
				table.sort(index_tab, sort)
				let min_inx = index_tab[0]
				return min_inx
			}
			return -1
		}

		this.Remove = () => {
			stageCfg = null
			limit_cfg = null
			this.DeleteEquipItems()

			if(this.fight_item){
                this.fight_item.DeleteMe()
                this.fight_item = null
            }


			if (this.fightItem) {
				this.fightItem.DeleteMe()
				this.fightItem = null
			}

			// if (this._head_main) {
			// 	this._head_main.DeleteMe()
			// 	this._head_main = null
			// }

			for (let key in this.BaseGp_item_list) {
				if (this.BaseGp_item_list[key]) {
					this.BaseGp_item_list[key].DeleteMe()
					this.BaseGp_item_list[key] = null
				}
			}

			for (let key in this.illusion_item_list) {
				if (this.illusion_item_list[key]) {
					this.illusion_item_list[key].DeleteMe()
					this.illusion_item_list[key] = null
				}
			}

			for (let key in this.item_list) {
				if (this.item_list[key]) {
					this.item_list[key].DeleteMe()
					this.item_list[key] = null
				}
			}

			for (let k in tab_list) {
				var v = tab_list[k]
				v.DeleteMe()
			}
			tab_list = []
			FriendModel.GetInstance().now_select_index = 1
			this.refresh_data = false
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}

			if (this.godBefallItem) {
				this.godBefallItem.DeleteMe()
				this.godBefallItem = null
			}
			if (this.petItem) {
				this.petItem.DeleteMe()
				this.petItem = null
			}

			if (this.secrettreasureitem) {
				for (let key in this.secrettreasureitem) {
					this.secrettreasureitem[key].DeleteMe()
				}
				this.secrettreasureitem = []
			}
		}


	}

	public setData(data?) {

		this._data = data
		if (this.refresh_data) {
			this.initTab()
			this.initEquip()
		}
	}



	_Image2: Laya.Image
	_Image1: Laya.Image
	_Image31: Laya.Image
	_Group1: Laya.Box
	_Image3: Laya.Image
	titleLb: Laya.Label
	title_img: Laya.Image
	_Image4: Laya.Image
	baseGp: Laya.Box
	msgGp: Laya.Box
	_stage_bg: Laya.Image
	_bg: Laya.Image
	_banner_bg: Laya.Image
	_icon_bg: Laya.Image
	_icon_medal: Laya.Image
	_fight_bg: Laya.Image
	_gp_message: Laya.Box
	_vip_icon: Laya.Image
	_name_lb: Laya.Label
	_Group2: Laya.Box
	_turn_lb: Laya.Label
	destiny_img: Laya.Image
	_level_lb: Laya.Label
	_guild_lb: Laya.Label
	equipment_left_group: Laya.VBox
	equipment_right_group: Laya.VBox
	_title_img: Laya.Image
	_gp_title: Laya.Box
	_lb_title: Laya.Label
	_gp_fight: Laya.Box
	head: Laya.Box
	Imag: Laya.Image
	guardGp: Laya.Box
	guard_1: Laya.Box
	img_guard_1: Laya.Image
	lb_guard_1: Laya.Label
	guard_2: Laya.Box
	img_guard_2: Laya.Image
	lb_guard_3: Laya.Label
	guard_3: Laya.Box
	img_guard_3: Laya.Image
	lb_guard_2: Laya.Label
	guard_4: Laya.Box
	img_guard_4: Laya.Image
	lb_guard_4: Laya.Label
	img_line: Laya.Image
	longlanguage: Laya.Box
	holyseal: Laya.Box
	dragonball: Laya.Box
	self_tabGp: Laya.Box
	all_btn: Laya.Box
	select_1: Laya.Image
	icon_1: Laya.Image
	dragonBall_btn: Laya.Box
	select_2: Laya.Image
	icon_2: Laya.Image
	holySeal_btn: Laya.Box
	select_3: Laya.Image
	icon_3: Laya.Image
	shenji_btn: Laya.Box
	select_4: Laya.Image
	icon_4: Laya.Image
	illusionGp: Laya.Box
	illusion_allGp: Laya.Box
	illusionBg: Laya.Image
	lb_fight: Laya.Label
	model_role: Laya.Box
	illusion_number: Laya.HTMLDivElement
	fashion_lv: Laya.HTMLDivElement
	btn: Laya.Box
	img_btn: Laya.Image
	other_illusionGp: Laya.Box
	illusion_tab: Laya.Box
	illusion_select_1: Laya.Image
	illusion_icon_1: Laya.Image
	illusion_select_2: Laya.Image
	illusion_icon_2: Laya.Image
	illusion_select_3: Laya.Image
	illusion_icon_3: Laya.Image
	illusion_select_4: Laya.Image
	illusion_icon_4: Laya.Image
	illusion_select_5: Laya.Image
	illusion_icon_5: Laya.Image
	illusion_select_6: Laya.Image
	illusion_icon_6: Laya.Image
	illusion_select_7: Laya.Image
	illusion_icon_7: Laya.Image
	illusion_select_8: Laya.Image
	illusion_icon_8: Laya.Image
	illusion_select_9: Laya.Image
	illusion_icon_9: Laya.Image
	petGp: Laya.Box
	GodBefallGp: Laya.Box
	secrettreasureGp: Laya.Box
	secrettreasure_tab: Laya.Box
	secrettreasure_btn_1: Laya.Box
	secrettreasure_select_1: Laya.Image
	secrettreasure_btn_2: Laya.Box
	secrettreasure_select_2: Laya.Image
	secrettreasure_btn_3: Laya.Box
	secrettreasure_select_3: Laya.Image
	secrettreasure_btn_4: Laya.Box
	secrettreasure_select_4: Laya.Image
	runeGp: Laya.Box
	lungGp: Laya.Box
	umrealbagGp: Laya.Box
	godbestGp: Laya.Box
	fightGp: Laya.Box
	_model_group: Laya.Box
	_close_btn: Laya.Box
	tabBtnList: Laya.Box
	group_faeries: Laya.Box
	image_faeries_bg: Laya.Image
	box_top: Laya.Box
	box_bottom: Laya.Box
	box_1 : Laya.Box
	box_2 : Laya.Box
	box_3 : Laya.Box
	box_4 : Laya.Box
	box_5 : Laya.Box
	box_6 : Laya.Box
	box_7 : Laya.Box
	box_8 : Laya.Box
	box_9 : Laya.Box

	public GetComponents() {
		[
			this._Image2,
			this._Image1,
			this._Image31,
			this._Group1,
			this._Image3,
			this.titleLb,
			this.title_img,
			this._Image4,
			this.baseGp,
			this.msgGp,
			this._stage_bg,
			this._bg,
			this._banner_bg,
			this._icon_bg,
			this._icon_medal,
			this._fight_bg,
			this._gp_message,
			this._vip_icon,
			this._name_lb,
			this._Group2,
			this._turn_lb,
			this.destiny_img,
			this._level_lb,
			this._guild_lb,
			this.equipment_left_group,
			this.equipment_right_group,
			this._title_img,
			this._gp_title,
			this._lb_title,
			this._gp_fight,
			this.head,
			this.Imag,
			this.guardGp,
			this.guard_1,
			this.img_guard_1,
			this.lb_guard_1,
			this.guard_2,
			this.img_guard_2,
			this.lb_guard_3,
			this.guard_3,
			this.img_guard_3,
			this.lb_guard_2,
			this.guard_4,
			this.img_guard_4,
			this.lb_guard_4,
			this.img_line,
			this.longlanguage,
			this.holyseal,
			this.dragonball,
			this.self_tabGp,
			this.all_btn,
			this.select_1,
			this.icon_1,
			this.dragonBall_btn,
			this.select_2,
			this.icon_2,
			this.holySeal_btn,
			this.select_3,
			this.icon_3,
			this.shenji_btn,
			this.select_4,
			this.icon_4,
			this.illusionGp,
			this.illusion_allGp,
			this.illusionBg,
			this.lb_fight,
			this.model_role,
			this.illusion_number,
			this.fashion_lv,
			this.btn,
			this.img_btn,
			this.other_illusionGp,
			this.illusion_tab,
			this.illusion_select_1,
			this.illusion_icon_1,
			this.illusion_select_2,
			this.illusion_icon_2,
			this.illusion_select_3,
			this.illusion_icon_3,
			this.illusion_select_4,
			this.illusion_icon_4,
			this.illusion_select_5,
			this.illusion_icon_5,
			this.illusion_select_6,
			this.illusion_icon_6,
			this.illusion_select_7,
			this.illusion_icon_7,
			this.illusion_select_8,
			this.illusion_icon_8,
			this.illusion_select_9,
			this.illusion_icon_9,
			this.petGp,
			this.GodBefallGp,
			this.secrettreasureGp,
			this.secrettreasure_tab,
			this.secrettreasure_btn_1,
			this.secrettreasure_select_1,
			this.secrettreasure_btn_2,
			this.secrettreasure_select_2,
			this.secrettreasure_btn_3,
			this.secrettreasure_select_3,
			this.secrettreasure_btn_4,
			this.secrettreasure_select_4,
			this.runeGp,
			this.lungGp,
			this.umrealbagGp,
			this.godbestGp,
			this.fightGp,
			this._model_group,
			this._close_btn,
			this.tabBtnList,
			this.group_faeries,
			this.image_faeries_bg,
			this.box_top,
			this.box_bottom,
			this.box_1,
			this.box_2,
			this.box_3,
			this.box_4,
			this.box_5,
			this.box_6,
			this.box_7,
			this.box_8,
			this.box_9,
		]
			= this.GetChildrenByNames([

				"_Image2",
				"_Image1",
				"_Image31",
				"_Group1",
				"_Image3",
				"titleLb",
				"title_img",
				"_Image4",
				"baseGp",
				"msgGp",
				"_stage_bg",
				"_bg",
				"_banner_bg",
				"_icon_bg",
				"_icon_medal",
				"_fight_bg",
				"_gp_message",
				"_vip_icon",
				"_name_lb",
				"_Group2",
				"_turn_lb",
				"destiny_img",
				"_level_lb",
				"_guild_lb",
				"equipment_left_group",
				"equipment_right_group",
				"_title_img",
				"_gp_title",
				"_lb_title",
				"_gp_fight",
				"head",
				"Imag",
				"guardGp",
				"guard_1",
				"img_guard_1",
				"lb_guard_1",
				"guard_2",
				"img_guard_2",
				"lb_guard_3",
				"guard_3",
				"img_guard_3",
				"lb_guard_2",
				"guard_4",
				"img_guard_4",
				"lb_guard_4",
				"img_line",
				"longlanguage",
				"holyseal",
				"dragonball",
				"self_tabGp",
				"all_btn",
				"select_1",
				"icon_1",
				"dragonBall_btn",
				"select_2",
				"icon_2",
				"holySeal_btn",
				"select_3",
				"icon_3",
				"shenji_btn",
				"select_4",
				"icon_4",
				"illusionGp",
				"illusion_allGp",
				"illusionBg",
				"lb_fight",
				"model_role",
				"illusion_number",
				"fashion_lv",
				"btn",
				"img_btn",
				"other_illusionGp",
				"illusion_tab",
				"illusion_select_1",
				"illusion_icon_1",
				"illusion_select_2",
				"illusion_icon_2",
				"illusion_select_3",
				"illusion_icon_3",
				"illusion_select_4",
				"illusion_icon_4",
				"illusion_select_5",
				"illusion_icon_5",
				"illusion_select_6",
				"illusion_icon_6",
				"illusion_select_7",
				"illusion_icon_7",
				"illusion_select_8",
				"illusion_icon_8",
				"illusion_select_9",
				"illusion_icon_9",
				"petGp",
				"GodBefallGp",
				"secrettreasureGp",
				"secrettreasure_tab",
				"secrettreasure_btn_1",
				"secrettreasure_select_1",
				"secrettreasure_btn_2",
				"secrettreasure_select_2",
				"secrettreasure_btn_3",
				"secrettreasure_select_3",
				"secrettreasure_btn_4",
				"secrettreasure_select_4",
				"runeGp",
				"lungGp",
				"umrealbagGp",
				"godbestGp",
				"fightGp",
				"_model_group",
				"_close_btn",
				"tabBtnList",
				"group_faeries",
				"image_faeries_bg",
				"box_top",
				"box_bottom",
				"box_1",
				"box_2",
				"box_3",
				"box_4",
				"box_5",
				"box_6",
				"box_7",
				"box_8",
				"box_9",
			])
		this.illusion_number.style.fontSize = 18
		this.illusion_number.style.color = "#663915"
		this.illusion_number.style.wordWrap = false
		this.fashion_lv.style.fontSize = 18
		this.fashion_lv.style.color = "#663915"
		this.fashion_lv.style.wordWrap = false

		ResManager.GetInstance().LoadFont(this, "fighting_font", this.lb_fight, null, false)
	}
}
window["PlayerMessageView"] = PlayerMessageView