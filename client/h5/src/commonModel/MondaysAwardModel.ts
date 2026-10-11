import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { table } from "../common/table"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { AdModuleId, WelfareModel } from "./WelfareModel"
// import  "../mondaysaward/MondaysAwardEntView"

export const MondaysAwardEvent = {
	OPEN_VIEW: "MondaysAwardEvent.OPEN_VIEW",
	ClOSE_VIEW: "MondaysAwardEvent.ClOSE_VIEW",
	REQUEST_PROTO: "MondaysAwardEvent.REQUEST_PROTO",
	REWARD_RETURN: "MondaysAwardEvent.REWARD_RETURN",
	RECORD_RETUEN: "MondaysAwardEvent.RECORD_RETUEN",
	KF_RECORD_RETUEN: "MondaysAwardEvent.KF_RECORD_RETUEN",
	TASK_DATA_RETUEN: "MondaysAwardEvent.TASK_DATA_RETUEN",
	GET_TASK_RETUEN: "MondaysAwardEvent.GET_TASK_RETUEN",
	CHANGE_VIEW_SELECT: "MondaysAwardEvent.CHANGE_VIEW_SELECT",
	CHANGE_POOL_REWARD: "MondaysAwardEvent.CHANGE_POOL_REWARD",
	UPDATE_RED_DOT: "MondaysAwardEvent.UPDATE_RED_DOT",
	ACTIVITY_OPEN: "MondaysAwardEvent.ACTIVITY_OPEN"
}
window["MondaysAwardEvent"] = MondaysAwardEvent
export class MondaysAwardModel extends EventDispatcher {
	changePoolReward
	changeSelectNum
	checkSelectLength
	cleanRecord
	config_reward
	config_reward_Id
	config_task
	draw_times
	getKfRecordData
	getRecordData
	getRewardIdById
	getRewardIdList
	getRewardIndex
	getShowListByPoolId
	getTaskDataById
	goods_id
	icon_type
	initSelectDic
	open
	pool_reward
	recordDesc
	rewardSelect
	round_times
	selectDic
	selectNum
	setKfRecordData
	setPoolReward
	setRecordData
	setRewardReturn
	setShowDic
	setTaskData
	showList
	showRedDot
	showReward
	showSelectImg
	showSelectList
	success_view
	taskList
	taskRedDot
	static Instance: any

