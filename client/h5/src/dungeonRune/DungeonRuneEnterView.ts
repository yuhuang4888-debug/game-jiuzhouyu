import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { OverrideScrollBarChange, Util } from "../util/Util"
import { DungeonRuneEnterItem } from "./DungeonRuneEnterItem"
import { CommonRewardItem } from "../common/CommonRewardItem";
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SYTweenLite } from "../util/SYTweenLite"
import { FirstBloodEvent, FirstBloodModel } from "../commonModel/FirstBloodModel"
import { DungeonRuneEnterLineItem } from "./DungeonRuneEnterLineItem"
import { DungeonRuneEnterBgItem } from "./DungeonRuneEnterBgItem"

import "../dungeonRune/DungeonRuneTargetView"
import "../dungeonRune/DungeonRuneFirstView"
import "../dungeonRune/DungeonRuneUnlockView"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { GiftPushIcon } from './../mainUI/GiftPushIcon';
import { SceneManager } from "../scene/SceneManager"
import { PlatformManager } from "../PlatformManager"

export class DungeonRuneEnterView extends BaseItem1 {

	//TaskTipType.FinDunType
	private giftItem: GiftPushIcon;
	base_dungeon_model: BaseDungeonModel
	first_blood_model: FirstBloodModel
	res_mgr: ResManager

