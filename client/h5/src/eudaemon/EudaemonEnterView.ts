import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { CrossServerViewIndex } from "../commonController/BossController"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { HtmlColorTxt, RefBoxChildsLayout, SetHtmlStyle, TransformLevel, Util } from "../util/Util"
import { EudaemonEnterTabItem } from "./EudaemonEnterTabItem"
import { EudaemonEnterItem } from "./EudaemonEnterItem"
import "./EudaemonTaskView"
import { table } from "../common/table"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { ShopModel } from "../commonModel/ShopModel"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"

export class EudaemonEnterView extends BaseItem1 {
	select_boss_id
	monter_res
	hunting_reward
	boss_info
	reward_item_list
	cross_server_boss_type
	show_model
	info
	cross_server_boss_info
	boss_layer_info
	now_tab_index    //层级
	now_select_index //当前选中list的index
	// tab_item_list
	defalut_index
	mon_res

	item_loop: LoopScrowViewMgr
	tab_item_list: Array<EudaemonEnterTabItem>
	is_frist_open = true

	erlang_parser: ErlangParser
	boss_model: BossModel
	goods_model: GoodsModel
	res_mgr: ResManager
	role_mgr: RoleManager
	scene_mgr: SceneManager
	private giftItem: GiftPushIcon;
	public constructor(parent?) {
		super(parent)
		this.base_file = "eudaemon"
		this.layout_file = "EudaemonEnterView"

		this.cross_server_boss_type = BossModel.BossType.holy
		this.boss_model = BossModel.GetInstance()

		this.erlang_parser = ErlangParser.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()


		this.defalut_index = 0

		this.load_callback = () => {
			this.boss_model.EduLoginRedBreak()
			this.LoadSuccess()
		}
	}

	public CustomMehod = (index?, args?) => {
		this.select_boss_id = args && args[0]
	}

	public LoadSuccess() {
		this._html_hunting_level.style.color = "#c37a45"
		this._html_hunting_level.style.fontSize = 20
		this._html_hunting_level.style.wordWrap = false


		this._html_tired.style.color = "#9b572f"
		this._html_tired.style.fontSize = 20
		this._html_tired.style.wordWrap = false
		this._html_tired.style.bold = true

		this._html_info.style.color = "#2d0b00"
		this._html_info.style.strokeColor = "#fffaf1"
		this._html_info.style.stroke = 2
		this._html_info.style.fontSize = 18
		this._html_info.style.wordWrap = false

		this._panel_item.vScrollBarSkin = ""
		this._panel_reward.vScrollBarSkin = ""

		this.hunting_reward = new EquipmentItem(this._box_hunt_reward)
		this.hunting_reward.SetItemSize(70, 70)
		this.hunting_reward.Load()

		// this.res_mgr.SetOutsideImageSprite(this, this.rightBg, GameResPath.GetIcon("suitboss", "ssl_009"), true)
		// this.res_mgr.SetOutsideImageSprite(this, this._Image4, GameResPath.GetIcon("suitboss", "uimh_023"))
		// this.res_mgr.SetOutsideImageSprite(this, this.bg2, GameResPath.GetIcon("suitboss", "uissl_011a"))

		this.InitEvent()
		this.InitView()
		this.ShowGiftIcon();
		this.ShowShop()
		this.CheckShopRed()
		this.UpdateBosxData()
	}

