import { EventDispatcher } from "../util/EventDispatcher"

export const PK_STATUS = {
	Peace : 0,  //和平
	All : 1,    //全体
	Force : 2,	//强制
	Server : 3,  //跨服
	Guild : 4, // 结社
	Camp : 5,//阵营
	Sea  : 6, //海域
}
window["PK_STATUS"] = PK_STATUS
export class PkStatusModel extends EventDispatcher {
	static Instance
	public static CHANGE_PK_STATUS = "PkStatusModel.CHANGE_PK_STATUS"
	public static CHANGE_SUCCESS = "PkStatusModel.CHANGE_SUCCESS"

	public static FightModeInfo = [
		{ pk_status: 0, status_name: "和平", desc: "不能攻击任何人", source: "pkstatus_flag_0", main_source: "pkstatus_flag_0", bg_source: "pkstatus_bg_0" },
		{ pk_status: 1, status_name: "全体", desc: "可以攻击任何人", source: "pkstatus_flag_2", main_source: "pkstatus_flag_2", bg_source: "pkstatus_bg_2" },
		{ pk_status: 2, status_name: "强制", desc: "不能攻击同结社和同队伍成员", source: "pkstatus_flag_1", main_source: "pkstatus_flag_1", bg_source: "pkstatus_bg_1" },
		{ pk_status: 3, status_name: "跨服", desc: "不能攻击同服务器成员", source: "pkstatus_flag_3", main_source: "pkstatus_flag_3", bg_source: "pkstatus_bg_3" },
		{ pk_status: 4, status_name: "结社", desc: "不能攻击同结社成员", source: "pkstatus_flag_4", main_source: "pkstatus_flag_4", bg_source: "pkstatus_bg_1" },
		{ pk_status: 5, status_name: "阵营", desc: "不能攻击同阵营成员", source: "pkstatus_flag_6", main_source: "pkstatus_flag_6", bg_source: "pkstatus_bg_3" },
		{ pk_status: 6, status_name: "海域", desc: "不能同海域成员", source: "pkstatus_flag_5", main_source: "pkstatus_flag_5", bg_source: "pkstatus_bg_1" }
	]

	public constructor() {
		super()

	}

	public static GetInstance() {

		if (!PkStatusModel.Instance) {
			PkStatusModel.Instance = new PkStatusModel()
		}
		return PkStatusModel.Instance
	}
}

window["PkStatusModel"] = PkStatusModel