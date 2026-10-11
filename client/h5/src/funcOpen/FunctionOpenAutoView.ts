import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { MainUIController } from "../commonController/MainUIController"
import { DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { FunctionOpenModel, FunctionOpenEvent } from "../commonModel/FunctionOpenModel"
import { HolyTerritoryModel } from "../commonModel/HolyTerritoryModel"
import { MainFunc, MainUIModel } from "../commonModel/MainUIModel"
import { StoryModel } from "../commonModel/StoryModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, SetHtmlCenter, SetHtmlStyle, SetSizeDelta, Util } from "../util/Util"

export class FunctionOpenAutoView extends BaseView1 {

	LoadSuccess
	InitEvent
	SetFuncIcon
	StartTimer
	OnTime
	CancelTimer
	Local_Open
	is_skill
	public constructor() {
		super();
		this.base_file = "functionOpen";
		this.layout_file = "FunctionOpenAutoView";
		this.layer_value = Enum_UILayer.Activity;
		let model = FunctionOpenModel.GetInstance(),
			mainUI_controller = MainUIController.GetInstance(),
			mainUI_model: MainUIModel = MainUIModel.GetInstance(),

			local_FunctionOpenEvent = FunctionOpenEvent,
			layer_mgr = LayerManager.GetInstance(),
			local_Util = Util,
			data_,
			item_list_,
			close_time_,
			close_time_id_: Laya.Timer
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = false
		this.not_show_main_msg = true
		this.not_show_attr_main_msg = true
		this.append_to_ctl_queue = true;
		this.is_skill = false
		let voice
		this.preload_client_config = {
			"ConfigFunctionOpenIconTargertPos": false
		}

		this.load_callback = function () {
			this.LoadSuccess();
			this.InitEvent();
		}
		this.open_callback = function () {
			// console.log("------------FunctionOpenAutoView@open_callback")
			let story_model = StoryModel.GetInstance()
			if (story_model.main_ui_finger) {
				let obj = story_model.main_ui_finger && story_model.main_ui_finger.target_obj
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, obj, true)
			}
			StoryModel.ShowFingerLock[this.hashCode] = true
			SoundManager.GetInstance().PlaySoundEffect("double_box")
			this.SetFuncIcon()
		}
		this.close_callback = function () {
			delete StoryModel.ShowFingerLock[this.hashCode]
			if (data_) {
				let pos = this.icon.localToGlobal(new Laya.Point(0, 0))
				let target_pos
				if (this.is_skill) {
					let target_pos = mainUI_model.GetSkillIconPosInMainUIView(data_.id)
					if (!target_pos) {
						target_pos = mainUI_model.GetIconPosInMainUIView(2, MainFunc.Role, { x: 20, y: 0 }, { x: 20, y: 1 })
					}
					model.Fire(local_FunctionOpenEvent.FUNCTIONOPEN_ICON_FLY, data_.id, data_.icon, pos, target_pos, null, this.is_skill)
				} else if (data_.id == 283) {//圣域需要打开圣域界面
					HolyTerritoryModel.GetInstance().NeedShow = false
					let secView = mainUI_controller.main_ui_secondary_view
					if (secView) {
						target_pos = secView.GetIconPos(283) || { "x": 630, "y": 720 }
						model.Fire(local_FunctionOpenEvent.FUNCTIONOPEN_ICON_FLY, data_.id, data_.icon, pos, target_pos, () => {
							OpenFun.OpenFunHandler(78)
						}, this.is_skill)
					}
				} else if (data_.id == 46) {//挂机收益跳转到
					HolyTerritoryModel.GetInstance().NeedShow = false
					let secView = mainUI_controller.main_ui_secondary_view
					if (secView) {
						let btn = secView.exp_btn
						if (btn) {
							target_pos = btn.localToGlobal(new Laya.Point(0, 0))
						}
						else {
							target_pos = { "x": 630, "y": 720 }
						}
						model.Fire(local_FunctionOpenEvent.FUNCTIONOPEN_ICON_FLY, data_.id, data_.icon, pos, target_pos)
					}
				} else {
					let pos_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigFunctionOpenIconTargertPos", true)
					if (pos_cfg) {
						let cfg = pos_cfg[data_.id]
						if (cfg) {
							target_pos = mainUI_model.GetIconPosInMainUIView(Number(cfg.part), Number(cfg.mapping_icon_type))
							if (target_pos) {
								model.Fire(local_FunctionOpenEvent.FUNCTIONOPEN_ICON_FLY, data_.id, data_.icon, pos, target_pos, ()=>{
									if(data_.jump_id){
										OpenFun.OpenFunHandler(data_.jump_id)
									}
								}, this.is_skill)
							}else{
								if(data_.jump_id){
									OpenFun.OpenFunHandler(data_.jump_id)
								}
							}
						}
						else{
							if(data_.jump_id){
								OpenFun.OpenFunHandler(data_.jump_id)
							}
						}
					}
				}
				// model.StartFunctionOpenStory(data_.id)


			}
		}
		this.destroy_callback = function () {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}

			model.need_show_open_fun_data_cache = null
			if (item_list_) {
				for (let obj of item_list_) {
					obj.DeleteMe()
				}
			}
			item_list_ = null
			this.CancelTimer()
			//this.ClearUIEffect(this.effect)
		}
		this.LoadSuccess = () => {
			this.is_skill = data_.is_skill ? data_.is_skill : (data_.title_type && data_.title_type == 1) ? true : false
			//魂魔战场音效播放
			if (data_.dun_type && data_.dun_type == DUN_TYPE.Heart) {
				voice = CommonManager.GetInstance().PlayFightingVoice(2)
			}

			this._scroll.hScrollBar.visible = false
			this.click_bg.visible = false
			this.click_bg.width = layer_mgr.stageWidth
			this.click_bg.height = layer_mgr.stageHeight

			let title_type = this.is_skill ? "uignkq_zia" : "uignkq_zib"
			ResManager.GetInstance().SetImageSprite(this, this.title, "functionOpen", title_type, true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.star_bg, GameResPath.GetIcon("functionOpen", "uignkq_ditu"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this.skill_icon_bg, GameResPath.GetIcon("guild", "ui_role_35"))
			this.skill_icon_bg.visible = this.is_skill;
			let wh: number = this.is_skill ? 78 : 100;
			SetSizeDelta(this.icon, wh, wh);

		}


		this.InitEvent = () => {
			let close_fun = () => {
				if (data_ && data_.id != 283 && !this.is_skill) {
					model.Fire(local_FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, 13801, "hc", data_.id, 1)
				}
				this.Close()
			}
			local_Util.AddClickEvent(this.okBtn, close_fun, this, true)
			local_Util.AddClickEvent(this.click_bg, close_fun, this)
		}

		this.SetFuncIcon = () => {
			if (data_) {
				setTimeout(() => {
					if (!this.use_delete_method) {
						this.click_bg.visible = true
					}
				}, 500)
				close_time_ = 10

				if (this.is_skill) {
					ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetSkillIconPath(data_.icon))
				} else {
					ResManager.GetInstance().SetImageSprite(this, this.icon, "functionOpen", data_.icon)
					//ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetFuncOpenIconPath(data_.icon))
				}


				this.content_bg.visible = !this.is_skill;
				this.tips.y = !this.is_skill ? 275 : 139;
				this.skillLab.visible = this.is_skill;
				// this.tips.textFlow = Util.StrToHTML(`解锁<font color=0xb3ff48>${data_.name}</font>功能`)
				let html_width = this.is_skill ? 236 : 325;
				let base_x = this.is_skill ? -47 : -98;
				this.skillLab.text = data_.name;
				if (this.is_skill) {
					this.tips.style.fontSize = 16;
					this.tips.style.align = "center";
					this.tips.style.valign = "middle";
					this.tips.style.color = "#663915";
					this.tips.style.wordWrap = true;
					this.tips.style.leading = 8;
					this.tips.style.bold = true;
					this.tips.width = html_width;
				} else {
					this.tips.style.fontSize = 20;
					this.tips.style.align = "center";
					this.tips.style.valign = "middle";
					this.tips.style.color = "#ffffff";
					this.tips.style.wordWrap = true;
					this.tips.style.leading = 8;
					this.tips.style.bold = false;
					this.tips.width = html_width;
				}

				// this.tips.height = 28
				let index = local_Util.StrToHTML(`${data_.icon_open_text}`).indexOf("<br/>")
				if (index == -1) {
					index = local_Util.StrToHTML(`${data_.icon_open_text}`).indexOf("<br>")
				}
				if (index != -1) {
					this.content_bg.height = 70
					// this.tips.height = 56
				}
				this.tips.innerHTML = `${data_.icon_open_text}`
				this.tips.style.width = html_width
				SetHtmlCenter(this.tips, { "x": base_x, "w": html_width })
				if (item_list_) {
					for (let obj of item_list_) {
						obj.DeleteMe()
					}
				}
				// item_list_ = []
				// let goods_list = JSON.parse(data_.reward)
				// if (goods_list) {
				// 	let item: BaseAwardItem
				// 	for (let i = 0; i < goods_list.length; i++) {
				// 		item = item_list_[i]
				// 		if (!item) {
				// 			item = new BaseAwardItem(this.scroll_group)
				// 			item_list_[i] = item
				// 			item.Load()
				// 			item.SetScale(0.66)
				// 		}
				// 		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods_list[i][0], goods_list[i][1])
				// 		item.SetData(type_id, goods_list[i][2])
				// 	}
				// }
				//this.AddUIEffect("ui_deblocking_glow", this.effect, undefined, undefined, true)
				this.StartTimer()
			}
		}

		this.StartTimer = () => {
			this.CancelTimer()
			var peorid_func = () => {
				if (!this.use_delete_method) {
					this.OnTime()
				}
			}
			close_time_id_ = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, 0)
			peorid_func()
		}

		this.OnTime = () => {
			close_time_ = close_time_ - 1
			if (close_time_ <= 0) {
				this.CancelTimer()
				this.close_tip.text = ""
				if (data_) {
					model.Fire(local_FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, 13801, "hc", data_.id, 1)
				}
				this.Close()
			} else {
				// this.getBtn.label = `领取奖励(${close_time_}s)`
				this.close_tip.text = `点击任意位置关闭（${close_time_}s）`
			}
		}

		this.CancelTimer = () => {
			if (close_time_id_) {
				GlobalTimerQuest.CancelQuest(close_time_id_)
				close_time_id_ = null
			}
		}
		this.Local_Open = (parms) => {
			[data_] = parms
			super.Open()
		}
	}

	public Open(...parms) {
		this.Local_Open(parms)
	}


	click_bg: Laya.Box
	star_bg: Laya.Image
	title: Laya.Image
	icon_bg: Laya.Image
	effect: Laya.Box
	con: Laya.Box
	content_bg: Laya.Image
	tips: Laya.HTMLDivElement
	icon: Laya.Image
	skill_icon_bg: Laya.Image
	skill_icon: Laya.Box
	_scroll: Laya.Panel
	Content: Laya.HBox
	okBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	iconDisplay: Laya.Image
	close_tip: Laya.Label
	skillLab: Laya.Label
	public GetComponents() {
		[
			this.click_bg,
			this.star_bg,
			this.title,
			this.icon_bg,
			this.effect,
			this.con,
			this.content_bg,
			this.tips,
			this.icon,
			this.skill_icon_bg,
			this.skill_icon,
			this._scroll,
			this.Content,
			this.okBtn,
			this._Image1,
			this.labelDisplay,
			this.iconDisplay,
			this.close_tip,
			this.skillLab,
		]
			= this.GetChildrenByNames([

				"click_bg",
				"star_bg",
				"title",
				"icon_bg",
				"effect",
				"con",
				"content_bg",
				"tips",
				"icon",
				"skill_icon_bg",
				"skill_icon",
				"_scroll",
				"Content",
				"okBtn",
				"_Image1",
				"labelDisplay",
				"iconDisplay",
				"close_tip",
				"skillLab",
			])
	}
}
window["FunctionOpenAutoView"] = FunctionOpenAutoView