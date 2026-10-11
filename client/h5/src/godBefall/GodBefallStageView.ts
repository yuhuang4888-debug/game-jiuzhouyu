import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { Enum_UILayer } from "../common/LayerManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { Message } from "../sysInfo/SysInfoController"
import { ModuleType } from "../common/RedDotManager"
import { ErlangParser } from "../util/ErlangParser"
import { PlatformManager } from "../PlatformManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { GodBefallModel, GodBefallEvent } from "../commonModel/GodBefallModel"
import { GodBefallSkillItem } from "./GodBefallSkillItem"
import { GodBefallAttrItem } from "./GodBefallAttrItem"

import "./GodBefallStageTipsView"
import { GameResPath } from "../util/GameResPath"

export class GodBefallStageView extends BaseView1 {
	Clear
	ClearModel
	Emp_btn_stage
	InitEvent
	LoadSuccess
	Local_Open
	Scr_Scroller1
	Scr_scroll_skill
	UpdateAttrItems
	UpdateCostData
	UpdateSkillItems
	UpdateUIModel
	UpdateView

	_scroll_skill
	ac_attr_loop_list
	ac_attr_loop_mgr
	ac_skill_loop_list
	ac_skill_loop_mgr
	config_god_stage

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallStageView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.preload_server_config = {
			"config_god_stage": false
		}

		let _model = GodBefallModel.GetInstance()
		let local_GodBefallEvent = GodBefallEvent
		let goods_model = GoodsModel.GetInstance()
		let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark

		this.ac_skill_loop_list = null
		this.ac_skill_loop_mgr = null
		this.ac_attr_loop_list = null
		this.ac_attr_loop_mgr = null

		let _uimodel_ = null
		let _cost_item_ = null
		let _cur_show_id_ = null
		let _god_data_ = null
		let _is_max_ = false
		let _text_fsb = null

		this.load_callback = () => {
			this._dg_skill.scrollBar.visible = false
			this._Scroller1.scrollBar.visible = false

			this._lb_count.style.fontSize = 20
			this._lb_count.style.color = "#663915"
			this._lb_count.style.wordWrap = false

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_024, GameResPath.GetIcon("godBefall", "ui_shape_12"))
			this.config_god_stage = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_stage", false)

			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

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
			if (_cost_item_) {
				_cost_item_.DeleteMe()
				_cost_item_ = null
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

			if (_text_fsb) {
				_text_fsb.DeleteMe()
				_text_fsb = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_stage, () => {
				if (_is_max_) {
					Message.show("已满阶")
					return
				}
				_model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44004, "i", _god_data_.id)
			}, this, true)

