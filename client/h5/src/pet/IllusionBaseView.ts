import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { FashionPartPos } from "../scene/SceneConfig"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, Util, GetSizeDeltaX, Trim, RefGridLayout, SetHtmlStyle, SetHtmlCenter } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { IllusionItem } from "./IllusionItem"
import { IllusionPropItem } from "./IllusionPropItem"
import { OutWardExpGoods } from "./OutWardExpGoods"
import { PetRoundItem } from "./PetRoundItem"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { PlatformManager } from "../PlatformManager"

export class IllusionBaseView extends BaseItem1 {
	update_bottom

	public _type //决定是什么幻化界面
	public _model_type

	/** 0有星星 1没有星星，显示阶数*/
	public ui_type = 0
	//0物品升阶 1经验升阶
	public upstage_type
	// public type_id

	public exp_goods_item_list
	public exp_goods_id_list = []
	public old_blessing = 0
	public goods_enough = false
	public buy_goods_id
	protected select_stage = 0
	protected select_index
	public auto_request
	public swicth_item = false
	public type_id
	public color_id = 0
	private giftItem: GiftPushIcon;

	private is_show_power_preview = false;

	color_shape

	Local_loadSuccess
	Local_InitEvent
	InitView
	SelectItem
	Local_SetModel
	Local_ClearModel
	SetSkillData
	SetPropData
	Local_SetUpStageData
	SetFightValue
	UpdateView
	SetSelectState
	SetBottomBtn
	CustomMehod
	Local_DeleteMe
	LoadEffect
	RefCost
	RefExpGoodsId
	exp_img_width = 274
	_ConfigIllusionModel
	fight_item
	public constructor(parent) {
		super(parent)

		let model_type_,
			outward_model_,
			upstage_item_: BaseAwardItem,
			skill_list_ = Array<PetRoundItem>(),
			item_list_ = {},
			prop_list_ = Array<IllusionPropItem>(),
			old_using_index_ = 0,
			illu_item_count_ = 0,
			message_flag_,
			is_play_ani_,
			is_max_,
			model_id_,
			ani_timer_list_ = [],
			skill_id_to_item_ = {},
			local_GlobalEventSystem = GlobalEventSystem,
			green_shape,
			layer_mgr = LayerManager.GetInstance()

		this.base_file = "pet"
		this.layout_file = "IllusionBaseView"
		this.layer_value = Enum_UILayer.UI
		let this_type_id = null
		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		let local_illusion_cfg = local_outwardModelIns.outward_illusion_cfg
		let local_redMgr = RedDotManager.GetInstance()
		let mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let local_outwardType = enum_OutWardType
		let local_goodsModel = GoodsModel
		let local_goodsModelIns = local_goodsModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let local_message = Message
		let local_json = JSON
		let local_wordMgr = WordManager
		let local_pre_client_cfg = Config.PRELOAD_CLIENT_CONFIG
		let model_name_ = null

		this.preload_client_config = {
			"ClientOutWardPos": false,
			"ClientOutWardModel": false,
			"ConfigIllusionModel": false
		}

		this.load_callback = () => {
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)
			this.LoadSuccess()
			this.InitEvent()
		}

		// this.ReOpen_callback = () => {
		// 	if (this.type_id) {
		// 		model_name_ = null
		// 		this_type_id = this.type_id
		// 		this.SetModel()
		// 	}
		// 	this.LoadEffect()
		// }

		this.Local_loadSuccess = () => {
			if(PlatformManager.IsEyouPlatform()){
				this.exp_upstage_lb.fontSize = 22
				this.resolve_lb.fontSize = 22
				this.upstage_lb.fontSize = 22
			}
			this._ConfigIllusionModel = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigIllusionModel", true)
			this.type_id = this._type
			this_type_id = this.type_id
			model_type_ = this._model_type
			let illu_info = null
			let illu_id = null

			if (this._type == enum_OutWardType.Wings || this._type == enum_OutWardType.Artifact
				|| this._type == enum_OutWardType.HolyDevice|| this._type == enum_OutWardType.BackOrnament) {
				this.is_show_power_preview = true;
			}
			// let cfg = []
			// for (let v of local_illusion_cfg) {
			// 	table.insert(cfg, v)
			// }
			// let sort_func1 = (a?, b?) => {
			// 	return a.id < b.id
			// }
			// table.sort(cfg, sort_func1)
			let count = 0
			for (let index in local_illusion_cfg) {
				if (local_illusion_cfg[index].type_id == this_type_id) {
					illu_info = local_illusion_cfg[index]
					illu_id = illu_info.id
					if (illu_info.career == 0 || illu_info.career == mainRoleVo.career) {
						illu_item_count_++
						let illusion_item = item_list_[illu_id]
						if (!illusion_item) {
							illusion_item = new IllusionItem(this.illusion_group)
							illusion_item.Load()
							item_list_[illu_id] = illusion_item
						}
						if (this.select_index && this.select_index == illu_id) {
							illusion_item.ExcuteCallback(() => {
								illusion_item.SetSelect(true)
							})
						}
						if (!this.select_index) {
							this.select_index = illu_id
							illusion_item.ExcuteCallback(() => {
								illusion_item.SetSelect(true)
							})
						}
						illusion_item.ExcuteCallback(() => {
							count++
							if (count == illu_item_count_) {
								let data = {
									h_gap: 4,
									v_gap: 7,
									column: 3,
									item_w: 220,
									item_h: 94
								}
								RefGridLayout(this.illusion_group, data, false)
								this.SetBottomBtn()
							}
						})

						let local_active_illu_list = local_outwardModelIns.active_illu_list
						let active_illu_cur_info = local_active_illu_list[this_type_id] && local_active_illu_list[this_type_id][illu_id]
						if (active_illu_cur_info) {
							let end_time = active_illu_cur_info.time
							if (end_time != 0) {
								illusion_item.SetTimer(end_time)
							} else {
								if (this.ui_type == 0) {
									illusion_item.SetActive(active_illu_cur_info.stage)
								} else if (this.ui_type == 1) {
									illusion_item.SetActive(`${active_illu_cur_info.stage}阶`)
								}
							}
							if (local_outwardModelIns.outward_illu_data_list[this_type_id] && local_outwardModelIns.outward_illu_data_list[this_type_id].illusion_id == illu_id) {
								if (this_type_id == local_outwardType.HolyDevice) {
									let fashion_data = null //local_fashionModelIns.fashion_info_list[local_fashionModel.WeaponType]
									if (fashion_data && fashion_data.wear_fashion_id) {
										illusion_item.SetUsing(false)
									} else {
										illusion_item.SetUsing(true)
									}
								} else {
									if (this_type_id == local_outwardType.Wings) {
										let is_ride_back_ornament = false //mainRoleVo.GetFigureRideState(FigureProtoVo.FigureType.BackOrnament)
										if (!is_ride_back_ornament) {
											illusion_item.SetUsing(true)
										}
									} else {
										illusion_item.SetUsing(true)
									}
								}
								old_using_index_ = illu_id
							} else {
								illusion_item.SetUsing(false)
							}
						} else {
							illusion_item.SetUsing(false)
							illusion_item.SetActive(false)
						}
						//设置红点
						let show_red = local_outwardModelIns.GetReddotState(this_type_id, illu_id) || local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(this_type_id), illu_id)
						illusion_item.SetData(illu_id, illu_info.goods_id, illu_info.name, this_type_id, show_red, illu_info.picture)
						// if (this_type_id == local_outwardType.HolyDevice) {
						// 	illusion_item.SetIconImage(illu_info.ride_figure)
						// }
					}
				}
			}
			this.SetBottomBtn()
			this.InitView()
			// local_resMgr.SetOutsideImageSprite(this, this.bottom_img, GameResPath.GetIcon("pet", "uiwg_017"), true)
			// local_resMgr.SetOutsideImageSprite(this, this.right_bg, GameResPath.GetIcon("pet", "uiwg_038"), true)
			// local_resMgr.SetOutsideImageSprite(this, this.model_bg_img, GameResPath.GetIcon("pet", "uiwg_008a"), true)
			// local_resMgr.SetOutsideImageSprite(this, this.exp_bg, GameResPath.GetIcon("pet", "uiwg_022"))
			// local_resMgr.SetOutsideImageSprite(this, this.exp_heigh_light, GameResPath.GetIcon("pet", "uiwg_021png"))

