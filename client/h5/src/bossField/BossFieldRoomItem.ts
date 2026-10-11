import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, RefBoxChildsLayout, SetAnchoredPosition, SetAnchoredPositionX, SetHtmlStyle, TransformLevel, Util } from "../util/Util"
import { BossCommonRoomItem } from "./BossCommonRoomItem"
import { BossFieldTabItem } from "./BossFieldTabItem"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"

export class BossFieldRoomItem extends BaseItem1 {

	boss_info
	boss_info_list
	boss_layer_info
	clickTime
	defalut_index
	defalut_layer
	gp_add_effect
	init_tab
	need_refresh_data
	now_index
	now_layer
	select_boss_id
	switch_call_back
	tab_list
	time_id2
	/**是否在新手引导 打boss */
	is_guider
	back_vit //可找回体力值

	tab_loop_mgr: LoopScrowViewMgr
	item_loop_mgr: LoopScrowViewMgr
	boss_model: BossModel
	role_mgr: RoleManager
	scene_mgr: SceneManager
	time_id

	public constructor(parent?) {
		super(parent)
		this.base_file = "bossField"
		this.layout_file = "BossFieldRoomItem"

		this.defalut_layer = 0
		this.init_tab = false
		this.defalut_index = 0
		this.time_id2 = null
		this.back_vit = 0
		this.boss_model = BossModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

	}

	LoadSuccess = () => {
		SetHtmlStyle(this._lb_time_tip, { c: "#ffffff", f: 20, ww: false, w: 600 })
		this._list_room.vScrollBarSkin = ""
		this._html_vit.style.fontSize = 20
		this._html_vit.style.color = "#ffffff"

		if (this.need_refresh_data) {
			this.UpdateView(false)
			this.need_refresh_data = false
		}
		this.ShowAddEffect()
		this.InitEvent()

		if (!this.is_guider) {
			BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
		}
	}


	InitEvent = () => {


		this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_VIT_TIME, (scmd) => {
			this.ShowVit(scmd.vit, scmd.max_vit, scmd.add_vit, scmd.back_vit, scmd.last_vit_time)
		}
		)


