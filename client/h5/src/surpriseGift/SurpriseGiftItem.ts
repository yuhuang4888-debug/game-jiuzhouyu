import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { SceneEventType } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DressType } from "../commonModel/DressModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { PoseState } from "../util/StateMachineManager"
import { GetSizeDeltaX, GlobalTimerQuest, SetSizeDeltaX, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class SurpriseGiftItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_gp_btn: Laya.Box
	_img_item_bg: Laya.Image
	_gp_model: Laya.Box
	_img_fight_down: Laya.Image
	_bit_fight: Laya.Label
	_Image1: Laya.Image
	_Group1: Laya.HBox
	_bit_day_return: Laya.Label
	_Image2: Laya.Image
	_Group2: Laya.HBox
	_bit_all_return: Laya.Label
	_Image3: Laya.Image
	ClearModel
	InitEvent
	InitView
	LocalDeleteMe
	PlayRole
	ReOpen_callback
	SetData
	ShowFootEffect
	ShowModel
	all_day_gp
	day_gp
	id
	model_id
	time_id
	type_id
	WIDTH = 254
	HEIGT = 350

	public constructor(parent?) {
		super()


		this.base_file = "surpriseGift"
		this.layout_file = "SurpriseGiftItem"
		let gift_cfg = null
		let reward_model = null
		let local_SceneEventType = SceneEventType
		let local_SurpriseGiftModel = SurpriseGiftModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_ResManager = ResManager.GetInstance()
		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_btn, (e?) => {
				if (gift_cfg && gift_cfg.gift_id) {
					local_SurpriseGiftModel.GetInstance().Fire(local_SurpriseGiftModel.SELECT_VIEW, gift_cfg.gift_id)
				}
			}
				, this, false)
			this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.REAL_FIGHT, (scmd?) => {
				if (scmd.type_id == this.type_id && this.id == scmd.id) {
					this._bit_fight.text = "z" + scmd.power
				}
			}
			)
			//let role_fun = (role?, role_id?) => {
			//this:PlayRole(role)
			//}

			//this:BindEvent(local_GlobalEventSystem, local_SceneEventType.UIROLE_VO_ADD_SUCCESS, role_fun)
		}
		this.load_callback = () => {

			this.InitEvent()
		}
		//this.ReOpen_callback = () => {
		//if (this.model_id ) {
		//this:ShowModel(this.model_id)
		//}
		//}
		this.Load()
		

		this.InitView = () => {
			//local_ResManager:SetOutsideImageSprite(this, this._img_fight_down, GameResPath.GetIcon("common","uisbdb_017"),true)
			//local_ResManager:SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("surpriseGift","uijxlwcj_0039"),true)
			if (!gift_cfg || Util.IsTableEmpty(gift_cfg)) {
				return
			}
			if (gift_cfg.gift_id == 2) {
				this.type_id = 2
				this.id = 5
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_PROTO, 16022, "cc", this.type_id, this.id)
			} else if (gift_cfg.gift_id == 3) {
				this.type_id = 3
				this.id = 17
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_PROTO, 16022, "cc", this.type_id, this.id)
			} else if (gift_cfg.gift_id == 4) {
				this.type_id = 1
				this.id = 8
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_PROTO, 16022, "cc", this.type_id, this.id)
			}


			let cfg = gift_cfg
			//let url = null
			//

			//if (1 == cfg.gift_id ) {
			//url = GameResPath.GetIcon("surpriseGift","uijxlwcj_035")
			//},
			//if (2 == cfg.gift_id ) {
			//url = GameResPath.GetIcon("surpriseGift","uijxlwcj_035")
			//},
			//if (3 == cfg.gift_id ) {
			//url = GameResPath.GetIcon("surpriseGift","uijxlwcj_036")
			//},
			//if (4 == cfg.gift_id ) {
			//url = GameResPath.GetIcon("surpriseGift","uijxlwcj_037")
			//}
			//}
			//
			//local_ResManager:SetOutsideImageSprite(this, this._img_item_bg, url,true)
			this._lb_title.text = cfg.gift_dec
			let return_gold = cfg.return_gold
			if (typeof (return_gold) == "string") {
				return_gold = JSON.parse(return_gold)[0]
			}
			if (return_gold[2]) {
				this._bit_day_return.text = return_gold[2]
			}
			if (return_gold[2] && cfg.return_day) {
				this._bit_all_return.text = String(return_gold[2] * cfg.return_day)
			}
			if (cfg.model_power) {
				this._bit_fight.text = "z" + cfg.model_power
			}
			if (cfg.model_id) {
				let model_id = cfg.model_id
				//this:ClearUIEffect(this._gp_model)
				//if (string.find(String(model_id),"footprint") != -1 ) {
				// this.AddUIEffect(model_id, this._gp_model, {x=0, y=30}, 2, true)
				//}else{
				let bool = cfg.gift_id == 1 && true || false
				this.ShowModel(cfg.model_id, bool)
				this.model_id = cfg.model_id
				//}
			}


			// if (this.time_id) {
			// 	GlobalTimerQuest.CancelQuest(this.time_id)
			// 	this.time_id = null
			// }
			this.time_id = setTimeout(() => {
				let width = GetSizeDeltaX(this._bit_day_return)
				let width_all = GetSizeDeltaX(this._bit_all_return)
				SetSizeDeltaX(this.day_gp, width)
				SetSizeDeltaX(this.all_day_gp, width_all)
				// LayoutRebuilder(this._Group2)
				// LayoutRebuilder(this._Group1)
			}, 0.02)

		}

		this.ShowFootEffect = (model_id?) => {
			let fun = (list?) => {
				if (list) {
					let tmp = null
					let i = 0
					let length = list.length
					do {
						tmp = list[i]
						if (tmp.figure_type == FigureProtoVo.FigureType.Wing || tmp.figure_type == FigureProtoVo.FigureType.Horse) {
							list[i].figure_id = 0
						}
						i = i + 1
					} while ((i < length))
				}
				return list
			}

			let main_role = RoleManager.GetInstance().mainRoleInfo
			let role_vo = SceneManager.GetInstance().CreateRoleVo()
			role_vo.role_id = main_role.role_id + 1
			role_vo.sex = main_role.sex
			role_vo.career = main_role.career
			role_vo.fashion_model_list = Util.DeepCopy(main_role.fashion_model_list)
			role_vo.level_model_list = Util.DeepCopy(main_role.level_model_list)
			role_vo.figure_list = fun(Util.DeepCopy(main_role.figure_list))
			role_vo.revelation_suit = main_role.revelation_suit
			role_vo.pos_x = -50
			role_vo.pos_y = 50
			role_vo.force_show_foot_effect = true
			role_vo.foot_effect_scale = new Vector2(1.5, 1.5)
			role_vo.dress_list = [{ dress_type: DressType.Foot, dress_id: model_id }]
			local_GlobalEventSystem.Fire(local_SceneEventType.UIROLE_VO_ADD, role_vo, this._gp_model, this._gp_model)
		}

		this.PlayRole = (role?) => {
			if (role) {
				role.SetScale(1.3)
				role.SetDirectionByNum(1)
				role.ChangeState(PoseState.MOVE)
			}
		}

		this.ShowModel = (model_id?, is_hair?) => {
			if (reward_model) {
				this.ClearModel()
			}
			let call_fun = (ui_model?) => {
				// reward_model = ui_model
				// let a = this._gp_model.GetChild(0)
				// let ani = this._gp_model.GetChild(0).gameObject.GetComponent("Animator")
				// ani.Play("show")
			}
			model_id = JSON.parse(model_id)
			CustomActivityModel.GetInstance().ShowViewModel(this, "SurpriseGiftItem", model_id, this._gp_model, call_fun, null, null, ["show"], false)
		}

		this.SetData = (_gift_cfg?) => {

		}
		this.dataChanged = () => {
			if (super.dataChanged()) {
				gift_cfg = this.data
				this.InitView()
			}
		}

		this.ClearModel = () => {
			//if (reward_model ) {
			//reward_model:DeleteMe()
			//reward_model = null
			//}
		}

		this.LocalDeleteMe = () => {
			this.ClearModel()
			// if (this.time_id) {
			// 	GlobalTimerQuest.CancelQuest(this.time_id)
			// 	this.time_id = null
			// }
			super.DeleteMe()
		}


	}


	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._lb_title,
			this._gp_btn,
			this._img_item_bg,
			this._gp_model,
			this._img_fight_down,
			this._bit_fight,
			this._Image1,
			this._Group1,
			this._bit_day_return,
			this._Image2,
			this._Group2,
			this._bit_all_return,
			this._Image3,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_title",
				"_gp_btn",
				"_img_item_bg",
				"_gp_model",
				"_img_fight_down",
				"_bit_fight",
				"_Image1",
				"_Group1",
				"_bit_day_return",
				"_Image2",
				"_Group2",
				"_bit_all_return",
				"_Image3",
			])
			ResManager.GetInstance().LoadFont(this, "surpriseFnt", this._bit_fight, null, false)
	}
}
window["SurpriseGiftItem"] = SurpriseGiftItem