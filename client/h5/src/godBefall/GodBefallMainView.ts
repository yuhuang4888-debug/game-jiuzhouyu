import { BaseItem1 } from "../common/BaseItem1"
import { Vector3 } from "../util/Vector3"
import { Util, SetSizeDeltaX, GetSizeDeltaX, GetSizeDeltaY, HtmlColorTxt, PlayBigEffect } from "../util/Util"
import { Mathf } from "../util/Mathf"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { Runner } from "../util/Runner"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ModuleType } from "../common/RedDotManager"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { GodBefallModel, GodBefallEvent, GodBefallDefine } from "../commonModel/GodBefallModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { GodBefallEquipItem } from "./GodBefallEquipItem"
import { GodBefallSkillItem } from "./GodBefallSkillItem"
import { GodBefallAttrItem } from "./GodBefallAttrItem"
import { GodBefallTabBtn } from "./GodBefallTabBtn"

import "./GodBefallEquipView"
import "./GodBefallStageView"
import "./GodBefallStarTipsView"
import "./GodBefall1TipsView"
import "./GodBefallActiveTipsView"
import "./GodBefallWayView"
import "../common/SkillTipsView"
import { CompositeModel } from "../commonModel/CompositeModel"

export class GodBefallMainView extends BaseItem1 {
	CheckButtonStage
	CheckSameRedDot
	CreateTabBar
	Dispose

	FinishAction
	InitEvent
	LoadSuccess
	Raw_gp_model
	ReOpen_callback

	StartProAction
	StartUpdate
	StopUpdate
	SwitchBtn
	Update
	UpdateActiveData
	UpdateAttrItems
	UpdateCostItems
	UpdateEquipItems
	UpdateProgress
	UpdateShowData
	UpdateSkillItems
	UpdateStar
	UpdateUIModel
	UpdateUpData
	PlaySoundEffect

	_cost_item_
	_cost_list_
	//_gp_eff_pro
	_img_shenge

	_model
	_red_shenge
	_shenge
	_star_list_
	_tabBar_
	ac_attr_loop_list
	ac_attr_loop_mgr
	ac_equip_loop_list
	ac_equip_loop_mgr
	ac_skill_loop_list
	ac_skill_loop_mgr
	ac_talent_loop_list
	ac_talent_loop_mgr

	sound_mgr
	cur_channel

	first_anim = true
	last_lv = 0
	anim_loop = 0
	config_god_lv
	config_god_star
	config_god_stage
	sound_cfg = {
		3001: "NPC_Voice36b",
		3002: "NPC_Voice16b",
		3003: "NPC_Voice12b",
		4001: "Pet_Voice17b",
		4002: "NPC_Voice05b",
		4003: "NPC_Voice35b",
		4004: "NPC_Voice29b",
		5001: "NPC_Voice28b",
		5002: "NPC_Voice14b",
		5003: "NPC_Voice19b"
	}

	public constructor(parent?) {
		super(parent)
		this.base_file = "godBefall"
		this.layout_file = "GodBefallMainView"
		this.preload_server_config = {
			"config_god_lv": false,
			"config_god_star": false,
			"config_god_stage": false,
			"config_god_star_up_limit": false
		}
		this.preload_client_config = {
			"ConfigGodBefall": false
		}

		this._model = GodBefallModel.GetInstance()
		this.sound_mgr = SoundManager.GetInstance()
		let local_Message = Message
		let local_GlobalEventSystem = GlobalEventSystem
		let OPEN_VIEW = EventName.OPEN_VIEW
		let local_GodBefallEvent = GodBefallEvent
		let goods_model = GoodsModel.GetInstance()
		let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark
		let local_ModuleType = ModuleType
		let runner = Runner.GetInstance()

		this._cost_list_ = null
		//let _ac_equip_ = null
		this.ac_equip_loop_list = null
		this.ac_equip_loop_mgr = null
		//let _ac_attr_ = null
		this.ac_attr_loop_list = null
		this.ac_attr_loop_mgr = null
		//let _ac_skill_ = null
		this.ac_skill_loop_list = null
		this.ac_skill_loop_mgr = null
		//let _ac_talent_ = null
		this.ac_talent_loop_list = null
		this.ac_talent_loop_mgr = null

		this._star_list_ = null
		this._cost_item_ = null
		this._tabBar_ = null
		let battle_select = false
		let _text_fsb = null
		//let _uimodel_ = null
		let _cur_data_ = null
		let _cur_show_id_ = null
		let _cur_btn_index_ = 0
		let _is_max_ = false
		let _tweening_ = false
		let _update_id_ = null
		let _move_x_ = 0
		let _cur_move_x_ = 0
		let _last_move_x = 0
		//let _max_width_ = 0
		let _tween_speed_ = 2700
		let _cur_lv_data_ = null
		//let _power_list_ = []

		this.load_callback = () => {
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				SetAnchoredPositionX(this._Label2, 0)
				SetAnchoredPositionX(this._Label3, 0)
				this._Label2.lineSpacing = 0.8
				this._Label3.lineSpacing = 0.8
				this._Label2.size = 16
				this._Label3.size = 16
			}
			*/
			this.equip_scroll.scrollBar.visible = false
			this._scroll_attr.scrollBar.visible = false
			this.scr1.scrollBar.visible = false
			this.scr2.scrollBar.visible = false

			this._lb_act_count.style.fontSize = 20
			this._lb_act_count.style.wordWrap = false
			this._lb_act_count.style.color = "#663915"

			this.config_god_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_lv", false)
			this.config_god_star = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_star", false)
			this.config_god_stage = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_stage", false)

			this.InitEvent()
			this.LoadSuccess()
		}

