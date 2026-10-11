import { Alert } from "../alert/Alert"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameMath } from "../util/GameMath"
import { TimeUtil } from "../util/TimeUtil"
import { IsInTable, Util } from "../util/Util"
import { HolyTerritoryModel } from "../commonModel/HolyTerritoryModel"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"

export const BossSceneEvent = {
	TIRED_DATA_UPDATE: "WorldBossModelEvent.UPDATE_ICON",
	UPDATE_SUIT_ANGER: "UPDATE_SUIT_ANGER",
	MAX_ANGER_EXIT_SUIT_BOSS: "MAX_ANGER_EXIT_SUIT_BOSS",
	CLOSE_SUIT_RELIVE_VIEW: "CLOSE_SUIT_RELIVE_VIEW",
	SELECT_BOSS_TYPE: "SELECT_BOSS_TYPE",
	CLEAN_DAMAGE_BOSS_INS_ID: "CLEAN_DAMAGE_BOSS_INS_ID"
}
window["BossSceneEvent"] = BossSceneEvent

export class BossSceneManager extends EventDispatcher {

	static SWITCH_ITEM = "BSM.SWITCH_ITEM"
	static Instance: BossSceneManager

	_attack_target
	attack_target
	_auto

	libel_list
	secret_boss_conf_list
	_show_damage_boss_ins_id
	alert
	relive_success
	select_boss_id
	sufferd_list
	return_safe_success

	main_role_vo
	boss_model
	scene
	scene_mgr
	public constructor() {
		super()

		this._auto = false
		this.select_boss_id = 0
		this.sufferd_list = []

		this.main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
		this.boss_model = BossModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.scene = Scene.GetInstance()

		this.alert = false
		this.libel_list = []
		this.relive_success = false
		this.secret_boss_conf_list = []
		this.return_safe_success = false
	}

	public static GetInstance() {

		if (!BossSceneManager.Instance) {
			BossSceneManager.Instance = new BossSceneManager()
		}
		return BossSceneManager.Instance
	}

	SetBossTiredData = (data?, boss_type?) => {
		this.Fire(BossSceneEvent.TIRED_DATA_UPDATE, data.boss_tired, boss_type)
		if (this.scene_mgr.IsHolyBossScene() && boss_type && boss_type == BossModel.BossType.eudaemon) {
			this.boss_model.Fire(BossModel.UPDATE_ER_TIRED_VALUE, data.boss_tired)
		}
	}

	FindBossInfo = (dataList?, boosid?) => {
		for (let _tmpi in dataList) {
			var info = dataList[_tmpi]
			if (info.boss_id == boosid) {
				return info
			}
		}
		return null
	}

	SceneOneBoss = (list?) => {
		let boss = null
		if (list.length > 1) {
			let x = null
			let y = null
			let distance = null
			let attacker = this.scene.main_role
			for (let key in list) {

				if (list[key]) {
					let info = list[key]
					x = info.x
					y = info.y
					let newdistance = GameMath.GetDistance(attacker.real_pos.x, attacker.real_pos.y, x, y)
					if (!distance || newdistance < distance) {
						distance = newdistance
						boss = info
					}
				}
			}
		} else {
			boss = list.length > 0 && list[1] || null
		}
		return boss
	}

	FindBossIndexById = (list?, bossid?) => {
		if (!list) {
			return
		}
		let index = 0
		let find = false
		for (let _ in list) {
			var info = list[_]
			if (info.boss_id == bossid) {
				find = true
				break
			}
			index = index + 1
		}
		if (find) {
			return Math.min(index, list.length)
		}
	}

	SetSufferedList = (id?) => {
		if (id) {
			this.sufferd_list[id] = TimeUtil.getServerTime()
		}
	}

	IsSuffered = (id?) => {
		let flag = false
		if (this.sufferd_list[id]) {
			flag = true
			let time = this.sufferd_list[id]
			if (TimeUtil.getServerTime() - time > 5) {
				flag = false
				this.sufferd_list[id] = null
			}
		}
		return flag
	}

