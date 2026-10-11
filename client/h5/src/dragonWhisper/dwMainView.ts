import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { TransformLevel, Util } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Message } from "../sysInfo/SysInfoController"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ColorType, ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { HtmlColorTxt } from "../util/Util"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { DragonWhisperModel, DrWsEvent } from "../commonModel/DragonWhisperModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { dwBossItem } from "./dwBossItem"
import { dwTab } from "./dwTab"

import "./dwAttrView"
import "./dwRecordView"

export class dwMainView extends BaseItem1 {
	CreateRadionBtn
	InitEvent
	LoadSuccess
	LocalDeleteMe
	ReOpen_callback

	SelectRadioBtn
	SendEnterProto
	UpdateAttrData
	UpdateMapData
	UpdateMonData
	UpdateMonItems
	UpdateMonItemsByProto
	UpdateRewardItems
	UpdateUIModel
	UpdateView

	mon_res
	tab_loop_mgr

	public constructor(parent?) {
		super(parent)
		this.base_file = "dragonWhisper"
		this.layout_file = "dwMainView"

		let _model = DragonWhisperModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Message = Message
		let goods_model = GoodsModel.GetInstance()
		let local_DrWsEvent = DrWsEvent
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		// let _uimodel_ = null
		// let _radioGroup_ = null
		let _cur_map_id_ = 1
		let _cur_mon_id_ = null
		let _cur_cost_data_ = null
		let _enough_ = false
		let _item_list_ = []
		let _mon_item_list_ = []
		let _mo_res_id_ = null

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._gp_tips, "resource/game/dragonWhisper/other/uilyboss_006.png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_map, "resource/game/dragonWhisper/other/uilyboss_004.png")
			this._Scroller2.hScrollBarSkin = ""
			this._reward_con.vScrollBarSkin = ""
			this._lb_count.style.fontSize = 20
			this._lb_count.style.color = "#ffffff"
			this._lb_count.style.wordWrap = false
			this._lb_player.style.fontSize = 20
			this._lb_player.style.color = "#ffffff"
			this._lb_player.style.wordWrap = false
			this._lb_attr.style.fontSize = 20
			this._lb_attr.style.color = "#dcca6e"
			this._lb_attr.style.leading = 15

			this.InitEvent()
			this.LoadSuccess()
		}

		this.ReOpen_callback = () => {
			if (this.mon_res) {
				this.UpdateUIModel(this.mon_res)
			}
		}

		this.LocalDeleteMe = () => {
			for (let _tmpi in _item_list_) {
				let item = _item_list_[_tmpi]
				item.DeleteMe()
			}
			_item_list_ = []
			for (let _tmpi in _mon_item_list_) {
				let item = _mon_item_list_[_tmpi]
				item.DeleteMe()
			}
			_mon_item_list_ = []

			// if (_radioGroup_) {
			// 	_radioGroup_.removeEventListener(local_eui.UIEvent.CHANGE, this.SelectRadioBtn, this)
			// }

			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.DeleteMe()
				this.tab_loop_mgr = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_ticket, () => {
				if (!_cur_cost_data_) {
					return
				}
				UIToolTipMgr.GetInstance().AppendGoodsTips(_cur_cost_data_.type_id)
			}, this, true)

