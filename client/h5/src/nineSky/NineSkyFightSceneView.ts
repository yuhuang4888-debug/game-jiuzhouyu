import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
// import { NineSkyFightHeadItem } from "./NineSkyFightHeadItem"

import "./NineSkyFightHeadItem"
import "./NineSkySecretTreasureView"
import "./NineSkyFloorRewardView"
import "./NineSkyReliveView"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"
import { ColorUtil } from "../util/ColorUtil"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { PlatformManager } from "../PlatformManager"

export class NineSkyFightSceneView extends BaseView1 {

	scene_vo_dic
	attack_index
	auto_fight_state
	count_down_id
	top_reward_time_id
	enter_tips_id
	floor_count
	ins_id_to_index = {}
	is_tween
	kill_data_list
	reward_item_list
	show_supper_effect
	supper_item_list
	tween_id_list
	scene_obj_data_list: { vo, is_attacted, is_suffered }[]
	scene_obj_data_cache: { vo, is_attacted, is_suffered }[]
	kill_head_item

	nine_sky_model: NineSkyModel
	scene_mgr: SceneManager
	runner: Runner
	layer_mgr: LayerManager
	goods_model: GoodsModel
	role_mgr: RoleManager
	item_loop_mgr: LoopScrowViewMgr
	voice
	voice_time
	public constructor() {
		super()

		this.base_file = "nineSky"
		this.layout_file = "NineSkyFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true

		this.nine_sky_model = NineSkyModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.runner = Runner.GetInstance()
		this.layer_mgr = LayerManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.preload_server_config = {
			"config_nine": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {

		let liuhai_height = Util.GetLiuhaiHeight()
		this.display_obj.top = liuhai_height
		this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0

		this.UpdateFloor()

		this._panel_reward.hScrollBarSkin = ""

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_kill_tips_bg, GameResPath.GetIcon("nineSky", "ui_arena_16"))

		MainUIManager.GetInstance().AddMoveComponent(this, this._img_reward_show, false, MainUIManager.MOVE_TYPE.Right)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_head, false, MainUIManager.MOVE_TYPE.Right)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_info, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._img_return, false, MainUIManager.MOVE_TYPE.Left)
		MainUIManager.GetInstance().AddMoveComponent(this, this._box_count_down, false, MainUIManager.MOVE_TYPE.Stay)


		this._html_top_reward_time.style.color = "#663915"
		this._html_top_reward_time.style.fontSize = 18
		this._html_top_reward_time.style.wordWrap = false

		this._lb_top_reward_index.fontSize = 24
		ResManager.GetInstance().LoadFont(this, "nine_sky", this._lb_top_reward_index, 24)

