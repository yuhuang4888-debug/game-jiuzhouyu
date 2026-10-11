import { AutoFightManager } from "../autofight/AutoFightManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameMath } from "../util/GameMath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BossModel } from "./BossModel"
import { WordManager } from "../common/WordManager"

export class SnatchTreasureModel extends EventDispatcher {
	AutoFight
	_allWave
	_autoFight
	_dunData
	_dunId
	_hurtList
	_mon_num
	_roundTime
	_thisHurtData
	_value
	_wave
	canAuto
	checkAutoFight
	checkTimer
	clean
	endtime
	getPoint
	haveMon
	last2pos
	lastPos
	newPos
	onTimer
	position
	removeTimer
	setDunData
	setDunId
	setHurtListData
	setSelfHurtData
	time
	timeMsgData

	position_config
	static Instance
	public static REQUEST_DUN_DATA = "STM.REQUEST_DUN_DATA";
	public static DUN_DATA_RETURN = "STM.DUN_DATA_RETURN";
	public static CHANGE_SELF_HURT = "STM.CHANGE_SELF_HURT";
	public static CHANGE_HURT_RANK = "STM.CHANGE_HURT_RANK";
	public static CHANGE_ROUND = "STM.CHANGE_ROUND";
	public static SCMD_REQUEST = "STM.SCMD_REQUEST";
	public constructor() {
		super()

		this.timeMsgData = null
		this.getPoint = (id?, territory_kv_cfg?) => {
			let cfg = this.getKvConfig(5, territory_kv_cfg)
			let pointConfig = cfg && JSON.parse(cfg.value)
			let point = 0
			if (pointConfig) {
				for (let key in pointConfig) {

					// [ts2lua]pointConfig下标访问可能不正确
					let conf = pointConfig[key]
					if (conf[0] == id) {
						point = conf[1]
						break
					}
				}
			}
			return point
		}
			;
		this.endtime = 0;
		this.setDunData = (data?) => {
			this._dunData = data
			this.Fire(SnatchTreasureModel.DUN_DATA_RETURN)
		}
			;
		this.setDunId = (value?) => {
			this._dunId = value
		}
			;
		this._wave = 1;
		this._mon_num = 0;
		this.setSelfHurtData = (data?) => {
			this._thisHurtData = data
			this.Fire(SnatchTreasureModel.CHANGE_SELF_HURT)
		}
			;
		this._roundTime = 0;
		this.setHurtListData = (data?) => {
			this._hurtList = data.rank
			if (this._wave != data.wave) {
				this._wave = data.wave
			}
			this._mon_num = data.num
			this.SetroundTime(data.time)
			this.Fire(SnatchTreasureModel.CHANGE_HURT_RANK)
		}
			;
		this.position = (dun_id?, wave?) => {
			// [ts2lua]this.position_config下标访问可能不正确
			return this.position_config[dun_id + "@" + wave]
		}
			;
		this.time = 5;
		this.checkAutoFight = () => {
			let autofight = AutoFightManager.GetInstance().GetAutoFightState()
			if ((((!autofight && this.canAuto) && !Scene.GetInstance().goToPos) && !this._autoFight) && !BossModel.GetInstance().auto_pick_up) {
				if (!this.checkTimer) {
					//this.checkTimer = Laya. new Timer(1000, 0)
					//this.checkTimer.addEventListener(Laya.TimerEvent.TIMER, this.onTimer, this)
					this.checkTimer = GlobalTimerQuest.AddPeriodQuest(() => {
						this.onTimer()
					}, 1, -1)
				}
				//if (! this.checkTimer.running ) {
				//this.checkTimer.start()
				//this:onTimer()
				//}
			} else {
				if (this.checkTimer) {
					GlobalTimerQuest.CancelQuest(this.checkTimer)
					this.checkTimer = null
					this.time = 5
				}
			}
		}
			;
		this.onTimer = () => {
			if (this.time <= 0) {
				this.resetAutoFight()
			}
			if (Scene.GetInstance().goToPos) {
				if (this.checkTimer) {
					GlobalTimerQuest.CancelQuest(this.checkTimer)
					this.checkTimer = null
					this.time = 3
				}
			}
			this.time = this.time - 1
		}
			;
		this.removeTimer = () => {
			if (this.checkTimer) {
				//if (this.checkTimer.running ) {
				//this.checkTimer.stop()
				//}
				//this.checkTimer.removeEventListener(Laya.TimerEvent.TIMER, this.onTimer, this)
				GlobalTimerQuest.CancelQuest(this.checkTimer)
				this.checkTimer = null
			}
		}
			;
		this.canAuto = true;
		this._autoFight = false;
		this.last2pos = null
		this.AutoFight = () => {
			if (BossModel.GetInstance().auto_pick_up || !this.canAuto) {
				return
			}
			ResManager.GetInstance().GetGameConfigWithAutoDestory("ClientSnatchTreasure", (cfgs?) => {
				let guaji_pos = cfgs["GUAJI_POINT"][this._dunId]
				if (!guaji_pos) {
					return
				}
				let main_role = Scene.GetInstance().main_role
				if (!main_role) {
					return
				}
				let posdic = cfgs["POINT"]
				if (!this.newPos) {
					let distance = null
					for (let key in guaji_pos) {

						let pos = posdic[key]
						let x = pos.x
						let y = pos.y
						let newdistance = GameMath.GetDistance(main_role.real_pos.x, main_role.real_pos.y, x, y)
						if (!distance || newdistance < distance) {
							distance = newdistance
							this.newPos = key
						}
					}
				}
				let guaji_pos_list = guaji_pos[this.newPos]
				let length = Util.TableSize(guaji_pos_list)
				if (this.lastPos) {
					this.last2pos = this.lastPos
				}
				let cache_list = []
				if (length > 0) {

					for (let i = guaji_pos_list.length - 1; i >= 0; i -= 1) {
						if (guaji_pos_list[i] != this.lastPos && guaji_pos_list[i] != this.last2pos) {
							table.insert(cache_list, guaji_pos_list[i])
						}
					}
				}
				else{
					let a = 1
					let b = a
				}
				this.lastPos = this.newPos
				let random = Util.RandomRange(0, Util.TableSize(cache_list) > 0 ? Util.TableSize(cache_list) - 1 : 0)
				// [ts2lua]guaji_pos_list下标访问可能不正确
				let randomPos = cache_list[random]
				// [ts2lua]posdic下标访问可能不正确
				let pos = posdic[randomPos]
				if (pos) {
					this._autoFight = true

					Scene.GetInstance().MainRoleMove(new Vector2(pos.x / SceneObj.GetLogicRealRatio().x, pos.y / SceneObj.GetLogicRealRatio().y - 2), 3, () => {
						this.newPos = randomPos
						if (this.haveMon()) {
							AutoFightManager.GetInstance().SetAutoFight(true)
						} else {
							this.AutoFight()
						}
					}
					)
				}
			}
				, true)
		}
			;
		this.haveMon = () => {
			let left_num = 1
			let monster_list = Scene.GetInstance().FindTargets(Scene.FIND_TARGET_TYPE.monster, left_num, 200, null, null, null, null)[0]
			if (monster_list.length > 0) {
				return true
			}
			return false
		}
			;
		this.clean = () => {
			this._thisHurtData = null
			this._hurtList = null
			this.lastPos = null
			this.newPos = null
			this._autoFight = false
			this._roundTime = 0
			this._allWave = 0
			this._wave = 1
			this._mon_num = 0
			this.endtime = 0
			this.removeTimer()
		}
			;
		this.clean()
	}

