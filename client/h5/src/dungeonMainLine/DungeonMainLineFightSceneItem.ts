import { BaseAwardItem } from "../common/BaseAwardItem"
import { Config } from "../common/Config"
import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType, EventName } from "../common/EventName"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { StoryController } from "../commonController/StoryController"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetSizeDeltaX, SetAnchoredPosition, SetLocalPositionX, Util, SetLocalScaleX } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class DungeonMainLineFightSceneItem extends BaseItem1 {
	InitEvent
	LoadSuccess
	MoveState
	ShowAwardItem
	UpdateArrowState
	UpdateView

	item_list
	skill_data
	tweenId
	tweenId2
	cfg_grade

	public constructor(parent?) {
		super(parent)
		this.base_file = "dungeonMainLine"
		this.layout_file = "DungeonMainLineFightSceneItem"
		this.preload_client_config = {
			"ConfigMainLineDungeon": false,
		}

		let base_model = BaseDungeonModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_laya = Laya
		let arrow_state_ = false

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.cfg_grade = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
			this.display_obj.left = 0
			this.display_obj.y = 500
			this._gp_reward.hScrollBarSkin = ""

			// this.form.pivot = Vector2(0, 0)
			// this.form.anchorMax = Vector2(0, 0)
			// this.form.anchorMin = Vector2(0, 0)
			// this.form.anchoredPosition = Vector2(2, 500)

			SetLocalPositionX(this._gp_con, -this._gp_con.width - this._gp_con.x)

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonMainLine", "uizxgj_001"))
			this.InitEvent()
			this.UpdateView()
			this.ShowAwardItem()

			// this.skill_data = Config.ConfigMainLineDungeon.skill_data
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._skill, GameResPath.GetSkillIconPath(BaseDungeonModel.MAIN_LINE_ADD_EXP_RADIO_SKILL_ID))
			//AutoFightManager:GetInstance():SetAutoFight(true)
			//this:MoveState()
		}

		this.InitEvent = () => {
			// Util.AddClickEvent(
			// 	this._skill,
			//() => {
			// 		if (this.skill_data ) {
			// 			let next_level = base_model.GetMainLineLevel() + 1
			// 			let desc = this.skill_data.desc
			// 			let ratio = (base_model.GetLevel2AddExpRatio(next_level)*100) + "%"
			// 			desc = string.format(desc,ratio)
			// 			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SkillTipsView", {
			// 				is_fake = true,
			// 				desc = desc,
			// 				path = GameResPath.GetSkillIconPath(BaseDungeonModel.MAIN_LINE_ADD_EXP_RADIO_SKILL_ID),
			// 				name = this.skill_data.name	
			// 			})
			// 		}
			// 	},
			// 	this,
			// 	true
			// )

			this.BindEvent(GlobalEventSystem, SceneEventType.PICK_UP_END, () => {
				setTimeout(() => {
					base_model.Fire(BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
				}, 1000)
			})

			Util.AddClickEvent(this.arrow_box, () => {
				arrow_state_ = !arrow_state_
				this.UpdateArrowState()
			}, this, false)

			let storyControllerInstance = StoryController.Instance
			if (!storyControllerInstance.nowStoryInfo) {
				this.MoveState()
			} else {
				this.BindEvent(GlobalEventSystem, EventName.STORY_FINISH, (bool?) => {
					this.MoveState()
				})
			}
			MainUIManager.GetInstance().AddMoveComponent(this, this.display_obj, false, MainUIManager.MOVE_TYPE.Left)
		}

		this.UpdateArrowState = () => {
			// SetLocalScaleX(this._img_arrow, arrow_state_ && 1.4 || -1.4)
			this._img_arrow.rotation = arrow_state_ ? 270 : 90
			if (this.tweenId) {
				SYTweenLite.Stop(this.tweenId)
			}
			let endValue = arrow_state_ && -this._gp_con.width - this._gp_con.x || 0
			this.tweenId =
				SYTweenLite.to(
					this,
					this._gp_con,
					SYTweenLite.UiAnimationType.POSX,
					endValue,
					0.2, () => {
						this.tweenId = false
					}
				)
		}

		this.UpdateView = () => {
			// let next_level = base_model.GetMainLineLevel() + 1
			// this._lb_level.text = String(next_level)
			let main_line_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigMainLineDungeon", true);
			let client_boss_cfg = main_line_cfg && main_line_cfg["boss_cfg"]
			let dun_id = SceneManager.GetInstance().GetCurrDunId()


			if (client_boss_cfg && dun_id && client_boss_cfg[dun_id]) {
				this._lb_kill_desc.text = "限时击杀" + client_boss_cfg[dun_id].name
			}
			// let index = next_level % 10
			// let cfg = client_boss_cfg && client_boss_cfg[index]


			//let scene_id = SceneManager.GetInstance().GetSceneId()

			//let subtype = 0

			//let bool = true
			//let data
			//let key
			//while (bool) {
			//subtype = subtype + 1
			//key = dun_id + "@" + scene_id + "@" + subtype + "@" + 1
			//if (! Config.Dungeonwave[key] ) {
			//bool = false
			//}else{
			//data = Config.Dungeonwave[key]
			//}

			//}

			//if (data ) {
			//data = ErlangParser.GetInstance().Parse(data.mon_list)
			//let monster_id = data && data[1] && data[1][1]
			//if (monster_id ) {
			//let monster_data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name,Number(monster_id), false)
			//if (monster_data ) {
			//this._lb_kill_desc.text = "限时击杀" + monster_data.name
			//}
			//}
			//}
		}

		this.MoveState = () => {
			this.tweenId2 =
				SYTweenLite.to(
					this,
					this._gp_con,
					SYTweenLite.UiAnimationType.POSX,
					0,
					0.1, () => {
						this.tweenId = false
					},
					SYTweenFunc.EASE_OUT_BACK
				)
		}

		this.ShowAwardItem = () => {
			let dun_id = SceneManager.GetInstance().GetCurrDunId()
			let dun_key = dun_id + "@0@0"
			let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_grade.name, dun_key, false, this.cfg_grade)
			//let dun_cfg = this.cfg_grade[dun_key]
			let career = RoleManager.GetInstance().GetMainRoleCareer()
			let list
			if (dun_cfg && dun_cfg.reward) {
				let reward_cfg = ErlangParser.GetInstance().Parse(dun_cfg.reward)
				for (let i in reward_cfg) {
					if (career == Number(reward_cfg[i][0])) {
						list = reward_cfg[i][1]
						break
					}
				}
			}

			//let ConfigMainLineDungeon = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigMainLineDungeon", true);
			//let list = ConfigMainLineDungeon.pre_reward
			if (!list) {
				list = []
			}
			if (!this.item_list) {
				this.item_list = []
			}
			for (let index in list) {
				let v = list[index]
				let item = this.item_list[index]
				if (!item) {
					item = new BaseAwardItem(this.con)
					item.SetItemSize(70, 70)
					this.item_list[index] = item
					item.Load()
				}
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, v[2], lock)
				}
			}
		}
	}

	public DeleteMe() {
		if (this.tweenId) {
			SYTweenLite.Stop(this.tweenId)
		}

		if (this.tweenId2) {
			SYTweenLite.Stop(this.tweenId2)
		}
		MainUIManager.GetInstance().RemoveMoveComponent(this)

		if (this.item_list) {
			for (let k in this.item_list) {
				var v = this.item_list[k]
				v.DeleteMe()
			}
			this.item_list = false
		}
		super.DeleteMe()
	}

	_gp_con: Laya.Box
	_img_bg: Laya.Image
	_lb_kill_desc: Laya.Label
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Label2: Laya.Label
	_Label3: Laya.Label
	arrow_box: Laya.Box
	_img_arrow: Laya.Image
	_skill: Laya.Image
	_gp_reward: Laya.Panel
	con: Laya.HBox
	public GetComponents() {
		[
			this._gp_con,
			this._img_bg,
			this._lb_kill_desc,
			this._Image3,
			this._Image4,
			this._Label2,
			this._Label3,
			this.arrow_box,
			this._img_arrow,
			this._skill,
			this._gp_reward,
			this.con,
		]
			= this.GetChildrenByNames([
				"_gp_con",
				"_img_bg",
				"_lb_kill_desc",
				"_Image3",
				"_Image4",
				"_Label2",
				"_Label3",
				"arrow_box",
				"_img_arrow",
				"_skill",
				"_gp_reward",
				"con",
			])
	}
}
window["DungeonMainLineFightSceneItem"] = DungeonMainLineFightSceneItem