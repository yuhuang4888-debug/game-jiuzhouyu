import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"

export class NineSkyModel extends EventDispatcher {

	/**
	 * 九魂圣殿 请求协议
	 */
	static REQUEST_CCMD_EVENT = "NSkM.REQUEST_CCMD_EVENT"
	/**
	 * 九魂圣殿 更新分数
	 */
	static UPDATE_SCORE = "NSkM.UPDATE_SCORE"
	/**
	 * 九魂圣殿 移除玩家
	 */
	static REMOVE_ROLE = "NSkM.REMOVE_ROLE"
	/**
	 * 九魂圣殿 攻击玩家
	 */
	static ATTACK_ROLE = "NSkM.ATTACK_ROLE"
	/**
	 * 九魂圣殿 战斗信息
	 */
	static NINE_SKY_FIGHTING_MSG = "NSkM.NINE_SKY_FIGHTING_MSG"
	/**
	 * 九魂圣殿 更新击杀信息
	 */
	static UPDATE_KILL_DATA = "NSkM.UPDATE_KILL_DATA"

	/**
	 * 九魂圣殿写死9层
	 */
	static MaxFloor = 9
	/**
	 * 普通模式默认场景index
	 */
	static NormalBaseSceneId = 27000
	/**
	 * 跨服模式默认场景index
	 */
	static ModBaseSceneId = 27010

	static Instance: NineSkyModel
	public static GetInstance() {
		if (!NineSkyModel.Instance) {
			NineSkyModel.Instance = new NineSkyModel()
		}
		return NineSkyModel.Instance
	}

	scene_mgr: SceneManager
	role_mgr: RoleManager
	notify_info: ProtoRecvVObj<13503>
	state_info: ProtoRecvVObj<13500>
	top_info: ProtoRecvVObj<13504>

	score
	server_type
	red_state
	need_init_state

	public constructor() {
		super()
		this.scene_mgr = SceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
	}

	public ResetData() {
		this.state_info = undefined
		this.notify_info = undefined
		this.top_info = undefined
		this.server_type = 1
		this.need_init_state = true
		this.red_state = undefined
	}

	public GetNotifyInfo() {
		return this.notify_info
	}

	public SetNotifyInfo(value: ProtoRecvVObj<13503>) {
		this.ChangeVar("notify_info", value)
	}

	public SetTopInfo(value: ProtoRecvVObj<13504>) {
		this.ChangeVar("top_info", value)
		this.UpdateDropState()
	}

	public GetTopInfo() {
		return this.top_info
	}

	public UpdateDropState(role_list?) {
		if (!this.scene_mgr.IsNineSkyFightScene()) {
			return
		}
		if (!this.top_info) {
			return
		}
		role_list = role_list || this.scene_mgr.GetAllRoleVos()

		let total_vo_list = []
		for (let role_id in role_list) {
			table.insert(total_vo_list, role_list[role_id])
		}
		table.insert(total_vo_list, this.role_mgr.GetMainRoleVo())

		for (let _tmpi in total_vo_list) {
			var role_vo = total_vo_list[_tmpi]
			if (role_vo.role_id == this.top_info.role_id) {
				role_vo.ChangeVar("boss_flag", 100)
			} else {
				role_vo.ChangeVar("boss_flag", 0)
			}
		}
	}

	public SetScore(value) {
		this.ChangeVar("score", value)
	}

	public GetScore() {
		return this.score
	}

	public GetStateInfo() {
		return this.state_info
	}

	public SetStateInfo(value: ProtoRecvVObj<13500>) {
		this.ChangeVar("state_info", value)
		this.server_type = value.mod
		this.RefreshRed()
	}

	public RefreshRed() {
		let state = this.CheckOpenState()
		if (this.red_state !== state) {
			this.red_state = state
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().NineSky, state)
		}
	}

	public GetRedState(){
		return this.red_state
	}

	public CheckOpenState() {
		let bool = false
		if (this.GetOpenState()) {
			let value = this.GetStateInfo()
			if (value) {
				bool = value.state == 1
			}
		}
		return bool
	}

	public GetOpenState() {
		return CommonManager.GetInstance().CheckFuncOpenState("BattleFieldEnterView", true)
	}
}


window["NineSkyModel"] = NineSkyModel