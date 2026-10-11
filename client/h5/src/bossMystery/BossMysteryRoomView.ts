import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { TimeUtil } from "../util/TimeUtil"
import { OpenFun } from "../common/OpenFun"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest } from "../util/Util"
import { EventName } from "../common/EventName"
import { SceneManager } from "../scene/SceneManager"
import { SceneEventType } from "../common/EventName"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BossModel } from "../commonModel/BossModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { ResManager } from "../common/ResManager"
import { BossMysteryRadioButton } from "./BossMysteryRadioButton"
import { BossMysteryMonItem } from "./BossMysteryMonItem"

export class BossMysteryRoomView extends BaseItem1 {
	InitEvent
	ItemTab
	LoadSuccess
	RequestPlayerNum
	SetClickCallBack
	SetCost
	SetData
	SetRoleNum
	SetSelectBoss
	SwitchLayer
	SwitchView
	UpdateView

	array_collection
	boss_info

	boss_layer_info_
	GetBossLayerInfos

	boss_type
	clickTime
	cost_item
	defalut_index
	defalut_tab_index
	initRequestTimer
	item_loop_mgr:LoopScrowViewMgr
	model
	needRefresh
	now_box_vo
	now_index
	/**1下标 */
	now_layer
	onTime
	open_state
	radio_btn
	requestTimer
	select_boss_id
	showTipslb
	switch_call_back
	tab_list
	tab_loop_mgr
	ticket_list
	cfg_boss
	cfg_boss_type

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossMystery"
		this.layout_file = "BossMysteryRoomView"

		this.needRefresh = false
		this.defalut_tab_index = 1
		this.defalut_index = 1
		this.boss_type = BossModel.BossType.mystery
		this.model = BossModel.GetInstance()

		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let scene_mgr = SceneManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.LoadSuccess = () => {
			this.cfg_boss = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_great_demon", false)
			this.cfg_boss_type = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type", false)

			this._Scroller1.scrollBar.visible = false
			this._scroll_con.scrollBar.visible = false

			this.scene_role.style.fontSize = 20
			this.scene_role.style.color = "#ffffff"
			this.scene_role.style.wordWrap = false

			this.challenge_num.style.fontSize = 20
			this.challenge_num.style.color = "#ffffff"
			this.challenge_num.style.wordWrap = false

			this.need_cost.style.fontSize = 20
			this.need_cost.style.color = "#ffffff"
			this.need_cost.style.wordWrap = false
		}

		this.ItemTab = (index?) => {
			this.SwitchView(index)
		}

		this.GetBossLayerInfos = (now_boss_type, now_layer) => {
			let infos = this.boss_layer_info_ && this.boss_layer_info_[now_boss_type + "_" + now_layer]
			// if(infos)return infos.slice(1)
			return infos
		}


