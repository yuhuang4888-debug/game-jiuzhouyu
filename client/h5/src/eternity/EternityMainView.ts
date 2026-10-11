import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { EternityDefine, EternityEvent, EternityModel, EternityTimer } from "../commonModel/EternityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorType, ColorUtil, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { HtmlColorTxt, Util } from "../util/Util"
import { Config } from "../common/Config"

export class EternityMainView extends BaseItem1 {
	_gp_btn_2: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_gp_btn_3: Laya.Box
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Label5: Laya.Label
	_Label6: Laya.Label
	_Label7: Laya.Label
	_Label8: Laya.Label
	_gp_btn_4: Laya.Box
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Label9: Laya.Label
	_Label10: Laya.Label
	_Label11: Laya.Label
	_Label12: Laya.Label
	_gp_btn_5: Laya.Box
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	_Label13: Laya.Label
	_Label14: Laya.Label
	_Label15: Laya.Label
	_Label16: Laya.Label
	_gp_btn_1: Laya.Box
	_img_center: Laya.Image
	_Image13: Laya.Image
	_Image14: Laya.Image
	_Image15: Laya.Image
	_Image16: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_Image17: Laya.Image
	_Image18: Laya.Image
	_Label17: Laya.Label
	_img_031: Laya.Image
	_Label18: Laya.Label
	_Label19: Laya.Label
	_Label20: Laya.Label
	_lb_time: Laya.HTMLDivElement
	_lb_lv: Laya.HTMLDivElement
	_lb_desc: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_btn_go: Laya.Box
	_Image19: Laya.Image
	_lb_btn: Laya.Label
	_gp_eff: Laya.Box
	red: Laya.Image
	CheckBtnStatus
	DeleteMeFunc
	FireEvent
	InitEvent
	LoadSuccess
	SelectBtn
	SendPlayerProto
	UpdateBtnEff
	UpdateBtnTimer
	UpdateGoStatus
	UpdatePlayerCount
	UpdateRewardItems
	UpdateShowData
	_gp_item