			// this.exp_heigh_light.mask = new Laya.Rectangle(0, 0, this.exp_heigh_light.width, this.exp_heigh_light.height)
			// this.exp_heigh_light.mask = new Laya.Image(null)
			// this.exp_heigh_light.mask.width = this.exp_heigh_light.width
			// this.exp_heigh_light.mask.height = this.exp_heigh_light.height
			this.LoadEffect()

			this.ShowGiftIcon();

		}

		this.LoadEffect = () => {
			// this.AddUIEffect("UI_1104", this.fire_img, undefined, undefined, true)
		}

		this.RefExpGoodsId = () => {
			let cost_cfg = local_illusion_cfg && local_illusion_cfg[this_type_id + "@" + this.select_index + "@" + mainRoleVo.career]
			let cost = null
			if (cost_cfg) {
				cost = cost_cfg.exp_goods && local_json.parse(cost_cfg.exp_goods)
			}
			let list = []
			if (cost) {
				for (let v of cost) {
					let goods_list = local_outwardModelIns.GetExpItemList(this_type_id)
					for (let k1 in goods_list) {
						let v1 = goods_list[k1]
						if (Number(v) == v1.goods_id) {
							table.insert(list, v1)
						}
					}
				}
			}

			this.exp_goods_id_list = list
		}

		this.RefCost = () => {
			this.buy_goods_id = null
			if (this.upstage_type == 1) {
				if (!this.exp_goods_item_list) {
					this.exp_goods_item_list = []
				}
				// this.AddUIEffect("ui_progressbar_glow", this.exp_effect_group, { x: 0, y: 12 }, 0.75, true)

				let index = 0
				let list = this.exp_goods_id_list

				let refVisibleNum = () => {
					let num = 0
					for (let k in this.exp_goods_item_list) {
						let item = this.exp_goods_item_list[k]
						if (item) {
							num = num + 1
						}
					}
					let width = num > 3 ? 270 : num * 90
					if (width > 0) {
						SetSizeDeltaX(this.exp_item, width)
					}
				}
				for (let exp_key in list) {
					let v = list[exp_key]
					let cur_info = list[exp_key]
					if (!this.buy_goods_id && cur_info.type == 1) {
						this.buy_goods_id = cur_info.goods_id
					}
					let item = this.exp_goods_item_list[exp_key]
					if (!item) {
						item = new OutWardExpGoods(this.exp_item_group)
						item.Load()
						this.exp_goods_item_list[exp_key] = item
						refVisibleNum()
					}
					item.ExcuteCallback(() => {
						item.visible = true
						item.SetData(cur_info, this.select_index, this.max_stage_image.visible, refVisibleNum)
					})
				}

				let len = this.exp_goods_item_list.length - list.length
				if (len > 0) {
					for (let i = list.length; i < this.exp_goods_item_list.length; i++) {
						let item = this.exp_goods_item_list[i]
						if (item) {
							item.visible = false
							refVisibleNum()
						}
					}
				}
			}
		}

		this.Local_InitEvent = () => {

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			let OnShowBtnClick = () => {
				let id = this.select_index
				local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this_type_id, 2, id, this.color_id)
			}
			Util.AddClickEvent(this.illusion_btn, OnShowBtnClick, this, true)

			Util.AddClickEvent(this.unillu_btn, () => {
				if (this_type_id == local_outwardType.Pet) {
					local_message.show("当前形象无法取消")
					return
				} else if (this_type_id == local_outwardType.HolyDevice) {
					local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this_type_id, 1, 0, this.color_id)
				} else {
					let data = local_outwardModelIns.outward_data_list[this_type_id]
					if (data) {
						local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this_type_id, 1, data.stage, this.color_id)
					} else {
						local_outwardModelIns.Fire(local_outwardModel.ILLUSION_OUTWARD, this_type_id, 1, 1, this.color_id)
					}
				}
			}, this, true)

			let OnUpStageBtnClick = () => {
				let id = this.select_index
				if (this.select_stage == 0) {
					local_outwardModelIns.Fire(local_outwardModel.ACTIVE_OUTWARD_FIGURE, this_type_id, id)
				} else {
					local_outwardModelIns.Fire(local_outwardModel.EVOLUTION_OUTWARD_FIGURE, this_type_id, id, 0)
				}
			}
			Util.AddClickEvent(this.upstage_btn, OnUpStageBtnClick, this, true)

			let upStageFunc = () => {
				let id = this.select_index
				if (!this.goods_enough && this.upstage_type == 1) {
					local_message.show("材料不足")
					if (this.buy_goods_id && (this_type_id == local_outwardType.Horse || this_type_id == local_outwardType.Partner || this_type_id == local_outwardType.Wings)) {
						ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: this.buy_goods_id })//缺失商城
					}
					return
				}
				local_outwardModelIns.Fire(local_outwardModel.EVOLUTION_OUTWARD_FIGURE, this_type_id, id, 0)
			}
			Util.AddClickEvent(this.exp_upstage_btn, upStageFunc, this, true)

			this.BindEvent(local_outwardModelIns, local_outwardModel.ILLUSION_OUTWARD_SUCCESS, (data?) => {
				if (data && data.type_id == this_type_id) {
					if (data.type == 2) {
						if (old_using_index_ != 0) {
							item_list_[old_using_index_].SetUsing(false)
						}
						if (item_list_[data.args]) {
							item_list_[data.args].SetUsing(true)
							old_using_index_ = data.args;
							if (this.select_index == data.args) {
								this.SetSelectState(2)
							}
						}
					} else if (data.type == 1) {
						if (old_using_index_ != 0) {
							this.illusion_btn.visible = true
							this.illu_label.visible = true
							if (this.select_index == data.args) {
								this.SetSelectState(1)
							}
							item_list_[old_using_index_].SetUsing(false)
						}
						old_using_index_ = 0
					}
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_OUTWARD_FIGURE_DATA, (data?) => {
				if (data.type_id == this_type_id) {
					if (this.select_stage && this.select_stage < data.stage) {
						for (let vo of data.skill_list) {
							let item: PetRoundItem = skill_id_to_item_[vo.skill_id]
							if (item && item.is_lock) {
								item.AddEffect("UI_partner_skillicon_02")
							}
						}
					}
					if (data.time == 0) {
						if (this.ui_type == 0) {
							item_list_[data.id].SetActive(data.stage)
						} else if (this.ui_type == 1) {
							item_list_[data.id].SetActive(`${data.stage}阶`)

						}
					}
					if (this.select_index == data.id) {
						this.select_stage = data.stage
						this.UpdateView()
					}
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_OUTWARD_ILLUSION_VIEW, (data?) => {
				if (data.type_id == this_type_id) {
					this.UpdateView()
				}
			})

			this.BindEvent(local_outwardModelIns, local_outwardModel.ATIVATE_OUTWARD_FIGURE_SUCCESS, (Vo?) => {
				if (Vo.type_id == this_type_id) {
					// this.AddUIEffect("ui_visualupgrade_behind", this.effect_group, null, 1, undefined, undefined, undefined, undefined, undefined, true)
					// this.AddUIEffect("ui_visualupgrade_front", this.effect_group, null, 1, undefined, undefined, undefined, undefined, undefined, true)
					// if (old_using_index_ > 0) {
					// 	item_list_[old_using_index_].SetUsing(false)
					// }
					// old_using_index_ = Vo.id
					// item_list_[old_using_index_].SetUsing(true)
					// local_outwardModelIns.Fire(local_outwardModel.SELECT_ILLUSION_ITEM, Vo.type_id, Vo.id)
					local_outwardModelIns.Fire(local_outwardModel.REQUEST_OUTWARD_DATA, this_type_id, Vo.id)
				}
			})

			let UpStageSuccess = (data?) => {
				if (data.type_id != this_type_id) {
					return
				}
				this.auto_request = data.goods_id && data.goods_id == 0
				if (this.ui_type == 0) {
					// this.AddUIEffect("UI_1401", this.effect)
				} else if (this.ui_type == 1) {
					if (data.blessing_plus >= data.blessing) {
						// this.AddUIEffect("UI_1401", this.effect)
						// this.AddUIEffect("ui_visualupgrade_behind", this.effect_group, null, 1, undefined, undefined, undefined, undefined, undefined, true)
						// this.AddUIEffect("ui_visualupgrade_front", this.effect_group, null, 1, undefined, undefined, undefined, undefined, undefined, true)
					}
				}
				if (this.upstage_type == 1) {
					is_play_ani_ = true
					let endValue = (data.blessing_plus / this.old_blessing) * this.exp_img_width + this.exp_heigh_light.width
					if (endValue > this.exp_img_width) {
						endValue = this.exp_img_width
					}

					let cur_blessing = data.blessing
					let OnchangeFunc = () => {
						if (this.exp_effect_group) {
							this.exp_effect_group.x = this.exp_heigh_light.width + this.exp_heigh_light.x

						}
					}

					let OnPlayOver = () => {
						is_play_ani_ = true
						if (is_max_) {
							this.exp_heigh_light.width = this.exp_img_width
						} else {
							if (this.swicth_item) {
								this.swicth_item = false
							} else {
								if (this.upstage_type == 1 && this.goods_enough) {
									if (this.auto_request == 0) {
										if (this.select_stage && this.select_stage > data.stage) {
											upStageFunc()
										}
									}
								} else if (!this.upstage_type && this.goods_enough) {
									OnUpStageBtnClick()
								}
							}
						}
						this.exp_heigh_light.width = (cur_blessing / this.old_blessing) * this.exp_img_width
						local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16007, "ci", this_type_id, data.id)
					}
					// Laya.Tween.get(this.exp_heigh_light.mask, { onChange: OnchangeFunc }).to({ width: endValue }, 500).call(OnPlazyOver)
					Laya.Tween.to(this.exp_heigh_light, { width: endValue }, 500, null, Laya.Handler.create(this, () => {
						OnPlayOver()
					}))
				} else {
					local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16007, "ci", this_type_id, data.id)
				}
			}
			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATA_OUTWARD_FIGURE_EVOLUTION_DATA, UpStageSuccess)

			let OnGoodsNumberChange = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				if (!goods_list) {
					return
				}
				local_outwardModelIns.CheckIlluStarRed(this_type_id)
				for (let active_index in item_list_) {
					if (local_outwardModelIns.active_illu_list[this_type_id] && local_outwardModelIns.active_illu_list[this_type_id][active_index]) {
						if (this.upstage_type == 1) {
							if (active_index == this.select_index) {
								this.SetUpStageData()
							}
							let show_red = local_outwardModelIns.GetReddotState(this_type_id, active_index) || local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(this_type_id), Number(active_index))
							item_list_[active_index].SetRedDot(show_red)
						} else {
							let stage = local_outwardModelIns.active_illu_list[this_type_id][active_index].stage
							let stage_key = `${this_type_id}@${active_index}@${stage}`
							let stage_cfg = local_outwardModelIns.outward_figure_stage_cfg[stage_key]
							if (stage_cfg) {
								let cost = local_json.parse(stage_cfg.cost)
								if (stage_cfg && cost.length > 0) {
									if (active_index == this.select_index) {
										this.SetUpStageData()
									}
									let show_red = local_outwardModelIns.GetReddotState(this_type_id, active_index)
									if (this_type_id == local_outwardType.Pet) {
										show_red = show_red || local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(this_type_id), Number(active_index))
									}
									item_list_[active_index].SetRedDot(show_red)
								}
							}
						}
					} else {
						let key = `${this_type_id}@${active_index}@${mainRoleVo.career}`
						if (active_index == this.select_index) {
							this.SetUpStageData()
						}
						let show_red = local_outwardModelIns.GetReddotState(this_type_id, active_index)
						item_list_[active_index].SetRedDot(show_red)
					}
				}
				this.SetBottomBtn()
			}
			this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_BAG_LIST, OnGoodsNumberChange)

			let OnActiveLimit = (errcode?) => {
				if (this.source_text.innerHTML != "" && this_type_id == local_outwardType.Pet) {
					local_message.show(this.source_text.innerHTML)
				} else {
					Util.ErrorCodeShow(errcode)
				}
			}
			this.BindEvent(local_outwardModelIns, local_outwardModel.PET_ACTIVE_LIMIT, OnActiveLimit)

			this.BindEvent(local_outwardModelIns, local_outwardModel.SELECT_ILLUSION_ITEM, (type_id?, illusion_id?) => {
				if (is_play_ani_) {
					this.swicth_item = true
				}
				if (this.select_index != illusion_id) {
					if (this.exp_heigh_light) {
						// Laya.Tween.removeTweens(this.exp_heigh_light.mask)
						Laya.Tween.clearAll(this.exp_heigh_light)
					}
					is_play_ani_ = false
				}
				if (type_id == this_type_id) {
					if (local_outwardModelIns.active_illu_list[this_type_id] && local_outwardModelIns.active_illu_list[this_type_id][illusion_id]) {
						this.select_index = illusion_id
						this.select_stage = local_outwardModelIns.active_illu_list[this_type_id][illusion_id].stage
						local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16007, "ci", this_type_id, illusion_id)
						this.UpdateView()
					} else {
						this.select_index = illusion_id
						this.select_stage = 0
						this.UpdateView()
					}
				}
			}
			)
			this.BindEvent(local_outwardModelIns, local_outwardModel.CANCEL_ACTIVE, (Vo?) => {
				if (Vo.type_id == this_type_id) {
					let item = item_list_[Vo.id]
					if (item) {
						item.CancelTimer()
						item.SetActive(false)
						item.SetUsing(false)
					}
				}
			})

			this.update_bottom = () => {
				this.SetBottomBtn()
			}
			// this.illusion_scroller.addEventListener(Laya.UIEvent.CHANGE, update_bottom, this)
			this.illusion_scroller.vScrollBar.on(Laya.UIEvent.CHANGE, this, this.update_bottom)
			let OnResolveBtnClick = () => {
				local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "OutwardStarView", this_type_id, this.select_index)
			}
			Util.AddClickEvent(this.resolve_btn, OnResolveBtnClick, this, true)

			this.BindEvent(local_outwardModelIns, local_outwardModel.REAL_FIGHT, (scmd?) => {
				if (scmd.type_id == this_type_id && this.select_index == scmd.id) {
					if(this.fight_item){
						this.fight_item.Updatefighting(scmd.power);
						if (!this.is_show_power_preview || scmd.next_star_power == 0) {
							this.fight_item.UpdatefightingUp(0);
							this.fight_item.IsCenter(true, false);
						} else {
							this.fight_item.UpdatefightingUp(scmd.next_star_power - scmd.star_combat);
							this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
						}
					}
				}
			})

			if (local_outwardModelIns.active_illu_list[this_type_id] && local_outwardModelIns.active_illu_list[this_type_id][this.select_index]) {
				local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16007, "ci", this_type_id, this.select_index)
			} else {
				this.select_stage = 0
				this.UpdateView()
			}

			/*运营需求
			let show = false
			let show_green_fun = (is_green?) => {
				show = !show
				if (this.color_shape) {
					destroy(this.color_shape)
					this.color_shape = null
				}
				if (show) {
					if (!this.color_shape) {
						this.color_shape = SetGreenOrBlackBg(this.form, is_green)
					}
					if (upstage_item_) {
						upstage_item_.ClearItemEffect()
					}
				}
				this.right_group.visible = !show
				this._Group3.visible = !show
				this._Group2.visible = !show
			}
			this.BindEvent(GlobalEventSystem, EventName.SHOW_GREEN_OR_BLACK_BG, show_green_fun)
			*/
		}

		this.InitView = () => {
			if (!upstage_item_) {
				upstage_item_ = new BaseAwardItem(this.upstage_group)
				upstage_item_.Load()
				upstage_item_.SetItemSize(85, 85)
			}
			if (local_outwardModelIns.outward_illu_data_list[this_type_id]) {
				this.SetPropData()
			}
			if (this_type_id == local_outwardType.Horse || this_type_id == local_outwardType.Partner || this_type_id == local_outwardType.Pet) {
				this.resolve_lb.text = `${local_outwardModelIns.typetoword[this_type_id]}升星`
			}
		}

		this.SelectItem = (select_id?) => {
			if (this.select_index == select_id) {
				return
			}
			if (!this.is_loaded) {
				this.select_index = select_id
			} else {
				if (this.select_index && item_list_[this.select_index]) {
					item_list_[this.select_index].SetSelect(false)
				}
				this.select_index = select_id
				if (item_list_[this.select_index]) {
					item_list_[this.select_index].SetSelect(true)
				}

				if (local_outwardModelIns.active_illu_list[this_type_id] && local_outwardModelIns.active_illu_list[this_type_id][this.select_index]) {
					this.select_stage = local_outwardModelIns.active_illu_list[this_type_id][this.select_index].stage
					local_outwardModelIns.Fire(local_outwardModel.REQUEST_OUTWARD_DATA, this_type_id, this.select_index)
				} else {
					//未激活
					this.select_stage = 0
					this.UpdateView()
				}
			}
		}

		this.Local_SetModel = () => {
			if (!this.is_loaded) {
				return
			}
			let key = `${this_type_id}@${this.select_index}@${mainRoleVo.career}`
			let cfg = local_illusion_cfg[key]
			if (cfg) {
				let model_res = Number(cfg.ride_figure)
				if (model_name_ == model_res) {
					return
				}
				model_name_ = model_res
				let action_list = null
				let client_pos_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardPos", true)
				let outward_action_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardModel", true)
				if (outward_action_cfg_ && outward_action_cfg_[this_type_id + "@1"]) {
					action_list = Util.DeepCopy(outward_action_cfg_[this_type_id + "@1"].action_list)
				}
				let pre_x = ""
				let default_str = ""
				let data = null
				let type = 1
				if (this.type_id == enum_OutWardType.Horse) {
					type = UI_MODEL_TYPE.HORSE
					pre_x = "h"
					default_str = "ill_horse"
				} else if (this.type_id == enum_OutWardType.Wings) {
					type = UI_MODEL_TYPE.WING
					pre_x = "w"
					default_str = "ill_wing"
				} else if (this.type_id == enum_OutWardType.Partner) {
					type = UI_MODEL_TYPE.SPRITE
					pre_x = "s"
					default_str = "ill_sprite"
				} else if (this.type_id == enum_OutWardType.HolyDevice) {
					type = UI_MODEL_TYPE.WEAPON
					pre_x = "d"
					default_str = "ill_weapon"
				} else if (this.type_id == enum_OutWardType.Artifact) {
					type = UI_MODEL_TYPE.ARTIFACT
					pre_x = "a"
					default_str = "ill_artifact"
				} else if (this.type_id == enum_OutWardType.BackOrnament) {
					type = UI_MODEL_TYPE.BACKORNAMENT
					action_list = ['idle']
					pre_x = "b"
					default_str = "ill_backornament"
				}
				let pos_cfg = client_pos_cfg_[`${pre_x}_${model_res}`]
				if (!pos_cfg) {
					pos_cfg = client_pos_cfg_[default_str]
				}
				data = {
					clothe_res_id: model_res,
					type: type,
					can_rotate: true,
					layer_value: this.layer_value,
					scale: pos_cfg && pos_cfg.scale,
					position: pos_cfg && pos_cfg.position,
					rotate: pos_cfg && pos_cfg.rotate,
					texture_size: new Vector2(567, 415),
					action_name_list: action_list,
					// load_call_back : call_func,
					// custom_sorting_order : curr_sorting_order
					action_delta: true,
					enableHDR:true
				}
				if (data) {
					ResManager.GetInstance().SetRoleModel(this, this.res, data)
				}

			}
		}

		this.Local_ClearModel = () => {
			if (!outward_model_) {
				return
			}
			outward_model_.DeleteMe()
			outward_model_ = null
		}

		this.SetSkillData = (cfg?) => {
			if (cfg && cfg.length > 0) {
				let i = 0
				skill_id_to_item_ = {}
				let sort_func = (a?, b?) => {
					let askill_data = local_outwardModelIns.outward_skill_cfg[`${this_type_id}@${a}`]
					let bskill_data = local_outwardModelIns.outward_skill_cfg[`${this_type_id}@${b}`]
					if (askill_data && bskill_data) {
						return askill_data.stage < bskill_data.stage
					} else {
						return false
					}
				}
				table.sort(cfg, sort_func)

				for (let index in cfg) {
					let skill_item = skill_list_[i]
					if (!skill_item) {
						skill_item = new PetRoundItem(this.skill_group)
						skill_item.Load()
						skill_list_[i] = skill_item
					}
					skill_item.ExcuteCallback(() => {
						skill_item.display_obj.visible = true
					})
					// skill_item.includeInLayout = true
					let key = `${this_type_id}@${cfg[i]}`
					let skill_data = local_outwardModelIns.outward_skill_cfg[key]
					if (skill_data) {
						let skill_info = SkillManager.GetInstance().getSkillFromConfig(skill_data.skill_id)
						if (skill_info && skill_info.type != 1) {
							let source_str = `resource/game/skillIcon/${skill_data.skill_id}.png`
							let SkillClickFunc = () => {
								local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "PetSkillView", skill_data.skill_id, this_type_id)
							}

							let is_lock = true
							let lock_stage
							if (skill_data.stage <= this.select_stage) {
								is_lock = false
							} else {
								lock_stage = skill_data.stage
							}
							skill_item.ExcuteCallback(() => {
								skill_item.SetData(source_str, SkillClickFunc, is_lock, lock_stage, 0, 0, false)
							})
						}
						i++
						skill_id_to_item_[skill_data.skill_id] = skill_item
					}
				}

				for (i; i < skill_list_.length; i++) {
					let skill_item = skill_list_[i]
					skill_item.display_obj.visible = false
					// skill_item.includeInLayout = false
				}

			} else {
				this.illu_group.y = 162
			}
		}

		this.SetPropData = () => {
			let stage = 0
			if (local_outwardModelIns.active_illu_list[this_type_id] && local_outwardModelIns.active_illu_list[this_type_id][this.select_index]) {
				stage = local_outwardModelIns.active_illu_list[this_type_id][this.select_index].stage
			}
			let key = `${this_type_id}@${this.select_index}@${stage}`
			let illu_stage_cfg = local_outwardModelIns.outward_figure_stage_cfg[key]
			let next_key = `${this_type_id}@${this.select_index}@${stage + 1}`
			let next_cfg = local_outwardModelIns.outward_figure_stage_cfg[next_key]
			if (illu_stage_cfg) {
				let attr = local_json.parse(illu_stage_cfg.attr)
				let curData = local_outwardModelIns.outward_figure_list[this_type_id] && local_outwardModelIns.outward_figure_list[this_type_id][this.select_index]
				if (curData && curData.attr_list && this.ui_type == 1) {
					let attList = attr
					for (let i = 0; i < attList.length; i++) {
						let prop_item = prop_list_[i]
						if (!prop_item) {
							prop_item = new IllusionPropItem(this.prop_group)
							prop_item.Load()
							prop_list_[i] = prop_item
						}
						prop_item.ExcuteCallback(() => {
							prop_list_[i].display_obj.visible = true
						})
						let next_value
						if (next_cfg) {
							let nect_attr = local_json.parse(next_cfg.attr)
							for (let k = 0; k < nect_attr.length; k++) {
								if (Number(nect_attr[k][0]) == Number(attList[i][0])) {
									next_value = nect_attr[k][1] - attr[k][1]
									break
								}
							}
						}
						if (!next_value) {
							prop_item.SetData(local_wordMgr.GetProperties(attList[i][0]), local_wordMgr.ConvertToPercentValue(attList[i][0], attList[i][1]), next_value)
						} else {
							prop_item.SetData(local_wordMgr.GetProperties(attList[i][0]), local_wordMgr.ConvertToPercentValue(attList[i][0], attList[i][1]), local_wordMgr.ConvertToPercentValue(attList[i][0], next_value))
						}
					}
				} else {
					for (let i = 0; i < attr.length; i++) {
						let prop_item = prop_list_[i]
						if (!prop_item) {
							prop_item = new IllusionPropItem(this.prop_group)
							prop_item.Load()
							prop_list_[i] = prop_item
						}
						prop_list_[i].ExcuteCallback(() => {
							prop_list_[i].display_obj.visible = true
						})
						let next_value
						if (next_cfg) {
							let nect_attr = local_json.parse(next_cfg.attr)
							if (nect_attr.length > i) {
								next_value = nect_attr[i][1] - attr[i][1]
							}
						}

						if (!next_value) {
							prop_item.SetData(local_wordMgr.GetProperties(attr[i][0]), local_wordMgr.ConvertToPercentValue(attr[i][0], attr[i][1]), next_value)
						} else {
							prop_item.SetData(local_wordMgr.GetProperties(attr[i][0]), local_wordMgr.ConvertToPercentValue(attr[i][0], attr[i][1]), local_wordMgr.ConvertToPercentValue(attr[i][0], next_value))
						}
					}
				}
				let add = local_json.parse(illu_stage_cfg.add)
				for (let i = 0; i < add.length; i++) {
					let total_attr = add[i]
					let prop = local_pre_client_cfg.ConfigItemAttr[total_attr[0]]

					let prop_item = prop_list_[i + attr.length]
					if (!prop_item) {
						prop_item = new IllusionPropItem(this.prop_group)
						prop_item.Load()
						prop_list_[i + attr.length] = prop_item
					}
					prop_list_[i + attr.length].ExcuteCallback(() => {
						prop_list_[i + attr.length].display_obj.visible = true
					})


					let next_value
					if (next_cfg) {
						let nect_attr = local_json.parse(next_cfg.add)
						let next_attr_list = nect_attr[i]
						next_value = `${(next_attr_list[1] - total_attr[1]) / 100}%`
					}
					prop_item.SetData(`${local_outwardModelIns.typetoword[this_type_id]}${prop.name}`, `${total_attr[1] / 100}%`, next_value)
				}
				for (let j = attr.length + add.length; j < prop_list_.length; j++) {
					prop_list_[j].ExcuteCallback(() => {
						prop_list_[j].display_obj.visible = false
					})

				}

			} else if (stage == 0 && next_cfg) {
				let attr = local_json.parse(next_cfg.attr)
				for (let i = 0; i < attr.length; i++) {
					let prop_item = prop_list_[i]
					if (!prop_item) {
						prop_item = new IllusionPropItem(this.prop_group)
						prop_item.Load()
						prop_list_[i] = prop_item
					}
					prop_list_[i].ExcuteCallback(() => {
						prop_list_[i].display_obj.visible = true
					})

					let val_id = Number(attr[i][0])
					prop_item.SetData(local_wordMgr.GetProperties(val_id), local_wordMgr.ConvertToPercentValue(val_id, 0), local_wordMgr.ConvertToPercentValue(attr[i][0], attr[i][1]))
				}

				let add = local_json.parse(next_cfg.add)
				for (let i = 0; i < add.length; i++) {
					let total_attr = add[i]
					let prop = local_pre_client_cfg.ConfigItemAttr[total_attr[0]]
					let prop_item = prop_list_[i + attr.length]
					if (!prop_item) {
						prop_item = new IllusionPropItem(this.prop_group)
						prop_item.Load()
						prop_list_[i + attr.length] = prop_item
					}
					prop_item.ExcuteCallback(() => {
						prop_list_[i + attr.length].display_obj.visible = true
					})
					prop_item.SetData(`${local_outwardModelIns.typetoword[this_type_id]}${prop.name}`, `0%`, `${total_attr[1] / 100}%`)
				}
				for (let j = attr.length + add.length; j < prop_list_.length; j++) {
					prop_list_[j].display_obj.visible = false
				}
			}
		}

		this.Local_SetUpStageData = () => {
			let stage = 0
			this.goods_quantity.width = 140
			this.goods_name.width = 140
			if (local_outwardModelIns.active_illu_list[this_type_id] && local_outwardModelIns.active_illu_list[this_type_id][this.select_index]) {
				stage = local_outwardModelIns.active_illu_list[this_type_id][this.select_index].stage
			}
			let key = `${this_type_id}@${this.select_index}@${stage}`
			let illusion_cfg = local_outwardModelIns.outward_figure_stage_cfg[key]
			this.source_text.innerHTML = ""
			if (this.ui_type == 0) {
				this.upstage_text.text = "升星条件"
			} else {
				this.upstage_text.text = "升阶条件"
			}
			// this.res_name.width = 150
			if (illusion_cfg) {
				let cost = local_json.parse(illusion_cfg.cost)
				if (cost.length <= 0) {
					if (!this.upstage_type) {
						let before_key = `${this_type_id}@${this.select_index}@${this.select_stage - 1}`
						illusion_cfg = local_outwardModelIns.outward_figure_stage_cfg[before_key]
						if (illusion_cfg) {
							let before_cost = local_json.parse(illusion_cfg.cost)
							let goods_list = before_cost[0]
							let goods_id = goods_list[1]
							upstage_item_.SetData(goods_id)
							let goodsVo = local_goodsModelIns.GetGoodsBasicByTypeId(goods_id)
							if (goodsVo) {
								if (goodsVo.type == 20) {
									this.goods_name.innerHTML = "<font color='#2971e6'>" + this._ConfigIllusionModel[goodsVo.type_id].name[RoleManager.GetInstance().GetMainRoleVo().career] + "</font>"
								} else {
									this.goods_name.innerHTML = "<font color='#2971e6'>" + goodsVo.goods_name + "</font>" //Util.StrToHTML("<font color=" + ColorUtil.GetColorLight(goodsVo.color) + ">" + Trim(goodsVo.goods_name) + "</font>")
								}
							}
							this.goods_quantity.innerHTML = "<font color='#0a953e'>已满级</font>"
							this.stage_reddot.visible = false
						}
						this.use_goods_group.visible = true
						this.use_exp_group.visible = false
						this.max_stage_image.visible = true
						this.upstage_btn.visible = false
					} else if (this.upstage_type == 1) {
						this.stage_reddot.visible = false
						this.use_exp_group.visible = true
						this.use_goods_group.visible = false
						let exp_cost = illusion_cfg.max_blessing
						if (exp_cost == 0) {
							this.exp_bg.visible = false
							this.exp_heigh_light.visible = false
							this.exp_effect_group.visible = false
							this.exp_label.text = ""
							this.max_stage_image.visible = true
							this.exp_upstage_btn.visible = false
							this.exp_upstage_red.visible = false
							if (!is_play_ani_) {
								this.exp_heigh_light.width = this.exp_img_width
							}
							is_max_ = true
						} else {
							this.exp_bg.visible = true
							this.exp_heigh_light.visible = true
							this.exp_effect_group.visible = true
							this.max_stage_image.visible = false
							this.exp_upstage_btn.visible = true
							let show_red = local_outwardModelIns.GetReddotState(this_type_id, this.select_index)
							this.goods_enough = false
							for (let v of this.exp_goods_id_list) {
								if (v.type != 3) {
									let goods_count = local_goodsModelIns.GetTypeGoodsNum(v.goods_id)
									if (goods_count > 0) {
										this.goods_enough = true
									}
								}
							}
							this.exp_upstage_red.visible = show_red && this.goods_enough

							if (local_outwardModelIns.outward_figure_list[this_type_id] && local_outwardModelIns.outward_figure_list[this_type_id][this.select_index]) {
								let exp = local_outwardModelIns.outward_figure_list[this_type_id][this.select_index].blessing
								if (!is_play_ani_) {
									// if(!(this.exp_heigh_light.width<0.0001)) {
									this.exp_heigh_light.width = this.exp_img_width * (exp / exp_cost)
									this.exp_effect_group.x = this.exp_heigh_light.width + this.exp_heigh_light.x
									// }
								}
								this.exp_label.text = `${exp}/${exp_cost}`
								this.old_blessing = exp_cost
								is_max_ = false
							}
						}
					}
				} else {
					this.use_goods_group.visible = true
					this.use_exp_group.visible = false
					if (this.ui_type == 0) {
						this.upstage_lb.text = "升星"
					} else {
						this.upstage_lb.text = "升阶"
					}
					let cost = local_json.parse(illusion_cfg.cost)
					let goods_list = cost[0]
					let goods_id = goods_list[1]
					upstage_item_.SetData(goods_id)
					let goodsVo = local_goodsModelIns.GetGoodsBasicByTypeId(goods_id)
					if (goodsVo) {
						if (goodsVo.type == 20) {
							this.goods_name.innerHTML = "<font color='#2971e6'>" + this._ConfigIllusionModel[goodsVo.type_id].name[RoleManager.GetInstance().GetMainRoleVo().career] + "</font>"
						} else {
							this.goods_name.innerHTML = "<font color='#2971e6'>" + Trim(goodsVo.goods_name) + "</font>" //Util.StrToHTML("<font color=" + ColorUtil.GetColorLight(goodsVo.color) + ">" + Trim(goodsVo.goods_name) + "</font>")
						}
					}
					let cur_quantity = local_goodsModelIns.GetTypeGoodsNum(goods_id)
					if (Number(goods_list[2]) > cur_quantity) {
						this.goods_quantity.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + cur_quantity + "/" + goods_list[2]) + "</font>"
						this.stage_reddot.visible = false
					} else {
						this.goods_quantity.innerHTML = `${cur_quantity}/${goods_list[2]}`
						this.stage_reddot.visible = true
					}
					this.max_stage_image.visible = false
					this.upstage_btn.visible = true
				}


				//设置左上角阶阶名字战力
				let stage_key = `${this_type_id}@${this.select_index}@${mainRoleVo.career}`
				this.res_name.innerHTML = local_illusion_cfg[stage_key].name

				//特殊处理 有1到6阶 1阶显示0星 6阶显示5星 未激活显示未激活
				if (this.ui_type == 0) {
					if (this.select_stage == 0) {
						this.star_group.visible = false
						this.shadow_group.visible = false
					} else if (this.select_stage) {
						this.star_group.visible = true
						this.shadow_group.visible = true
						//显示图标类型 1-6 星星  7-11 月亮 12-16太阳
						let iconType = Math.floor((this.select_stage - 2) / 5)
						let iconNum = this.select_stage == 1 ? 0 : (this.select_stage - 2) % 5 + 1
						let res
						let shadowRes
						if (iconType < 1) {
							shadowRes = `pet_star_shadow`
							res = `pet_star`
						} else if (iconType == 1) {
							shadowRes = `pet_moon_shaow`
							res = `pet_moon`
						} else {
							shadowRes = `petpet_son_shadow_`
							res = `pet_son`
						}
						for (let i = 0; i < 5; i++) {
							let star = <Laya.Image>this.star_group.getChildAt(i)
							if (i < iconNum) {
								star.visible = true
							} else {
								star.visible = false
							}
							star.skin = GameResPath.GetPetPath(res)
							let shadow = <Laya.Image>this.shadow_group.getChildAt(i)
							if (shadow) {
								shadow.skin = GameResPath.GetPetPath(shadowRes)
							}
						}

					}
				} else {
					this.res_name.innerHTML = Util.StrToHTML(`${local_illusion_cfg[stage_key].name} <font color='#FFFB98'>${this.select_stage}阶</font>`)
				}
				if(PlatformManager.IsEyouPlatform()){
					SetHtmlStyle(this.res_name,{c:"#ffffff",f:22,ww:false})
					this.res_name.style.width = 400
					SetHtmlCenter(this.res_name,{x:-56,w:400})
				}
			} else if (stage == 0) {
				this.use_goods_group.visible = true
				this.resolve_red.visible = false
				this.use_exp_group.visible = false
				this.max_stage_image.visible = false
				//设置激活条件
				let key = `${this_type_id}@${this.select_index}@${mainRoleVo.career}`
				let cfg = local_illusion_cfg[key]
				if (cfg) {
					upstage_item_.SetData(cfg.goods_id)
					let goodsVo = local_goodsModelIns.GetGoodsBasicByTypeId(cfg.goods_id)
					if (goodsVo) {
						if (goodsVo.type == 20) {
							this.goods_name.innerHTML = "<font color='#2971e6'>" + this._ConfigIllusionModel[goodsVo.type_id].name[RoleManager.GetInstance().GetMainRoleVo().career] + "</font>"
						} else {
							this.goods_name.innerHTML = "<font color='#2971e6'>" + goodsVo.goods_name + "</font>" //Util.StrToHTML(GoodsModel.GetGoodsNameWithColorLight(goodsVo.type_id))
						}
					}
					let cur_quantity = local_goodsModelIns.GetTypeGoodsNum(cfg.goods_id)
					this.illusion_btn.visible = false
					this.illu_label.visible = false
					let condition_list = local_json.parse(cfg.condition_list)
					let condition_flag = true
					if (condition_list.length > 0) {
						for (let vo of condition_list) {
							if ("turn" == vo[0]) {
								if (condition_flag && mainRoleVo.turn >= Number(vo[1])) {

								} else {
									this.source_text.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + vo[1] + "转后解锁</font>")
									condition_flag = false
								}
							} else if ("active_id" == vo[0]) {
								let active_list = local_outwardModelIns.active_illu_list[this_type_id]
								let cond_id = condition_list[0]
								let cond_key = `${this_type_id}@${cond_id}@${mainRoleVo.career}`
								let cond_cfg = local_illusion_cfg[cond_key]
								let cond_name = ``
								if (cond_cfg) {
									cond_name = cond_cfg.name
								}
								let cond_stage = condition_list[1]
								if (condition_flag && active_list && active_list[cond_id] && active_list[cond_id].stage >= cond_stage) {
									condition_flag = true
								} else {
									condition_flag = false
								}
								this.source_text.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + cond_name + cond_stage + "阶后解锁</font>")
							}
						}
					}
					if (cfg.goods_num > cur_quantity) {
						this.goods_quantity.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + cur_quantity + "/" + cfg.goods_num + "</font>")
						this.stage_reddot.visible = false
						message_flag_ = false
					} else {
						this.goods_quantity.innerHTML = `${cur_quantity}/${cfg.goods_num}`
						this.stage_reddot.visible = condition_flag
						message_flag_ = true
					}
					this.upstage_btn.visible = true
					// this.upstage_btn.touchEnabled = true
					this.upstage_lb.text = "激活"
					this.upstage_text.text = "激活条件"

					//设置左上角阶阶名字战力
					this.res_name.innerHTML = cfg.name
					if(PlatformManager.IsEyouPlatform()){
						SetHtmlStyle(this.res_name,{c:"#ffffff",f:22,ww:false})
						this.res_name.style.width = 400
						SetHtmlCenter(this.res_name,{x:-56,w:400})
					}
					if (this.ui_type == 0) {
						for (let i = 0; i < 5; i++) {
							let star = this.star_group.getChildAt(i)
							star.active = false
						}
						this.shadow_group.visible = false
						this.star_group.visible = false
					}
				}
			}
			if ((this_type_id == local_outwardType.Horse || this_type_id == local_outwardType.Partner) && this.select_stage > 0) {
				this.resolve_btn.visible = true
			} else {
				this.resolve_btn.visible = false
			}
		}

		this.SetFightValue = () => {
			let fight = 0;
			let cur_star_fight = 0;
			let next_star_fight = 0;
			let list = local_outwardModelIns.outward_figure_list[this_type_id]
			if (list && list[this.select_index]) {
				fight = list[this.select_index].combat
				cur_star_fight = list[this.select_index].star_combat
				next_star_fight = list[this.select_index].next_star_power
			} else {
				local_outwardModelIns.Fire(local_outwardModel.REQUEST_PROTO, 16022, "cc", this_type_id, this.select_index)
			}
			if(this.fight_item){
				this.fight_item.Updatefighting(fight);
				if (!this.is_show_power_preview || next_star_fight == 0) {
					this.fight_item.UpdatefightingUp(0);
					this.fight_item.IsCenter(true, false);
				} else {
					this.fight_item.UpdatefightingUp(next_star_fight - cur_star_fight);
					this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
				}
			}
		}

		this.UpdateView = () => {
			let key = `${this_type_id}@${this.select_index}@${mainRoleVo.career}`
			let cfg = local_illusion_cfg[key]
			if (cfg) {
				let state = 0
				if (local_outwardModelIns.outward_illu_data_list[this_type_id]) {
					for (let figure_data of local_outwardModelIns.outward_illu_data_list[this_type_id].figure_list) {
						if (figure_data.id == cfg.id) {
							state = 1
							if (cfg.id == local_outwardModelIns.outward_illu_data_list[this_type_id].illusion_id) {
								if (this_type_id == local_outwardType.HolyDevice) {
									let fashion_data = null //.fashion_info_list[local_fashionModel.WeaponType]
									if (fashion_data && fashion_data.wear_fashion_id) {
										state = 1
									} else {
										state = 2
									}
								} else {
									if (this_type_id == local_outwardType.Wings) {
										let is_ride_back_ornament = false //mainRoleVo:GetFigureRideState(FigureProtoVo.FigureType.BackOrnament)
										if (!is_ride_back_ornament) {
											state = 2
										}
									} else {
										state = 2
									}
								}
							}
						}
					}
				}
				if (item_list_[this.select_index]) {
					let show_red = local_outwardModelIns.GetReddotState(this_type_id, this.select_index) || local_redMgr.CheckRedStatus(local_outwardModelIns.GetRedType(this_type_id), this.select_index)
					item_list_[this.select_index].SetRedDot(show_red)
				}
				let skill_cfg = local_json.parse(cfg.skill_list)
				this.SetSkillData(skill_cfg)
				this.SetPropData()
				this.RefExpGoodsId()
				this.SetUpStageData()
				this.SetSelectState(state)
				this.SetModel()
				this.SetFightValue()
				this.SetBottomBtn()
				this.RefCost()
			}
		}

		//0 未激活 1 已激活 2 使用中
		this.SetSelectState = (state?) => {
			if (state == 0) {
				this.illu_label.visible = false
				this.illusion_btn.visible = false
				this.unillu_btn.visible = false
				this.proview_bg.visible = true
				return
			} else if (state == 2) {
				this.illu_label.visible = true
				this.illusion_btn.visible = false
				this.unillu_btn.visible = true
				this.proview_bg.visible = false
				return
			} else if (state == 1) {
				this.illu_label.visible = true
				this.illusion_btn.visible = true
				this.unillu_btn.visible = false
				this.proview_bg.visible = false
			}
		}

		this.SetBottomBtn = () => {
			if (this.illusion_scroller) {
				if (this.illusion_scroller.displayHeight /*.viewport.scrollV*/ >= this.illusion_group.height - this.illusion_scroller.vScrollBar.value/*.viewport.contentHeight */ - 3) {
					this.bottom_red.visible = false
					this.bottom_btn.visible = false
				} else {
					this.bottom_btn.visible = true
					// let count = Math.floor((this.illusion_scroller.viewport.scrollV + this.illusion_scroller.viewport.height) / (120))
					let count = Math.floor((this.illusion_group.height - this.illusion_scroller.vScrollBar.value /*viewport.height*/) / (120))
					if (count < 0) {
						count = 0
					}
					for (let i = count * 3; i < this.illusion_group.numChildren; i++) {
						let illu_item = item_list_[i - 1]
						if (illu_item && illu_item.red_dot && illu_item.red_dot.visible) {
							this.bottom_red.visible = true
							return
						}
					}
					this.bottom_red.visible = false
				}
			}
		}

		this.CustomMehod = (index?, id?) => {
			if (id != undefined) {
				this.SelectItem(id[0])
			}
		}

		this.Local_DeleteMe = () => {
			if(this.fight_item){
                this.fight_item.DeleteMe()
                this.fight_item = null
            }
			for (let i in item_list_) {
				item_list_[i].DeleteMe()
			}
			item_list_ = {}
			for (let i in prop_list_) {
				prop_list_[i].DeleteMe()
			}
			prop_list_ = null
			if (upstage_item_) {
				upstage_item_.DeleteMe()
			}
			upstage_item_ = null
			if (this.illusion_scroller) {
				this.illusion_scroller.vScrollBar.off(Laya.UIEvent.CHANGE, this, this.update_bottom)
			}
			if (this.exp_goods_item_list) {
				for (let key in this.exp_goods_item_list) {
					this.exp_goods_item_list[key].DeleteMe()
					this.exp_goods_item_list[key] = null
				}
				this.exp_goods_item_list = null
			}
			for (let index in skill_list_) {
				skill_list_[index].DeleteMe()
			}
			skill_list_.length = 0
			skill_id_to_item_ = {}
			if (this.exp_heigh_light) {
				// Laya.Tween.removeTweens(this.exp_heigh_light.mask)
				Laya.Tween.clearAll(this.exp_heigh_light)
			}
			this.ClearUIEffect(this.effect_group)
			this.ClearUIEffect(this.exp_effect_group)
			this.ClearUIEffect(this.star_effect)
			// if (this.illusion_scroller) {
			// 	this.illusion_scroller.removeEventListener(Laya.UIEvent.CHANGE)
			// }
			this.ClearModel()
			/*运营需求
			if (this.color_shape) {
				destroy(this.color_shape)
				this.color_shape = null
			}
			*/
			if (this.giftItem) {
				this.giftItem.DeleteMe();
				this.giftItem = null;
			}
			super.DeleteMe()
		}


	}

	private ShowGiftIcon() {
		let type: number = this.type_id == enum_OutWardType.Horse ? EnumPushGiftType.eZuoJi : EnumPushGiftType.eShiHun;
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(type));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, type);
			});

		}
		this.giftIcon.visible = bool;
	}

	public SetUpStageData() {
		this.Local_SetUpStageData()
	}

	public LoadSuccess() {
		this.Local_loadSuccess()
	}

	public InitEvent() {
		this.Local_InitEvent()
	}

	public SetModel() {
		this.Local_SetModel()
	}

	public ClearModel() {
		this.Local_ClearModel()
	}

	public DeleteMe() {
		this.Local_DeleteMe()
	}


	ui_bg: Laya.Image
	model_bg_img: Laya.Image
	effect: Laya.Box
	res: Laya.Box
	top_group: Laya.Box
	_Group1: Laya.Box
	shadow_group: Laya.HBox
	star9: Laya.Image
	star10: Laya.Image
	star0: Laya.Image
	star1: Laya.Image
	star7: Laya.Image
	star_group: Laya.HBox
	shadow9: Laya.Image
	shadow10: Laya.Image
	shadow0: Laya.Image
	shadow1: Laya.Image
	shadow2: Laya.Image
	star_effect: Laya.Box
	_Group2: Laya.Box
	_img_name: Laya.Image
	res_name: Laya.HTMLDivElement
	res_stage: Laya.Label
	_gp_fight: Laya.Box
	_FightingShowBigItem1: Laya.Box
	bottom_group: Laya.Box
	bottom_img: Laya.Image
	illusion_scroller: Laya.Panel
	illusion_group: Laya.Box
	skill_group: Laya.HBox
	bottom_btn: Laya.Image
	select_bg: Laya.Image
	proview_bg: Laya.Image
	effect_group: Laya.Box
	illu_group: Laya.Box
	unillu_btn: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	illusion_btn: Laya.Box
	_Image4: Laya.Image
	_Image5: Laya.Image
	illu_label: Laya.Label
	bottom_red: Laya.Image
	right_group: Laya.Box
	right_bg: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	source_text: Laya.HTMLDivElement
	upstage_text: Laya.Label
	prop_text: Laya.Label
	prop_scroller: Laya.Panel
	prop_group: Laya.VBox
	use_goods_group: Laya.Box
	upstage_group: Laya.Box
	upstage_btn: Laya.Box
	upstage_img: Laya.Image
	upstage_lb: Laya.Label
	stage_reddot: Laya.Image
	goods_quantity: Laya.HTMLDivElement
	goods_name: Laya.HTMLDivElement
	use_exp_group: Laya.Box
	exp_item: Laya.Panel
	exp_item_group: Laya.HBox
	exp_bg: Laya.Image
	exp_heigh_light: Laya.Image
	exp_goods_name0: Laya.Label
	exp_goods_name1: Laya.Label
	exp_label: Laya.Label
	exp_upstage_btn: Laya.Box
	exp_upstage_img: Laya.Image
	exp_upstage_lb: Laya.Label
	exp_upstage_red: Laya.Image
	exp_effect_group: Laya.Box
	resolve_btn: Laya.Box
	resolve_img: Laya.Image
	resolve_lb: Laya.Label
	resolve_red: Laya.Image
	max_stage_image: Laya.Image
	Separate_img: Laya.Image
	giftIcon: Laya.Box
	public GetComponents() {
		[
			this.ui_bg,
			this.model_bg_img,
			this.effect,
			this.res,
			this.top_group,
			this._Group1,
			this.shadow_group,
			this.star9,
			this.star10,
			this.star0,
			this.star1,
			this.star7,
			this.star_group,
			this.shadow9,
			this.shadow10,
			this.shadow0,
			this.shadow1,
			this.shadow2,
			this.star_effect,
			this._Group2,
			this._img_name,
			this.res_name,
			this.res_stage,
			this._gp_fight,
			this._FightingShowBigItem1,
			this.bottom_group,
			this.bottom_img,
			this.illusion_scroller,
			this.illusion_group,
			this.skill_group,
			this.bottom_btn,
			this.select_bg,
			this.proview_bg,
			this.effect_group,
			this.illu_group,
			this.unillu_btn,
			this._Image2,
			this._Image3,
			this.illusion_btn,
			this._Image4,
			this._Image5,
			this.illu_label,
			this.bottom_red,
			this.right_group,
			this.right_bg,
			this._Image6,
			this._Image7,
			this.source_text,
			this.upstage_text,
			this.prop_text,
			this.prop_scroller,
			this.prop_group,
			this.use_goods_group,
			this.upstage_group,
			this.upstage_btn,
			this.upstage_img,
			this.upstage_lb,
			this.stage_reddot,
			this.goods_quantity,
			this.goods_name,
			this.use_exp_group,
			this.exp_item,
			this.exp_item_group,
			this.exp_bg,
			this.exp_heigh_light,
			this.exp_goods_name0,
			this.exp_goods_name1,
			this.exp_label,
			this.exp_upstage_btn,
			this.exp_upstage_img,
			this.exp_upstage_lb,
			this.exp_upstage_red,
			this.exp_effect_group,
			this.resolve_btn,
			this.resolve_img,
			this.resolve_lb,
			this.resolve_red,
			this.max_stage_image,
			this.Separate_img,
			this.giftIcon,
		]
			= this.GetChildrenByNames([

				"ui_bg",
				"model_bg_img",
				"effect",
				"res",
				"top_group",
				"_Group1",
				"shadow_group",
				"star9",
				"star10",
				"star0",
				"star1",
				"star7",
				"star_group",
				"shadow9",
				"shadow10",
				"shadow0",
				"shadow1",
				"shadow2",
				"star_effect",
				"_Group2",
				"_img_name",
				"res_name",
				"res_stage",
				"_gp_fight",
				"_FightingShowBigItem1",
				"bottom_group",
				"bottom_img",
				"illusion_scroller",
				"illusion_group",
				"skill_group",
				"bottom_btn",
				"select_bg",
				"proview_bg",
				"effect_group",
				"illu_group",
				"unillu_btn",
				"_Image2",
				"_Image3",
				"illusion_btn",
				"_Image4",
				"_Image5",
				"illu_label",
				"bottom_red",
				"right_group",
				"right_bg",
				"_Image6",
				"_Image7",
				"source_text",
				"upstage_text",
				"prop_text",
				"prop_scroller",
				"prop_group",
				"use_goods_group",
				"upstage_group",
				"upstage_btn",
				"upstage_img",
				"upstage_lb",
				"stage_reddot",
				"goods_quantity",
				"goods_name",
				"use_exp_group",
				"exp_item",
				"exp_item_group",
				"exp_bg",
				"exp_heigh_light",
				"exp_goods_name0",
				"exp_goods_name1",
				"exp_label",
				"exp_upstage_btn",
				"exp_upstage_img",
				"exp_upstage_lb",
				"exp_upstage_red",
				"exp_effect_group",
				"resolve_btn",
				"resolve_img",
				"resolve_lb",
				"resolve_red",
				"max_stage_image",
				"Separate_img",
				"giftIcon",
			])
		this.res_name.style.fontSize = 22
		this.res_name.style.color = "#ffffff"
		this.res_name.style.wordWrap = false

		this.source_text.style.fontSize = 18
		this.source_text.style.color = "#5a1c20"
		this.source_text.width = 281
		this.goods_quantity.style.fontSize = 20
		this.goods_quantity.style.color = "#0a953e"

		this.goods_name.style.fontSize = 20
		this.goods_name.style.color = "#ffffff"
		this.goods_name.width = 133
		this.exp_item.hScrollBar.visible = false
		this.prop_scroller.vScrollBar.visible = false
		this.illusion_scroller.vScrollBar.visible = false
	}
}
window["IllusionBaseView"] = IllusionBaseView