
//require("game.elim.RequireElim")
//require("game.rhythmMaster.RequireRhythmMaster")
//require("game.miniGame.MiniGameModel")

import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

import "../elim/RequireElim"
export class MiniGameController extends BaseController {
	mini_game_model:MiniGameModel
	user_msg_adapter
	view_dic
	InitEvent
	RegisterAllProtocals
	//通用错误返回
	public On39900 = () => {

		let scmd = this.user_msg_adapter.GetSCMD(39900)
		Util.ErrorCodeShow(scmd.errcode, scmd.msg)
	}

	//游戏开启(手动/自动开启)
	public On39901 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39901)
		if (scmd.code == 1) {
			this.mini_game_model.StopMiniGame()
			this.mini_game_model.SetMiniGameData(scmd)
			this.mini_game_model.TryStartMiniGame()
		} else {
			Util.ErrorCodeShow(scmd.code)
			this.mini_game_model.is_end = true
			this.mini_game_model.Fire(MiniGameModel.GAME_OVER)
		}
	}

	// 当前游戏状态(断线重连信息)
	public On39902 = () => {

		let scmd = this.user_msg_adapter.GetSCMD(39902)
		if (scmd.module_id == 0) {
			return
		}
		if (!this.mini_game_model.IsPlaying() || !this.mini_game_model.IsSameData(scmd)) {
			this.mini_game_model.SetMiniGameData(scmd)
			this.mini_game_model.TryStartMiniGame()
		}
	}

	// 游戏信息反馈
	public On39903 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39903)
	}

	// 实时排行榜
	public On39904 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39904)
		this.mini_game_model.SetRankData(scmd)
		this.mini_game_model.Fire(MiniGameModel.UPDATE_RANK_DATA, scmd.game_type)
	}

	// 游戏结算
	public On39905 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39905)
		this.mini_game_model.StopMiniGame()
	}

	public On39921 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39921)
	}

	/*
		消消乐发39902，返回39922
	*/
	public On39922 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39922)
		if (scmd.module_id == 0) {
			return
		}
		scmd["game_type"]=MiniGameModel.MiniGameType.Elim
		this.mini_game_model.SetMiniGameData(scmd)
		if (!this.mini_game_model.IsPlaying()) {
			scmd.game_type = 1
			this.mini_game_model.TryStartMiniGame()
			this.mini_game_model.is_continue = true
		}
	}

	public On39923 = (scmd?) => {

		scmd = scmd || this.user_msg_adapter.GetSCMD(39923)
	}

	public On39931 = (scmd?) => {

		// scmd = scmd || this.user_msg_adapter.GetSCMD(39931)
		// this.mini_game_model.StopMiniGame()
		// if (this.mini_game_model.test_mode || SceneManager.GetInstance().IsGuildExploreScene()) {
		// 	table.sort(scmd.rank_list, (a?, b?) => {
		// 		return a.rank < b.rank
		// 	})
		// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RhythmMasterResultView", scmd.rank_list)
		// }
	}

	public GetMiniGameMainViewName = (type?) => {

		if (type == MiniGameModel.MiniGameType.RhythmMaster) {
			return "RhythmMasterMainView"
		} else if (type == MiniGameModel.MiniGameType.Elim) {
			return "ElimMainView"
		}
	}

	public TestReceive = (id, fmt, ...new_args) => {
		let scmd
		let parms = new_args
		if (id == 39904) {
			scmd = {
				game_type: parms[0],
				module_id: parms[1],
				sub_id: parms[2],
				rank_list: []
			}
			let data = this.mini_game_model.GetRankData(scmd.game_type)
			if (!data) {
				data = [{
					score: 0,
					name: RoleManager.GetInstance().GetMainRoleVo().name,
					role_id: RoleManager.GetInstance().GetMainRoleId(),
					rank: 1,
				}]
			}
			for (let _ in data) {
				var v = data[_]
				v.score = v.score + 10
			}
			table.insert(data, {
				score: 0,
				name: Config.PRELOAD_CLIENT_CONFIG.ConfigRandomName.surname[Math.ceil(Config.PRELOAD_CLIENT_CONFIG.ConfigRandomName.surname.length * Math.random())],
				rank: data.length + 1,
				role_id: 1,
			})
			scmd.rank_list = data
		} else if (id == 39901) {
			scmd = {
				game_type: parms[0],
				module_id: parms[1],
				sub_id: parms[2],
				code: 1,
				start_time: TimeUtil.getServerTime()
			}
		} else if (id == 39905) {
			if (this.mini_game_model.game_type == MiniGameModel.MiniGameType.RhythmMaster) {

				let rank_data = this.mini_game_model.GetRankData(MiniGameModel.MiniGameType.RhythmMaster)
				let list = []
				if (rank_data) {
					for (let index = 0; index < rank_data.length; index++) {
						var data = rank_data[index]
						table.insert(list, [
							data.rank, data.role_id, data.name, data.score, index * 2, index
						])
					}
				}
				scmd = {
					game_type: this.mini_game_model.game_type,
					module_id: this.mini_game_model.module_id,
					sub_id: this.mini_game_model.sub_id,
					info_list: list
				}
			}
		} else if (id == 39931) {

			scmd.module_id = this.mini_game_model.module_id
			scmd.sub_id = this.mini_game_model.sub_id
			let rank_data = this.mini_game_model.GetRankData(MiniGameModel.MiniGameType.RhythmMaster)
			let list = []
			if (rank_data) {
				for (let index = 0; index < rank_data.length; index++) {
					var data = rank_data[index]
					table.insert(list, {
						rank: data.rank,
						role_id: data.role_id,
						name: data.name,
						score: data.score,
						perfects: index * 2,
						con_perfects: index
					})
				}
			}
			scmd = {
				module_id: this.mini_game_model.module_id,
				sub_id: this.mini_game_model.sub_id,
				rank_list: list
			}
		} else {
			return
		}

		if (scmd) {
			this["On" + id](scmd)
		}
	}
	public constructor() {
		super()
		this.mini_game_model = MiniGameModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.InitEvent = () => {
			this.mini_game_model.Bind(MiniGameModel.START_MINI_GAME, (type?) => {
				if(SceneManager.GetInstance().IsEveningScene()){
					//不能在晚宴场景内打开这个，会和晚宴的界面重叠
					return
				}
				if (!this.view_dic) {
					this.view_dic = {}
				}

				let view = this.view_dic[type]
				if (!view) {
					let view_name = this.GetMiniGameMainViewName(type)
					if (!view_name) { return }
					view = new window[view_name]
					this.view_dic[type] = view
				}

				if (view) {
					view.Open()
				}
			}
			)
			this.mini_game_model.Bind(MiniGameModel.CLOSE_MINI_GAME, (type?) => {
				let view = this.view_dic[type]
				if (view) {
					view.Close()
					delete this.view_dic[type]
				}
			}
			)

			GlobalEventSystem.Bind(EventName.GAME_START, () => {
				this.mini_game_model.InitCfg()
				this.mini_game_model.is_playing = false
				this.mini_game_model.Fire(MiniGameModel.REQUEST_CCMD_EVENT, 39902)
			}
			)

			GlobalEventSystem.Bind(EventName.MINI_GAME_TEST, (x,y,buff_type,chess_type) => {
				this.mini_game_model.TestChangeChess(x,y,buff_type,chess_type)
			}
			)
			this.mini_game_model.Bind(MiniGameModel.REQUEST_CCMD_EVENT, (id, fmt, ...new_args) => {
				if(this.mini_game_model.is_open_client){
					return
				}
				if (this.mini_game_model.test_mode) {
					this.TestReceive(id, fmt, ...new_args)
				} else {
					if (id == 39903) {
						let parms = new_args
						this.WriteBegin(39903)
						this.WriteFMT("c", parms[0])
						this.WriteFMT("h", parms[1])
						this.WriteFMT("c", parms[2])
						if (parms[0] == MiniGameModel.MiniGameType.RhythmMaster) {
							this.WriteFMT("h", 2)
							this.WriteFMT("i", parms[3])
							this.WriteFMT("i", parms[4])
							this.SendToGame()
						}
					} else {
						this.SendFmtToGame(id, fmt, ...new_args)
					}
				}
			})

			let onRequestListHandler_39921 = (type?, info?, board?, effect?, score_chess?) => {
				if(this.mini_game_model.is_open_client){
					return
				}
				if(this.mini_game_model.test_mode) return
				this.WriteBegin(39921)
				this.WriteFMT("c", type)
				// 操作
				this.WriteFMT("h", info.length)
				for (let _ = 0; _ < info.length; _++) {
					var value = info[_]
					this.WriteFMT("i", value)
				}


				// 棋盘
				this.WriteFMT("h", board.length)
				for (let i = 0; i < board.length; i++) {
					var row = board[i]
					this.WriteFMT("c", i)
					this.WriteFMT("h", row.length)
					for (let j = 0; j < row.length; j++) {
						var col = row[j]
						this.WriteFMT("c", board[i][j])
					}
				}

				// 效果
				this.WriteFMT("h", effect.length)
				for (let i = 0; i < effect.length; i++) {
					var info = effect[i]
					this.WriteFMT("c", info[0])
					this.WriteFMT("c", info[1])
					this.WriteFMT("c", info[2])
					this.WriteFMT("c", info[3])
				}

				// 积分棋
				this.WriteFMT("h", score_chess.length)
				for (let i = 0; i < score_chess.length; i++) {
					var info = score_chess[i]
					this.WriteFMT("c", info[0])
					this.WriteFMT("c", info[1])
				}

				this.SendToGame()
			}
			this.mini_game_model.Bind(MiniGameModel.REQUEST_PROTO_LIST_39921, onRequestListHandler_39921)
		}
		this.RegisterAllProtocals = () => {
			this.RegisterProtocal(39900, this.On39900)// 通用错误返回
			this.RegisterProtocal(39901, this.On39901)// 游戏开启(手动/自动开启)
			this.RegisterProtocal(39902, this.On39902)// 当前游戏状态(断线重连信息)

			this.RegisterProtocal(39903, this.On39903)// 游戏信息反馈
			this.RegisterProtocal(39904, this.On39904)// 实时排行榜
			this.RegisterProtocal(39905, this.On39905)// 游戏结算
			this.RegisterProtocal(39921, this.On39921)// 上传棋盘信息
			this.RegisterProtocal(39922, this.On39922)// 重连
			this.RegisterProtocal(39923, this.On39923)// 主动结算通知

			this.RegisterProtocal(39931, this.On39931)// 游戏结算(节奏达人)
		}
		this.InitEvent()
		this.RegisterAllProtocals()
	}






}

