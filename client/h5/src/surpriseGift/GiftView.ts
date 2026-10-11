import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { SceneEventType } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DressType } from "../commonModel/DressModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SurpriseGiftModel } from "../commonModel/SurpriseGiftModel"
import { SceneManager } from "../scene/SceneManager"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { PoseState } from "../util/StateMachineManager"
import { GlobalTimerQuest, Split, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class GiftView extends BaseItem1 {
	_img_title: Laya.Image
	_Image1: Laya.Image
	_gp_effect: Laya.Box
	_gp_model: Laya.Box
	_gp_foot: Laya.Box
	_img_fight_down: Laya.Image
	_img: Laya.Image
	_bit_fight: Laya.Label
	_btn_buy: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Image2: Laya.Image
	_Group2: Laya.HBox
	_Label1: Laya.Label
	_Group1: Laya.Box
	_Image3: Laya.Image
	_lb_original_price: Laya.Label
	_Image4: Laya.Image
	_Image5: Laya.Image
	_lb_price: Laya.Label
	_gp_skill: Laya.Box
	_img_skill_bg: Laya.Image
	_Image6: Laya.Image
	_img_skill_icon: Laya.Image
	_gp_reward: Laya.Box
	_Image7: Laya.Image
	_lb_skill_name: Laya.HTMLDivElement
	_lb_skill_dec: Laya.HTMLDivElement
	ClearModel
	CustomMehod
	DeleteMe
	Emp_btn_buy
	InitEvent
	InitItem
	InitSkill
	InitView
	PlayRole
	ReOpen_callback
	RefBtn
	ShowFootEffect
	ShowModel
	id
	model_id
	time_id
	type_id

	public constructor(parent?) {
		super(parent)


		this.base_file = "surpriseGift"
		this.layout_file = "GiftView"
		let local_SurpriseGiftModel = SurpriseGiftModel
		let model = local_SurpriseGiftModel.GetInstance()
		let local_RoleManager = RoleManager.GetInstance()
		let local_ResManager = ResManager.GetInstance()
		let reward_model = null
		let reward_item = null
		let index = null
		let gift_cfg = null
		let price = null
		let is_can_buy = true
		let id_list = []
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let goods_model = GoodsModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let local_Erlang = ErlangParser.GetInstance()
		this.load_callback = () => {

			this.InitEvent()
			this.InitView()
			//this._lb_skill_dec.lineSpacing = 1
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_skill_name.size  = 20
			// 	this._lb_skill_dec.size  = 18
			// 	this._lb_skill_dec.lineSpacing = 0.8
			// }
			this._gp_effect.width = 720 * 2.6
			this._gp_effect.height = 1280 * 2.6
			this._gp_effect.centerX = 0
			this._gp_effect.centerY = 190
			this.AddUIEffect("ui_tianshihusongjiemian", this._gp_effect)


		}
		this.ReOpen_callback = () => {
			if (this.model_id) {
				this.ShowModel(this.model_id)
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_buy, () => {
				if ((gift_cfg && gift_cfg.gift_id) && is_can_buy) {
					let role = local_RoleManager.mainRoleInfo
					// [ts2lua]lua中0和空字符串也是true，此处price[0] == 1需要确认
					let have_money = Number(price[0]) == 1 && role.jin || role.jin + role.jinLock
					if (have_money >= Number(price[2])) {
						// [ts2lua]lua中0和空字符串也是true，此处price[0] == 1需要确认
						let name = Number(price[0]) == 1 && "勾玉" || "勾玉(优先消耗绑玉)"
						let str = "是否消耗<font color='#639c12'>" + price[2] + name + "</font>,继续购买"
						let ok_func = () => {
							model.Fire(local_SurpriseGiftModel.SCMD_REQUEST, 49001, gift_cfg.gift_id)
						}

						local_Alert.Show(Util.StrToHTML(str), local_Alert_Type.Two, ok_func)
					} else {
						local_Alert.Show("勾玉不足，是否前往充值", local_Alert_Type.Two, () => {
							OpenFun.OpenFunHandler(21)
						}
						)
					}
				} else if (!is_can_buy) {
					Message.show("已购买")
				}
			}
				, this, true)
			let buy_callback = (gift_id?) => {
				if (gift_cfg && gift_cfg.gift_id == gift_id) {
					let reward = gift_cfg.gift_reward
					if (reward) {
						if (typeof (reward) == "string") {
							reward = JSON.parse(reward)
						}
						let sex = local_RoleManager.mainRoleInfo.sex
						// [ts2lua]reward下标访问可能不正确
						// [ts2lua]reward下标访问可能不正确
						reward = reward[sex - 1] && reward[sex - 1][1]
						let view = new CongratulationObtainView(reward)
						view.Open()
					}
				}
			}

			this.BindEvent(model, local_SurpriseGiftModel.BUY_SUCCESS, buy_callback)
			let updata_view = () => {
				this.RefBtn()
			}

			this.BindEvent(model, local_SurpriseGiftModel.UPDATA_VIEW, updata_view)
			this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.REAL_FIGHT, (scmd?) => {
				if (scmd.type_id == this.type_id && this.id == scmd.id) {
					this._bit_fight.text = "z" + scmd.power
				}
			}
			)
			//AddClickEvent(this._gp_model,() => {
			//if (gift_cfg ) {
			//let reward = gift_cfg.gift_reward
			//if (typeof(reward) == "string" ) {
			//reward = local_Erlang.Parse(reward)
			//}
			//if (reward && reward.length ) {
			//let sex = local_RoleManager.mainRoleInfo.sex
			//// [ts2lua]reward下标访问可能不正确
			//reward = reward[sex - 1][1][0]
			//if (reward ) {
			//let type_id, lock = goods_model.GetMappingTypeId(reward[0], reward[1])
			//UIToolTipMgr:GetInstance():DefaultAppendTips(type_id, reward[2])
			//}
			//}
			//}
			//}
			//, this, false)
			//let role_fun = (role?, role_id?) => {
			//this:PlayRole(role)
			//}

			//this:BindEvent(local_GlobalEventSystem, local_SceneEventType.UIROLE_VO_ADD_SUCCESS, role_fun)
		}

		this.InitView = () => {
			//local_ResManager:SetOutsideImageSprite(this, this._img_fight_down, GameResPath.GetIcon("common","uisbdb_017"),true)
			//lua_resM:SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("surpriseGift","uijxlwcj_0028"),true)
			//lua_resM:SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("surpriseGift","uijxlwcj_0020"),true)
			//lua_resM:SetOutsideImageSprite(this, this._img_skill_bg, GameResPath.GetIcon("surpriseGift","uijxlwcj_0019a"),true)
			if (index <= 0) {
				return
			}
			if (index == 2) {
				this.type_id = 2
				this.id = 5
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_PROTO, 16022, "cc", this.type_id, this.id)
			} else if (index == 3) {
				this.type_id = 3
				this.id = 17
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_PROTO, 16022, "cc", this.type_id, this.id)
			} else if (index == 4) {
				this.type_id = 1
				this.id = 8
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.REQUEST_PROTO, 16022, "cc", this.type_id, this.id)
			}

			model.SetGradeRed(index)
			let cfg = model.getCfgGift(index)
			if (!cfg || Util.IsTableEmpty(cfg)) {
				return
			}
			gift_cfg = cfg
			//let url = "client/assets/icon/surpriseGift/" +  + ".png"
			local_ResManager.SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("surpriseGift", `uijxlwcj_${cfg.gift_id}`), true)
			if (cfg.model_power) {
				this._bit_fight.text = "z" + cfg.model_power
			}
			if (cfg.model_id) {
				this.ShowModel(cfg.model_id)
				this.model_id = cfg.model_id
			}
			if (cfg.gift_price) {
				let prices = cfg.gift_price
				if (typeof (prices) == "string") {
					prices = JSON.parse(prices)
				}
				if (prices[0]) {
					this._lb_original_price.text = prices[0][2]
				}
				if (prices[1]) {
					price = prices[1]
					this._lb_price.text = prices[1][2]
				}
			}
			//LayoutRebuilder(this._Group2)
			this.RefBtn()
			this.InitItem()
		}

		this.InitItem = () => {
			if (gift_cfg) {
				let gift_id = gift_cfg.gift_id
				let kv_cfg = model.getCfgGiftKvCfgByValue(gift_id + 3)
				if (kv_cfg) {
					let reward = kv_cfg.value
					if (reward && typeof (reward) == "string") {
						reward = JSON.parse(reward)
					}
					if (reward && reward[0]) {
						let v = reward[0]
						if (!reward_item) {
							reward_item = new EquipmentItem(this._gp_reward)
							reward_item.Load()
							reward_item.SetItemSize(55, 55)
						}
						reward_item.ExcuteCallback(() => {
							let [type_id, lock] = goods_model.GetMappingTypeId(v[0], v[1])
							reward_item.SetData(type_id, v[2], lock)
						}
						)
					}
					let desc = kv_cfg.desc
					if (desc && typeof (desc) == "string") {
						desc = Split(desc, "@")
					}
					this._lb_skill_name.visible = true
					this._lb_skill_dec.visible = true
					this._lb_skill_name.style.fontSize = 18
					this._lb_skill_name.style.color = "#ff6600"
					this._lb_skill_name.style.wordWrap = false
					this._lb_skill_dec.style.leading = 1
					this._lb_skill_dec.style.fontSize = 16
					this._lb_skill_dec.style.color = "#774239"
					this._lb_skill_dec.width = 200
					//this._lb_skill_dec.style.wordWrap = false
					if (desc.length > 1) {
						this._lb_skill_name.innerHTML = Util.StrToHTML("【" + desc[0] + "】")
						this._lb_skill_dec.innerHTML = Util.StrToHTML(desc[1])
					} else if (desc.length) {
						this._lb_skill_name.visible = false
						this._lb_skill_dec.innerHTML = Util.StrToHTML(desc[0])
					} else {
						this._lb_skill_name.visible = false
						this._lb_skill_dec.visible = false
					}
				}
			}
		}

		// this.InitSkill = () => {
		// 	if (gift_cfg) {
		// 		let gift_id = gift_cfg.gift_id
		// 		let kv_cfg = model.getCfgGiftKvCfgByValue(gift_id + 3)
		// 		if (kv_cfg) {
		// 			let SetMask = () => {
		// 				//SetCircleMask(this._img_skill_icon)
		// 			}

		// 			SetMask()
		// 			this._lb_skill_dec.innerHTML = Util.StrToHTML(kv_cfg.desc)
		// 			let skill_cfg = SkillManager.GetInstance().getSkillFromConfig(Number(kv_cfg.value))
		// 			if (skill_cfg) {
		// 				this._lb_skill_name.innerHTML = Util.StrToHTML("【" + skill_cfg.name + "】")
		// 				local_ResManager.SetOutsideImageSprite(this, this._img_skill_icon, GameResPath.GetSkillIconPath(skill_cfg.id))
		// 			}
		// 			this._gp_skill.visible = true
		// 			return
		// 		}
		// 	}
		//}

		this.RefBtn = () => {
			if (!gift_cfg) {
				return
			}
			let info = model.GetViewInfo()
			if (info && info.gift_list.length > 0) {
				for (let _tmpi in info.gift_list) {
					var v = info.gift_list[_tmpi]
					if (v.gift_id == gift_cfg.gift_id) {
						is_can_buy = false
						break
					}
				}
			}
			//let label = this._btn_buy.getChildAt(1)
			// [ts2lua]lua中0和空字符串也是true，此处is_can_buy需要确认
			this.labelDisplay.text = is_can_buy && "立即抢购" || "已购买"
		}

		this.ShowModel = (model_id?) => {
			if (reward_model) {
				this.ClearModel()
			}
			//if (string.find(String(model_id),"footprint") != -1 ) {
			//	model_id = Number(string.gsub(String(model_id),"footprint_", ""))
			//this:ShowFootEffect(model_id)
			//}else{
			//this:AddUIEffect("ui_arrayglow_behind", this._gp_effect, {x=0, y=-170}, {x=1.8, y=1}, true)
			let call_fun = (ui_model?) => {
				reward_model = ui_model
			}
			let bool = gift_cfg.gift_id == 1 && true || false
			model_id = JSON.parse(model_id)
			CustomActivityModel.GetInstance().ShowViewModel(this, "GiftView", model_id, this._gp_model, call_fun, null, null, null, null, bool)
			//}
		}

		this.ClearModel = () => {
			//if (reward_model ) {
			//reward_model:DeleteMe()
			//reward_model = null
			//}
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

			let main_role = local_RoleManager.mainRoleInfo
			let role_vo = SceneManager.GetInstance().CreateRoleVo()
			role_vo.role_id = main_role.role_id
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
			role_vo.dress_list = [{ dress_type: DressType.Foot, dress_id: 0 }]
			local_GlobalEventSystem.Fire(local_SceneEventType.UIROLE_VO_ADD, role_vo, this._gp_model, this._gp_model)
			this._gp_model.x = 250
			let i = 1
			let timeout = () => {
				this.AddUIEffect("footprint_" + model_id, this._gp_foot)
				i = i - 1
			}

			timeout()
			this.time_id = setTimeout(timeout, 0.3)
			//table.insert(id_list, id)
		}

		this.PlayRole = (role?) => {
			if (role) {
				role.SetScale(2)
				role.SetDirectionByNum(1)
				role.ChangeState(PoseState.MOVE)
			}
		}

		this.CustomMehod = (_index?, args?) => {
			index = _index
		}

		this.DeleteMe = () => {
			// if (this.time_id) {
			// 	GlobalTimerQuest.CancelQuest(this.time_id)
			// 	this.time_id = null
			// }
			this.ClearUIEffect(this._gp_effect)
			this.ClearModel()
			super.DeleteMe()
			//	UIScene.GetInstance().ClearUIScene()
		}


	}



	public GetComponents() {
		[
			this._img_title,
			this._Image1,
			this._gp_effect,
			this._gp_model,
			this._gp_foot,
			this._img_fight_down,
			this._img,
			this._bit_fight,
			this._btn_buy,
			this._Image11,
			this.labelDisplay,
			this._Image2,
			this._Group2,
			this._Label1,
			this._Group1,
			this._Image3,
			this._lb_original_price,
			this._Image4,
			this._Image5,
			this._lb_price,
			this._gp_skill,
			this._img_skill_bg,
			this._Image6,
			this._img_skill_icon,
			this._gp_reward,
			this._Image7,
			this._lb_skill_name,
			this._lb_skill_dec,
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_Image1",
				"_gp_effect",
				"_gp_model",
				"_gp_foot",
				"_img_fight_down",
				"_img",
				"_bit_fight",
				"_btn_buy",
				"_Image11",
				"labelDisplay",
				"_Image2",
				"_Group2",
				"_Label1",
				"_Group1",
				"_Image3",
				"_lb_original_price",
				"_Image4",
				"_Image5",
				"_lb_price",
				"_gp_skill",
				"_img_skill_bg",
				"_Image6",
				"_img_skill_icon",
				"_gp_reward",
				"_Image7",
				"_lb_skill_name",
				"_lb_skill_dec",
			])
		ResManager.GetInstance().LoadFont(this, "surpriseFnt", this._bit_fight, null, false)
	}
}
window["GiftView"] = GiftView