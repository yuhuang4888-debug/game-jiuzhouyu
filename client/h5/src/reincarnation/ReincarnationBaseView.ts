import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { TaskModel, TaskTipType, TaskType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionX, SetSizeDeltaX, Split, Color, SetSizeDeltaY, SetHtmlStyle } from "../util/Util"
import { ReincarnationSkillItem } from "./ReincarnationSkillItem"
import { GuardModel } from "../commonModel/GuardModel"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { ReincarnationTaskItem } from "./ReincarnationTaskItem"
import { Alert, Alert_Type } from "../alert/Alert"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ReincarnationDanTips } from "./ReincarnationDanTips"
import { DressModel } from "../commonModel/DressModel"
import { PlatformManager } from "../PlatformManager"

export class ReincarnationBaseView extends BaseItem1 {
	InitEvent
	InitView
	LoadSuccess
	SetPower
	SetPropStyle
	SetReinDownItem
	SetStage
	TipsClickFunc
	ClickFun

	equipItemList
	fashionImteList
	ShowGuardImage
	LayoutBox
	SetHtmlLoc

	private conf: any;
	private _item: BaseAwardItem;
	private taskVo: ITaskVo;
	private _id: string;
	private giftItem: GiftPushIcon;

	public constructor(parent?) {
		super(parent)
		this.equipItemList = [];
		this.fashionImteList = [];
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationBaseView"
		let local_roleVo = RoleManager.GetInstance()
		let res_mgr = ResManager.GetInstance()
		// let local_resMgr = lua_resM
		let reinModel = ReincarnationModel
		let local_reinmodel = reinModel.GetInstance()
		let local_wordMgr = WordManager
		let local_Erlang = ErlangParser.GetInstance()
		let local_taskmodel = TaskModel.GetInstance()
		let local_taskTipType = TaskTipType
		let local_openFunc = OpenFun
		let reinClientCfg_ = null
		let item_list_ = []
		let task_item_list_ = null
		let skill_list_ = []
		let prop_list_ = []
		let stage_prop_list_ = null
		let bottomItem_ = null
		let bottom_item_turn_ = null
		let bottom_item_list_ = [null, null, null, "ReincarnationFourView", "ReincarnationFiveView", "ReincarnationSixView", "ReincarnationSevenView"]
		let config_reincarnation_cfg
		let config_dress_up_cfg
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.curImage.fontSize = 20
				this.curImage.y = 4
				this.nextImage.fontSize = 20
				this.nextImage.y = 4
				this.arrow.pos(0, 0)
				this.arrow.width = 36
				this.arrow.height = 32
				let box:Laya.Box = this.arrow.parent as Laya.Box 
				if(box){
					box.width = 40
				}
			}
			this.LoadSuccess()
			this.InitEvent()
			// this.RegisterMask(this.itemMask)
		}

		this.DeleteMe = () => {
			if (skill_list_) {
				for (let index in skill_list_) {
					skill_list_[index].DeleteMe()
					skill_list_[index] = null
				}
				skill_list_ = null
			}
			if (bottomItem_) {
				bottomItem_.DeleteMe()
				bottomItem_ = null
			}
			if (task_item_list_) {
				for (let index in task_item_list_) {
					task_item_list_[index].DeleteMe()
					task_item_list_[index] = null
				}
				task_item_list_ = null
			}
			if (this.tipsLabel)
				this.tipsLabel.off(Laya.Event.LINK, this, this.ClickFun)
			if (this.giftItem) {
				this.giftItem.DeleteMe();
				this.giftItem = null;
			}
			if (this._item) {
				this._item.DeleteMe();
				this._item = null;
			}
			this.giftItem = null;
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			//this.item_group.mask = this.itemMask
			local_reinmodel.Fire(reinModel.UPDATE_CUR_REIN)
			res_mgr.SetOutsideImageSprite(this, this.leftBg, GameResPath.GetIcon("reincarnation", "uizs_042"), true)
			res_mgr.SetImageSprite(this, this._Image2, "reincarnation", "uizs_035", true)
			// res_mgr.SetOutsideImageSprite(this, this.taskLine, GameResPath.GetIcon("reincarnation", "uizs_line"), true)
			// res_mgr.SetOutsideImageSprite(this, this._Image4, GameResPath.GetIcon("reincarnation", "uizs_line"), true)
			res_mgr.SetImageSpriteTrans(this, this._Image6, GameResPath.GetIcon("reincarnation", "uizs_041"), true)
			res_mgr.SetOutsideImageSprite(this, this.grid_bg, GameResPath.GetIconJpg("reincarnation", "ui_task_bg"), true)

			reinClientCfg_ = Config.PRELOAD_CLIENT_CONFIG.ClientReincarnationPos
			config_reincarnation_cfg = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_cfg
			config_dress_up_cfg = Config.PRELOAD_SERVER_CONFIG.config_dress_up_cfg

			this._Scroller1.hScrollBar.visible = false
			this._Scroller2.hScrollBar.visible = false
			this._Scroller3.hScrollBar.visible = false
			this._Scroller4.hScrollBar.visible = false
			this.prop_scroller.vScrollBar.visible = false
			this.task_scroller.vScrollBar.visible = false

			if (reinClientCfg_) {
				this.InitView()
			}
			// this.RegisterMask(this.equipGroup)
			// this.RegisterMask(this.fashionGroup)

			this.ShowGiftIcon();

		}

		this.InitView = () => {
			if (!reinClientCfg_) {
				return
			}
			let career = local_roleVo.mainRoleInfo.career
			let sex = local_roleVo.mainRoleInfo.sex
			let turn = local_roleVo.mainRoleInfo.turn;

			this.rebirth_btn.x = turn <= 2 ? 419 : 550;
			this.stageBtn.x = turn <= 2 ? 419 : 550;
			this.rebirth_reddot.x = turn <= 2 ? 539 : 670;


			this.lock_text.style.fontSize = 20
			this.lock_text.style.color = "#663915"
			this.lock_text.style.width = 529
			this.lock_text.style.leading = 10
			this.lock_text.style.align = "center"

			if (local_reinmodel.GetCurTurn() > ReincarnationModel.MaxTurn) {
				this.lockGroup.visible = true
				this.lock_text.innerHTML = "当前已达最高转职等级"
				this.CallLater(() => {
					this.lock_text.x = Math.abs(this.lockGroup.width - this.lock_text.width) / 2
				})
				this.rebirth_btn.visible = false
				this.stageBtn.visible = false
				turn = 4
			}
			let key = career + "@" + sex + "@" + turn;
			this._id = key;
			let cfg = config_reincarnation_cfg[key];
			this.conf = cfg;
			let next_key = career + "@" + sex + "@" + (turn + 1)
			let next_cfg = config_reincarnation_cfg[next_key]
			let lv_next_key = career + "@" + sex + "@" + (turn + 2)
			let lv_next_cfg = config_reincarnation_cfg[lv_next_key]
			let clientCfg = reinClientCfg_[turn + 1]
			if (cfg && clientCfg) {
				if (local_reinmodel.GetCurTurn() > ReincarnationModel.MaxTurn) {
					let max_cfg = reinClientCfg_[ReincarnationModel.MaxTurn]
					if (max_cfg) {
						this.curImage.text = max_cfg.name_desc[career - 1]
					}
					// ResManager.GetInstance().SetImageSprite(this, this.curImage, "reincarnation_asset", "zszy_" + career + "_5", true)
					this.arrow.visible = false
					this.nextImage.visible = false
				} else {
					let name = ""
					if (turn == 0) {
						name = reinClientCfg_.normal_name[career - 1]
					} else {
						let now_cfg = reinClientCfg_[turn]
						if (now_cfg) {
							name = now_cfg.name_desc[career - 1]
						}
					}
					this.curImage.text = name
					// ResManager.GetInstance().SetImageSprite(this, this.curImage, "reincarnation_asset", "zszy_" + career + "_" + turn, true)
					let next = next_cfg && true || false
					this.arrow.visible = next
					this.nextImage.visible = next
					if (next) {
						name = ""
						let next_cfg = reinClientCfg_[turn + 1]
						if (next_cfg) {
							name = next_cfg.name_desc[career - 1]
						}
						this.nextImage.text = name
						// ResManager.GetInstance().SetImageSprite(this, this.nextImage, "reincarnation_asset", "zszy_" + career + "_" + (turn + 1), true)
					}
				}
				if (next_cfg) {
					let _picture_resource = DressModel.GetInstance().getHeadICon(next_cfg.icon)
					if (_picture_resource) {
						res_mgr.SetImageSpriteTrans(this, this.headImage, GameResPath.GetIcon("head", _picture_resource))
						// res_mgr.SetOutsideImageSprite(this, this.headImage, "resource/icon/head/" + picture_cfg.resource + ".png")
						// res_mgr.SetImageSprite(this, this.headImage, "head", _picture_resource)
						//res_mgr.SetOutsideImageSprite(this, this.headImage, GameResPath.GetHeadPath(picture_cfg.resource))
					}
				}
				this.turnGroup.refresh()
				//设置属性提升
				let str = ``
				if (next_cfg) {
					let next_attr = JSON.parse(next_cfg.attr)
					for (let i = 0; i < next_attr.length; i++) {
						if (i == next_attr.length - 1) {
							str += `${local_wordMgr.GetProperties(next_attr[i][0])}<font color='#ffdc90'>&nbsp;+${local_wordMgr.ConvertToPercentValue(next_attr[i][0], next_attr[i][1])}</font>`
						} else {
							str += `${local_wordMgr.GetProperties(next_attr[i][0])}<font color='#ffdc90'>&nbsp;+${local_wordMgr.ConvertToPercentValue(next_attr[i][0], next_attr[i][1])}</font><br/>`
						}
					}
				}
				this.propLabel.style.fontSize = 22
				this.propLabel.style.color = "#ffffff"
				this.propLabel.style.width = 173
				// this.propLabel.style.align = "center"
				this.propLabel.style.leading = 14
				this.propLabel.innerHTML = Util.StrToHTML(str)
				if (lv_next_cfg && (lv_next_cfg.full_lv == next_cfg.full_lv)) {
					this.lvTotalGroup.visible = false
					this.lvTotalGroup.removeSelf()
					this._Group1.refresh()
				} else if (next_cfg) {
					this.SetHtmlLoc(this.levelLabel)
					let str = ""
					str = next_cfg.full_lv > 370 ? ("神创" + (next_cfg.full_lv - 370)) : next_cfg.full_lv;
					
					if(clientCfg.up_lock_res && clientCfg.up_lock_res.length > 1){
						this.levelLabel.innerHTML = Util.StrToHTML("等级上限提升至<font color='#b3ff48'>" + str + "</font>级且解锁<font color='#b3ff48'>天赋</font>")
					}else{
						this.levelLabel.innerHTML = Util.StrToHTML("人物等级上限提升至<font color='#b3ff48'>" + str + "</font>级")
					}
					this.LayoutBox(this.lvTotalGroup)
					this.lvTotalGroup.visible = true
				}
				this.Content1111111.removeChildren()
				if(clientCfg.up_lock_res && clientCfg.up_lock_res.length > 0){
					for (let i = 0, len = clientCfg.up_lock_res.length; i < len; i++) {
						let img_name = clientCfg.up_lock_res[i];
						let img_com = new Laya.Image();
						img_com.width = img_com.height = 84;
						this.Content1111111.addChild(img_com);
						ResManager.GetInstance().SetImageSprite(this, img_com, "reincarnation", img_name);
					}
				}
				if (!skill_list_) {
					skill_list_ = []
				}
					this.SetHtmlLoc(this.skillLabel)
				this.skillLabel.innerHTML = Util.StrToHTML("主动技能强化<font color='#ffe82a'>【点击图标查看】</font>")
				this.LayoutBox(this.skillTotalGRoup)
				let turn_skill_list = JSON.parse(next_cfg.turn_skill)
				if (turn_skill_list.length > 0) {
					for (let i = 0; i < turn_skill_list.length && i < 2; i++) {
						let skill_item: ReincarnationSkillItem = skill_list_[i]
						if (!skill_item) {
							skill_item = new ReincarnationSkillItem(this.Content1111)
							skill_item.Load()
							skill_list_[i] = skill_item
						}
						skill_item.SetVisible(true)
						// skill_item.ExcuteCallback(() => {
						skill_item.SetUpSkillData(turn_skill_list[i])
						// })
					}
					this.skillTotalGRoup.visible = true
				} else {
					this.skillTotalGRoup.visible = false
					this.skillTotalGRoup.removeSelf()
					this._Group1.refresh()
				}
				for (let i = turn_skill_list.length; i < skill_list_.length; i++) {
					let skill_item = skill_list_[i]
					if (skill_item) {
						skill_item.SetVisible(false)
					}
				}
				let equipCfg = clientCfg.equipUnlock
				this.SetHtmlLoc(this.equipLabel)
				this.equipLabel.innerHTML = Util.StrToHTML(clientCfg.equipText)
				this.LayoutBox(this.equipTotalGroup)
				let showEquipCount = 0
				if (equipCfg && equipCfg.length > 0) {
					for (let i = 0; i < equipCfg.length; i++) {
						let equipData = GoodsModel.GetInstance().GetGoodsBasicByTypeId(equipCfg[i])
						if (!equipData || (equipData.sex && equipData.sex != local_roleVo.GetMainRoleVo().sex)) {
							continue
						}
						let equipItem = this.equipItemList[showEquipCount]
						if (!equipItem) {
							equipItem = new EquipmentItem(this.Content11)
							equipItem.Load()
							equipItem.SetScale(0.6)
							this.equipItemList[showEquipCount] = equipItem
						} else {
							equipItem.SetVisible(true)
						}
						equipItem.SetData(equipCfg[i])
						showEquipCount++
					}
					for (let i = showEquipCount; i < this.equipItemList.length; i++) {
						let equipItem = this.equipItemList[i]
						if (equipItem) {
							equipItem.SetVisible(false)
						}
					}
				}
				this.equipTotalGroup.visible = showEquipCount > 0
				this.SetHtmlLoc(this.fashionLabel)
				this.fashionLabel.innerHTML = Util.StrToHTML("解锁强力幻化形象<font color='#ffe82a'>【点击图标查看】</font>")
				this.LayoutBox(this.faTotalGroup)
				let fashionCfg = clientCfg.fashionUnlock
				if (fashionCfg && fashionCfg.length > 0) {
					for (let i = 0; i < fashionCfg.length; i++) {
						let fashionItem = this.fashionImteList[i]
						if (!fashionItem) {
							fashionItem = new BaseAwardItem(this.Content111111)
							fashionItem.Load()
							fashionItem.SetScale(0.6)
							this.fashionImteList[i] = fashionItem
						} else {
							fashionItem.SetVisible(true)
						}
						fashionItem.SetData(fashionCfg[i])
					}
					for (let i = fashionCfg.length; i < this.fashionImteList.length; i++) {
						let fashionItem = this.fashionImteList[i]
						if (fashionItem) {
							fashionItem.SetVisible(false)
						}
					}
					this.faTotalGroup.visible = true
				} else {
					this.faTotalGroup.visible = false
				}
			}
			this.SetReinDownItem()
		}

		this.SetHtmlLoc=(html:Laya.HTMLDivElement)=>{
			if(PlatformManager.IsEyouEnPlatform()){
				SetHtmlStyle(html,{f:20,c:"#ffffff",ww:true,w:400})
			}else{
				html.style.fontSize = 20
				html.style.color = "#ffffff"
				html.style.wordWrap = false
			}
		}
		this.LayoutBox=(box:Laya.Box)=>{
			if(PlatformManager.IsEyouEnPlatform()){
				let img:Laya.Image = box.getChildAt(0) as Laya.Image 
				let html:Laya.HTMLDivElement = box.getChildAt(1) as Laya.HTMLDivElement 
				let Panel:Laya.Panel = box.getChildAt(2) as Laya.Panel 
				html.style.width = 430
				img.height =html.contextHeight+8
				Panel.y = img.y +html.contextHeight+14
				box.height = Panel.y+Panel.height
				this.CallLater(()=>{
					if(this.use_delete_method)return
					this._Group1.refresh()
				})
			}
		}
		this.SetReinDownItem = (changePos?) => {
			this.SetStage()
			this.lock_text.style.fontSize = 20
			this.lock_text.style.color = "#663915"
			this.lock_text.style.width = 529
			this.lock_text.style.align = "center"

			this.tipsLabel.style.fontSize = 22
			this.tipsLabel.style.color = "#663915"
			this.tipsLabel.style.width = 481
			this.tipsLabel.style.leading = 8

			this.tipsLabel.innerHTML = ""
			if (local_reinmodel.GetCurTurn() > ReincarnationModel.MaxTurn) {
				this.item_group.visible = false
				this.lockGroup.visible = true
				this.lock_text.innerHTML = "当前已达最高转职等级"
				this.CallLater(() => {
					this.lock_text.x = Math.abs(this.lockGroup.width - this.lock_text.width) / 2
				})
				this.lock_img.visible = false
				this.taskGroup.visible = false
				this.taskLabel.text = "转职任务"
				// SetAnchoredPositionX(this.lock_text, 0)
				return
			}
			let unlock_lv = local_reinmodel.turn_level_list[local_reinmodel.GetCurTurn()]
			if (unlock_lv && local_roleVo.mainRoleInfo.level < unlock_lv) {
				// this.step_gp.visible = false
				this.lockGroup.visible = true
				let level = (unlock_lv > 370 && ("神创" + (unlock_lv - 370)) || (unlock_lv))

				this.lock_text.innerHTML = "人物达到<font color='#ff4f50'>" + level + "</font>级才能领取" + local_reinmodel.rein_content_list[local_reinmodel.GetCurTurn()] + "任务!<br>前往挑战【恶灵退治】可快速提升等级"
				this.CallLater(() => {
					this.lock_text.x = Math.abs(this.lockGroup.width - this.lock_text.width) / 2
				})
				this.taskLabel.text = "转职任务"

				this.rebirth_reddot.visible = false
				this.item_group.visible = false
				this.rebirth_btn.visible = false
				this.stageBtn.visible = false
				this.SetPropStyle(false)
				this.taskGroup.visible = false
				return
			} else {
				this.lockGroup.visible = false
				let item_class = bottom_item_list_[local_reinmodel.GetCurTurn() - 1]
				if (item_class) {
					this.grid_bg.visible = true
					// SetAnchoredPosition(this.tipsLabel, 37, 885)
					// SetAnchoredPositionX(this.rebirth_reddot, 670)
					// SetSizeDeltaX(this.tipsLabel, 400)

					this.stageBtn.visible = false
					this.taskGroup.visible = false
					this.item_group.visible = true
					Util.SetImageGray(this._Image111, false)
					this.rebirth_btn.visible = true
					this.rebirth_btn.mouseEnabled = true
					//this.tipsLabel.touchEnabled = true
					if (bottom_item_turn_ && bottom_item_turn_ != local_reinmodel.GetCurTurn()) {
						bottomItem_.DeleteMe()
						bottomItem_ = null
					}
					if (!bottomItem_) {
						bottomItem_ = new window[item_class](this.item_group)
						let label = this.taskLabel
						let setNameFunc = (str?) => {
							if (label) {
								label.text = str
							}
						}
						bottomItem_.setNameFunc = setNameFunc
						bottomItem_.Load()
						bottom_item_turn_ = local_reinmodel.GetCurTurn()
					} else {
						if (changePos) {
							bottomItem_.InitView()
						}
					}
					let turnLevel = 0
					let task_list = local_taskmodel.GetReincarnationTaskList()
					if (task_list && task_list[0]) {
						turnLevel = local_reinmodel.needStageList[task_list[0].task_id] || 0
					}
					let clientCfg = null
					let levelColor = local_roleVo.GetMainRoleVo().level >= turnLevel && "#0a953e" || "#ff4f50"
					if (reinClientCfg_) {
						clientCfg = reinClientCfg_[local_reinmodel.GetCurTurn()]
						let stageStr = null
						let isNotShop = false
						let curId = local_reinmodel.GetNextAwakenId()
						if (4 == local_reinmodel.GetCurTurn()) {
							stageStr = "点亮所有天命且达到370级"
						} else if (5 == local_reinmodel.GetCurTurn()) {
							stageStr = "点亮所有源力且达到520级"
						} else if (6 == local_reinmodel.GetCurTurn()) {
							stageStr = "点亮所有神域"
						} else if (7 == local_reinmodel.GetCurTurn()) {
							stageStr = "点亮所有命盘"
						}
						if (isNotShop) {
							this.tipsLabel.innerHTML = Util.StrToHTML(stageStr + "完成转职!该阶段转职材料只可通过野外挂机概率获得。")
						} else {
							this.tipsLabel.innerHTML = Util.StrToHTML(stageStr + "完成转职!" + clientCfg.tipsText)
						}

						this.tipsLabel.on(Laya.Event.LINK, this, this.ClickFun)
					}
				} else {
					this.grid_bg.visible = false
					this._box_guard.visible = false
					// SetAnchoredPosition(this.tipsLabel, 40, 857)
					// SetAnchoredPositionX(this.rebirth_reddot, 670)
					// SetSizeDeltaX(this.tipsLabel, 640)

					let task_list = local_taskmodel.GetReincarnationTaskList()
					if (local_reinmodel.GetCurTurn() < 4) {
						this.taskLabel.text = "转职任务"
					} else {
						this.taskLabel.text = "转职阶段" + local_reinmodel.GetCurStage() + "/" + local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()]
					}
					if (task_list) {
						if (!task_item_list_) {
							task_item_list_ = []
						}
						table.sort(task_list, (a?, b?) => {
							if (a && b) {
								return a.has_finish < b.has_finish
							} else {
								return false
							}
						})
						{ // 按钮进度状态
							let task: ITaskVo = task_list[0];
							this.taskVo = task_list[0];
							// 进度条
							let barW: number = (task.now_num / task.need_num) * 302
							this.barImg.width = barW > 302 ? 302 : barW;

							// 前往
							let state: boolean = local_reinmodel.GetCurTurn() < 4 && task.task_tips_type != 61 && task.has_finish == 0;
							// 前往挂机
							let state1: boolean = false;

							if (task.task_tips_type == TaskTipType.CollectMaterial) {
								this.keyAllBtn.visible = task.now_num < task.need_num;
								state1 = task.now_num < task.need_num && task.has_finish == 0;
							}
							this.goBtn.visible = state || state1; // 挂机获取
							this.goLab.text = this.keyAllBtn.visible && state1 ? '前往挂机' : '前往';

							let goRedState = false;
							if (task.task_tips_type == TaskTipType.CollectMaterial) {
								goRedState = true
							} else if (task.task_tips_type == TaskTipType.FinDungeon) {
								let cfg1 = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, task.id, false)
								if (cfg1 && cfg1.recommend_power) {
									goRedState = cfg1.recommend_power <= RoleManager.GetInstance().GetMainRoleVo().fighting
								}
							}
							this.goRed.visible = goRedState && state;
							this.RenderDan();

						}

						let i = 0
						if (i < task_list.length) {
							do {
								let task_item: ReincarnationTaskItem = task_item_list_[i]
								if (!task_item) {
									task_item = new ReincarnationTaskItem(this.Content)
									task_item_list_[i] = task_item
									task_item.Load()
								}
								task_item.SetVisible(true)
								let task_id = task_list[i].task_id
								let task_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_task.name, task_id, false)
								// let task_cfg = ConfigItemMgr.Instance.GetTaskData(task_id)  //Config:GetConfigVo(Config.ConfigHasDefaultValue.config_task.name, task_id, false)
								if (local_reinmodel.GetCurStage() == local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()] && local_reinmodel.GetCurTurn() < 4) {
									task_list[i]["show_boss_red"] = true
								} else {
									task_list[i]["show_boss_red"] = false
								}
								if (task_cfg) {
									task_item.SetData(task_list[i])
								}
								if (task_list[i].task_tips_type == local_taskTipType.CollectMaterial) {
									// let cfg = Config.Taskstagefuncdrop
									let cfg = Config.PRELOAD_SERVER_CONFIG.config_task_stage_func_drop
									if (cfg) {
										for (let key in cfg) {

											// [ts2lua]cfg下标访问可能不正确
											if (cfg[key].task_id == task_id) {
												// this.tipsLabel.style.fontSize = 22
												// this.tipsLabel.style.color = "#663915"
												this.tipsLabel.innerHTML = Util.StrToHTML("野外挂机<font color='#0a953e'>（包括离线）</font>击杀" + cfg[key].mon_lv + "级及以上怪物概率获得")
												break
											}
										}
									}
								} else if (task_list[i].task_tips_type == local_taskTipType.Outside_kill_lv) {
									// this.tipsLabel.style.fontSize = 22
									// this.tipsLabel.style.color = "#663915"
									this.tipsLabel.innerHTML = Util.StrToHTML("野外挂机<font color='#0a953e'>（包括离线）</font>击杀" + task_list[i].id + "级及以上怪物即可完成")
								} else if (task_list[i].task_tips_type == local_taskTipType.FinDungeon) {
									this._box_guard.visible = true
								}
								i = i + 1
							} while ((i < task_list.length))
						}

						let j = task_list.length
						if (j < task_item_list_.length) {
							do {
								let task_item = task_item_list_[j]
								if (task_item) {
									task_item.SetVisible(false)
								}
								j = j + 1
							} while ((j < task_item_list_.length))
						}
						let task_id = task_list[0].task_id
						let config_reincarnation_task_cfg = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_task_cfg
						let prop_cfg = config_reincarnation_task_cfg[task_id]
						// let prop_cfg = Config.Reincarnationtaskcfg[task_id]
						if (prop_cfg) {
							if (!stage_prop_list_) {
								stage_prop_list_ = []
							}
							let str = "阶段属性:"
							let prop_attr = JSON.parse(prop_cfg.attr)
							if (i < prop_attr.length) {
								let i = 0
								do {
									str = str + " " + local_wordMgr.GetProperties(prop_attr[i][0]) + ("<font color='#ffdc90'> + ") + prop_attr[i][1] + "</font>"
									i = i + 1
								} while ((i < prop_attr.length))
							}
							this.taskPropLabel.style.fontSize = 22
							this.taskPropLabel.style.color = "#663915"
							this.taskPropLabel.style.width = 648
							this.taskPropLabel.innerHTML = Util.StrToHTML(str)
							if (prop_attr.length > 0) {
								this.SetPropStyle(true)
							} else {
								this.SetPropStyle(false)
							}
						}
					}
					if (local_reinmodel.GetCurStage() < local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()]) {
						this.stageBtn.visible = true
						this.rebirth_btn.visible = false
					} else {
						this.stageBtn.visible = false
						this.rebirth_btn.visible = true
					}
				}
				let img = this._Image1
				let lb = this.labelDisplay
				lb.strokeColor = ColorUtil.TryParseHtmlString("#2f999f")
				let res = "com_rect_btn11"
				let needLv
				let task_list = local_taskmodel.GetReincarnationTaskList()
				if (task_list) {
					needLv = local_reinmodel.needStageList[task_list[0].task_id]
				}
				if (local_reinmodel.IsFinishRein() && (!needLv || (needLv && local_roleVo.mainRoleInfo.level >= needLv))) {
					Util.SetImageGray(img, false)
					this.rebirth_reddot.visible = true
					this.labelDisplay.text = "突破"
				} else if (local_reinmodel.GetCurStage() < local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()] && local_reinmodel.IsFinishStageTask()) {
					Util.SetImageGray(this._Image11, false)
					this.rebirth_reddot.visible = true
					this.labelDisplay.text = "提交任务"
				} else if (local_reinmodel.GetCurTurn() >= 4) {
					res = "com_rect_btn6"
					lb.strokeColor = "#ffffff"
					if (needLv && local_roleVo.mainRoleInfo.level < needLv) {
						//this.labelDisplay.text = needLv + "级可转职"
						this.rebirth_btn.mouseEnabled = true
					} else {
						this.rebirth_btn.mouseEnabled = false
					}
					this.labelDisplay.text = "突破"
					Util.SetImageGray(this._Image1, true)
					this.rebirth_reddot.visible = false
				} else {
					if (local_reinmodel.GetCurStage() == local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()]) {
						this.labelDisplay.text = "突破"
					} else {
						this.labelDisplay.text = "获取材料"
					}
					Util.SetImageGray(this._Image11, true)
					Util.SetImageGray(img, true)
					lb.strokeColor = Color(0, 0, 0, 0)
					this.rebirth_reddot.visible = false
				}
				img.skin = `resource/game/common/texture/${res}.png`
			}

			if (this.keyAllBtn.visible) {
				this.rebirth_btn.visible = false;
				this.stageBtn.visible = false;
			}


		}

		this.ClickFun = (prams, x, y) => {
			let argsList = Split(prams, "@")
			if (argsList && argsList.length > 0) {
				if (argsList[3]) {
					argsList[3] = Number(argsList[3])
				}
				OpenFun.OpenFunHandler(argsList[0], argsList[1], argsList[2], argsList[3])
			}
		}

		this.InitEvent = () => {
			let OnReinBtnClick = () => {
				if (local_reinmodel.IsFinishRein() || (local_reinmodel.GetCurStage() < local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()] && local_reinmodel.IsFinishStageTask())) {
					local_reinmodel.Fire(reinModel.STAR_REIN)
				} else if (local_reinmodel.GetCurTurn() < 4) {
					if (local_reinmodel.GetCurStage() < local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()]) {
						Message.show("完成任务后才可进行提交")
					} else {
						Message.show("成功挑战转职副本后方可转职")
					}
				} else {
					let task_list = local_taskmodel.GetReincarnationTaskList()
					let roleLv = local_roleVo.GetMainRoleVo().level
					let finishLv = task_list && task_list[0] && local_reinmodel.needStageList[task_list[0].task_id]
					if ((task_list && task_list[0]) && task_list[0].task_tips_type == local_taskTipType.FinDungeon) {
						this.task_model.DoTask(task_list[0])
					} else if (finishLv && roleLv < finishLv) {
						Message.show(finishLv + "级可转职")
					} else {
						//let curId = local_reinmodel.GetNextAwakenId()
						//let turn = local_reinmodel.GetCurTurn()
						//if (((turn == 5 && curId >= 11) && curId <= 15 || (turn == 6 && curId >= 26) && curId <= 30) || (curId >= 46 && curId <= 50) && turn == 7 ) {
						//local_openFunc.OpenFunHandler(77)
						//}else{
						local_openFunc.OpenFunHandler(26)
						//}
					}
				}
			}
			Util.AddClickEvent(this.rebirth_btn, OnReinBtnClick, this, true)
			Util.AddClickEvent(this.stageBtn, OnReinBtnClick, this, true)

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			let UpDateBottom = (changePos?) => {
				if (this.use_delete_method) {
					return
				}
				this.SetReinDownItem(changePos)
			}
			this.BindEvent(local_reinmodel, reinModel.UPDATE_AWAKEN_CELL, UpDateBottom)
			this.BindVar(local_roleVo.GetMainRoleVo(), "turn_stage", UpDateBottom)
			this.BindEvent(local_taskmodel, TaskModel.UPDATE_REINCARNATION_TASK_LIST, UpDateBottom)

			let UpdateView = () => {
				this.InitView()
			}
			this.BindEvent(local_reinmodel, reinModel.UPDATE_TURN_VIEW, UpdateView)

			Util.AddClickEvent(this.lock_img, () => {
				local_openFunc.OpenFunHandler(7)
			}, this, true)

			//this.tipsLabel.addEventListener(Laya.TextEvent.LINK, this.TipsClickFunc, this)

			let update_fighting = () => {
				this.SetPower()
			}
			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "fighting", update_fighting)

			this.ShowGuardImage()
			this.BindEvent(GuardModel.GetInstance(), GuardModel.UPDATA_VIEW, () => {
				this.ShowGuardImage()
			})

			Util.AddClickEvent(this._box_guard, () => {
				GuardModel.GetInstance().Fire(GuardModel.OPEN_VIEW, 2)
			}, this, true)


			let local_taskModel = TaskModel
			let local_taskModelIns = local_taskModel.GetInstance()
			Util.AddClickEvent(this.keyAllBtn, () => {
				let taskVo = this.taskVo
				if (taskVo && taskVo.task_tips_type == 61) {
					if (taskVo.now_num < taskVo.need_num) {
						let goodsPriceCfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price
						if (goodsPriceCfg && goodsPriceCfg[taskVo.id]) {
							let needMoney = (taskVo.need_num - taskVo.now_num) * goodsPriceCfg[taskVo.id].price
							let content = ""
							content = "当前拥有" + taskVo.now_num + "个材料"
							Alert.Show("是否消耗<font color='#0a953e'>" + needMoney + "勾玉</font>", Alert_Type.Three, () => {
								local_taskModelIns.Fire(local_taskModel.REQUEST_CCMD_EVENT, 30006, taskVo.task_id, taskVo.id, taskVo.need_num)
							}
								, null, null, null, null, null, null, null, null, "resource/game/common/texture/com_diamond.png", "补足材料完成任务？", null, content)
						}
					}
				}
			}, this, true)


			Util.AddClickEvent(this.goBtn, () => {
				if (this.keyAllBtn.visible) { // 前往挂机
					local_taskModelIns.now_do_task_type = TaskType.REINCARNATION
					OpenFun.OpenFunHandler(77)
				} else { // 前往
					GlobalEventSystem.Fire(EventName.CLOSE_REINCARNATION_ENTER_VIEW)
					local_taskModelIns.now_do_task_type = TaskType.REINCARNATION
					local_taskModelIns.DoTask(this.taskVo, true)
				}

			}, this, true)

			// 打开转生丹界面
			Util.AddClickEvent(this.danBox, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, ReincarnationDanTips._layout_file, this._id);
			}, this)


		}

		this.SetPropStyle = (bool?) => {
			if (bool) {
				this.taskPropLabel.visible = true
				// SetAnchoredPositionY(this.taskLine, -64)
				SetSizeDeltaY(this.taskItemScroller, 215)
			} else {
				this.taskPropLabel.visible = false
				// SetAnchoredPositionY(this.taskLine, -64)
				SetSizeDeltaY(this.taskItemScroller, 200)
			}
		}

		this.SetStage = () => {
			if (local_reinmodel.GetCurTurn() < 4) {
				this.tipsLabel.visible = false
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientRebirthEffect
				let turn_num = local_reinmodel.GetCurTurn()
				let career = local_roleVo.GetMainRoleVo().career
				let step = local_reinmodel.GetCurStage()
				let all_step = local_reinmodel.rein_turn_stage_list[local_reinmodel.GetCurTurn()]
				// SetAnchoredPositionX(this.rebirth_reddot, 670)

				this.strategy_gp.visible = true
				// this.step_gp.visible = true
				if (cfg) {
					this.SetPower()
				}
				let step_num = null
				if (local_reinmodel.IsFinishRein()) {
					step_num = step
				} else {
					step_num = step - 1
				}
				if (step_num > all_step) {
					step_num = all_step
				}
				this.step_lb.text = step_num + "/" + all_step
				let width = 387
				SetSizeDeltaX(this.full_img, step_num / all_step * width)
				//this.full_img.width = step_num / all_step * width

				//this.taskItemScroller.top = 90
				// this.task_name_gp.visible = true
				this.task_name_lb.text = local_wordMgr.NumConvertStage(local_reinmodel.GetCurTurn()) + "转任务"
			} else {
				this.strategy_gp.visible = false
				// this.step_gp.visible = false
				//this.taskItemScroller.top = 50
				// this.task_name_gp.visible = false
			}
		}

		this.SetPower = () => {
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientRebirthEffect
			let turn_num = local_reinmodel.GetCurTurn()
			let career = local_roleVo.GetMainRoleVo().career
			let step = local_reinmodel.GetCurStage()
			let cur_power = RoleManager.GetInstance().GetMainRoleVo().fighting
			if (turn_num < 4 && cfg[turn_num + "@" + career] && cfg[turn_num + "@" + career].condition) {
				this.strategy_lb.style.fontSize = 20
				this.strategy_lb.style.color = "#663915"
				this.strategy_lb.style.leading = 10
				this.strategy_lb.style.width = 400

				if (step == 3) {
					let tasklist = local_taskmodel.GetReincarnationTaskList()
					let need_power = cfg[turn_num + "@" + career].dun_power
					if (tasklist && tasklist[0]) {
						let dungeonId = tasklist[0].id
						// let cfg1 = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dungeonId, false, Config.Dungeon)
						let cfg1 = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dungeonId, false)
						if (cfg1 && cfg1.recommend_power) {
							need_power = cfg1.recommend_power
						}
					}
					let color = (cur_power >= (need_power || 0)) && "'#0a953e'" || "'#ff4f50'"

					this.strategy_lb.innerHTML = Util.StrToHTML(cfg[turn_num + "@" + career].condition[step - 1] + "<br/>推荐战力:<font color=" + color + ">" + cur_power + "/" + need_power + "</font>")
				} else {
					if (step > 0) {
						this.strategy_lb.innerHTML = cfg[turn_num + "@" + career].condition[step - 1]
					}
				}
				if(PlatformManager.IsEyouPlatform()){
					this.strategy_lb.style.leading = 0.1
					this.strategy_lb.style.width = 436
				}
			}
		}
		this.ShowGuardImage = () => {
			let bool = false
			let magic_circle_lv = 2
			let open = GuardModel.GetInstance().OpenStatus(magic_circle_lv)
			if (!open) {
				return
			}
			let [type1, type2] = GuardModel.GetInstance().GetGuardActiveType()
			bool = type2 != null
			Util.SetImageGray(this._img_guard, !bool)
			if (!bool) {
				type2 = 2
				ResManager.GetInstance().SetImageSprite(this, this._img_guard, "reincarnation", "guard" + type2 + "_1", true)
			} else {
			}
		}
	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eZhuangSheng));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}

			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eZhuangSheng, 0);
			});

		}
		this.giftIcon.visible = bool;
	}


	private RenderDan() {
		if (!this._item) {
			this._item = new BaseAwardItem(this.iconBox);
			this._item.Load();
		}
		this._item.SetItemSize(128, 128);
		this._item.SetShowTips(false);
		this._item.SetItembgVisible(false);
		this._item.SetShowEffect(false);
		if (!this.conf) {
			return;
		}
		let json_data = JSON.parse(this.conf.turn_cost)
		let data: any
		if(json_data && json_data[0]){
			data = json_data[0]
		}
		if(!data) return
		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1]);
		let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		if (goods_vo) {
			this._item.SetData(goods_vo.type_id);
			this.iconNameLab.text = goods_vo.goods_name;
			let goodsNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(goods_vo.type_id)
			this.numLab.text = `${goodsNum}/${data[2]}`;
			let color: string = ColorUtil.GetReplaceChar((goodsNum >= data[2] ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.GOLDEN));
			this.numLab.color = color;
			this.danRedImg.visible = goodsNum >= data[2];
		}
	}

	_Image1111: Laya.Image
	bottom_scroller: Laya.Panel
	Content11111: Laya.Box
	task_scroller: Laya.Panel
	Content111: Laya.VBox
	_Image2: Laya.Image
	taskLabel: Laya.Label
	itemMask: Laya.Image
	item_group: Laya.Box
	grid_bg: Laya.Image
	taskGroup: Laya.Box
	strategy_gp: Laya.Box
	_Label1: Laya.Label
	strategy_lb: Laya.HTMLDivElement
	taskItemScroller: Laya.Panel
	Content: Laya.VBox
	taskPropLabel: Laya.HTMLDivElement
	task_name_gp: Laya.Box
	_Image5: Laya.Image
	task_name_lb: Laya.Label
	iconBox: Laya.Box
	iconNameLab: Laya.Label
	numLab: Laya.Label
	barBox: Laya.Box
	barImg: Laya.Image
	barNumLab: Laya.Label
	goBtn: Laya.Box
	goLab: Laya.Label
	headImage: Laya.Image
	leftBg: Laya.Image
	prop_scroller: Laya.Panel
	Content1: Laya.Box
	propLabel: Laya.HTMLDivElement
	_Image6: Laya.Image
	turnGroup: Laya.HBox
	curImage: Laya.Label
	arrow: Laya.Image
	nextImage: Laya.Label
	_Group1: Laya.VBox
	lvTotalGroup: Laya.Box
	_Image7: Laya.Image
	levelLabel: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content1111111: Laya.Box
	skillTotalGRoup: Laya.Box
	_Image9: Laya.Image
	skillLabel: Laya.HTMLDivElement
	_Scroller2: Laya.Panel
	Content1111: Laya.HBox
	equipTotalGroup: Laya.Box
	_Image10: Laya.Image
	equipLabel: Laya.HTMLDivElement
	_Scroller3: Laya.Panel
	Content11: Laya.HBox
	faTotalGroup: Laya.Box
	_Image111: Laya.Image
	fashionLabel: Laya.HTMLDivElement
	_Scroller4: Laya.Panel
	Content111111: Laya.HBox
	tipsLabel: Laya.HTMLDivElement
	_Label2: Laya.Label
	lockGroup: Laya.Box
	lock_img: Laya.Image
	lock_text: Laya.HTMLDivElement
	step_gp: Laya.Box
	_Group2: Laya.Box
	_Image13: Laya.Image
	full_img: Laya.Image
	step_lb: Laya.Label
	keyAllBtn: Laya.Box
	stageBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	rebirth_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	rebirth_reddot: Laya.Image
	_box_guard: Laya.Box
	_img_guard: Laya.Image
	giftIcon: Laya.Box
	keyRed: Laya.Image
	goRed: Laya.Image
	danBox: Laya.Box
	danRedImg: Laya.Image
	public GetComponents() {
		[
			this._Image1111,
			this.bottom_scroller,
			this.Content11111,
			this.task_scroller,
			this.Content111,
			this._Image2,
			this.taskLabel,
			this.itemMask,
			this.item_group,
			this.grid_bg,
			this.taskGroup,
			this.strategy_gp,
			this._Label1,
			this.strategy_lb,
			this.taskItemScroller,
			this.Content,
			this.taskPropLabel,
			this.task_name_gp,
			this._Image5,
			this.task_name_lb,
			this.iconBox,
			this.iconNameLab,
			this.numLab,
			this.barBox,
			this.barImg,
			this.barNumLab,
			this.goBtn,
			this.goLab,
			this.headImage,
			this.leftBg,
			this.prop_scroller,
			this.Content1,
			this.propLabel,
			this._Image6,
			this.turnGroup,
			this.curImage,
			this.arrow,
			this.nextImage,
			this._Group1,
			this.lvTotalGroup,
			this._Image7,
			this.levelLabel,
			this._Scroller1,
			this.Content1111111,
			this.skillTotalGRoup,
			this._Image9,
			this.skillLabel,
			this._Scroller2,
			this.Content1111,
			this.equipTotalGroup,
			this._Image10,
			this.equipLabel,
			this._Scroller3,
			this.Content11,
			this.faTotalGroup,
			this._Image111,
			this.fashionLabel,
			this._Scroller4,
			this.Content111111,
			this.tipsLabel,
			this._Label2,
			this.lockGroup,
			this.lock_img,
			this.lock_text,
			this.step_gp,
			this._Group2,
			this._Image13,
			this.full_img,
			this.step_lb,
			this.keyAllBtn,
			this.stageBtn,
			this._Image11,
			this.labelDisplay1,
			this.rebirth_btn,
			this._Image1,
			this.labelDisplay,
			this.rebirth_reddot,
			this._box_guard,
			this._img_guard,
			this.giftIcon,
			this.keyRed,
			this.goRed,
			this.danBox,
			this.danRedImg,
		]
			= this.GetChildrenByNames([

				"_Image1111",
				"bottom_scroller",
				"Content11111",
				"task_scroller",
				"Content111",
				"_Image2",
				"taskLabel",
				"itemMask",
				"item_group",
				"grid_bg",
				"taskGroup",
				"strategy_gp",
				"_Label1",
				"strategy_lb",
				"taskItemScroller",
				"Content",
				"taskPropLabel",
				"task_name_gp",
				"_Image5",
				"task_name_lb",
				"iconBox",
				"iconNameLab",
				"numLab",
				"barBox",
				"barImg",
				"barNumLab",
				"goBtn",
				"goLab",
				"headImage",
				"leftBg",
				"prop_scroller",
				"Content1",
				"propLabel",
				"_Image6",
				"turnGroup",
				"curImage",
				"arrow",
				"nextImage",
				"_Group1",
				"lvTotalGroup",
				"_Image7",
				"levelLabel",
				"_Scroller1",
				"Content1111111",
				"skillTotalGRoup",
				"_Image9",
				"skillLabel",
				"_Scroller2",
				"Content1111",
				"equipTotalGroup",
				"_Image10",
				"equipLabel",
				"_Scroller3",
				"Content11",
				"faTotalGroup",
				"_Image111",
				"fashionLabel",
				"_Scroller4",
				"Content111111",
				"tipsLabel",
				"_Label2",
				"lockGroup",
				"lock_img",
				"lock_text",
				"step_gp",
				"_Group2",
				"_Image13",
				"full_img",
				"step_lb",
				"keyAllBtn",
				"stageBtn",
				"_Image11",
				"labelDisplay1",
				"rebirth_btn",
				"_Image1",
				"labelDisplay",
				"rebirth_reddot",
				"_box_guard",
				"_img_guard",
				"giftIcon",
				"goRed",
				"keyRed",
				"danBox",
				"danRedImg",
			])
	}
}
window["ReincarnationBaseView"] = ReincarnationBaseView