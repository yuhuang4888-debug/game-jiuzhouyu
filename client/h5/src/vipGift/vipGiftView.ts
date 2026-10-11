import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MarriageTagShowItem } from "../marriage/MarriageTagShowItem"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { FRAME_TYPE, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, SetSizeDeltaX, SetAnchoredPositionY } from "../util/Util"
import { vipGiftGradeBtn } from "./vipGiftGradeBtn"

export class vipGiftView extends BaseItem1 {
	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_img_mask: Laya.Image
	_scr_btn: Laya.List
	_gp_effect: Laya.Box
	_gp_model: Laya.Box
	_img_model: Laya.Image
	_img_8: Laya.Image
	_Scroller1: Laya.Panel
	_gp_reward: Laya.HBox
	_gp_fight_fire: Laya.Box
	_img_fight: Laya.Image
	_gp_fight: Laya.Box
	_img_fight_down: Laya.Image
	_Group2: Laya.HBox
	_bit_fight: Laya.Label
	_Image2: Laya.Image
	_img_bg_0: Laya.Image
	_Group3: Laya.HBox
	_Label1: Laya.Label
	_img_jin: Laya.Image
	_lb_price: Laya.Label
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_gp_num_1: Laya.Image
	_mask_1: Laya.Box
	_num_1: Laya.Label
	_num_5: Laya.Label
	_gp_num_2: Laya.Image
	_mask_2: Laya.Box
	_num_2: Laya.Label
	_num_6: Laya.Label
	_gp_num_3: Laya.Image
	_mask_3: Laya.Box
	_num_3: Laya.Label
	_num_7: Laya.Label
	_gp_num_4: Laya.Image
	_mask_4: Laya.Box
	_num_4: Laya.Label
	_num_8: Laya.Label
	_btn: Laya.Box
	_Imgae12: Laya.Image
	_lb_btn: Laya.Label
	_img_red: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_gp_time: Laya.Box
	_img_price_desc: Laya.Image
	_lb_price_desc: Laya.HTMLDivElement
	_img_return: Laya.Box
	_gp_num_5: Laya.Image
	_gp_num_6: Laya.Image
	_gp_num_7: Laya.Image
	_gp_num_8: Laya.Image
	_img_btn_list_red: Laya.Image
	ClearModel
	CustomMehod
	Emp_btn
	InitBtnList
	InitEvent
	InitGradeBtn
	InitView
	Local_DeleteMe
	Out_lb_btn
	RefBtn
	RefReward
	Scr_Scroller1
	Scr_scr_btn
	ShowCurGrade
	ShowModel
	ShowNowGold
	Update
	_Viewport1
	_soureArr
	custom_sorting_order
	initDic
	initShowNum
	randomNum
	reSet
	resetImg
	show_type
	update_id
	cur_sorting_order = null
	runner_id
	select_tab=0
	refreshRed
	red_tween_id
	public constructor(parent?) {
		super(parent)


		this.base_file = "vipGift"
		this.layout_file = "vipGiftView"
		this.layer_value = Enum_UILayer.UI

		this._soureArr = null
		this.show_type = null
		this.update_id = false
		let model = CustomActivityModel.GetInstance()
		let local_Event = CustomActivityDefine.EVENT
		let local_RoleManager = RoleManager.GetInstance()
		let timer_item = null
		let rewardItem_list = []
		let uiModel = null
		let info = null
		let data = null
		let b = null
		let s = null
		let cur_grade_data = null
		let btn_list = []
		let img_model_y = 0
		let default_select = null
		let tween_id = null
		let local_Number = Number
		let local_GlobalEventSystem = GlobalEventSystem
		let OPEN_ACT_VIEW = EventName.OPEN_ACT_VIEW
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_Message = Message
		let runner = Runner.GetInstance()

		//转动动画的参数
		let speedDic = []//记录每列的速度
		let slowSpeedDic = []//记录计算每列的减速需要减去的速度
		let roundDic = []//记录每列的圈数
		let roundMax = [7, 6, 5, 4, 7, 6, 5, 4]//最大圈数
		let slowRound = 4//开始减速的圈数
		let numList = ["?", "?", "?", "?"]
		let stopNum = 0//停止的个数
		let stopID = []
		let minSpeed = 30//最小速度（重置位置减去展示位置的倍数）
		let maxSpeed = 50//最大速度
		let mask_y = 0
		let mask_h = 759


		this.load_callback = () => {


			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_price_desc.lineSpacing = 0.8
			// }
			// this.custom_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.RegisterMask(this._Viewport1)
			this.InitEvent()
			this.InitView()
		}

		let reward_sort = (a?, b?) => {
			return a.grade < b.grade
		}

		let require_dis = () => {
			if (!data) {
				return null
			}
			if (model.act_key_dic[b] && model.act_key_dic[b][s]) {
				return model.act_key_dic[b][s]["require_dis"]
			}
			return null
		}

		let buy_ing = () => {
			if (!data) {
				return null
			}
			if (model.act_key_dic[b] && model.act_key_dic[b][s]) {
				return model.act_key_dic[b][s]["buy_ing"]
			}
			return null
		}

		this.InitEvent = () => {

			Util.AddClickEvent(this._img_return,()=>{
				model.Fire(CustomActivityModel.CLOSE_VIPGIFT_VIEW)
			},this)
			let updata_view = (...new_args) => {
				let args = new_args
				if (args[1] == b && args[2] == s) {
					data = model.GetActData(b, s)
					if (!data) {
						return
					}
					if (data.reward_list) {
						table.sort(data.reward_list, reward_sort)
					}
					//let x = this._scr_btn.viewport.scrollH || 0
					this.InitBtnList()
					this.InitGradeBtn()
					this.ShowCurGrade()
					//this._scr_btn.validateNow()
					//this._scr_btn.viewport.scrollH = x
				}
			}
			this.BindEvent(model, local_Event.UPDATE_VIEW, updata_view)

			this.BindEvent(model, local_Event.ANSWER_TARGET, (...new_args) => {
				if (!info) {
					return
				}
				let args = new_args
				if (b == args[0] && s == args[1] && args[3]) {
					this.initDic("buy_ing", false)
					let reward = model.GetActReward(b, s, args[3].form_type, args[3].reward)
					if (reward) {
						let view = new CongratulationObtainView(reward, 10)
						view.Open()

						let fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(reward)
						CustomActivityModel.GetInstance().ShowActFlyReward(fly_list,this._btn)
					}
					data = model.GetActData(b, s)
					if (!data) {
						return
					}
					if (data.reward_list) {
						table.sort(data.reward_list, reward_sort)
					}
					cur_grade_data = data.reward_list && data.reward_list[this._scr_btn.selectedIndex]
					this.RefBtn()
					this._soureArr.replaceAll(btn_list)
				}
			}
			)
			Util.AddClickEvent(this._btn, () => {
				if (require_dis() || buy_ing()) {
					local_Message.show("点击过快")
					return
				}
				let limit_click = () => {
					let cur_grade = data.reward_list && data.reward_list[this._scr_btn.selectedIndex]
					if (cur_grade) {
						let cond = model.GetActCondition(b, s, "data", cur_grade.grade)
						if (cond) {
							let vip_level = local_RoleManager.mainRoleInfo.vip_flag
							if (vip_level < local_Number(cond.vip)) {
								//let act_type = 68
								let jump_id = local_Number(cond.vip) <= 4 && 8 || 60
								let str = "VIP" + cond.vip + "即可购买，是否前往提升？"
								local_Alert.Show(str, local_Alert_Type.Two, () => {
									OpenFun.OpenFunHandler(jump_id,0)
									//if (jump_id != act_type ) {
									//OpenFun.OpenFunHandler(jump_id)
									//}else{
									//let list = model.cache_scmd_33101_list
									//if (! list || ! list.length ) {
									//return true
									//}
									//for (let _tmpi in list) {
									// var v = list[_tmpi]
									//if (v.base_type == jump_id ) {
									//arg = v.sub_type
									//break
									//}
									//}
									//let icon_type, act_type, show_id = model.GetActIconType(jump_id, arg, true)
									//if (icon_type ) {
									//if (act_type ) {
									//local_GlobalEventSystem:Fire(OPEN_ACT_VIEW, icon_type, act_type, show_id)
									//}else{
									//local_GlobalEventSystem:Fire(OPEN_ACT_VIEW, icon_type)
									//}
									//}
									//}
								}
								)
								return true
							}
						}
					}
				}

				if (cur_grade_data && cur_grade_data.status == 0) {
					if (!require_dis()) {
						this.initDic("require_dis", true)
						model.Fire(local_Event.SCMD_REQUEST, 33215, b, s, cur_grade_data.grade)
					}
				} else if (cur_grade_data && cur_grade_data.status == 1) {
					if (limit_click()) {
						return
					}
					let cond = model.GetActCondition(b, s, "data", cur_grade_data.grade)
					if (cond && cond.now_cost) {
						let cost = cond.now_cost[0]
						if (!cost) {
							return
						}
						let role = local_RoleManager.mainRoleInfo
						let type = local_Number(cost[0])
						let name = type == 1 && "勾玉" || "绑玉"
						let have_jin = type == 1 && role.jin || role.jin + role.jinLock
						let str = "是否消耗<font color='#0a953e'>" + cost[2] + name + "</font>抢购<font color='#0a953e'>" + cur_grade_data.name + "</font>"
						let openAlert = model.getKeyDicValue(b, s, "openAlert")
						let require = () => {
							this.initDic("buy_ing", true)
							model.RequireGetAward(b, s, cur_grade_data.grade)
						}
						let ok_func = () => {
							if (openAlert) {
								model.setKeyDicValue(b, s, "openAlert", openAlert)
							}
							if (have_jin < local_Number(cost[2])) {
								local_Alert.Show("勾玉不足，是否前往充值", local_Alert_Type.Two, () => {
									OpenFun.OpenFunHandler(21)
								}
								)
							} else {
								require()
							}
						}

						let check_func = () => {
							openAlert = !openAlert
						}

						if (openAlert) {
							ok_func()
						} else {
							local_Alert.Show(str, local_Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_func)
						}
					}
				} else if (cur_grade_data && cur_grade_data.status == 2) {
					local_Message.show("已购买")
				}
			}
				, this, true)

			this.BindEvent(model, local_Event.RECEIVE_SUCCESS, (scmd?) => {
				if (scmd && scmd.base_type == b && scmd.sub_type == s
					&& cur_grade_data && scmd.grade == cur_grade_data.grade) {
					if (scmd.now_cost && scmd.now_cost[0]) {
						numList = this.initShowNum(scmd.now_cost[0].count)
						if (!this.update_id) {
							this.runner_id = runner.AddRunObj(this, 1,FRAME_TYPE.total)
							this.update_id = true
						}
					}
				}
			}
			)

			this.BindEvent(local_RoleManager.GetMainRoleVo(), "vip_flag", () => {
				this.InitBtnList()
				if (this._soureArr) {
					this._soureArr.replaceAll(btn_list)
				}
			}
			)

			if (this._img_btn_list_red) {
				this.red_tween_id = SYTweenLite.to(this, this._img_btn_list_red, SYTweenLite.UiAnimationType.SCALE, { x: 0.8, y: 0.8 }, 1, null, SYTweenFunc.PINGPONG, true)
			}
		}

		this.initDic = (key?, bool?) => {
			if (!data) {
				return
			}
			model.act_key_dic[b] = model.act_key_dic[b] || {}
			model.act_key_dic[b][s] = model.act_key_dic[b][s] || {}
			model.act_key_dic[b][s][key] = bool
		}

		this.refreshRed = (btn_list, _list_tab_con) => {
			let bool = false
			if (_list_tab_con.scrollBar) {
				let value = _list_tab_con.scrollBar.value
				let item_width = 150
				let length
				for (let index in btn_list) {
					let tab = btn_list[index]
					if (tab && tab.status == 0) {
						length = item_width * (Number(index) + 1) - _list_tab_con._width - 20 // 20 计算向左的偏移量
						if (length > value) {
							bool = true
							break
						}
					}
				}
			}
			if (this._img_btn_list_red){
				this._img_btn_list_red.visible = bool
			}
		}

		this.InitView = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpgOtherPath("vipGift", "uihd_008"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mask, GameResPath.GetIcon("common", "uity_005"), true)
			ResManager.GetInstance().SetTexture(this, this._img_8, GameResPath.GetIcon("vipGift", "ui_vip_thlb006"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image9, GameResPath.GetIconOtherPath("vipGift", "ui_vip_thlb001"))
			let effect_data = {
				custom_sorting_order: this.custom_sorting_order
			}
			this.AddUIEffect("UI_1201", this.layer_value, this._gp_effect, null, { x: 1, y: 0.5 }, true, effect_data)

			if (!info) {
				return
			}
			b = info.base_type
			s = info.sub_type
			model.CloseACTRed(b, s)
			data = model.GetActData(b, s)
			timer_item = model.LoadActTimer(this._gp_time, info.etime, 20,"#2cff40", null, "#ffffff", "活动剩余时间：")
			if (!data) {
				return
			}
			this.initDic("buy_ing", false)
			this.initDic("require_dis", false)
			if (data.reward_list) {
				table.sort(data.reward_list, reward_sort)
			}
			this.InitBtnList(true)
			// this.refreshRed(btn_list, this._scr_btn)
			this.InitGradeBtn()
			this.ShowCurGrade()

			//展示大图动画
			tween_id = SYTweenLite.to(this, this._img_model, SYTweenLite.UiAnimationType.ANCHORED_POSY, 220, 2.5, null, SYTweenFunc.PINGPONG, true)
		}

		//刷新展示选中礼包的全部内容
		this.ShowCurGrade = () => {
			if (!data) {
				return
			}
			let cur_grade = data.reward_list && data.reward_list[this._scr_btn.selectedIndex]
			if (cur_grade) {
				cur_grade_data = cur_grade
				this.RefReward(cur_grade)
				let cond = model.GetActCondition(b, s, "data", cur_grade.grade)
				if (cond) {
					let fight = cond.fighting
					if (fight && fight.length > 0) {
						let type = fight[0][0]
						this._img_fight.visible = type == "1"
						this._gp_fight.visible = type == "0"
						this.ClearUIEffect(this._gp_fight_fire)
						if (type == "1") {
							ResManager.GetInstance().SetImageSprite(this, this._img_fight, "vipGift_asset", fight[0][1], true)
							//this:AddUIEffect("ui_Warfareflame_10", this.layer_value, this._gp_fight_fire, null, {x=1.3, y=1.3}, true, {custom_sorting_order = this.custom_sorting_order})
						} else {
							this._bit_fight.text = "ay" + fight[0][1]
						}
					}
					this.ClearModel()
					if (cond.show_icon && cond.show_icon[0]) {
						this.show_type = 1
						ResManager.GetInstance().SetImageSpriteTrans(this, this._img_model, "resource/game/vipGift/texture/" + cond.show_icon[0][1] + ".png")
					}
					if (cond.show_model && cond.show_model[0]) {
						this.show_type = 2
						this.ShowModel(cond.show_model[0][1])
					}
					if (cond.show_effect && cond.show_effect[0]) {
						this.show_type = 3
						this.AddUIEffect(cond.show_effect[0][1], this.layer_value, this._gp_model, null, null, true, { custom_sorting_order: this.custom_sorting_order })
					}
					if (cond.gold && cond.gold[0]) {
						let jin_url = local_Number(cond.gold[0][0]) == 1 && "com_diamond" || "com_bind_diamond"
						ResManager.GetInstance().SetImageSprite(this, this._img_jin, "common_asset", jin_url)
						this._lb_price.text = cond.gold[0][2]
						// LayoutRebuilder(this._Group3)
					}
					if (cur_grade.desc) {
						this._lb_title.text = cur_grade.desc
					}
					this.ShowNowGold()
					this.RefBtn()
				}
			}
		}

		//展示下方的价格信息
		this.ShowNowGold = () => {
			let cur_grade = cur_grade_data
			if (!cur_grade) {
				return
			}
			let cond = model.GetActCondition(b, s, "data", cur_grade.grade)
			if (!cond) {
				return
			}
			this._lb_price_desc.width = 160
			let price_bool = cur_grade.status > 0
			this._lb_price_desc.visible = price_bool
			this._img_price_desc.visible = price_bool
			if (cond.now_cost && cond.now_cost[0] && cur_grade.status > 0 && cond.gold && cond.gold[0]) {
				let _type = local_Number(cond.now_cost[0][0])
				let now_cost = local_Number(cond.now_cost[0][2])
				let name = (_type == 1 && "勾玉" || "绑玉")
				let left_jin = local_Number(cond.gold[0][2]) - now_cost
				let precent = 100
				if (cond.discount) {
					for (let i in cond.discount) {

						let dis = cond.discount[i]
						if (dis[0] && dis[0][0] && Number(dis[0][0][2]) == now_cost) {
							precent = dis[3]
							break
						}
					}
				}
				this._lb_price_desc.innerHTML = Util.StrToHTML("立减<font color='#cf4702'>" + left_jin + name + "</font>,超过了<font color='#cf4702'>" + precent + "%</font>的玩家!"
				)

				let num_list = this.initShowNum(now_cost)
				let index  = 0
				for (let i in num_list) {

					if (this["_gp_num_" + local_Number(index+1)]) {
						// this["_num_" + local_Number(i+1)].text = num_list[i]
						this["_gp_num_"+(index+1)].skin=GameResPath.GetIcon("vipGift","ui_vipsz_"+num_list[i])
					}
					++index
				}

			} else if (cur_grade.status == 0) {
				let num_list = ["?", "?", "?", "?"]
				let index=0
				for (let i in num_list) {
					if (this["_gp_num_" + (local_Number(i)+1)]) {
						this["_gp_num_"+(index+1)].skin=GameResPath.GetIcon("vipGift","ui_vipsz")

					}
					++index
				}
			}
		}

		//按钮状态
		this.RefBtn = () => {
			let cur_grade = cur_grade_data
			if (!cur_grade) {
				return
			}
			let str = ""
			if (cur_grade.status == 0) {
				str = "获取折扣"
				this._btn.gray=false
			} else if (cur_grade.status == 1) {
				str = "购买"
				this._btn.gray=false
			} else {
				str = "已购买"
				this._btn.gray=true
			}
			this._lb_btn.text = str
			let role_vip = local_RoleManager.mainRoleInfo.vip_flag
			let cond = model.GetActCondition(b, s, "data", cur_grade.grade)
			if (cond && cond.vip != null) {
				this._img_red.visible = cur_grade.status == 0
			}
		}

		//展示大奖（模型）
		this.ShowModel = (model_id?) => {
			model.ShowViewModel(this, "vipGiftView", model_id, this._gp_model, null, null, this.cur_sorting_order)
		}

		//创建奖励
		this.RefReward = (cur_info?) => {
			if (!cur_info) {
				return
			}

			let reward = model.GetActReward(b, s, cur_info.form_type, cur_info.reward)
			for (let i in reward) {

				let item = rewardItem_list[i]
				if (!item) {
					item = new EquipmentItem(this._gp_reward)
					// item.SetMaskId(1)
					item.SetItemSize(76, 76)
					item.Load()
					table.insert(rewardItem_list, item)
				}
				item.ExcuteCallback(() => {
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[i][0], reward[i][1])
					item.SetData(type_id, reward[i][2], lock)
					if (!item.GetVisible()) {
						item.SetVisible(true)
					}
				}
				)
			}
			for (let i = reward.length + 1; i <= rewardItem_list.length; i++) {
				let item = rewardItem_list[i]
				if (item.GetVisible()) {
					item.SetVisible(false)
				}
			}

			if (reward) {
				let layout = this._gp_reward//.GetComponent("UnityEngine.UI.HorizontalLayoutGroup")
				let spacing = reward.length < 6 && 20 || 6
				layout.space = spacing
				let content_size = (100 + spacing) * reward.length - spacing
				if (content_size > 581) {
					SetSizeDeltaX(this._gp_reward, content_size)
				}
			}
		}

