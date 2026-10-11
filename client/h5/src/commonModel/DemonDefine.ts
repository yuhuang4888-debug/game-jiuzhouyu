import { BaseClass } from "../common/BaseClass"

export class DemonDefine extends BaseClass {
	public static Quality2Setting = {
		"3": {
			bg_source: ["demon","uism_028a"],
			name_bg_source: ["demon","uism_028b"],
			level_bg_source: ["demon","uism_028c"],
			tips_source: ["demon","uism_028d"],
			circle_source: ["demon","uism_058"]
		},
		"4": {
			bg_source: ["demon","uism_029a"],
			name_bg_source: ["demon","uism_029b"],
			level_bg_source: ["demon","uism_029c"],
			tips_source: ["demon","uism_029d"],
			circle_source: ["demon,uism_059"]
		},
		"5": {
			bg_source: ["demon","uism_030a"],
			name_bg_source: ["demon","uism_030b"],
			level_bg_source:[ "demon","uism_030c"],
			circle_source: ["demon","uism_060"]
		}
	}

	public static Realm2Name = {
		"1": "珍兽",
		"2": "妖怪",
		"3": "灵幻"
	}

	public static tips_source = {
		"1@3": ["demon","uism_028e"],
		"1@4": ["demon","uism_029e"],
		"1@5": ["demon","uism_030e"],
		"2@3": ["demon","uism_028g"],
		"2@4": ["demon","uism_029g"],
		"2@5": ["demon","uism_030g"],
		"3@3": ["demon","uism_028h"],
		"3@4": ["demon","uism_029h"],
		"3@5": ["demon","uism_030h"],
	}

	public static StarsCount = 5
	public static StarsStageSource = {
		"0": ["demon","uism_016"],
		"1": ["demon","uism_015"],
		"2": ["demon","uism_015b"],
	}

	public static BestAttr = [9, 10, 13, 19, 20, 21, 22, 24, 25, 49]
	public static JumpId = 147
	public static SecondJumpId = 148
	public static GoodsType = 73
	public static MaterialSubType = 1//材料
	public static FragmentSubType = 2//碎片
	public static SkillSubType = 3//技能书
	public static TalentSubType = 4
	public static RotarySubType = 5

	public static SecondViewIndex = {
		Painting: 0,
		Shop: 1
	}

	public static LifeSkillSpecialKeyList = ["kill_boss", "daily_charge_reward", "liveness", "race_act"]
}
window["DemonDefine"] = DemonDefine