			this.BindEvent(_model, local_GodBefallEvent.UPDATE_GOD_VO, (id?) => {
				if (_god_data_ && _god_data_.id == id) {
					this.UpdateView()
				}
			})
		}

		this.LoadSuccess = () => {
			_text_fsb = new FightingShowSmallItem(this._fsb_item)
			_text_fsb.Load()

			this.ac_skill_loop_list = []
			this.ac_skill_loop_mgr = new LoopScrowViewMgr()
			this.ac_skill_loop_mgr.SetData(this._dg_skill, GodBefallSkillItem, this.ac_skill_loop_list, LoopScrCon.Horizontal)

			this.ac_attr_loop_list = []
			this.ac_attr_loop_mgr = new LoopScrowViewMgr()
			this.ac_attr_loop_mgr.SetData(this._Scroller1, GodBefallAttrItem, this.ac_attr_loop_list, LoopScrCon.Vertical)
		}

		this.UpdateAttrItems = (list?) => {
			this.ac_attr_loop_list = list
			this.ac_attr_loop_mgr.replaceAll(this.ac_attr_loop_list)
		}

		this.UpdateSkillItems = (list?) => {
			this.ac_skill_loop_list = list
			this.ac_skill_loop_mgr.replaceAll(this.ac_skill_loop_list)
		}

		this.UpdateUIModel = (data?) => {
			let id = data.id
			if (_cur_show_id_ == id) {
				return
			}
			//let res_list = [{ type: UI_MODEL_TYPE.GOD, id: data.model }]
			//let scale = [x = data.model_ratio, y = data.model_ratio]
			/*
			let callBack = () => {
				this.CoverMode(this._con_top)
			}
			*/
			let mode_data = {
				clothe_res_id: data.model,
				weapon_res_id: data.model,
				type: UI_MODEL_TYPE.GOD,
				// wing_id: data.model,
				layer_value: this.layer_value,
				//scale = data.model_ratio, 
				scale: 1 * data.model_ratio,
				position: new Vector3(0, -1.5, 0),
				//load_call_back = callBack,
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model, mode_data)
			_cur_show_id_ = id
		}

		this.ClearModel = () => {
			_cur_show_id_ = null
			if (_uimodel_) {
				_uimodel_.DeleteMe()
				_uimodel_ = null
			}
		}

		this.UpdateView = () => {
			let data = _god_data_
			this.UpdateUIModel(data)
			let talents = _model.GetTalentList(data.id)
			this.UpdateSkillItems(talents)
			let vo = _model.GetGodVoInDic(data.id)
			if (!vo) {
				return
			}
			_text_fsb.Updatefighting(vo.power)
			this._lb_name.text = data.name
			//this._lb_cur.text = vo.grade + "i"

			let cdata = _model.GetStageData(data.id, vo.grade, this.config_god_stage)
			let ndata = _model.GetStageData(data.id, vo.grade + 1, this.config_god_stage)
			let is_max = !ndata
			let clist = JSON.parse(cdata.attr)
			let nlist = !is_max ? (JSON.parse(ndata.attr)) : (null)
			let attrs = _model.GetAttrListAndAdd(clist, nlist)
			this.UpdateAttrItems(attrs)
			ResManager.GetInstance().SetImageSprite(this, this.img1, "godBefall", "ui_stage_" + vo.grade)
			this.img3.visible = !is_max
			this.img2.visible = !is_max
			if (!is_max) {
				let next_grade = vo.grade + 1
				ResManager.GetInstance().SetImageSprite(this, this.img3, "godBefall", "ui_stage_" + next_grade)
			}
			this.UpdateCostData(vo)
			this._lb_btn.text = (is_max && ("已满阶") || ("进阶"))
			Util.SetImageGray(this._img_btn, is_max)
			_is_max_ = is_max
			this._red_stage.visible = _model.GetRedStatus(ModuleType.GOD_STAGE, data.id)
		}

		this.UpdateCostData = (vo?) => {
			let data = _model.GetStageData(vo.god_id, vo.grade, this.config_god_stage)
			let cond_list = _model.GetJsonCacheAndSet("stage@" + vo.god_id + "@" + vo.grade, data.condition)
			if (cond_list.length > 0) {
				let cond_good = cond_list[0]
				if (!_cost_item_) {
					_cost_item_ = new BaseAwardItem(this._gp_item)
					_cost_item_.Load()
					_cost_item_.SetItemSize(60, 60)
				}
				let [type_id, temp] = goods_model.GetMappingTypeId(cond_good[0], cond_good[1])
				let own = goods_model.GetTypeGoodsNum(type_id)
				let color = (own >= Number(cond_good[2]) && (local_Enum_ColorUtil_Dark.WHITE) || (local_Enum_ColorUtil_Dark.RED))
				let own_str = Util.HtmlColorTxt(own, color)
				this._lb_count.innerHTML = Util.StrToHTML(own_str + "/" + cond_good[2])
				_cost_item_.SetData(type_id)
				this._gp_cost.visible = true
			} else {
				this._gp_cost.visible = false
			}
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	gp_con: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_024: Laya.Image
	bg_img: Laya.Image
	_img_029: Laya.Image
	_Image4: Laya.Image
	_gp_model: Laya.Box
	_btn_close: Laya.Image
	_con_top: Laya.Box
	_Image6: Laya.Image
	_lb_name: Laya.Label
	_fsb_item: Laya.Box
	_btn_stage: Laya.Box
	_img_btn: Laya.Image
	_lb_btn: Laya.Label
	_red_stage: Laya.Image
	_dg_skill: Laya.List
	_Scroller1: Laya.List
	_Image7: Laya.Image
	_gp_cost: Laya.Box
	_gp_item: Laya.Box
	_lb_count: Laya.HTMLDivElement
	group2: Laya.HBox
	img1: Laya.Image
	img2: Laya.Image
	img3: Laya.Image
	lb_title1: Laya.Label
	lb_title2: Laya.Label
	public GetComponents() {
		[
			this.gp_con,
			this._Image1,
			this._Image2,
			this._img_024,
			this.bg_img,
			this._img_029,
			this._Image4,
			this._gp_model,
			this._btn_close,
			this._con_top,
			this._Image6,
			this._lb_name,
			this._fsb_item,
			this._btn_stage,
			this._img_btn,
			this._lb_btn,
			this._red_stage,
			this._dg_skill,
			this._Scroller1,
			this._Image7,
			this._gp_cost,
			this._gp_item,
			this._lb_count,
			this.group2,
			this.img1,
			this.img2,
			this.img3,
			this.lb_title1,
			this.lb_title2,
		]
			= this.GetChildrenByNames([
				"gp_con",
				"_Image1",
				"_Image2",
				"_img_024",
				"bg_img",
				"_img_029",
				"_Image4",
				"_gp_model",
				"_btn_close",
				"_con_top",
				"_Image6",
				"_lb_name",
				"_fsb_item",
				"_btn_stage",
				"_img_btn",
				"_lb_btn",
				"_red_stage",
				"_dg_skill",
				"_Scroller1",
				"_Image7",
				"_gp_cost",
				"_gp_item",
				"_lb_count",
				"group2",
				"img1",
				"img2",
				"img3",
				"lb_title1",
				"lb_title2",
			])
	}
}
window["GodBefallStageView"] = GodBefallStageView