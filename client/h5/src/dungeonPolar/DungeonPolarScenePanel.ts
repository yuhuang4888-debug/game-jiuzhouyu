import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossSceneManager, BossSceneEvent } from "../commonController/BossSceneManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { BossModel } from "../commonModel/BossModel"
import { TaskModel } from "../commonModel/TaskModel"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDeltaY, SetLocalScaleX } from "../util/Util"
import { DungeonPolarDamage } from "./DungeonPolarDamage"
import { DungeonPolarPanelItem } from "./DungeonPolarPanelItem"

export class DungeonPolarScenePanel extends BaseItem1 {
	AddBossDamage
	GetDamageList
	InitEvent
	LoadSuccess
	RemoveDamage
	SwitchBtn
	UpdateBossDamage
	boss_damage_dic
	changePanel
	check_Boss_way
	d_loop_mgr
	find_Boss
	loop_mgr
	setPanel
	showpanel
	tween_list
	item_list
	show_damage_boss_ins_id
	public constructor(parent?) {
		super(parent)


		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarScenePanel"
		this.dependent_res = ["suitboss"]
		this.preload_server_config = { "config_week_dungeon_boss": false }
		let _model = BaseDungeonModel.GetInstance()
		let local_ResManager = ResManager.GetInstance()
		let _scene_mgr = SceneManager.GetInstance()
		let scene = Scene.GetInstance()
		let bossList = []
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_TimeUtil = TimeUtil
		let itemType = "boss"
		let panel_touch = false
		let panel_state = true
		this.item_list = []
		this.boss_damage_dic = []
		this.tween_list = []
		let bossModel = BossModel.GetInstance()
		this.load_callback = () => {
			this._scroller.vScrollBarSkin = ""
			this.InitEvent()
			this.LoadSuccess()
			this.check_Boss_way()
		}

		this.InitEvent = () => {

			this.BindEvent(local_GlobalEventSystem, local_EventName.SHOWRELIVEWINDOW, (type?) => {
				if (this.use_delete_method || !this.is_loaded) {
					return
				}
				if (type == 0) {
					if (!_model.dead_time) {
						_model.dead_time = local_TimeUtil.getServerTime()
					}
				} else if (type == 1) {
					_model.dead_time = null
					this.check_Boss_way()
				}
			}
			)
			this.BindEvent(_model, BaseDungeonModel.POLAR_BOSS_INFO_UPDATE, () => {
				if (this.use_delete_method || !this.is_loaded) {
					return
				}

				setTimeout(() => {
					let drop = scene.FindDropItem(scene.pick_drop_distance)
					if (drop) {
						return
					}
					this.check_Boss_way()
				}, 2)
			}
			)

			this.BindEvent(GlobalEventSystem, SceneEventType.PICK_UP_END, () => {
				if (this.use_delete_method || !this.is_loaded) {
					return
				}
				this.check_Boss_way()
			}
			)



			this.BindEvent(_model, BaseDungeonModel.POLAR_RELIVE_TIME, () => {
				this._lb_relive.text = "队伍剩余复活次数：" + _model.relive_time
			}
			)
			//this._rbtn_boss.group.addEventListener(local_eui.UIEvent.CHANGE, this.SwitchBtn, this)

			Util.AddClickEvent(this._rbtn_boss, () => {
				this.SwitchBtn("boss")
			}, this)

			Util.AddClickEvent(this._rbtn_damage, () => {
				this.SwitchBtn("damage")
			}, this)


			Util.AddClickEvent(this._panel_btn, () => {
				this.showpanel(!panel_state)
			}
				, this)
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
				this.UpdateBossDamage(monster_id, list)
			}
			)
			this.BindEvent(GlobalEventSystem, EventName.ADD_BOSS_DAMAGE_DATA, (vo?) => {
				this.AddBossDamage(vo)
			}
			)
			this.BindEvent(GlobalEventSystem, EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
				this.RemoveDamage(monster_id, list)
			}
			)
			this.BindEvent(BossSceneManager.GetInstance(), BossSceneEvent.CLEAN_DAMAGE_BOSS_INS_ID, (monster_id?) => {
				this.RemoveDamage(monster_id, null, true)
			}
			)


			//重登之后，等模型加载出来再寻路
			this.BindEvent(GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_RES_LOAD_COMPLETE, () => {
				if(SceneManager.GetInstance().IsPolarDungeon()||SceneManager.GetInstance().IsKFPolarDungeon()){
					this.check_Boss_way()
				}
			})

			this.BindEvent(GlobalEventSystem, EventName.LOADMAP_COMPLETE, () => {
				if(SceneManager.GetInstance().IsPolarDungeon()||SceneManager.GetInstance().IsKFPolarDungeon()){
					this.check_Boss_way()
				}
			})

		}

		this.LoadSuccess = () => {
			//local_ResManager.SetOutsideImageSprite(this, this._img, GameResPath.GetIcon("advancedExp", "uizbfb_041"))
			let dun_id = _scene_mgr.GetCurrDunId()
			let str_dun_id = String(dun_id)
			let type = str_dun_id.slice(-1)

			this._txt_title1.text = type == "1" ? "极寒之地" : "埋骨之地"

			//SetSizeDeltaY(this._img_bg,not _scene_mgr.IsPolarDungeon() && 199 || 175)
			let week_dungeon_boss_cfg = local_ResManager.GetGameConfigFromCache(this, "config_week_dungeon_boss", false)//Config.Weekdungeonboss
			bossList = _model.polarbossList(week_dungeon_boss_cfg, dun_id)
			this.setPanel()
			this._lb_relive.visible = !_scene_mgr.IsPolarDungeon()
			this._lb_relive.text = "队伍剩余复活次数：" + _model.relive_time

			this.SwitchBtn("boss")
		}

		this.setPanel = () => {
			let dataList = []
			if (itemType == "boss") {
				dataList = bossList
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content, DungeonPolarPanelItem, dataList, LoopScrCon.Vertical)
				} else {
					this.loop_mgr.replaceAll(dataList)
				}
			} else {
				dataList = this.GetDamageList()
				// if (!this.d_loop_mgr) {
				// 	this.d_loop_mgr = new LoopScrowViewMgr()
				// 	this.d_loop_mgr.SetData(this.dContent, DungeonPolarDamage, dataList, LoopScrCon.Vertical)
				// } else {
				// 	this.d_loop_mgr.replaceAll(dataList)
				// }


				for (let i = 0; i < dataList.length; i++) {
					let item: DungeonPolarDamage = this.item_list[i]
					if (!item) {
						item = new DungeonPolarDamage(this.dContent)
						item.Load()
						this.item_list[i] = item
					}
					item.SetVisible(true)
					item.SetData(dataList[i])
				}


				for (let p = this.item_list.length - 1; p >= dataList.length; p--) {
					this.item_list[p].SetVisible(false)
				}

			}

			this.Content.visible = itemType == "boss"
			this._scroller.visible = itemType != "boss"
		}

		this.check_Boss_way = () => {
			let bossInfo = null
			for (let key in bossList) {

				let boss = bossList[key]
				let flag = _model.PolarBossInfo(boss.boss_id)
				if (flag != null && flag != 1) {
					bossInfo = boss
					break
				}
			}
			if (bossInfo) {
				this.find_Boss(bossInfo)
			}
		}

		this.find_Boss = (bossInfo?) => {
			let main_role = Scene.GetInstance().main_role
			if (bossInfo && main_role) {
				let pos_List = JSON.parse(bossInfo.boss_born)[0]
				let real_x = pos_List[0] / SceneObj.GetLogicRealRatio().x
				let real_y = pos_List[1] / SceneObj.GetLogicRealRatio().y

				let findVo = new FindVo()
				findVo.type = FindVo.MONSTER
				findVo.sceneId = SceneManager.GetInstance().GetSceneId()
				findVo.id = bossInfo.boss_id
				findVo.x = real_x
				findVo.y = real_y
				findVo.range = 5
				findVo.call_back = () => {
					AutoFightManager.GetInstance().SetAutoFight(true)
					BossSceneManager.GetInstance().SetAutoState(true)
				}
				let logic_pos = main_role.GetLogicPos()
				if (findVo.x != -1 && findVo.y != -1 && logic_pos.x != -1 && logic_pos.y != -1) {
					if ((GameMath.GetDistance(logic_pos.x, logic_pos.y, findVo.x, findVo.y) > TaskModel.ADD_SPEED_DISTANCE * TaskModel.ADD_SPEED_DISTANCE)) {
						TaskModel.GetInstance().AddSpeedEffect()
					} else {
						TaskModel.GetInstance().CancelSpeedEffect()
					}
				}
				//GlobalEventSystem.Fire(EventName.FIND, findVo)
				AutoFightManager.GetInstance().SetAutoFight(false)
				BossSceneManager.GetInstance().SetAutoState(false)
				let call_fun = () => {
					let monster = Scene.GetInstance().GetMonsterByTypeId(findVo.id)
					BossSceneManager.GetInstance().SetAttackTarget(monster)
					AutoFightManager.GetInstance().SetAutoFight(true)
					BossSceneManager.GetInstance().SetAutoState(true)
				}

				Scene.GetInstance().MainRoleMove(findVo, 0, call_fun)


				_model.Fire(BaseDungeonModel.CHANGE_POLAR_BOSS, bossInfo.boss_id)
			}
		}

		this.SwitchBtn = (type?) => {
			if (type == "boss") {
				local_ResManager.SetImageSprite(this, this.img_rbtn_boss, "common4", "ui_btn_achv_highlight")
				local_ResManager.SetImageSprite(this, this.img_rbtn_damage, "common4", "ui_btn_achv")
				this.lb_rbtn_boss.color = ColorUtil.TryParseHtmlString("#9b572f")
				this.lb_rbtn_damage.color = ColorUtil.TryParseHtmlString("#ffffff")
			} else {
				local_ResManager.SetImageSprite(this, this.img_rbtn_boss, "common4", "ui_btn_achv")
				local_ResManager.SetImageSprite(this, this.img_rbtn_damage, "common4", "ui_btn_achv_highlight")
				this.lb_rbtn_boss.color = ColorUtil.TryParseHtmlString("#ffffff")
				this.lb_rbtn_damage.color = ColorUtil.TryParseHtmlString("#9b572f")
			}
			itemType = type
			this.setPanel()
		}

		this.showpanel = (bool?) => {
			///bool true展开 false收缩
			if (panel_touch) {
				return
			}

			this.changePanel(false)
			let tweenId
			let tween_type = SYTweenFunc.EASE_OUT
			if (!bool) {
				panel_state = false
				tweenId = SYTweenLite.to(this, this._panel_btn, SYTweenLite.UiAnimationType.POSX, 40, 0.2, () => {
					SetLocalScaleX(this._panel_btn, -1)
				}, tween_type)
				table.insert(this.tween_list, tweenId)


				tweenId = SYTweenLite.to(this, this._panel_gp, SYTweenLite.UiAnimationType.POSX, - (this._panel_gp.width + 12), 0.2, () => {
					this.changePanel(true)
				}, tween_type)
				table.insert(this.tween_list, tweenId)
			} else {
				panel_state = true

				tweenId = SYTweenLite.to(this, this._panel_btn, SYTweenLite.UiAnimationType.POSX, 267, 0.2, () => {
					SetLocalScaleX(this._panel_btn, 1)
				}, tween_type)
				table.insert(this.tween_list, tweenId)

				tweenId = SYTweenLite.to(this, this._panel_gp, SYTweenLite.UiAnimationType.POSX, 4, 0.2, () => {
					this.changePanel(true)
				}, tween_type)
				table.insert(this.tween_list, tweenId)

			}
		}

		this.changePanel = (bool?) => {
			if (bool) {
				panel_touch = false
			} else {
				panel_touch = true
			}
		}

		this.UpdateBossDamage = (monster_id?, list?) => {
			if (!this.boss_damage_dic) {
				this.boss_damage_dic = []
			}
			let dic = []
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				dic[vo.player_id] = vo
			}
			this.boss_damage_dic[monster_id] = dic
			if (itemType == "damage") {
				this.setPanel()
			}
		}

		this.AddBossDamage = (vo?) => {
			let dic = this.boss_damage_dic && this.boss_damage_dic[vo.monster_id]
			if (dic) {
				let data = dic[vo.player_id]
				if (data) {
					data.damage = data.damage + vo.damage
					data.player_name = vo.player_name
				} else {
					dic[vo.player_id] = vo
				}
			} else {
				let dic = []
				dic[vo.player_id] = vo
				this.boss_damage_dic[vo.monster_id] = dic
			}
			if (itemType == "damage") {
				this.setPanel()
			}
		}

		this.RemoveDamage = (monster_id?, list?, all?) => {
			if (all == null) {
				all = false
			}
			let dic = this.boss_damage_dic && this.boss_damage_dic[monster_id]
			if (dic) {
				if (all) {
					this.boss_damage_dic[monster_id] = null
				} else {
					for (let _tmpi in list) {
						var data = list[_tmpi]
						if (dic[data.player_id]) {
							dic[data.player_id] = null
						}
					}
				}
				if (itemType == "damage") {
					this.setPanel()
				}
			}
		}

		this.GetDamageList = () => {


			let list = []
			if (this.boss_damage_dic && this.boss_damage_dic[bossModel.show_damage_boss_ins_id]) {
				let dic = this.boss_damage_dic[bossModel.show_damage_boss_ins_id]
				let total_damage = 0
				for (let key in dic) {

					let vo = dic[key]
					total_damage = total_damage + vo.damage
					table.insert(list, vo)
				}
				table.sort(list, (a?, b?) => {
					return a.damage < b.damage
				})
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (!vo.damage) {
						vo.modulus = 0
					} else {
						vo.modulus = `${Number(vo.damage * 100 / total_damage).toFixed(2)}`
					}
				}
			}
			return list


		}
	}

	public DeleteMe() {

		if (this.boss_damage_dic) {
			this.boss_damage_dic = null
		}

		if (this.tween_list != []) {
			for (let i in this.tween_list) {
				var v = this.tween_list[i]
				SYTweenLite.Stop(v);
			}
			this.tween_list = []
		}

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}

		// if (this.d_loop_mgr) {
		// 	this.d_loop_mgr.DeleteMe()
		// 	this.d_loop_mgr = null
		// }
		for (let i = 0; i < this.item_list.length; i++) {
			this.item_list[i].DeleteMe()
			this.item_list[i] = null
		}
		this.item_list = []

		super.DeleteMe()
	}



	_panel_gp: Laya.Box
	_img_bg: Laya.Image
	_img_jiejie_b: Laya.Image
	_txt_title1: Laya.Text
	_Group1: Laya.Box
	_rbtn_boss: Laya.Box
	img_rbtn_boss: Laya.Image
	lb_rbtn_boss: Laya.Label
	_rbtn_damage: Laya.Box
	img_rbtn_damage: Laya.Image
	lb_rbtn_damage: Laya.Label
	_lb_relive: Laya.Label
	Content: Laya.List
	_scroller: Laya.Panel
	dContent: Laya.VBox
	_panel_btn: Laya.Image
	public GetComponents() {
		[
			this._panel_gp,
			this._img_bg,
			this._img_jiejie_b,
			this._txt_title1,
			this._Group1,
			this._rbtn_boss,
			this.img_rbtn_boss,
			this.lb_rbtn_boss,
			this._rbtn_damage,
			this.img_rbtn_damage,
			this.lb_rbtn_damage,
			this._lb_relive,
			this.Content,
			this._scroller,
			this.dContent,
			this._panel_btn,
		]
			= this.GetChildrenByNames([

				"_panel_gp",
				"_img_bg",
				"_img_jiejie_b",
				"_txt_title1",
				"_Group1",
				"_rbtn_boss",
				"img_rbtn_boss",
				"lb_rbtn_boss",
				"_rbtn_damage",
				"img_rbtn_damage",
				"lb_rbtn_damage",
				"_lb_relive",
				"Content",
				"_scroller",
				"dContent",
				"_panel_btn",
			])
	}
}
window["DungeonPolarScenePanel"] = DungeonPolarScenePanel