import { BaseView1 } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Config } from "../common/Config"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { ViewManager } from "../common/ViewManager"
import { MainUIController } from "../commonController/MainUIController"
import { ChatModel, ChatModelEvent } from "../commonModel/ChatModel"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { DressModel } from "../commonModel/DressModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GetSexByCareer, GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class DiamondFightBattleView extends BaseView1 {

	public static LinePosData = {
		"9":{
			pos_x : {
				left:159,
				right:562
			},
			pos_y :{
				"0":136,
				"1":118,
				"2":354,
				"3":336,
				"4":591,
				"5":577,
				"6":813,
				"7":799,
			}
		},
		"10":{
			pos_x : {
				left:214,
				right:507
			},
			pos_y :{
				"0":243,
				"1":229,
				"2":700,
				"3":690,
			}
		},
		"11":{
			pos_x : {
				left:313,
				right:408
			},
			pos_y :{
				"0":503,
				"1":486.5,
			},
			height :{
				"1":217
			},
			sizeGrid:{
				"1": "112,0,90,0"
			}
		}
	}


	click_menu_pos
	init_role_info
	line_dic
	time_id
	top_head: CustomHeadItem

	chat_model: ChatModel
	diamond_fight_model: DiamondFightModel
	layer_mgr: LayerManager
	mainUI_controller: MainUIController
	role_mgr: RoleManager
	res_mgr: ResManager
	view_mgr:ViewManager

	static Spacing = 7
	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightBattleView"
		this.layer_value = Enum_UILayer.UI
		this.destroy_imm = true
		this.change_scene_close = true

		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.layer_mgr = LayerManager.GetInstance()
		this.mainUI_controller = MainUIController.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.chat_model = ChatModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.view_mgr = ViewManager.GetInstance()

		this.time_id = null
		this.init_role_info = false

		this.preload_server_config = {
			"config_career": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			let main_ui_chat_view = this.mainUI_controller.main_ui_chat_view
			if (main_ui_chat_view) {
				if (main_ui_chat_view.layer_value != Enum_UILayer.UI) {
					main_ui_chat_view.layer_value = Enum_UILayer.UI
				}
				main_ui_chat_view.uilayer = this.layer_mgr.GetUILayer(main_ui_chat_view.layer_value)
				main_ui_chat_view.Open()
			}
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {

		let main_ui_chat_view = this.mainUI_controller.main_ui_chat_view
		if (main_ui_chat_view && main_ui_chat_view.layer_value != Enum_UILayer.Main && main_ui_chat_view.HasOpen()) {

			main_ui_chat_view.layer_value = Enum_UILayer.Main
			main_ui_chat_view.uilayer = this.layer_mgr.GetUILayer(main_ui_chat_view.layer_value)
			main_ui_chat_view.Open()

		}
		delete BaseWindowComponent.CURR_OPEN_VIEW[this.hashCode]
		this.view_mgr.CloseBaseWindow()
		this.init_role_info = false
		this.CancelCountTime()

		if (this.top_head) {
			this.top_head.DeleteMe()
			this.top_head = undefined
		}

		for (let i = 0; i < 16; i++) {
			if (this["head_" + i]) {
				this["head_" + i].DeleteMe()
				this["head_" + i] = null
			}
		}
	}

	public LoadSuccess() {

		this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0
		this.display_obj.top = Util.GetLiuhaiHeight()

		BaseWindowComponent.CURR_OPEN_VIEW[this.hashCode] = true


		//resource/game/diamondFight/texture/uizsdz_026.png
		let i = 0
		do {
			this.res_mgr.SetOutsideImageSprite(this, this["_img_line" + i], GameResPath.GetIcon("diamondFight", "uizsdz_026"))
			i = i + 1
		} while ((i < 2))


		//resource/game/diamondFight/texture/uizsdz_024.png
		this.res_mgr.SetOutsideImageSprite(this, this._img_tips_bg, GameResPath.GetIcon("diamondFight", "uizsdz_024"))

		//resource/game/diamondFight/texture/bg.jpg
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("diamondFight", "bg"))

		// resource/game/diamondFight/texture/uizsdz_01a.png
		this.res_mgr.SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("common", "uizsdz_01a"))


		this.line_dic = {}

		this.InitView()
		this.InitEvent()
		this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13719)
		this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13703)

		this.view_mgr.OpenBaseWindow()

		
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_return, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._img_heart, () => {
			let info = this.diamond_fight_model.waiting_info
			if (info) {
				if (info.is_out == 0) {
					if (!this.diamond_fight_model.waiting_info) {
						return
					}
					this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightPurchaseView")
				} else {
					Message.show("您已被淘汰，无法购买命数")
				}
			}
			else{
				Message.show("当前阶段,无法购买命数")
			}
		}, this, true)

		Util.AddClickEvent(this._box_record, () => {
			this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightBetRecordView")
		}, this, true)

		Util.AddClickEvent(this._box_bet, () => {
			if (this.diamond_fight_model.IsInBetState()) {
				this.diamond_fight_model.Fire(DiamondFightModel.OPEN_VIEW, "DiamondFightBetView")
			} else {
				Message.show("当前不在竞猜阶段!")
			}
		}, this, true)

		this.BindVar(this.diamond_fight_model, "gamble_data", (event_name?, value?) => {
			this.UpdateBattleMsg()
		})

		this.BindVar(this.diamond_fight_model, "wait_tip_info", () => {
			this.UpdateWaitTipInfo()
		})

		this.BindVar(this.diamond_fight_model, "champion_info", () => {
			this.FightIsOut()
			this.UpdateChampionData()
		})

		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_RECORD_RED_STATE, () => {
			this.UpdateRecordRed()
		})
	}

	public InitView() {
		this.UpdateBattleMsg()
		this.UpdateWaitTipInfo()
		this.UpdateRecordRed()
	}

	public UpdateBattleMsg() {
		// return
		if (!this.diamond_fight_model.gamble_data) {
			return
		}
		let gamble_data = this.diamond_fight_model.gamble_data.data

		//测试
		// let gamble_data:any = this.diamond_fight_model.GetGambleData()

		let config_career = this.res_mgr.GetGameConfigFromCache(this, "config_career", false)
		let battle_msg = gamble_data && gamble_data[9]
		if (battle_msg && !this.init_role_info) {
			for (let key in battle_msg) {

				let vo = battle_msg[key]
				let index = (Number(key)) * 2
				if (vo.arid != 0) {

					this[`_lb_name${index}`].text = `S${vo.asnum}.${vo.aname}`
					if (vo.arid == this.role_mgr.GetMainRoleId()) {
						this[`_lb_name${index}`].color = "#ff4f50"
					}

					if (this[`head_${index}`] == null) {
						this[`head_${index}`] = new CustomHeadItem(this[`_img_head${index}`])
						// this[`head_${index}`].SetActiveLevel(false)
						this[`head_${index}`].SetActiveFrame(false)
						this[`head_${index}`].Load()
						this[`head_${index}`].SetScale(0.82)
						this[`head_${index}`].SetPosition(0, 0)
					}

					this[`head_${index}`].SetData(vo.arid, vo.acareer, GetSexByCareer(vo.acareer, config_career), vo.apic, vo.apicver, null, vo.asid, null, vo.alv)

					this[`head_${index}`].SetClickFunc((e: Laya.Event) => {
						this.click_menu_pos = new Vector2(e.stageX, e.stageY)
						this.chat_model.Fire(ChatModelEvent.OPEN_CHAT_MENU, this[`_img_head${index}`], vo.arid, vo.asid)
					})
				}

				if (vo.brid != 0) {
					this[`_lb_name${index + 1}`].text = "S" + vo.bsnum + "." + vo.bname
					if (vo.brid == this.role_mgr.GetMainRoleId()) {
						this[`_lb_name${index + 1}`].color = "#ff4f50"
					}


					if (this[`head_${index + 1}`] == null) {
						this[`head_${index + 1}`] = new CustomHeadItem(this["_img_head" + (index + 1)])
						// this[`head_${index + 1}`].SetActiveLevel(false)
						this[`head_${index + 1}`].SetActiveFrame(false)
						this[`head_${index + 1}`].Load()
						this[`head_${index + 1}`].SetScale(0.82)
						this[`head_${index + 1}`].SetPosition(0, 0)
					}

					this["head_" + (index + 1)].SetData(vo.brid, vo.bcareer, GetSexByCareer(vo.bcareer, config_career), vo.bpic, vo.bpicver, null, vo.bsid, null, vo.blv)

					this["head_" + (index + 1)].SetClickFunc((e) => {
						this.click_menu_pos = new Vector2(e.stageX, e.stageY)
						this.chat_model.Fire(ChatModelEvent.OPEN_CHAT_MENU, this["_img_head" + (index + 1)], vo.brid, vo.bsid)
					})
				}
			}
			this.init_role_info = true
		}

		let img
		for(let index in this.line_dic){
			img = this.line_dic[index]
			img.visible = false
		}	
		// return
		if (gamble_data) {
			let i = 9
			do {
				let value = gamble_data[i]
				if (!value) {
					break
				}
				for (let key in value) {
					let index = Number(key)
					let vo = value[key]
					if (vo.winner == vo.arid && vo.arid != 0) {
						let action = this.diamond_fight_model.GetNowAction()
						if (vo.brid == 0 && action == i && this.diamond_fight_model.IsInBetState()) {
							continue
						}
						this.DrawLine(i, index * 2)
					} else if (vo.winner == vo.brid && vo.brid != 0) {
						this.DrawLine(i, index * 2 + 1)
					}
				}
				i = i + 1
			} while ((i < 14))
		}
	}


	/**
	 * 
	 * @param round 轮次
	 * @param index 赢家序号
	 */
	public DrawLine(round, index) {
		let line:Laya.Image = this.line_dic[`${round}@${index}`]
		if(!line){
			line = this.GetLine()
			this.line_dic[`${round}@${index}`] = line
		}
		line.visible = true
		let res = this.GetLineResName(round)
		this.res_mgr.SetImageSprite(this, line, "diamondFight", res)
		let x, y
		let x_scale 
		let y_scale =  index % 2  == 0 ? 1 : -1
		let pos_data = DiamondFightBattleView.LinePosData[round]
		if(!pos_data) return
		let count  
		if(round == 9){
			count = 16
		} else if(round == 10){
			count = 8
		} else if(round == 11){
			count = 4
		}
		let half = count / 2
		let id = index % half

		x_scale =  index < half ? 1 : -1
		x = index < half ? pos_data.pos_x.left : pos_data.pos_x.right
		y = pos_data.pos_y[id]

		if(pos_data.sizeGrid && pos_data.sizeGrid[id]){
			line.sizeGrid = pos_data.sizeGrid[id]
		}

		if(pos_data.height && pos_data.height[id]){
			line.height = pos_data.height[id]
		}

		line.scaleX = x_scale
		line.scaleY = y_scale
		line.x = x
		line.y = y
		
	}

	public GetLineResName(round){
		if(round == 9){
			return "uizsdz_027a1"
		} else if(round == 10){
			return "uizsdz_027a2"
		} else if(round == 11){
			return "uizsdz_027a3"
		}
	}

	public GetLine(){
		let line = new Laya.Image()
		line.anchorX = line.anchorY = 1
		this._box_line.addChild(line)
		return line
	}

	public UpdateChampionData() {

		let champion_data = this.diamond_fight_model.champion_info
		if (champion_data && champion_data[0]) {

			let config_career = this.res_mgr.GetGameConfigFromCache(this, "config_career", false)
			let vo = champion_data[0]

			if (this.top_head == null) {
				this.top_head = new CustomHeadItem(this._img_top_head)
				this.top_head.SetActiveLevel(false)
				this.top_head.SetActiveFrame(false)
				this.top_head.Load()
				this.top_head.SetScale(0.82)
				this.top_head.SetActiveBg2(false)
			}

			this.top_head.SetData(vo.arid, vo.acareer, GetSexByCareer(vo.acareer, config_career), vo.apic, vo.apicver, null, vo.asid, null, vo.alv)

			//this:SetRoleHead(this._img_top_head, champion_data[1].acareer, champion_data[1].apic)

			this._lb_top_name.text = `S${vo.asnum}.${vo.aname}`
		} else {
			this._lb_top_name.text = "虚位以待"
			ResManager.GetInstance().SetImageSprite(this, this._img_top_head, "diamondFight", "uizsdz_032", true)
		}
	}

	

	

	public FightIsOut() {

		if (this.diamond_fight_model.champion_info) {
			// this.ClearUIEffect(this._box_gamble_effect)
			this.CancelCountTime()
			this._lb_count_down.visible = false
			this._img_count_down_bg.visible = false
			this._box_tips.visible = false
			return true
		}
	}

	public UpdateWaitTipInfo() {

		if (this.FightIsOut()) {
			return
		}
		// this.ClearUIEffect(this._box_gamble_effect)
		let info = this.diamond_fight_model.wait_tip_info
		if (info) {
			this._box_tips.visible = true
			this._lb_count_down.visible = true
			let end_time = info.end_time
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time > 0) {

				switch (info.type) {
					case 2:
						this._lb_count_down.visible = true
						this._img_count_down_bg.visible = true
						this._lb_tips.text = "争霸赛第" + (info.action - DiamondFightModel.HAIXUAN_ROUNDS) + "轮开始倒计时"
						this.StartCountTime(() => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								this.CancelCountTime()
								return
							}
							this._lb_count_down.text = String(left_time)
						}
						)
						break
					case 6:
						this.UpdateBattleMsg()
						this._lb_count_down.visible = true
						this._img_count_down_bg.visible = true
						this._lb_tips.text = "争霸赛第" + (info.action - DiamondFightModel.HAIXUAN_ROUNDS) + "轮激战中"
						this.StartCountTime(() => {
							let left_time = end_time - TimeUtil.getServerTime()
							if (left_time < 0) {
								this._box_tips.visible = false
								this._lb_count_down.visible = false
								this._img_count_down_bg.visible = false
								this.CancelCountTime()
								return
							}
							this._lb_count_down.text = String(left_time)
						}
						)
						break
				}
			} else {
				this.CancelCountTime()
				this._box_tips.visible = false
				this._lb_count_down.visible = false
				this._img_count_down_bg.visible = false
			}
		}
	}

	public StartCountTime(func?) {

		this.CancelCountTime()
		this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public CancelCountTime() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public SetRoleHead(img?, career?, picture_id?) {

		let picture_source = DressModel.GetInstance().getHeadICon(91, career)
		if (picture_id && String(picture_id).trim() != "") {
			picture_source = DressModel.GetInstance().getHeadICon(picture_id, career)
		}
		ResManager.GetInstance().SetImageSpriteTrans(this, img, GameResPath.GetIcon("head", picture_source))
	}

	public UpdateRecordRed() {

		let bool = this.diamond_fight_model.GetRecordRedState()
		this._img_record_red.visible = bool
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_img_title_bg: Laya.Image
	_img_instruction: Laya.Image
	_img_line0: Laya.Image
	_img_line1: Laya.Image
	_img_title: Laya.Image
	_box_line: Laya.Box
	_box_head: Laya.Box
	_box_role0: Laya.Box
	_img_default0: Laya.Image
	_img_head0: Laya.Image
	_img_name_bg0: Laya.Image
	_lb_name0: Laya.Label
	_box_role1: Laya.Box
	_img_default1: Laya.Image
	_img_head1: Laya.Image
	_img_name_bg1: Laya.Image
	_lb_name1: Laya.Label
	_box_role2: Laya.Box
	_img_default2: Laya.Image
	_img_head2: Laya.Image
	_img_name_bg2: Laya.Image
	_lb_name2: Laya.Label
	_box_role3: Laya.Box
	_img_default3: Laya.Image
	_img_head3: Laya.Image
	_img_name_bg3: Laya.Image
	_lb_name3: Laya.Label
	_box_role4: Laya.Box
	_img_default4: Laya.Image
	_img_head4: Laya.Image
	_img_name_bg4: Laya.Image
	_lb_name4: Laya.Label
	_box_role5: Laya.Box
	_img_default5: Laya.Image
	_img_head5: Laya.Image
	_img_name_bg5: Laya.Image
	_lb_name5: Laya.Label
	_box_role6: Laya.Box
	_img_default6: Laya.Image
	_img_head6: Laya.Image
	_img_name_bg6: Laya.Image
	_lb_name6: Laya.Label
	_box_role7: Laya.Box
	_img_default7: Laya.Image
	_img_head7: Laya.Image
	_img_name_bg7: Laya.Image
	_lb_name7: Laya.Label
	_box_role8: Laya.Box
	_img_default8: Laya.Image
	_img_head8: Laya.Image
	_img_name_bg8: Laya.Image
	_lb_name8: Laya.Label
	_box_role9: Laya.Box
	_img_default9: Laya.Image
	_img_head9: Laya.Image
	_img_name_bg9: Laya.Image
	_lb_name9: Laya.Label
	_box_role10: Laya.Box
	_img_default10: Laya.Image
	_img_head10: Laya.Image
	_img_name_bg10: Laya.Image
	_lb_name10: Laya.Label
	_box_role11: Laya.Box
	_img_default11: Laya.Image
	_img_head11: Laya.Image
	_img_name_bg011: Laya.Image
	_lb_name11: Laya.Label
	_box_role12: Laya.Box
	_img_default12: Laya.Image
	_img_head12: Laya.Image
	_img_name_bg12: Laya.Image
	_lb_name12: Laya.Label
	_box_role13: Laya.Box
	_img_default13: Laya.Image
	_img_head13: Laya.Image
	_img_name_bg13: Laya.Image
	_lb_name13: Laya.Label
	_box_role14: Laya.Box
	_img_default14: Laya.Image
	_img_head14: Laya.Image
	_img_name_bg14: Laya.Image
	_lb_name14: Laya.Label
	_box_role15: Laya.Box
	_img_default15: Laya.Image
	_img_head15: Laya.Image
	_img_name_bg15: Laya.Image
	_lb_name15: Laya.Label
	_box_top: Laya.Box
	_img_top_bg: Laya.Image
	_lb_top_name: Laya.Label
	_img_default_top: Laya.Image
	_img_top_head: Laya.Image
	_box_tips: Laya.Box
	_img_tips_bg: Laya.Image
	_lb_tips: Laya.Label
	_img_count_down_bg: Laya.Image
	_lb_count_down: Laya.Label
	_box_record: Laya.Box
	_img_record: Laya.Image
	_img_record_red: Laya.Image
	_img_return: Laya.Image
	_img_heart: Laya.Image
	_box_bet: Laya.Box
	_img_bet: Laya.Image
	_lb_bet: Laya.Label
	_gp_gamble_effect: Laya.Box
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._img_title_bg,
			this._img_instruction,
			this._img_line0,
			this._img_line1,
			this._img_title,
			this._box_line,
			this._box_head,
			this._box_role0,
			this._img_default0,
			this._img_head0,
			this._img_name_bg0,
			this._lb_name0,
			this._box_role1,
			this._img_default1,
			this._img_head1,
			this._img_name_bg1,
			this._lb_name1,
			this._box_role2,
			this._img_default2,
			this._img_head2,
			this._img_name_bg2,
			this._lb_name2,
			this._box_role3,
			this._img_default3,
			this._img_head3,
			this._img_name_bg3,
			this._lb_name3,
			this._box_role4,
			this._img_default4,
			this._img_head4,
			this._img_name_bg4,
			this._lb_name4,
			this._box_role5,
			this._img_default5,
			this._img_head5,
			this._img_name_bg5,
			this._lb_name5,
			this._box_role6,
			this._img_default6,
			this._img_head6,
			this._img_name_bg6,
			this._lb_name6,
			this._box_role7,
			this._img_default7,
			this._img_head7,
			this._img_name_bg7,
			this._lb_name7,
			this._box_role8,
			this._img_default8,
			this._img_head8,
			this._img_name_bg8,
			this._lb_name8,
			this._box_role9,
			this._img_default9,
			this._img_head9,
			this._img_name_bg9,
			this._lb_name9,
			this._box_role10,
			this._img_default10,
			this._img_head10,
			this._img_name_bg10,
			this._lb_name10,
			this._box_role11,
			this._img_default11,
			this._img_head11,
			this._img_name_bg011,
			this._lb_name11,
			this._box_role12,
			this._img_default12,
			this._img_head12,
			this._img_name_bg12,
			this._lb_name12,
			this._box_role13,
			this._img_default13,
			this._img_head13,
			this._img_name_bg13,
			this._lb_name13,
			this._box_role14,
			this._img_default14,
			this._img_head14,
			this._img_name_bg14,
			this._lb_name14,
			this._box_role15,
			this._img_default15,
			this._img_head15,
			this._img_name_bg15,
			this._lb_name15,
			this._box_top,
			this._img_top_bg,
			this._lb_top_name,
			this._img_default_top,
			this._img_top_head,
			this._box_tips,
			this._img_tips_bg,
			this._lb_tips,
			this._img_count_down_bg,
			this._lb_count_down,
			this._box_record,
			this._img_record,
			this._img_record_red,
			this._img_return,
			this._img_heart,
			this._box_bet,
			this._img_bet,
			this._lb_bet,
			this._gp_gamble_effect,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_img_title_bg",
				"_img_instruction",
				"_img_line0",
				"_img_line1",
				"_img_title",
				"_box_line",
				"_box_head",
				"_box_role0",
				"_img_default0",
				"_img_head0",
				"_img_name_bg0",
				"_lb_name0",
				"_box_role1",
				"_img_default1",
				"_img_head1",
				"_img_name_bg1",
				"_lb_name1",
				"_box_role2",
				"_img_default2",
				"_img_head2",
				"_img_name_bg2",
				"_lb_name2",
				"_box_role3",
				"_img_default3",
				"_img_head3",
				"_img_name_bg3",
				"_lb_name3",
				"_box_role4",
				"_img_default4",
				"_img_head4",
				"_img_name_bg4",
				"_lb_name4",
				"_box_role5",
				"_img_default5",
				"_img_head5",
				"_img_name_bg5",
				"_lb_name5",
				"_box_role6",
				"_img_default6",
				"_img_head6",
				"_img_name_bg6",
				"_lb_name6",
				"_box_role7",
				"_img_default7",
				"_img_head7",
				"_img_name_bg7",
				"_lb_name7",
				"_box_role8",
				"_img_default8",
				"_img_head8",
				"_img_name_bg8",
				"_lb_name8",
				"_box_role9",
				"_img_default9",
				"_img_head9",
				"_img_name_bg9",
				"_lb_name9",
				"_box_role10",
				"_img_default10",
				"_img_head10",
				"_img_name_bg10",
				"_lb_name10",
				"_box_role11",
				"_img_default11",
				"_img_head11",
				"_img_name_bg011",
				"_lb_name11",
				"_box_role12",
				"_img_default12",
				"_img_head12",
				"_img_name_bg12",
				"_lb_name12",
				"_box_role13",
				"_img_default13",
				"_img_head13",
				"_img_name_bg13",
				"_lb_name13",
				"_box_role14",
				"_img_default14",
				"_img_head14",
				"_img_name_bg14",
				"_lb_name14",
				"_box_role15",
				"_img_default15",
				"_img_head15",
				"_img_name_bg15",
				"_lb_name15",
				"_box_top",
				"_img_top_bg",
				"_lb_top_name",
				"_img_default_top",
				"_img_top_head",
				"_box_tips",
				"_img_tips_bg",
				"_lb_tips",
				"_img_count_down_bg",
				"_lb_count_down",
				"_box_record",
				"_img_record",
				"_img_record_red",
				"_img_return",
				"_img_heart",
				"_box_bet",
				"_img_bet",
				"_lb_bet",
				"_gp_gamble_effect",
			])
	}
}
window["DiamondFightBattleView"] = DiamondFightBattleView