	ResetData = () => {
		this.attack_target = null
		this.sufferd_list = []
		this.select_boss_id = 0
	}

	JudgeTired = (show?, boss_type?, boss_id?) => {
		if (show == null) {
			show = true
		}
		let flag = true
		if (this.scene_mgr.IsHolyBossScene() && boss_id) {
			let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holy)
			if (info) {
				flag = info.tired < info.max_tired
			}
			if (!flag) {
				if (show) {
					Message.show("今日已无次数，无法对BOSS造成伤害！")
				}
			}
		} else if (this.scene_mgr.IsFieldBossScene()) {
			if (boss_type && boss_type != BossModel.BossType.field) {
				return flag
			}
			let info = this.boss_model.GetBossTypeInfo(boss_type)
			if (this.scene_mgr.IsFieldBossScene()) {
				info = this.boss_model.GetBossTypeInfo(BossModel.BossType.field)
			}
			if (boss_id && info) {
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false)
				let tired_add = config && config.tired_add || 0
				flag = info.tired >= tired_add
			}
			if (!flag && show && boss_id) {
				let boss_vo = this.boss_model.GetBossInfo(boss_type,boss_id)
				this.boss_model.Fire(BossModel.OPEN_BOSS_TIRED_ALERT,boss_vo)
			}
		} else if (this.scene_mgr.IsHolyTerritory()) {
			let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.holyterritory)
			if (info) {
				flag = info.tired < info.all_tired
			}
			if (!flag) {
				let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, boss_id, false)
				// let config = config_boss_cfg[boss_id]
				if (!config || config.sign != 1) {
					flag = true
				}
				if ((!flag && show) && !HolyTerritoryModel.GetInstance().IsSelfHT()) {
					Alert.Show("和平首领疲劳值已满,无法攻击和平首领。<br>请前往攻击<font color='#639c12'>非和平首领</font>")
				}
			}
		} else if (this.scene_mgr.IsKfHolyAreaScene()) {
			flag = KfHolyAreaModel.GetInstance().JudgeTired(show)
		}
		return flag
	}

	JudgeTiredByType = (boss_type?) => {
		let flag = true
		if (boss_type && boss_type != BossModel.BossType.field) {
			return flag
		}
		let info = this.boss_model.GetBossTypeInfo(BossModel.BossType.field)
		if (!info) {
			return flag
		}
		flag = info.all_tired - info.tired > 0
		let num = GoodsModel.GetInstance().GetTypeGoodsNum(BossModel.tired_goods_id)
		if (!flag && num > 0) {
			flag = true
		}
		return flag
	}

	JudgeTarget = (list?) => {
		if (this.attack_target && this.attack_target.obj_type == SceneBaseType.Role) {
			if (list.find(this.attack_target) == -1) {
				this.attack_target = null
			}
		}
	}

	NearBossRole = (bossPos?) => {
		let role_list = this.GetSecneRoleList()
		let distance = 0
		let nearRole = null
		let range = 400
		let guild_id = this.main_role_vo.guild_id
		for (let key in role_list) {

			let role = role_list[key]
			if (!this.scene_mgr.IsCanAttackByMainRole(role.vo)) {
				break
			}
			let newDistance = GameMath.GetDistance(role.real_pos.x, role.real_pos.y, bossPos.x, bossPos.y)
			if (newDistance <= range * range && newDistance > distance) {
				nearRole = role
			}
		}
		return nearRole
	}

	CheckRole = (bossPos?) => {
		let main_role = this.scene.main_role
		let nearRole = null
		let range = 600
		let distance = GameMath.GetDistance(main_role.logic_pos.x, main_role.logic_pos.y, bossPos.x, bossPos.y)
		if (distance > range * range) {
			return true
		}
		return false
	}

	NearSufferedRole = () => {
		if (!Util.IsTableEmpty(this.sufferd_list)) {
			let main_role = this.scene.main_role
			let lastDistance = null
			let nearRole = null
			for (let key in this.sufferd_list) {

				let role_id = key
				let role = this.scene.GetRole(role_id)
				if (!role) {
					break
				}
				let distance = GameMath.GetDistance(role.real_pos.x, role.real_pos.y, main_role.real_pos.x, main_role.real_pos.y)
				if (!lastDistance || distance < lastDistance) {
					nearRole = role
					lastDistance = distance
				}
			}
			return nearRole
		}
	}

	OwnerRole = () => {
		let _ownerRole = null
		let role_list = this.GetSecneRoleList()
		for (let key in role_list) {

			let role = role_list[key]
			if (!this.scene_mgr.IsCanAttackByMainRole(role.vo)) {
				break
			}
			if (role.vo.boss_flag == 1) {
				_ownerRole = role
				break
			}
		}
		return _ownerRole
	}

	GetOwnerTeamId = (role_id?) => {
		let role = this.scene.GetRole(role_id)
		if (role && role.vo) {
			return role.vo.team_id
		}
	}

	GetDamageBossInstanceId() {

		return this._show_damage_boss_ins_id
	}

	SetDamageBossInstanceId(value?) {

		if (this._show_damage_boss_ins_id != value) {
			if (!value) {
				this.Fire(BossSceneEvent.CLEAN_DAMAGE_BOSS_INS_ID, this._show_damage_boss_ins_id)
			}
			this._show_damage_boss_ins_id = value
		}
	}

	GetSortSecneRoleList() {


		let sufferd_list = []

		if (!Util.IsTableEmpty(this.sufferd_list)) {
			let main_role = this.scene.main_role
			let lastDistance = null
			let nearRole = null
			for (let key in this.sufferd_list) {

				let role_id = key
				let role = this.scene.GetRole(role_id)
				if (!role) {
					break
				}
				table.insert(sufferd_list, role)
			}
		}

		let role_list = []
		let mainRoleId = this.main_role_vo.role_id
		for (let key in this.scene.role_list) {

			let role = this.scene.role_list[key]
			if (role.IsDead() || IsInTable(role, sufferd_list)) {
				break
			}

			if (role.vo.role_id != mainRoleId) {
				let distance = GameMath.GetDistance(this.main_role_vo.pos_x, this.main_role_vo.pos_y, role.vo.pos_x, role.vo.pos_y)
				if (distance <= 800 * 800) {
					table.insert(role_list, role)
				}
			}
		}
		if (this.main_role_vo.boss_flag == 1) {
			table.insert(role_list, this.main_role_vo)
		}

		table.sort(role_list, (a?, b?) => {
			let aIndex = 100
			let bIndex = 100
			if (this.scene_mgr.IsCanAttackByMainRole(a.vo)) {
				aIndex = aIndex + 100
			}
			if (this.scene_mgr.IsCanAttackByMainRole(b.vo)) {
				bIndex = bIndex + 100
			}
			return bIndex > aIndex

		})

		let list = []

		for (let _ = 0; _ < sufferd_list.length; _++) {
			var vo = sufferd_list[_]
			table.insert(list, vo)
		}

		for (let _ = 0; _ < role_list.length; _++) {
			var vo = role_list[_]
			table.insert(list, vo)
		}

		return list
	}

	GetSecneRoleList() {

		let mainRoleId = this.main_role_vo.role_id
		let list = []
		let role_list = Scene.GetInstance().role_list
		for (let _ in role_list) {
			var role = role_list[_]
			if (role.IsDead()) {
				break
			}
			if (role.vo.role_id != mainRoleId) {
				table.insert(list, role)
			}
		}
		return list
	}

	SetAutoState(value?) {

		this._auto = value
	}

	GetAutoState() {

		return this._auto
	}

	public SetAttackTarget(value?) {

		let lastValue = this._attack_target
		this._attack_target = value
		if (this._attack_target != lastValue) {
			GlobalEventSystem.Fire(EventName.MAIN_ROLE_CHANGE_ATTACK_TARGRT, this._attack_target)
		}
	}

	GetAttackTarget() {

		return this._attack_target
	}


}

window["BossSceneManager"] = BossSceneManager