import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { TaskModel } from "../commonModel/TaskModel"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { FindVo } from "../scene/sceneobj/FindVo"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { Message } from "../sysInfo/SysInfoController"
export class DungeonPolarPanelItem extends BaseItemRenderer {
	_model

	public WIDTH = 250
	public HEIGT = 39
	public constructor(parent) {
		super()

		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarPanelItem"
		this.load_callback = () => {
			this._model = BaseDungeonModel.GetInstance()
			this.BindEvent(this._model, BaseDungeonModel.POLAR_BOSS_INFO_UPDATE, (boss_id?) => {
				if (this.data && boss_id == this.data.boss_id) {
					this.updatBossInfo()
				}
			}
			)
			Util.AddClickEvent(this._box, () => {
				this.item_touch()
			}, this, true)
		}
		this.Load()
	}



	public dataChanged() {
		if (!super.dataChanged()) return
		let vo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.boss_id, false)
		if (vo) {
			this._lb_name.text = vo.name
			let flag = this._model.PolarBossInfo(this.data.boss_id)
			this._lb_count.text = flag != 1 && '0/1' || '1/1'

			let color_str=ColorUtil.TryParseHtmlString(flag != 1 && Enum_ColorUtil_Dark.RED || Enum_ColorUtil_Dark.GREEN)
			this._lb_count.color =ColorUtil.GetReplaceChar(color_str)
		}
	}

	public updatBossInfo() {

		if (!this.data) {
			return
		}
		let flag = this._model.PolarBossInfo(this.data.boss_id)
		this._lb_count.text = flag != 1 && '0/1' || '1/1'
		let color_str=ColorUtil.TryParseHtmlString(flag != 1 && Enum_ColorUtil_Dark.RED || Enum_ColorUtil_Dark.GREEN)
		this._lb_count.color =ColorUtil.GetReplaceChar(color_str)
	}

	public item_touch() {

		let bossInfo = this.data
		if (bossInfo) {
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
				// let mon2=SceneManager.GetInstance().GetMonsterVoByTypeId(findVo.id)
				// let monster = Scene.GetInstance().GetMonsterByTypeId(findVo.id)
				// BossSceneManager.GetInstance().SetAttackTarget(monster)


				// AutoFightManager.GetInstance().SetAutoFight(true)
				// BossSceneManager.GetInstance().SetAutoState(true)
			}

			AutoFightManager.GetInstance().SetAutoFight(false)
			BossSceneManager.GetInstance().SetAutoState(false)
			let call_fun = () => {
				let monster = Scene.GetInstance().GetMonsterByTypeId(findVo.id)
				BossSceneManager.GetInstance().SetAttackTarget(monster)
				AutoFightManager.GetInstance().SetAutoFight(true)
				BossSceneManager.GetInstance().SetAutoState(true)
			}

			Scene.GetInstance().MainRoleMove(findVo, 0, call_fun)


			let logic_x, logic_y = Scene.GetInstance().main_role.GetLogicPos()
			if (findVo.x != -1 && findVo.y != -1 && logic_x != -1 && logic_y != -1) {
				if ((GameMath.GetDistance(logic_x, logic_y, findVo.x, findVo.y) > TaskModel.ADD_SPEED_DISTANCE * TaskModel.ADD_SPEED_DISTANCE)) {
					TaskModel.GetInstance().AddSpeedEffect()
				} else {
					TaskModel.GetInstance().CancelSpeedEffect()
				}
			}
			//Scene:GetInstance():FindElement(findVo)
			//GlobalEventSystem.Fire(EventName.FIND, findVo)
			this._model.Fire(BaseDungeonModel.CHANGE_POLAR_BOSS, bossInfo.boss_id)
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_box: Laya.Box
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_lb_count: Laya.Label
	public GetComponents() {
		[
			this._box,
			this._Image1,
			this._lb_name,
			this._lb_count,
		]
			= this.GetChildrenByNames([

				"_box",
				"_Image1",
				"_lb_name",
				"_lb_count",
			])
	}
}
window["DungeonPolarPanelItem"] = DungeonPolarPanelItem