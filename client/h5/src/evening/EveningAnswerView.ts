import { Alert, Alert_Type } from "../alert/Alert"
import { ChatItem } from "../chat/ChatItem"
import { VoiceChatView } from "../chat/VoiceChatView"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CHAT_TYPE, ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActivityModel, GuildActDefine, GuildActEvent } from "../commonModel/GuildActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { TimeUtil } from "../util/TimeUtil"
import { Util, Trim, GlobalTimerQuest, HtmlColorTxt, SetAnchoredPosition, RefBoxChildsLayout, SetHtmlStyle } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { EveningAnswerItem } from "./EveningAnswerItem"
import { EveningChatItem } from "./EveningChatItem"

export class EveningAnswerView extends BaseItem1 {
	Empbtn_speak
	_ac_rank
	_answer_list
	_arrayCollection
	_btn_rbg
	_channel
	_is_select
	_quest_info
	_right_idx
	//_select_idx
	_send
	_timer_id
	_tips_pos_list
	choose_count
	cmodel
	item_list
	model: GuildActivityModel
	percentHeight
	percentWidth
	preload_server_config
	quest_count
	reward_list
	scmd40214
	send
	spirit_count
	voice_view
	write_count

	tag_pos
	item_List = []
	question_obj = {} //记录答过的题目
	//cur_question_id //当前题目id
	btn_pos_ = []
	is_show=true
	public constructor(parent?) {
		super(parent)
		this._answer_list = ["A.", "B.", "C.", "D."];
		this._tips_pos_list = [143, 303, 463, 623];
		this.dependent_res = ["chat"]
		this._is_select = false;
		this._right_idx = 0;
		//this._select_idx = -1;
		this.choose_count = 0;
		this.write_count = 2;
		this.quest_count = 12;
		this.spirit_count = 5;
		// this.cur_question_id = -1
		this._channel = CHAT_TYPE.GUILD_QUIZ;
		this._send = false;
		this.model = GuildActivityModel.GetInstance();
		this.base_file = "evening"
		this.layout_file = "EveningAnswerView"
		this.percentWidth = 100
		this.percentHeight = 100
		this.item_list = []
		this.preload_client_config = { "ClientTitleNameBordWidth": false }
		this.preload_server_config = {
			"config_gfeast": false,
			"config_guild_reply_title": false,
			"config_title_cfg": false,
			"config_medal": false
		}
		this.load_callback = () => {
			for (let i = 0; i <= GuildActDefine.ANSWER_COUNT; i++) {
				let btn: Laya.Box = this["_btn_an_" + (i + 1)]
				if (btn) {
					this.btn_pos_[i] = [btn.x, btn.y]
				}
			}
			this.question_obj = {}
			this._quest_info = {}
			this.display_obj.centerX = 0
			this.display_obj.centerY = 0
			this.contentScroller.vScrollBarSkin = ""
			//RefBoxChildsLayout(this._Group1, 10, null, true)
			this.LoadSuccess()
		}

	}

	public DeleteMe() {
		if (this.contentScroller.vScrollBar) Laya.Tween.clearAll(this.contentScroller.vScrollBar)
		Laya.timer.clear(this, this.KeepScrollBottom)
		GlobalEventSystem.Fire(EventName.CLOSE_CHAT_VIEW)
		this.Clear()
		this.RemoveListen()
		super.DeleteMe()
	}

	public Clear() {
		this.ClearTimer()
		if (this._ac_rank) {
			this._ac_rank.DeleteMe()
			this._ac_rank = null
		}

		for (let i = 0; i < this.item_list.length; i++) {
			if (!this.item_list[i]) continue
			this.item_list[i].DeleteMe()
			this.item_list[i] = null
		}
		this.item_list.length = 0
	}