		//vip礼包列表信息
		this.InitBtnList = (is_first?) => {
			if (!data || !data.reward_list) {
				return
			}
			let role_vip = local_RoleManager.mainRoleInfo.vip_flag
			let limit_vip = role_vip < 4 && 4 || role_vip+1
			btn_list = []
			let _select = null
			for (let i in data.reward_list) {

				let v = data.reward_list[i]
				if (v) {
					let cond = model.GetActCondition(b, s, "data", v.grade)
					if (cond && cond.vip != null) {
						if (local_Number(cond.vip) <= limit_vip) {
							table.insert(btn_list, v)
						}
					}
					if (is_first && _select == null && v.status != 2) {
						_select = local_Number(i)
					}
				}
			}
			default_select = _select || 0
		}

		//vip礼包列表按钮
		this.InitGradeBtn = () => {
			if (!btn_list || btn_list.length == 0) {
				return
			}
			if (!this._soureArr) {
				this._soureArr = new LoopScrowViewMgr()
				this._soureArr.SetData(this._scr_btn, vipGiftGradeBtn, btn_list, LoopScrCon.Horizontal, 1, (item?) => {})
				this._scr_btn.mouseEnabled=true
				this._scr_btn.mouseHandler=new Laya.Handler(this,(e?)=>{
					if(e.type==Laya.Event.CLICK)
					if (require_dis()) {
						this._soureArr.SetSelectIndex(cur_grade_data.grade, false)
						local_Message.show("正在抽取特惠价格")
						this._scr_btn.selectedIndex=this.select_tab
						return
					} else if (buy_ing()) {
						this._soureArr.SetSelectIndex(cur_grade_data.grade, false)
						local_Message.show("正在购买礼包")
						this._scr_btn.selectedIndex=this.select_tab
						return
					}
					this.select_tab=this._scr_btn.selectedIndex
					this.ShowCurGrade()
				})
			}

			// if (cur_grade_data) {
			// 	this._soureArr.SetSelectIndex(cur_grade_data.grade-1, false)
			// } else {
				if (default_select > 4) {
					this._soureArr.FirstOnChild(default_select)
					//this._scr_btn.viewport.scrollH = (default_select - 4) * vipGiftGradeBtn.width
				}
				this._soureArr.SetSelectIndex(default_select, false)
				this._scr_btn.scrollTo(default_select)
			// }
			let func = () => {
				this.refreshRed(btn_list, this._scr_btn)
			}
			this._scr_btn.scrollBar.on(Laya.Event.CHANGE, this, func)
			this.refreshRed(btn_list, this._scr_btn)
		}

