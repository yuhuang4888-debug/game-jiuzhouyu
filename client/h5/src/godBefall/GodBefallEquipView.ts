import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ModuleType } from "../common/RedDotManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ColorUtil } from "../util/ColorUtil"
import { Vector2 } from "../util/Vector2"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { GodBefallModel, GodBefallEvent, GodBefallDefine } from "../commonModel/GodBefallModel"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { DownDropBtn } from "../common/DownDropBtn"
import { GodBefallEquipItem } from "./GodBefallEquipItem"
import { GodBefallBagItem } from "./GodBefallBagItem"

export class GodBefallEquipView extends BaseView1 {
	Clear
	ClearAllTimeOut
	ClearModel
	ClearTween
	ClickColor
	ClickType
	Emp_btn_com
	Emp_btn_star
	GetEquipList
	InitEvent
	LoadSuccess
	Local_Open
	Raw_gp_model
	Scr_Scroller1
	Scr_dg_equip
	SetTimeOut
	UpdateBagItems
	UpdateDefaultTypeBag
	UpdateEquipItems
	UpdateStar
	UpdateUIModel
	UpdateView

	_dd_color
	_dd_type
	ac_bag_loop_list
	ac_bag_loop_mgr
	ac_equip_loop_list
	ac_equip_loop_mgr
	config_god_star
	cfg_god_star_up_limit
	ConfigGodBefall
	CheckSameRedDot
	_model

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallEquipView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this._model=GodBefallModel.GetInstance()
		this.preload_server_config = {
			"config_god_star": false,
			"config_god_star_up_limit": false
		}
		this.preload_client_config = {
			"ConfigGodBefall": false
		}

		let _model = GodBefallModel.GetInstance()
		let local_CompositeModel = CompositeModel
		let local_GodBefallEvent = GodBefallEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_GodBefallDefine = GodBefallDefine
		//let local_Vector2 = Vector2

		let local_ColorUtil = ColorUtil
		//let _ac_equip_ = null
		this.ac_equip_loop_list = null
		this.ac_equip_loop_mgr = null

		this.ac_bag_loop_list = null
		this.ac_bag_loop_mgr = null

		//let _ac_bag_ = null
		let _uimodel_ = null
		let _star_list_ = null
		let _cur_show_id_ = null
		let _god_data_ = null
		let _color_ = 99
		let _type_ = -1
		let _is_max_ = false
		let _tweening_ = false
		let _time_dic_ = null
		let _eff_dic_ = []
		let _text_fsb = null

		this.load_callback = () => {
			this._dg_equip.scrollBar.visible = false
			this._Scroller1.scrollBar.visible = false

			this._lb_tips.style.fontSize = 18
			this._lb_tips.style.color = "#d15e00"
			this._lb_tips.style.wordWrap = false

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_024, GameResPath.GetIcon("godBefall", "ui_shape_12"))
			this.config_god_star = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_star", false)
			this.ConfigGodBefall = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGodBefall", true)
			this.cfg_god_star_up_limit = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_star_up_limit", false)

			this.InitEvent()
			this.LoadSuccess()

