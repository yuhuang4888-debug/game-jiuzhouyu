import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { CustomActivityModel } from "./CustomActivityModel"

export class ListDuobaoModel extends EventDispatcher {
	static Instance: any
	public static OPEN_VIEW = "OPEN_VIEW"
	public static REQUEST_SCMD = "REQUEST_SCMD"
	public static UPDATE_MAIN_VIEW = "UPDATE_MAIN_VIEW"
	public static UPDATE_RANK = "UPDATE_RANK"
	public static TEST_EVENT = "TEST_EVENT"

	base_type = 116
	sub_type
	score
	reward_list
	stage_list

	player_score
	player_rank
	player_rank_list
	server_score
	server_rank
	server_rank_list

	first_in
	stage_red
	is_openAlert

	public constructor() {
		super()
		if (ListDuobaoModel.Instance) {
			return
		}
		ListDuobaoModel.Instance = this

		this.score = 0
		this.reward_list = []
		this.stage_list = []
		this.player_score = 0
		this.player_rank = 0
		this.player_rank_list = []
		this.server_score = 0
		this.server_rank = 0
		this.server_rank_list = []
		this.first_in = true
		this.stage_red = false
		this.is_openAlert = true
	}

	public static GetInstance() {
		if (!ListDuobaoModel.Instance) {
			ListDuobaoModel.Instance = new ListDuobaoModel()
		}
		return ListDuobaoModel.Instance
	}

	public SetActSubType(sub_type) {
		this.sub_type = sub_type
		this.InitRankData()
	}

	public SetData(scmd) {
		if (!scmd) {
			return
		}
		if (scmd.type != this.base_type || scmd.subtype != this.sub_type) {
			return
		}

		this.score = scmd.score
		this.reward_list = scmd.reward_list
		this.stage_list = scmd.stage_list
		table.sort(this.stage_list, (a, b) => {
			return a.id < b.id
		})
		this.SetStageRed()
		this.Fire(ListDuobaoModel.UPDATE_MAIN_VIEW)
	}

	public InitRankData() {
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_treasure_rank_reward
		if (!cfg) {
			return
		}

		for (let i in cfg) {
			let vo = cfg[i]
			if (vo.type == this.base_type && vo.sub_type == this.sub_type) {
				if (vo.rank_type == 1) {
					for (let j = vo.rank_min; j <= vo.rank_max; j++) {
						this.player_rank_list[Number(j) - 1] = {
							rank: j,
							rank_type: 1,
							need_score: vo.limit_val,
							reward: vo.reward,
							role_id: 0,
							role_name: "",
							score: 0,
							server_id: 0
						}
					}
				} else if (vo.rank_type == 2) {
					for (let j = vo.rank_min; j <= vo.rank_max; j++) {
						this.server_rank_list[Number(j) - 1] = {
							rank: j,
							rank_type: 2,
							need_score: vo.limit_val,
							reward: vo.reward,
							server_id: 0,
							server_name: "",
							score: 0
						}
					}
				}
			}
		}
	}

	public SetRankData(scmd) {
		if (!scmd) {
			return
		}
		if (scmd.type != this.base_type || scmd.subtype != this.sub_type) {
			return
		}
		this.InitRankData()

		this.player_score = scmd.score
		this.player_rank = scmd.rank
		for (let i in scmd.rank_list) {
			let vo = scmd.rank_list[i]
			let index = vo.rank - 1
			if (this.player_rank_list[index]) {
				this.player_rank_list[index].server_id = vo.server_id
				this.player_rank_list[index].role_id = vo.role_id
				this.player_rank_list[index].role_name = vo.role_name
				this.player_rank_list[index].score = vo.role_score
			}
		}

		this.server_score = scmd.sever_score
		this.server_rank = scmd.server_rank
		for (let i in scmd.server_rank_list) {
			let vo = scmd.server_rank_list[i]
			let index = vo.rank - 1
			if (this.server_rank_list[index]) {
				this.server_rank_list[index].server_id = vo.server_id
				this.server_rank_list[index].server_name = vo.server_name
				this.server_rank_list[index].score = vo.server_score
			}
		}

		this.Fire(ListDuobaoModel.UPDATE_RANK)
	}

	public CheckStageTypeById(id) {
		for (let i in this.stage_list) {
			let vo = this.stage_list[i]
			if (vo.id == id) {
				return vo.got_type
			}
		}
		return 0
	}

	public GetPlayerRankRewardByRank(rank) {
		let index = rank - 1
		if (this.player_rank_list[index]) {
			return this.player_rank_list[index].reward
		}
	}

	public SetStageRed() {
		this.stage_red = false
		for (let i in this.stage_list) {
			let vo = this.stage_list[i]
			if (vo.got_type == 1) {
				this.stage_red = true
				break
			}
		}
		this.UpdateRed()
	}

	public UpdateRed() {
		CustomActivityModel.GetInstance().SetActRedDot(this.base_type, this.sub_type)
		CustomActivityModel.GetInstance().RefreshIconRed(this.base_type, this.sub_type)

	}

	public GetRed() {
		let red = this.first_in || this.stage_red
		return red
	}
}
window["ListDuobaoModel"] = ListDuobaoModel