	public static GetInstance() {

		if (!SnatchTreasureModel.Instance) {
			SnatchTreasureModel.Instance = new SnatchTreasureModel()
		}
		return SnatchTreasureModel.Instance
	}

	public getKvConfig(key?, territory_kv_cfg?) {

		// [ts2lua]territory_kv_cfg下标访问可能不正确
		return territory_kv_cfg && territory_kv_cfg[key]
	}

	public getRewardList(territory_kv_cfg?) {

		let rewardList = []
		let worldLv = RoleManager.GetInstance().GetMainRoleVo().worldLv
		let cfg = this.getKvConfig(3, territory_kv_cfg)
		let rewardConf = cfg && JSON.parse(cfg.value)
		if (rewardConf) {
			for (let key in rewardConf) {

				// [ts2lua]rewardConf下标访问可能不正确
				let conf = rewardConf[key]
				if (worldLv >= Number(conf[0])) {
					rewardList = conf[1]
				} else {
					break
				}
			}
		}
		return rewardList
	}

	public getRankConfig(territory_rank_cfg?) {

		let list = []
		let level = RoleManager.GetInstance().GetMainRoleVo().worldLv
		let lastInfo = null
		for (let key in territory_rank_cfg) {

			// [ts2lua]territory_rank_cfg下标访问可能不正确
			let info = territory_rank_cfg[key]
			if (level >= info.min_wldlv && level <= info.max_wldlv) {
				table.insert(list, info)
			}
		}
		table.sort(list, (a?, b?) => {
			return a.min_rank < b.min_rank
		})
		for (let _ in list) {
			var info = list[_]
			if (level >= info.min_wldlv && level <= info.max_wldlv) {
				if (lastInfo) {
					// [ts2lua]info下标访问可能不正确
					info["max_rank"] = lastInfo.min_rank + 1
				} else {
					// [ts2lua]info下标访问可能不正确
					info["max_rank"] = info.min_rank
				}
				lastInfo = info
			}
		}
		return list
	}