			this.CheckSameRedDot()
		}

		this.destroy_callback = () => {
			_cur_show_id_ = null
			this.Clear()
		}

		this.open_callback = () => {
			_type_ = -1
			this.UpdateView()
		}

		//this.preload_server_config = [Equipattr = false, config_god_star = false, config_god_star_up_limit = false]
		//this.preload_client_config = [ConfigGodBefall = false]
		this.Local_Open = (parms?) => {
			_god_data_ = parms
			if (!_god_data_) {
				this.Close()
			} else {
				super.Open()
			}
		}

		this.Clear = () => {
			this.ClearModel()
			this.ClearAllTimeOut()
			this.ClearTween()
			_tweening_ = false
			_star_list_ = null
			this.ac_equip_loop_list = null
			if (_text_fsb) {
				_text_fsb.DeleteMe()
				_text_fsb = null
			}
			if (this.ac_equip_loop_mgr) {
				this.ac_equip_loop_mgr.DeleteMe()
				this.ac_equip_loop_mgr = null
			}
			if (this.ac_bag_loop_mgr) {
				this.ac_bag_loop_mgr.DeleteMe()
				this.ac_bag_loop_mgr = null
			}
			if (this._dd_color) {
				this._dd_color.DeleteMe()
				this._dd_color = null
			}
			if (this._dd_type) {
				this._dd_type.DeleteMe()
				this._dd_type = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_com, () => {
				CompositeModel.GetInstance().Fire(local_CompositeModel.OPEN_COMPOSITE_VIEW, local_CompositeModel.Index.God)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_star, () => {
				if (_is_max_) {
					Message.show("已满星")
					return
				}
				let str = "升星后会将身上4件装备进行吞噬（装备属性会直接增加到人物身上）是否继续？"
				Alert.Show(str, Alert_Type.Two, () => {
					_model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44005, "i", _god_data_.id)
				})
			}, this, true)

			Util.AddClickEvent(this._img_help, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_INSTRUCTION_VIEW, 4401)
			}, this, true)

			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_GOD_BAG_LIST, () => {
				this.UpdateBagItems()
			})

			this.BindEvent(_model, local_GodBefallEvent.UPDATE_GOD_VO, (id?) => {
				if (_god_data_ && _god_data_.id == id) {
					this.UpdateView()
				}
			})

			this.BindEvent(_model, local_GodBefallEvent.STAR_SUCCESS, (scmd?) => {
				let data = _model.GetGodData(scmd.god_id)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBefallStarTipsView", data)
				/*
				// TODO dxj 没有特效展示，暂时屏蔽
				if (true) { return }

				_tweening_ = true
				let i = 0
				do {
					let pos = new local_Vector2(87 * 0.5 + i * 31 + 87, GetSizeDeltaY(this._gp_eff_item) * 0.5)
					//this:AddUIEffect("ui_degreeglow_glowboom", this._gp_eff_item, pos, null, false, null, null, null, null, true)
					i = i + 1
				} while ((i < local_GodBefallDefine.EQUIP_COUNT)
				)
				this.SetTimeOut(() => {
					let tar_pos = new local_Vector2(GetSizeDeltaX(this._gp_eff_item) * 0.5, -140)
					let i = 0
					do {
						let pos = new local_Vector2(87 * 0.5 + i * 31 + 87, GetSizeDeltaY(this._gp_eff_item) * 0.5)
						//this:AddUIEffect(
						//    "ui_degreeglow_glowlizi",
						//    this._gp_eff_item,
						//    pos,
						//    null,
						//    true,
						//    0.5,
						//    null,
						//(obj?) => {
						//        _eff_dic_[i] = obj
						//        let dx = tar_pos.x - pos.x
						//        let dis = GameMath.GetDistance(pos.x, pos.y, tar_pos.x, tar_pos.y, true)
						//        obj.rotation = -Math:acos(dx / dis) * 180 / Math.PI
						//        local_laya.Tween.get(obj).to({x = tar_pos.x, y = tar_pos.y}, 200)
						//    },
						//    null,
						//    true
						//)
						i = i + 1
					} while ((i < local_GodBefallDefine.EQUIP_COUNT)
					)
				},
					6 / 14
				)
				this.SetTimeOut(() => {
					//this:AddUIEffect("ui_degreeglow_beind", this._gp_eff_1)
					//this:AddUIEffect("ui_degreeglow_front", this._gp_eff_2)
				},
					6 / 14 + 0.2
				)
				this.SetTimeOut(() => {
					_tweening_ = false
					this.UpdateView()
					////this:ClearUIEffect(this._gp_eff_item)
					////this:ClearUIEffect(this._gp_eff_1)
					////this:ClearUIEffect(this._gp_eff_2)
					let data = _model.GetGodData(scmd.god_id)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBefallStarTipsView", data)
				},
					6 / 14 + 0.7
				)
				*/
			})


			this.BindEvent(CompositeModel.GetInstance(), CompositeModel.UPDATE_COMPOSE_RED, () => {
				this.CheckSameRedDot()
			})
		}

		this.LoadSuccess = () => {
			_text_fsb = new FightingShowSmallItem(this._fsb_item)
			_text_fsb.Load()
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_024, GameResPath.GetIconJpg("godBefall", "uijs_024"))
			//_ac_equip_ = eui. new ArrayCollection()
			//this._dg_equip.dataProvider = _ac_equip_
			//this._dg_equip.itemRenderer = GodBefallEquipItem

			let GBDropColorList = this.ConfigGodBefall["GBDropColorList"]
			let GBDropTypeList = this.ConfigGodBefall["GBDropTypeList"]

			this._dd_color = new DownDropBtn(this.color_con)
			this._dd_type = new DownDropBtn(this.type_con)

			this._dd_color.Init(GBDropColorList, this.ClickColor, "品质", "content", this.layer_value, 5, null, null, true)
			this._dd_type.Init(GBDropTypeList, this.ClickType, "类型", "content", this.layer_value, null, null, null, true)
			this._dd_color.Load()
			this._dd_type.Load()

			this.ac_equip_loop_list = []
			this.ac_equip_loop_mgr = new LoopScrowViewMgr()
			this.ac_equip_loop_mgr.SetData(this._dg_equip, GodBefallEquipItem, this.ac_equip_loop_list, LoopScrCon.Horizontal)

			//_ac_bag_ = eui. new ArrayCollection()
			//this._dg_bag.dataProvider = _ac_bag_
			//this._dg_bag.itemRenderer = GodBefallBagItem

			this.ac_bag_loop_list = []
			this.ac_bag_loop_mgr = new LoopScrowViewMgr()
			this.ac_bag_loop_mgr.SetData(this._Scroller1, GodBefallBagItem, this.ac_bag_loop_list, LoopScrCon.Vertical)

			/*
			_star_list_ = []
			let i = 0
			do {
				let go = new GameObject()
				let trans = go.transform
				trans.parent = this._gp_star
				SetLocalScale(trans, 1, 1, 1)
				SetLocalPositionZ(trans, 0)
				SetUILayer(trans, this.layer_value)
				let image = go.AddComponent(typeof (UnityEngine.UI.Image))
				go.visible = false
				_star_list_[i] = image
				i = i + 1
			} while ((i < local_GodBefallDefine.STAR_COUNT))
			*/
		}

		this.UpdateDefaultTypeBag = () => {
			if (_type_ < 0) {
				let GBDropTypeList = this.ConfigGodBefall["GBDropTypeList"]
				let data = _model.GetGodData(_god_data_.id)
				_type_ = data.color
				let i = 0
				let select_index = -1
				do {
					let vo = GBDropTypeList[i]
					if (vo.cond == data.color) {
						select_index = i
						break
					}
					i = i + 1
				} while ((i < GBDropTypeList.length)
				)
				if (select_index != -1) {
					this._dd_type.ExcuteCallback(() => {
						this._dd_type.SetSelectIndex(select_index)
					})
				}
			}
		}

		this.UpdateEquipItems = (list?) => {
			let only_update_data = this.ac_equip_loop_list.length == list.length
			this.ac_equip_loop_list = list

			this.ac_equip_loop_list = list
			this.ac_equip_loop_mgr.replaceAll(this.ac_equip_loop_list, null, only_update_data)

		}

		this.UpdateBagItems = () => {
			if (_type_ < 0) {
				this.UpdateDefaultTypeBag()
			} else {
				let list = _model.GetGoodsByBagCond(_color_, _type_, _god_data_.id)
				this.ac_bag_loop_list = list
				this.ac_bag_loop_mgr.replaceAll(this.ac_bag_loop_list)
				//this.ac_bag_loop_mgr.RestToBeginning()
			}
		}

		this.UpdateStar = (star?) => {
			let max_star = _model.GetMaxStarCount(_god_data_.id) || local_GodBefallDefine.STAR_COUNT
			let i = 0
			do {
				let image = _star_list_[i]
				let sp_name = (star > i && ("uity_043a") || ("uity_043b"))
				ResManager.GetInstance().SetImageSprite(this, image, "godBefall_asset", sp_name, true)
				i = i + 1
				image.visible = i <= max_star
			} while ((i < _star_list_.length)
			)
		}

		this.UpdateUIModel = (data?) => {
			let id = data.id
			if (_cur_show_id_ == id) {
				return
			}
			/*
			let callBack = () => {
				this.CoverMode(this._con_top)
			}
			*/
			let mode_data = {
				clothe_res_id: data.model,
				weapon_res_id: data.model,
				// wing_id: data.model,
				type: UI_MODEL_TYPE.GOD,
				layer_value: this.layer_value,
				//scale = data.model_ratio, 
				scale: 1 * data.model_ratio,
				position: new Vector3(0, -1, 0),
				//load_call_back = callBack,
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model, mode_data)
			_cur_show_id_ = id
		}

		this.ClearModel = () => {
			if (_uimodel_) {
				_uimodel_.DeleteMe()
				_uimodel_ = null
			}
		}

		this.UpdateView = () => {
			if (_tweening_) {
				return
			}
			let data = _god_data_
			this.UpdateUIModel(data)
			let vo = _model.GetGodVoInDic(data.id)
			if (!vo) {
				return
			}
			let equip_list = _model.GetEquipList(vo)
			this.UpdateEquipItems(equip_list)
			this.UpdateBagItems()
			//this.UpdateStar(vo.star)
			_text_fsb.Updatefighting(vo.power)
			this._lb_name.text = data.name
			let ldata = _model.GetStarLimitData(vo.star, this.cfg_god_star_up_limit)
			if (ldata) {
				let color = Util.HtmlColorTxt(local_ColorUtil.GetColorName(Number(ldata.color)), local_ColorUtil.GetColorDark(Number(ldata.color)))
				let star_str = (ldata.equip_star && (ldata.equip_star + "星") || (""))
				this._lb_tips.innerHTML = Util.StrToHTML("穿上4件" + color + star_str + "神器后，可进行降神升星")
				this._img_tips.visible = true
			} else {
				this._lb_tips.innerHTML = ""
				this._img_tips.visible = false
			}
			this._lb_tips.width = this._lb_tips.contextWidth
			this._red_star.visible = _model.GetRedStatus(ModuleType.GOD_STAR, data.id)
			let ndata = _model.GetStarData(data.id, vo.star + 1, this.config_god_star)
			_is_max_ = !ndata
			this._lb_btn_star.text = (_is_max_ && ("已满星") || ("升星"))
			Util.SetImageGray(this._img_btn_star, _is_max_)
			this._Group1.visible = !_is_max_
		}

		this.GetEquipList = (equip_list?) => {
			let list = []
			for (let _tmpi in equip_list) {
				var vo = equip_list[_tmpi]
				table.insert(list, _model.GetEquipInfo(vo.goods_id))
			}
			return list
		}

		this.ClickColor = (index?, data?) => {
			_color_ = data.cond
			this.UpdateBagItems()
			//this.ac_bag_loop_mgr.ResetPosition()
		}

		this.ClickType = (index?, data?) => {
			_type_ = data.cond
			this.UpdateBagItems()
			//this.ac_bag_loop_mgr.ResetPosition()
		}

		this.SetTimeOut = (func?, delay?) => {
			if (!_time_dic_) {
				_time_dic_ = []
			}
			let id = setTimeout(func, delay)
			_time_dic_[id] = id
		}

		this.ClearAllTimeOut = () => {
			if (!_time_dic_) {
				return
			}
			for (let key in _time_dic_) {
				clearTimeout(_time_dic_[key])
			}
			_time_dic_ = null
		}

		this.ClearTween = () => {
			for (let key in _eff_dic_) {
				//local_laya.Tween.removeTweens(_eff_dic_[key])
			}
			_eff_dic_ = []
		}

		this.CheckSameRedDot = (id?) => {
			this._red_com.visible = GodBefallModel.GetInstance().GetAutoComposeRed()
		}

	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	gp_con: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_024: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	img_bg6: Laya.Image
	_gp_eff_1: Laya.Box
	_gp_model: Laya.Box
	_gp_eff_2: Laya.Box
	_btn_close: Laya.Image
	_con_top: Laya.Box
	_Image7: Laya.Image
	_lb_name: Laya.Label
	_fsb_item: Laya.Box
	_gp_star: Laya.HBox
	_gp_eff_item: Laya.Box
	_dg_equip: Laya.List
	_btn_com: Laya.Box
	_Image8: Laya.Image
	_Label1: Laya.Label
	_red_com: Laya.Image
	_btn_star: Laya.Box
	_img_btn_star: Laya.Image
	_lb_btn_star: Laya.Label
	_red_star: Laya.Image
	_Scroller1: Laya.List
	_Label2: Laya.Label
	_Label3: Laya.Label
	color_con: Laya.Box
	type_con: Laya.Box
	_img_help: Laya.Image
	_Group1: Laya.HBox
	_img_tips: Laya.Image
	gp_tips: Laya.HBox
	_lb_tips: Laya.HTMLDivElement
	lb_title1: Laya.Label
	lb_title2: Laya.Label
	public GetComponents() {
		[
			this.gp_con,
			this._Image1,
			this._Image2,
			this._img_024,
			this._Image4,
			this._Image5,
			this.img_bg6,
			this._gp_eff_1,
			this._gp_model,
			this._gp_eff_2,
			this._btn_close,
			this._con_top,
			this._Image7,
			this._lb_name,
			this._fsb_item,
			this._gp_star,
			this._gp_eff_item,
			this._dg_equip,
			this._btn_com,
			this._Image8,
			this._Label1,
			this._red_com,
			this._btn_star,
			this._img_btn_star,
			this._lb_btn_star,
			this._red_star,
			this._Scroller1,
			this._Label2,
			this._Label3,
			this.color_con,
			this.type_con,
			this._img_help,
			this._Group1,
			this._img_tips,
			this.gp_tips,
			this._lb_tips,
			this.lb_title1,
			this.lb_title2,
		]
			= this.GetChildrenByNames([

				"gp_con",
				"_Image1",
				"_Image2",
				"_img_024",
				"_Image4",
				"_Image5",
				"img_bg6",
				"_gp_eff_1",
				"_gp_model",
				"_gp_eff_2",
				"_btn_close",
				"_con_top",
				"_Image7",
				"_lb_name",
				"_fsb_item",
				"_gp_star",
				"_gp_eff_item",
				"_dg_equip",
				"_btn_com",
				"_Image8",
				"_Label1",
				"_red_com",
				"_btn_star",
				"_img_btn_star",
				"_lb_btn_star",
				"_red_star",
				"_Scroller1",
				"_Label2",
				"_Label3",
				"color_con",
				"type_con",
				"_img_help",
				"_Group1",
				"_img_tips",
				"gp_tips",
				"_lb_tips",
				"lb_title1",
				"lb_title2",
			])
	}
}
window["GodBefallEquipView"] = GodBefallEquipView