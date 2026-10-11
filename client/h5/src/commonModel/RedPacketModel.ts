import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildEvent, GuildModel } from "./GuildModel"
import { MainFunc } from "./MainUIModel"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Trim } from "../util/Util"
import { RedPacketMainView } from "../redPacket/RedPacketMainView"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"

export let RedPacketEvent = {
	REQUEST_PROTO: "RedPacketEvent.REQUEST_PROTO",
	RED_TIPS: "RedPacketEvent.RED_TIPS",
	OPEN_VIEW:"RedPackerEvent.OPEN_VIEW",
	CLOSE_VIEW:"RedPackerEvent.CLOSE_VIEW"
}

export let RedPacketStatus = {
	Open: "open",
	Send: "send",
	Look: "look",
	Other: "other"
}

export let RedPacketFunc = [
	{ title: "vip4以上可发红包", open_id: 108 },
	{ title: "VIP提升红包", open_id: 23 },
	{ title: "每日累充红包", open_id: 21 },
	{ title: "每日首充红包", open_id: 72 },
	{ title: "月卡投资红包", open_id: 61 },
	{ title: "等级投资红包", open_id: 62 },
	{ title: "结社晚宴红包", open_id: 50 }
]



// [ts2lua]window下标访问可能不正确
window["RedPacketEvent"] = RedPacketEvent
// [ts2lua]window下标访问可能不正确
window["RedPacketStatus"] = RedPacketStatus
// [ts2lua]window下标访问可能不正确
window["RedPacketFunc"] = RedPacketFunc

export class RedPacketModel extends EventDispatcher {
	CheckRedStatus
	GetAllRedStatus
	GetMaxCount
	GetRedMsgDic
	GetRedPacketData
	GetRedPacketInfo
	GetRedStatus
	Reset
	SetBestRole
	SetRedMsgDic
	SetRedPacketInfo
	SetRedStatus
	//SetRoleHead
	SortRedPacketList
	UpdateRedPacketInfo
	_cfg_dic
	_red_mark
	_rp_info
	_first_mark_=true

	static Instance: RedPacketModel;

	RedPacketDefine = []

	RedPacketFunc = [
		{ title: "vip4以上可发红包", open_id: 108 },
		{ title: "VIP提升红包", open_id: 23 },
		{ title: "每日累充红包", open_id: 21 },
		{ title: "每日首充红包", open_id: 72 },
		{ title: "月卡投资红包", open_id: 61 },
		{ title: "等级投资红包", open_id: 62 },
		{ title: "结社晚宴红包", open_id: 50 }
	]