		this.InitView()
		this.InitEvent()
		this.runner.AddRunObj(this, 3)
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_return, () => {
			let ok_func = () => {
				this.nine_sky_model.Fire(NineSkyModel.REQUEST_CCMD_EVENT, 13505)
			}
			Alert.Show("离开战场", Alert_Type.Two, ok_func, null, "退出", "取消")
		}, this, true)

		this.BindVar(this.nine_sky_model, "notify_info", (event_name?, now_value?) => {
			this.UpdateNotifyInfo()
			this.UpdateFloorReward()
		})

		this.BindVar(this.nine_sky_model, "top_info", (event_name?, now_value?) => {
			this.UpdateTopInfo()
		})

		this.BindEvent(this.nine_sky_model, NineSkyModel.REMOVE_ROLE, (role_id?) => {
			if (!this.scene_vo_dic[role_id]) {
				return
			}
			this.TryUpdateList()
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, (role_id?, role_vo?) => {
			let obj = {}
			obj[role_id] = role_vo
			this.nine_sky_model.UpdateDropState(obj)
			this.scene_vo_dic[role_id] = role_vo
			this.TryUpdateList()
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_REMOVE, (role_id?, role_vo?) => {
			if (!this.scene_vo_dic[role_id]) {
				return
			}
			delete this.scene_vo_dic[role_id]
			this.TryUpdateList()
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_ADD, (mon_id?, mon_vo?) => {
			this.scene_vo_dic[mon_id] = mon_vo
			this.TryUpdateList()
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.MONSTER_VO_REMOVE, (mon_id?, mon_vo?) => {
			if (!this.scene_vo_dic[mon_id]) {
				return
			}
			delete this.scene_vo_dic[mon_id]
			this.TryUpdateList()
		})

		this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, () => {
			if (this.supper_item_list) {
				this.supper_item_list = null
			}
			this.show_supper_effect = false
			this.InitList()

			this.UpdateScoreReward()
			let floor = this.UpdateFloor()
			this._box_enter_tips.visible = Math.abs(floor) < 10
			this._lb_enter_floor.text = String(floor)
			this.enter_tips_id = setTimeout(() => {
				if (this.use_delete_method) {
					return
				}
				this._box_enter_tips.visible = false
				this.enter_tips_id = null
			}, 5000)
			this.attack_index = null
		})

		Util.AddClickEvent(this._img_first_top, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkySecretTreasureView", 1)
		}, this, true)

		Util.AddClickEvent(this._img_top_reward, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkySecretTreasureView", 0)
		}, this, true)

		Util.AddClickEvent(this._img_reward_show, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkyRewardView")
		}, this, true)


		this.BindEvent(GlobalEventSystem, EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, (target?) => {
			if (target && target.vo && target.vo != false) {
				if (target.obj_type == SceneBaseType.Role) {
					this.UpdateAttackTagret(target.vo.role_id)
				} else if (target.obj_type == SceneBaseType.Monster) {
					this.UpdateAttackTagret(target.vo.instance_id)
				}
			}
		})

		this.BindEvent(GlobalEventSystem, NineSkyModel.NINE_SKY_FIGHTING_MSG, (attack_role_id?) => {
			let index = this.ins_id_to_index[attack_role_id]
			if (index) {
				this.show_supper_effect = true
				let data = this.scene_obj_data_list[index]
				if (data) {
					data.is_suffered = true
					this.ChangeHeadItem(index)
				}
				if (!this.supper_item_list) {
					this.supper_item_list = {}
				}
				this.supper_item_list[index] = { index: index, time: TimeUtil.getServerTime() }
			}
		})

		this.BindEvent(this.nine_sky_model, NineSkyModel.UPDATE_KILL_DATA, (scmd?) => {
			this.SetDKillState(scmd)
		})
	}

	public UpdateFloor() {
		let id = this.scene_mgr.GetSceneId()
		let floor = id - NineSkyModel.ModBaseSceneId
		if (floor < 0) {
			floor = id - NineSkyModel.NormalBaseSceneId
		}
		this._lb_scene_name.text = `${this.scene_mgr.GetSceneName()}${floor}层`
		return floor
	}

	public InitView() {
		this.UpdateNotifyInfo()
		this.UpdateFloorReward()
		this.UpdateScoreReward()
		this.UpdateTopInfo()

		this.InitList()
		this.voice_time = setTimeout(() => {
			if (this.use_delete_method) return
			this.voice = CommonManager.GetInstance().PlayFightingVoice(3)
		}, 2000);

	}

	public InitList() {
		if (!this.scene_vo_dic) {
			this.scene_vo_dic = {}
		}

		let all_monster = this.scene_mgr.GetAllMonsterVo()
		for (let instance_id in all_monster) {
			let vo = all_monster[instance_id]
			this.scene_vo_dic[vo.instance_id] = vo
		}

		let all_role = this.scene_mgr.GetAllRoleVos()
		for (let role_id in all_role) {
			let vo = all_role[role_id]
			if (vo) {
				this.scene_vo_dic[vo.role_id] = vo
			}
		}
		this.TryUpdateList()
	}

	public Remove() {

		if (this.voice_time) {
			clearTimeout(this.voice_time)
			this.voice_time = null
		}

		if (this.dealy_update_time_id) {
			clearTimeout(this.dealy_update_time_id)
			this.dealy_update_time_id = undefined
		}

		if (this.voice) {
			SoundManager.GetInstance().StopSoundEffect(this.voice)
			this.voice = null
		}

		this.CancelTime()
		this.CancelTime2()

		let obj
		if (this.reward_item_list) {
			for (let _tmpi in this.reward_item_list) {
				obj = this.reward_item_list[_tmpi]
				obj.DeleteMe()
			}
			this.reward_item_list = null
		}

		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = undefined
		}

		this.ClearKillTween()

		if (this.enter_tips_id) {
			clearTimeout(this.enter_tips_id)
			this.enter_tips_id = false
		}

		this.reward_item_list = null
		this.count_down_id = null
		this.floor_count = null
		this.auto_fight_state = false
		this.scene_vo_dic = null
		this.ins_id_to_index = {}
		this.kill_data_list = null
		this.is_tween = null
		this.attack_index = null
		this.show_supper_effect = null
		this.supper_item_list = null

		this.runner.RemoveRunObj(this.hashCode)
		MainUIManager.GetInstance().RemoveMoveComponent(this)
	}

	public UpdateNotifyInfo() {
		let info = this.nine_sky_model.GetNotifyInfo()
		if (!info) return
		let nine_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine", false)
		let cfg = nine_cfg[this.nine_sky_model.server_type + "@" + info.cur_floor]
		let str = String(info.kill_num)
		if (cfg.kill_num) {
			str = str + "/" + cfg.kill_num
			this._lb_fight_msg.text = "积分：" + str
			this._img_progress.width = 229 * (info.kill_num > cfg.kill_num && cfg.kill_num || info.kill_num) / cfg.kill_num
		} else {
			this._lb_fight_msg.text = "已达到最高层"
			this._img_progress.width = 229
		}
		let first_player_name = info.first_player
		if (!first_player_name) {
			first_player_name = "暂无登顶"
		}
		else if (info.first_server_num && this.nine_sky_model.server_type > 1) {
			first_player_name = `s${info.first_server_num}.${first_player_name}`
		}
		this._lb_first_top_name.text = first_player_name

		this.StartTime(info.left_time)
	}

	public UpdateFloorReward() {
		let info = this.nine_sky_model.GetNotifyInfo()
		if (!info) return
		if (!this.floor_count) {
			this.floor_count = info.max_floor
		} else {
			if (info.max_floor > this.floor_count) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "NineSkyFloorRewardView", info.max_floor)
				this.floor_count = info.max_floor
			}
		}
	}

	public UpdateTopInfo() {
		let top_info = this.nine_sky_model.GetTopInfo()
		if (!top_info) return

		this._lb_top_reward_index.text = String(top_info.index)
		this.StartTime2(top_info.left_time)
	}

	public UpdateScoreReward() {
		let id = this.scene_mgr.GetSceneId()
		let floor = id - NineSkyModel.ModBaseSceneId
		if (floor < 0) {
			floor = id - NineSkyModel.NormalBaseSceneId
		}
		floor = floor + 1
		let nine_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine", false)
		let cfg = nine_cfg[this.nine_sky_model.server_type + "@" + floor]
		if (!cfg) {
			this._img_all_get.visible = true
			this._panel_reward.visible = false
			return
		}
		this._img_all_get.visible = false
		this._panel_reward.visible = true

		let list = JSON.parse(cfg.award)
		let len = list.length
		if (!this.reward_item_list) {
			this.reward_item_list = []
		}

		let i = len
		if (i < this.reward_item_list.length) {
			do {
				this.reward_item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.reward_item_list.length))
		}

		if (len > 0) {
			let item
			for (let key in list) {
				item = this.reward_item_list[key]
				if (!item) {
					item = new EquipmentItem(this._panel_reward)
					this.reward_item_list[key] = item
					item.Load()
					item.SetItemSize(68, 69)
				}
				item.SetPosition(Number(key) * 74, 0)
				let vo = list[key]
				let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				}
				item.SetVisible(true)
			}
		}
	}

	public StartTime(end_time) {
		this.CancelTime()
		let loop_func = () => {
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelTime()
				return
			}
			this._lb_count_down2.text = TimeUtil.convertTime(left_time)
		}
		this.count_down_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public CancelTime() {
		if (this.count_down_id) {
			GlobalTimerQuest.CancelQuest(this.count_down_id)
			this.count_down_id = false
		}
	}

	public StartTime2(end_time) {
		this.CancelTime2()
		let loop_func = () => {
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this._html_top_reward_time.innerHTML = ""
				this.CancelTime2()
				return
			}
			this._html_top_reward_time.innerHTML = `${Util.HtmlColorTxt(TimeUtil.timeConvert(left_time, "mm:ss"), "'#0a953e'")}后开启`
			if(PlatformManager.IsEyouPlatform()){
				this._html_top_reward_time.style.wordWrap = true
				this._html_top_reward_time.style.leading = 0.1
				this._html_top_reward_time.style.align = "center"
				this._html_top_reward_time.y = 325
				this._html_top_reward_time.style.width = 110
			}
		}
		this.top_reward_time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public CancelTime2() {
		if (this.top_reward_time_id) {
			GlobalTimerQuest.CancelQuest(this.top_reward_time_id)
			this.top_reward_time_id = false
		}
	}

	public SetDKillState(data?) {
		if (!data) {
			return
		}
		if (this.is_tween) {
			if (!this.kill_data_list) {
				this.kill_data_list = []
			}
			if (this.kill_data_list.length > 30) {
				table.remove(this.kill_data_list, 0)
			}
			table.insert(this.kill_data_list, data)
			return

		}
		this._lb_kill_count.text = data.dkill
		this._lb_kill_name.text = data.name

		if(!this.kill_head_item){
			this.kill_head_item = new CustomHeadItem(this._box_kill_head)
			this.kill_head_item.CloseClick()
			this.kill_head_item.SetActiveLevel(true)
			this.kill_head_item.SetActiveFrame(true)
			this.kill_head_item.Load()
		}

		this.kill_head_item.SetRoleVoData(data)

		this.is_tween = true
		this.ClearKillTween()
		this._box_kill_tips.visible = true
		let width = LayerManager.GetInstance().stageWidth / 2 + this._box_kill_tips.width / 2
		this._box_kill_tips.centerX = -width

		if (!this.tween_id_list) {
			this.tween_id_list = []
		}

		table.insert(this.tween_id_list, SYTweenLite.to(this, this._box_kill_tips, SYTweenLite.UiAnimationType.CENTER_POSX, 0, 0.2, () => {
			setTimeout(() => {
				if (this.use_delete_method) { return }
				table.insert(this.tween_id_list, SYTweenLite.to(this, this._box_kill_tips, SYTweenLite.UiAnimationType.CENTER_POSX, width, 0.3, () => {
					this.is_tween = false
					if (this.kill_data_list && this.kill_data_list.length > 0) {
						let data = table.remove(this.kill_data_list, 1)[0]
						this.SetDKillState(data)
					}
					else{
						this._box_kill_tips.visible = false
					}

				}, SYTweenFunc.EASE_IN))
			}, 1000)
		}, SYTweenFunc.EASE_IN_OUT))
	}

	public ClearKillTween() {
		if (this.tween_id_list) {
			for (let _ = 0; _ < this.tween_id_list.length; _++) {
				let id = this.tween_id_list[_]
				SYTweenLite.Stop(id)
			}
			this.tween_id_list.length = 0
		}
	}

	dealy_update_time_id
	public TryUpdateList() {
		if (this.dealy_update_time_id) return
		this.dealy_update_time_id = setTimeout(() => {
			this.dealy_update_time_id = undefined
			this.UpdateList()
		}, 1000);
	}

	public UpdateList() {
		if (!this.scene_obj_data_list) {
			this.scene_obj_data_list = []
		}

		let list = this.scene_obj_data_list
		if (list.length > 0) {
			if (!this.scene_obj_data_cache) {
				this.scene_obj_data_cache = []
			}
			for (let data of list) {
				data.vo = undefined
				data.is_attacted = false
				data.is_suffered = false
				this.scene_obj_data_cache.push(data)
			}
			list.length = 0
		}
		let delete_list = []

		let dic = this.scene_vo_dic, vo, data
		for (let id in dic) {
			vo = dic[id]
			if (vo.hp > 0) {
				data = (this.scene_obj_data_cache && this.scene_obj_data_cache.length > 0) ? this.scene_obj_data_cache.pop() : this.CreateItemData()
				data.vo = vo
				table.insert(list, data)
			} else {
				table.insert(delete_list, id)
			}
		}

		for (let _tmpi in delete_list) {
			let value = delete_list[_tmpi]
			delete dic[value]
		}

		this.SortList()
		this.RefreshList()
	}

	public SortList() {

		let list = this.scene_obj_data_list
		let secret_treasure_role_id = 0
		let top_data = this.nine_sky_model.GetTopInfo()
		if (top_data) {
			secret_treasure_role_id = top_data.role_id
		}
		table.sort(list, (a?, b?) => {
			if (a.vo.role_id == secret_treasure_role_id) {
				return true
			}
			if (b.vo.role_id == secret_treasure_role_id) {
				return false
			}

			let main_role_pos_x = this.role_mgr.GetMainRoleVo().pos_x
			let main_role_pos_y = this.role_mgr.GetMainRoleVo().pos_y
			let a_dis = GameMath.GetDistance(main_role_pos_x, main_role_pos_y, a.vo.pos_x, a.vo.pos_y)
			let b_dis = GameMath.GetDistance(main_role_pos_x, main_role_pos_y, b.vo.pos_x, b.vo.pos_y)
			return a_dis < b_dis
		})
	}



	public RefreshList() {
		let list = this.scene_obj_data_list
		let len = list.length

		this.ins_id_to_index = {}

		if (len > 0) {
			for (let key in list) {
				let data = list[key]
				let id = data.vo.vo_type == SceneBaseType.Role && data.vo.role_id || data.vo.instance_id
				this.ins_id_to_index[id] = key
			}
		}

		this.scene_obj_data_list = list

		let item_class = window['NineSkyFightHeadItem']
		if (!item_class) return
		if (this.item_loop_mgr) {
			this.item_loop_mgr.replaceAll(list)
		}
		else {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this._list_head, item_class, list, LoopScrCon.Horizontal)
		}
	}

	public CreateItemData() {
		return {
			vo: undefined,
			is_attacted: false,
			is_suffered: false
		}
	}

	public UpdateAttackTagret(attack_id?) {
		let index = this.ins_id_to_index[attack_id]
		if (this.attack_index == index) {
			return
		}

		let data = this.scene_obj_data_list[this.attack_index]
		if (data) {
			data.is_attacted = false
			this.ChangeHeadItem(this.attack_index)
		}

		data = this.scene_obj_data_list[index]
		if (data) {
			data.is_attacted = true
			this.ChangeHeadItem(index)
		}

		this.attack_index = index
	}

	public ChangeHeadItem(index) {
		//如果是可视范围，则重新渲染
		if (index >= this._list_head.startIndex && index < this._list_head.startIndex + this._list_head.cells.length) {
			this._list_head["renderItem"](this._list_head.getCell(index)!, index);
		}
	}

	public Update(now_time?, elapse_time?) {
		if (this.show_supper_effect) {
			let now_time = TimeUtil.getServerTime()
			let delete_list = []
			let index = 0
			for (let key in this.supper_item_list) {
				index++
				let vo = this.supper_item_list[key]
				if (now_time - vo.time >= 3) {
					let data = this.scene_obj_data_list[index]
					if (data) {
						data.is_suffered = false
						this.ChangeHeadItem(index)
					}
					table.insert(delete_list, key)
				}
			}

			for (let _tmpi in delete_list) {
				let value = delete_list[_tmpi]
				delete this.supper_item_list[value]
			}

			if (index - delete_list.length == 0) {
				this.show_supper_effect = false
			}
		}
	}

	_box_count_down: Laya.Box
	_img_count_down_bg: Laya.Image
	_lb_count_down: Laya.Label
	_lb_count_down2: Laya.Label
	_box_enter_tips: Laya.Box
	_img_bg2: Laya.Image
	_lb_enter_floor: Laya.Label
	_box_info: Laya.Box
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_lb_scene_name: Laya.Label
	_img_progress_bg: Laya.Image
	_img_progress: Laya.Image
	_lb_fight_msg: Laya.Label
	_img_bg5: Laya.Image
	_lb_title: Laya.Label
	_panel_reward: Laya.Panel
	_img_bg6: Laya.Image
	_lb_title2: Laya.Label
	_img_first_top: Laya.Image
	_img_top_reward: Laya.Image
	_img_all_get: Laya.Image
	_lb_first_top_name: Laya.Label
	_lb_top_reward_index: Laya.Label
	_html_top_reward_time: Laya.HTMLDivElement
	_img_reward_show: Laya.Image
	_img_return: Laya.Image
	_box_head: Laya.Box
	_img_bg7: Laya.Image
	_list_head: Laya.List
	_box_kill_tips: Laya.Box
	_img_kill_tips_bg: Laya.Image
	_img_kill_tips: Laya.Image
	_lb_kill_name: Laya.Label
	_lb_kill_count: Laya.Label
	_box_kill_head: Laya.Box
	public GetComponents() {
		[
			this._box_count_down,
			this._img_count_down_bg,
			this._lb_count_down,
			this._lb_count_down2,
			this._box_enter_tips,
			this._img_bg2,
			this._lb_enter_floor,
			this._box_info,
			this._img_bg3,
			this._img_bg4,
			this._lb_scene_name,
			this._img_progress_bg,
			this._img_progress,
			this._lb_fight_msg,
			this._img_bg5,
			this._lb_title,
			this._panel_reward,
			this._img_bg6,
			this._lb_title2,
			this._img_first_top,
			this._img_top_reward,
			this._img_all_get,
			this._lb_first_top_name,
			this._lb_top_reward_index,
			this._html_top_reward_time,
			this._img_reward_show,
			this._img_return,
			this._box_head,
			this._img_bg7,
			this._list_head,
			this._box_kill_tips,
			this._img_kill_tips_bg,
			this._img_kill_tips,
			this._lb_kill_name,
			this._lb_kill_count,
			this._box_kill_head,
		]
			= this.GetChildrenByNames([

				"_box_count_down",
				"_img_count_down_bg",
				"_lb_count_down",
				"_lb_count_down2",
				"_box_enter_tips",
				"_img_bg2",
				"_lb_enter_floor",
				"_box_info",
				"_img_bg3",
				"_img_bg4",
				"_lb_scene_name",
				"_img_progress_bg",
				"_img_progress",
				"_lb_fight_msg",
				"_img_bg5",
				"_lb_title",
				"_panel_reward",
				"_img_bg6",
				"_lb_title2",
				"_img_first_top",
				"_img_top_reward",
				"_img_all_get",
				"_lb_first_top_name",
				"_lb_top_reward_index",
				"_html_top_reward_time",
				"_img_reward_show",
				"_img_return",
				"_box_head",
				"_img_bg7",
				"_list_head",
				"_box_kill_tips",
				"_img_kill_tips_bg",
				"_img_kill_tips",
				"_lb_kill_name",
				"_lb_kill_count",
				"_box_kill_head",
			])
	}
}
window["NineSkyFightSceneView"] = NineSkyFightSceneView