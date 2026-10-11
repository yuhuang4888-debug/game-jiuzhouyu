import { BaseClass } from "../common/BaseClass";

export class DungeonDragonDefine extends BaseClass {

	public static OpenLV = 120;
	public static TeamType = 6;
	public static MaxNum = 3;
	public static LevelTips =
		{
			32001: "冒险",
			32002: "白银",
			32003: "黄金",
			32004: "钻石",
			32005: "大师",
		}
	public static WaveRewardTabList = [
		{ dun_id: 32001, desc: "冒险" },
		{ dun_id: 32002, desc: "白银" },
		{ dun_id: 32003, desc: "黄金" },
		{ dun_id: 32004, desc: "钻石" },
		{ dun_id: 32005, desc: "大师" }
	];
	public static HelpDunId = 32001;
	public static InviteInterval = 10;
	public static RefreshRoomInterval = 1;
	public static MatchTotalTime = 15;
	public static SkillKey = "skill_list";
	public static TowerKey = "tower_id";
	public static QuickKey = "quick_time";
	public static QuickCreateKey = "quick_create_mon";
}

window["DungeonDragonDefine"] = DungeonDragonDefine