		this.ReOpen_callback = () => {
			_cur_show_id_ = null
			this.UpdateShowData()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_equip, () => {
				if (!_cur_data_) {
					return
				}
				let vo = this._model.GetGodVoInDic(_cur_data_.id)
				if (!vo) {
					local_Message.show("请先激活降神")
					return
				}
				local_GlobalEventSystem.Fire(OPEN_VIEW, "GodBefallEquipView", _cur_data_)
			}, this, true)

			Util.AddClickEvent(this._btn_stage, () => {
				if (!_cur_data_) {
					return
				}
				let vo = this._model.GetGodVoInDic(_cur_data_.id)
				if (!vo) {
					local_Message.show("请先激活降神")
					return
				}
				local_GlobalEventSystem.Fire(OPEN_VIEW, "GodBefallStageView", _cur_data_)
			}, this, true)

			Util.AddClickEvent(this._btn_upgrade, () => {
				if (!_cur_data_) {
					return
				}
				if (_tweening_) {
					return
				}
				_tweening_ = true

				//Test
				// this.anim_loop = 1
				// this.StartProAction(4, 20)
				// return

				this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44003, "i", _cur_data_.id)
			}, this, true)

			Util.AddClickEvent(this._btn_active, () => {
				if (!_cur_data_) {
					return
				}
				this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44002, "i", _cur_data_.id)
			}, this, true)

			Util.AddClickEvent(this._btn_attr, () => {
				this.SwitchBtn(1)
			}, this)

			Util.AddClickEvent(this._btn_skill, () => {
				this.SwitchBtn(2)
			}, this)

			Util.AddClickEvent(this.gp_trans, (event?) => {
				if (!_cur_data_) {
					return
				}
				if (battle_select) {
					Message.show("无法取消当前变身，可切换其他已激活降神")
					return
				}
				battle_select = false
				this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44006, "ci", 1, _cur_data_.id)
			}, this, true)

			Util.AddClickEvent(this.compose_gp, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBefallAutoComposeView")
			}, this, true)

			Util.AddClickEvent(this._shenge, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GodBefallStrongGodView")
			}, this, true)

			this.BindEvent(this._model, local_GodBefallEvent.UPDATE_GOD_VO, (id?) => {
				if (_cur_data_ && _cur_data_.id == id) {
					this.UpdateShowData()
					this.CheckButtonStage()
				}
			})

			this.BindEvent(goods_model, GoodsModel.CHANGE_GOD_LIST, () => {
				if (!_cur_data_) {
					return
				}
				let vo = this._model.GetGodVoInDic(_cur_data_.id)
				if (!vo) {
					return
				}
				let equip_list = this._model.GetEquipList(vo)
				this.UpdateEquipItems(equip_list)
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPGRADE_SUCCESS, (scmd?) => {
				if (_cur_data_ && _cur_data_.id == scmd.god_id) {
					_tweening_ = true
					let ldata = this._model.GetLvData(scmd.god_id, scmd.lv, this.config_god_lv)
					_cur_lv_data_ = ldata
					this.anim_loop = scmd.lv - this.last_lv
					if (scmd.lv == 100) {
						this.anim_loop = this.anim_loop - 1
					}
					if (ldata.exp > 0 || ldata.lv == 100) {
						this.StartProAction(scmd.exp, ldata.exp)
					}
					PlayBigEffect('ui_shengjitexiao');
				}
			})

			this.BindEvent(this._model, local_GodBefallEvent.ACTIVE_SUCCESS, (scmd?) => {
				PlayBigEffect('ui_ZiTi_Jihuo');
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPDATE_AUTO_COMPOSE_VIEW, () => {
				this.CheckButtonStage()
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPGRADE_FAIL, (scmd?) => {
				if (_cur_data_ && _cur_data_.id == scmd.god_id) {
					_tweening_ = false
					this.FinishAction()
				}
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPDATE_BATTLE_ID, (god_id?) => {
				if (_cur_data_ && _cur_data_.id == god_id) {
					//this._cb_battle.selected = true
					battle_select = true
					this.UpdateShowData()
				}
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPDATE_GOODS_RED, () => {
				if (!_cur_data_) {
					return
				}
				let vo = this._model.GetGodVoInDic(_cur_data_.id)
				this.CheckButtonStage()
				if (vo) {
					this.UpdateUpData()
					this.CheckSameRedDot(_cur_data_.id)
				} else {
					this.UpdateActiveData()
				}
			})

			this.BindEvent(CompositeModel.GetInstance(), CompositeModel.UPDATE_COMPOSE_RED, () => {
				if (!_cur_data_) {
					return
				}
				let vo = this._model.GetGodVoInDic(_cur_data_.id)
				this.CheckButtonStage()
				if (vo) {
					this.UpdateUpData()
					this.CheckSameRedDot(_cur_data_.id)
				} else {
					this.UpdateActiveData()
				}
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPDATE_NO_POWER, (scmd?) => {
				if (!_cur_data_) {
					return
				}
				if (scmd.god_id != _cur_data_.id) {
					return
				}
				let vo = this._model.GetGodVoInDic(_cur_data_.id)
				if (vo) {
					return
				}
				_text_fsb.Updatefighting(scmd.power)
			})

			this.BindEvent(this._model, local_GodBefallEvent.STOP_GOD_SOUND, () => {
				if (this.cur_channel) {
					this.sound_mgr.StopSoundEffect(this.cur_channel)
					this.cur_channel = null
				}
			})

			this.BindEvent(GlobalEventSystem, EventName.CHANGE_SUB_VIEW, (view_name) => {
				if (view_name == "GodBefallMainView") {
					return
				} else {
					if (this.cur_channel) {
						this.sound_mgr.StopSoundEffect(this.cur_channel)
						this.cur_channel = null
					}
				}
			})
		}

		this.Dispose = () => {
			_cur_show_id_ = null
		}

		this.LoadSuccess = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGodBefall", true)
			let GodBefallTabData = cfg && cfg["GodBefallTabData"]
			this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44000)

			_text_fsb = new FightingShowSmallItem(this._fsb_item)
			_text_fsb.Load()

			this.ac_equip_loop_list = []
			this.ac_equip_loop_mgr = new LoopScrowViewMgr()
			this.ac_equip_loop_mgr.SetData(this.equip_scroll, GodBefallEquipItem, this.ac_equip_loop_list, LoopScrCon.Horizontal)

			this.ac_attr_loop_list = this.ac_attr_loop_list || {}
			this.ac_attr_loop_mgr = new LoopScrowViewMgr()
			this.ac_attr_loop_mgr.SetData(this._scroll_attr, GodBefallAttrItem, this.ac_attr_loop_list, LoopScrCon.Vertical)

			this.ac_skill_loop_list = []
			this.ac_skill_loop_mgr = new LoopScrowViewMgr()
			this.ac_skill_loop_mgr.SetData(this.scr1, GodBefallSkillItem, this.ac_skill_loop_list, LoopScrCon.Horizontal)

			this.ac_talent_loop_list = []
			this.ac_talent_loop_mgr = new LoopScrowViewMgr()
			this.ac_talent_loop_mgr.SetData(this.scr2, GodBefallSkillItem, this.ac_talent_loop_list, LoopScrCon.Horizontal)

			this._star_list_ = []
			this._cost_list_ = []

			let i = 0
			do {
				let image = new Laya.Image
				image.visible = false
				image.height = 28
				image.width = 28
				this._gp_star.addChild(image)
				this._star_list_[i] = image
				i = i + 1
			} while ((i < GodBefallDefine.STAR_COUNT))

			for (let _tmpi in GodBefallTabData) {
				let vo = GodBefallTabData[_tmpi]
				let color = vo[2].color
				this._model.Fire(GodBefallEvent.REQUEST_PROTO, 44017, "c", color)
			}
			this.CreateTabBar(GodBefallTabData)
			this.CheckButtonStage()
			this.SwitchBtn(1)
		}

		this.CheckButtonStage = () => {
			// 暂时屏蔽
			return

			// 神格按钮
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGodBefall", true)
			let GodBefallTabData = cfg && cfg["GodBefallTabData"]
			let open_dir = this._model.CheckOpenShenGe(GodBefallTabData)
			let open = false
			for (let key in open_dir) {
				let vo = open_dir[key]
				if (vo) {
					open = true
					break
				}
			}
			let width = (open && (100) || (0))
			SetSizeDeltaX(this._img_shenge, width)
			this._shenge.visible = open
			let red = this._model.RefreshShenGeRed()
			this._red_shenge.visible = red

			// 智能合成按钮
			let dir = this._model.CheckCanAutoCompose(GodBefallTabData)
			let bool = (Util.TableSize(dir) > 0 && (true) || (false))
			this.compose_gp.visible = bool
			width = (bool && (100) || (0))
			SetSizeDeltaX(this.compose_gp, width)
			// TODO dxj
			this.auto_compose_red.visible = bool
		}

		this.UpdateSkillItems = (slist?, tlist?) => {
			this.ac_skill_loop_list = slist
			this.ac_talent_loop_list = tlist

			this.ac_skill_loop_mgr.replaceAll(this.ac_skill_loop_list)
			this.ac_talent_loop_mgr.replaceAll(this.ac_talent_loop_list)
		}

		this.UpdateEquipItems = (list?) => {
			let only_update_data = this.ac_equip_loop_list.length == list.length
			this.ac_equip_loop_list = list
			this.ac_equip_loop_mgr.replaceAll(this.ac_equip_loop_list, null, only_update_data)
		}

		this.UpdateAttrItems = (list?) => {
			this.ac_attr_loop_list = list
			if (!this.is_loaded) {
				return
			}
			this.ac_attr_loop_mgr.replaceAll(this.ac_attr_loop_list)
		}

		this.UpdateCostItems = (list?) => {
			if (this._cost_list_) {
				for (let i = 0; i < this._cost_list_.length; i++) {
					let item = this._cost_list_[i]
					item.SetVisible(false)
				}
			}

			let i = 0
			do {
				let vo = list[i]
				let item = this._cost_list_[i]
				if (!item) {
					item = new BaseAwardItem(this._gp_cost)
					item.Load()
					item.SetItemSize(77, 77)
					this._cost_list_[i] = item
				}
				let own = goods_model.GetTypeGoodsNum(vo[0])
				item.ExcuteCallback(() => {
					item.SetData(vo[0])
					item.ForceSetNumber(own)
					item.SetVisible(true)
				}
				)
				i = i + 1
			} while ((i < list.length)
			)
		}

		this.UpdateStar = (star?) => {
			let max_star = this._model.GetMaxStarCount(_cur_data_.id, this.config_god_star) || GodBefallDefine.STAR_COUNT
			let i = 0
			do {
				let image = this._star_list_[i]
				let sp_name = (star > i && ("com_star_1a") || ("com_star_2"))
				ResManager.GetInstance().SetImageSprite(this, image, "godBefall", sp_name)
				i = i + 1
				image.visible = i <= max_star
			} while ((i < this._star_list_.length)
			)
		}

		this.UpdateActiveData = () => {
			if (!_cur_data_) {
				return
			}
			let data = _cur_data_
			let gdata = this._model.GetGodData(data.id)
			let cond_goods = this._model.GetJsonCacheAndSet("cond_good@" + data.id, gdata.condition)
			let cond_lvs = this._model.GetJsonCacheAndSet("cond_lv@" + data.id, gdata.condition_lv)
			let cond_all_lv = this._model.GetJsonCacheAndSet("cond_all_lv@" + data.id, gdata.condition_all_lv)
			if (cond_lvs.length > 0) {
				let cond_lv = cond_lvs[0]
				let cdata = this._model.GetGodData(cond_lv[0])
				let vo = this._model.GetGodVoInDic(cdata.id)
				let color = (vo && vo.lv >= cond_lv[1] && (local_Enum_ColorUtil_Dark.GREEN) || (local_Enum_ColorUtil_Dark.RED))
				let lv_str = HtmlColorTxt(cond_lv[1], color)
				this._lb_cond.text = Util.StrToHTML(cdata.name + "达到" + lv_str + "级")
				this._lb_cond.visible = true
			} else if (cond_all_lv[0]) {
				let id_list = cond_all_lv[0]
				let all_lv = Number(id_list[1])
				let lv = 0
				for (let _tmpi in id_list[1]) {
					let id = id_list[1][_tmpi]
					let vo = this._model.GetGodVoInDic(Number(id))
					if (vo) {
						lv = lv + vo.lv
					}
				}
				let color = (lv >= all_lv && (local_Enum_ColorUtil_Dark.GREEN) || (local_Enum_ColorUtil_Dark.RED))
				let lv_str = HtmlColorTxt(all_lv, color)
				this._lb_cond.text = Util.StrToHTML("降神总等级达到" + lv_str + "级")
				this._lb_cond.visible = true
			} else {
				this._lb_cond.visible = false
			}
			let has_goods = cond_goods.length > 0
			if (has_goods) {
				if (!this._cost_item_) {
					this._cost_item_ = new BaseAwardItem(this._gp_act_item)
					this._cost_item_.Load()
					this._cost_item_.SetItemSize(90, 90)
				}
				let cond_good = cond_goods[0]
				let [type_id, temp] = goods_model.GetMappingTypeId(cond_good[0], cond_good[1])
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				let name = HtmlColorTxt(basic.goods_name, ColorUtil.GetColorDark(basic.color))
				let own = goods_model.GetTypeGoodsNum(type_id)

				let color = (own >= Number(cond_good[2]) && (local_Enum_ColorUtil_Dark.WHITE) || (local_Enum_ColorUtil_Dark.RED))
				let own_str = HtmlColorTxt(own, color)
				this._lb_act_count.innerHTML = Util.StrToHTML(name + "(" + own_str + "/" + cond_good[2] + ")")
				this._cost_item_.SetData(type_id)
			}
			this._red_active.visible = this._model.GetRedStatus(local_ModuleType.GOD_ACTIVE, data.id)
			this._lb_act_count.visible = has_goods
		}

		this.UpdateUpData = () => {
			if (!_cur_data_) {
				return
			}
			let vo = this._model.GetGodVoInDic(_cur_data_.id)
			let ldata = this._model.GetLvData(_cur_data_.id, (vo && (vo.lv) || (1)), this.config_god_lv)
			this.UpdateProgress((vo && (vo.exp) || (0)), ldata.exp, vo && !_is_max_)
			if (!_is_max_) {
				this.UpdateCostItems(this._model._lv_goods_list)
			}
		}

		this.UpdateShowData = () => {
			if (_tweening_) {
				return
			}
			if (!_cur_data_) {
				return
			}
			let data = _cur_data_
			let vo = this._model.GetGodVoInDic(data.id)
			let has_vo = !(!vo)
			battle_select = has_vo && vo.is_battle == 1
			this.img_trans.visible = battle_select

			let attr_list = this._model.GetAllAttrListByVo(data.id, vo, this.config_god_lv, this.config_god_star, this.config_god_stage)
			this.UpdateAttrItems(attr_list)
			let star = (vo && (vo.star) || (0))
			let grade = (vo && (vo.grade) || (0))
			this.UpdateStar(star)
			this._lb_name.text = data.name
			this._gp_active.visible = !vo
			this._gp_upgrade.visible = !(!vo)
			this.lb_stage.text = grade + "阶"

			let ndata = (vo && (this._model.GetLvData(data.id, vo.lv + 1, this.config_god_lv)) || (null))
			_is_max_ = vo && !ndata
			this.lb_title1.visible = !_is_max_
			this._gp_cost.visible = !_is_max_
			this._btn_upgrade.visible = !_is_max_
			this._img_max.visible = _is_max_
			this.gp_trans.visible = vo != null
			if (vo) {
				this.UpdateUpData()
				_text_fsb.Updatefighting(vo.power)
			} else {
				this.UpdateActiveData()
				this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44015, "i", data.id)
			}
			let equips = this._model.GetEquipList(vo)
			this.UpdateEquipItems(equips)
			let skills = this._model.GetSkillList(data.id, grade)
			let talents = this._model.GetTalentList(data.id)
			this.UpdateSkillItems(skills, talents)
			this.UpdateUIModel(data)
			let lv = (vo && (vo.lv) || (0))
			/*
			if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
				this._lb_lv.text = "Lv." + lv
			} else {
				this._lb_lv.text = lv + "级"
			}
			*/
			this._lb_lv.text = lv + "级"
			this.last_lv = Number(lv)
			this.CheckSameRedDot(data.id)
		}

		this.CreateTabBar = (GodBefallTabData?) => {
			if (!GodBefallTabData) {
				return
			}
			if (!this._tabBar_) {
				this._tabBar_ = new UIVerTabBar(this._gp_tab)
				this._tabBar_.Load()
				/*
				this._tabBar_.SetEXLoadCallback(() => {
					if (this._tabBar_.transscroll) {
						SetSizeDeltaX(this._tabBar_.transscroll, GetSizeDeltaX(this.Content1))
					}
				})
				*/
			}
			let call_fun = (id?) => {
				if (_cur_data_ && _cur_data_.id == id) {
					return
				}
				_cur_data_ = this._model.GetGodData(id)
				this._model._cur_data = _cur_data_
				this._model._com_god_id = (_cur_data_ && (_cur_data_.id) || (null))
				this.PlaySoundEffect(id)
				this.UpdateShowData()
			}
			this._tabBar_.SetTabBar(GodBefallTabData, call_fun, GetSizeDeltaY(this._gp_tab), null, GodBefallTabBtn)
			let is_battle = false
			let i = 0
			do {
				let j = 0
				do {
					let god_id = GodBefallTabData[i][1][j]
					let vo = this._model.GetGodVoInDic(god_id)
					if (vo && vo.is_battle == 1) {
						is_battle = true
						this._tabBar_.SetSelectTab(i, j)
						break
					}
					j = j + 1
				} while ((j < GodBefallTabData[i][1].length)
				)
				i = i + 1
			} while ((i < GodBefallTabData.length)
			)
			if (!is_battle) {
				this._tabBar_.SetSelectTab(0, 0)
			}
		}

		this.PlaySoundEffect = (god_id) => {
			if (this.cur_channel) {
				this.sound_mgr.StopSoundEffect(this.cur_channel)
				this.cur_channel = null
			}

			let sound = this.sound_cfg[god_id]
			if (sound) {
				this.cur_channel = this.sound_mgr.PlaySoundEffect(sound, false, null, "npc")
			}
		}

		this.UpdateUIModel = (data?) => {
			let id = data.id
			if (_cur_show_id_ == id) {
				return
			}
			let weapon_model_id = data.model
			// let wing_id = data.model
			let mode_data = {
				clothe_res_id: data.model,
				weapon_res_id: weapon_model_id,
				type: UI_MODEL_TYPE.GOD,
				layer_value: this.layer_value,
				// wing_id: wing_id,
				scale: 1 * data.model_ratio,
				position: new Vector3(0, -1.5, 0),
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model, mode_data)
			_cur_show_id_ = id
		}

		this.SwitchBtn = (index?) => {
			if (_cur_btn_index_ == index) {
				return
			}
			_cur_btn_index_ = index
			if (index == 1) {
				ResManager.GetInstance().SetImageSprite(this, this._btn_attr, "godBefall", "ui_role_btn_1")
				this._lb_attr.color = "#9b572f"
				ResManager.GetInstance().SetImageSprite(this, this._btn_skill, "godBefall", "ui_role_btn_2")
				this._lb_skill.color = "#d7d9ed"
				this._scroll_attr.visible = true
				this._gp_skill.visible = false
			} else if (index == 2) {
				ResManager.GetInstance().SetImageSprite(this, this._btn_attr, "godBefall", "ui_role_btn_2")
				this._lb_attr.color = "#d7d9ed"
				ResManager.GetInstance().SetImageSprite(this, this._btn_skill, "godBefall", "ui_role_btn_1")
				this._lb_skill.color = "#9b572f"
				this._scroll_attr.visible = false
				this._gp_skill.visible = true
			}
		}

		this.UpdateProgress = (now?, max?, show?) => {
			if (_tweening_) {
				return
			}
			let can_up = max > 0
			this._lb_pro.text = can_up ? (now + "/" + max) : ("MAX")
			let amount = can_up ? (now / max) : 1
			this._img_pro.width = amount * 420
			_last_move_x = amount
		}

		this.StartProAction = (now?, max?) => {
			if (max == 0) {
				_move_x_ = 1
			} else {
				_move_x_ = now / max
			}
			_cur_move_x_ = _last_move_x
			this.StartUpdate()
		}

		this.FinishAction = () => {
			_tweening_ = false
			_move_x_ = null
			_last_move_x = _cur_move_x_
			_cur_move_x_ = 0
			this.StopUpdate()
			this.UpdateShowData()
		}

		this.StartUpdate = () => {
			if (!_update_id_) {
				this.first_anim = true
				_update_id_ = runner.AddRunObj(this, 1)
			}
		}

		this.StopUpdate = () => {
			if (_update_id_) {
				runner.RemoveRunObj(_update_id_)
				_update_id_ = null
			}
		}

		this.Update = (now_time?, elapse_time?) => {
			if (!_tweening_) {
				return
			}
			if (!_move_x_ && _move_x_ != 0) {
				this.FinishAction()
				return
			}

			_cur_move_x_ = _cur_move_x_ + _tween_speed_ * elapse_time * 0.001
			if (this.anim_loop > 0) {
				if (_cur_move_x_ > 1) {
					this.anim_loop = this.anim_loop - 1
					_cur_move_x_ = 0
				}
				if (!this._img_pro) {
					return
				}
				this._img_pro.width = (_cur_move_x_ || 0) * 430
				let max = _cur_lv_data_.exp
				let now = Mathf.Round(_cur_move_x_ * max)
				this._lb_pro.text = now + "/" + max
			} else {
				if (_cur_move_x_ >= _move_x_) {
					this.FinishAction()
					return
				} else {
					if (!this._img_pro) {
						return
					}
					this._img_pro.width = (_cur_move_x_ || 0) * 430
					let max = _cur_lv_data_.exp
					let now = Mathf.Round(_cur_move_x_ * max)
					this._lb_pro.text = now + "/" + max
				}
			}
		}

		this.CheckSameRedDot = (id?) => {
			this._red_upgrade.visible = this._model.GetRedStatus(local_ModuleType.GOD_LV, id)
			this._red_stage.visible = this._model.GetRedStatus(local_ModuleType.GOD_STAGE, id)
			this._red_equip.visible = this._model.GetRedStatus(local_ModuleType.GOD_STAR, id)
									|| this._model.GetGodSepcRedStatusAll(id)
									||this._model.GetAutoComposeRed()
		}
	}

	public DeleteMe() {
		if (this.cur_channel) {
			this.sound_mgr.StopSoundEffect(this.cur_channel)
			this.cur_channel = null
		}

		this.StopUpdate()
		if (this._tabBar_) {
			this._tabBar_.DeleteMe()
			this._tabBar_ = null
		}
		if (this._cost_item_) {
			this._cost_item_.DeleteMe()
			this._cost_item_ = null
		}
		if (this._cost_list_) {
			for (let key in this._cost_list_) {
				this._cost_list_[key].DeleteMe()
			}
			this._cost_list_ = null
		}
		this._star_list_ = null
		this._model._cur_data = null
		this.ac_equip_loop_list = null
		if (this.ac_equip_loop_mgr) {
			this.ac_equip_loop_mgr.DeleteMe()
			this.ac_equip_loop_mgr = null
		}

		this.ac_attr_loop_list = null
		if (this.ac_attr_loop_mgr) {
			this.ac_attr_loop_mgr.DeleteMe()
			this.ac_attr_loop_mgr = null
		}

		this.ac_skill_loop_list = null
		if (this.ac_skill_loop_mgr) {
			this.ac_skill_loop_mgr.DeleteMe()
			this.ac_skill_loop_mgr = null
		}
		//let _ac_talent_ = null
		this.ac_talent_loop_list = null
		if (this.ac_talent_loop_mgr) {
			this.ac_talent_loop_mgr.DeleteMe()
			this.ac_talent_loop_mgr = null
		}
		this.Dispose()
		super.DeleteMe()
	}

	_Image1: Laya.Image
	atrr_bg_img: Laya.Image
	_gp_model: Laya.Box
	_btn_equip: Laya.Box
	_Image4: Laya.Image
	_red_equip: Laya.Image
	_btn_attr: Laya.Image
	_lb_attr: Laya.Label
	_btn_skill: Laya.Image
	_lb_skill: Laya.Label
	_gp_tab: Laya.Box
	_con_top: Laya.Box
	_fsb_item: Laya.Box
	_Image5: Laya.Image
	_lb_name: Laya.Label
	_gp_star: Laya.HBox
	_btn_stage: Laya.Box
	_Image3: Laya.Image
	_red_stage: Laya.Image
	lb_stage: Laya.Label
	equip_scroll: Laya.List
	_scroll_attr: Laya.List
	_gp_upgrade: Laya.Box
	_gp_cost: Laya.HBox
	_btn_upgrade: Laya.Box
	_Image6: Laya.Image
	_Label1: Laya.Label
	_red_upgrade: Laya.Image
	_Image7: Laya.Image
	_img_pro: Laya.Image
	_lb_lv: Laya.Label
	_lb_pro: Laya.Label
	_img_max: Laya.Image
	lb_title1: Laya.Label
	_gp_skill: Laya.Box
	img2: Laya.Image
	img3: Laya.Image
	_lb_skill1: Laya.Label
	_lb_skill2: Laya.Label
	scr1: Laya.List
	scr2: Laya.List
	_gp_active: Laya.Box
	_btn_active: Laya.Box
	_Image10: Laya.Image
	_Label4: Laya.Label
	_red_active: Laya.Image
	_gp_act_item: Laya.Box
	_Group2: Laya.VBox
	_lb_act_count: Laya.HTMLDivElement
	_lb_cond: Laya.Label
	_Group3: Laya.HBox
	compose_gp: Laya.Box
	compose_img: Laya.Image
	auto_compose_red: Laya.Image
	shenge_gp: Laya.Box
	shenge_img: Laya.Image
	shenge_red: Laya.Image
	shenge_img1: Laya.Image
	gp_trans: Laya.Box
	img_transbg: Laya.Image
	lb_trans: Laya.Label
	img_trans: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this.atrr_bg_img,
			this._gp_model,
			this._btn_equip,
			this._Image4,
			this._red_equip,
			this._btn_attr,
			this._lb_attr,
			this._btn_skill,
			this._lb_skill,
			this._gp_tab,
			this._con_top,
			this._fsb_item,
			this._Image5,
			this._lb_name,
			this._gp_star,
			this._btn_stage,
			this._Image3,
			this._red_stage,
			this.lb_stage,
			this.equip_scroll,
			this._scroll_attr,
			this._gp_upgrade,
			this._gp_cost,
			this._btn_upgrade,
			this._Image6,
			this._Label1,
			this._red_upgrade,
			this._Image7,
			this._img_pro,
			this._lb_lv,
			this._lb_pro,
			this._img_max,
			this.lb_title1,
			this._gp_skill,
			this.img2,
			this.img3,
			this._lb_skill1,
			this._lb_skill2,
			this.scr1,
			this.scr2,
			this._gp_active,
			this._btn_active,
			this._Image10,
			this._Label4,
			this._red_active,
			this._gp_act_item,
			this._Group2,
			this._lb_act_count,
			this._lb_cond,
			this._Group3,
			this.compose_gp,
			this.compose_img,
			this.auto_compose_red,
			this.shenge_gp,
			this.shenge_img,
			this.shenge_red,
			this.shenge_img1,
			this.gp_trans,
			this.img_transbg,
			this.lb_trans,
			this.img_trans,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"atrr_bg_img",
				"_gp_model",
				"_btn_equip",
				"_Image4",
				"_red_equip",
				"_btn_attr",
				"_lb_attr",
				"_btn_skill",
				"_lb_skill",
				"_gp_tab",
				"_con_top",
				"_fsb_item",
				"_Image5",
				"_lb_name",
				"_gp_star",
				"_btn_stage",
				"_Image3",
				"_red_stage",
				"lb_stage",
				"equip_scroll",
				"_scroll_attr",
				"_gp_upgrade",
				"_gp_cost",
				"_btn_upgrade",
				"_Image6",
				"_Label1",
				"_red_upgrade",
				"_Image7",
				"_img_pro",
				"_lb_lv",
				"_lb_pro",
				"_img_max",
				"lb_title1",
				"_gp_skill",
				"img2",
				"img3",
				"_lb_skill1",
				"_lb_skill2",
				"scr1",
				"scr2",
				"_gp_active",
				"_btn_active",
				"_Image10",
				"_Label4",
				"_red_active",
				"_gp_act_item",
				"_Group2",
				"_lb_act_count",
				"_lb_cond",
				"_Group3",
				"compose_gp",
				"compose_img",
				"auto_compose_red",
				"shenge_gp",
				"shenge_img",
				"shenge_red",
				"shenge_img1",
				"gp_trans",
				"img_transbg",
				"lb_trans",
				"img_trans",
			])
	}
}
window["GodBefallMainView"] = GodBefallMainView