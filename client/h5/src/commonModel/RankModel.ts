import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { Config } from "../common/Config"

export let RANK_CONFIG = {
	RANK_TAB: 0,
	STAGE: 1,
	MEDAL: 2
}

export let RankModelEvent = {
	REQUEST_RANK_DATA: "RankModelEvent.REQUEST_RANK_DATA",
	RANK_DATA_UPDATE: "RankModelEvent.RANK_DATA_UPDATE",
	LIKE: "RankModelEvent.LIKE",
	LIKE_INFO_UPDATE: "RankModelEvent.LIKE_INFO_UPDATE",
	REQUEST_GUILD_RANK_DATA: "RankModelEvent.REQUEST_GUILD_RANK_DATA",
	OPEN_MENU_VIEW: "OPEN_MENU_VIEW"
}
window["RANK_CONFIG"] = RANK_CONFIG
window["RankModelEvent"] = RankModelEvent
export class RankModel extends EventDispatcher {
	_likeTime
	_rankTabList
	config
	getConfig
	getNameByType
	getRank
	getRankDate
	getRankList
	getRankMax
	guildValue
	initConfig
	playerLikeTime
	rankDataDic
	rank_type
	reqChaceDic
	requestRankData
	setLike
	setRankData
	static Instance
	public static RANK_TYPE = { GUILD: 100, FIGHT: 200, LEVEL: 300, NOBILITY: 400, COMPETITION: 500, HORSE: 601, FLY_HORSE: 602, WING: 603, PARTNER: 604, SPIRIT: 605, GOD: 606, PYX: 607, EQUIP: 608, TOWER: 609, ONHOOK: 700 };
	public constructor() {
		super()

		this.config = [];
		this.rank_type = 0;
		this._rankTabList = [];
		this.rankDataDic = [];
		this.reqChaceDic = []
		this._likeTime = 0;
		this.playerLikeTime = 0;
		let local_RANK_CONFIG = RANK_CONFIG
		let local_TimeUtil = TimeUtil
		let local_RankModelEvent = RankModelEvent
		let rank_type = RankModel.RANK_TYPE
		this.initConfig = () => {

		}

		this.getConfig = (dun_type?) => {
			return this.config[dun_type]
		}

		this.setRankData = (data?) => {
			data["rturn_time"] = local_TimeUtil.getServerTime()
			let allData = this.rankDataDic[data.rank_type]
			if (!allData) {
				this.rankDataDic[data.rank_type] = data
			} else {
				allData.role_rank = data.role_rank
				allData.sel_val = data.sel_val
				allData.sel_sec_val = data.sel_sec_val
				allData.sum = data.sum
				let firstInfo = allData.rank_list[data.start]
				for (let i in data.rank_list) {
					var info = data.rank_list[i]
					if (firstInfo) {
						allData.rank_list[data.start + (Number(i) - 1)] = info
					} else {
						table.insert(allData.rank_list, info)
					}
				}
			}
			this.Fire(local_RankModelEvent.RANK_DATA_UPDATE, data)

			let reqChace = this.reqChaceDic[data.rank_type][0]
			let max = reqChace && reqChace.max
			if (max) {
				let a = data.rank_list.length
				if (data.rank_list.length >= max) {
					reqChace.reqFun()
					table.remove(this.reqChaceDic[data.rank_type], 0)
				} else {
					this.reqChaceDic[data.rank_type] = []
				}
			}
		}

		this.getRankDate = (rankType?) => {
			return this.rankDataDic[rankType]
		}

		this.getRankMax = (selectIndex?) => {
			let spiritTabDataList = this.spiritTabDataList()
			return spiritTabDataList[selectIndex].rank_max
		}

		this.getRankList = (rankList?, selectIndex?) => {
			let length = this.getRankMax(selectIndex)
			let newList = []
			let data = null
			let i = 1
			do {
				if (rankList && i < rankList.length) {
					data = rankList[i]
				} else {
					data = null
				}
				table.insert(newList, data)
				i = i + 1
			} while ((i < length))
			return newList
		}

		this.requestRankData = (selectIndex?) => {
			this.config[local_RANK_CONFIG.RANK_TAB] = Config.PRELOAD_SERVER_CONFIG.config_ranking
			this.config[local_RANK_CONFIG.MEDAL] = Config.PRELOAD_SERVER_CONFIG.config_medal

			let spiritTabDataList = this.spiritTabDataList()
			let info = spiritTabDataList[selectIndex]
			let type = info.type
			let data = this.rankDataDic[type]
			if (!data || local_TimeUtil.getServerTime() - data.rturn_time >= 10) {
				let length = info.rank_max
				let oneMax = 20
				let r_time = Math.ceil(length / 20)
				let last_length = length % 20
				let event = type == rank_type.GUILD && local_RankModelEvent.REQUEST_GUILD_RANK_DATA || local_RankModelEvent.REQUEST_RANK_DATA
				this.reqChaceDic[type] = []

				for (let i = 1; i <= r_time; i++) {
					let new_start = 1 + (i - 1) * oneMax
					let reqLength = oneMax
					if (i == r_time) {
						reqLength = last_length == 0 && oneMax || last_length
					}
					if (i == 1) {
						this.Fire(event, type, new_start, reqLength)
					} else {
						let obj = {
							max: reqLength, reqFun: () => {
								this.Fire(event, type, new_start, reqLength)
							}
						}
						table.insert(this.reqChaceDic[type], obj)
					}
				}
			} else {
				this.Fire(local_RankModelEvent.RANK_DATA_UPDATE, data)
			}
		}

		this.setLike = (likeTime?) => {
			this._likeTime = likeTime
			this.Fire(local_RankModelEvent.LIKE_INFO_UPDATE)
		}

		this.getRank = (data?, selectIndex?) => {
			let str = "未上榜"
			let spiritTabDataList = this.spiritTabDataList()
			let cof = spiritTabDataList[selectIndex]
			if (data.role_rank == 0) {
				let value = data.sel_val
				if (data.rank_type != rank_type.COMPETITION && value >= cof.rank_limit || data.rank_type == rank_type.COMPETITION && value <= cof.rank_limit) {
					str = this.getRankMax(selectIndex) + (" + ")
				}
			} else {
				str = data.role_rank + ""
			}
			return str
		}

		this.guildValue = (rank?) => {
			let str = "未加入结社"
			let vo = RoleManager.GetInstance().GetMainRoleVo()
			if (rank != 0 || vo.guild_id > 0) {
				let data = this.getRankDate(rank_type.GUILD).rank_list
				for (let key in data) {

					if (data.hasOwnProperty(key)) {
						let info = data[key]
						if (info.rank == rank) {
							str = info.first_value + ""
						}
					}
				}
			}
			return str
		}

		this.getNameByType = (type?) => {
			let name = ""
			if (type == rank_type.GUILD) {
				name = "结社战力"
			} else if (type == rank_type.LEVEL) {
				name = "等级"
			} else if (type == rank_type.NOBILITY) {
				name = "成就等级"
			} else if (type == rank_type.COMPETITION) {
				name = "竞技场排名"
			} else if (type == rank_type.HORSE) {
				name = "坐骑战力"
			} else if (type == rank_type.WING) {
				name = "羽翼战力"
			} else if (type == rank_type.PARTNER) {
				name = "侍魂战力" //精灵就是H5项目的伙伴
			} else if (type == rank_type.SPIRIT) {
				name = "侍魂2战力"
			} else if (type == rank_type.FLY_HORSE) {
				name = "飞骑战力"
			} else if (type == rank_type.EQUIP) {
				name = "装备评分"
			} else if (type == rank_type.GOD) {
				name = "御守战力"
			} else if (type == rank_type.PYX) {
				name = "神兵战力"
			} else if (type == rank_type.TOWER) {
				name = "层数"
			} else if (type == rank_type.ONHOOK) {
				name = "挂机收益"
			} else {
				name = "战力"
			}
			return name
		}
	}

	public static GetInstance() {

		if (!RankModel.Instance) {
			RankModel.Instance = new RankModel()
		}
		return RankModel.Instance
	}

	public spiritTabDataList() {

		if (this._rankTabList.length <= 0) {
			let obj = this.getConfig(RANK_CONFIG.RANK_TAB)
			for (let key in obj) {

				let element = obj[key]
				if (element.show == 1) {
					table.insert(this._rankTabList, element)
				}
			}
			table.sort(this._rankTabList, (a?, b?) => {
				return a.sortid < b.sortid
			})
		}
		return this._rankTabList
	}

	public likeTime() {

		return this._likeTime
	}

	public rankRedDot() {

		return this.likeTime() > 0
	}
}

window["RankModel"] = RankModel