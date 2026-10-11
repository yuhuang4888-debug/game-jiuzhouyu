
import { UserMsgAdapter } from "./UserMsgAdapter";
/**
	string  玩家名字
	int8	性别
	int8	阵营
	int8	职业
	int16   等级
	int8	是否GM
	int8	VIP
	int8	职称
	array{  等级模型
		int8  部位
		int32 模型id
	}
	array{  时装模型
		int8	部位
		int32   模型id
	}
	string  自定义头像url
	int32   自定义头像版本号
	int64   帮派id
	string  帮派名字
	int8	帮派职位
	string  帮派职位名字
	int32   称号
	int32   活跃度形象Id
	int8	转生次数
	int8	转生阶段
	int8	爵位等级
	int8	结婚状态 0单身 1情侣 2结婚
	int64   伴侣玩家id
	string  伴侣玩家name
	int32   护送天使id
	int32   房子街区id
	int32   房子id
	int16   房子等级
	array{ 幻化模型
		int8  类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物）
		int32 模型id
	}
	array{ 幻化模型是否骑乘##找不到数据就默认骑乘
		int8  类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物）
		int8  是否骑乘(用于场景表现,点击头像等等忽略本字段)
	}
	int16   成就等级
	int16   勋章id
	int32   法阵id
	array{ 装扮列表
		int8  装扮类型 
		int32 装扮id
	}
	int32   将神id
	int32   天启套装
	int32   使魔id
	int8	是否有至尊vip标识
	int32   头衔id
	int8	蒙面id
	int8	阵营/四海争霸(玩家阵营)
	int8	海战日常砖块品质	 
	int8	假人类型（0:玩家）
    int8	套装贴图id
	int8	采集状态 （0：非采集， 1：采集中）
 */
let user_msg_adapter = UserMsgAdapter.GetInstance();
export class FigureProtoVo {
	static FigureType = {
		Horse: 1,
		Sprite: 2,
		Wing: 3,
		Shengqi: 4,
		Weapon: 5,
		Pet: 7,
		MagicArray: 8,
		BackOrnament: 9, //背饰
		Partner: 10,
		NewBackOrnament: 12, //背饰
	};
	public static pro_list = [
		["name", "s"],
		["sex", "c"],
		["realm", "c"],
		["career", "c"],
		["level", "h"],
		["GM", "c"],
		["vip_flag", "c"],
		["is_hide_vip", "c"],
		["touxian", "c"],
		["level_model_list", [["part_pos", "c"], ["level_model_id", "i"]]],
		["fashion_model_list", [["part_pos", "c"], ["fashion_model_id", "i"], ["fashion_chartlet_id", "c"]]],
		["picture", "s"],
		["prcture_ver", "i"],
		["guild_id", "l"],
		["guild_name", "s"],
		["position", "c"],
		["position_name", "s"],
		["dsgt_id", "i"],
		["liveness_id", "i"],
		["turn", "c"],
		["turn_stage", "c"],
		["grade_id", "c"],
		["is_marriage", "c"],
		["marriage_id", "l"],
		["marriage_name", "s"],
		["escort_state", "i"],
		["block_id", "i"],
		["house_id", "i"],
		["house_lv", "h"],
		["figure_list", [["figure_type", "c"], ["figure_id", "i"], ["figure_chartlet_id", "i"]]],
		["figure_ride_list", [["figure_type", "c"], ["is_ride", "c"]]],
		["achv_lv", "h"],
		["medal_id", "h"],
		["fazhen_id", "i"],
		["dress_list", [["dress_type", "c"], ["dress_id", "i"]]],
		["god_id", "i"],
		["revelation_suit", "i"],
		["demon_id", "i"],
		["supreme_vip", "c"],
		["title_id", "i"],
		["mask_id", "c"],
		["seaCamp", "c"],
		["brick_id", "c"],
		["dummy_type", "c"],
		["suit_fashion_id", "c"],
		["collect_state", "c"]
	];
	public constructor() {
	}
	public ReadFmt(target) {
		let len: number, list_vo
		FigureProtoVo.pro_list.forEach((value: (string | string[][])[], index: number) => {
			var pro = <string>value[0]
			if (pro == "level_model_list"
				|| pro == "fashion_model_list"
				|| pro == "figure_list" 
				|| pro == "figure_ride_list" 
				|| pro == "dress_list"
				) {
				len = user_msg_adapter.ReadFmt("h");
				target[pro] = [];
				for (let j = 0; j < len; j++) {
					list_vo = {};
					for (let k = 0; k < value[1].length; k++) {
						list_vo[value[1][k][0]] = user_msg_adapter.ReadFmt(value[1][k][1]);
					}
					target[pro].push(list_vo);
				}
			}
			else {
				target[pro] = user_msg_adapter.ReadFmt(<string>value[1]);
				// if(value[0] == "is_hide_vip"){
					// console.error("FigureProtoVo ReadFmt ",value[0], value[1], target[<string>value[0]])
				// }
			}
		});
	}
}

window["FigureProtoVo"] = FigureProtoVo