		//清楚展示大奖（切换礼包时用）
		this.ClearModel = () => {
			if (this.show_type == 1) {
				ResManager.GetInstance().SetImageSprite(this, this._img_model, "common_asset", "com_empty")
			} else if (this.show_type == 2) {
				this._gp_model.visible = false
				// ResManager.GetInstance().ClearPartModel(this, this._gp_model)
			} else if (this.show_type == 3) {
				this.ClearUIEffect(this._gp_model)
			}

		}

		this.Local_DeleteMe = () => {
			if (timer_item) {
				timer_item.DeleteMe()
				timer_item = null
			}

			if (rewardItem_list && rewardItem_list.length > 0) {
				for (let k in rewardItem_list) {
					var item = rewardItem_list[k]
					item.DeleteMe()
				}
				rewardItem_list = []
			}

			if (this._soureArr) {
				this._soureArr.DeleteMe()
				this._soureArr = null
			}

			if (tween_id) {
				SYTweenLite.Stop(tween_id)
				tween_id = null
			}

			if(this.red_tween_id){
				SYTweenLite.Stop(this.red_tween_id)
				this.red_tween_id = null
			}

			runner.RemoveRunObj(this.runner_id)
			this.update_id = false
			super.DeleteMe()


		}

		this.CustomMehod = (index?, args?) => {
			info = args && args[index]
		}