	public LoadSuccess() {
		SetHtmlStyle(this._lb_time, { f: 18, c: "#7b5250", w: 260, ww: false })
		//resource/game/evening/other/ui_ghdt_bg_02.png
		ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetIconOtherPath("evening", "ui_ghdt_bg_02"))
		ResManager.GetInstance().SetTexture(this, this.img4, GameResPath.GetIconOtherPath("evening", "ui_ghdt_bg_01"))
		this.choose_count = Number(ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)[27]["value"])
		this.write_count = Number(ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)[28]["value"])
		this.quest_count = this.choose_count + this.write_count
		this.spirit_count = Number(ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)[54]["value"])
		this.reward_list = JSON.parse(ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)[53]["value"])
		this.percentWidth = 100
		this.percentHeight = 100
		this.InitView()
		this.InitChatView()
		this.InitEvent()
		this.InitChatEvent()

		this.FireEvent()
		this.UpdateRankData()
		this.UpdateMyRankData()
		//this.TestData()
	}

	public InitView() {

		this.cmodel = ChatModel.GetInstance()
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_award, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningRankRewardView")
		}, this, true)


		Util.AddClickEvent(this._close_img, () => {
			this.model.Fire(GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, true)
		}, this, true)

		Util.AddClickEvent(this._btn_an_1, () => {
			this.SelectAnswer(1)
		}, this, true)

		Util.AddClickEvent(this._btn_an_2, () => {
			this.SelectAnswer(2)
		}, this, true)

		Util.AddClickEvent(this._btn_an_3, () => {
			this.SelectAnswer(3)
		}, this, true)

		Util.AddClickEvent(this._btn_an_4, () => {
			this.SelectAnswer(4)
		}, this, true)

		this.BindVar(this.model, "question_info", (event_name?, value?, old_value?) => {
			this._quest_info = value
			this.UpdateQuestion(value)
		}
		)
		this.BindVar(this.model, "rank_info", (event_name?, value?, old_value?) => {
			this.UpdateRankData()
		}
		)

		this.BindEvent(this.model, GuildActEvent.UPDATE_QUESTION_STATUS, (status) => {
			this.UpdateChooseBtn(status)
		})


		this.BindEvent(this.model, GuildActEvent.UPDATE_MY_RANK_INFO, () => {
			this.UpdateMyRankData()
		})


		this.BindEvent(this.model, GuildActEvent.OPEN_CLOSE_SCORE_RANK_VIEW, (bool?) => {
			this.SetVisible(!bool)
		})


	}


	RemoveListen() {
		if (this.voice_view) {
			this.voice_view.Close()
			this.voice_view = null
		}
	}

	public FireEvent() {
		this.model.Fire(GuildActEvent.REQUEST_PROTO, 40217)
	}

	public UpdateView() {


	}
	public SelectAnswer(i?) {
		if (!this._quest_info) return
		if (this.question_obj[this._quest_info.id]) {
			Message.show("此题已作答")
			return
		}


		this.model.answer_select_index = i
		this._is_select = true

		let msg = this.answer_list[i - 1] //不知道下标

		this.question_obj[this._quest_info.id] = true
		this.model.Fire(GuildActEvent.REQUEST_PROTO, 40259, "c", this.model.answer_select_index)
		// this.SendMsg(msg)
	}

	public UpdateRankData() {
		let data = this.model.GetRankInfo()
		if (data && data.rank_list) {

			if (!this._ac_rank) {
				this._ac_rank = new LoopScrowViewMgr()
				this._ac_rank.SetData(this._lits_ranks, EveningAnswerItem, data.rank_list, LoopScrCon.Vertical)
			} else {
				this._ac_rank.replaceAll(data.rank_list)
			}

			this._lb_rank_tips.visible = data.rank_list.length < 1
		}

	}

	public UpdateMyRankData() {
		let data = this.model.MyRankInfo()
		if (!data) {
			data = { rank: 0, point: 0 }
		}
		this._lb_rank.text = (data.rank <= 0 && ("无") || (data.rank + ""))
		this._lb_score.text = data.point + ""
	}


	/**更新问题 */
	public UpdateQuestion(data?) {

		//题号为0用来判断答题结束，关闭界面
		if (0 == data.no) {
			return
		}
		if (data.status == 0) {
			return
		}

		let cfg_g = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_reply_title", false)
		if (!cfg_g) {
			return
		}

		if(!cfg_g[data.id])return
		let cfg = cfg_g[data.id]

		this._group_btn.visible = cfg.topic_type == 1
		SetHtmlStyle(this._lb_content, { c: "#663519", f: 20, ww: true, w: 275, lh: 23 })
		this._Label11.text = `第${data.no}/${this.quest_count}题`
		this._lb_content.innerHTML = Trim(cfg.question)
		this._right_idx = cfg.right
		this.UpdateAnswer(cfg)
		this.SetTimer(data)

		
		if (this.model.cur_question_id != data.no) {
			//题目更换  刷新按钮的状态
			this.model.cur_question_id = data.no
			this.UpdateChooseBtn(-1)
			this.question_obj[data.id] = false
		}else{
			//同一个题目
			if(this.model.answer_select_index!=-1){
				this.question_obj[this._quest_info.id] = true
				this.UpdateChooseBtn(this.model.answer_select_index)
			}else{
				this.UpdateChooseBtn(-1)
				this.question_obj[data.id] = false
			}
			
		}

	}


	/**更新选择题按钮状态 status==1选对了  ==0选错了   ==-1仅仅设置按钮变色*/
	public UpdateChooseBtn(status) {
		this._img_tag.visible = false
		for (let i = 1; i <= GuildActDefine.ANSWER_COUNT; i++) {
			let btn_bg: Laya.Image = this["_img_an_" + i]
			if (btn_bg) {
				let url = "ui_ghdt_basal_06"  //默认色
				console.warn("测试@this.model.answer_select_index",this.model.answer_select_index)
				if (this.model.answer_select_index != -1 && this.model.answer_select_index == i && status != -1) {
					url = status == 0 ? "ui_ghdt_basal_05" : "ui_ghdt_basal_08"
					this._img_tag.visible = true
					let tag_url = status == 1 ? "ui_ghdt_basal_04" : "ui_ghdt_basal_03"
					ResManager.GetInstance().SetImageSprite(this, this._img_tag, "evening", tag_url)

					//位置
					let pos = this.btn_pos_[i - 1]
					this._img_tag.x = pos[0] + 140
					this._img_tag.y = pos[1] + 9
				}
				ResManager.GetInstance().SetImageSprite(this, btn_bg, "evening", url)
			}
		}
	}


	answer_list = []
	public UpdateAnswer(cfg?) {

		let is_show = false
		let answer = null
		this.answer_list = []
		for (let i = 1; i <= GuildActDefine.ANSWER_COUNT; i++) {
			answer = cfg["answer" + i]
			is_show = answer != ""
			let btn: Laya.Box = this["_btn_an_" + i]
			btn.visible = is_show
			if (is_show) {
				let btn_tx: Laya.Text = this["_lb_an_" + i]
				btn_tx.text = this._answer_list[i - 1] + answer
				table.insert(this.answer_list, answer)
			}
		}
	}

	public SetTimer(data?) {

		this.ClearTimer()
		// let status = data.status
		// if (status == 1) {
		// 	this.HideTipsImage()
		// } else {
		// 	this.SetTipsImage()
		// }


		this.ClearTimer()
		this._timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
			this.UpdateTimer()
		}, 1, -1)
		this.UpdateTimer()
	}


	public UpdateTimer() {

		let rtime = this._quest_info.etime - TimeUtil.getServerTime()
		if (rtime < 0) {
			this.ClearTimer()
		} else {
			this.SetTimeText(this._quest_info.status, rtime)
		}
	}

	public SetTimeText(status?, rtime?) {
		let str = HtmlColorTxt(rtime, "'#ff6519'")//Enum_ColorUtil_Dark.GREEN)
		if (status == 1) {
			this._lb_time.innerHTML = `答题时间：${str}秒`   //Util.StrToHTML("答题时间：" + str + "秒")
		} else if (status == 2) {
			this._lb_time.innerHTML = `${str}秒后开始下一题，请做好准备！` // Util.StrToHTML(str + "秒后开始下一题，请做好准备！")
		}
	}

	public ClearTimer() {

		if (this._timer_id) {
			GlobalTimerQuest.CancelQuest(this._timer_id)
			this._timer_id = null
		}
	}

	// public SetImgPos(idx?, img?) {

	// 	if (!idx) {
	// 		return
	// 	}
	// 	// [ts2lua]this._btn_list下标访问可能不正确
	// 	let btn = this._btn_list[idx]
	// 	// let gPoint = btn.localToGlobal()
	// 	// let lPoint = this.globalToLocal(gPoint.x, gPoint.y)
	// 	//transform.TransformPoint(localpos) 给一个相对于这个transform的局部坐标，返回一个世界坐标
	// 	//Transform.InverseTransformPoint(worldpos) 给一个世界坐标，返回相对这个transform的局
	// 	// let gPoint = UILocalToCanvasPoint(btn)
	// 	// let lPoint = this.form(gPoint)
	// 	// img.x = lPoint.x + 117
	// 	// img.y = lPoint.y + 15
	// 	let lPoint = this.tag_pos[idx + 1]
	// 	// SetAnchoredPosition(img, lPoint.x + 117, lPoint.y + 15)
	// 	SetAnchoredPosition(img, lPoint[0], lPoint[1])
	// 	// img.visible = true 
	// 	img.visible = false  //策划说没有选择题了
	// }

	// public SetTipsImage() {

	// 	this.SetImgPos(this._right_idx, this._img_right)
	// 	if (this._select_idx < 0) {
	// 		return
	// 	}
	// 	let is_right = this._right_idx == this._select_idx
	// 	if (!is_right) {
	// 		this.SetImgPos(this._select_idx, this._img_wrong)
	// 	} else {
	// 		this.ShowRightReward()
	// 	}
	// 	this._select_idx = -1
	// }

	// public HideTipsImage() {

	// 	this._img_right.visible = false
	// 	this._img_wrong.visible = false
	// }

	public ShowRightReward() {

		for (let _tmpi in this.reward_list) {
			var info = this.reward_list[_tmpi]
			let type_id = GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (!basic) {
				break
			}
			// Message.show("获得" + basic.goods_name + "x" + info[2], false, SysInfoType.MINI)
			Message.show("获得" + basic.goods_name + "x" + info[2])
		}
	}

	public SendMsg(msg?) {

		this._send = true
		let roleVo = RoleManager.GetInstance().GetMainRoleVo()
		let channel = this._channel
		let sendGoods, goods_id_list, sendGoodsMesg
		[sendGoods, goods_id_list, sendGoodsMesg] = this.cmodel.sendGoodsMesg(msg)
		this.cmodel.Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, channel, roleVo.province, roleVo.city, 0, sendGoodsMesg, sendGoods, 0, "")
		// sendGoodsMesg = sendGoodsMesg + `${HtmlColorTxt("<a@guildquiz>前往答题</a>", Enum_ColorUtil_Dark.BLUE)}`
		// this.cmodel.Fire(ChatModelEvent.CHAT_SEND_MSG, 11001, CHAT_TYPE.GUILD, roleVo.province, roleVo.city, 0, sendGoodsMesg, sendGoods, 0, "")
	}

	last_sec_=0
	public InitChatEvent() {

		Util.AddClickEvent(this.sendBtn, () => {
			let msg = this._input.text
			if (msg == "") {
				Message.show("请输入聊天内容!")
				return
			}
			if((TimeUtil.getServerTime()-this.last_sec_)<4){
				let left_time= 4-(TimeUtil.getServerTime()-this.last_sec_)
				Message.show(`${HtmlColorTxt(`${left_time}s`,Enum_ColorUtil_Light.GREEN)}后可再次发言`)
				return
			}
			this.last_sec_ = TimeUtil.getServerTime()
			this.SendMsg(msg)
		}
			, this, true)
		Util.AddClickEvent(this.faceBtn, (e?) => {
			this.cmodel.selectChannel = this._channel
			this.cmodel.Fire(ChatModelEvent.OPENTOOLPANEL, this.faceBtn.localToGlobal(new Laya.Point(0, 0), true))
			//e.stopImmediatePropagation()
		}
			, this, true)

		this.BindEvent(this.cmodel, ChatModelEvent.CHAT_CHANNEL_MSG_UPDATE, (e?, chat?) => {
			let channel = this._channel
			if (e == channel) {
				this.UpdateChatView(chat)
			}
		})

		let addFace = (...new_args) => {
			let args = new_args
			if (args[0] && args[1] == this._channel) {
				let face_str = "<f_" + args[0] + ">"
				if (this._input.text.length + face_str.length <= this._input.maxChars || this._input.maxChars == 0) {
					this._input.text = this._input.text + face_str
				} else {
					Message.show("单条信息不超过30字")
				}
			}
		}



		this.BindEvent(this.cmodel, ChatModelEvent.ADD_FACE, addFace)

		let addGoods = (...new_args) => {
			let args = new_args
			let data = args[1]
			let goods_name = data.goods_name
			let name = "[" + goods_name + "]"
			if (args[2] == this._channel) {
				// if ((Language.GetStringLength(name) + Language.GetStringLength(this._input.text) < this._input.characterLimit || this._input.characterLimit == 0)) {
				// 	// this._input.text = this._input.text + "[" + args[0] + "]"
				// 	this._input.text = this._input.text + "%[" + args[0] + "%]"

				// 	// let repetition = string.find(this._input.text, "%[" + goods_name + "%]")
				// 	// _model.setSendGoodsData(data, repetition)
				// 	// this._input.text = this._input.text + name
				// }
			}
		}
		this.BindEvent(this.cmodel, ChatModelEvent.ADD_BAG_GOODS, addGoods)
	}

	public UpdateChatView(chat?) {

		if (this.is_loaded) {
			if (this._send) {
				this._input.text = ""
				this._send = false
			}
			let item = new EveningChatItem(this.Content1)
			item.Load()
			item.SetData(chat)
			table.insert(this.item_list, item)

			Laya.timer.frameOnce(10, this, this.KeepScrollBottom, [false])
			//this.KeepScrollBottom()
		}
	}


	public InitChatView() {

		let datalsit = []
		datalsit = datalsit.concat(this.cmodel.getChannelChat(this._channel))//table.merge(datalsit, this.cmodel.getChannelChat(this._channel))

		for (let i = 0; i < datalsit.length; i++) {
			var v = datalsit[i]
			this.item_list[i] = this.item_list[i] || new EveningChatItem(this.Content1)
			this.item_list[i].SetData(v)
		}

		Laya.timer.frameOnce(50, this, this.KeepScrollBottom, [true])
	}

	public KeepScrollBottom(is_croll?) {
		if (this.use_delete_method) return
		if (!is_croll) {
			this.contentScroller.vScrollBar.value = this.contentScroller.vScrollBar.max
			return
		}
		Laya.Tween.clearAll(this.contentScroller.vScrollBar)
		Laya.Tween.to(this.contentScroller.vScrollBar, { value: this.contentScroller.vScrollBar.max }, 400)

	}

	public IsQuizFinish() {

		let question_info = this.model.GetQuestInfo()
		return null == question_info || 0 == question_info.no
	}


	// public TestData() {
	// 	let data_list = []
	// 	let len=5
	// 	for (let k = 0; k < len; k++) {
	// 		let data
	// 		data = {
	// 			GM: 0,
	// 			achv_lv: 1,
	// 			args: "[]",
	// 			block_id: 0,
	// 			brick_id: 0,
	// 			career: 2,
	// 			channel: 16,
	// 			city: "",
	// 			demon_id: 0,
	// 			dress_list: [],
	// 			dsgt_id: 0,
	// 			dummy_type: 0,
	// 			escort_state: 0,
	// 			fashion_model_list: [],
	// 			fazhen_id: 0,
	// 			figure: undefined,
	// 			figure_list: [
	// 				{
	// 					figure_chartlet_id: 0,
	// 					figure_id: 1101,
	// 					figure_type: 5
	// 				}
	// 			],
	// 			figure_ride_list: [],
	// 			god_id: 0,
	// 			grade_id: 0,
	// 			guild_id: 4294967297,
	// 			guild_name: "sdfsd",
	// 			house_id: 0,
	// 			house_lv: 0,
	// 			iType: 1,
	// 			image_id: 0,
	// 			is_marriage: 0,
	// 			level: 371,
	// 			level_model_list: [],
	// 			marriage_id: 0,
	// 			marriage_name: "",
	// 			mask_id: 0,
	// 			medal_id: 2,
	// 			msg: k==3?"我是无情的测<f_24>":"我是无情",
	// 			name: "希尔瑟雅",
	// 			picture: "204",
	// 			player_id: 4294968461,
	// 			position: 3,
	// 			position_name: "会员",
	// 			prcture_ver: 0,
	// 			province: "同省",
	// 			realm: 0,
	// 			result: 0,
	// 			revelation_suit: 0,
	// 			seaCamp: 0,
	// 			ser_id: 1,
	// 			ser_name: "《永夜25dLaya》开发服",
	// 			server_num: 1,
	// 			sex: 2,
	// 			suit_fashion_id: 0,
	// 			supreme_vip: 0,
	// 			time: 1638448180,
	// 			title_id: 0,
	// 			touxian: 0,
	// 			turn: 4,
	// 			turn_stage: 0,
	// 			vip_flag: 12
	// 		}

	// 		if (k == len - 1) {
	// 			data.msg+="<f_24>"
	// 			data.player_id = RoleManager.GetInstance().GetMainRoleId()
	// 		}
	// 		data_list.push(data)
	// 	}


	// 	let sys_data
	// 	sys_data = {
	// 		GM: 0,
	// 		achv_lv: 1,
	// 		args: "[]",
	// 		block_id: 0,
	// 		brick_id: 0,
	// 		career: 2,
	// 		channel: CHAT_TYPE.SYSTEM,
	// 		city: "",
	// 		demon_id: 0,
	// 		dress_list: [],
	// 		dsgt_id: 0,
	// 		dummy_type: 0,
	// 		escort_state: 0,
	// 		fashion_model_list: [],
	// 		fazhen_id: 0,
	// 		figure: undefined,
	// 		figure_list: [
	// 			{
	// 				figure_chartlet_id: 0,
	// 				figure_id: 1101,
	// 				figure_type: 5
	// 			}
	// 		],
	// 		figure_ride_list: [],
	// 		god_id: 0,
	// 		grade_id: 0,
	// 		guild_id: 4294967297,
	// 		guild_name: "sdfsd",
	// 		house_id: 0,
	// 		house_lv: 0,
	// 		iType: 1,
	// 		image_id: 0,
	// 		is_marriage: 0,
	// 		level: 371,
	// 		level_model_list: [],
	// 		marriage_id: 0,
	// 		marriage_name: "",
	// 		mask_id: 0,
	// 		medal_id: 2,
	// 		msg: "我是无情的测试代码<font color='#993516'>无情编程</font>我是无情的测试代码<font color='#993516'>无情编程</font>我是无情的测试代码<font color='#993516'>无情编程</font>我是无情的测试代码<font color='#993516'>无情编程</font>",
	// 		name: "希尔瑟雅",
	// 		picture: "204",
	// 		player_id: 4294968461,
	// 		position: 3,
	// 		position_name: "会员",
	// 		prcture_ver: 0,
	// 		province: "同省",
	// 		realm: 0,
	// 		result: 0,
	// 		revelation_suit: 0,
	// 		seaCamp: 0,
	// 		ser_id: 1,
	// 		ser_name: "《永夜25dLaya》开发服",
	// 		server_num: 1,
	// 		sex: 2,
	// 		suit_fashion_id: 0,
	// 		supreme_vip: 0,
	// 		time: 1638448180,
	// 		title_id: 0,
	// 		touxian: 0,
	// 		turn: 4,
	// 		turn_stage: 0,
	// 		vip_flag: 12
	// 	}
	// 	data_list.push(sys_data)
	// 	data_list.push(sys_data)


	// 	for (let i = 0; i < data_list.length; i++) {
	// 		this.UpdateChatView(data_list[i])
	// 	}


	//  }


	_Group2: Laya.Box
	_img_bg: Laya.Image
	_img_b2: Laya.Image
	img4: Laya.Image
	_Image1: Laya.Image
	_img6: Laya.Image
	_lits_ranks: Laya.List
	_group_btn: Laya.Box
	_lb_tips: Laya.Label
	_btn_an_1: Laya.Box
	_img_an_1: Laya.Image
	_lb_an_1: Laya.Text
	_btn_an_2: Laya.Box
	_img_an_2: Laya.Image
	_lb_an_2: Laya.Text
	_btn_an_3: Laya.Box
	_img_an_3: Laya.Image
	_lb_an_3: Laya.Text
	_btn_an_4: Laya.Box
	_img_an_4: Laya.Image
	_lb_an_4: Laya.Text
	_img_tag: Laya.Image
	_lb_content: Laya.HTMLDivElement
	_lb_time: Laya.HTMLDivElement
	_Label11: Laya.Label
	_Label1: Laya.Label
	_lb_rank: Laya.Label
	_Label2: Laya.Label
	_lb_score: Laya.Label
	_lb_rank_tips: Laya.Label
	_Group1: Laya.Box
	text_input: Laya.Box
	_Image111: Laya.Image
	_input: Laya.TextInput
	faceBtn: Laya.Box
	_Image111111111: Laya.Image
	sendBtn: Laya.Box
	_Image11111: Laya.Image
	labelDisplay11: Laya.Label
	contentScroller: Laya.Panel
	Content1: Laya.VBox
	_img_jiejie_b: Laya.Image
	_jie_txt: Laya.Text
	_close_img: Laya.Image
	_btn_award: Laya.Image
	public GetComponents() {
		[
			this._Group2,
			this._img_bg,
			this._img_b2,
			this.img4,
			this._Image1,
			this._img6,
			this._lits_ranks,
			this._group_btn,
			this._lb_tips,
			this._btn_an_1,
			this._img_an_1,
			this._lb_an_1,
			this._btn_an_2,
			this._img_an_2,
			this._lb_an_2,
			this._btn_an_3,
			this._img_an_3,
			this._lb_an_3,
			this._btn_an_4,
			this._img_an_4,
			this._lb_an_4,
			this._img_tag,
			this._lb_content,
			this._lb_time,
			this._Label11,
			this._Label1,
			this._lb_rank,
			this._Label2,
			this._lb_score,
			this._lb_rank_tips,
			this._Group1,
			this.text_input,
			this._Image111,
			this._input,
			this.faceBtn,
			this._Image111111111,
			this.sendBtn,
			this._Image11111,
			this.labelDisplay11,
			this.contentScroller,
			this.Content1,
			this._img_jiejie_b,
			this._jie_txt,
			this._close_img,
			this._btn_award,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_img_bg",
				"_img_b2",
				"img4",
				"_Image1",
				"_img6",
				"_lits_ranks",
				"_group_btn",
				"_lb_tips",
				"_btn_an_1",
				"_img_an_1",
				"_lb_an_1",
				"_btn_an_2",
				"_img_an_2",
				"_lb_an_2",
				"_btn_an_3",
				"_img_an_3",
				"_lb_an_3",
				"_btn_an_4",
				"_img_an_4",
				"_lb_an_4",
				"_img_tag",
				"_lb_content",
				"_lb_time",
				"_Label11",
				"_Label1",
				"_lb_rank",
				"_Label2",
				"_lb_score",
				"_lb_rank_tips",
				"_Group1",
				"text_input",
				"_Image111",
				"_input",
				"faceBtn",
				"_Image111111111",
				"sendBtn",
				"_Image11111",
				"labelDisplay11",
				"contentScroller",
				"Content1",
				"_img_jiejie_b",
				"_jie_txt",
				"_close_img",
				"_btn_award",
			])
	}
}
window["EveningAnswerView"] = EveningAnswerView