		Util.AddClickEvent(this._box_go, () => {
			if (this.clickTime && TimeUtil.getServerTime() - this.clickTime < 0.5) {
				return
			}
			let info = this.boss_layer_info && this.boss_layer_info[this.now_layer]
			let boss_info = info && info[this.now_index]
			if (!boss_info) {
				return
			}
			let enter = (call?, needTire?) => {
				if (needTire == null) {
					needTire = true
				}
				let enter_func = () => {
					if (this.now_index || this.now_index == 0) {
						let fun = () => {
							this.boss_model.SetEnterBossInfo({
								boss_id: boss_info.boss_id,
								boss_type: boss_info.boss_type
							})
							this.boss_model.Fire(BossModel.SCMD_REQUEST, 46003, boss_info.boss_type, boss_info.boss_id)
							this.clickTime = TimeUtil.getServerTime()
						}

						if (call) {
							call(fun)
						} else {
							fun()
						}
					}
				}

				let lv = this.role_mgr.GetMainRoleVo().level
				if (lv < boss_info.open_lv) {
					let lv = boss_info.open_lv > 370 && "神创" + (boss_info.open_lv - 370) || boss_info.open_lv
					if (PlatformManager.IsEyouEnPlatform()) {
						Message.show(lv + "level to enter" + "Fl." + this.now_layer)
					} else {
						Message.show(lv + "级可进入第" + this.now_layer + "层")
					}
					return
				}
				if (boss_info.boss_type == BossModel.BossType.field || boss_info.boss_type == BossModel.BossType.field_infinite) {
					if (boss_info.lv - lv > BossModel.FIELD_HIGT_LEVEL_TIPS_VALUE) {
						Alert.Show("该大妖等级较高，挑战可能比较困难？<br>是否继续前往？", Alert_Type.Two, enter_func, null, "前往", "取消")
						return
					}
					if (lv - boss_info.lv > boss_info.drop_lv) {
						Alert.Show("与该大妖等级差距过大，击杀无奖励？<br>是否前往击杀？", Alert_Type.Two, enter_func, null, "前往", "取消")
						return
					}
				}

				enter_func()
			}

			if (this.scene_mgr.IsFieldBossScene() || this.scene_mgr.IsFieldSpecialBossScene() || this.scene_mgr.IsFieldInfiniteBossScene()) {
				let curr_scene_id = this.scene_mgr.curr_scene_id
				let type = this.boss_model.GetBossType()
				let layer = this.now_layer != 0 ? curr_scene_id - BossModel.BaseBossSceneId[type] : 0 //当前场景所在层数 
				// 无限层并入了第一层，需要特殊处理
				if(type ==BossModel.BossType.field_infinite){
					layer = 0
				}
				

				//选中boss所在的层级
				let boss_layer = null
				if(boss_info){
					boss_layer = boss_info.layer
				}else{
					boss_layer =this.now_layer 
				}

				if (layer == boss_layer) {
					let find = () => {
						this.boss_model.Fire(BossModel.CHANGE_BOSS_TARGET, null, boss_info.boss_id)
						GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "BossEnterView")
					}
					enter(find, false)
				} else {
					let call = (fun?) => {
						Alert.Show("是否离开当前场景？", Alert_Type.Two, () => {
							if (fun) {
								fun()
							}
						}, null, "离开", "取消")
					}

					enter(call, false)
				}
			} else {

				if(this.scene_mgr.IsNotChangeScene()){
					Message.show("当前场景不能进入")
					return
				}

				if (!this.scene_mgr.IsFieldScene()) {
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
		}, this, true)

		Util.AddClickEvent(this._img_add, (e?) => {
			BossModel.GetInstance().Fire(BossModel.OPEN_BOSS_TIRED_ALERT)
			//BossModel.GetInstance().Fire(BossModel.OPEN_VIT_VIEW, e.stageX, e.stageY)
		}, this, true)

		this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
			if (type_id != BossModel.tired_goods_id) {
				return
			}
			this.boss_info.all_tired = this.boss_info.all_tired + 1
			this.UpdateVit()
			this.ShowAddEffect()
		}
		)


		Util.AddClickEvent(this._lb_t2, (e?) => {
			if (this.back_vit) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldVitBuyView", this.back_vit)
			}

		}, this, true)

	}

	SetClickCallBack = (switch_call_back?) => {
		this.switch_call_back = switch_call_back
	}

	SetData = (boss_info?, is_init?, is_guider?) => {
		this.boss_info = boss_info
		this.is_guider = is_guider ? is_guider : false //是否是新手引导
		if (this.is_loaded) {
			this.UpdateView(is_init)
		} else {
			this.need_refresh_data = true
		}
	}

	UpdateVit = () => {
		if (this.now_layer == 0) {
			this._html_vit.innerHTML = `无限层不消耗体力`
			this._html_vit.style.width = 400
		}

		else {
			let green_color =ColorUtil.TransHtmlColor(Enum_ColorUtil_NEW.LIGHT_GREEN)
			let color = this.boss_info.tired == 0 ? Enum_ColorUtil_Light.RED : green_color
			this._html_vit.innerHTML = `体力值：&nbsp;${HtmlColorTxt(this.boss_info.tired + "", color)}${HtmlColorTxt("/" + this.boss_info.all_tired, green_color)}`
			this._html_vit.style.width = 400
		}
		RefBoxChildsLayout(this._box_ref, 4, null, true, "left")
	}


	InitBossLayerInfo = () => {
		let list = this.boss_info.boss_info
		let boss_type, vo, layer

		//初始化层数
		if (!this.tab_list || this.tab_list.length == 0) {
			this.tab_list = []
			let layer_dic = {}
			for (let _tmpi in list) {
				vo = list[_tmpi]
				layer = vo.layer
				boss_type = vo.boss_type
				if (layer /**|| layer == 0  无限层并入第一层*/) {
					if (!layer_dic[layer]) {
						layer_dic[layer] = true
						let data
						data = { layer: layer, label: layer == 0 ? "无限层" : layer + "层" }
						table.insert(this.tab_list, data)
					}
				}
			}

			if (boss_type == BossModel.BossType.fieldspecial) {
				for (let i = 1; i <= 8; i++) {
					if (!this.tab_list[i - 1]) {
						this.tab_list[i - 1] = { layer: i, label: i + "层" }
					}
				}
			}

			table.sort(this.tab_list, (a?, b?) => {
				return a.layer < b.layer
			})
		}

		//初始化boss信息
		this.boss_layer_info = {}
		for (let _tmpi in list) {
			vo = list[_tmpi]
			layer = vo.layer
			boss_type = vo.boss_type

			//屏蔽多人无限层数据
			if (vo.boss_type == BossModel.BossType.field && layer == 0) continue

			//无限层并入第一层的
			if (layer == 0) {
				if (!this.boss_layer_info[1]) {
					this.boss_layer_info[1] = []
				}
				table.insert(this.boss_layer_info[1], vo)
			} else {
				if (!this.boss_layer_info[layer]) {
					this.boss_layer_info[layer] = []
				}
				table.insert(this.boss_layer_info[layer], vo)
			}

		}

		let data
		for (let i in this.boss_layer_info) {
			data = this.boss_layer_info[i]
			data.sort(this.SortBossFunc)
		}

	}

	/**
	 *  打开界面时 默认选中规则
	 * @returns 
	 */
	private GetJumpData = () => {

		//bossid跳转
		if (this.select_boss_id) {
			for (let key in this.boss_layer_info) {
				let layer_info = this.boss_layer_info[key]
				for (let index = 0; index < layer_info.length; index++) {
					let info = layer_info[index]
					if (info.boss_id == this.select_boss_id) {
						let layer = info.layer==0?1:info.layer //无限层已经并入1层
						return [layer, index]
					}
				}
			}
		}


		//打开界面跳转
		let len = Util.TableSize(this.boss_layer_info)
		let main_role_level = this.role_mgr.GetMainRoleVo().level
		let boss_list
		let max_level, max_layer, max_index

		for (let layer = len; layer >= 0; layer -= 1) {
			boss_list = this.boss_layer_info[layer]
			if (boss_list) {
				let len = boss_list.length
				for (let index = len - 1; index >= 0; index -= 1) {
					let info = boss_list[index]
					let open_lv = info.open_lv, max_lv = info.max_lv, boss_lv = info.lv, drop_lv = info.drop_lv
					//是否有掉落
					let drop_bool = true
					if (drop_lv != 0) {
						drop_bool = Math.abs(main_role_level - boss_lv) < drop_lv
					}
					//是否达到可以开启boss的等级
					let level_bool = main_role_level >= open_lv && main_role_level <= max_lv && (main_role_level + 50) >= boss_lv
					if (level_bool && drop_bool) {
						if (index != 0 && info.reborn_time > TimeUtil.getServerTime()) continue
						let layer, item_index
						layer = info.layer==0?1:info.layer //无限层已经并入1层
						item_index = index
						return [layer, item_index]
					}


					//应该和新手任务有关系
					if (level_bool && (!max_level || boss_lv > max_level)) {
						max_layer = info.layer
						max_index = index
						max_level = boss_lv
					}

				}
			}

		}
		if (max_layer == 1 && this.boss_model.GuideTaskDone()) {
			max_layer = 1
			max_index = 0
		}
		return [max_layer, max_index]
	}



	/**
	 * 切页时选中boss规则
	 * @param layer 
	 * @returns 
	 */
	private GetBossIndex(layer) {

		let boss_list = this.boss_layer_info[layer]
		let main_role_level = this.role_mgr.GetMainRoleVo().level
		let boss_range = 50 //在这个等级范围内波动
		if (boss_list) {
			let len = boss_list.length

			let index_blackup = 0
			let record_lv = 0
			for (let index = len - 1; index >= 0; index -= 1) {
				let info = boss_list[index]
				let open_lv = info.open_lv, max_lv = info.max_lv, boss_lv = info.lv, drop_lv = info.drop_lv
				//是否有掉落
				let drop_bool = true
				if (drop_lv != 0) {
					drop_bool = Math.abs(main_role_level - boss_lv) < drop_lv
				}
				//是否达到可以开启boss的等级
				let level_bool = main_role_level >= open_lv && main_role_level <= max_lv && (main_role_level + boss_range) >= boss_lv
				if (level_bool && drop_bool) {
					if (index != 0 && info.reborn_time > TimeUtil.getServerTime()) continue
					let l, i
					l = info.layer
					i = index
					return i
				}

				if (boss_lv <= (main_role_level + boss_range) && boss_lv > record_lv) {
					index_blackup = index
					record_lv = boss_lv
				}

			}

			return index_blackup
		}

		return 0
	}


	is_update = false
	tab_record_list = null
	frist_open_tab_index = 0 //是否切换过tab 区别首次打开切页和手动切页
	/**
	 * 
	 * @param is_update 是否仅仅刷新boss的信息
	 */
	UpdateView = (is_update?) => {
		//初始化
		this.InitBossLayerInfo()

		//跳转
		let is_init = this.now_layer == null
		if (is_init) {
			let jump_data = this.GetJumpData()
			this.now_layer = jump_data[0]
			this.now_index = jump_data[1]
			this.frist_open_tab_index = this.now_layer
		}


		//刷新tab_bar
		if (this.tab_record_list != this.tab_list) {
			this.tab_record_list = this.tab_list //避免重复刷新

			for (let tab_index = 0; tab_index < this.tab_list.length; tab_index++) {
				let data = this.tab_list[tab_index]
				if (data.layer == this.now_layer) {
					if (!this.tab_loop_mgr) {
						this.tab_loop_mgr = new LoopScrowViewMgr()
						this.tab_loop_mgr.SetData(this._list_tab, BossFieldTabItem, this.tab_list, LoopScrCon.Horizontal, null, (index) => {

							let tab_data = this.tab_list[index]
							this.now_layer = tab_data.layer
							//boss 引导任务
							if (this.is_guider && index != 0) {
								this.tab_loop_mgr.SetSelectIndex(0)
								Message.show("【请先完成当前主线任务】")
								return
							}

							if (this.frist_open_tab_index != this.now_layer && this.frist_open_tab_index != 99) {
								this.frist_open_tab_index = 99  //==99说明手动切换过页签
							}


							if (is_update) {
								this.SwitchLayer(this.now_layer, this.now_index,is_update)
							} else {
								if (this.frist_open_tab_index == 99) {
									this.now_index = this.GetBossIndex(this.now_layer)
								}
								this.SwitchLayer(this.now_layer, this.now_index)
							}

							this.UpdateVit()
						}, tab_index)
					} else {
						this.tab_loop_mgr.replaceAll(this.tab_list)
						this.tab_loop_mgr.SetSelectIndex(this.now_layer)
					}
					break
				}
			}


			if (is_init) {
				is_init = false
				this._list_tab.tweenTo(this.now_layer - 2, 400)
			}

		}


		//刷新boss信息
		if (is_update) {
			this.SwitchLayer(this.now_layer, this.now_index,is_update)
			this.UpdateVit()
		}

	}


	/**
	 * 
	 * @param layer  
	 * @param item_index  选中第几个boss
	 * @param is_update   是否仅仅刷新boss信息
	 * @returns 
	 */
	SwitchLayer = (layer?, item_index?,is_update=false) => {
		if(!layer)return
		this.UpdateLayer(layer,item_index,is_update)
		RefBoxChildsLayout(this._box_ref, 4, null, true, "left")
		if (layer != 0) {
			this.AddUIEffect("ZengJia", this._box_time_effect, { x: 0, y: 0 }, 25, true)
		}
		else {
			this.ClearUIEffect(this._box_time_effect)
		}
	}


	private SortBossFunc(a, b){
		if (a.lv != b.lv) {
			return a.lv - b.lv
		} else {
			return a.layer - b.layer
		}
	}

	private UpdateLayer = (layer,item_index,is_update) => {
		this.boss_info_list = this.boss_layer_info[layer]
		if (this.boss_info_list && Util.TableSize(this.boss_info_list) > 0) {
			if (this.item_loop_mgr) {
				this._list_room.selectedIndex = -1
				this.item_loop_mgr.replaceAll(this.boss_info_list)
				this.item_loop_mgr.SetSelectIndex(item_index)

				if (this._list_room && this._list_room.scrollBar) {
					this.OnListRoomChange(this._list_room.scrollBar.value)
				}

			} else {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_room, BossCommonRoomItem, this.boss_info_list, LoopScrCon.Vertical, null, (index) => {
					this.now_index = index
					this.UpdateItem()
				}, item_index)

				this._list_room.scrollBar.changeHandler = Laya.Handler.create(this, this.OnListRoomChange, null, false)
			}
		}

		if(this.item_loop_mgr.hasInit&&!is_update){
			this._list_room.scrollTo(item_index)
		}
	}

	OnListRoomChange(value) {
		if (this._img_down && this._img_up) {
			if (this.boss_info_list && Util.TableSize(this.boss_info_list) > 0) {
				this._img_up.visible = this.boss_info_list.length > 6 && value >= (BossCommonRoomItem.HEIGT_UI / 2)
				this._img_down.visible = this.boss_info_list.length > 6 && (value < (this._list_room.scrollBar.max - BossCommonRoomItem.HEIGT_UI / 2))
			} else {
				this._img_up.visible = this._img_down.visible = false
			}
		}
	}


	UpdateItem = () => {
		if (this.boss_info_list && Util.TableSize(this.boss_info_list) > 0) {
			let boss = this.boss_info_list[this.now_index]

			if (this.switch_call_back) {
				this.switch_call_back(boss)
			}

			if (boss) {
				let level = this.role_mgr.GetMainRoleVo().level
				let open_lv = boss.open_lv
				let max_lv = boss.max_lv
				let open_state = level >= open_lv && level <= max_lv
				this._box_go.gray = !open_state
				if (!open_state) {
					if (PlatformManager.IsEyouIdnPlatform()) {
						let lv = open_lv > 370 && "Genesis Lv." + (open_lv - 370) || "Lv." + open_lv
						this._lb_go.text = lv
					}else if(PlatformManager.IsEyouEnPlatform()){
						this._lb_go.text = `Unlocks at Lv.${TransformLevel(open_lv)}`
						this._lb_go.fontSize = 16
					} else {
						this._lb_go.text = `${TransformLevel(open_lv)}级解锁`
						this._lb_go.fontSize = 18
					}
				} else {
					this._lb_go.text = "立即前往"
					this._lb_go.fontSize = 22
				}

				let main_line_vo = this.task_model.GetMainLineTaskVo()
				if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Kill_boss_id) && main_line_vo && main_line_vo.id == boss.boss_id && main_line_vo.has_finish != 1) {
					let finger = this.story_model.GetFinger(this, this._box_go)
					if (!finger) {
						let step = {
							"direction": 6,
							"text": "现在前往<font color='#0a9f42'>大妖</font>击杀大妖可获得大量装备奖励~",
							"effect_scaleX": 0.65,
							"effect_scaleY": 0.9
						}
						GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_go, "UI", 20, -20, null, null, step, true)
					}
				} else {
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_go)
				}
			}

		}


	}

	SetSelectBoss = (boss_id?) => {
		this.select_boss_id = boss_id
	}


	ShowAddEffect = () => {

		//let num = GoodsModel.GetInstance().GetTypeGoodsNum(BossModel.tired_goods_id)
		//let show = num > 0
		//if (show ) {
		//this:AddUIEffect2("ui_plussign_glow", this.gp_add_effect, null, {x=0.8, y=0.8}, true)
		//}else{
		//this:ClearUIEffect(this.gp_add_effect)
		//}
	}

	cur_vit = 0//防止无限刷新
	req_vit = -1 //请求更新时的vit
	last_vit_time = 0
	// vit:int16             // 体力值
	// max_vit:int16         // 最大体力值
	//add_vit                //已恢复的体力值
	// back_vit:int16        // 可找回的体力值
	// last_vit_time:int32   // 上次计算的体力值时间
	public ShowVit(vit?, max_vit?, add_vit?, back_vit?, last_vit_time?) {

		//this._lb_time_tip.visible = false
		this.last_vit_time = last_vit_time
		if (this.is_guider) return //新手引导跳过

		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
		//恢复一点体力所需要的时间
		let time = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_time", cfg)
		//每天最多恢复的体力上限
		let add_vit_max = BossModel.GetInstance().GetBossKeyValue(BossModel.BossType.field, "add_vit_max", cfg)


		//每天恢复达到上限
		if (add_vit >= Number(add_vit_max)) {
			this._lb_time_tip.visible = false
			this.ClearTimer()
		} else {
			this.cur_vit = vit
			if (vit >= max_vit) {
				this.ClearTimer()
				//体力已经回满  不显示提示
				this._lb_time_tip.visible = false
			} else {
				let v = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? 0.8 : 1
				let end_time = this.last_vit_time + /**(max_vit - vit) **/ time * v
				let time_func = () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time >= 0) {
						this._lb_time_tip.visible = true
						let time_str = TimeUtil.timeConvert(left_time, "mm:ss")
						let str_ = KaifuActivityModel.GetInstance().CheckHaveMonthCard() ? `${time_str}（月卡加速中）` : time_str
						this._lb_time_tip.innerHTML = `${HtmlColorTxt(str_, ColorUtil.TransHtmlColor(Enum_ColorUtil_NEW.LIGHT_GREEN))}后可恢复1点体力`
					} else {
						this.ClearTimer()
						// if (this.req_vit != this.cur_vit) {
						// 	this.req_vit = this.cur_vit
						// 	//刷新体力值
						// 	BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46043, BossModel.BossType.field)
						// } else {
						// 	//console.warn("测试：倒计时停止")
						// }

					}

				}

				//倒计时
				if (!this.time_id) {
					this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
						time_func()
					}, 1, -1)
					time_func()
				}


			}
		}



		//可找回体力
		this.back_vit = back_vit
		if (back_vit > 0) {
			this._lb_t1.text = `可找回体力值：${back_vit}点`
			this._lb_t2.visible = true
			this._lb_t2.x = this._lb_t1.x + this._lb_t1.textField.textWidth + 10
		} else {
			this._lb_t1.text = `已找回全部体力值`
			this._lb_t2.visible = false
		}

		RefBoxChildsLayout(this._box_ref, 4, null, true, "left")

	}

	public ClearTimer() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public ClearTimeId() {
		if (this.time_id2) {
			clearTimeout(this.time_id2)
			this.time_id2 = null
		}
	}

	public DeleteMe() {

		if (this._list_room && this._list_room.scrollBar&&this._list_room.scrollBar.changeHandler) {
			this._list_room.scrollBar.changeHandler.recover()
			this._list_room.scrollBar.changeHandler = null
		}

		this.ClearUIEffect(this._box_time_effect)
		this.ClearTimeId()
		if (this.tab_loop_mgr) {
			this.tab_loop_mgr.DeleteMe()
			this.tab_loop_mgr = undefined
		}
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = undefined
		}
		this.clickTime = null
		this.ClearTimer()
		super.DeleteMe()
	}