	public constructor() {
		super()

		if (RedPacketModel.Instance) {
			return
		}
		RedPacketModel.Instance = this
		this._cfg_dic = [];
		let red_dot_mgr = RedDotManager.GetInstance()
		let red_packet_type = ModuleType.RED_PACKET
		let role_mgr = RoleManager.GetInstance()

		let guild_model = GuildModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let _red_msg_dic_ = []
		//let _first_mark_ = true
		this.Reset = () => {
			red_dot_mgr.ClearAnyRedStatus(red_packet_type)
			// this.redMark = false
			this.SetRedMark(false)
			this._rp_info = null
		}

		this.SetRedPacketInfo = (scmd?) => {
			this.SortRedPacketList(scmd.red_envelopes_list)
			this.ChangeVar("_rp_info", scmd, false, true)
			this.CheckRedStatus()
		}

		this.GetRedPacketInfo = () => {
			return this._rp_info
		}

		this.UpdateRedPacketInfo = (scmd?) => {
			let rp_info = this.GetRedPacketInfo()
			if (!rp_info) {
				return
			}
			for (let _tmpi in rp_info.red_envelopes_list) {
				var info = rp_info.red_envelopes_list[_tmpi]
				if (info.id == scmd.red_envelopes_id) {
					info.receive_status = 1
					info.recipients_num = scmd.recipients_num
					this.SetRedPacketInfo(rp_info)
					break
				}
			}
		}

		this.SortRedPacketList = (red_envelopes_list?) => {
			let role_id = role_mgr.GetMainRoleId()
			// red_envelopes_list.sort((a?, b?) => {
			let positive_number = false
			let negative_number = true

			table.sort(red_envelopes_list, (a?, b?) => {
				if (a.status == b.status) {
					if (a.status == 1 || b.status == 1) {
						if (a.receive_status != b.receive_status) {
							return b.receive_status < a.receive_status
						} else {
							return b.stime < a.stime
						}
					} else {
						if (a.role_id != b.role_id) {
							if (role_id == a.role_id) {
								// return -1
								return negative_number
							} else {
								// return 1
								return positive_number
							}
						} else {
							return b.stime < a.stime
						}
					}
				} else {
					if (a.status == 0 && role_id == a.role_id) {
						// return -1
						return negative_number
					} else if (a.status == 0 && role_id != a.role_id) {
						// return 1
						return positive_number
					} else if (b.status == 0 && role_id == b.role_id) {
						// return 1
						return positive_number
					} else if (b.status == 0 && role_id != b.role_id) {
						// return -1
						return negative_number
					} else {
						if (a.receive_status != b.receive_status) {
							return b.receive_status < a.receive_status
						} else {
							return a.status < b.status
						}
					}
				}
			}
			)
		}

		this.GetRedPacketData = (id?, cfg?) => {
			// [ts2lua]cfg下标访问可能不正确
			return cfg[id]
		}

		// this.SetRoleHead = (iclass?, img?, career?, picture_id?) => {
		// 	if (!img) {
		// 		return
		// 	}
		// 	picture_id = Number(picture_id)
		// 	// [ts2lua]lua中0和空字符串也是true，此处career需要确认
		// 	let _source = (career && (career + "001") || (role_mgr.mainRoleInfo.career)) + ".png"
		// 	// if (picture_id && String(picture_id).trim() != "" ) {
		// 	if (picture_id && Trim(String(picture_id)) != "") {
		// 		// [ts2lua]Config.PRELOAD_SETVER_CONFIG.config_picture下标访问可能不正确
		// 		// let picture_cfg = Config.PRELOAD_SETVER_CONFIG.config_picture[picture_id]
		// 		let picture_cfg = Config.Picture[picture_id]
		// 		if (picture_cfg) {
		// 			_source = picture_cfg.resource
		// 		}
		// 	}
		// 	// _source = "resource/game/head/" + _source + ".png"
		// 	_source = "client/assets/icon/head/" + _source
		// 	ResManager.GetInstance().SetOutsideImageSprite(iclass, img, _source)
		// }

		this.GetMaxCount = () => {
			let ginfo = guild_model.GetGuildInfo()
			// [ts2lua]lua中0和空字符串也是true，此处ginfo需要确认
			return (ginfo && (ginfo.member_capacity) || (0))
		}

		this.SetBestRole = (scmd?) => {
			if (scmd.status != 2) {
				return
			}
			let max_vo = null
			let len = scmd.recipient_list.length
			let i = 0
			do {
				let info = scmd.recipient_list[i]
				if (!max_vo) {
					max_vo = info
				} else if (info.receive_money > max_vo.receive_money) {
					max_vo = info
				} else if (info.receive_money == max_vo.receive_money) {
					if (info.time < max_vo.time) {
						max_vo = info
					}
				}
				i = i + 1
			} while ((i < len))
			if (max_vo) {
				max_vo.is_best = true
			}
		}

		this.SetRedMsgDic = (scmd?) => {
			// [ts2lua]_red_msg_dic_下标访问可能不正确
			_red_msg_dic_[scmd.red_envelopes_id] = scmd
		}

		this.GetRedMsgDic = (id?) => {
			// [ts2lua]_red_msg_dic_下标访问可能不正确
			return _red_msg_dic_[id]
		}

		this.CheckRedStatus = () => {
			red_dot_mgr.ClearAnyRedStatus(red_packet_type)
			let info = this.GetRedPacketInfo()
			if (!info) {
				return
			}
			let role_id = role_mgr.GetMainRoleId()
			for (let _tmpi in info.red_envelopes_list) {
				var data = info.red_envelopes_list[_tmpi]
				if (data.receive_status == 2) {
					this.SetRedStatus(data.id, true)
				} else if (data.status == 0) {
					this.SetRedStatus(data.id, role_id == data.role_id)
				} else {
					this.SetRedStatus(data.id, false)
				}
			}
			let red = this.GetRedStatus()
			if (!red) {
				// this.redMark = false
				this.SetRedMark(false)
			} else {
				if (this._first_mark_) {
					//_first_mark_ = false
					// this.redMark = this.GetRedStatus()
					this.SetRedMark(this.GetRedStatus())
				}
			}
			guild_model.Fire(GuildEvent.UPDATE_BASE_RED_STATUS)
			local_GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
		}

		this.SetRedStatus = (id?, active?) => {
			RedDotController.ins.add(`${RedKey.GUILD_REDPACKET}_${id}`, RedKey.GUILD_REDPACKET);
			RedDotController.ins.up(`${RedKey.GUILD_REDPACKET}_${id}`, active ? 1 : 0);
			red_dot_mgr.SetAnyRedStatus(red_packet_type, id, active)
		}

		this.GetRedStatus = (id?) => {
			return red_dot_mgr.CheckAnyRedStatus(red_packet_type, id)
		}

		this.GetAllRedStatus = () => {
			return this._red_mark || this.GetRedStatus()
		}


	}

	//首次红包登录提示
	public SetFristMark(boo){
		this._first_mark_=boo
	}

	public SetRedMark(mark?) {

		this._red_mark = mark
		RedDotController.ins.up(RedKey.GUILD_REDPACKET_RED_MARK, mark ? 1 : 0);
		this.Fire(RedPacketEvent.RED_TIPS, mark)
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Guild)
	}

	public redMark() {

		return this._red_mark
	}

	public static GetInstance() {

		if (!RedPacketModel.Instance) {
			RedPacketModel.Instance = new RedPacketModel()
		}
		return RedPacketModel.Instance
	}

}


window["RedPacketModel"] = RedPacketModel