	//function SnatchTreasureModel.__getters.value()
	//return this._value
	//}

	//function SnatchTreasureModel.__setters.value(v)
	//this._value = v
	//}


	public SetroundTime(value?) {

		if (this._roundTime == value) {
			return
		}
		this._roundTime = value
		if (this._roundTime > TimeUtil.getServerTime()) {
			this.Fire(SnatchTreasureModel.CHANGE_ROUND)
		}
	}

	public HurtListData() {

		let list = []
		let length = 10
		if (this._hurtList) {
			list = this._hurtList
			// [ts2lua]lua中0和空字符串也是true，此处this._hurtList.length >= 10需要确认
			length = (this._hurtList.length >= 10 && (0) || (10 - this._hurtList.length))
		}
		let i = 0
		do {
			table.insert(list, {})
			i = i + 1
		} while ((i < length))
		return list
	}

	public SetValue(value?) {

		return WordManager.ConvertNum(Number(value), true)
		//if (value >= 10000 && value < 1000000 ) {
		//value = value / 10000
		//value = value.toFixed(2)
		//return value + "万"
		//} else if (value >= 1000000 && value < 100000000 ) {
		//value = Math.floor(value)
		//return value + "万"
		//} else if (value >= 100000000 && value < 10000000000 ) {
		//value = value / 100000000
		//value = value.toFixed(2)
		//return value + "亿"
		//} else if (value >= 10000000000 ) {
		//value = Math.floor(value)
		//return value + "亿"
		//}else{
		//return value + ""
		//}
	}

	public resetAutoFight() {

		this.lastPos = null
		this.newPos = null
		this.last2pos = null
		this.AutoFight()
	}

	public checkOpen() {

		let flag = true
		if (this.timeMsgData && this.timeMsgData.end_time != 0 && TimeUtil.getServerTime() >= this.timeMsgData.end_time) {
			flag = false
		}
		return flag
	}

}
window["SnatchTreasureModel"] = SnatchTreasureModel