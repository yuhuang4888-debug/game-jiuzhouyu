import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipModel, EquipEvent, EquipDefine } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPosition, SetSizeDeltaX, Util } from "../util/Util"
import { EquipJewelCraveAttItem } from "./EquipJewelCraveAttItem"
import { EquipJewelCraveSubItem } from "./EquipJewelCraveSubItem"

export class EquipJewelCraveView extends BaseItem1 {
	DefaultSelect
	InitEvent
	InitGoodsItem
	InitSubView
	LoadSuccess
	NextSelect
	PlayExpAni
	SelectGoods
	SetExpAndProp
	SetJewelItem
	UpdateArrowRed
	UpdateRed

	mask
	maskTweenid

	LocalDeleteMe: any

	public constructor(parent?) {
		super(parent)
		this.base_file = "jewel"
		this.layout_file = "EquipJewelCraveView"

		let model = EquipModel.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let local_EquipEvent = EquipEvent
		let role_mgr = RoleManager.GetInstance()
		//let function_open_model = FunctionOpenModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let ui_tip_mgr = UIToolTipMgr.GetInstance()
		let local_EquipDefine = EquipDefine
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_Message = Message
		let ani_type_ = null
		let old_lv_ = null
		let oldExp = null
		let play_ani_ = null
		let max_len_ = null
		let ani_count_ = 0
		let end_value_ = null
		let goods_item_list_ = []
		let goods_id_to_index_ = []
		let defalut_sub_index_ = null
		let sub_item_list_ = []
		let now_select_type_id_ = null
		let target_item_ = null
		let now_select_goods_id_ = null
		let default_goods_id_ = null
		let attr_item_list_: EquipJewelCraveAttItem[] = []
		let cur_equip_info_ = null
		let unlock_config_ = null
		this.preload_server_config = {
			"config_equip_stone_pos_unlock": false,
			"config_equip_stone_refine": false,
			"config_equip_stone_lv": false,
			"config_equip_stone_refine_goods": false,
			"config_equip_stone_refine_limit": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.tab_scroller.vScrollBar.visible = false
			this._Scroller1.vScrollBar.visible = false
			res_mgr.SetOutsideImageSprite(this, this._img_bg, "resource/game/jewel/other/uidz_004c.png")

			unlock_config_ = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_pos_unlock", false)
			if (unlock_config_) {
				max_len_ = this.exp_heigh_light.width
				this.InitSubView()
				this.InitEvent()
				if (defalut_sub_index_) {
					let item = sub_item_list_[defalut_sub_index_]
					if (item) {
						item.ExcuteCallback(() => {
							model.Fire(local_EquipEvent.SELECT_JEWEL_CARVE_GOODS, defalut_sub_index_ + 1, true)
						}
						)
						let index = defalut_sub_index_
						if (index > 4) {
							//SetAnchoredPosition(this.Content11, this.Content11.x, this.tab_scroller.height - 179 * (index + 1))
						}
					}
				} else {
					let item = sub_item_list_[now_select_type_id_]
					if (item) {
						item.ExcuteCallback(() => {
							model.Fire(local_EquipEvent.SELECT_JEWEL_CARVE_GOODS, now_select_type_id_ + 1)
						}
						)
					}
				}
			}
		}

		this.InitSubView = () => {
			let equipInfo = model.GetWearEquipDynamics()
			if (equipInfo && equipInfo.length > 0) {
				now_select_type_id_ = equipInfo[0].equip_type - 1
				for (let i = 0; i < equipInfo.length; i++) {
					let item = sub_item_list_[equipInfo[i].equip_type - 1]
					if (!item) {
						item = new EquipJewelCraveSubItem(this.Content11)
						item.Load()
						sub_item_list_[equipInfo[i].equip_type - 1] = item
					}
					item.visible = true
					let open_list = []
					for (let _tmpi in equipInfo[i].stone_list) {
						let vo = equipInfo[i].stone_list[_tmpi]
						open_list[vo.pos] = vo.pos
					}
					let unlock_number = 0
					for (let _tmpi in local_EquipDefine.JEWEL_POS) {
						let pos = local_EquipDefine.JEWEL_POS[_tmpi]
						let is_open = Boolean(open_list[pos])
						if (!is_open) {
							let unlock_cfg = unlock_config_[equipInfo[i].equip_type + "@" + pos]
							let equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)
							let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equipInfo[i].type_id, false, equip_attr_cfg)
							let cond = JSON.parse(unlock_cfg.condition)
							let unlock = cond.length < 1
							if (!unlock) {
								let str_list = cond[0]
								let key = str_list[0]
								let value = str_list[1]
								if (key == "stage") {
									unlock = Number(value) <= attr_cfg.stage
								} else if (key == "vip") {
									let vip_flag = role_mgr.GetMainRoleVo().vip_flag
									value = str_list[2]
									unlock = Number(value) <= vip_flag
								}
							}
							if (unlock) {
								unlock_number = unlock_number + 1
							}
						}
					}
					item.SetData(equipInfo[i], unlock_number)
					if (i == equipInfo.length - 1) {
						item.FinishCallback(() => {
							this.UpdateRed()
						})
					}
				}
			}
			this.DefaultSelect()
			this.SetExpAndProp(defalut_sub_index_ || now_select_type_id_)
		}

		this.SetJewelItem = (equip_type?) => {
			if (equip_type) {
				now_select_type_id_ = equip_type
				let equip_data = model.GetWearEquipDynamic(equip_type)
				if (equip_data) {
					if (!target_item_) {
						target_item_ = new EquipmentItem(this.cur_item_group)
						target_item_.Load()
					}
					target_item_.SetData(equip_data.type_id)
					let crave_data = model.jewel_crave_data_list[equip_type]
					target_item_.SetClickCallBack(() => {
						let goodsVo = goods_model.GetEquipById(equip_data.goods_id)
						ui_tip_mgr.AppendEquipTips(equip_data.type_id, null, null, goodsVo, null, [1])
					}
					)
					if (crave_data) {
						target_item_.SetStrengthen(crave_data.refine_lv, true)
					}
					let open_list = []
					for (let _tmpi in equip_data.stone_list) {
						let vo = equip_data.stone_list[_tmpi]
						this["icon" + vo.pos].visible = true
						this["lock" + vo.pos].visible = false
						let icon_id = GoodsModel.GetGoodsIcon(vo.type_id)
						res_mgr.SetOutsideImageSprite(this, this["icon" + vo.pos], GameResPath.GetGoodsIconPath(icon_id))
						open_list[vo.pos] = vo.pos
					}
					for (let _tmpi in local_EquipDefine.JEWEL_POS) {
						let pos = local_EquipDefine.JEWEL_POS[_tmpi]
						let is_open = Boolean(open_list[pos])
						if (!is_open) {
							let unlock_cfg = unlock_config_[equip_data.equip_type + "@" + pos]
							let equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)

							let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip_data.type_id, false, equip_attr_cfg)
							let cond = JSON.parse(unlock_cfg.condition)
							let unlock = cond.length < 1
							if (!unlock) {
								let str_list = cond[0]
								let key = str_list[0]
								let value = str_list[1]
								if (key == "stage") {
									unlock = Number(value) <= attr_cfg.stage
								} else if (key == "vip") {
									value = str_list[2]
									let vip_flag = role_mgr.GetMainRoleVo().vip_flag
									unlock = Number(value) <= vip_flag
								}
							}
							if (unlock) {
								this["icon" + pos].visible = false
								this["lock" + pos].visible = false
							} else {
								this["icon" + pos].visible = false
								this["lock" + pos].visible = true
							}
						}
					}
				}
			}
		}

		this.SetExpAndProp = (equip_type?) => {
			let jewel_data = model.jewel_crave_data_list[equip_type]
			let equip_info = model.GetWearEquipDynamic(equip_type)
			if (jewel_data) {
				let equip_stone_refine_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_refine", false)
				let jewel_cfg = equip_stone_refine_cfg[jewel_data.equip_type + "@" + jewel_data.refine_lv]
				let next_config = equip_stone_refine_cfg[jewel_data.equip_type + "@" + (jewel_data.refine_lv + 1)]
				//let cur_crave_data = null
				//let next_crave_data = null
				let cur_jewel_data = []
				//let overall_plus = null
				let jewel_lv_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_lv", false)
				if (equip_info) {
					for (let _tmpi in equip_info.stone_list) {
						let vo = equip_info.stone_list[_tmpi]
						let stone_attr = jewel_lv_cfg[vo.type_id]
						if (stone_attr) {
							let stone_list = JSON.parse(stone_attr.attr)
							for (let _tmpi in stone_list) {
								let stonr_info = stone_list[_tmpi]
								let value = cur_jewel_data[stonr_info[0]]
								if (value) {
									value = value + stonr_info[1]
								} else {
									value = stonr_info[1]
								}
								cur_jewel_data[stonr_info[0]] = value
							}
						}
					}
				}
				if (next_config && jewel_cfg) {
					this.lb_exp.text = jewel_data.exp + "/" + jewel_cfg.exp
					let attr_list = JSON.parse(jewel_cfg.attr)
					for (let i = attr_list.length; i < attr_item_list_.length; i++) {
						let item = attr_item_list_[i]
						item.SetVisible(false)
					}
					for (let i = 0; i < attr_list.length; i++) {
						let item = attr_item_list_[i]
						if (!item) {
							item = new EquipJewelCraveAttItem(this.Content)
							item.Load()
							attr_item_list_[i] = item
						}
						item.SetVisible(true)
						item.SetData(attr_list[i], JSON.parse(next_config.attr)[i], cur_jewel_data[attr_list[i][0]], jewel_cfg.overall_plus, next_config.overall_plus)
					}
					let last_item = attr_item_list_[attr_list.length]
					if (!last_item) {
						last_item = new EquipJewelCraveAttItem(this.Content)
						last_item.Load()
						attr_item_list_[attr_list.length] = last_item
					}
					if (last_item) {
						last_item.SetVisible(true)
						last_item.SetPropUP(jewel_cfg.overall_plus, next_config.overall_plus)
					}
				} else if (jewel_cfg) {
					let attr_list = JSON.parse(jewel_cfg.attr)
					for (let i = attr_list.length; i < attr_item_list_.length; i++) {
						let item = attr_item_list_[i]
						item.SetVisible(false)
					}
					for (let i = 0; i < attr_list.length; i++) {
						let item = attr_item_list_[i]
						if (!item) {
							item = new EquipJewelCraveAttItem(this.Content)
							item.Load()
							attr_item_list_[i] = item
						}
						item.SetVisible(true)
						item.SetData(attr_list[i], false, cur_jewel_data[attr_list[i][0]], jewel_cfg.overall_plus)
					}

					let last_item = attr_item_list_[attr_list.length]
					if (!last_item) {
						last_item = new EquipJewelCraveAttItem(this.Content)
						last_item.Load()
						attr_item_list_[attr_list.length] = last_item
					}
					if (last_item) {
						last_item.SetVisible(true);
						last_item.SetPropUP(jewel_cfg.overall_plus, null)
					}
					this.lb_exp.text = "已满级"
				}
				if (ani_type_ == equip_type) {
					if (next_config) {
						end_value_ = jewel_data.exp == 0 ? 0 : Math.ceil(max_len_ * (jewel_data.exp / jewel_cfg.exp))
					} else {
						end_value_ = max_len_
					}
					if (old_lv_ < jewel_data.refine_lv) {
						ani_count_ = ani_count_ + 1
						if (!play_ani_) {
							this.PlayExpAni(end_value_)
						}
						old_lv_ = jewel_data.refine_lv
					} else {
						if (!play_ani_ && jewel_data.exp != oldExp) {
							this.PlayExpAni(end_value_)
						}
						oldExp = jewel_data.exp
					}
				} else {
					old_lv_ = jewel_data.refine_lv
					oldExp = jewel_data.exp
					ani_type_ = equip_type
					play_ani_ = false
					if (this.maskTweenid != null) {
						SYTweenLite.Stop(this.maskTweenid)
						this.maskTweenid = null
					}
					if (next_config) {
						SetSizeDeltaX(this.exp_heigh_light, max_len_ * jewel_data.exp / jewel_cfg.exp)
					} else {
						SetSizeDeltaX(this.exp_heigh_light, max_len_)
					}
				}
			}
		}

		this.PlayExpAni = (endPos?) => {
			let end_value = null
			if (play_ani_) {
				return
			} else {
				if (ani_count_ > 0) {
					end_value = max_len_
				} else {
					let wid = this.exp_heigh_light.width < 1 ? 0 : this.exp_heigh_light.width
					if (end_value_ < wid) {
						ani_count_ = 1
					}
					end_value = end_value_
				}
				let PlayOver = () => {
					play_ani_ = false
					if (ani_count_ > 0) {
						if (this.exp_heigh_light.width == max_len_) {
							this.exp_heigh_light.width = 0
							ani_count_ = ani_count_ - 1
						}
						this.PlayExpAni(end_value_)
					}
				}
				play_ani_ = true
				this.maskTweenid = SYTweenLite.to(this, this.exp_heigh_light, SYTweenLite.UiAnimationType.WIDTH, end_value, 0.35, PlayOver)
			}
		}

		this.InitGoodsItem = (equip_type?) => {
			let equip_stone_refine_goods_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_refine_goods", false)
			let goods_config = equip_stone_refine_goods_cfg
			let count = 1
			this.SelectGoods(false, true)

			let goods_cfg = []
			for (let i in goods_config) {
				let v = goods_config[i]
				table.insert(goods_cfg, v)
			}
			table.sort(goods_cfg, (a?, b?) => {
				if (a.goods_id == b.goods_id) {
					return a.equip_pos < b.equip_pos
				} else {
					return a.goods_id < b.goods_id
				}
			})

			goods_id_to_index_ = []
			if (goods_cfg) {
				for (let key in goods_cfg) {
					if (goods_cfg[key].equip_pos == equip_type) {
						let item = goods_item_list_[count]
						let goodsNumber = goods_model.GetTypeGoodsNum(goods_cfg[key].goods_id)
						if (!item) {
							item = new BaseAwardItem(this.Content1)
							item.Load()
							item.SetScale(100 / 127)
							goods_item_list_[count] = item
						}
						item.SetClickCallBack(() => {
							this.SelectGoods(goods_cfg[key].goods_id)
						}
						)
						if (!default_goods_id_ && goodsNumber > 0) {
							default_goods_id_ = goods_cfg[key].goods_id
						}
						goods_id_to_index_[goods_cfg[key].goods_id] = count
						item.ExcuteCallback(() => {
							item.SetData(goods_cfg[key].goods_id)
							item.ForceSetNumber(goodsNumber)
						}
						)
						count = count + 1
					}
				}
			}
			this.NextSelect()
		}

		this.SelectGoods = (goods_id?, force_reset?) => {
			let new_goods_id = goods_id
			if (new_goods_id) {
				let goods_num = goods_model.GetTypeGoodsNum(new_goods_id)
				if (goods_num > 0 && (!now_select_goods_id_ || now_select_goods_id_ != new_goods_id)) {
					if (now_select_goods_id_ && goods_item_list_[goods_id_to_index_[now_select_goods_id_]]) {
						let count = goods_id_to_index_[now_select_goods_id_]
						goods_item_list_[count].SetSelect(false)
					}
					now_select_goods_id_ = new_goods_id
					let select = goods_id_to_index_[now_select_goods_id_]
					if (goods_item_list_[select]) {
						goods_item_list_[select].ExcuteCallback(() => {
							goods_item_list_[select].SetSelect(true)
						}
						)
					}
				} else {
					ui_tip_mgr.AppendGoodsTips(new_goods_id)
				}
			} else if (force_reset) {
				let select = goods_id_to_index_[now_select_goods_id_]
				if ((now_select_goods_id_ && select) && goods_item_list_[select]) {
					goods_item_list_[select].SetSelect(false)
				}
				now_select_goods_id_ = null
			}
		}

		this.DefaultSelect = () => {
			let lastlv = 99999
			for (let key in sub_item_list_) {
				let item = sub_item_list_[key]
				if (item) {
					let show_red = red_dot_mgr.CheckRedStatus(local_ModuleType.JEWEL_CRAVE_RED, item.GetTypeId())
					if (show_red) {
						let crave_data = model.jewel_crave_data_list[Number(key)]
						if (crave_data && crave_data.refine_lv < lastlv) {
							defalut_sub_index_ = Number(key)
							lastlv = crave_data.refine_lv
						}
					}
				}
			}
		}

		this.UpdateRed = () => {
			if (now_select_type_id_) {
				let a = red_dot_mgr.CheckRedStatus(local_ModuleType.JEWEL_CRAVE_RED, now_select_type_id_)
				this.crave_red.visible = red_dot_mgr.CheckRedStatus(local_ModuleType.JEWEL_CRAVE_RED, now_select_type_id_)
			}
			this.UpdateArrowRed()
		}

		this.NextSelect = () => {
			for (let key in goods_id_to_index_) {

				let goodsNumber = goods_model.GetTypeGoodsNum(key)
				if (goodsNumber > 0) {
					this.SelectGoods(key)
					return
				}
			}
			this.SelectGoods(false, true)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btn_allCrave, () => {
				let equip_stone_refine_limit_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_refine_limit", false)
				if (!model.IsOpenCrave(now_select_type_id_, equip_stone_refine_limit_cfg)) {
					// [ts2lua]equip_stone_refine_limit_cfg下标访问可能不正确
					let limit_config = equip_stone_refine_limit_cfg[now_select_type_id_]
					if (limit_config) {
						local_Message.show(JSON.parse(limit_config.limit)[0][0] + "阶以上可以雕刻")
					}
					return
				}
				if (now_select_type_id_ && now_select_goods_id_) {
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15211, "cic", now_select_type_id_, now_select_goods_id_, 1)
				} else if (!now_select_goods_id_) {
					local_Message.show("材料不足")
				} else if (!now_select_type_id_) {
					local_Message.show("穿戴装备才能进行雕刻")
				}
			}, this, true)

			Util.AddClickEvent(this.btn_crave, () => {
				let equip_stone_refine_limit_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_refine_limit", false)
				if (!model.IsOpenCrave(now_select_type_id_, equip_stone_refine_limit_cfg)) {
					let limit_config = equip_stone_refine_limit_cfg[now_select_type_id_]
					if (limit_config) {
						local_Message.show(JSON.parse(limit_config.limit)[0][0] + "阶以上可以雕刻")
					}
					return
				}
				if (now_select_type_id_ && now_select_goods_id_) {
					model.Fire(local_EquipEvent.REQUEST_PROTO, 15211, "cic", now_select_type_id_, now_select_goods_id_, 0)
				} else if (!now_select_goods_id_) {
					local_Message.show("材料不足")
				} else if (!now_select_type_id_) {
					local_Message.show("穿戴装备才能进行雕刻")
				}
			}, this, true)

			this.BindEvent(model, local_EquipEvent.JEWEL_SEMLT_INFO, (scmd?) => {
				if (scmd.equip_type == now_select_type_id_) {
					this.SetExpAndProp(scmd.equip_type)
					target_item_.SetStrengthen(scmd.refine_lv, true)
					this.crave_red.visible = red_dot_mgr.CheckRedStatus(local_ModuleType.JEWEL_CRAVE_RED, scmd.equip_type)
				}
				this.UpdateArrowRed()
			})

			this.BindEvent(model, local_EquipEvent.JEWEL_SEMLT_SUCCESS, (scmd?) => {
				if (scmd.is_up == 1) {
					for (let key in attr_item_list_) {
						if (attr_item_list_[key] && attr_item_list_[key].GetVisible()) {
							attr_item_list_[key].PlayEffect()
						}
					}
					// this.AddUIEffect("UI_1102_shengjichenggong", "UI", this.effect_group)
				} else if (scmd.one_key == 1) {

				}
			})

			this.BindEvent(model, local_EquipEvent.SELECT_JEWEL_CARVE_GOODS, (equip_type?, red_state?) => {
				this.SetJewelItem(equip_type)
				this.SetExpAndProp(equip_type)
				this.InitGoodsItem(equip_type)
				this.crave_red.visible = red_dot_mgr.CheckRedStatus(local_ModuleType.JEWEL_CRAVE_RED, equip_type)
			})

			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				let equip_stone_refine_goods_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_refine_goods", false)
				if (equip_stone_refine_goods_cfg) {
					for (let _tmpi in goods_list) {
						let vo = goods_list[_tmpi]
						for (let key in equip_stone_refine_goods_cfg) {
							if (vo.type_id == equip_stone_refine_goods_cfg[key].goods_id) {
								let goods_num = goods_model.GetTypeGoodsNum(vo.type_id)
								let select = goods_id_to_index_[vo.type_id]
								if (select) {
									goods_item_list_[select].ForceSetNumber(goods_num)
									if (goods_num == 0 && now_select_goods_id_ == vo.type_id) {
										this.NextSelect()
									} else if (goods_num > 0 && !now_select_goods_id_) {
										this.SelectGoods(vo.type_id)
									}
								}
								//this:UpdateRed()
								break
							}
						}
					}
				}
			})

			/*
			let update_func = () => {
				if (this.Content11.scrollV > this.Content11.preferredHeight - this.tab_scroller.height - 5) {
					this._arrow.visible = false
				} else {
					this._arrow.visible = true
				}
				this.UpdateArrowRed()
			}
			this.tab_scroller.addEventListener(Laya.UIEvent.CHANGE, update_func, this)
			*/

			this.BindEvent(model, EquipEvent.UPDATE_JEWEL_CARVE_RED, () => {
				this.UpdateRed()
			})
		}

		this.UpdateArrowRed = () => {
			let red = false
			// let a = this.Content.y
			// let b = this.Content11.height
			let show_buttom_num = /*this.Content11.scrollV*/ + this.tab_scroller.height
			for (let key in sub_item_list_) {
				let item = sub_item_list_[key]
				if (item.y > show_buttom_num && item["red_dot"] && item["red_dot"].visible) {
					red = true
					break
				}
			}
			this.arrow_red.visible = red
		}

		this.LocalDeleteMe = () => {
			for (let key in goods_item_list_) {
				goods_item_list_[key].DeleteMe()
				goods_item_list_[key] = null
			}
			goods_item_list_ = []
			for (let key in sub_item_list_) {
				sub_item_list_[key].DeleteMe()
				sub_item_list_[key] = null
			}
			sub_item_list_ = []
			for (let key in attr_item_list_) {
				attr_item_list_[key].DeleteMe()
				attr_item_list_[key] = null
			}
			attr_item_list_ = []
			if (target_item_) {
				target_item_.DeleteMe()
				target_item_ = null
			}
			// res_mgr.ClearUIEffect(this.effect_group)
			unlock_config_ = null
			if (this.maskTweenid != null) {
				SYTweenLite.Stop(this.maskTweenid)
				this.maskTweenid = null
			}
			super.DeleteMe()
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
	}

	_img_bg: Laya.Image
	cur_item_group: Laya.HBox
	pos_6: Laya.Box
	bg: Laya.Image
	lock6: Laya.Image
	icon6: Laya.Image
	pos_5: Laya.Box
	bg4: Laya.Image
	lock5: Laya.Image
	icon5: Laya.Image
	pos_4: Laya.Box
	bg0: Laya.Image
	lock4: Laya.Image
	icon4: Laya.Image
	pos_3: Laya.Box
	bg1: Laya.Image
	lock3: Laya.Image
	icon3: Laya.Image
	pos_2: Laya.Box
	bg2: Laya.Image
	lock2: Laya.Image
	icon2: Laya.Image
	pos_1: Laya.Box
	bg3: Laya.Image
	lock1: Laya.Image
	icon1: Laya.Image
	tab_scroller: Laya.Panel
	Content11: Laya.VBox
	_img_bg4: Laya.Image
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	_Label2: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	_gp_processbar: Laya.Box
	_img_bar_fill: Laya.Image
	exp_heigh_light: Laya.Image
	lb_exp: Laya.Label
	_Image6: Laya.Image
	Content1: Laya.HBox
	btn_allCrave: Laya.Image
	lb_allCrave: Laya.Label
	crave_red: Laya.Image
	btn_crave: Laya.Image
	lb_carve: Laya.Label
	_arrow: Laya.Image
	arrow_red: Laya.Image
	effect_group: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this.cur_item_group,
			this.pos_6,
			this.bg,
			this.lock6,
			this.icon6,
			this.pos_5,
			this.bg4,
			this.lock5,
			this.icon5,
			this.pos_4,
			this.bg0,
			this.lock4,
			this.icon4,
			this.pos_3,
			this.bg1,
			this.lock3,
			this.icon3,
			this.pos_2,
			this.bg2,
			this.lock2,
			this.icon2,
			this.pos_1,
			this.bg3,
			this.lock1,
			this.icon1,
			this.tab_scroller,
			this.Content11,
			this._img_bg4,
			this._Image1,
			this._Label1,
			this._Image3,
			this._Label2,
			this._Scroller1,
			this.Content,
			this._gp_processbar,
			this._img_bar_fill,
			this.exp_heigh_light,
			this.lb_exp,
			this._Image6,
			this.Content1,
			this.btn_allCrave,
			this.lb_allCrave,
			this.crave_red,
			this.btn_crave,
			this.lb_carve,
			this._arrow,
			this.arrow_red,
			this.effect_group,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"cur_item_group",
				"pos_6",
				"bg",
				"lock6",
				"icon6",
				"pos_5",
				"bg4",
				"lock5",
				"icon5",
				"pos_4",
				"bg0",
				"lock4",
				"icon4",
				"pos_3",
				"bg1",
				"lock3",
				"icon3",
				"pos_2",
				"bg2",
				"lock2",
				"icon2",
				"pos_1",
				"bg3",
				"lock1",
				"icon1",
				"tab_scroller",
				"Content11",
				"_img_bg4",
				"_Image1",
				"_Label1",
				"_Image3",
				"_Label2",
				"_Scroller1",
				"Content",
				"_gp_processbar",
				"_img_bar_fill",
				"exp_heigh_light",
				"lb_exp",
				"_Image6",
				"Content1",
				"btn_allCrave",
				"lb_allCrave",
				"crave_red",
				"btn_crave",
				"lb_carve",
				"_arrow",
				"arrow_red",
				"effect_group",
			])
	}
}
window["EquipJewelCraveView"] = EquipJewelCraveView