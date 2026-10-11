import { EventDispatcher } from "../util/EventDispatcher"

export class DialogueNodeVo extends EventDispatcher {


	type
	text
	otherInfos
	findVo
	public constructor() {
		super()

		/* 对话类型 <br>
			0	npc	NPC对话内容 <br>
			1	role	角色对话内容 <br>
			2	yes	确定 <br>
			3	no	取消 <br>
			4	fight	发生战斗 <br>
			5	trigger	触发任务，附加参数，array(任务id) <br>
			6	finish	完成任务，附加参数，array(任务id) <br>
			7	trigger_and_finish	触发并完成任务 <br>
			8	talk_event	触发对话事件 <br>
			9	build_guild	建立帮派 <br>
			10	apply_join_guild	申请加入帮派 <br>
			11	guild_store	帮派仓库 <br>
			12	guild_task	帮派任务 <br>
			13	learn_skill	技能学习 <br>
			14	personal_store	个人仓库 <br>
			15	buy	买物品 <br>
			16	sell	卖物品 <br>
			17	mixture	合成 <br>
			18	embed	镶嵌 <br>
			19	identify	装备鉴定 <br>
			20	mix	法宝熔合 <br>
			21	strenghten	装备强化 <br>
			22	petshop	仙宠购买 <br>
			23	train_equip	法宝修炼 <br>
			24	drill	装备打孔 <br>
			25	fixed	装备修理 <br>
			26	fix_all	全部修理 <br>
			27	ablate	摘除宝石 <br>
			28	alchemy	炼丹 <br>
			29	back_to_guild_scene	回到帮会领地 <br>
			30	leave_guild_scene	离开帮会领地 <br>
			31	join_guild_war	参加帮会战 <br>
			32	watch_guild_war	观看帮会战 <br>
			33	enabled_xxd	开启玄虚鼎 <br>
			34	chushi	出师 <br>
			35	bole_billboard	伯乐榜 <br>
			36	soul_binding	灵魂绑定 <br>
			37	coin_binding	金币绑定 <br>
			38	task_award	任务奖励 <br>
			39	jobber	交易行 <br>
			40	open_favorite 弹出收藏框(不显示) <br>
			41	enter_dungeon	进入副本 <br>
			42	leave_dungeon	离开副本 <br>
			*/
		this.type = 0  //类型
		this.text = ""  //对话内容
		this.otherInfos = []  //其他信息
		this.findVo = null  //寻路
	}
}

window["DialogueNodeVo"] = DialogueNodeVo