		this.InitEvent = () => {
			//this._list_room_con.addEventListener(local_eui.ItemTapEvent.ITEM_TAP, this.ItemTab, this)
			Util.AddClickEvent(this.challengeBtn, () => {
				if (this.clickTime && TimeUtil.getServerTime() - this.clickTime < 0.5) {
					return
				}
				let info = this.GetBossLayerInfos(this.boss_type, this.now_layer)
				let boss_info = info && info[this.now_index]
				if (!boss_info) {
					return
				}
				if (!this.open_state) {
					Message.show("等级不足")
					return
				}
				let enter = (call?, same_layer?) => {
					//let equip_bag_cell = this.model.GetBossKeyValue(this.now_boss_type, "min_equip_bag_cell")
					//let god_bag_cell = this.model.GetBossKeyValue(this.now_boss_type, "min_god_bag_cell")
					let enter_func = () => {
						if (this.now_index || this.now_index == 0) {
							let fun = () => {
								this.model.SetEnterBossInfo({ boss_id: boss_info.boss_id, boss_type: this.boss_type })
								this.model.Fire(BossModel.SCMD_REQUEST, 46003, this.boss_type, boss_info.boss_id)
								this.clickTime = TimeUtil.getServerTime()
							}
							if (call) {
								call(fun)
							} else {
								fun()
							}
						}
					}

					if (!scene_mgr.IsMysteryBossScene() || !same_layer) {
						if (this.boss_info && this.boss_info.count <= 0) {
							Message.show("进入次数不足（每天4点刷新）")
							return
						}
					}
					let lv = role_mgr.GetMainRoleVo().level
					if (lv < boss_info.open_lv) {
						Message.show(boss_info.open_lv + "级可进入第" + this.now_layer + "层")
						return
					}
					if (same_layer) {
						enter_func()
						return
					}
					if (this.ticket_list) {
						let cost_num = Number(this.ticket_list[2])
						let good_type = Number(this.ticket_list[1])
						let goods_num = goods_model.GetTypeGoodsNum(good_type)
						let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[good_type]
						if (!goods_info) {
							return
						}
						let goods_price = goods_info.price
						let basic = goods_model.GetGoodsBasicByTypeId(good_type)
						if (!basic) {
							return
						}
						let _tiket_name = basic.goods_name
						if (goods_num < cost_num) {
							let enter_callback = () => {
								let all_cost = cost_num - goods_num * goods_price
								if (role_mgr.mainRoleInfo.jin + role_mgr.mainRoleInfo.jinLock < all_cost) {
									Alert.Show("勾玉数量不足，是否进行充值", Alert_Type.Two, () => {
										OpenFun.OpenFunHandler(21)
									}
									)
									return
								}
								enter_func()
							}

							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossPersonalAlert", good_type, goods_num, cost_num, goods_price, null, _tiket_name, null, enter_callback)
							return
						}
					}
					enter_func()
				}

				let go_fun = () => {
					if (scene_mgr.IsMysteryBossScene()) {
						let curr_scene_id = scene_mgr.curr_scene_id
						let type = this.model.GetBossType()
						let layer = curr_scene_id - BossModel.BaseBossSceneId[type]
						if (type == this.boss_type && layer == this.now_layer) {
							let find = (fun) => {
								this.model.Fire(BossModel.CHANGE_BOSS_TARGET, null, boss_info.boss_id)
								//GlobalEventSystem:Fire(EventName.OPEN_BOSS_ENTER_VIEW, null, null, false)
								GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BossEnterView")
							}
							enter(find, true)
						} else {
							let call = (fun?) => {
								Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
									if (fun) {
										fun()
									}
								}, null, "离开", "取消")
							}
							enter(call, false)
						}
					} else {

						if (scene_mgr.IsNotChangeScene()) {
							Message.show("当前场景不能进入")
							return
						}

						if (!scene_mgr.IsFieldScene()) {
							let call = (fun?) => {
								Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
									if (fun) {
										fun()
									}
								}, null, "离开", "取消")
							}
							enter(call, false)
						} else {
							enter(null)
						}
					}
				}

				let layer_infos = this.GetBossLayerInfos(this.boss_type, this.now_layer)
				if (layer_infos && layer_infos[this.now_index].lv - role_mgr.GetMainRoleVo().level >= BossModel.HIGT_LEVEL_TIPS_VALUE) {
					Alert.Show("该首领等级较高,挑战可能比较困难,\n是否继续前往?", Alert_Type.Two, go_fun, null, "前往", "取消")
					return
				} else {
					go_fun()
				}
			}, this, true)

			this.BindEvent(this.model, BossModel.UPDATE_PLAYER_NUM, (scene_id?, player_num?) => {
				let boss_cfgs = this.cfg_boss
				if (this.boss_type != null && this.now_layer != null && this.now_index != null) {
					let info = this.GetBossLayerInfos(this.boss_type, this.now_layer)
					let boss_info = info && info[this.now_index]
					if (boss_info) {
						let cur_scene_id = boss_cfgs[boss_info.boss_id].scene
						if (cur_scene_id == scene_id) {
							this.SetRoleNum(player_num)
						}
					}
				}
			}
			)

			let update_select_fun = (info?) => {
				if (info && (info.mon_type == BossModel.MYSTERY_BOX_TYPE || info.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE)) {
					this.now_box_vo = info
					// let layer_infos = this.GetBossLayerInfos(this.now_boss_type, this.now_layer)
					// if (layer_infos) {
					// 	layer_infos[this.now_index] = info
					// }
				}
			}

			this.BindEvent(this.model, BossModel.UPDATE_SELECT_BOSS_INFO, update_select_fun)

			if (this.needRefresh) {
				this.SetData(this.boss_info)
				this.needRefresh = false
			}
		}

		
		this.SetClickCallBack = (switch_call_back?) => {
			this.switch_call_back = switch_call_back
		}

		this.SetSelectBoss = (boss_id?) => {
			this.select_boss_id = boss_id
		}

		this.SetData = (boss_info?) => {
			this.boss_info = boss_info
			if (this.is_loaded) {
				this.UpdateView()
				this.initRequestTimer()
			} else {
				this.needRefresh = true
			}
		}

		this.UpdateView = () => {
			if (!this.boss_info) {
				return
			}
			let list = this.boss_info.boss_info
			this.boss_layer_info_ = {}
			this.tab_list = []
			let layers = 0
			let tmp = null
			let find = null
			let box = []
			let special_boss = []
			for (let _tmpi = 0; _tmpi < list.length; _tmpi++) {
				var vo = list[_tmpi]

				let layer = vo.layer
				if (layer) {
					let boss_type = vo.boss_type
					if (!box[boss_type + "_" + layer]) {
						box[boss_type + "_" + layer] = []
					}
					if (!special_boss[boss_type + "_" + layer]) {
						special_boss[boss_type + "_" + layer] = []
					}
					if (vo.mon_type == BossModel.MYSTERY_BOX_TYPE || vo.mon_type == BossModel.MYSTERY_SUPER_BOX_TYPE) {
						if ((this.now_box_vo && this.now_box_vo.layer == this.now_layer) && vo.layer == this.now_layer) {
							if (this.now_box_vo.mon_type == vo.mon_type) {
								find = box[boss_type.length + "_" + layer] > 0
								if (!find) {
									table.insert(box[boss_type + "_" + layer], vo)
								}
							}
						} else {
							find = box[boss_type.length + "_" + layer] > 0
							if (!find) {
								if(vo.mon_type == BossModel.MYSTERY_BOX_TYPE)continue //刚开始不展示普通宝箱
								table.insert(box[boss_type + "_" + layer], vo)
							}
						}
					} else if (vo.mon_type == BossModel.MYSTERY_SPECIAL_BOSS_TYPE) {
						find = special_boss[boss_type.length + "_" + layer] > 0
						if (!find) {
							table.insert(special_boss[boss_type + "_" + layer], vo)
						}
					}
				}
			}
			let list_a = null
			let sort_fun = (a?, b?) => {
				if (a.layer == b.layer) {
					return a.lv < b.lv
				} else {
					return a.layer < b.layer
				}

			}
			table.sort(list, sort_fun)
			for (let _tmpi = 0; _tmpi < list.length; _tmpi++) {
				var vo = list[_tmpi]
				let layer = vo.layer
				let boss_type = vo.boss_type

				let layer_infos = this.GetBossLayerInfos(boss_type, layer)
				if (!layer_infos) {
					this.boss_layer_info_[boss_type + "_" + layer] = []
					layers = layers + 1
					if (box[boss_type + "_" + layer] && special_boss[boss_type + "_" + layer]) {
						list_a = box[boss_type + "_" + layer].concat(special_boss[boss_type + "_" + layer])
						this.boss_layer_info_[boss_type + "_" + layer] = list_a.concat(this.boss_layer_info_[boss_type + "_" + layer])
					}
					let data = {}
					if (PlatformManager.IsEyouThPlatform()) {
						data = { layer: layer, label: "ชั้น" + layer }
					} else {
						data = { layer: layer, label: layer + "层" }
					}
					if (PlatformManager.IsEyouEnPlatform()) {
						data = { layer: layer, label: "Fl." + layer }
					}
					if (PlatformManager.IsEyouIdnPlatform()) {
						data = { layer: layer, label: "Lt." + layer }
					}
					table.insert(this.tab_list, data)
				}
				if (vo.mon_type == 0) {
					table.insert(this.boss_layer_info_[boss_type + "_" + layer], vo)
				}
			}
			let layer = this.now_layer != null && this.now_layer || this.defalut_tab_index
			if (this.now_layer == null && !this.select_boss_id) {
				let max_key = null
				let level = role_mgr.GetMainRoleVo().level
				let i = list.length - 1
				do {
					let info = list[i]
					if (info) {
						let open_lv = info.open_lv
						let max_lv = info.max_lv
						max_key = i
						if (level >= open_lv && level <= max_lv) {
							break
						}
					}
					i = i - 1
				} while ((i >= 0))
				if (max_key != null) {
					let info = list[max_key]
					if (info) {
						let show_list = this.GetBossLayerInfos(this.boss_type, info.layer)
						for (let key in show_list) {
							let show_info = show_list[key]
							if (show_info.reborn_time < TimeUtil.getServerTime() && show_info.mon_type == BossModel.MYSTERY_NORMAL_BOSS_TYPE) {
								this.select_boss_id = show_info.boss_id
								break
							}
						}
					}
				}
			}
			if (this.select_boss_id) {
				for (let key in this.boss_layer_info_) {
					let layer_info = this.boss_layer_info_[key]
					for (let k in layer_info) {
						if (layer_info[k].boss_id == this.select_boss_id) {

							let idx = Number(k) == 0 ? Number(k) : Number(k) - 1 //宝箱做了处理
							layer = layer_info[k].layer
							this.defalut_index = idx
							this.defalut_tab_index = layer
							this.select_boss_id = null
							break
						}
					}
				}
			}

			this.now_layer = layer
			if (!this.tab_loop_mgr) {
				table.sort(this.tab_list, (a?, b?) => {
					return a.layer < b.layer
				})
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._Scroller1, BossMysteryRadioButton, this.tab_list, LoopScrCon.Horizontal, 1, (index?) => {
					this.now_layer = index+1
					this.SwitchLayer(index)
				},this.defalut_tab_index-1)
			}else{
				this.tab_loop_mgr.SetSelectIndex(this.now_layer-1)
			}


			let data = this.GetBossLayerInfos(this.boss_type, this.now_layer)

			if (this.item_loop_mgr) {
				this.item_loop_mgr.replaceAll(data)
				let tab_index = this.now_index != null?this.now_index : this.defalut_index
				this._scroll_con.selectedIndex=-1
				this.item_loop_mgr.SetSelectIndex(tab_index)
				this.item_loop_mgr.CenterOnChild(tab_index)
			} else {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._scroll_con, BossMysteryMonItem, data, LoopScrCon.Horizontal, 1, (index?) => {
					this.ItemTab(index)
				},this.defalut_index)
				this.item_loop_mgr.CenterOnChild(this.defalut_index)
			}

			// let tab_index = this.now_index != null?this.now_index : this.defalut_index
			// this.item_loop_mgr.CenterOnChild(tab_index)
			// this.item_loop_mgr.SetSelectIndex(tab_index)
			this.showTipslb()
			this.RequestPlayerNum()
		}

		this.SwitchLayer = (index) => {
			if (this.item_loop_mgr) {
				let data = this.GetBossLayerInfos(this.boss_type, index+1)
				this.item_loop_mgr.replaceAll(data)
				this._scroll_con.scrollBar.value = 0
				this._scroll_con.selectedIndex=-1
				this.item_loop_mgr.SetSelectIndex(this.defalut_index)
			}


			this.showTipslb()
			this.RequestPlayerNum()
		}

		this.showTipslb = () => {
			if (this.boss_info) {
				this.SetCost()
				let color = (this.boss_info.count > 0 && ("'#00fa64'") || ("'#fe1a1a'"))
				let str = "今日挑战次数：<font color=" + color + ">" + this.boss_info.count + "</font>/<font color='#00fa64'>" + this.boss_info.all_count + "</font>"
				this.challenge_num.innerHTML = Util.StrToHTML(str)
			}
		}

		this.SetRoleNum = (num?) => {
			this.scene_role.innerHTML = Util.StrToHTML("当前进入人数：<font color='#00fa64'>" + num + "</font>")
		}

		this.SetCost = () => {
			if (this.boss_info) {
				let info = this.boss_info
				let now_times = info.all_count - info.count + 1
				let cost = this.model.GetMysteryBossCost(now_times, this.cfg_boss_type)
				if (cost) {
					this.ticket_list = cost
					let [type_id, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
					if (!this.cost_item) {
						this.cost_item = new BaseAwardItem(this.cost_icon)
						this.cost_item.Load()
						this.cost_item.SetItemSize(40, 40)
						this.cost_item.SetItembgVisible(false)
					}
					this.cost_item.SetData(type_id, 0)
					//let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					let have = goods_model.GetTypeGoodsNum(type_id)
					let color = (have >= Number(cost[2]) && ("'#00fa64'") || ("'#fe1a1a'"))
					let str = "<font color=" + color + ">" + have + "</font><font color='#00fa64'>/" + cost[2] + "</font>"
					this.need_cost.innerHTML = Util.StrToHTML(str)
					this.CallLater(() => {
						this.need_cost.event("resize")
					})
				}
				//LayoutRebuilder(this._Group1)
			}
		}

		this.SwitchView = (index?) => {
			this.now_index = index
			if (this.boss_info && this.switch_call_back) {
				let info = this.GetBossLayerInfos(this.boss_type, this.now_layer)
				let boss = info && info[index]
				this.switch_call_back(boss)
				if (boss) {
					let level = role_mgr.GetMainRoleVo().level
					let open_lv = boss.open_lv
					let max_lv = boss.max_lv
					this.open_state = level >= open_lv && level <= max_lv
					Util.SetImageGray(this.btn_img, !this.open_state)
					let show = open_lv > 370 && !this.open_state
					this.destiny_img.visible = show
					this.destiny_img.width = show ? 22 : 0.1
					//this.lable_gp.horizontalCenter = (open_lv > 370 && ! this.open_state && ( -5 ) || ( 0 ) )
					if (!this.open_state) {
						let lv = (open_lv > 370 && (open_lv - 370) || (open_lv))
						if (PlatformManager.IsEyouEnPlatform()) {
							this.btn_label.text = lv + "级开启"
							this.btn_label.fontSize = 16
						} else if (PlatformManager.IsEyouIdnPlatform()) {
							this.btn_label.text = lv + "Buka di Lv."
							this.btn_label.fontSize = 18
						} else {
							this.btn_label.text = lv + "级开启"
							this.btn_label.fontSize = 22
						}
						//this.btn_label.strokeColor = "#989898"
					} else {
						this.btn_label.text = "进入秘境"
						//this.btn_label.strokeColor = "#CC7652"
						if (PlatformManager.IsEyouIdnPlatform()) {
							this.btn_label.fontSize = 20
						} else {
							this.btn_label.fontSize = 22
						}
					}
					//LayoutRebuilder(this.lable_gp)
				}
			}
		}

		this.initRequestTimer = () => {
			if (!this.requestTimer) {
				let time_fun = () => {
					this.onTime()
				}
				this.requestTimer = GlobalTimerQuest.AddDelayQuest(time_fun, 15)
			}
			this.onTime()
		}

		this.onTime = () => {
			this.RequestPlayerNum()
		}

		this.RequestPlayerNum = () => {
			let boss_cfgs = this.cfg_boss
			if (this.now_layer != null && this.now_index != null && this.boss_layer_info_) {
				let info = this.GetBossLayerInfos(this.boss_type, this.now_layer)
				let boss_info = info && info[this.now_index]
				if (boss_info) {
					let scene_id = boss_cfgs[boss_info.boss_id].scene
					GlobalEventSystem.Fire(SceneEventType.SCENE_PALYER_COUNT, scene_id)
				}
			}
		}
	}

	public DeleteMe() {
		if (this.tab_loop_mgr) {
			this.tab_loop_mgr.DeleteMe()
			this.tab_loop_mgr = null
		}
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}
		this.clickTime = null
		if (this.cost_item) {
			this.cost_item.DeleteMe()
			this.cost_item = null
		}
		if (this.requestTimer) {
			GlobalTimerQuest.CancelQuest(this.requestTimer)
			this.requestTimer = null
		}
		this.now_box_vo = null
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_Scroller1: Laya.List
	_scroll_con: Laya.List
	_Group1: Laya.HBox
	_Label1: Laya.Label
	cost_icon: Laya.Box
	need_cost: Laya.HTMLDivElement
	challenge_num: Laya.HTMLDivElement
	scene_role: Laya.HTMLDivElement
	challengeBtn: Laya.Box
	btn_img: Laya.Image
	lable_gp: Laya.HBox
	destiny_img: Laya.Image
	btn_label: Laya.Label
	_img_left: Laya.Image
	_img_right: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this._scroll_con,
			this._Group1,
			this._Label1,
			this.cost_icon,
			this.need_cost,
			this.challenge_num,
			this.scene_role,
			this.challengeBtn,
			this.btn_img,
			this.lable_gp,
			this.destiny_img,
			this.btn_label,
			this._img_left,
			this._img_right,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Scroller1",
				"_scroll_con",
				"_Group1",
				"_Label1",
				"cost_icon",
				"need_cost",
				"challenge_num",
				"scene_role",
				"challengeBtn",
				"btn_img",
				"lable_gp",
				"destiny_img",
				"btn_label",
				"_img_left",
				"_img_right",
			])
	}
}
window["BossMysteryRoomView"] = BossMysteryRoomView