	cur_data
	is_first = true
	_unlock_goods_id_
	item_loop_mgr
	bg_loop_mgr
	line_loop_mgr
	reward_loop_mgr: LoopScrowViewMgr
	tween_list = []
	init_list_event
	has_set_unlock_effect
	public constructor(parent?) {
		super(parent)
		this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneEnterView"

		this.base_dungeon_model = BaseDungeonModel.GetInstance()
		this.first_blood_model = FirstBloodModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		let FinDunType = TaskTipType.FinDunType
		let local_DUN_TYPE = DUN_TYPE

		this.load_callback = () => {
			let main_role_task = TaskModel.GetInstance().GetMainLineTaskVo()
			if (main_role_task && main_role_task.task_id == 100980) {
				this._gp_daily_reward.visible = this._gp_first.visible = this._gp_target.visible = false
			}
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_daily_reward.pos(79,17)
				this._lb_daily_reward.width = 99
				this._lb_daily_reward.height = 39
				this._lb_daily_reward.wordWrap = true
				this._lb_daily_reward.leading = 0.1
				this._lb_first.pos(79,17)
				this._lb_first.width = 99
				this._lb_first.height = 39
				this._lb_first.wordWrap = true
				this._lb_first.leading = 0.1
				this._lb_target.pos(79,17)
				this._lb_target.width = 99
				this._lb_target.height = 39
				this._lb_target.wordWrap = true
				this._lb_target.leading = 0.1
			}
			this.LoadSuccess()
		}
		this.createChildren = () => {
			if (this["GetComponents"]) {
				this["GetComponents"]()
				this.is_get = true
			}
			this.story_obj_list = this.story_obj_list || {}
			this.story_obj_list[FinDunType] = this.story_obj_list[FinDunType] || {}
			this.story_obj_list[FinDunType][local_DUN_TYPE.Rune] = [this._gp_challenge]


			// 		this.story_obj_list = this.story_obj_list || {}
			// this.story_obj_list[FinDunType] = this.story_obj_list[FinDunType] || {}
			//this.story_obj_list[FinDunType][local_DUN_TYPE.Exp] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
			this.story_obj_list[FinDunType][local_DUN_TYPE.Tower] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
			//this.story_obj_list[FinDunType][local_DUN_TYPE.Equip] = [BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2]
			
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Dungeon_level)) {
				this.story_model.curr_view_story_step=1
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
			}
			this.story_obj_list[TaskTipType.Dungeon_level] = [null, this._gp_challenge]

			super.createChildren()
		}
	}

	public LoadSuccess() {
		// this._img_rec_fight_bg.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_06")
		// this._img_unlock.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_04")

		// this.res_mgr.SetOutsideImageSprite(this, this._img_rec_fight_bg, GameResPath.GetIcon("dungeonRune", "ui_copy_06"))
		// this.res_mgr.SetOutsideImageSprite(this, this._img_unlock, GameResPath.GetIcon("dungeonRune", "ui_copy_04"))
		this._gp_unlock.x = 539
		this._gp_unlock.y = -272

		// this._list_bg.cacheContent = true
		// this._list_line.cacheContent = true
		// this._list_item.cacheContent = true

		this.InitEvent()
		this.UpdateFirstRed()
		this.UpdateTargetRed()
		this.UpdateDailyRed()
		this.UpdateView()
		this.UpdateScroller()
		this.ShowGiftIcon();

	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eYuHun));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eYuHun, 0);
			});

		}
		this.giftIcon.visible = bool;
	}

	public InitEvent() {
		this.BindEvent(this.base_dungeon_model, BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, (dun_type?) => {
			if (dun_type == DUN_TYPE.Rune) {
				this.UpdateView()
			}
		})

		this.BindEvent(this.base_dungeon_model, BaseDungeonModel.UPDATE_RUNE_UNLOCK_FLOOR, () => {
			this.UpdateUnLockState()
		})

		this.BindEvent(this.base_dungeon_model, BaseDungeonModel.UPDATE_RUNE_DAILY_REWARD_STATE, () => {
			this.UpdateDailyRed()
		})

		this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
			this.ShowGiftIcon();
		})



		let challenge_func=()=>{
			let challenge_data = this.base_dungeon_model.GetRuneChallengeData()
			if (challenge_data) {

				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}

				//先退出队伍
				if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(challenge_data.dun_id)) return


				this.base_dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, challenge_data.dun_id)
			} else {
				Message.show("已达到最高层")
			}
		}


		Util.AddClickEvent(this._gp_challenge, () => {
			challenge_func()
		}, this, true)

		Util.AddClickEvent(this._img_icon, () => {
			if (this._unlock_goods_id_) {
				UIToolTipMgr.GetInstance().DefaultAppendTips(this._unlock_goods_id_, 1)
			}
		}, this, true)

		Util.AddClickEvent(this._gp_first, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonRuneFirstView")
		}, this, true)

		Util.AddClickEvent(this._gp_target, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonRuneTargetView")
		}, this, true)

		Util.AddClickEvent(this._gp_daily_reward, () => {
			let state = this.base_dungeon_model.GetRuneDailyRewardState()
			if (state == 0) {
				Message.show("暂无奖励可以领取")
			} else if (state == 1) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonRuneDailyRewardView")
			} else if (state == 2) {
				Message.show("每日奖励已领取，请明天再来吧!")
			}
		}, this, true)

		Util.AddClickEvent(this._box_unlock_click, () => {
			let dungeon_rune_lv_data_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_rune_lv_data
			let [next_floor, cfg_data] = this.base_dungeon_model.GetNextUnlockRune(dungeon_rune_lv_data_cfg)
			let cur_floor = this.base_dungeon_model.GetRuneCurFloor()
			if (next_floor && cur_floor >= next_floor) {
				this.base_dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61116, next_floor)
			}
		}, this, true)


		this.BindEvent(this.base_dungeon_model, BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id)=>{
			let challenge_data = this.base_dungeon_model.GetRuneChallengeData()
			if(challenge_data&&challenge_data.dun_id==dun_id){
				challenge_func()
			}
		})

		this.BindEvent(this.first_blood_model, FirstBloodEvent.UPDATE_RUNE_RED, () => {
			this.UpdateFirstRed()
		})

		this.BindEvent(this.base_dungeon_model, BaseDungeonModel.CHANGE_RUNE_DUN_REWARD, () => {
			this.UpdateTargetRed()
		})
	}

	public SyncLoopList = (e: Event | null = null) => {
		let value = this._list_item.scrollBar.value
		this._list_bg.scrollBar["_isElastic"] = this._list_item.scrollBar["_isElastic"]
		this._list_bg.startIndex = this._list_item.startIndex
		this._list_bg.scrollBar.value = value
		// callback.call(this._list_bg, e);

		this._list_line.scrollBar["_isElastic"] = this._list_item.scrollBar["_isElastic"]
		this._list_line.startIndex = this._list_item.startIndex
		this._list_line.scrollBar.value = value
		// callback.call(this._list_line, e);
		// console.warn("##########",value)
	}

	public UpdateView() {
		let dun_list = this.base_dungeon_model.GetDungeonInfo(DUN_TYPE.Rune)
		if (dun_list) {
			let list = []
			for (let _tmpi in dun_list) {
				var vo = dun_list[_tmpi]
				list.push(vo)
			}

			list = list.reverse()

			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_item, DungeonRuneEnterItem, list, LoopScrCon.Vertical)
			} else {
				this.item_loop_mgr.replaceAll(list)
			}

			if (!this.line_loop_mgr) {
				this.line_loop_mgr = new LoopScrowViewMgr()
				this.line_loop_mgr.SetData(this._list_line, DungeonRuneEnterLineItem, list, LoopScrCon.Vertical)
			} else {
				this.line_loop_mgr.replaceAll(list)
			}

			if (!this.bg_loop_mgr) {
				this.bg_loop_mgr = new LoopScrowViewMgr()
				this.bg_loop_mgr.SetData(this._list_bg, DungeonRuneEnterBgItem, list, LoopScrCon.Vertical)
			} else {
				this.bg_loop_mgr.replaceAll(list)
			}

			if (!this.init_list_event) {
				this.init_list_event = true
				this._list_bg.scrollBar!.off(Laya.Event.CHANGE, this._list_bg, null);
				this._list_item.scrollBar!.off(Laya.Event.CHANGE, this._list_item, null);
				this._list_line.scrollBar!.off(Laya.Event.CHANGE, this._list_line, null);

				this._list_bg.scrollBar!.on(Laya.Event.CHANGE, this._list_bg, OverrideScrollBarChange);
				this._list_item.scrollBar!.on(Laya.Event.CHANGE, this._list_item, OverrideScrollBarChange);
				this._list_line.scrollBar!.on(Laya.Event.CHANGE, this._list_line, OverrideScrollBarChange);

				this._list_item.scrollBar.on(Laya.Event.CHANGE, this, this.SyncLoopList);
			}


			this.UpdateUnLockState()

			if (this.base_dungeon_model.RuneAllIsDone()) {
				this._lb_done.visible = true
				this._gp_rec_fight.visible = false
				this._gp_challenge.visible = false
				this._lb_reward_floor.visible = false
				this._list_reward.visible = false
			} else {
				this._lb_done.visible = false
				this._gp_rec_fight.visible = true
				this._gp_challenge.visible = true
				this._lb_reward_floor.visible = true
				this._list_reward.visible = true
				this.UpdateRewardItem()
				this.UpdateLevel()
				this._lb_reward_floor.text = `${this.base_dungeon_model.GetRuneCurFloor() + 1}层奖励`
			}


			let challenge_data = this.base_dungeon_model.GetRuneChallengeData()
			if (challenge_data) {
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_dungeon
				let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, challenge_data.dun_id, false, cfgs)
				this._img_challenge_red.visible = RoleManager.GetInstance().GetMainRoleVo().fighting >= Number(dun_cfg.recommend_power) * BaseDungeonModel.Recommend_Power_Module
			} else {
				this._img_challenge_red.visible = false
			}
		}
	}

	public UpdateRewardItem() {
		let dungeon_ui_content = Config.PRELOAD_SERVER_CONFIG.config_dungeon_ui_content
		let cur_data = this.base_dungeon_model.GetRuneChallengeData()
		let ui_cfg = dungeon_ui_content && cur_data && Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_ui_content.name, cur_data.dun_id, false, dungeon_ui_content)
		let list = []
		if (ui_cfg) {
			list = JSON.parse(ui_cfg.rewards)
		}
		let pre_reward_list = []
		for (let _tmpi in list) {
			var vo = list[_tmpi]
			pre_reward_list.push({ size: 87, vo: { style: vo[0], typeId: vo[1], count: 0 } })
		}

		let len = pre_reward_list.length
		if (len > 2) {
			len = 2
		}
		this._list_reward.width = len * 87 + len * 6

		if (!this.reward_loop_mgr) {
			this.reward_loop_mgr = new LoopScrowViewMgr()
			this.reward_loop_mgr.SetData(this._list_reward, CommonRewardItem, pre_reward_list, LoopScrCon.Horizontal, null, null, null, 87)
		} else {
			this.reward_loop_mgr.replaceAll(pre_reward_list)
		}
	}

	public UpdateLevel() {
		let cur_data = this.base_dungeon_model.GetRuneChallengeData()
		if (cur_data) {
			let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, cur_data.dun_id, false)
			let com_power = dun_cfg && dun_cfg.recommend_power
			let mainFight = RoleManager.GetInstance().GetMainRoleVo().fighting
			//let str = mainFight + "/" + com_power
			let str = com_power
			let color = mainFight >= com_power && "#ffd74d" || "#ff4f50"
			this._lb_rec_fight.text = str
			this._lb_rec_fight.color = color
		}
	}


	public UpdateScroller() {
		let cur_floor = this.base_dungeon_model.GetRuneCurFloor()
		let max_floor = this.base_dungeon_model.GetRuneMaxFloor()
		// this.item_loop_mgr.LastOnChild(150)
		// this._list_item.scrollTo(150)

		let floor = max_floor - cur_floor - 1
		this._list_item.startIndex = (floor - 3)
		if (this._list_item.scrollBar) this._list_item.scrollBar.value = (floor - 3) * this._list_item["_cellSize"] - 35

		// this._list_item.cacheContent = true
		// this._list_line.cacheContent = true
		// this._list_bg.cacheContent = true
	}

	public UpdateUnLockState() {
		let dungeon_rune_lv_data_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_rune_lv_data
		let [next_floor, cfg_data] = this.base_dungeon_model.GetNextUnlockRune(dungeon_rune_lv_data_cfg)
		let bool = next_floor > 0
		if (bool && cfg_data) {
			this._gp_unlock.visible = true
			let type_id = cfg_data.unlock_rune
			this._unlock_goods_id_ = type_id

			if (type_id == BaseDungeonModel.Rune_Hole_Id) {
				this._img_unlock_tips.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_04cc")
				this._img_icon.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_10")
				this._lb_icon_name.text = "新槽位"
			}
			else {
				let data = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (data) {
					this._img_icon.skin = null
					this.res_mgr.SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(data.goods_icon))
					// this._lb_icon_name.color = ColorUtil.TryParseHtmlString(ColorUtil.GetColorLight(data.color))
					this._lb_icon_name.text = data.goods_name
				}
				this._img_unlock_tips.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_04c")
			}
			// this._lb_pre_reward_floor.text = `${next_floor}层${type_id == BaseDungeonModel.Rune_Hole_Id && "解锁新槽位" || "解锁新类型"}`
			let cur_floor = this.base_dungeon_model.GetRuneCurFloor()
			if (cur_floor >= next_floor) {
				if (!this.has_set_unlock_effect) {
					this.has_set_unlock_effect = true
					this.AddUIEffect("UI_1601_03", this._box_unlock_effect, { x: 0, y: -0.5 }, 6)
				}
				this._box_unlock_effect.visible = true
				// if (type_id == BaseDungeonModel.Rune_Hole_Id) {
				this._lb_unlock_msg.text = "点击解锁"
				// }else{
				// 	this._lb_unlock_msg.text = "点击领取"
				// }
				this._img_unlock_red.visible = true
				this._lb_unlock_msg.color = "#fff3d3"
				this._img_unlock_bg2.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_04a")
			}
			else {
				this._img_unlock_red.visible = false
				this._box_unlock_effect.visible = false
				this._lb_unlock_msg.text = next_floor + "层奖励"
				// this._lb_unlock_msg.color = "#fffffe"
				// this._img_unlock_bg2.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_04b")
				this._lb_unlock_msg.color = "#fff3d3"
				this._img_unlock_bg2.skin = GameResPath.GetIcon("dungeonRune", "ui_copy_04a")
			}
		} else {
			this._box_unlock_effect.visible = false
			this._gp_unlock.visible = false
		}

		if (this.is_first) {
			this.is_first = false
			if (this._gp_unlock.visible) {
				let tween_id = SYTweenLite.to(this, this._gp_unlock, SYTweenLite.UiAnimationType.POSY, 50, 0.3, () => {
					let tween_id = SYTweenLite.to(this, this._gp_unlock, SYTweenLite.UiAnimationType.POSY, 30, 0.2, () => {
						let tween_id = SYTweenLite.to(this, this._gp_unlock, SYTweenLite.UiAnimationType.POSY, 7, 0.1)
						this.tween_list.push(tween_id)
					})
					this.tween_list.push(tween_id)
				})
				this.tween_list.push(tween_id)
			}
		}
	}

	public UpdateFirstRed() {
		let red = this.first_blood_model.RuneFirstRed()
		this._img_first_red.visible = red
	}

	public UpdateTargetRed() {
		let red = this.base_dungeon_model.RuneRewardRed()
		this._img_target_red.visible = red
	}

	public UpdateDailyRed() {
		let state = this.base_dungeon_model.GetRuneDailyRewardState()
		this._img_daily_reward_red.visible = state == 1
	}

	public DeleteMe() {
		if (this._list_item && this._list_item.scrollBar)
			this._list_item.scrollBar.off(Laya.Event.CHANGE, this, this.SyncLoopList);

		if (this.item_loop_mgr != null) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}

		if (this.bg_loop_mgr != null) {
			this.bg_loop_mgr.DeleteMe()
			this.bg_loop_mgr = null
		}

		if (this.line_loop_mgr != null) {
			this.line_loop_mgr.DeleteMe()
			this.line_loop_mgr = null
		}

		if (this.reward_loop_mgr != null) {
			this.reward_loop_mgr.DeleteMe()
			this.reward_loop_mgr = null
		}

		let tween_id
		for (let i = 0; i < this.tween_list.length; i++) {
			tween_id = this.tween_list[i]
			SYTweenLite.Stop(tween_id)
		}
		if (this._list_reward) {
			BaseItemRenderer.ClearList(this._list_reward)
		}
		this.tween_list.length = 0
		this._unlock_goods_id_ = null
		this.init_list_event = false
		this.has_set_unlock_effect = false
		if (this.giftItem) {
			this.giftItem.DeleteMe();
			this.giftItem = null;
		}
		super.DeleteMe()
	}


	_list_bg: Laya.List
	_list_line: Laya.List
	_list_item: Laya.List
	_gp_unlock: Laya.Box
	_img_unlock_bg: Laya.Image
	_box_unlock_effect: Laya.Box
	_img_icon: Laya.Image
	_lb_icon_name: Laya.Label
	_img_unlock_tips: Laya.Image
	_img_unlock_bg2: Laya.Image
	_lb_unlock_msg: Laya.Label
	_box_unlock_click: Laya.Box
	_img_unlock_red: Laya.Image
	_gp_rec_fight: Laya.Box
	_img_rec_fight_bg: Laya.Image
	_lb_rec_desc: Laya.Label
	_lb_rec_fight: Laya.Label
	_lb_done: Laya.Label
	_gp_challenge: Laya.Box
	_img_challenge: Laya.Image
	_lb_challenge: Laya.Label
	_img_challenge_red: Laya.Image
	_gp_daily_reward: Laya.Box
	_img_daily_reward: Laya.Image
	_lb_daily_reward: Laya.Label
	_img_daily_reward_red: Laya.Image
	_gp_first: Laya.Box
	_img_first: Laya.Image
	_lb_first: Laya.Label
	_img_first_red: Laya.Image
	_gp_target: Laya.Box
	_img_target: Laya.Image
	_lb_target: Laya.Label
	_img_target_red: Laya.Image
	_gp_reward: Laya.Box
	_img_reward_bg: Laya.Image
	_lb_reward_floor: Laya.Label
	_list_reward: Laya.List
	giftIcon: Laya.Box
	public GetComponents() {
		[
			this._list_bg,
			this._list_line,
			this._list_item,
			this._gp_unlock,
			this._img_unlock_bg,
			this._box_unlock_effect,
			this._img_icon,
			this._lb_icon_name,
			this._img_unlock_tips,
			this._img_unlock_bg2,
			this._lb_unlock_msg,
			this._box_unlock_click,
			this._img_unlock_red,
			this._gp_rec_fight,
			this._img_rec_fight_bg,
			this._lb_rec_desc,
			this._lb_rec_fight,
			this._lb_done,
			this._gp_challenge,
			this._img_challenge,
			this._lb_challenge,
			this._img_challenge_red,
			this._gp_daily_reward,
			this._img_daily_reward,
			this._lb_daily_reward,
			this._img_daily_reward_red,
			this._gp_first,
			this._img_first,
			this._lb_first,
			this._img_first_red,
			this._gp_target,
			this._img_target,
			this._lb_target,
			this._img_target_red,
			this._gp_reward,
			this._img_reward_bg,
			this._lb_reward_floor,
			this._list_reward,
			this.giftIcon,
		]
			= this.GetChildrenByNames([

				"_list_bg",
				"_list_line",
				"_list_item",
				"_gp_unlock",
				"_img_unlock_bg",
				"_box_unlock_effect",
				"_img_icon",
				"_lb_icon_name",
				"_img_unlock_tips",
				"_img_unlock_bg2",
				"_lb_unlock_msg",
				"_box_unlock_click",
				"_img_unlock_red",
				"_gp_rec_fight",
				"_img_rec_fight_bg",
				"_lb_rec_desc",
				"_lb_rec_fight",
				"_lb_done",
				"_gp_challenge",
				"_img_challenge",
				"_lb_challenge",
				"_img_challenge_red",
				"_gp_daily_reward",
				"_img_daily_reward",
				"_lb_daily_reward",
				"_img_daily_reward_red",
				"_gp_first",
				"_img_first",
				"_lb_first",
				"_img_first_red",
				"_gp_target",
				"_img_target",
				"_lb_target",
				"_img_target_red",
				"_gp_reward",
				"_img_reward_bg",
				"_lb_reward_floor",
				"_list_reward",
				"giftIcon",
			])
	}
}
window["DungeonRuneEnterView"] = DungeonRuneEnterView