			Util.AddClickEvent(this._btn_attr, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwAttrView")
			}, this, true)

			Util.AddClickEvent(this._btn_go, () => {
				let vinfo = _model.GetViewInfo()
				if (!vinfo) {
					return
				}
				if (vinfo.left_count <= 0) {
					local_Message.show("次数不足，无法前往")
				} else if (!_enough_) {
					if (!_cur_cost_data_) {
						return
					}
					let cdata = _cur_cost_data_
					let own = goods_model.GetTypeGoodsNum(cdata.type_id)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossPersonalAlert", cdata.type_id, own, cdata.need, cdata.price, null, cdata.name, null, () => {
						this.SendEnterProto(1)
					}
					)
				} else {
					this.SendEnterProto(0)
				}
			}, this, true)

			Util.AddClickEvent(this._btn_record, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwRecordView")
			}, this, true)

			this.BindEvent(_model, local_DrWsEvent.UPDATE_VIEW, () => {
				this.UpdateView()
			})

			this.BindEvent(_model, local_DrWsEvent.SELECT_BOSS_ITEM, (data?) => {
				this.UpdateMonData(data.mon_id)
			})
		}

		this.LoadSuccess = () => {
			_model.Fire(local_DrWsEvent.PROTO, 65101)

			let map_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_map
			let list = []
			for (let key in map_cfg) {
				table.insert(list, map_cfg[key])
			}
			this.CreateRadionBtn(list)
		}

		this.UpdateView = () => {
			let vinfo = _model.GetViewInfo()
			if (!vinfo) {
				return
			}
			let color = vinfo.left_count > 0 ? ColorUtil.GetColorLight(ColorType.GREEN) : ColorUtil.GetColorLight(ColorType.RED)
			let last_str = HtmlColorTxt(vinfo.left_count, color)
			this._lb_count.innerHTML = Util.StrToHTML("剩余进入次数：" + last_str + "/" + vinfo.all_count)
			let map_id = _cur_map_id_
			_cur_map_id_ = 0
			this.UpdateMapData(map_id)
		}

		this.SendEnterProto = (auto?) => {
			if (!(_cur_map_id_ > 0)) {
				local_Message.show("请先选择地图")
				return
			}
			if (!_cur_mon_id_) {
				local_Message.show("请先选择怪物")
				return
			}
			let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
			let b = _model.CheckAttrByMonID(mon_cfg, _cur_mon_id_)
			let func = () => {
				_model.Fire(local_DrWsEvent.PROTO, 65102, "cic", _cur_map_id_, _cur_mon_id_, auto)
			}

			if (b) {
				func()
			} else {
				let list = JSON.parse(mon_cfg[_cur_mon_id_].attr_list)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwAttrAlertView", list, func)
			}
		}

		this.UpdateMapData = (id?) => {
			if (_cur_map_id_ == id) {
				return
			}
			_cur_map_id_ = id
			let vinfo = _model.GetViewInfo()
			if (!vinfo) {
				return
			}
			let map_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_map
			let mdata = map_cfg[id]
			let cost_list = JSON.parse(mdata.cost)
			let tar_count = vinfo.all_count - vinfo.left_count + 1
			tar_count = Math.min(tar_count, cost_list.length)
			let cdata = null
			for (let _tmpi in cost_list) {
				let vo = cost_list[_tmpi]
				if (Number(vo[0]) == tar_count) {
					cdata = vo[1][0]
					break
				}
			}
			if (!cdata) {
				return
			}
			let [type_id, lock] = goods_model.GetMappingTypeId(cdata[0], cdata[1])
			let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[type_id]
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			let own = goods_model.GetTypeGoodsNum(type_id)
			_enough_ = cdata && own >= Number(cdata[2]) || false
			if (Number(cdata[2]) <= 0) {
				this._lb_own.color = ColorUtil.GetColorLight(ColorType.GREEN, false)
				this._lb_own.text = "首次免费"
				this._img_ticket.visible = false
			} else {
				this._lb_own.color = _enough_ ? ColorUtil.GetColorLight(ColorType.GREEN, false) : ColorUtil.GetColorLight(ColorType.RED, false)
				this._lb_own.text = own + "/" + cdata[2]
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_ticket, GameResPath.GetGoodsIconPath(basic.goods_icon))
				this._img_ticket.visible = true
			}
			_cur_cost_data_ = { type_id: type_id, need: Number(cdata[2]), name: basic.goods_name, price: goods_info.price }
			let minfo = _model.GetViewMapInfo(id)
			this._lb_player.innerHTML = "当前进入人数：" + String(minfo.role_num)
			this.UpdateMonItemsByProto(id)
		}

		this.UpdateMonItemsByProto = (map_id?) => {
			let minfo = _model.GetViewMapInfo(map_id)
			let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
			let map_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_map
			let mdata = map_cfg[map_id]
			let show_mon_list = JSON.parse(mdata.show_mon_list)
			let list = []
			for (let _tmpi in show_mon_list) {
				let vo = show_mon_list[_tmpi]
				let md = mon_cfg[Number(vo[0])]
				table.insert(list, { mon_id: Number(vo[0]), icon: md.mon_figure, type: md.type })
			}
			for (let _tmpi in minfo.mon_list) {
				let vo1 = minfo.mon_list[_tmpi]
				for (let _tmpi in list) {
					let vo2 = list[_tmpi]
					if (vo1.mon_id == vo2.mon_id) {
						vo2.reborn_time = vo1.reborn_time
						break
					}
				}
			}
			this.UpdateMonItems(list)
		}

		this.UpdateMonData = (mon_id?) => {
			if (_cur_mon_id_ == mon_id) {
				return
			}
			_cur_mon_id_ = mon_id
			let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
			let modata = mon_cfg[mon_id]
			this.UpdateRewardItems(JSON.parse(modata.preview_reward))
			let vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mon_id, false)
			this.mon_res = vo.icon
			// let modelCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigBoss", true)
			// let _modelCfg = BossModel.GetInstance().GetShowModelCfg(651, this.mon_res, modelCfg)
			// this.ui_scale = _modelCfg && _modelCfg.scale || 1
			// this.offset = _modelCfg && { x = _modelCfg.offset.x, y = _modelCfg.offset.y } || { x=0, y=0 }
			this.UpdateUIModel(this.mon_res)

			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_mon.name, mon_id, false)
			let str_name = cfg && cfg.name || 0
			let lv = cfg && cfg.lv || 0
			let str_lv = "Lv." + lv
			this._lb_boss_name.text = `${str_lv} ${str_name}`//str_lv + str_name
			this.UpdateAttrData(mon_id)
		}

		this.UpdateRewardItems = (list?) => {
			let i = 0
			if (i < list.length) {
				do {
					let vo = list[i]
					let item = _item_list_[i]
					if (!item) {
						item = new EquipmentItem(this._reward_con)
						item.Load()
						item.SetItemSize(80, 80)
						item.SetPosition(Number(i) % 2 == 0 ? 0 : 97, Math.floor(Number(i) / 2) * 89)
						_item_list_[i] = item
					}
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					item.SetData(type_id)
					item.SetVisible(true)
					i = i + 1
				} while (i < list.length)
			}

			i = list.length
			if (i < _item_list_.length) {
				do {
					_item_list_[i].SetVisible(false)
					i = i + 1
				} while ((i < _item_list_.length)
				)
			}
		}

		this.UpdateMonItems = (list?) => {
			let i = 0
			if (i < list.length) {
				do {
					let vo = list[i]
					let item = _mon_item_list_[i]
					if (!item) {
						let group = this["_Group" + (1 + i)]
						item = new dwBossItem(group)
						item.SetType(vo.type)
						item.Load()
						_mon_item_list_[i] = item
					}
					item.ExcuteCallback(() => {
						item.SetData(vo)
						item.display_obj.visible = true
						if (!_cur_mon_id_) {
							_model.Fire(local_DrWsEvent.SELECT_BOSS_ITEM, list[0])
						}
					}
					)
					i = i + 1
				} while (i < list.length)
			}

			i = list.length
			if (i < _mon_item_list_.length) {
				do {
					_mon_item_list_[i].display_obj.visible = false
					i = i + 1
				} while ((i < _mon_item_list_.length)
				)
			}
		}

		this.UpdateAttrData = (mon_id?) => {
			let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
			let md = mon_cfg[mon_id]
			let list = []
			let name = null
			let num = null
			let color = null
			let down = null
			let attr_cfg = null
			let attr = null
			let attr_list = JSON.parse(md.attr_list)
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let rVo = role_mgr.GetMainRoleVo()
			let str = ""
			for (let _tmpi in attr_list) {
				let vo = attr_list[_tmpi]
				name = WordManager.GetProperties(Number(vo[0]))
				attr = rVo[cfg[Number(vo[0])].mainvo_str]
				color = attr >= Number(vo[1]) && Enum_ColorUtil_Light.WHITE || Enum_ColorUtil_Dark.RED
				if (down == null && attr < Number(vo[1])) {
					down = true
				}
				num = HtmlColorTxt(vo[1], color)
				table.insert(list, name + "：" + num)
				str = str + name + "：" + num + '<br>'
			}
			if (list.length > 0) {
				this._lb_attr.innerHTML = str
			} else {
				this._lb_attr.innerHTML = ""
			}
			this._lb_attr.width = 300
			this._gp_tips.visible = down
		}

		this.UpdateUIModel = (mon_res?) => {
			if (_mo_res_id_ == mon_res) {
				return
			}
			let action_name_list = ["attack", "idle"]
			let data = {
				clothe_res_id: mon_res,
				type: UI_MODEL_TYPE.MONSTER,
				action_name_list: action_name_list,
				layout_file: "dwMainView"
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)
		}

		this.CreateRadionBtn = (list?) => {
			let tabList = []
			let i = 0
			do {
				let vo = list[i]
				let str = `第${(i + 1)}层`
				let obj = { label: str, isAbyssBoss: true }
				table.insert(tabList, obj)
				i = i + 1
			} while ((i < list.length)
			)

			this.tab_loop_mgr = new LoopScrowViewMgr()
			this.tab_loop_mgr.SetData(this._Scroller2, dwTab, tabList, LoopScrCon.Horizontal, 1, (index?) => {
				this.SelectRadioBtn(index)
			})

		}

		this.SelectRadioBtn = (index?) => {
			let map_id = Number(index) + 1
			if (_cur_map_id_ == map_id) {
				return
			}
			let map_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_map
			let mdata = map_cfg[map_id]
			if (role_mgr.GetMainRoleVo().level < mdata.lv) {
				local_Message.show(`等级达到${TransformLevel(mdata.lv)}级才解锁`)
				this.tab_loop_mgr.SetSelectIndex(_cur_map_id_ - 1, false)
			} else {
				_cur_mon_id_ = null
				this.UpdateMapData(map_id)
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_gp1: Laya.Box
	_img_reward_bg: Laya.Image
	_lb_title: Laya.Label
	_img_title2: Laya.Image
	_lb_title2: Laya.Label
	_lb_attr: Laya.HTMLDivElement
	_btn_attr: Laya.Image
	_btn_record: Laya.Image
	_reward_con: Laya.Panel
	_gp2: Laya.Box
	_gp_model_con: Laya.Box
	_img_namebg: Laya.Image
	_lb_boss_name: Laya.Label
	_gp_attention: Laya.Box
	_Image3: Laya.Image
	attention: Laya.Image
	lb_atten: Laya.Label
	_gp_tips: Laya.Image
	_lb_tips: Laya.Label
	_gp3: Laya.Box
	_img_bg: Laya.Image
	_img_map: Laya.Image
	_img_left: Laya.Image
	_img_right: Laya.Image
	_Scroller2: Laya.List
	_gp_bossitem: Laya.Box
	_Group1: Laya.Box
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Group4: Laya.Box
	_Group5: Laya.Box
	_Group6: Laya.Box
	_Group7: Laya.Box
	_Group8: Laya.Box
	_lb_count: Laya.HTMLDivElement
	_lb_player: Laya.HTMLDivElement
	_btn_add: Laya.Image
	_gp_cost: Laya.HBox
	_Label5: Laya.Label
	_lb_own: Laya.Label
	_img_ticket: Laya.Image
	_btn_go: Laya.Image
	_lb_go: Laya.Label
	public GetComponents() {
		[
			this._gp1,
			this._img_reward_bg,
			this._lb_title,
			this._img_title2,
			this._lb_title2,
			this._lb_attr,
			this._btn_attr,
			this._btn_record,
			this._reward_con,
			this._gp2,
			this._gp_model_con,
			this._img_namebg,
			this._lb_boss_name,
			this._gp_attention,
			this._Image3,
			this.attention,
			this.lb_atten,
			this._gp_tips,
			this._lb_tips,
			this._gp3,
			this._img_bg,
			this._img_map,
			this._img_left,
			this._img_right,
			this._Scroller2,
			this._gp_bossitem,
			this._Group1,
			this._Group2,
			this._Group3,
			this._Group4,
			this._Group5,
			this._Group6,
			this._Group7,
			this._Group8,
			this._lb_count,
			this._lb_player,
			this._btn_add,
			this._gp_cost,
			this._Label5,
			this._lb_own,
			this._img_ticket,
			this._btn_go,
			this._lb_go,
		]
			= this.GetChildrenByNames([
				"_gp1",
				"_img_reward_bg",
				"_lb_title",
				"_img_title2",
				"_lb_title2",
				"_lb_attr",
				"_btn_attr",
				"_btn_record",
				"_reward_con",
				"_gp2",
				"_gp_model_con",
				"_img_namebg",
				"_lb_boss_name",
				"_gp_attention",
				"_Image3",
				"attention",
				"lb_atten",
				"_gp_tips",
				"_lb_tips",
				"_gp3",
				"_img_bg",
				"_img_map",
				"_img_left",
				"_img_right",
				"_Scroller2",
				"_gp_bossitem",
				"_Group1",
				"_Group2",
				"_Group3",
				"_Group4",
				"_Group5",
				"_Group6",
				"_Group7",
				"_Group8",
				"_lb_count",
				"_lb_player",
				"_btn_add",
				"_gp_cost",
				"_Label5",
				"_lb_own",
				"_img_ticket",
				"_btn_go",
				"_lb_go",
			])
	}
}
window["dwMainView"] = dwMainView