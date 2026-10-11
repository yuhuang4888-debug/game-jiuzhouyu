import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { NotEnougnDiamond, SetAnchoredPosition, SetSizeDelta, Trim, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { AccumItem } from "./AccumItem"
import { PoolItem } from "./PoolItem"

export class OptionalLottoView extends BaseItem1 {
	_img_bg: Laya.Image
	_img_0: Laya.Image
	_img_1: Laya.Image
	_Scroller1: Laya.Panel
	_gp_show: Laya.Box
	_gp_pool: Laya.Box
	_btn_select: Laya.Box
	_img_select: Laya.Image
	_lb_select: Laya.Label
	_Scroller3: Laya.Panel
	_Viewport3: Laya.Box
	_img_progress: Laya.Image
	_gp_reward: Laya.VBox
	_btn_ref: Laya.Box
	_img_ref: Laya.Image
	_lb_ref: Laya.Label
	_btn_draw: Laya.Box
	_img_draw: Laya.Image
	_lb_draw: Laya.Label
	_btn_reset: Laya.Box
	_img_reset: Laya.Image
	_lb_reset: Laya.Label
	_gp_cost: Laya.HBox
	_img_cost: Laya.Image
	_lb_cost: Laya.Label
	_lb_reset_num: Laya.HTMLDivElement
	_gp_time: Laya.Box
	_lb_desc: Laya.HTMLDivElement
	_Image1: Laya.Image
	_lb_count: Laya.Label
	_Image2: Laya.Image
	_Image3: Laya.Image
	_img_cheap_time: Laya.Image
	_gp_effect: Laya.Box
	Anim_Callback
	CreatePoolItem
	CustomMehod
	InitEvent
	InitGradeDic
	InitShowReward
	InitView
	Local_DeleteMe
	OpenCongra
	RefAccumItem
	RefDrawBtn
	RefResetBtn
	Update
	_Viewport1
	custom_sorting_order

	public constructor(parent?) {
		super(parent)

		this.base_file = "optionalLotto"
		this.layout_file = "OptionalLottoView"
		this.layer_value = Enum_UILayer.UI

		let model = CustomActivityModel.GetInstance()
		let local_Event = CustomActivityDefine.EVENT
		let local_GoodsModel = GoodsModel.GetInstance()
		let timer = null
		let info = null
		let data = null
		let b = null
		let s = null
		let pool_dic = []
		let accum_dic = []
		let poolItem_list = []
		let showItem_list = []
		let accumItem_list = []
		let draw_cost = null
		let reset_cost = null
		let update_id = false
		let draw_answer = null
		let reset_count = 0
		let random_reward = false
		let local_Message = Message
		let local_Number = Number
		let role_mgr = RoleManager.GetInstance()
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let runner = Runner.GetInstance()


		let play_show_anim = true		//奖励展示滚动动画
		let play_draw_anim = false	//抽奖动画
		let show_item_size = 85		//展示奖励的size
		let pool_grade = []			//还没抽中的列表
		let start_speend = 6			//初始速度
		let speend = 6				//当前速度
		let frames = 0				//动画时的帧数记录
		let last_index = null			//避免两次随机相同
		let play_count = 0			//当前变换次数
		let all_count = 10			//总变换次数
		let speend_count = 7			//第几次变换时要改变速度
		let paopaopos = [{ x: 30, y: 80 }, { x: 200, y: 50 }, { x: 370, y: 80 }, { x: 30, y: 250 }, { x: 200, y: 220 }, { x: 370, y: 250 }, { x: 30, y: 410 }, { x: 200, y: 380 }, { x: 370, y: 410 }]
		this.preload_server_config = {
			"config_goods_price": false
		}

		this.load_callback = () => {

			// this.custom_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.RegisterMask(this._Viewport1)
			this.InitEvent()
			this.InitView()
			// 		if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 			SetSizeDeltaX(this._lb_select,87)
			// 			this._lb_select.size  = 20

			// 			let csf = this._lb_ref.GetComponent("ContentSizeFitter")
			// 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			SetSizeDelta(this._lb_ref,150,70)
			// 			this._lb_ref.verticalAlign = "middle"
			// this._lb_ref.textAlign = "center"

			// 			let csf = this._lb_draw.GetComponent("ContentSizeFitter")
			// 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			SetSizeDelta(this._lb_draw,150,70)
			// 			this._lb_draw.verticalAlign = "middle"
			// this._lb_draw.textAlign = "center"
			// 		}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_ref, () => {
				if (!data) {
					return
				}
				let pool = data.pool
				if (pool.length > 0) {
					local_Message.show("奖池已锁定")
					return
				}

				let desc = "是否随机生成奖池?"
				let ok_callback = () => {
					if (b != null && s != null) {
						model.Fire(local_Event.SCMD_REQUEST, 33139, b, s)
					}
				}
				ok_callback()
			}
				, this, true)

			Util.AddClickEvent(this._btn_draw, () => {
				if (model.getKeyDicValue(b, s, "is_draw")) {
					local_Message.show("点击过快")
					return
				}

				if (!data) {
					return
				}

				let draw_times = data.draw_times
				if (draw_times == poolItem_list.length) {
					local_Message.show("奖池已抽完,请重置奖池")
					return
				}

				if (data.pool.length == 0 && (!data.random_pool || (data.random_pool && data.random_pool.length < poolItem_list.length))) {
					local_Message.show("请填充奖池")
					return
				}
				//抽奖回调
				let draw = () => {
					if (draw_cost) {
						let cost = draw_cost
						let [type, lock] = local_GoodsModel.GetMappingTypeId(cost[0], cost[1])
						let basic = local_GoodsModel.GetGoodsBasicByTypeId(type)
						if (basic) {
							let request = (auto_buy?) => {
								model.setKeyDicValue(b, s, "is_draw", true)
								model.Fire(local_Event.SCMD_REQUEST, 33134, b, s, auto_buy)
							}
							let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_price", false)
							let price_cfg = cfg[type]
							if (!price_cfg) {
								return
							}
							let price = price_cfg.price
							let have_num = local_GoodsModel.GetTypeGoodsNum(type)
							let need_num = local_Number(cost[2])
							if (have_num >= need_num) {
								request(0)
							} else {
								let need_money = (need_num - have_num) * price
								let jump_alert = model.getKeyDicValue(b, s, "jump_alert")
								let ok_callback = () => {
									if (jump_alert) {
										model.setKeyDicValue(b, s, "jump_alert", true)
									}
									let jin = role_mgr.mainRoleInfo.jin
									if (jin >= need_money) {
										request(1)
									} else {
										NotEnougnDiamond()
									}
								}

								let check_callback = () => {
									jump_alert = !jump_alert
								}

								if (jump_alert) {
									ok_callback()
								} else {
									let str = Trim(basic.goods_name) + "不足,是否消耗<font color='#639c12'>" + need_money + "勾玉</font>进行抽奖"
									local_Alert.Show(str, local_Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, check_callback)
								}
							}
						}
					}
				}
				//锁定回调
				let lock_callback = () => {
					let list = []
					if (data.random_pool) {
						for (let i in data.random_pool) {

							let v = data.random_pool[i]
							let grade = [v.rare, v.grade]
							table.insert(list, grade)
						}
						if (list.length > 0) {
							random_reward = true
							model.Fire(local_Event.SCMD_REQUEST, 33129, b, s, list)
							data.random_pool = null
						}
					}

				}

				if (data.pool.length == 0 && data.random_pool) {
					local_Alert.Show("锁定奖池后,需要将奖池全部抽完,\n或花费一定的勾玉才可将奖池重置.\n是否确定锁定奖池？", local_Alert_Type.Two, lock_callback)
					return
				}
				draw()
			}
				, this, true)

			Util.AddClickEvent(this._btn_reset, () => {
				if (model.getKeyDicValue(b, s, "is_draw")) {
					local_Message.show("点击过快")
					return
				}
				if (!reset_count || reset_count <= 0) {
					local_Message.show("今日重置次数已用完")
					return
				}
				if (data) {
					let accum = data.stage
					if (accum.length > 0) {
						for (let _tmpi in accum) {
							var v = accum[_tmpi]
							if (v.status == 1) {
								local_Message.show("有累计奖励未领取")
								return
							}
						}
					}
					let pool = data.pool
					if (!pool || pool.length == 0) {
						local_Message.show("当前奖池未锁定，可继续选择奖励无需重置")
						return
					}
				}
				if (reset_cost) {
					let pool = data.pool
					let need_money = 0
					if (pool) {
						for (let i in pool) {

							if (pool[i].status == 0) {
								need_money = local_Number(reset_cost[2])
								break
							}
						}
					}
					let str = null
					if (need_money == 0) {
						str = "消耗1次重置次数重置奖励,同时将会重置累计次数与累计奖励.重置后需要重新选取奖励."
					} else {
						str = "消耗<font color='#639c12'>" + need_money + "勾玉</font>与1次重置次数重置奖励,同时将会重置累计次数与累计奖励.重置后需要重新选取奖励."
					}
					let request = () => {
						model.Fire(local_Event.SCMD_REQUEST, 33133, b, s)
					}

					let ok_callback = () => {
						let jin = role_mgr.mainRoleInfo.jin
						if (jin >= need_money) {
							request()
						} else {
							NotEnougnDiamond()
						}
					}
					local_Alert.Show(str, local_Alert_Type.Two, ok_callback)
				}
			}
				, this, true)

			Util.AddClickEvent(this._btn_select, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "SelectView", b, s, 2)
			}
				, this, true)

			this.BindEvent(model, local_Event.ANSWER_TARGET, (...new_args) => {
				let args = new_args
				if (args[0] == b && args[1] == s) {
					let _reward = null
					let grade = args[2].grade
					if (args[2].draw_times != null) {
						draw_answer = args[2]
						this.Anim_Callback()
						model.setKeyDicValue(b, s, "is_draw", false)
						//play_draw_anim = true
					} else {
						if (!accum_dic) {
							return
						}
						_reward = accum_dic[grade]
						this.OpenCongra(_reward)
					}
					this.RefAccumItem()
				}
			}
			)

			this.BindEvent(model, local_Event.UPDATE_VIEW, (...new_args) => {
				let args = new_args
				if (args[0] == b && args[1] == s) {
					data = model.GetActData(b, s)
					if (args[2] == 33139) {
						this.CreatePoolItem(b, s, data, data.random_pool)
						return
					}
					this.InitGradeDic()
					this.CreatePoolItem(b, s, data)
					this.RefDrawBtn()
					if (args[1] != 33129) {
						this.InitShowReward()
						this.RefAccumItem()
						this.RefResetBtn()
					}
				}
			}
			)

			let close_tips_view = () => {
				play_show_anim = true
			}
			this.BindEvent(local_GlobalEventSystem, local_EventName.CLOSE_TIPS_VIEW, close_tips_view)
		}

		this.OpenCongra = (_reward?) => {
			if (_reward) {
				let rewards = model.GetActReward(b, s, _reward.form_type, _reward.reward)
				let view = new CongratulationObtainView(rewards, 10)
				view.Open()
			}
		}

		this.Anim_Callback = () => {
			if (!data || !draw_answer) {
				return
			}
			let rare = draw_answer.rare
			let grade = draw_answer.grade
			if (!pool_dic) {
				return
			}
			let _reward = pool_dic[rare] && pool_dic[rare][grade]
			data = model.GetActData(b, s)
			this.CreatePoolItem(b, s, data)
			this.RefDrawBtn()
			this.OpenCongra(_reward)
		}

		this.InitView = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath("uizxjc_016.jpg"), false, () => {
				SetSizeDelta(this._img_bg, 720, 1201);
			})
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_0, GameResPath.GetIcon("optionalLotto", "uizxjc_016b"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_1, GameResPath.GetIcon("optionalLotto", "uizxjc_016a"), true)
			// let effect_data = {
			// 	custom_sorting_order: this.custom_sorting_order
			// }
			//this.AddUIEffect("UI_2052_01", this.layer_value, this._gp_effect, null, null, true, effect_data)
			if (!info) {
				return
			}
			b = info.base_type
			s = info.sub_type
			model.CloseACTRed(b, s)
			data = model.GetActData(b, s)
			if (!data) {
				return
			}
			timer = model.LoadActTimer(this._gp_time, info.etime, 20, "#ffdb11", null, "#ffffff", "活动剩余时间：", 280)
			if (!update_id) {
				runner.AddRunObj(this, 2)
				update_id = true
			}
			this.InitGradeDic()
			this.CreatePoolItem(b, s, data, data.random_pool)
			this.InitShowReward()
			this.RefAccumItem()
			this.RefDrawBtn()
			this.RefResetBtn()
		}

		//创建累计奖励
		this.RefAccumItem = () => {
			if (accumItem_list.length > 0) {
				for (let _tmpi in accumItem_list) {
					var item = accumItem_list[_tmpi]
					item.SetVisible(false)
				}
			}
			if (!info || !data) {
				return
			}
			if (Util.IsTableEmpty(accum_dic)) {
				return
			}
			let dic = accum_dic
			let stage = data.stage
			let sort = (a?, b?) => {
				return a.grade < b.grade
			}
			table.sort(stage, sort)
			for (let i in stage) {

				let v = stage[i]
				let item = accumItem_list[i]
				if (!item) {
					item = new AccumItem(this._gp_reward)
					item.Load()
					table.insert(accumItem_list, item)
				}
				item.ExcuteCallback(() => {
					item.SetVisible(true)
					item.SetData(b, s, dic[v.grade], v)
				}
				)
			}
			//let accum_height = 129 * stage.length + 6 * (stage.length - 1)
			//SetSizeDeltaX(this._img_progress, accum_height * 0.8)
			//SetAnchoredPositionY(this._img_progress, -(accum_height * 0.8 + 20))
		}

		//刷新抽奖信息
		this.RefDrawBtn = () => {
			if (!info || !data) {
				return
			}
			//当前抽奖次数
			let times = data.draw_times
			this._lb_count.text = times
			let n_times = times + 1
			//是否锁定奖池
			if (data.pool && data.pool.length == 0) {
				this._lb_draw.text = "锁定奖池"
				this._gp_cost.visible = false
				this._img_cheap_time.visible = false
				return
			} else {
				this._lb_draw.text = "抽取奖励"
			}
			let cond = model.GetActCondition(b, s, "info")
			if (cond) {
				//是否超值次数内
				let cheap_time = cond.cheap_time
				this._img_cheap_time.visible = times < local_Number(cheap_time)
				//寻找对应的下一次抽奖所消耗的道具信息
				let cost = cond.cost
				if (!cost) {
					return
				}
				for (let i in cost) {

					let _c = cost[i]
					let min = local_Number(_c[0])
					let max = local_Number(_c[1])
					if (min <= n_times && n_times <= max) {
						this._gp_cost.visible = true
						let cur_cost = _c[2] && _c[2][0]
						draw_cost = cur_cost
						if (local_Number(cur_cost[2]) == 0) {
							this._lb_cost.text = "免费"
							this._img_cost.visible = false
						} else {
							let [type, lock] = local_GoodsModel.GetMappingTypeId(cur_cost[0], cur_cost[1])
							let basic = local_GoodsModel.GetGoodsBasicByTypeId(type)
							this._lb_cost.text = cur_cost[2]
							if (basic) {
								this._img_cost.visible = true
								ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(basic.goods_icon))
							}
						}
						this._gp_cost.refresh()
						//LayoutRebuilder(this._gp_cost)
						return//找到了就返回
					}
				}
				//没有下一次信息，说明抽完了
				this._gp_cost.visible = false
			}
		}

		//刷新奖池可重置次数
		this.RefResetBtn = () => {
			if (!info || !data) {
				return
			}
			let times = data.reset
			let n_times = times + 1
			let cond = model.GetActCondition(b, s, "info")
			if (cond) {
				let cost = cond.refresh
				if (!cost) {
					return
				}
				let max = null
				for (let i in cost) {

					let _c = cost[i]
					let min = local_Number(_c[0])
					max = local_Number(_c[1])
					if (min <= n_times && n_times <= max) {
						let cur_cost = _c[2] && _c[2][0]
						reset_cost = cur_cost
					}
				}
				reset_count = max - times
				this._lb_reset_num.style.fontSize = 20
				this._lb_reset_num.style.color = "#49ec64"
				this._lb_reset_num.style.wordWrap = false
				this._lb_reset_num.innerHTML = Util.StrToHTML("剩余次数:<font color='#49ec64'>" + reset_count + "</font>")
				if (this._lb_reset_num.parent)
					(<Laya.HBox>(this._lb_reset_num.parent)).refresh()
			}
		}

		//获取所有奖励并存入字典
		this.InitGradeDic = () => {
			if (!data || !data.reward_list || data.reward_list.length == 0) {
				return
			}
			for (let _tmpi in data.reward_list) {
				var v = data.reward_list[_tmpi]
				let grade = v.grade
				let cond: String = v.condition
				if (cond) {
					if (cond.match("stage") != null) {
						accum_dic[grade] = v
					} else {
						let _cond = model.GetActCondition(b, s, "data", grade)
						if (_cond && _cond.rare) {
							let key = Number(_cond.rare)
							pool_dic[key] = pool_dic[key] || {}
							pool_dic[key][grade] = v
						}
					}
				}
			}
		}

		//创建上方的奖励展示
		this.InitShowReward = () => {
			if (showItem_list.length > 0) {
				for (let _tmpi in showItem_list) {
					var item = showItem_list[_tmpi]
					item.SetVisible(false)
				}
			}
			if (Util.IsTableEmpty(pool_dic)) {
				return
			}
			let rare_2 = pool_dic[2]
			let rare_1 = pool_dic[1]
			let num = 0
			let initItem = (list?) => {
				for (let i in list) {

					let item: EquipmentItem = showItem_list[num]
					if (!item) {
						item = new EquipmentItem(this._gp_show)
						//item.SetMaskId(1)

						item.Load()
						item.SetPosition((num) * show_item_size, -3)
						table.insert(showItem_list, item)
					}

					item.ExcuteCallback(() => {
						item.SetItemSize(show_item_size, show_item_size)
						item.SetVisible(true)
						let v = list[i]
						let reward = model.GetActReward(b, s, v.form_type, v.reward)
						if (reward && reward[0]) {
							let rew = reward[0]
							let [type, lock] = local_GoodsModel.GetMappingTypeId(rew[0], rew[1])
							let call_back = () => {
								play_show_anim = false
								UIToolTipMgr.GetInstance().DefaultAppendTips(type, rew[2])
							}
							item.SetClickCallBack(call_back)
							item.SetData(type, rew[3], lock)
						}
					}
					)
					num = num + 1
				}
			}

			initItem(rare_2)
			initItem(rare_1)
		}

		//创建奖池
		this.CreatePoolItem = (_b?, _s?, _data?, random_pool?) => {
			let new_pool_list = []
			if (poolItem_list.length > 0) {
				for (let _tmpi in poolItem_list) {
					var item = poolItem_list[_tmpi]
					item.SetVisible(false)
				}
			}
			let cond = model.GetActCondition(_b, _s, "info")
			if (!cond || !_data) {
				return
			}
			let pool = random_pool || _data.pool
			if (!pool) {
				return
			}
			let rare_0 = local_Number(cond.rare_0)
			let rare_1 = local_Number(cond.rare_1)
			let rare_2 = local_Number(cond.rare_2)
			let str = "可选" + rare_2 + "个<font color='#fdf759'>传说奖励</font>,"
			str = str + rare_1 + "个<font color='#fdf759'>史诗奖励</font>,"
			str = str + rare_0 + "个<font color='#fdf759'>珍稀奖励</font>"
			this._lb_desc.style.fontSize = 18
			this._lb_desc.style.color = "#ffffff"
			this._lb_desc.style.wordWrap = false
			this._lb_desc.innerHTML = str
			if (this._lb_desc.parent)
				(<Laya.HBox>this._lb_desc.parent).refresh()
			let all_num = rare_0 + rare_1 + rare_2
			//代表随机奖池，随机奖池是没有排序的，已存储且锁定在服务端的是已排好序的
			if (random_pool) {
				let list_0 = []
				let list_1 = []
				let list_2 = []
				for (let _tmpi in pool) {
					var v = pool[_tmpi]
					if (v.rare == 2) {
						table.insert(list_2, v)
					} else if (v.rare == 1) {
						table.insert(list_1, v)
					} else {
						table.insert(list_0, v)
					}
				}

				for (let i = list_0.length + 1; i <= rare_0; i++) {
					table.insert(list_0, false)
				}
				for (let i = list_1.length + 1; i <= rare_1; i++) {
					table.insert(list_1, false)
				}
				for (let i = list_2.length + 1; i <= rare_2; i++) {
					table.insert(list_2, false)
				}

				pool = list_2.concat(list_1)
				pool = pool.concat(list_0)
			}
			pool_grade = []
			let remaining_cells = all_num
			for (let i = 0; i < all_num; i++) {
				let item: PoolItem = poolItem_list[i]
				if (!item) {
					item = new PoolItem(this._gp_pool)
					item.SetPosition(paopaopos[i].x, paopaopos[i].y)
					item.Load()
					table.insert(poolItem_list, item)
				}
				let rare = 0
				//选定固定奖励时占住的格子类型数量，以及剩余空格子类型的数量
				if(pool[i]){
					let new_rare
					remaining_cells = remaining_cells - 1
					if(pool[i].rare == 2){
						rare_2 = rare_2 - 1
					} else if(pool[i].rare == 1){
						rare_1 = rare_1 - 1
					} else if(pool[i].rare == 0){
						rare_0 = rare_0 - 1
					}
					if(pool[i].rare == 2){
						new_rare = 3
					}else if(pool[i].rare == 1){
						new_rare = 2
					}else if(pool[i].rare == 0){
						new_rare = 1
					}
					table.insert(new_pool_list, new_rare)
				}
				//代表空奖池
				// if (!pool[i]) {
				// 	if (i < rare_2) {
				// 		console.error("传说：2")
				// 		rare = 2
				// 	} else if (i < rare_2 + rare_1) {
				// 		console.error("史诗：1")
				// 		rare = 1
				// 	} else {
				// 		console.error("稀有：0")
				// 		rare = 0
				// 	}
				// }
				//还没有抽中的
				if (pool[i] && pool[i].status == 0) {
					table.insert(pool_grade, pool[i].grade)
				}
				// item.ExcuteCallback(() => {
				// 	item.SetVisible(true)
				// 	item.SetData(pool[i], pool_dic, _b, _s, rare)
				// }
				// )
			}

			//重新刷新空格子的类型
			for(let idx = 0; idx < remaining_cells; idx++){
				let rare = 1
				if (idx < rare_2) {
					rare = 3
				} else if (idx < rare_2 + rare_1) {
					rare = 2
				}
				table.insert(new_pool_list, rare)
			}
			//刷新所有格子的数据
			for (let j = 0; j < all_num; j++) {
				let item = poolItem_list[j]
				item.ExcuteCallback(() => {
					item.SetVisible(true)
					item.SetData(pool[j], pool_dic, _b, _s, new_pool_list[j])
				})
			}
		}

		this.CustomMehod = (index?, args?) => {
			if (args) {
				info = args[0]
			}
		}

		this.Local_DeleteMe = () => {
			if (b && s) {
				model.setKeyDicValue(b, s, "is_draw", false)
			}
			if (update_id) {
				runner.RemoveRunObj(this.hashCode)
				update_id = false
			}
			if (timer) {
				timer.DeleteMe()
				timer = null
			}
			if (poolItem_list.length > 0) {
				for (let _tmpi in poolItem_list) {
					var item = poolItem_list[_tmpi]
					item.DeleteMe()
				}
				poolItem_list = []
			}
			if (accumItem_list.length > 0) {
				for (let _tmpi in accumItem_list) {
					var item = accumItem_list[_tmpi]
					item.DeleteMe()
				}
				accumItem_list = []
			}
			if (showItem_list.length > 0) {
				for (let _tmpi in showItem_list) {
					var item = showItem_list[_tmpi]
					item.DeleteMe()
				}
				showItem_list = []
			}
			super.DeleteMe()
		}


		this.Update = () => {
			//奖励滚动展示
			if (play_show_anim && showItem_list.length > 0) {
				for (let index in showItem_list) {

					let item: EquipmentItem = showItem_list[index]
					if (!item.is_loaded) break
					let item_pos = new Vector2(item.display_obj.x, item.display_obj.y)
					let item_pos_x = item_pos.x - 1
					SetAnchoredPosition(item.display_obj, item_pos_x, -3)
					if (item_pos_x < -show_item_size) {
						let i = (showItem_list.length - 1) //local_Number(index) <= 0 &&   || (local_Number(index))
						let last_item = showItem_list[i]
						if (!last_item.is_loaded) break
						let last_item_pos = new Vector2(last_item.display_obj.x, last_item.display_obj.y)
						let posx = show_item_size * i
						SetAnchoredPosition(item.display_obj, posx, -3)
					}
				}
			}
			//抽奖动画
			if (play_draw_anim) {
				//每隔指定帧数才能进行变换
				if (frames % speend == 0) {
					let max = pool_grade.length
					let select_draw_grade = () => {
						if (draw_answer) {
							let grade = draw_answer.grade
							model.Fire(local_Event.UP_GRADE, b, s, grade)
						}
					}

					if (play_count == all_count || max == 1) {
						this.Anim_Callback()
						model.setKeyDicValue(b, s, "is_draw", false)
						play_draw_anim = false
						frames = 0
						play_count = 0
						last_index = null
						speend = start_speend
						if (max == 1) {
							select_draw_grade()
						}
					} else if (play_count == all_count - 1) {
						select_draw_grade()
						play_count = play_count + 1
					} else {
						let random
						random = () => {
							let index = Math.floor(Math.random() * max)
							if (last_index != index) {
								last_index = index
								let grade = pool_grade[index]
								play_count = play_count + 1
								model.Fire(local_Event.UP_GRADE, b, s, grade)
							} else {
								random()
							}
						}

						random()
					}
					if (play_count >= speend_count) {
						speend = speend + Math.floor(Math.random() * 5)
					}
				}
				frames = frames + 1
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_0,
			this._img_1,
			this._Scroller1,
			this._gp_show,
			this._gp_pool,
			this._btn_select,
			this._img_select,
			this._lb_select,
			this._Scroller3,
			this._Viewport3,
			this._img_progress,
			this._gp_reward,
			this._btn_ref,
			this._img_ref,
			this._lb_ref,
			this._btn_draw,
			this._img_draw,
			this._lb_draw,
			this._btn_reset,
			this._img_reset,
			this._lb_reset,
			this._gp_cost,
			this._img_cost,
			this._lb_cost,
			this._lb_reset_num,
			this._gp_time,
			this._lb_desc,
			this._Image1,
			this._lb_count,
			this._Image2,
			this._Image3,
			this._img_cheap_time,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_0",
				"_img_1",
				"_Scroller1",
				"_gp_show",
				"_gp_pool",
				"_btn_select",
				"_img_select",
				"_lb_select",
				"_Scroller3",
				"_Viewport3",
				"_img_progress",
				"_gp_reward",
				"_btn_ref",
				"_img_ref",
				"_lb_ref",
				"_btn_draw",
				"_img_draw",
				"_lb_draw",
				"_btn_reset",
				"_img_reset",
				"_lb_reset",
				"_gp_cost",
				"_img_cost",
				"_lb_cost",
				"_lb_reset_num",
				"_gp_time",
				"_lb_desc",
				"_Image1",
				"_lb_count",
				"_Image2",
				"_Image3",
				"_img_cheap_time",
				"_gp_effect",
			])
	}
}
window["OptionalLottoView"] = OptionalLottoView