		//转动动画
		this.randomNum = () => {
			let blabel = null
			let num = null
			let num2=null
			let mask = null
			let speed = null
			let index = null
			let round = null
			let lastRound = null

			for (let i = 1; i <= 8; i++) {
				blabel = this["_gp_num_" + i]
				let blabel_y = blabel.y
				let blabel_h = 7
				index = i > 4 && (i - 4) || i
				speed = speedDic[index]
				round = roundDic[index]
				if (round == null) {
					round = 0
				}
				lastRound = (roundMax[i-1] - round) == 0
				if (speed == null) {
					speed =Mathf.Floor(Mathf.Random() * 10 + maxSpeed)
					speedDic[index] = speed
					slowSpeedDic[index] = (speed - minSpeed) / slowRound
				}
				//当前列的最后一圈
				if (lastRound) {
					if (blabel_y >= 7 && speed != 0 && i > 4) {
						SetAnchoredPositionY(blabel, 7)
						speed = 0
						speedDic[index] = 0
						stopNum = stopNum + 1
						this.resetImg(i)
						if (stopNum == 4) {
							this.initDic("require_dis", false)
							cur_grade_data.status = 1
							this.RefBtn()
							this._soureArr.replaceAll(btn_list)
							this.ShowNowGold()
							this.reSet()
							this.resetImg()
							if (this.update_id) {
								runner.RemoveRunObj(this.runner_id)
								this.update_id = false
							}
							break
						}
						break
					}
				}
				let refresh_num=(num1?,num2?)=>{
					if(num2==null){
						if(num==num1){
							num = Mathf.Floor(Mathf.Random() * 10)
							refresh_num(num1,num2)
						}
					}else{
						if(num==num1 || num==num2 ){
							num = Mathf.Floor(Mathf.Random() * 10)
							refresh_num(num1,num2)
						}
					}
				}
				//位置计算，超过界限要设回在下面，循环动画
				blabel_y = blabel_y + speed
				if (blabel_y  >= 134) {
					num = Mathf.Floor(Mathf.Random() * 10)
					if (i > 4 && speed != 0) {
						round = round + 1
						roundDic[index] = round
						let listRound = roundMax[i-1] - round
						if (listRound <= slowRound) {
							if (listRound > 0) {
								speed = speed - slowSpeedDic[index]
							} else if (listRound == 0) {
								speed = minSpeed
								if(index==1){
									num=numList["_a"]
								}else if(index==2){
									num=numList["_b"]
								}else if(index==3){
									num=numList["_c"]
								}else if(index==4){
									num=numList["_d"]
								}
								// num = numList[index]
							}else if(listRound==1){
								if(index==1){
									num2=numList["_a"]
								}else if(index==2){
									num2=numList["_b"]
								}else if(index==3){
									num2=numList["_c"]
								}else if(index==4){
									num2=numList["_d"]
								}
							}
							speedDic[index] = speed
						}	
					}
					if(i>4){
						refresh_num( Number(this["_gp_num_" + (i-4)].text),num2) // blabel_y=this["_gp_num_" + (i-4)].y-134
					}else{
						refresh_num(Number(this["_gp_num_" + (i+4)].text),num2)
					}
					this["_gp_num_" + i].skin =GameResPath.GetIcon("vipGift","ui_vipsz_"+num) 
					if(i>4){
						blabel_y=this["_gp_num_" + (i-4)].y-134
					}else{
						blabel_y=this["_gp_num_" + (i+4)].y-134
					}
					// blabel_y =-120// blabel_h
				}
				SetAnchoredPositionY(blabel, blabel_y)
			}
		}

