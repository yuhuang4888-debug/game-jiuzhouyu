import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { AdventureModel, Adventure_Cfg } from "../commonModel/AdventureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HaloModel } from "../commonModel/HaloModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { AdModuleId, WelfareEvent, WelfareModel } from "../commonModel/WelfareModel"
import { Point } from "../scene/AstarManager"
import { AttachNode, FashionPartPos, SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { Util, NotEnougnDiamond, GlobalTimerQuest, SetLocalPosition, HtmlColorTxt, RefBoxChildsLayout } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { AdventureItem } from "./AdventureItem"

export class AdventureMainView extends BaseItem1 {
	
	ChangeRotation
	ChangeStatus
	ClearTimeOutID
	CreateHorse
	CreateRole
	DeleteMeFunc
	DoMove
	InitEvent
	InitItem
	InitRefNum
	InitRewardPreview
	InitView
	LoadSuccess
	OnTimer
	RefCostInfo
	RefGoCost
	RefPosLocation
	StepCallback
	Update
	InitHalo
    UpdateHalo
	InitAd
	UpdateAd

	_gp_reward
	all_time
	cur_steps
	custom_sorting_order
	end_pos
	move_speed
	move_x
	move_y
	scmd_Data
	star_pos
	time_id
	timeout_id
	update_time
	runer_id
	Step_anim
	role
	public constructor(parent?) {
		super(parent)


		this.base_file = "adventure"
		this.layout_file = "AdventureMainView"
		this.layer_value = Enum_UILayer.UI
		let local_AdventureModel = AdventureModel
		let model = AdventureModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_Message = Message
		let role_mgr = RoleManager.GetInstance()
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let vip_model = VipModel.GetInstance()
		let local_OpenFun = OpenFun

		let local_Erlang = ErlangParser.GetInstance()
		let local_TimeUtil = TimeUtil
		let timer_ = null
		let re_pro_list_ = []
		let re_box_pro_list_ = []
		let box_item_list_ = []
		let info_ = null
		let cost_ = []
		let extro_cost_ = null
		let use_extro_ = true
		let ref_left_num_ = 0
		let box_pos_ = [{ x: 71, y: 728 }, { x: 142, y: 688 }, { x: 212, y: 729 }, { x: 284, y: 768 }, { x: 350, y: 738 },
		{ x: 421, y: 769 }, { x: 490, y: 809 }, { x: 562, y: 770 }, { x: 630, y: 738 }, { x: 561, y: 689 }, { x: 493, y: 649 },
		{ x: 562, y: 608 }, { x: 630, y: 581 }, { x: 561, y: 528 }, { x: 493, y: 489 }, { x: 425, y: 527 }, { x: 356, y: 572 },
		{ x: 285, y: 615 }, { x: 215, y: 568 }, { x: 145, y: 530 }, { x: 211, y: 496 }, { x: 282, y: 448 }, { x: 353, y: 408 },
		{ x: 423, y: 367 }, { x: 490, y: 327 }, { x: 560, y: 299 }, { x: 490, y: 250 }, { x: 420, y: 211 }, { x: 350, y: 250 },
		{ x: 282, y: 210 }, { x: 175, y: 138 }]
		let box_index_ = [13, 12, 11, 10, 9, 8, 7, 6, 3, 4, 5, 0, 1, 2, 29, 28, 30, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 14, 15, 16, 27]
		let uirole_ = null
		let id_list_ = []
		this.move_x = 0
		this.move_y = 0
		this.move_speed = 1
		this.preload_server_config = {
			"config_adventure_loc": false
		}
		this.load_callback = () => {
			this._lb_cost_num.style.fontSize = 24
			this._lb_cost_num.style.color = "#672a2a"
			this._lb_cost_num.style.wordWrap = false
			this._lb_cost_num.style.stroke = 4
			this._lb_cost_num.style.strokeColor = "#e3d0ba"
			this._lb_ref_num.style.fontSize = 18
			this._lb_ref_num.style.color = "#704432"
			this._lb_ref_num.style.wordWrap = false
			this._lb_vip.style.fontSize = 18
			this._lb_vip.style.color = "#cc5600"
			this._lb_vip.style.wordWrap = false
			this._lb_time.style.fontSize = 18
			this._lb_time.style.color = "#00fa64"
			this._lb_time.style.wordWrap = false
			this._Scroller1.hScrollBar.visible = false
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_AdventureModel.UPDATE_RED, () => {
				this._img_shop_red.visible = model.GetShopRed()
			}
			)
			let role_fun = (role?, role_id?) => {
				uirole_ = role
			}

			//this:BindEvent(local_GlobalEventSystem, local_SceneEventType.UIROLE_VO_ADD_SUCCESS, role_fun)
			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_NUM, (list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in list) {
					var v = list[_tmpi]
					if (extro_cost_ && v.type_id == extro_cost_[1]) {
						this.RefCostInfo()
						this.RefGoCost()
					}
				}
			}
			)
			Util.AddClickEvent(this._img_extro_1, () => {
				use_extro_ = !use_extro_
				this._img_extro_1.visible = !use_extro_ ? true : false
				this._img_extro_2.visible = use_extro_ ? true : false
				this.RefGoCost()
			}
				, this, true)
			Util.AddClickEvent(this._img_extro_2, () => {
				use_extro_ = !use_extro_
				this._img_extro_1.visible = !use_extro_ ? true : false
				this._img_extro_2.visible = use_extro_ ? true : false
				this.RefGoCost()
			}
				, this, true)
			Util.AddClickEvent(this._btn, () => {
				if (!model.act_open_) {
					local_Message.show("活动已经结束")
					return
				}
				let left_time = model.GetZoreStatus()
				if (left_time > 0) {
					local_Message.show("商店0点刷新中")
					return
				}
				if (model.is_request_42702) {
					local_Message.show("投掷中")
					return
				}
				if (!info_) {
					return
				}
				let role = role_mgr.mainRoleInfo
				let recharge = () => {
					NotEnougnDiamond()
				}

				let rq_scmd = (scmd, ...new_args) => {
					let args = new_args
					if (scmd == 42703) {
						model.Fire(local_AdventureModel.REQUEST_SCMD, scmd)
					} else if (scmd == 42702) {
						model.is_request_42702 = true
						model.Fire(local_AdventureModel.REQUEST_SCMD, scmd, args[0])
					}
				}

				let func = (cost?) => {
					let name
					let have_num = 0
					if (cost[0] == 1) {
						name = "勾玉"
						have_num = role.jin
					} else if (cost[0] == 2) {
						name = "绑玉(优先消耗勾玉)"
						have_num = role.jin + role.jinLock
					} else {
						let [type, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
						let basic = goods_model.GetGoodsBasicByTypeId(type)
						if (basic) {
							name = basic.name
						}
						have_num = goods_model.GetTypeGoodsNum(type)
					}
					return [name, have_num]
				}

				let alert_fun = (str?, have_num?, callback?, alert_key?) => {
					let check = false
					let ok_func = () => {
						if (check) {
							model.alert_status[alert_key] = false
						}
						if (cost_[2] > have_num && (cost_[0] == 1 || cost_[0] == 2)) {
							recharge()
						} else if (cost_[2] > have_num && (cost_[0] == 1 || cost_[0] == 2)) {
							local_Message.show(name + "数量不足")
						} else {
							callback()
						}
					}

					let check_func = () => {
						check = !check
					}

					local_Alert.Show(Util.StrToHTML(str), local_Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_func, "本次登录不再提示")
				}

				if (info_.location == 30) {
					if (ref_left_num_ > 0) {
						let callback = () => {
							rq_scmd(42703)
						}
						if ((cost_ && cost_.length > 0) && model.alert_status["alert_ref"]) {
							let [name, have_num] = func(cost_)
							let str = "是否消耗<font color='#639c12'>" + cost_[2] + name + "</font>,进行重置"
							alert_fun(str, have_num, callback, "alert_ref")
						} else {
							callback()
						}
					} else {
						let vip = role.vip_flag
						let vip_card = vip_model.GetNobleCardState()
						let num_type = vip_model.GetVipCfgNumType(427, 42701)
						// if (num_type == 2) {
						// 	vip_card = 99
						// }
						vip_card = 99
						let value = vip_model.GetVipPrivilegeValue(427, 42701, vip_card, vip,true)
						let i = vip + 1
						vip_card = 99
						do {
							let num = vip_model.GetVipPrivilegeValue(427, 42701, vip_card, i, true)
							if (num > value) {
								let ok_callback = () => {
									local_OpenFun.OpenFunHandler(23, 0)
								}

								let content = "VIP" + i + "可增加挑战次数,是否前往提升？"
								local_Alert.Show(content, local_Alert_Type.Two, ok_callback, null, "前往")
								return
							}
							i = i + 1
						} while ((i <= 15)
						)
						local_Message.show("次数已用完，请明日再来")
					}
				} else {
					let callback = () => {
						if (use_extro_) {
							rq_scmd(42702, 1)
						} else {
							rq_scmd(42702, 0)
						}
					}

					if ((cost_ && cost_.length > 0) && model.alert_status["alert_go"]) {
						let [name, have_num] = func(cost_)
						let num = 0
						let need_num = cost_[2]
						if (use_extro_) {
							let _num = goods_model.GetTypeGoodsNum(extro_cost_[1])
							num = extro_cost_[2] * _num
							have_num = have_num + num
							need_num = need_num - num
							need_num = (need_num >= 0 && (need_num) || (0))
						}
						let str = "是否消耗<font color='#639c12'>" + need_num + name + "</font>(冒险券还可抵扣<font color='#639c12'>" + num + "勾玉</font>),\n投掷一次"
						alert_fun(str, have_num, callback, "alert_go")
					} else {
						callback()
					}
				}
			}, this, true)
			
			Util.AddClickEvent(this._img_suit, () => {
				local_OpenFun.OpenFunHandler(125)
			}
				, this, true)
			Util.AddClickEvent(this._img_shop, () => {
				model.Fire(local_AdventureModel.OPEN_VIEW, "AdventureShopView")
			}
				, this, true)

			this.BindEvent(model, local_AdventureModel.UPDATA_VIEW, (scmd?) => {
				info_ = model.GetViewInfo()
				if (!info_) {
					return
				}
				this.RefGoCost()
				if (scmd && scmd.lucky_reward) {
					let cur_pos = 0
					let index = 0
					let sort_fun = (a?, b?) => {
						return a.loc < b.loc
					}
					table.sort(scmd.lucky_reward, sort_fun)
					this.scmd_Data = scmd
					if (scmd.steps) {
						let call_back_func = () => {
							this._img_num.visible = true
							ResManager.GetInstance().SetImageSprite(this, this._img_num, "adventure_asset", scmd.steps)
							this.Step_anim(scmd.steps)
						}
						this.AddUIEffect("UI_2001", this._gp_num, null, 7, false, 1, call_back_func)
					}
				} else {
					this.RefPosLocation(true)
					this.InitItem()
					this.InitRefNum()
				}
			}
			)
		}

		this.LoadSuccess = () => {
			if (!timer_) {
				let func = () => {
					this.OnTimer()
				}
				timer_ = GlobalTimerQuest.AddPeriodQuest(func, 1)
			}
			this.OnTimer()
			ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetIcon("adventure", "ui_tb_bg"), undefined, undefined, true)
			this._img_extro_1.visible = !use_extro_ ? true : false
			this._img_extro_2.visible = use_extro_ ? true : false
			let adventure_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_kv", false)
			let config_adventure_kv = model.setAdventureKvCfg(adventure_kv_cfg)
			let _type = (config_adventure_kv && config_adventure_kv[1]) && config_adventure_kv[1].value
			let num = (config_adventure_kv && config_adventure_kv[2]) && config_adventure_kv[2].value
			if (_type != null && num != null) {
				extro_cost_ = [0, _type, num]
				this._lb_tik_desc.text = extro_cost_[2]
			}
			info_ = model.GetViewInfo()
			this.RefPosLocation()
			this.InitView()
			this._img_shop_red.visible = model.GetShopRed()
			this.InitHalo()
			this.InitAd()
		}

		this.InitHalo = () => {
            //光环
            this.UpdateHalo()
            Util.AddClickEvent(this._lb_halo_tips, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
            }, this, false)
        }

        this.UpdateHalo = () => {
            if (HaloModel.GetInstance().GetOpenState()) {
                this._box_halo.visible = true
                if (HaloModel.GetInstance().GetHaloOpenState()) {
                    this._img_merge_count.visible = false
                    this._lb_halo_tips.visible = false
                }
                else {
                    this._img_merge_count.visible = false
                    this._lb_halo_tips.visible = true
                }
            }
            else {
                this._box_halo.visible = false
            }
			// RefBoxChildsLayout(this._gp_cost, 5)
        }

		this.InitAd = () =>{
			if (!WelfareModel.GetInstance().GetAdOpenState()) {
				return
			}

			//resource/game/advertising/other/ui_fllb_08.png
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_ad, GameResPath.GetIcon("advertising", "ui_fllb_08"))
			Util.AddClickEvent(this._img_ad, () => {
				let ad_cfg = WelfareModel.GetInstance().GetAdCfg(AdModuleId.Adventure)
				if(ad_cfg){
					WelfareModel.GetInstance().PlayAdAlert(ad_cfg, "观看完影片可再获得一次免费次数！")
				}
			}, this, true)

			this.BindEvent(WelfareModel.GetInstance(), WelfareEvent.UPDATE_AD_STATE, () => {
				this.UpdateAd()
			})
			this.UpdateAd()
		}

		this.UpdateAd = () =>{
			this._img_ad.visible = !WelfareModel.GetInstance().GetAdLookStateByMoudleId(AdModuleId.Adventure)
		}

		this.InitView = () => {
			this.InitRewardPreview()
			this.InitRefNum()
			this.RefCostInfo()
			this.RefGoCost()
			this.InitItem()
		}

		this.RefPosLocation = () => {
			if (!info_) {
				return
			}
			let p = info_.location
			let pos = box_pos_[p]
			if (pos && !uirole_) {
				this.CreateRole(this._gp_role, pos)
			} else if (pos && uirole_) {
				SetLocalPosition(this._gp_role, pos.x - 90, pos.y - 118)
			}
			if (p == 0) {
				this.ChangeRotation(box_pos_[p + 1])
			}
		}

		this.CreateHorse = (pos?) => {
			let func = (go?) => {
				if (Util.IsNull(go)) { return }
				let bone = Util.FindBone(go.transform, AttachNode.Ride)
				if (bone == null || Util.IsNull(go)) {
					return
				}
				this.CreateRole(bone)
			}
			let data = {
				clothe_res_id: 1900001,
				type: 10,
				scale: 100,
				layer_value: this.layer_value,
				position: new Vector3(pos.x, pos.y, 0),
				custom_sorting_order: this.custom_sorting_order,
				load_call_back: func
			}
			uirole_ = ResManager.GetInstance().SetRoleModel(this, this._gp_pos, data)
		}

		this.CreateRole = (parent?, pos?) => {
			let main_role = role_mgr.mainRoleInfo
			if (!main_role || this.role) {
				return
			}
			let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let [model_id, texture_id] = mainVo.GetRoleClotheTextureId()
			let weapon_model_id = mainVo.GetWeaponClotheId()
			let [head_model_id, head_texture_id] = mainVo.GetRoleHeadId()
			// let liveness_id = Util.GetLivenessId(mainVo)
			let data = {
				career: mainVo.career,
				sex: mainVo.sex,
				clothe_res_id: mainVo.GetRoleClotheId(),
				weapon_res_id: weapon_model_id,
				weapon_clothe_id: 0,
				type: UI_MODEL_TYPE.MAINROLE,
				scale: 1,
				fashion_model_id: model_id,
				texture_id: texture_id,
				wing_id: Util.GetWingClotheId(mainVo),
				head_wear_id: head_model_id,
				head_clothe_id: head_texture_id,
				hair_id: 0,
				// liveness_id: liveness_id,
				layout_file: "AdventureMainView",
				can_rotate: false,
				back_ornament_id: Util.GetBackOrnamentId(mainVo)
			}
			uirole_ = ResManager.GetInstance().SetRoleModel(this, this._gp_role, data)
			this._gp_role.pos(pos.x - 90, pos.y - 118)
		}

		this.ChangeStatus = (status?) => {
			if (uirole_) {
				let role
				for (let key in uirole_) {
					role = uirole_[key]
					break
				}
				if (role) {
					role.PlayActions(status, false,)
				}
			}
		}

		this.ChangeRotation = (pos?, angle?) => {
			if (uirole_ /*&& uirole_[this._gp_pos]*/ && (pos || angle)) {
				let role
				for (let key in uirole_) {
					role = uirole_[key]
					break
				}
				if (!role || !role.transform) return
				let cur_pos = { x: this._gp_role.x, y: this._gp_role.y }
				if (!angle) {
					angle = SceneManager.GetInstance().GetAngle(cur_pos, pos, true)
					role.ChangeRotate(new Laya.Vector3(0, (angle < -90 || (angle > 0 && angle < 90)) ? angle + 180 : angle, 0))
				} else {
					role.ChangeRotate(angle)
				}
			}
		}

		this.DoMove = (pos?) => {
			if (uirole_ && pos) {
				let role
				for (let key in uirole_) {
					role = uirole_[key]
					break
				}

				let distance = GameMath.GetDistance(pos.x, pos.y, this._gp_role.x, this._gp_role.y, true)
				if (distance > 0) {
					this.star_pos = { x: this._gp_role.x, y: this._gp_role.y }
					this.end_pos = pos
					this.move_x = distance
					this.move_speed = 6 // {x = Math.sin(angle)*2 ,y=Math.cos(angle)*2}
					this.all_time = distance / this.move_speed
					if (!this.runer_id) {
						this.runer_id = Runner.GetInstance().AddRunObj(this, 1)
					}
				}
			}
		}
		this.update_time = 1
		this.Update = (now_time?, elapse_time?) => {
			if (!this.move_speed || !this.star_pos) { return }
			if (this.update_time < this.all_time) {
				if (uirole_) {
					this.end_pos.z = 1
					let pos = GameMath.LerpXYZ(this.star_pos, this.end_pos, this.update_time / this.all_time)
					SetLocalPosition(this._gp_role, pos.x, pos.y)
					this.update_time = this.update_time + 1
					if (this.update_time > this.all_time) {
						this.StepCallback(this.cur_steps)
						if (this.cur_steps > 1 && this.scmd_Data) {
							this.Step_anim(this.cur_steps - 1, true)
							this.update_time = 1
						}
					}
				}
			} else {
				this.update_time = 1
				if (this.runer_id) {
					Runner.GetInstance().RemoveRunObj(this.runer_id)
					this.runer_id = null
				}

			}
		}

		this.StepCallback = (steps?) => {
			if (!this._gp_pos) {
				return
			}
			if (!this._gp_crit) {
				return
			}
			let lucky_reward = this.scmd_Data && this.scmd_Data.lucky_reward
			if (!lucky_reward) { return }
			let v = lucky_reward[lucky_reward.length - steps]
			if (!v) { return }
			let pos = box_pos_[v.loc]
			if (2 == v.crit) {
				this.ClearTimeOutID()
				this.timeout_id = setTimeout(() => {
					this.ClearUIEffect(this._gp_crit)
				}, 0.8)
			}
			let goods = local_GoodsModel.RewardKeyToNumber(v.get_goods)
			model.Fire(local_AdventureModel.OPEN_BOX, v.loc, goods, v.crit)
			if (steps == 1) {
				this.ChangeStatus(["idle"])
				this.ChangeRotation(null, 0)
				model.is_request_42702 = false
				if (this.scmd_Data.gain_goods_list && this.scmd_Data.gain_goods_list.length > 0) {
					let list = local_GoodsModel.RewardKeyToNumber(this.scmd_Data.gain_goods_list)
					let view = new CongratulationObtainView(list, 10)
					view.Open()
				}
				if (this._img_num) {
					this._img_num.visible = false
				}
				if (this._gp_num) {
					this.ClearUIEffect(this._gp_num)
				}
			}
		}

		this.Step_anim = (steps?, is_back?) => {
			this.cur_steps = steps
			let lucky_reward = this.scmd_Data && this.scmd_Data.lucky_reward
			if (!lucky_reward) { return }
			let v = lucky_reward[lucky_reward.length - steps]
			let cur_pos = v && v.loc
			let pos = box_pos_[cur_pos]
			if (!pos) {
				return
			}
			if (uirole_ && cur_pos) {
				pos = { x: pos.x - 90, y: pos.y - 118 }
				this.ChangeStatus(["run"])
				this.ChangeRotation(pos)
				this.DoMove(pos)
			}
		}

		this.InitRefNum = () => {
			if (!info_) {
				return
			}
			let role = role_mgr.mainRoleInfo
			let vip = role.vip_flag
			let vip_card = vip_model.GetNobleCardState()
			let num_type = vip_model.GetVipCfgNumType(427, 42701)
			// if (num_type == 2) {
			// 	vip_card = 99
			// }
			vip_card = 99
			let defult_value = vip_model.GetVipPrivilegeValue(427, 42701, 99, 0)
			let value = vip_model.GetVipPrivilegeValue(427, 42701, vip_card, vip, true)
			//总次数 = 额外增加的重置次数 + 默认的配置的重置次数 + VIP特权的重置次数
			let left_time = info_.free_reset_times + defult_value + value - info_.left_times 
			left_time = left_time > 0 && (left_time) || (0)
			ref_left_num_ = left_time
			this._lb_ref_num.innerHTML = Util.StrToHTML("剩余重置次数:<font color='#CC5600'>" + left_time + "</font>")
			this._lb_vip.visible = false
			let i = vip + 1
			vip_card = 99
			do {
				let num = vip_model.GetVipPrivilegeValue(427, 42701, vip_card, i, true)
				if (num > value) {
					this._lb_vip.innerHTML = Util.StrToHTML("VIP" + i + "<font color='#704432'>额外获得" + (num - value) + "次</font>")
					this._lb_vip.visible = true
					this._Group1.width = this._lb_ref_num.contextWidth + this._lb_vip.contextWidth + 10
					this._Group1.x = 334 / 2 - this._Group1.width / 2
					return
				}
				i = i + 1
			} while ((i <= 15)
			)
			this._Group1.width = this._lb_ref_num.contextWidth + this._lb_vip.contextWidth + 10
			this._Group1.x = 334 / 2 - this._Group1.width / 2
		}

		this.InitItem = () => {
			if (!info_) {
				return
			}
			let circle = info_.circle
			let stage = info_.stage
			if (circle == null || stage == null) {
				return
			}
			let adventure_loc_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_loc", false)
			let cfg = model.GetLocCfgByTurn(stage, circle, adventure_loc_cfg)
			if (!cfg || !cfg.length) {
				return
			}
			let sortFunc = (a?, b?) => {
				return a.location < b.location
			}
			table.sort(cfg, sortFunc)
			if (box_item_list_.length > 0) {
				for (let _tmpi in box_item_list_) {
					var item = box_item_list_[_tmpi]
					item.visible = false
				}
			}
			for (let i in box_index_) {

				let pos = box_index_[i]
				let item = box_item_list_[i]
				if (!item) {
					item = new AdventureItem(this._gp_box)
					item.Load()
					table.insert(box_item_list_, item)
				}
				item.ExcuteCallback(() => {
					if (box_pos_[pos + 1]) {
						SetLocalPosition(item.display_obj, box_pos_[pos + 1].x - 60, box_pos_[pos + 1].y + 30, 0)
					}
					item.SetDate(cfg[pos])
					item.visible = true
				}
				)
			}
		}

		this.RefGoCost = () => {
			if (!info_) {
				return
			}
			let cost = null
			this._red.visible = false
			if (info_.location == 30) {
				if(info_.free_reset_times > 0){
					cost = "[]"
				}
				else{
					let adventure_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_kv", false)
					let config_adventure_kv = model.setAdventureKvCfg(adventure_kv_cfg)
					let ref_cost = (config_adventure_kv && config_adventure_kv[3]) && config_adventure_kv[3].value
					if (typeof (ref_cost) == "string") {
						ref_cost = JSON.parse(ref_cost)
					}
					let next_ref = info_.left_times + 1
					for (let i in ref_cost) {
	
						let v = ref_cost[i]
						if (Number(v[0]) == next_ref) {
							cost = v[1]
							break
						}
					}
				}
				this.labelDisplay.text = "重置"
			} else {
				this._red.visible = model.GetRedValue()
				this.labelDisplay.text = "前进"
				if(info_.free_throw_times + model.free_times > info_.throw_times){
					cost = "[]"
				}
				else{
					let throw_times = info_.throw_times
					let next_times = throw_times + 1
					let cfg = model.GetCfgBYType(Adventure_Cfg.rand)
					if (cfg) {
						for (let i in cfg) {
							let v = cfg[i]
							if (next_times >= v.low_point && next_times <= v.high_point) {
								cost = v.cost
								if (cost != "[]" && typeof (cost) == "string") {
									cost = local_Erlang.Parse(cost)
								}
								break
							}
						}
					}
				}
				
			}
			if (cost) {
				this._gp_cost.visible = true
				let is_free = (cost == "[]" && (true) || (false))
				let cost_num
				if (!is_free) {
					cost = cost[0]
					cost_ = [Number(cost[0]), Number(cost[1]), Number(cost[2])]
					cost_num = cost[2]
					if ((info_.location != 30 && extro_cost_) && use_extro_) {
						let num = goods_model.GetTypeGoodsNum(extro_cost_[1])
						let jin_num = num * extro_cost_[2]
						cost_num = cost[2] - jin_num
						cost_num = (cost_num >= 0 && (cost_num) || (0))
					}
				}
				else{
					cost_ = []
				}

				let str
				if (is_free) {
					if (info_.location == 30) {
						str = "剩余免费重置:" + info_.free_reset_times + "次"
					}else{
						str = "剩余免费:" + (model.free_times + info_.free_throw_times - info_.throw_times) + "次"
					}
				}
				else{
					str = "消耗：" + cost_num
				}

				this._lb_cost_num.innerHTML = Util.StrToHTML(str)
				// this._gp_cost.width = this._lb_cost_num.contextWidth + this._img_cost_icon.width
				this._img_cost_icon.visible = !is_free
				if (!is_free) {
					let [type, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
					let basic = goods_model.GetGoodsBasicByTypeId(type)
					if (basic) {
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost_icon, GameResPath.GetGoodsIconPath(basic.goods_icon))
					}
				}
			} else {
				this._gp_cost.visible = false
			}
			RefBoxChildsLayout(this._gp_cost, 5)
		}

		this.RefCostInfo = () => {
			if (!extro_cost_) {
				return
			}
			let num = goods_model.GetTypeGoodsNum(extro_cost_[1])
			this._lb_tik.text = "冒险券:" + num + "张"
		}

		this.InitRewardPreview = () => {
			if (re_pro_list_.length > 0) {
				for (let _tmpi in re_pro_list_) {
					var item = re_pro_list_[_tmpi]
					item.visible = false
				}
			}
			let adventure_kv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_adventure_kv", false)
			let config_adventure_kv = model.setAdventureKvCfg(adventure_kv_cfg)
			let list = (config_adventure_kv && config_adventure_kv[4]) && config_adventure_kv[4].value
			if (!list) {
				return
			}
			if (typeof (list) == "string") {
				list = local_Erlang.Parse(list)
			}
			for (let i in list) {

				let item = re_pro_list_[i]
				if (!item) {
					item = new EquipmentItem(this.Content)
					item.Load()
					item.SetItemSize(67, 67)
				}
				item.ExcuteCallback(() => {
					item.visible = true
					item.SetData(list[i])
				}
				)
			}
		}

		this.OnTimer = () => {
			let left_time = model.GetZoreStatus()
			if (left_time > 0) {
				this._lb_time.innerHTML = Util.StrToHTML("重置中(" + left_time + "s)")
			} else {
				let zero_time = local_TimeUtil.GetFutureZeroStamp(1)
				let start_time = zero_time - model.outTime
				let time = start_time - local_TimeUtil.getServerTime()
				let url = "距下次系统重置:&nbsp;&nbsp;" + local_TimeUtil.timeConvert(time, "hh-mm-ss")
				this._lb_time.innerHTML = Util.StrToHTML(url)
			}
			this._lb_time.x = this._Group2.width / 2 - this._lb_time.contextWidth / 2
			this._lb_time.y = this._Group2.height / 2 - this._lb_time.contextHeight / 2
		}

		this.ClearTimeOutID = () => {
			if (this.timeout_id) {
				clearTimeout(this.timeout_id)
				this.timeout_id = null
			}
		}

		this.DeleteMeFunc = () => {
			if (this.time_id) {
				clearTimeout(this.time_id)
				this.time_id = null
			}
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null
			}
			if (id_list_.length > 0) {
				for (let _tmpi in id_list_) {
					var id = id_list_[_tmpi]
					clearTimeout(id)
				}
			}
			if (uirole_) {
				//UIScene:GetInstance():ClearUIScene()
			}
			model.is_request_42702 = false
			if (re_pro_list_.length > 0) {
				for (let _tmpi in re_pro_list_) {
					var item = re_pro_list_[_tmpi]
					item.DeleteMe()
				}
				re_pro_list_ = []
			}
			if (re_box_pro_list_.length > 0) {
				for (let _tmpi in re_box_pro_list_) {
					var item = re_box_pro_list_[_tmpi]
					item.DeleteMe()
				}
				re_box_pro_list_ = []
			}
			if (box_item_list_.length > 0) {
				for (let _tmpi in box_item_list_) {
					var item = box_item_list_[_tmpi]
					item.DeleteMe()
				}
				box_item_list_ = []
			}
			this.ClearTimeOutID()
			this.update_time = 1
			if (this.runer_id) {
				Runner.GetInstance().RemoveRunObj(this.runer_id)
				this.runer_id = null
			}
			super.DeleteMe()
		}

	}

	public DeleteMe() {

		this.DeleteMeFunc()
	}

	_img_bg: Laya.Image
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_Image3: Laya.Image
	_gp_cost: Laya.Box
	_lb_cost_num: Laya.HTMLDivElement
	_img_cost_icon: Laya.Image
	_Group1: Laya.HBox
	_lb_ref_num: Laya.HTMLDivElement
	_lb_vip: Laya.HTMLDivElement
	_Image4: Laya.Image
	_img_extro_1: Laya.Image
	_img_extro_2: Laya.Image
	_lb_tik: Laya.Label
	_lb_tik_desc: Laya.Label
	_img_shop: Laya.Image
	_img_suit: Laya.Image
	_gp_box_re_pro: Laya.HBox
	_gp_box: Laya.Box
	_gp_pos: Laya.Box
	_gp_role: Laya.Box
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_gp_num: Laya.Box
	_img_num: Laya.Image
	_gp_crit: Laya.Box
	_red: Laya.Image
	_Image5: Laya.Image
	_Label1: Laya.Label
	_img_shop_red: Laya.Image
	_Group2: Laya.Box
	_lb_time: Laya.HTMLDivElement
	_box_halo: Laya.Box
    _img_merge_count: Laya.Image
    _lb_halo_tips: Laya.Label
	_img_ad: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._Image11,
			this._Image2,
			this._Scroller1,
			this.Content,
			this._Image3,
			this._gp_cost,
			this._lb_cost_num,
			this._img_cost_icon,
			this._Group1,
			this._lb_ref_num,
			this._lb_vip,
			this._Image4,
			this._img_extro_1,
			this._img_extro_2,
			this._lb_tik,
			this._lb_tik_desc,
			this._img_shop,
			this._img_suit,
			this._gp_box_re_pro,
			this._gp_box,
			this._gp_pos,
			this._gp_role,
			this._btn,
			this._Image1,
			this.labelDisplay,
			this._gp_num,
			this._img_num,
			this._gp_crit,
			this._red,
			this._Image5,
			this._Label1,
			this._img_shop_red,
			this._Group2,
			this._lb_time,
			this._box_halo,
            this._img_merge_count,
            this._lb_halo_tips,
			this._img_ad,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image11",
				"_Image2",
				"_Scroller1",
				"Content",
				"_Image3",
				"_gp_cost",
				"_lb_cost_num",
				"_img_cost_icon",
				"_Group1",
				"_lb_ref_num",
				"_lb_vip",
				"_Image4",
				"_img_extro_1",
				"_img_extro_2",
				"_lb_tik",
				"_lb_tik_desc",
				"_img_shop",
				"_img_suit",
				"_gp_box_re_pro",
				"_gp_box",
				"_gp_pos",
				"_gp_role",
				"_btn",
				"_Image1",
				"labelDisplay",
				"_gp_num",
				"_img_num",
				"_gp_crit",
				"_red",
				"_Image5",
				"_Label1",
				"_img_shop_red",
				"_Group2",
				"_lb_time",
				"_box_halo",
                "_img_merge_count",
                "_lb_halo_tips",
				"_img_ad",
			])
	}
}
window["AdventureMainView"] = AdventureMainView