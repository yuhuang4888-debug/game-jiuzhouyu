import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GodBefallModel } from "../commonModel/GodBefallModel"
import { GodBefallAttrItem } from "./GodBefallAttrItem"
import { GameResPath } from "../util/GameResPath"

export class GodBefall1TipsView extends BaseView1 {
	Clear
	ClearModel
	Content
	Emp_btn_ok
	InitEvent
	Local_Open
	Raw_gp_model
	Scr_Scroller1
	SetWXShare
	UpdateAttrItems
	UpdateUIModel
	UpdateView

	_ac_attr_loop_list
	_ac_attr_loop_mgr
	_god_data

	//_img_041_l
	//_img_041_r
	_model
	_scmd
	fight

	public constructor() {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.click_bg_toClose = true

		this._model = GodBefallModel.GetInstance()
		this.fight = null

		//let friend_invite_model = FriendInviteModel.GetInstance()
		this._ac_attr_loop_list = null
		this._ac_attr_loop_mgr = null
		let _uimodel_ = null
		let _cur_show_id_ = null
		let wx_share_tips_ = null

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			_cur_show_id_ = null
			if (this._ac_attr_loop_mgr) {
				this._ac_attr_loop_mgr.DeleteMe()
				this._ac_attr_loop_mgr = null
			}
			this._ac_attr_loop_list = null
			this.Clear()
		}

		this.open_callback = () => {
			//this.AddUIEffect("UI_1402", this.layer_value, this.image_particle_group, null, null, true)
			this.UpdateView()
		}

		this.Local_Open = (parms?) => {
			this._scmd = parms
			let data = this._model.GetGodData(this._scmd.god_id)
			this._god_data = data
			if (!this._god_data) {
				this.Close()
			} else {
				super.Open()
			}
		}

		this.Clear = () => {
			_cur_show_id_ = null
			this.ClearModel()
			if (wx_share_tips_) {
				wx_share_tips_.DeleteMe()
				wx_share_tips_ = null
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_ok, () => {
				this.Close()
			}, this, true)

			// let close_fun = () => {
			// 	this.Close()
			// }
			// this:BindEvent(friend_invite_model, FriendInviteModel.GET_WX_SHARE_REWARD_SUCCESS, close_fun)
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
			// let res_list = [{ type: UIModelClass.UI_MODEL_TYPE.GOD, id: data.model }]
			// let callBack = () => {
			// 	this.CoverMode(this._con_top)
			// }
			let model_data = {
				clothe_res_id: data.model,
				weapon_res_id: data.model,
				// wing_id: data.model,
				type: UI_MODEL_TYPE.GOD,
				layer_value: this.layer_value,
				//scale = data.model_ratio, 
				scale: 1 * data.model_ratio,
				//position = offset, 
				//load_call_back = callBack,
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model, model_data)
			_cur_show_id_ = id
		}

		this.ClearModel = () => {
			if (_uimodel_) {
				_uimodel_.DeleteMe()
				_uimodel_ = null
			}
		}

		this.UpdateView = () => {
			let data = this._god_data
			this.UpdateUIModel(data)
			let vo = this._model.GetGodVoInDic(data.id)
			this._lb_name.text = data.name
			if (!vo) {
				return
			}
			this.fight.Updatefighting(vo.power)
		}

		this.SetWXShare = () => {
			// let call_back = (show?) => {
			// 	this.wx_share_con.visible = show
			// 	this._btn_ok.visible = !show
			// 	if (this.wx_share_con.visible) {
			// 		if (!wx_share_tips_) {
			// 			wx_share_tips_ = new WXShareTips(this.wx_share_con)
			// 			wx_share_tips_.Load()
			// 		}
			// 	}
			// }
			// friend_invite_model.ShowWXShare(call_back)
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}
	
	public LoadSuccess() {
		this.fight = new FightingShowSmallItem(this._fsb_item)
		this.fight.Load()

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_xxxjs_001, GameResPath.GetIcon("godBefall", "ui_shape_28"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bgattr, GameResPath.GetIcon("godBefall", "ui_shape_29"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bgskill, GameResPath.GetIcon("godBefall", "ui_shape_29"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_041_l, GameResPath.GetIcon("godBefall", "uijs_041"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_041_r, GameResPath.GetIcon("godBefall", "uijs_041"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_xxxjs_001, GameResPath.GetIcon("pet", "uixxxjs_001"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_left, GameResPath.GetIcon("godBefall", "uijs_038"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_right, GameResPath.GetIcon("godBefall", "uijs_038"))

		//this:AddUIEffect("ui_image_arrary", this.image_arrary_group, null, null, true)
		//this:AddUIEffect("ui_image_bigglow", this.image_bigglow_group, null, null, true)
		//this:AddUIEffect("ui_image_particle", this.image_particle_group, null, null, true)
		//this:SetWXShare()

		this.Local_LoadSuccess()
	}

	public Local_LoadSuccess() {
		this._ac_attr_loop_list = []
		this._ac_attr_loop_mgr = new LoopScrowViewMgr()
		this._ac_attr_loop_mgr.SetData(this._Scroller1, GodBefallAttrItem, this._ac_attr_loop_list, LoopScrCon.Vertical)
	}

	_img_xxxjs_001: Laya.Image
	image_bigglow_group: Laya.Box
	image_arrary_group: Laya.Box
	image_particle_group: Laya.Box
	_gp_model: Laya.Box
	_con_top: Laya.Box
	_img_title: Laya.Image
	_fsb_item: Laya.Box
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_Group1: Laya.VBox
	_gp_attr: Laya.Box
	img_bgattr: Laya.Image
	_Image4: Laya.Image
	lb_attr: Laya.Label
	_Scroller1: Laya.List
	_gp_skill: Laya.Box
	img_bgskill: Laya.Image
	_Image2: Laya.Image
	lb_skill: Laya.Label
	_dg_skill: Laya.HBox
	_btn_ok: Laya.Box
	_Image6: Laya.Image
	_Label1: Laya.Label
	wx_share_con: Laya.Box
	public GetComponents() {
		[
			this._img_xxxjs_001,
			this.image_bigglow_group,
			this.image_arrary_group,
			this.image_particle_group,
			this._gp_model,
			this._con_top,
			this._img_title,
			this._fsb_item,
			this._Image1,
			this._lb_name,
			this._Group1,
			this._gp_attr,
			this.img_bgattr,
			this._Image4,
			this.lb_attr,
			this._Scroller1,
			this._gp_skill,
			this.img_bgskill,
			this._Image2,
			this.lb_skill,
			this._dg_skill,
			this._btn_ok,
			this._Image6,
			this._Label1,
			this.wx_share_con,
		]
			= this.GetChildrenByNames([

				"_img_xxxjs_001",
				"image_bigglow_group",
				"image_arrary_group",
				"image_particle_group",
				"_gp_model",
				"_con_top",
				"_img_title",
				"_fsb_item",
				"_Image1",
				"_lb_name",
				"_Group1",
				"_gp_attr",
				"img_bgattr",
				"_Image4",
				"lb_attr",
				"_Scroller1",
				"_gp_skill",
				"img_bgskill",
				"_Image2",
				"lb_skill",
				"_dg_skill",
				"_btn_ok",
				"_Image6",
				"_Label1",
				"wx_share_con",
			])
	}
}
window["GodBefall1TipsView"] = GodBefall1TipsView