		//重置位置(每列转完和全部转完时)
		this.resetImg = (i?) => {
			let blabel = null
			//单列重置
			if (i != null) {
				blabel = this["_gp_num_" + ((i ))]
				SetAnchoredPositionY(blabel, 7)
				return
			}

			//全重置
			for (let i = 1; i <= 8; i++) {
				blabel = this["_gp_num_" + i]
				if (i > 4) {
					SetAnchoredPositionY(blabel, 134)
				} else {
					let num
					if(i==1){
						num=numList["_a"]
					}else if(i==2){
						num=numList["_b"]
					}else if(i==3){
						num=numList["_c"]
					}else if(i==4){
						num=numList["_d"]
					}
					this["_gp_num_" + i].skin = GameResPath.GetIcon("vipGift","ui_vipsz_" + num)// numList[i]
					SetAnchoredPositionY(blabel, 7)
				}
			}

		}

		//动画记录数据重置
		this.reSet = () => {
			speedDic = []
			roundDic = []
			slowSpeedDic = []
			stopNum = 0
		}

		this.initShowNum = (cost?) => {
			let _cost = local_Number(cost)
			let _a = Mathf.Floor(_cost / 1000)
			_cost = _cost - (_a * 1000)
			let _b = Mathf.Floor(_cost / 100)
			_cost = _cost - (_b * 100)
			let _c = Mathf.Floor(_cost / 10)
			let _d = _cost - (_c * 10)
			return { _a, _b, _c, _d }
		}

