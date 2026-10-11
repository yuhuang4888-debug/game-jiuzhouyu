import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ErlangParser } from "../util/ErlangParser"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { GodBefallModel, GodBefallDefine } from "../commonModel/GodBefallModel"
import { GodBefallAttrItem } from "./GodBefallAttrItem"
import { GameResPath } from "../util/GameResPath"

export class GodBefallStarTipsView extends BaseView1 {
	Clear
	ClearModel
	InitEvent
	LoadSuccess
	Local_Open
	Scr_Scroller1
	UpdateAttrItems
	UpdateStar
	UpdateUIModel
	UpdateView
	fight_item
	_ac_attr_loop_list
	_ac_attr_loop_mgr
	config_god_star

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallStarTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.preload_server_config = {
			"config_god_star": false
		}

		let _model = GodBefallModel.GetInstance()
		let local_Erlang = ErlangParser.GetInstance()

		//let _ac_attr_ = null
		let _star_list_ = null
		let _cur_show_id_ = null
		let _god_data_ = null
		this.load_callback = () => {
			this._Scroller1.scrollBar.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_xxxjs_001, GameResPath.GetIcon("godBefall", "ui_shape_28"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("godBefall", "ui_shape_29"))
			
			this.config_god_star = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_star", false)
			
			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		//this.preload_server_config = [config_god_star = false]
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
			_star_list_ = null
			if (this._ac_attr_loop_mgr) {
				this._ac_attr_loop_mgr.DeleteMe()
				this._ac_attr_loop_mgr = null
			}
			this._ac_attr_loop_list = null
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this._btn_ok, () => {
					this.Close()
				},
				this,
				true
			)
		}

		this.LoadSuccess = () => {
			this.fight_item = new FightingShowSmallItem(this._fsb_item)
			this.fight_item.Load()

			/*
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_041_l, GameResPath.GetIcon("godBefall", "uijs_041"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_041_r, GameResPath.GetIcon("godBefall", "uijs_041"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_xxxjs_001, GameResPath.GetIcon("pet", "uixxxjs_001"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("godBefall", "uijs_039"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_left, GameResPath.GetIcon("godBefall", "uijs_038"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_right, GameResPath.GetIcon("godBefall", "uijs_038"))
			*/

			this._ac_attr_loop_list = []
			this._ac_attr_loop_mgr = new LoopScrowViewMgr()
			this._ac_attr_loop_mgr.SetData(this._Scroller1, GodBefallAttrItem, this._ac_attr_loop_list, LoopScrCon.Vertical)

			
			_star_list_ = []
			for (let i = 0; i < GodBefallDefine.STAR_COUNT; i++) {
				let image = new Laya.Image
				image.visible = false
				image.height = 28
				image.width = 28
				this._gp_star.addChild(image)
				_star_list_[i] = image
			}
			

			//this:AddUIEffect("ui_image_arrary", this.image_arrary_group, null, null, true)
			//this:AddUIEffect("ui_image_bigglow", this.image_bigglow_group, null, null, true)
			//this:AddUIEffect("ui_image_particle", this.image_particle_group, null, null, true)
		}

		this.UpdateStar = (star?) => {
			let max_star = _model.GetMaxStarCount(_god_data_.id, this.config_god_star) || GodBefallDefine.STAR_COUNT
			let i = 0
			do {
				let image = _star_list_[i]
				let sp_name = (star > i && ("com_star_1a") || ("com_star_2"))
				ResManager.GetInstance().SetImageSprite(this, image, "godBefall", sp_name)
				i = i + 1
				image.visible = i <= max_star
			} while ((i < _star_list_.length)
			)
		}

		this.UpdateAttrItems = (list?) => {
			this._ac_attr_loop_list = list
			this._ac_attr_loop_mgr.replaceAll(this._ac_attr_loop_list)
		}

		this.UpdateUIModel = (data?) => {
			let id = data.id
			if (_cur_show_id_ == id) {
				return
			}
			//let res_list = [{type : UI_MODEL_TYPE.GOD, id : data.model}]
			/*
			let callBack = () => {
				this.CoverMode(this._con_top)
				this._fsb_item.ExcuteCallback(() => {
					let curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
					this.CoverEffect(this._img_title, this.layer_value, curr_sorting_order)
				})
			}
			*/
			let mode_data = {
				clothe_res_id: data.model,
				weapon_res_id: data.model,
				type: UI_MODEL_TYPE.GOD,
				layer_value: this.layer_value,
				// wing_id: data.model,
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
		}

		this.UpdateView = () => {
			let data = _god_data_
			this.UpdateUIModel(data)
			let vo = _model.GetGodVoInDic(data.id)
			this._lb_name.text = data.name
			if (!vo) {
				return
			}
			this.UpdateStar(vo.star)
			this.fight_item.Updatefighting(vo.power)
			
			let cdata = _model.GetStarData(data.id, vo.star - 1, this.config_god_star)
			let ndata = _model.GetStarData(data.id, vo.star, this.config_god_star)
			let clist = JSON.parse(cdata.attr)
			let nlist = (ndata && (JSON.parse(ndata.attr)) || (null))
			let attrs = _model.GetAttrListAndAdd(clist, nlist)
			let i = 0
			do {
				attrs[i][1] = nlist[i][1]
				i = i + 1
			} while ((i < attrs.length)
			)
			//logWarn("//////////////////////////////////////////////////////////////////////////")
			//PrintTable(attrs, 1)
			//let a_num, b_num
			//table.sort(attrs,(a?, b?) => {
			//    a_num = Number(a[1])
			//    b_num = Number(b[1])
			//    if (a_num != b_num ) { 
			//        return a_num < b_num
			//    }
			//    return false
			//})
			this.UpdateAttrItems(attrs)
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	_img_xxxjs_001: Laya.Image
	_gp_model: Laya.Box
	_Image3: Laya.Image
	_Image1: Laya.Image
	lb_title: Laya.Label
	_con_top: Laya.Box
	_img_title: Laya.Image
	_Image4: Laya.Image
	_fsb_item: Laya.Box
	_lb_name: Laya.Label
	_gp_star: Laya.HBox
	_Scroller1: Laya.List
	_btn_ok: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	public GetComponents() {
		[
			this._img_xxxjs_001,
			this._gp_model,
			this._Image3,
			this._Image1,
			this.lb_title,
			this._con_top,
			this._img_title,
			this._Image4,
			this._fsb_item,
			this._lb_name,
			this._gp_star,
			this._Scroller1,
			this._btn_ok,
			this._Image5,
			this._Label1,
		]
			= this.GetChildrenByNames([
				"_img_xxxjs_001",
				"_gp_model",
				"_Image3",
				"_Image1",
				"lb_title",
				"_con_top",
				"_img_title",
				"_Image4",
				"_fsb_item",
				"_lb_name",
				"_gp_star",
				"_Scroller1",
				"_btn_ok",
				"_Image5",
				"_Label1",
			])
	}
}
window["GodBefallStarTipsView"] = GodBefallStarTipsView