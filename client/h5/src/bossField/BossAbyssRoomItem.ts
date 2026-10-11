import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { Util, GlobalTimerQuest, SetAnchoredPosition } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { ColorUtil, ColorType, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { OpenFun } from "../common/OpenFun"
import { EventName, SceneEventType } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { VipModel } from "../commonModel/VipModel"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { Alert, Alert_Type } from "../alert/Alert"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { BossFieldTabItem } from "./BossFieldTabItem"
import { BossSuitItem } from "../bossSuit/BossSuitItem"
import { PlatformManager } from "../PlatformManager"

export class BossAbyssRoomItem extends BaseItem1 {
	InitEvent
	LoadSuccess
	RequestPlayerNum
	SetClickCallBack
	SetData
	SetSelectBoss
	SwitchLayer
	SwitchRoom
	Underline
	UpdateEnterMsg
	UpdateLayerMapView
	UpdateView

	bgConfig
	boss_info
	boss_layer_info
	boss_type
	clickTime
	cur_layer_boss_info_list
	cur_layer_boss_list
	defalut_layer
	initRequestTimer
	init_tab
	layer_item_list
	need_refreshData
	now_index
	now_layer = null
	onTime
	requestTimer
	select_boss_id
	skip_boss_id
	select_index
	switch_call_back
	tab_list
	tab_loop_mgr
	tips
	updateLayer
	vip_flag


	public constructor(parent?) {
		super(parent)
		this.base_file = "bossField"
		this.layout_file = "BossAbyssRoomItem"

		this.defalut_layer = 0
		this.need_refreshData = false
		this.boss_type = BossModel.BossType.abyss
		this.init_tab = false
		this.layer_item_list = []
		this.cur_layer_boss_list = []
		this.cur_layer_boss_info_list = []
		this.tab_list = []
		this.select_index = 0

		let role_mgr = RoleManager.GetInstance()
		//let local_Config = Config
		let local_GlobalEventSystem = GlobalEventSystem
		let local_TimeUtil = TimeUtil
		let vip_model = VipModel.GetInstance()
		let local_Message = Message
		let scene_mgr = SceneManager.GetInstance()
		let boss_base_model = BossModel.GetInstance()
		let local_BossBaseModel = BossModel
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_OpenFun = OpenFun
		let goods_model = GoodsModel.GetInstance()
		let local_ColorUtil = ColorUtil

		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._btn_go.pos(506,395)
				this._Label1.pos(461,362)
			}
			this._Scroller1.scrollBar.visible = false
			this._lb_vip_tips.style.fontSize = 20
			this._lb_vip_tips.style.color = "#ffffff"
			this._lb_vip_tips.style.wordWrap = false
			this._lb_people_num.style.fontSize = 20
			this._lb_people_num.style.color = "#ffffff"
			this._lb_people_num.style.wordWrap = false
			this._lb_people_num.innerHTML = "当前进入人数：<font color = '#00fa64'>0</font>"

			this.InitEvent()
			this.LoadSuccess()

		}

		this.LoadSuccess = () => {
			this.bgConfig = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientBossBg", true)
			this.vip_flag = role_mgr.GetMainRoleVo().vip_flag
			if (this.need_refreshData) {
				this.UpdateView()
				this.need_refreshData = false
			}
		}

		this.onTime = () => {
			this.RequestPlayerNum()
		}

		this.initRequestTimer = () => {
			if (!this.requestTimer) {
				this.requestTimer = GlobalTimerQuest.AddPeriodQuest(this.onTime, 3)
			}
			this.onTime()
		}

		this.RequestPlayerNum = () => {
			let boss_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
			if (this.select_boss_id) {
				let scene_id = (boss_cfgs && boss_cfgs[this.select_boss_id]) && boss_cfgs[this.select_boss_id].scene
				if (scene_id) {
					local_GlobalEventSystem.Fire(SceneEventType.SCENE_PALYER_COUNT, scene_id)
				}
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_go, () => {
				if (this.clickTime && local_TimeUtil.getServerTime() - this.clickTime < 0.5) {
					return
				}
				let boss_info = (this.boss_layer_info && this.boss_layer_info[this.now_layer]) && this.boss_layer_info[this.now_layer][this.now_index]
				if (!boss_info) {
					return
				}
				let level = role_mgr.GetMainRoleVo().level
				let open_lv = boss_info.open_lv
				let max_lv = boss_info.max_lv
				let enter_vip = boss_info.enter_vip
				let enter_vip_card = boss_info.enter_vip_card != null && boss_info.enter_vip_card || 4
				let vip = role_mgr.GetMainRoleVo().vip_flag
				let vip_card = vip_model.GetMaxVipCardType()
				let invalid_card = vip_model.IsInvalidCard()
				let open_state = level >= open_lv && level <= max_lv
				if (!open_state) {
					local_Message.show("玩家达到180级可进入")
					return
				}
				if (vip_card < enter_vip_card) {
					OpenFun.OpenFunHandler(8, 28)
					local_Message.show("需要达到VIP特权卡" + enter_vip_card + "才可进入大妖之境")
					return
				}
				if (invalid_card) {
					OpenFun.OpenFunHandler(8, 28)
					local_Message.show("VIP特权卡已过期")
					return
				}
				if (vip < enter_vip) {
					OpenFun.OpenFunHandler(8, 28)
					local_Message.show("需要达到VIP" + enter_vip + "才可进入大妖之境")
					return
				}
				let scmd_func = () => {
					if (boss_info) {
						let info = this.boss_layer_info[this.now_layer]
						let boss_info = info && info[this.now_index]
						let curr_scene_id = scene_mgr.curr_scene_id
						let layer = curr_scene_id - local_BossBaseModel.BaseBossSceneId[this.boss_type]
						let enter = () => {
							boss_base_model.SetEnterBossInfo({ boss_id: boss_info.boss_id })
							boss_base_model.Fire(local_BossBaseModel.SCMD_REQUEST, 46003, this.boss_type, boss_info.boss_id)
							this.clickTime = local_TimeUtil.getServerTime()
						}
						let alert = () => {
							local_Alert.Show("是否离开当前场景?", local_Alert_Type.Two, () => {
								enter()
							}
								, null, "离开", "取消")
						}
						if (scene_mgr.IsAbyssBossScene()) {
							if (layer == this.now_layer) {
								boss_base_model.Fire(local_BossBaseModel.CHANGE_BOSS_TARGET, null, boss_info.boss_id)
								local_GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BossEnterView")
							} else {
								alert()
							}
						} else {

							if(scene_mgr.IsNotChangeScene()){
								Message.show("当前场景不能进入")
								return
							}


							if (!scene_mgr.IsFieldScene()) {
								alert()
							} else {
								enter()
							}
						}
					}
				}

				let enter_cost = boss_info.enter_cost
				let cost = enter_cost && enter_cost[0]
				let cost_count = Number((cost && (cost[2]) || (0)))
				let check_jin = () => {
					if (this.use_delete_method) {
						return
					}
					let jin_lock = role_mgr.GetMainRoleVo().jinLock
					let jin = role_mgr.GetMainRoleVo().jin
					this._lb_vip_tips.innerHTML = "消耗:"
					if (jin_lock < cost_count && jin + jin_lock < cost_count) {
						local_Alert.Show("勾玉数量不足，是否进行充值", local_Alert_Type.Two, () => {
							local_OpenFun.OpenFunHandler(21)
						})
					} else if (jin_lock < cost_count && jin + jin_lock >= cost_count) {
						let str = "<font color='#ff4f50'>当前绑定勾玉数量不足，是否消耗勾玉代替？</font>"
						let content = Util.StrToHTML(str)
						local_Alert.Show(content, local_Alert_Type.Two, scmd_func, null, "确定", "取消")
						local_Alert.SetIsCharge(true)
					} else {
						scmd_func()
					}
					this.CallLater(() => {
						this._lb_vip_tips.event("resize")
					})
				}

				let check_vip = () => {
					if (scene_mgr.IsAbyssBossScene()) {
						scmd_func()
						return
					}
					let free_vip = boss_info && boss_info.free_vip
					if (vip >= free_vip) {
						scmd_func()
					} else {
						if (!boss_base_model.abyss_cost_alert) {
							let str = "当前VIP等级不满足免费进入条件<br><font color='#ff4f50'>是否消耗" + cost_count + "绑定勾玉代替？</font>"
							let content = Util.StrToHTML(str)
							local_Alert.Show(content, local_Alert_Type.AlertTypeCheckBox, check_jin, null, "确定", "取消", null, false, (bool?) => {
								boss_base_model.abyss_cost_alert = bool
							}, "本次登录不再提示")
						} else {
							check_jin()
						}
					}
				}

				//let equip_bag_cell = boss_base_model.GetBossKeyValue(this.boss_type, "min_equip_bag_cell")
				//let god_bag_cell = boss_base_model.GetBossKeyValue(this.boss_type, "min_god_bag_cell")
				if (boss_info.lv - role_mgr.GetMainRoleVo().level >= BossModel.HIGT_LEVEL_TIPS_VALUE) {
					local_Alert.Show("该大妖等级较高，挑战可能比较困难。<br>是否继续前往?", local_Alert_Type.Two, check_vip, null, "前往", "取消")
					return
				}
				check_vip()
			}, this, true)

			this.BindEvent(boss_base_model, local_BossBaseModel.UPDATE_PLAYER_NUM, (scene_id?, player_num?) => {
				if (this.use_delete_method) { return }
				let boss_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
				if (this.select_boss_id) {
					let cur_scene = (boss_cfgs && boss_cfgs[this.select_boss_id]) && boss_cfgs[this.select_boss_id].scene
					if (scene_id == cur_scene) {
						this._lb_people_num.innerHTML = "当前场景内人数：<font color = '#00fa64'>" + player_num + "</font>"
					}
				}
			})

			Util.AddClickEvent(this._gp_vip, () => {
				let boss_info = this.boss_layer_info[this.now_layer][this.now_index]
				if ((this.now_layer == 0 && boss_info.free_vip >= 0) && this.vip_flag < boss_info.free_vip) {
					local_OpenFun.OpenFunHandler(23)
				} else if ((this.now_layer == 0 && this.vip_flag >= boss_info.free_vip) && vip_model.GetNobleCardState() == 0) {
					local_OpenFun.OpenFunHandler(23)
				}
			}, this, true)
		}

		this.UpdateView = () => {
			let list = this.boss_info.boss_info
			this.boss_layer_info = []
			let layers = 0
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				let layer = vo.layer
				if (layer || layer == 0) {
					if (!this.boss_layer_info[layer]) {
						this.boss_layer_info[layer] = []
						layers = layers + 1
					}
					table.insert(this.boss_layer_info[layer], vo)
				}
			}
			for (let layer in this.boss_layer_info) {
				table.sort(this.boss_layer_info[layer], (a, b) => {
					return a.lv < b.lv
				})
			}
			let layer = this.now_layer != null && this.now_layer || this.defalut_layer
			let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag
			let role_level = RoleManager.GetInstance().mainRoleInfo.level


			if(this.skip_boss_id){
							for (let i = this.boss_layer_info.length - 1; i >= 0; i--) {
								let list_temp_1 = this.boss_layer_info[i]
								let boss_vo = list_temp_1[0]

								//设置层级
								layer = i
					let is_break = false
					//找到有缘的boss
								for (let p = list_temp_1.length - 1; p >= 0; p--) {
									boss_vo = list_temp_1[p]
						if (boss_vo.boss_id == this.skip_boss_id) {

									//设置每层的index
									this.select_index = p
							this.select_boss_id = this.skip_boss_id
							is_break = true
							this.skip_boss_id=null
							break;
								}
					}
					if(is_break){
								break
							}
				}
			}else{
				if (role_vip >= BossModel.BOSS_ABYSS_OPEN_VIP_LV) {
					if (!BossModel.GetInstance().GetBossAbyssRed()) {
						//boss之家没有红点 选中一只最合适的boss   等级限制/vip免费等级
						if (this.boss_layer_info && this.boss_layer_info.length > 0) {
							if (this.now_layer == null && !this.select_boss_id) {
							for (let i = this.boss_layer_info.length - 1; i >= 0; i--) {
								let list_temp_1 = this.boss_layer_info[i]
								let boss_vo = list_temp_1[0]
									// if (role_vip < boss_vo.enter_vip) continue //vip等级不够
								if (role_vip < boss_vo.free_vip) continue //vip等级不能免费打
								if (role_level < boss_vo.lv) continue	//等级比该层最菜的boss都小
								//设置层级
								layer = i
	
									//找一只稍微比自己等级低一丢丢的boss
								for (let p = list_temp_1.length - 1; p >= 0; p--) {
									boss_vo = list_temp_1[p]
										if (role_level < boss_vo.lv) continue
										this.select_boss_id = boss_vo.boss_id
										//设置每层的index
										this.select_index = p
	
										break
									}
									break
							}
						}
					}
				} else {
					//免费层有红点，找一只最高等级的
					let is_free_find = false
					if (this.boss_layer_info && this.boss_layer_info.length > 0) {
						if (this.now_layer == null && !this.select_boss_id) {
							let is_find = false//免费层是否有红点
							for (let i = this.boss_layer_info.length - 1; i >= 0; i--) {
								if (!BossModel.GetInstance().CheckBossAbyssLayer(i)) continue
								let list_temp_2 = this.boss_layer_info[i]

								let boss_vo
								for (let p = list_temp_2.length - 1; p >= 0; p--) {
									boss_vo = list_temp_2[p]
									if (role_vip < boss_vo.free_vip) continue //vip等级不能免费打
									if (!boss_base_model.CheckBossRemainState(boss_vo)) continue

									//设置层级
									layer = i
									//直接最高等级
									this.select_boss_id = boss_vo.boss_id
									this.select_index = p
									is_find = true
									break
								}


								if(is_find){
									break
								}
								
							}

							//选中等级最大的有红点的boss
							if (!is_find) {
								for (let i = this.boss_layer_info.length - 1; i >= 0; i--) {
									if (!BossModel.GetInstance().CheckBossAbyssLayer(i)) continue
									let list_temp_3 = this.boss_layer_info[i]
									for (let p = list_temp_3.length - 1; p >= 0; p--) {
										let boss_vo = list_temp_3[p]

										if (!BossModel.GetInstance().CheckBossRemainState(boss_vo)) continue
										this.select_boss_id = boss_vo.boss_id
										//设置每层的index
										this.select_index = p
										layer = i
										break
									}
									break
								}
							}
						}
					}
				}
				}
			}



			//再加一层保底
			if (this.now_layer == null && !this.select_boss_id && this.boss_layer_info[0]) {
				this.select_boss_id = this.boss_layer_info[0][0].boss_id
				layer = 0
				this.select_index = 0
			}
			this.now_layer = layer

			if (!this.tab_loop_mgr) {
				let i = 0
				do {
					let str = i == 0 && "共享层" || `${i}层`
					let obj = { label: str, boss_type: BossModel.BossType.abyss, layer: i }
					table.insert(this.tab_list, obj)
					i = i + 1
				} while ((i < layers))
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._Scroller1, BossFieldTabItem, this.tab_list, LoopScrCon.Horizontal, 1, (index?) => {
					this.SwitchLayer(index)
				}, layer)
			}
			this.tab_loop_mgr.SetSelectIndex(layer)
			// this.tab_loop_mgr.CenterOnChild(layer)

			this.UpdateLayerMapView()
			this.updateLayer(this.now_layer)
			this.initRequestTimer()


			this._Scroller1.tweenTo(layer - 2, 400)
		}

		this.UpdateLayerMapView = () => {
			if (!this) {
				return
			}
			this.cur_layer_boss_info_list = this.boss_layer_info[this.now_layer]
			let count = 0
			let bg = this.bgConfig && this.bgConfig[this.boss_type]
			let pos_list = null
			if ((bg && bg[Number(this.now_layer)]) && bg[Number(this.now_layer)]["pos"]) {
				pos_list = bg[Number(this.now_layer)]["pos"]
			}
			let i = 0
			do {
				let info = this.cur_layer_boss_info_list[i]
				let boss_item = this.cur_layer_boss_list[i]
				let _gp = this["_Group" + (i + 1)]
				_gp.visible = true
				if (!boss_item) {
					let callFun = (item?) => {
						let _index = item.index
						if (_index == this.select_index) {
							return
						}
						this.cur_layer_boss_list[_index].SetSelect(true)
						this.cur_layer_boss_list[this.select_index].SetSelect(false)
						this.SwitchRoom(_index)
						this.select_index = _index
					}
					boss_item = new BossSuitItem(_gp)
					boss_item.Load()
					boss_item.setFun(2, callFun, i)
					//boss_item.cur_index = i
					this.cur_layer_boss_list[i] = boss_item
					//table.insert(this.cur_layer_boss_list, boss_item)
				} else {
					if (boss_item.is_loaded) {
						boss_item.display_obj.visible = true
					}
				}
				if (pos_list) {
					let pos = pos_list[i]
					SetAnchoredPosition(_gp, pos.x, pos.y)
				}
				boss_item.ExcuteCallback(() => {
					boss_item.SetData(info)
					if (this.select_index == boss_item.index) {
						this.select_boss_id = info.boss_id
						boss_item.SetSelect(true)
					} else {
						boss_item.SetSelect(false)
					}
				})

				count = count + 1
				i = i + 1
			} while ((i < this.cur_layer_boss_info_list.length))
			if (this.cur_layer_boss_list.length > count) {
				let i = count
				do {
					let _gp = this["_Group" + (i + 1)]
					_gp.visible = false
					let boss_item = this.cur_layer_boss_list[i]
					if (boss_item && boss_item.display_obj) {
						boss_item.display_obj.visible = false
					}
					i = i + 1
				} while ((i < this.cur_layer_boss_list.length))
			}
			this.SwitchRoom(this.select_index)
		}

		this.SetData = (boss_info?) => {
			this.boss_info = boss_info
			if (this.is_loaded) {
				this.UpdateView()
			} else {
				this.need_refreshData = true
			}
		}

		this.SetClickCallBack = (switch_call_back?) => {
			this.switch_call_back = switch_call_back
		}

		this.SwitchRoom = (index?) => {
			if (index == this.now_index) {
				return
			}
			this.now_index = index
			if (this.boss_layer_info && this.switch_call_back) {
				let info = this.boss_layer_info[this.now_layer]
				this.switch_call_back(info && info[index], this.now_layer)
			}
			this.UpdateEnterMsg()
		}

		this.SwitchLayer = (index?) => {
			let layer = index
			if (layer == this.now_layer) {
				return
			}
			this.select_index = 0
			this.updateLayer(layer)
		}

		this.updateLayer = (layer?) => {
			layer = Number(layer)
			if (layer != 0) { //共享层不限制
				let open_lv = this.boss_layer_info[Number(layer)][0].open_lv
				let role_lv = role_mgr.GetMainRoleVo().level
				if (role_lv < open_lv) {
					let dec = "玩家达到" + open_lv + "级可进入"
					local_Message.show(dec)
					this.tab_loop_mgr.SetSelectIndex(this.now_layer)
					return
				}
			}
			let bg = this.bgConfig && this.bgConfig[this.boss_type]
			if ((bg && bg[layer + 1]) && bg[layer + 1]["small_bg"]) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_map, bg[layer + 1]["small_bg"])
			}
			this.now_layer = layer
			this.now_index = null
			this.UpdateLayerMapView()
			this.SwitchRoom(this.select_index)
			this.RequestPlayerNum()
		}

		this.UpdateEnterMsg = () => {
			// if (this.Underline) {
			// 	this.Underline.transform.GetComponent("Text").text = ""
			// }
			let boss_info = this.boss_layer_info[this.now_layer][this.now_index]
			if (boss_info) {
				let bool = false
				this.labelDisplay.text = "V" + boss_info.free_vip + "立即进入"
				if (boss_info.free_vip >= 0 && this.vip_flag >= boss_info.free_vip) {
					bool = true
					//if (this.now_layer > 1 ) {
					// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
					// 	this._lb_vip_tips.text = "VIP " + boss_info.free_vip + " Masuk Gratis"
					// } else {
					// 	this._lb_vip_tips.text = "VIP" + boss_info.free_vip + "可免费进入"
					// }
					this._lb_vip_tips.innerHTML = "VIP" + boss_info.free_vip + "可免费进入"
					//}else{
					//if (vip_model.GetNobleCardState() == 0 ) {
					//this._lb_vip_tips.textFlow = Util.StrToHTML("<font color=" + local_ColorUtil.GetColorLight(ColorType.GREEN) + ">需先激活VIP特权卡</font>")
					//this.Underline = AddUnderlineText(this._lb_vip_tips, this._lb_vip_tips, local_ColorUtil.GetColorLight(ColorType.GREEN), 3 , 5 )
					//}else{
					//this._lb_vip_tips.textFlow = Util.StrToHTML("<font color=" + local_ColorUtil.GetColorLight(ColorType.GREEN) + ">已激活VIP特权卡</font>",this.Underline)
					//}
					//}
				} else {
					if (this.now_layer > 1) {
						let enter_cost = boss_info.enter_cost
						let cost = enter_cost && enter_cost[0]
						if (cost) {
							let type_id, lock = goods_model.GetMappingTypeId(cost[0], cost[1])
							let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
							this._lb_cost.text = cost[2]
							if (goods_vo) {
								ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost_icon, "client/assets/icon/goodsIcon/" + goods_vo.goods_icon + ".png")
							}
						}
						if (this.vip_flag < boss_info.enter_vip) {
							this._lb_vip_tips.innerHTML = "VIP" + boss_info.enter_vip + "可消耗"
						} else {
							this._lb_vip_tips.innerHTML = "VIP等级不足,可消耗"
						}
					} else {
						this._lb_vip_tips.innerHTML = Util.StrToHTML("<font color=" + ColorUtil.TransHtmlColor(Enum_ColorUtil_NEW.LIGHT_GREEN) + ">VIP" + boss_info.enter_vip + "可免费进入</font>")
						// Temp
						//this.Underline = AddUnderlineText(this._lb_vip_tips, this._lb_vip_tips, local_ColorUtil.GetColorLight(ColorType.GREEN), 3, 5, this.Underline)
						bool = true
					}
					this.CallLater(() => {
						this._lb_vip_tips.event("resize")
					})
				}
				this._lb_cost.visible = !bool
				this._img_cost_icon.visible = !bool
				this.Text.visible = !bool
			}
		}

		this.SetSelectBoss = (boss_id?) => {
			this.skip_boss_id = boss_id
		}
	}

	public DeleteMe() {
		if (this.cur_layer_boss_list.length > 0) {
			for (let index in this.cur_layer_boss_list) {
				//let group = this.cur_layer_boss_list[index]._gp_boss_icon
				this.cur_layer_boss_list[index].DeleteMe()
			}
		}
		this.cur_layer_boss_list = []
		if (this.requestTimer) {
			GlobalTimerQuest.CancelQuest(this.requestTimer)
			this.requestTimer = null
		}
		this.clickTime = null
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_map: Laya.Image
	_Scroller1: Laya.List
	_gp_bossitem: Laya.Box
	_Group1: Laya.Box
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Group4: Laya.Box
	_Group5: Laya.Box
	_Group6: Laya.Box
	_Group7: Laya.Box
	_Group8: Laya.Box
	_btn_go: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Group9: Laya.Box
	_gp_cost: Laya.HBox
	_gp_vip: Laya.HBox
	_lb_vip_tips: Laya.HTMLDivElement
	_img_cost_icon: Laya.Image
	_lb_cost: Laya.Label
	Text: Laya.Label
	_lb_people_num: Laya.HTMLDivElement
	_Label1: Laya.Label
	_img_left: Laya.Image
	_img_right: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_map,
			this._Scroller1,
			this._gp_bossitem,
			this._Group1,
			this._Group2,
			this._Group3,
			this._Group4,
			this._Group5,
			this._Group6,
			this._Group7,
			this._Group8,
			this._btn_go,
			this._Image1,
			this.labelDisplay,
			this._Group9,
			this._gp_cost,
			this._gp_vip,
			this._lb_vip_tips,
			this._img_cost_icon,
			this._lb_cost,
			this.Text,
			this._lb_people_num,
			this._Label1,
			this._img_left,
			this._img_right,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_map",
				"_Scroller1",
				"_gp_bossitem",
				"_Group1",
				"_Group2",
				"_Group3",
				"_Group4",
				"_Group5",
				"_Group6",
				"_Group7",
				"_Group8",
				"_btn_go",
				"_Image1",
				"labelDisplay",
				"_Group9",
				"_gp_cost",
				"_gp_vip",
				"_lb_vip_tips",
				"_img_cost_icon",
				"_lb_cost",
				"Text",
				"_lb_people_num",
				"_Label1",
				"_img_left",
				"_img_right",
			])
	}
}
window["BossAbyssRoomItem"] = BossAbyssRoomItem