		this.Update = () => {
			this.randomNum()
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this._lb_title,
			this._img_mask,
			this._scr_btn,
			this._gp_effect,
			this._gp_model,
			this._img_model,
			this._img_8,
			this._Scroller1,
			this._gp_reward,
			this._gp_fight_fire,
			this._img_fight,
			this._gp_fight,
			this._img_fight_down,
			this._Group2,
			this._bit_fight,
			this._Image2,
			this._img_bg_0,
			this._Group3,
			this._Label1,
			this._img_jin,
			this._lb_price,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._gp_num_1,
			this._mask_1,
			this._num_1,
			this._num_5,
			this._gp_num_2,
			this._mask_2,
			this._num_2,
			this._num_6,
			this._gp_num_3,
			this._mask_3,
			this._num_3,
			this._num_7,
			this._gp_num_4,
			this._mask_4,
			this._num_4,
			this._num_8,
			this._btn,
			this._Imgae12,
			this._lb_btn,
			this._img_red,
			this._Image8,
			this._Image9,
			this._Image10,
			this._gp_time,
			this._img_price_desc,
			this._lb_price_desc,
			this._img_return,
			this._gp_num_5,
			this._gp_num_6,
			this._gp_num_7,
			this._gp_num_8,
			this._img_btn_list_red
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_title",
				"_img_mask",
				"_scr_btn",
				"_gp_effect",
				"_gp_model",
				"_img_model",
				"_img_8",
				"_Scroller1",
				"_gp_reward",
				"_gp_fight_fire",
				"_img_fight",
				"_gp_fight",
				"_img_fight_down",
				"_Group2",
				"_bit_fight",
				"_Image2",
				"_img_bg_0",
				"_Group3",
				"_Label1",
				"_img_jin",
				"_lb_price",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_gp_num_1",
				"_mask_1",
				"_num_1",
				"_num_5",
				"_gp_num_2",
				"_mask_2",
				"_num_2",
				"_num_6",
				"_gp_num_3",
				"_mask_3",
				"_num_3",
				"_num_7",
				"_gp_num_4",
				"_mask_4",
				"_num_4",
				"_num_8",
				"_btn",
				"_Imgae12",
				"_lb_btn",
				"_img_red",
				"_Image8",
				"_Image9",
				"_Image10",
				"_gp_time",
				"_img_price_desc",
				"_lb_price_desc",
				"_img_return",
				"_gp_num_5",
				"_gp_num_6",
				"_gp_num_7",
				"_gp_num_8",
				"_img_btn_list_red"
			])
		this._lb_price_desc.style.fontSize = 20
		this._lb_price_desc.style.color = "#631818"
		this._lb_price_desc.y=230
		this._lb_price_desc.style.leading = 5
		this._lb_price_desc.style.align="center"
		this._lb_price_desc.style.valign="middle"
		this._Scroller1.hScrollBar.visible = false
	}
}
window["vipGiftView"] = vipGiftView