	public constructor(parent?) {
		super(parent)
		this.base_file = "eternity"
		this.layout_file = "EternityMainView"

		let _model = EternityModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_EternityEvent = EternityEvent
		let local_EternityTimer = EternityTimer
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		let _data_list_ = [{ scene_id: 44001, bg: "013", sel: "007a" }, { scene_id: 44002, bg: "012", sel: "007" }, { scene_id: 44003, bg: "008", sel: "007" }, { scene_id: 44004, bg: "010", sel: "007" }, { scene_id: 44005, bg: "009", sel: "007" }]
		let _btn_list_ = null
		let _item_list_ = null
		let _cur_vo_ = null
		let _limit_num_ = null
		let _limit_time_ = null
		let _limit_mark_ = null
		let _kv_cfg_ = null
		let _reward_cfg_ = null
		let _scene_cfg_ = null
		let _reward_list_ = []
		let _can_enter_ = true

		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			this.LoadSuccess()
			this.InitEvent()
			this.FireEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_go, () => {
				if (!_cur_vo_) {
					return
				}
				_model.Fire(local_EternityEvent.REQUEST_PROTO, 27902, "h", _cur_vo_.scene_id)
			}
				, this, true)
			this.BindEvent(_model, local_EternityEvent.UPDATE_PLAYER, (scmd?) => {
				this.UpdatePlayerCount(scmd.join_list)
				this.UpdateGoStatus(scmd.can_enter_scene)
			}
			)
			this.BindVar(_model, "_act_data", () => {
				let adata = _model.GetActData()
				let cur_time = local_TimeUtil.getServerTime()
				let is_normal = (adata && cur_time >= adata.open_time) && cur_time < adata.enter_time
				let index = (is_normal && (2) || (1))
				this.SelectBtn(_data_list_[index])
			}
			)
		}

		this.FireEvent = () => {
			_model.Fire(local_EternityEvent.REQUEST_PROTO, 27900)
			_model.Fire(local_EternityEvent.REQUEST_PROTO, 27901)
		}

		this.DeleteMeFunc = () => {
			_btn_list_ = null
			if (_item_list_) {
				for (let _tmpi in _item_list_) {
					var item = _item_list_[_tmpi]
					item.DeleteMe()
				}
			}
			_item_list_ = null
			_model.ClearTimer(local_EternityTimer.PLAYER)
			_model.ClearTimer(local_EternityTimer.GOBTN)
		}

		this.LoadSuccess = () => {
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_tips.size = 18
			// }
			//this.RegisterMask(this._gp_item)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_031, GameResPath.GetIcon("eternity", "uifb_031"))
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image13, GameResPath.GetIcon("eternity", "uiyhsd_015"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image15, GameResPath.GetIcon("eternity", "uiyhsd_017"), true)
			_reward_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_sanctum_reward_show
			_kv_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_sanctum_kv
			_scene_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_sanctum_scene_type
			_limit_num_ = _model.GetKVData(_kv_cfg_, "enter_scene_player_limit")
			_item_list_ = []
			_btn_list_ = []
			let i = 0
			do {
				let vo = _data_list_[i]
				let btn: Laya.Box = this["_gp_btn_" + (i + 1)]
				let sdata = _model.GetSceneData(_scene_cfg_, vo.scene_id)
				let data = { "img_bg": <Laya.Image>btn.getChildAt(0), "img_select": <Laya.Image>btn.getChildAt(2) }
				if (sdata.scene_type == 2) {
					data["lb_scene"] = <Laya.Label>btn.getChildAt(3)
					data["lb_server"] = <Laya.Label>btn.getChildAt(4)
				}
				ResManager.GetInstance().SetOutsideImageSprite(this, data.img_select, GameResPath.GetIcon("eternity", "uiyhsd_" + vo.sel))
				ResManager.GetInstance().SetOutsideImageSprite(this, data.img_bg, GameResPath.GetIcon("eternity", "uiyhsd_" + vo.bg),true)
				Util.AddClickEvent(data.img_bg, () => {
					this.SelectBtn(vo)
				}
					, this)
				_btn_list_[vo.scene_id] = data
				i = i + 1
			} while ((i < _data_list_.length))
			let adata = _model.GetActData()
			let cur_time = local_TimeUtil.getServerTime()
			let is_normal = (adata && cur_time >= adata.open_time) && cur_time < adata.enter_time
			let index = (is_normal && (2) || (1))
			this.SelectBtn(_data_list_[index])
			this.UpdateShowData()
			if (is_normal) {
				_model.ClearTimer(local_EternityTimer.PLAYER)
				let func = () => {
					this.SendPlayerProto()
				}
				_model.StartTimer(local_EternityTimer.PLAYER, 10, func)
			}
		}

		this.CheckBtnStatus = () => {
			let adata = _model.GetActData()
			let cur_time = local_TimeUtil.getServerTime()
			let is_normal = (adata && cur_time >= adata.open_time) && cur_time < adata.enter_time
			if (is_normal) {
				_limit_time_ = adata.enter_time
				_model.ClearTimer(local_EternityTimer.GOBTN)
				let func = () => {
					this.UpdateBtnTimer()
				}
				_model.StartTimer(local_EternityTimer.GOBTN, 1, func)
				this.UpdateBtnTimer()
			}
		}

		this.UpdateBtnTimer = () => {
			let mark = _limit_time_ > local_TimeUtil.getServerTime()
			if (_limit_mark_ == mark) {
				return
			}
			_limit_mark_ = mark
			if (mark) {
				this.UpdateBtnEff(true)
			} else {
				_model.ClearTimer(local_EternityTimer.GOBTN)
				this.UpdateBtnEff(false)
			}
		}

		this.UpdateBtnEff = (show?) => {
			this.red.visible = show
			// if (show) {
			// 	//this:AddUIEffect("ui_awaken_buttonglow", this._gp_eff, null, {x=1.4, y=1.3}, true)
			// } else {
			// 	//this:ClearUIEffect(this._gp_eff)
			// }
		}

		this.SelectBtn = (vo?) => {
			if (!vo || vo == _cur_vo_) {
				return
			}
			if (_cur_vo_) {
				let btn = _btn_list_[_cur_vo_.scene_id]
				if (btn) {
					btn.img_select.visible = false
				}
			}
			_cur_vo_ = vo
			let btn = _btn_list_[_cur_vo_.scene_id]
			if (btn) {
				btn.img_select.visible = true
			}
			let rdata = _reward_cfg_[vo.scene_id]
			let list = _reward_list_[vo.scene_id] || JSON.parse(rdata.show_list)
			_reward_list_[vo.scene_id] = list
			this.UpdateRewardItems(list)
			if (_cur_vo_.scene_id == EternityDefine.BOSS_SCENE) {
				_model.ClearTimer(local_EternityTimer.GOBTN)
				this._lb_btn.text = "进入场景"
				Util.SetImageGray(this._Image19, false)
				this.UpdateBtnEff(_limit_mark_)
			} else {
				this.CheckBtnStatus()
			}
		}

		this.UpdateRewardItems = (list?) => {
			let i = 0
			do {
				let info = list[i]
				let item = _item_list_[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					//item.SetMaskId(1)
					item.SetItemSize(60, 60)
					item.Load()
					_item_list_[i] = item
				}
				item.ExcuteCallback(() => {
					let [type_id] = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
					item.SetData(type_id, info[2])
					item.visible = true
				})
				i = i + 1
			} while ((i < list.length))
			i = list.length
			if (i < _item_list_.length) {
				do {
					_item_list_[i].ExcuteCallback(() => {
						_item_list_[i].visible = false
					})
					i = i + 1
				} while ((i < _item_list_.length))
			}

		}

		this.UpdateShowData = () => {
			let lv = _model.GetKVData(_kv_cfg_, "open_lv")
			let level = (lv > 370 && ("神创" + (lv - 370)) || (lv))
			let lv_str = HtmlColorTxt(level + "级", "'#FFC549'")
			this._lb_lv.style.fontSize = 16
			this._lb_lv.style.color = "#ffffff"
			this._lb_lv.style.wordWrap = false
			this._lb_lv.innerHTML = Util.StrToHTML(lv_str + "以上可参加")
			let str = "小跨服范围内的限时玩法，击杀结界或天启之源内的怪物"
			let str1 = HtmlColorTxt("可获得圣装和装备各种奖励", "'#FFC549'")
			this._lb_desc.style.fontSize = 16
			this._lb_desc.style.color = "#ffffff"
			this._lb_desc.style.wordWrap = false
			this._lb_desc.innerHTML = Util.StrToHTML(str + str1)
			let cond_list = _model.GetKVData(_kv_cfg_, "act_open_list")
			cond_list = JSON.parse(cond_list)
			let day_list = cond_list[0][1]
			let time = cond_list[1][1][0]
			let day_str = "每周"
			for (let _tmpi in day_list) {
				var day = day_list[_tmpi]
				// if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
				// 	day_str = day_str + TimeUtil.KrDayName(day)
				// } else {
				day_str = day_str + WordManager.NumConvertStage(day)
				//}
				if (_tmpi != day_list.length) {
					day_str = day_str + "、"
				}
			}
			for (let key1 in time) {

				let vo = time[key1]
				if (vo[1] == "0") {
					vo[1] = "00"
				}
			}
			let time_str = time[0][0] + ":" + time[0][1] + (" - ") + time[1][0] + ":" + time[1][1]
			this._lb_time.style.fontSize = 16
			this._lb_time.style.color = "#ffffff"
			this._lb_time.style.wordWrap = false
			this._lb_time.innerHTML = `<font color='#FFC549'>${day_str} ${time_str}</font>`
		}

		this.UpdatePlayerCount = (list?) => {
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				let btn = _btn_list_[vo.scene]
				if (!btn) {
					break
				}
				let sdata = _model.GetSceneData(_scene_cfg_, vo.scene)
				if (sdata.scene_type == 1) {
					break
				}
				btn.lb_scene.text = vo.scene_num + "/" + _limit_num_
				btn.lb_server.text = vo.self_server_num
			}
		}

		this.UpdateGoStatus = (can_enter_scene?) => {
			let can_enter = can_enter_scene == 1
			// if (can_enter == _can_enter_) {
			// 	return
			// }
			_can_enter_ = can_enter
			let pic = (can_enter && ("uiyhsd_013") || ("uiyhsd_013a"))

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_center, GameResPath.GetIcon("eternity", pic))
			this._lb_tips.style.fontSize = 18
			this._lb_tips.style.color = "#ffffff"
			this._lb_tips.style.wordWrap = false
			this._lb_tips.style.leading = 1
			this._lb_tips.y = can_enter ? 95 : 84
			//this._lb_tips.style.color = (can_enter && (ColorUtil.GetColorLight(ColorType.GREEN)) || (ColorUtil.GetColorLight(ColorType.RED)))
			this._lb_tips.innerHTML = (can_enter && ("<font color='#19ae4a'>已获得进入资格</font>") || ("击杀<font color='#ff5050'>任意守护者</font>的服务器<br>可进入天启之源"))
		}

		this.SendPlayerProto = () => {
			_model.Fire(local_EternityEvent.REQUEST_PROTO, 27901)
		}


	}
	public DeleteMe() {

		this.DeleteMeFunc()
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._gp_btn_2,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._gp_btn_3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Label5,
			this._Label6,
			this._Label7,
			this._Label8,
			this._gp_btn_4,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Label9,
			this._Label10,
			this._Label11,
			this._Label12,
			this._gp_btn_5,
			this._Image10,
			this._Image11,
			this._Image12,
			this._Label13,
			this._Label14,
			this._Label15,
			this._Label16,
			this._gp_btn_1,
			this._img_center,
			this._Image13,
			this._Image14,
			this._Image15,
			this._Image16,
			this._lb_tips,
			this._Image17,
			this._Image18,
			this._Label17,
			this._img_031,
			this._Label18,
			this._Label19,
			this._Label20,
			this._lb_time,
			this._lb_lv,
			this._lb_desc,
			this._Scroller1,
			this.Content,
			this._btn_go,
			this._Image19,
			this._lb_btn,
			this._gp_eff,
			this.red,
		]
			= this.GetChildrenByNames([

				"_gp_btn_2",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_gp_btn_3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Label5",
				"_Label6",
				"_Label7",
				"_Label8",
				"_gp_btn_4",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Label9",
				"_Label10",
				"_Label11",
				"_Label12",
				"_gp_btn_5",
				"_Image10",
				"_Image11",
				"_Image12",
				"_Label13",
				"_Label14",
				"_Label15",
				"_Label16",
				"_gp_btn_1",
				"_img_center",
				"_Image13",
				"_Image14",
				"_Image15",
				"_Image16",
				"_lb_tips",
				"_Image17",
				"_Image18",
				"_Label17",
				"_img_031",
				"_Label18",
				"_Label19",
				"_Label20",
				"_lb_time",
				"_lb_lv",
				"_lb_desc",
				"_Scroller1",
				"Content",
				"_btn_go",
				"_Image19",
				"_lb_btn",
				"_gp_eff",
				"red",
			])
	}
}
window["EternityMainView"] = EternityMainView