_img_bg:Laya.Image
_img_left:Laya.Image
_img_right:Laya.Image
_list_room:Laya.List
_img_down:Laya.Image
_img_up:Laya.Image
_list_tab:Laya.List
_lb_time_tip:Laya.HTMLDivElement
_box_go:Laya.Box
_img_go:Laya.Image
_lb_go:Laya.Label
_box_ref:Laya.Box
_html_vit:Laya.HTMLDivElement
_btn_add:Laya.Box
_img_add:Laya.Image
_box_time_effect:Laya.Box
_lb_t1:Laya.Label
_lb_t2:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_left,
this._img_right,
this._list_room,
this._img_down,
this._img_up,
this._list_tab,
this._lb_time_tip,
this._box_go,
this._img_go,
this._lb_go,
this._box_ref,
this._html_vit,
this._btn_add,
this._img_add,
this._box_time_effect,
this._lb_t1,
this._lb_t2,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_left",
"_img_right",
"_list_room",
"_img_down",
"_img_up",
"_list_tab",
"_lb_time_tip",
"_box_go",
"_img_go",
"_lb_go",
"_box_ref",
"_html_vit",
"_btn_add",
"_img_add",
"_box_time_effect",
"_lb_t1",
"_lb_t2",
])
}
}
 window["BossFieldRoomItem"]= BossFieldRoomItem