	public constructor() {
		super()
		if (MondaysAwardModel.Instance) {
			return
		}
		MondaysAwardModel.Instance = this

		this.open = false
		this.draw_times = 0
		this.round_times = 10
		this.goods_id = 1102015063
		this.icon_type = "179"
		this.selectNum = 0
		this.selectDic = []
		this.config_task = null
		this.config_reward_Id = null
		this.config_reward = null

		let local_MondaysAwardEvent = MondaysAwardEvent
		let local_Erlang = ErlangParser.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_ColorUtil = ColorUtil
		let _taskList_ = []
		let showDic_ = []
		let _showList_ = []
		let _rewardReturn_ = null
		let _recordData_ = null
		let _KfRecordData_ = null
		let _taskData_ = null

		this.pool_reward = (id?) => {
			return this.config_reward[Number(id)]
		}

		this.getRewardIdById = (id?) => {
			return this.config_reward_Id && this.config_reward_Id[id]
		}

		this.getRewardIdList = (id?) => {
			let list = []
			let config = this.getRewardIdById(id)
			if (config) {
				let choose_list = local_Erlang.Parse(config.choose_list)
				for (let _tmpi in choose_list) {
					var choose_id = choose_list[_tmpi]
					table.insert(list, { id, choose_id })
				}
			}
			return list
		}

		this.taskList = () => {
			if (_taskList_.length <= 0) {
				for (let key in this.config_task) {

					let task = this.config_task[key]
					table.insert(_taskList_, task)
				}

				if(WelfareModel.GetInstance().GetAdOpenState()){
					let ad_cfg = {
						"id": AdModuleId.MondayReward + 1000,
						"desc": "观看广告",
						"reward": "[{\"0\":0,\"1\":1102015063,\"2\":1}]",
						"jump_id": 0,
						"condition": "[]"
					}
					table.insert(_taskList_, ad_cfg)
				}
			}
			return _taskList_
		}

		this.setShowDic = (data?) => {
			for (let key in data.pool) {

				let info = data.pool[key]
				let list = []
				for (let _tmpi in info.rids) {
					var idinfo = info.rids[_tmpi]
					table.insert(list, idinfo.rid)
				}
				showDic_[info.id] = list
			}
			this.Fire(local_MondaysAwardEvent.CHANGE_POOL_REWARD)
		}

		this.showList = (refresh?) => {
			if (refresh == null) {
				refresh = false
			}
			if (!_showList_ || refresh) {
				_showList_ = []
				for (let key in showDic_) {

					let list = showDic_[key]
					for (let _tmpi in list) {
						var id = list[_tmpi]
						let rewardConf = this.config_reward[id]
						if (rewardConf) {
							let reward = JSON.parse(rewardConf.reward)
							reward=reward[0]
							table.insert(_showList_, reward)
						}
					}
				}
			}
			return _showList_
		}

		this.setRewardReturn = (data?) => {
			_rewardReturn_ = data
			this.draw_times = data.draw_times
			let index = this.getRewardIndex(data.pool_id)
			if (index != null) {
				this.Fire(local_MondaysAwardEvent.REWARD_RETURN, index)
			}
			this.Fire(local_MondaysAwardEvent.UPDATE_RED_DOT)
		}

		this.getRewardIndex = (pool_id?) => {
			let index = 1
			let find = null
			for (let key in showDic_) {

				let list = showDic_[key]
				for (let _tmpi in list) {
					var id = list[_tmpi]
					if (Number(id) == pool_id) {
						return index
					}
					index = index + 1
				}
			}
		}

		this.showReward = () => {
			if (!_rewardReturn_) {
				return
			}
			let reward = this.config_reward[_rewardReturn_.pool_id]
			if (reward && reward.reward) {
				let list = JSON.parse(reward.reward)
				this.success_view = new CongratulationObtainView(list , 10)
				this.success_view.Open()
			}
		}

		this.setRecordData = (data?) => {
			if (_recordData_) {
				let old_person = _recordData_.person
				let new_person = data.person
				for (let i = 0; i < old_person.length; i++) {
					var v = old_person[i]
					table.insert(new_person, v)
				}
				_recordData_.person = new_person
			} else {
				_recordData_ = data
			}
			if (_recordData_ && _recordData_.person.length > 30) {
				for (let j = 31; j <= _recordData_.person.length; j++) {
					table.remove(_recordData_.person, j)
				}
			}
			this.Fire(local_MondaysAwardEvent.RECORD_RETUEN)
		}

		this.getRecordData = () => {
			let list = []
			if (_recordData_ && _recordData_.person) {
				list = _recordData_.person
			}
			return list
		}

		this.setKfRecordData = (data?) => {
			if (_KfRecordData_) {
				//let old_person = _KfRecordData_.record
				//let new_person = data.record
				//for (let i = 0; i < old_person.length; i++) {
				// var v = old_person[i]
				//table.insert(new_person, v)
				//}
				_KfRecordData_.record = data.record

			} else {
				_KfRecordData_ = data
			}
			if (_KfRecordData_ && _KfRecordData_.record.length > 30) {
				for (let j = 31; j <= _KfRecordData_.record.length; j++) {
					table.remove(_KfRecordData_.record, j)
				}
			}
			this.Fire(local_MondaysAwardEvent.KF_RECORD_RETUEN)
		}

		this.getKfRecordData = () => {
			let list = []
			if (_KfRecordData_ && _KfRecordData_.record) {
				list = _KfRecordData_.record
			}
			return list
		}

		this.cleanRecord = () => {
			_recordData_ = null
			_KfRecordData_ = null
		}

		this.recordDesc = (reward_type_id?, reward_id?) => {
			let desc = ""
			let config = this.getRewardIdById(reward_type_id)
			let rewardConfig = this.config_reward[reward_id]
			let reward = JSON.parse(rewardConfig.reward)
			let rewardVo = null
			if (reward) {
				let [type_id, lock] = goods_model.GetMappingTypeId(reward[0][0], reward[0][1])
				rewardVo = goods_model.GetGoodsBasicByTypeId(type_id)
			}
			if (config && rewardVo) {
				desc = "<font color=" + local_ColorUtil.GetColorLight(rewardVo.color) + ">" + rewardVo.goods_name + "*" + reward[0][2] + "</font>"
			}
			return ["<font color=" + local_ColorUtil.GetColorDark(ColorType.RED) + ">" + config.desc + "</font>", desc]
		}

		this.setTaskData = (data?) => {
			let updateEvent = () => {
				this.Fire(local_MondaysAwardEvent.TASK_DATA_RETUEN)
				this.Fire(local_MondaysAwardEvent.UPDATE_RED_DOT)
			}

			let time = 0.1
			if (!_taskData_) {
				time = 1
			}
			_taskData_ = data
			let id = setTimeout(() => {
				updateEvent()
				clearTimeout(id)
			}, time)
		}

		this.getTaskDataById = (id?) => {
			if (_taskData_ && _taskData_.task_state) {
				let list = _taskData_.task_state
				for (let key in list) {

					let task = list[key]
					if (task.task_id == id) {
						return task
					}
				}
			}
		}

		this.getShowListByPoolId = (pool_id?) => {
			let list = []
			if (showDic_[pool_id]) {
				list = showDic_[pool_id]
			}
			return list
		}

		this.rewardSelect = (pool_id?, reward_id?) => {
			let list = this.selectDic[pool_id]
			if (list) {
				return table.find(list, reward_id) != -1
			}
			return false
		}

		this.changeSelectNum = (bool?, pool_id?, reward_id?) => {
			let list = this.selectDic[pool_id]
			if (bool) {
				this.selectNum = this.selectNum + 1
				table.insert(list, reward_id)
				table.sort(list, (a?, b?) => {
					return a < b
				})
			} else {
				this.selectNum = this.selectNum - 1
				let index = table.find(list, reward_id)
				table.remove(list, index)
			}
			this.Fire(local_MondaysAwardEvent.CHANGE_VIEW_SELECT)
		}

		this.initSelectDic = () => {
			for (let key in showDic_) {

				let list = showDic_[key]
				let selectList = []
				for (let _tmpi in list) {
					var id = list[_tmpi]
					table.insert(selectList, id)
				}
				this.selectDic[key] = selectList
			}
		}

		this.changePoolReward = () => {
			if (this.checkSelectLength(this.selectDic, false)) {
				for (let key in this.selectDic) {

					let list = this.selectDic[key]
					showDic_[key] = list
				}
				this.Fire(local_MondaysAwardEvent.REQUEST_PROTO, 17901, null, showDic_)
			}
			this.selectNum = 0
			this.selectDic = []
		}

		this.setPoolReward = (data?) => {
			for (let key in data.pool) {

				let info = data.pool[key]
				let list = []
				for (let _tmpi in info.rids) {
					var idinfo = info.rids[_tmpi]
					table.insert(list, idinfo.rid)
				}
				showDic_[info.id] = list
			}
			this.Fire(local_MondaysAwardEvent.CHANGE_POOL_REWARD)
		}

		this.checkSelectLength = (dic?, show?) => {
			if (show == null) {
				show = true
			}
			for (let key in dic) {

				let list = dic[key]
				let config = this.config_reward_Id[key]
				if (config && list.length < config.num) {
					if (show) {
						Message.show("请先填满对应奖池奖励")
					}
					return false
				}
			}
			return true
		}

		this.showSelectList = () => {
			_showList_ = []
			let num = 0
			for (let key in this.selectDic) {

				let config = this.getRewardIdById(key)
				if (config) {
					num = config.num
					let list = this.selectDic[key]

					for (let i = 0; i <num; i++) {
						let id = list[i]
						let reward 
						if (id != null) {
							let rewardConf = this.config_reward[id]
							if (rewardConf) {
								reward = JSON.parse(rewardConf.reward)
							}
							reward=reward[0]
						}else{
							reward={}
						}
						table.insert(_showList_, reward)
					}
				}

			}
			return _showList_
		}

		this.showSelectImg = (gp?, id?) => {
			id = id - 1
			let index = 0
			let num = 0
			let configList = this.config_reward_Id
			for (let key in configList) {

				let config = configList[key]
				if (config.id < id) {
					index = index + config.num
				} else if (config.id == id) {
					num = config.num
				} else {
					break
				}
			}

			for (let i = 0; i < gp.numChildren; i++) {
				let _gp = gp.getChildAt(i)
				let state = (i < index + num) && (i >= index)
				_gp.visible = state
			}
		}

		this.taskRedDot = () => {
			let flag = false
			if (!_taskData_) {
				return flag
			}
			for (let key in _taskData_.task_state) {

				let data = _taskData_.task_state[key]
				if (data.state == 1) {
					flag = true
					break
				}
			}
			return flag
		}

		this.showRedDot = () => {
			let flag = false
			let num = goods_model.GetTypeGoodsNum(this.goods_id)
			if ((this.open && num > 0) || this.taskRedDot()) {
				flag = true
			}
			return flag
		}


	}

	public static GetInstance() {

		if (!MondaysAwardModel.Instance) {
			MondaysAwardModel.Instance = new MondaysAwardModel()
		}
		return MondaysAwardModel.Instance
	}
}
window["MondaysAwardModel"] = MondaysAwardModel