	public InitEvent() {

		this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
			this.ShowGiftIcon();
		})

		this.BindEvent(this.boss_model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {
			if (boss_type == this.cross_server_boss_type || boss_type == BossModel.BossType.holy_wuxian) {
				if (this.is_frist_open) {
					this.UpdateView()
				} else {
					if (this.boss_info) {
						let boss_info = this.boss_model.GetBossInfo(this.boss_info.boss_type, this.boss_info.boss_id)
						if (boss_info) {
							this.SwitchView(boss_info)
						}
					}
				}
			}
		}
		)

		this.BindEvent(this.boss_model, BossModel.BOSS_EUDA_REMIAN_UPDATE, (scmd?) => {
			let boss_info = this.boss_model.GetBossInfo(scmd.boss_type, scmd.boss_id)
			if (boss_info) {
				//更新数据源
				for(let key in this.boss_layer_info){
					let list = this.boss_layer_info[key]
					for(let i = 0 ;i<list.length;i++){
						if(list[i]&&list[i].boss_id==boss_info.boss_id){
							this.boss_layer_info[key][i] = boss_info
						}
					}
				}
				//更新关注状态
				if (this.boss_info&&this.boss_info.boss_id==boss_info.boss_id) {
					let boss_info = this.boss_model.GetBossInfo(this.boss_info.boss_type, this.boss_info.boss_id)
					if (boss_info) {
						this.SwitchView(boss_info)
					}
				}
			}
		})
		this.BindEvent(this.boss_model, BossModel.UPDATE_HUNTING_INFO, () => {
			this.UpdateHuntingLevelData()
			this.UpdateHuntingLevelReward()
		}
		)
		this.BindEvent(this.boss_model, BossModel.KILL_BOSS, (scmd?) => {
			if (scmd.boss_type == BossModel.BossType.holy) {
				this.UpdateBosxData()
			}
		})
		this.BindEvent(this.boss_model, BossModel.UPDATE_MON_POS, () => {
			this.UpdateBosxData()
		})
		this.BindEvent(this.boss_model, BossModel.PUSH_MSG, (key, val) => {
			this.UpdateBosxData()
		})


		Util.AddClickEvent(this._box_attention, () => {
			if (this.boss_info) {
				let state = this.boss_info.is_remind ? 0 : 1
				if (this.boss_info.boss_type == BossModel.BossType.holy_wuxian)
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 46007, this.boss_info.boss_type, this.boss_info.boss_id, state, 0)
				else
					this.boss_model.Fire(BossModel.SCMD_REQUEST, 47005, this.boss_info.boss_type - BossModel.cross_boss_base_index, this.boss_info.boss_id, state)
			}
		}, this, true)

		//this._gp_model_con.addEventListener(local_laya.TouchEvent.TOUCH_TAP,() => {
		//if (this.boss_info ) {
		//this.boss_model.Fire(BossModel.OPEN_TIPS_VIEW, this.boss_info.boss_id)
		//}
		//}
		//, this, true)

		Util.AddClickEvent(this._img_tips, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.BossEudaemon)
		}
			, this, true)

		Util.AddClickEvent(this._img_drop, () => {
			this.boss_model.Fire(BossModel.OPEN_DROP_RECORD_VIEW, BossModel.BossType.eudaemon)
		}
			, this, true)

		Util.AddClickEvent(this._img_task, () => {
			if (!this.boss_model.eudaemon_has_click) {
				this.boss_model.eudaemon_has_click = true
				this._img_task_red.visible = false
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss, this.boss_model.GetEudaemonRed())
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "6210")
			}
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EudaemonTaskView")
			// GlobalEventSystem.Fire(EventName.OPEN_WEEKEND_ACTIVITY_VIEW, "EudaemonTaskView")
		}, this, true)


		Util.AddClickEvent(this._box_challenge, () => {
			let boss_info = (this.boss_layer_info && this.boss_layer_info[this.now_tab_index]) && this.boss_layer_info[this.now_tab_index][this.now_select_index]
			if (!boss_info) {
				return
			}
			let level = this.role_mgr.GetMainRoleLevel()
			let open_lv = boss_info.open_lv
			let max_lv = boss_info.max_lv
			let open_state = level >= open_lv && level <= max_lv
			if (!open_state) {
				Message.show("您的等级不符")
				return
			}
			let config_boss_type_key_value = Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value
			let equip_bag_cell = this.boss_model.GetBossKeyValue(this.cross_server_boss_type, "min_equip_bag_cell", config_boss_type_key_value)
			let god_bag_cell = this.boss_model.GetBossKeyValue(this.cross_server_boss_type, "min_god_bag_cell", config_boss_type_key_value)
			if (!GoodsModel.GetInstance().CheckEquipNum(equip_bag_cell, god_bag_cell)) {
				return
			}
			let enter_func = () => {
				if (boss_info) {
					this.boss_model.SetEnterBossInfo({ boss_id: boss_info.boss_id })

					let boss_type = boss_info.boss_type == BossModel.BossType.holy_wuxian ? boss_info.boss_type : boss_info.boss_type - BossModel.cross_boss_base_index
					let team_info = TeamModel.GetInstance().team_info
					if (team_info && team_info.team_id) {
						Alert.Show("组队状态无法进入蜃气楼,是否退出队伍?", Alert_Type.Two, () => {
							TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
							if (boss_type == BossModel.BossType.holy_wuxian)
								this.boss_model.Fire(BossModel.SCMD_REQUEST, 46003, boss_type, boss_info.boss_id)
							else
								this.boss_model.Fire(BossModel.SCMD_REQUEST, 47003, boss_type, boss_info.boss_id)
						})
					} else {
						if (boss_type == BossModel.BossType.holy_wuxian)
							this.boss_model.Fire(BossModel.SCMD_REQUEST, 46003, boss_type, boss_info.boss_id)
						else
							this.boss_model.Fire(BossModel.SCMD_REQUEST, 47003, boss_type, boss_info.boss_id)
					}
				}
			}

			if (this.scene_mgr.IsHolyBossScene()) {

				let curr_scene_id = this.scene_mgr.curr_scene_id
				let type = this.boss_model.GetBossType()
				let layer = curr_scene_id - BossModel.BaseBossSceneId[type]
				if (type == this.cross_server_boss_type && layer == this.now_tab_index && this.now_tab_index != 0) {
					this.boss_model.Fire(BossModel.CHANGE_BOSS_TARGET, null, boss_info.boss_id)
					GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "CrossServerEnterView")
				} else {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						enter_func()
					}, null, "离开", "取消")
				}
			} else {

				if (this.scene_mgr.IsNotChangeScene()) {
					Message.show("当前场景不能进入")
					return
				}

				if (!this.scene_mgr.IsFieldScene()) {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						enter_func()
					}, null, "离开", "取消")
				} else {
					enter_func()
				}
			}
		}
			, this, true)




		Util.AddClickEvent(this._img_shop, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldSoulShopView")
		}, this, true)


		this.BindEvent(this.boss_model, BossModel.BOSS_EUDA_BOSS_UPDATE_VIEW, () => {
			this.SwitchLayer(this.GetMaxLayers(), false)
		})

		this.BindEvent(this.boss_model, BossModel.BOSS_EUDA_UPDATE_BOSS_ROOM, (index) => {
			this.ItemListClick(index)
		})


	}

	public InitView() {
		this.boss_model.Fire(BossModel.SCMD_REQUEST, 47000, this.cross_server_boss_type - BossModel.cross_boss_base_index)
		this.boss_model.Fire(BossModel.SCMD_REQUEST, 46000, BossModel.BossType.holy_wuxian)
		this.boss_model.Fire(BossModel.SCMD_REQUEST, 47019)
		this.UpdateHuntingLevelData()
		if (!this.boss_model.eudaemon_has_click) {
		this._img_task_red.visible = this.boss_model.GetEudaemonRed()
		} else {
			this._img_task_red.visible = false
		}
		// this.UpdateView()
	}

	public SwitchView(info?) {
		if (this.use_delete_method) {
			return
		}
		if (!info) {
			return
		}
		this.boss_info = info
		let cfgs = Config.PRELOAD_SERVER_CONFIG.config_eudemons_boss_cfg
		let boss_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_eudemons_boss_cfg.name, info.boss_id, false, cfgs)
		let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, info.boss_id, false)
		this._lb_boss_name.text = `Lv.${mon_cfg.lv} ${info.boss_name}`
		let level = this.role_mgr.GetMainRoleLevel()
		let open_lv = info.open_lv
		let max_lv = info.max_lv
		let open_state = level >= open_lv && level <= max_lv

		this._img_attention.visible = info.is_remind

		let rewards = JSON.parse(boss_cfg.ratio_goods)
		let career = this.role_mgr.GetMainRoleCareer()
		let reward_list = []
		for (let _tmpi in rewards) {
			let vo = rewards[_tmpi]
			if (Number(vo[0]) == career) {
				reward_list = vo[1]
				break
			}
		}
		let config_eudemons_boss_exp = Config.PRELOAD_SERVER_CONFIG.config_eudemons_boss_exp
		let cfg = config_eudemons_boss_exp && config_eudemons_boss_exp[info.boss_id]
		if (cfg) {
			this._html_info.innerHTML = `狩猎经验:<font color='#c45937'>${cfg.eudemons_exp}</font>悬赏积分:<font color='#c45937'>${cfg.kill_score}</font>`
		}
		this.ShowRewardItem(reward_list)
		this.ShowModel(info.icon)
		this.UpdateHuntingLevelReward()
	}

	public ShowRewardItem(reward_list?) {
		let len = reward_list.length
		if (!this.reward_item_list) {
			this.monter_res = this.boss_info.icon
			this.reward_item_list = []
		}
		let i = len
		if (i < this.reward_item_list.length) {
			do {
				this.reward_item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.reward_item_list.length))
		}
		for (let i in reward_list) {
			let vo = reward_list[i]
			let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
			let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				let item = this.reward_item_list[i]
				if (!item) {
					item = new EquipmentItem(this._panel_reward)
					this.reward_item_list[i] = item
					item.SetItemSize(70, 70)
					item.SetPosition(Number(i) % 3 * 81, Math.floor((Number(i) / 3)) * 77)
					item.Load()
				}
				item.SetVisible(true)
				item.SetData(goods_vo.type_id, vo[2], lock)
			}
		}
	}

	public ShowModel(mon_res) {
		if (this.mon_res == mon_res) return
		this.mon_res = mon_res
		let action_name_list = ["attack", "idle"]

		let data = {
			clothe_res_id: mon_res,
			type: UI_MODEL_TYPE.MONSTER,
			action_name_list: action_name_list,
			layout_file: "EudaemonEnterView"
		}
		ResManager.GetInstance().SetRoleModel(this, this._box_model_con, data)
	}


	public UpdateHuntingLevelData() {
		let data = this.boss_model.GetHuntingLevelData()
		if (data) {
			let desc = "狩猎等级:"
			let color = Enum_ColorUtil_Dark.GREEN
			desc += HtmlColorTxt(data.level, color)

			let config_eudemons_lv = Config.PRELOAD_SERVER_CONFIG.config_eudemons_lv
			let next_cfg = config_eudemons_lv && config_eudemons_lv[data.level + 1]
			if (next_cfg) {
				desc += HtmlColorTxt(`(${data.exp}/${next_cfg.exp})`, color)
			}
			this._html_hunting_level.innerHTML = desc
		}
	}

	public UpdateHuntingLevelReward() {

		let data = this.boss_model.GetHuntingLevelData()
		if (data && this.boss_info) {
			let config_eudemons_boss_reward = Config.PRELOAD_SERVER_CONFIG.config_eudemons_boss_reward
			let cfg = config_eudemons_boss_reward && config_eudemons_boss_reward[this.boss_info.boss_id + "@" + data.level]
			if (cfg) {
				let reward = JSON.parse(cfg.rewards)[0]
				let [type_id, lock] = this.goods_model.GetMappingTypeId(reward[0], reward[1])
				let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					this.hunting_reward.SetData(type_id, reward[2])
				}
			}
		}
	}

	/**
	 * 
	 * @param layer 
	 * @param is_update_index 是否重新选中index
	 * @returns boo  是否切页成功
	 */
	public SwitchLayer(layer, is_select_index?) {

		let layer_info = this.boss_layer_info[layer]
		if (layer_info) {
			let vo = layer_info[0]
			let role_lv = this.role_mgr.GetMainRoleLevel()
			if (vo && vo.open_lv > role_lv) {
				Message.show(TransformLevel(vo.open_lv) + "级开启蜃气楼" + (Number(layer)) + "层")
				return false
			}
			this.now_tab_index = layer
			this.UpdateMsg(layer)
			this.UpdateRoomList(layer, is_select_index)

		}
		return true
	}


	/***获取已经解锁的最高层layers */
	private GetMaxLayers() {
		// let left_times = 0
		// if(this.cross_server_boss_info){
		// 	left_times = this.cross_server_boss_info.max_tired - this.cross_server_boss_info.tired
		// }

		// if(left_times<=0){
		// 	return 0
		// }


		if (!this.boss_layer_info) return 0
		let index = 0
		let role_lv = this.role_mgr.GetMainRoleLevel()
		for (let i = 0; i < this.boss_layer_info.length; i++) {
			let layer_info = this.boss_layer_info[i]
			if (layer_info && layer_info.length > 0) {
				let vo = layer_info[0]
				if (vo && vo.open_lv <= role_lv && i > index) {
					index = i
				}
			}
		}
		return index
	}

	/**
	 * 
	 * @param is_select_index 是否手动切页
	 */
	public UpdateRoomList(layer, is_select_index) {

		let boss_list = this.boss_layer_info[layer]
		if (boss_list) {

			if (!this.item_loop) {
				this.item_loop = new LoopScrowViewMgr()
				this.item_loop.SetData(this._panel_item, EudaemonEnterItem, boss_list, LoopScrCon.Vertical, 0)
				this.ItemListClick(this.defalut_index)
				this._panel_item.scrollTo(this.defalut_index)
			} else {
				this.item_loop.replaceAll(boss_list)

				let is_sel = false
				//选中一只玩家关注过的boss
				if (is_select_index) {
					for (let i = boss_list.length - 1; i >= 0; i--) {
						let boss_vo = boss_list[i]
						if (boss_vo && boss_vo.is_remind) {
							is_sel = true
							this._panel_item.scrollTo(i)
							this.now_select_index = i
							break;
						}
					}
				}

				//选中一只比玩家等级低的boss
				if (!is_sel && is_select_index) {
					this._panel_item.scrollTo(0)
					this.now_select_index = 0
					// let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
					// for (let i = boss_list.length - 1; i >= 0; i--) {
					// 	let boss_vo = boss_list[i]
					// 	if (boss_vo && boss_vo.lv && boss_vo.lv < role_lv) {
					// 		this.item_loop.SetSelectIndex(i)
					// 		break;
					// 	}
					// }
				}

				this.ItemListClick(this.now_select_index)
				this.SwitchRoom(this.now_select_index)
			}
		}

	}


	private ItemListClick(index) {
		this.item_loop.SetSelectIndex(index)
		this.now_select_index = index
		this.SwitchRoom(index)
	}

	public SwitchRoom(index = 0) {
		if (this.boss_layer_info && this.boss_layer_info.length > 0) {
			let layer_info = this.boss_layer_info[this.now_tab_index]
			if (layer_info) {
				this.SwitchView(layer_info[index])
			}
		}
	}

	public UpdateMsg(layar) {
		if (this.cross_server_boss_info && !this.use_delete_method) {
			if (layar == 0) {
				this._html_tired.innerHTML = `大妖次数：<font color='#19ae4a'>无限次</font>`
				this._html_box_times.visible = false
			}
			else {
				this._html_box_times.visible = true
				let left_time = this.cross_server_boss_info.max_tired - this.cross_server_boss_info.tired
				this._html_tired.innerHTML = `大妖次数：<font color='${left_time == 0 ? "#ff4f50" : "#19ae4a"}'>${left_time}/${this.cross_server_boss_info.max_tired}</font>`
			}
			this.wuxian.visible = this.wuxian_bg.visible = (layar == 0)
		}
	}

	public UpdateView() {
		this.cross_server_boss_info = this.boss_model.GetBossTypeInfo(this.cross_server_boss_type)
		let holy_wuxian_info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy_wuxian)
		let holy_wuxian_list = holy_wuxian_info && holy_wuxian_info.boss_info
		let cross_server_boss_list = this.cross_server_boss_info && this.cross_server_boss_info.boss_info
		if (!cross_server_boss_list) {
			return
		}


		this.boss_layer_info = []
		let layers = 0
		let role_lv = this.role_mgr.GetMainRoleLevel()
		if (cross_server_boss_list && holy_wuxian_list) {
			cross_server_boss_list = holy_wuxian_list.concat(cross_server_boss_list)
			table.sort(cross_server_boss_list, (a?, b?) => {
				return a.boss_id < b.boss_id
			})
			for (let _tmpi in cross_server_boss_list) {
				let vo = cross_server_boss_list[_tmpi]
				let layer = vo.layer
				if (layer || layer == 0) {
					if (vo.boss_type == BossModel.BossType.holy_wuxian) {
						layer = vo.layer = 0
					}
					if (!this.boss_layer_info[layer]) {
						this.boss_layer_info[layer] = []
						layers = layer > layers ? layer : layers
					}
					let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, vo.boss_id, false)
					if (mon_cfg && mon_cfg.kind == 0) {
						this.boss_layer_info[layer].push(vo)
						if (role_lv >= vo.open_lv) {
							//this.defalut_layer = layer
						}
					}
				}
			}

			let list: []
			for (let i = 0; i < this.boss_layer_info.length; i++) {
				list = this.boss_layer_info[i]
				table.sort(list, (a?, b?) => {
					return a["boss_id"] < b["boss_id"]
				})
			}

		}

		let layer
		if (this.now_tab_index != null) {
			layer = this.now_tab_index
		}
		else {
			if (this.scene_mgr.IsHolyBossScene()||this.scene_mgr.IsCrossWuxianBossScene()) {
				let curr_scene_id = this.scene_mgr.curr_scene_id
				let type = this.boss_model.GetBossType()
				layer = curr_scene_id - BossModel.BaseBossSceneId[type]
			} else {
				layer = this.GetMaxLayers()
			}

		}

		if (this.select_boss_id) {
			for (let key in this.boss_layer_info) {
				let layer_info = this.boss_layer_info[key]
				for (let k in layer_info) {

					if (layer_info[k].boss_id == this.select_boss_id) {
						layer = key
						this.defalut_index = Number(k)
						this.select_boss_id = null
						break
					}
				}
			}
		} else {
			if (this.is_frist_open) {
				let boss_list = this.boss_layer_info[layer]
				for (let i = boss_list.length - 1; i >= 0; i--) {
					let boss_vo = boss_list[i]
					if (boss_vo && boss_vo.is_remind) {
						this.defalut_index = i
						break;
					}
				}
			}

		}

		this.InitTab(layers, layer || 0)
		this.UpdateBosxData()
	}

	public InitTab(layers, defalut_layer) {

		let tab_list = []
		for (let i = 0; i <= layers; i++) {
			tab_list.push({
				index: i,
				floor: i,
				boss_type:i==0?BossModel.BossType.holy_wuxian:BossModel.BossType.holy
			})
		}

		if (!this.tab_item_list) {
			this.tab_item_list = []
		}

		let call_back = (index, is_hand) => {
			let boo = this.SwitchLayer(index, is_hand)
			this.is_frist_open = false
			if (boo) {
				for (let i = 0; i < this.tab_item_list.length; i++) {
					let item: EudaemonEnterTabItem = this.tab_item_list[i]
					item.SetSelect(index)
				}
			}
		}

		let item_index = 0
		for (let i = 0; i < tab_list.length; i++) {
			let item: EudaemonEnterTabItem = this.tab_item_list[i]
			if (!item) {
				item = new EudaemonEnterTabItem(this._panel_tab)
				item.SetData(tab_list[i], i, call_back)
				item.Load()
				item.ExcuteCallback(() => {
					item_index++
					if (item_index >= tab_list.length) {
						RefBoxChildsLayout(this._panel_tab, -2, 130, true, "left")
					}
				})
				table.insert(this.tab_item_list, item)
			}
		}


		if (this.is_frist_open) {
			call_back(defalut_layer, true)
			this.is_frist_open = false
		}
	}

	public DeleteMe() {

		if (this.item_loop) {
			this.item_loop.DeleteMe()
			this.item_loop = null
		}

		let item
		if (this.reward_item_list) {
			for (let _tmpi in this.reward_item_list) {
				item = this.reward_item_list[_tmpi]
				item.DeleteMe()
			}
			this.reward_item_list = null
		}

		if (this.tab_item_list) {
			for (let _tmpi in this.tab_item_list) {
				item = this.tab_item_list[_tmpi]
				item.DeleteMe()
			}
			this.tab_item_list = null
		}

		if (this.hunting_reward) {
			this.hunting_reward.DeleteMe()
			this.hunting_reward = null
		}
		this.mon_res = undefined;
		if (this.giftItem) {
			this.giftItem.DeleteMe();
			this.giftItem = null;
		}
		super.DeleteMe()

	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eShiYao));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eShiYao);
			});

		}
		this.giftIcon.visible = bool;
	}

	private ShowShop = () => {
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		this._img_shop.visible = lv >= 300
	}

	private CheckShopRed = () => {
		let red = ShopModel.GetInstance().CheckSoulOfWarRed()
		this._img_shop_red.visible = red
	}


	private UpdateBosxData() {
		SetHtmlStyle(this._html_box_times, { w: 250, ww: false, c: "#9b572f", f: 20, b: true, lh: 28 })
		let box_1_data = this.GetBoxsDataValue(1)
		let total_collect_times_1 = box_1_data && box_1_data.total_collect_times || 0
		let left_clt_1 = total_collect_times_1 - (box_1_data && box_1_data.collect_times || 0)
		let str_ct_1 = HtmlColorTxt(left_clt_1, left_clt_1 <= 0 ? Enum_ColorUtil_Dark.RED : Enum_ColorUtil_Dark.GREEN)
		let str_tct_1 = HtmlColorTxt(`/${total_collect_times_1}`, Enum_ColorUtil_Dark.GREEN)
		let box_2_data = this.GetBoxsDataValue(2)
		let total_collect_times_2 = box_2_data && box_2_data.total_collect_times || 0
		let left_clt_2 = total_collect_times_2 - (box_2_data && box_2_data.collect_times || 0)
		let str_ct_2 = HtmlColorTxt(left_clt_2, left_clt_2 <= 0 ? Enum_ColorUtil_Dark.RED : Enum_ColorUtil_Dark.GREEN)
		let str_tct_2 = HtmlColorTxt(`/${total_collect_times_2}`, Enum_ColorUtil_Dark.GREEN)
		this._html_box_times.innerHTML = `蜃妖宝箱：${str_ct_1}${str_tct_1}<br>蜃妖秘宝：${str_ct_2}${str_tct_2}`
		this._html_box_times.x = 720 - this._html_box_times.contextWidth - 25
	}
	private GetBoxsDataValue(type) {
		let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy)
		let collect_list = info && info.collect_list
		if (!collect_list) return null
		for (let i = 0; i < collect_list.length; i++) {
			if (collect_list[i].type == type) {
				return collect_list[i]
			}
		}
		return null
	}
	_box_model_con: Laya.Box
	_img_info: Laya.Image
	_html_info: Laya.HTMLDivElement
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_title: Laya.Label
	_img_bg3: Laya.Image
	_lb_title2: Laya.Label
	_img_tips: Laya.Image
	_html_hunting_level: Laya.HTMLDivElement
	_box_hunt_reward: Laya.Box
	_img_bg4: Laya.Image
	_img_bg13: Laya.Image
	_img_bg5: Laya.Image
	_panel_reward: Laya.Panel
	_img_bg6: Laya.Image
	_lb_boss_name: Laya.Label
	_box_attention: Laya.Box
	_img_bg8: Laya.Image
	_lb_tips2: Laya.Label
	_img_bg7: Laya.Image
	_img_attention: Laya.Image
	_box_room_con: Laya.Box
	_img_drop: Laya.Image
	_img_task: Laya.Image
	_img_task_red: Laya.Image
	_panel_tab: Laya.Box
	_img_bg9: Laya.Image
	_img_bg11: Laya.Image
	_img_bg12: Laya.Image
	_panel_item: Laya.List
	_html_box_times: Laya.HTMLDivElement
	_box_challenge: Laya.Box
	_img_challenge: Laya.Image
	_lb_challenge: Laya.Label
	_html_tired: Laya.HTMLDivElement
	wuxian_bg: Laya.Image
	wuxian: Laya.Label
	giftIcon: Laya.Box
	_img_shop: Laya.Image
	_img_shop_red: Laya.Image
	public GetComponents() {
		[
			this._box_model_con,
			this._img_info,
			this._html_info,
			this._img_bg,
			this._img_bg2,
			this._lb_title,
			this._img_bg3,
			this._lb_title2,
			this._img_tips,
			this._html_hunting_level,
			this._box_hunt_reward,
			this._img_bg4,
			this._img_bg13,
			this._img_bg5,
			this._panel_reward,
			this._img_bg6,
			this._lb_boss_name,
			this._box_attention,
			this._img_bg8,
			this._lb_tips2,
			this._img_bg7,
			this._img_attention,
			this._box_room_con,
			this._img_drop,
			this._img_task,
			this._img_task_red,
			this._panel_tab,
			this._img_bg9,
			this._img_bg11,
			this._img_bg12,
			this._panel_item,
			this._html_box_times,
			this._box_challenge,
			this._img_challenge,
			this._lb_challenge,
			this._html_tired,
			this.wuxian_bg,
			this.wuxian,
			this.giftIcon,
			this._img_shop,
			this._img_shop_red,
		]
			= this.GetChildrenByNames([

				"_box_model_con",
				"_img_info",
				"_html_info",
				"_img_bg",
				"_img_bg2",
				"_lb_title",
				"_img_bg3",
				"_lb_title2",
				"_img_tips",
				"_html_hunting_level",
				"_box_hunt_reward",
				"_img_bg4",
				"_img_bg13",
				"_img_bg5",
				"_panel_reward",
				"_img_bg6",
				"_lb_boss_name",
				"_box_attention",
				"_img_bg8",
				"_lb_tips2",
				"_img_bg7",
				"_img_attention",
				"_box_room_con",
				"_img_drop",
				"_img_task",
				"_img_task_red",
				"_panel_tab",
				"_img_bg9",
				"_img_bg11",
				"_img_bg12",
				"_panel_item",
				"_html_box_times",
				"_box_challenge",
				"_img_challenge",
				"_lb_challenge",
				"_html_tired",
				"wuxian_bg",
				"wuxian",
				"giftIcon",
				"_img_shop",
				"_img_shop_red",
			])
	}
}
window["EudaemonEnterView"] = EudaemonEnterView