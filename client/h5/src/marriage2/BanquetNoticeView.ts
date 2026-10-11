import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { DressType } from "../commonModel/DressModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetHtmlCenter, Util } from "../util/Util"


export class BanquetNoticeView extends BaseView1 {

	GuestModel
	InitInfo
	InitView
	Local_Open
	MasterModel
	canEnter
	change_scene_close
	destroy_callback
	destroy_imm
	head1: CustomHeadItem
	head2: CustomHeadItem
	is_center
	manId
	modelType
	onePrice
	open_callback
	use_background

	public constructor() {
		super()


		this.base_file = "marriage2"
		this.layout_file = "BanquetNoticeView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.click_bg_toClose = true;
		this.preload_server_config = {
			"config_wedding_info": false
		}

		let ban_quet_model = BanquetModel.GetInstance()
		let local_BanqEvent = BanqEvent
		let local_TimeUtil = TimeUtil
		this.load_callback = () => {

			this.InitInfo()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	let csf = this.labelDisplay.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDeltaX(this.labelDisplay, 130)
			// 	this.labelDisplay.size = 20
			// 	this.labelDisplay.lineSpacing = 0.7
			// 	this.labelDisplay.verticalAlign = "top"
			// 	this.labelDisplay.textAlign = "center"
			// }
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			if (this.head1) {
				this.head1.DeleteMe()
				this.head1 = null
			}
			if (this.head2) {
				this.head2.DeleteMe()
				this.head2 = null
			}
			//this:ClearUIEffect(this.effectGp)
		}

		this.InitInfo = () => {
			if (!this.head1) {
				this.head1 = new CustomHeadItem(this.head1Box)
				this.head1.Load()
			}
			if (!this.head2) {
				this.head2 = new CustomHeadItem(this.head2Box)
				this.head2.Load()
			}
			this.InitView()
			ResManager.GetInstance().SetTexture(this, this.BG1, GameResPath.GetIcon("marriage2", "uijh_168"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, GameResPath.GetIcon("marriage2", "uijh_169"), true)

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.enterBtn, () => {
				if (this.modelType == 2) {
					// ban_quet_model.Fire(local_BanqEvent.OPEN_VIEW, "BanquetInviteView")
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetInviteView")
					this.Close()
				} else if (this.modelType == 1) {
					if (this.canEnter) {
						ban_quet_model.Fire(local_BanqEvent.REQUET_PROTO, 17263, "l", this.manId)//进入婚礼场景
						this.Close()
					} else {
						ban_quet_model.Fire(local_BanqEvent.REQUET_PROTO, 17257, "l", this.manId)//索要请柬
					}
				}
			}
				, this, true)

			Util.AddClickEvent(this.buyBtn, () => {
				if (!this.canEnter && this.manId) {
					ban_quet_model.Fire(BanqEvent.REQUET_PROTO, 17258, "l", this.manId)
				}
			}, this, true)

			this.BindEvent(ban_quet_model, local_BanqEvent.BANQUET_CALL, (scmd?) => {
				if (this.modelType == 1) {
					this.GuestModel()
				}
			}
			)
			this.BindEvent(ban_quet_model, local_BanqEvent.INVITE_VIEW_DATA, (scmd?) => {
				if (this.modelType == 2) {
					this.MasterModel()
				}
			}
			)
			this.BindEvent(ban_quet_model, local_BanqEvent.BANQ_START, () => {
				this.modelType = 1
				this.GuestModel()
			}
			)
			this.BindVar(ban_quet_model, "newApply", (value?) => {
				if (this.modelType == 2) {
					this.banqRed.visible = ban_quet_model.newApply
				}
			}
			)
		}

		this.MasterModel = () => {
			let info = ban_quet_model.InviteViewData
			if (info) {

				let time = "正在进行"
				if (local_TimeUtil.getServerTime() < info.wedding_time) {
					time = `将于${Util.HtmlColorTxt(local_TimeUtil.timeConversion(info.wedding_time, "MDhh:mm"), "'#d64251'")}准时举行`
				}

				//新郎
				this.head1.ExcuteCallback(() => {
					let my_arr = ban_quet_model.GetRoleHeadIconInfo(info["my_picture"])
					this.head1.SetData(info.my_role_id, Number(my_arr[1]), null, my_arr[0], info.my_picture_ver, null, null, null, null, true)
				})

				//新娘
				this.head2.ExcuteCallback(() => {
					let lover_arr = ban_quet_model.GetRoleHeadIconInfo(info["lover_picture"])
					this.head2.SetData(info.lover_role_id, Number(lover_arr[1]), null, lover_arr[0], info.lover_picture_ver, null, null, null, null, true)
				})


				this.name1.text = info.my_name
				this.name2.text = info.lover_name

				let wedding_info_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_info", false)

				this.tipsLabel.innerHTML = `${Util.HtmlColorTxt("您", "'#d64251'")}与${Util.HtmlColorTxt(info.lover_name, "'#d64251'")}的${wedding_info_cfg[info.wedding_type].wedding_name}<br/>${time}`;
				SetHtmlCenter(this.tipsLabel, { x: 0, w: this.tipsLabel.parent["width"] })
				this.tipsLabel.x = this.tipsLabel.x + 264 / 2;
			}
			this.banqRed.visible = ban_quet_model.newApply
			this.labelDisplay.text = "宾客管理"
		}

		

		this.GuestModel = () => {
			this.banqRed.visible = false
			let info = ban_quet_model.weddingInfo
			if (info) {
				let roleId = RoleManager.GetInstance().GetMainRoleId()
				let manInfo = info.man_list[0]
				let womanInfo = info.woman_list[0]
				let Info1 = manInfo
				let Info2 = womanInfo
				if (womanInfo.role_id == roleId) {
					Info1 = womanInfo
					Info2 = manInfo
				}


				//新浪的头像
				this.head1.ExcuteCallback(() => {
					let my_arr = ban_quet_model.GetRoleHeadIconInfo(Info2["picture"])
					this.head1.SetData(Info2.role_id, Number(my_arr[1]), null, my_arr[0], Info2.picture_ver, null, null, null, null, true)
				})

				//新娘头像
				this.head2.ExcuteCallback(() => {
					let lover_arr = ban_quet_model.GetRoleHeadIconInfo(Info1["picture"])
					this.head2.SetData(Info1.role_id, Number(lover_arr[1]), null, lover_arr[0], Info1.picture_ver, null, null, null, null, true)
				})


				// this.head1.ExcuteCallback(() => {
				// 	this.head1.SetData(Info2.role_id, null, null, Info2.picture, Info2.picture_ver, null, null, null, null, true)
				// })
				// this.head2.ExcuteCallback(() => {
				// 	this.head2.SetData(Info1.role_id, null, null, Info1.picture, Info1.picture_ver, null, null, null, null, true)
				// })
				this.name1.text = Info2.name
				this.name2.text = Info1.name

				this.manId = manInfo.role_id
				let str = null
				this.canEnter = false
				let start = false
				//this:ClearUIEffect(this.effectGp)
				let timeStr = "正在进行"
				if (info.start_time > local_TimeUtil.getServerTime()) {
					str = `将于${Util.HtmlColorTxt(local_TimeUtil.timeConversion(info.start_time, "MDhh:mm"), "'#d64251'")}准时举行`;
				} else {
					start = true
				}
				if (roleId == womanInfo.role_id || roleId == manInfo.role_id) {

					str = `${Util.HtmlColorTxt("您", "'#d64251'")}与${Util.HtmlColorTxt(Info2.name, "'#d64251'")}`

					this.canEnter = true
				} else {
					for (let _tmpi in info.guest_list) {
						var vo = info.guest_list[_tmpi]
						if (vo.role_id == roleId) {
							this.canEnter = true
						}
					}
					str = `${Util.HtmlColorTxt(manInfo.name, "'#d64251'")}与${Util.HtmlColorTxt(womanInfo.name, "'#d64251'")}`
				}
				if (this.canEnter) {
					if (start) {
						//this:AddUIEffect2("ui_button3", this.effectGp, null, {x=0.6, y=0.7}, true)
						this.labelDisplay.text = "立即入场"
					} else {
						this.labelDisplay.text = local_TimeUtil.timeConversion(info.start_time, "hh:MM") + "开启"
					}
				} else {
					this.labelDisplay.text = "索要请柬"
				}
				this.buyBtn.visible = !this.canEnter
				this.gp.visible = this.buyBtn.visible;
				if (!this.canEnter) {
					let price = MarriageModel.GetInstance().GetConstantData(21)
					price = price && JSON.parse(price)
					this.onePrice = price && price[0];
					let res = this.onePrice && this.onePrice[0] == "2" && "com_bind_diamond" || "com_diamond"
					ResManager.GetInstance().SetImageSprite(this, this.diam, "common_asset", res)
					this.price.text = this.onePrice && this.onePrice[2]
				}

				let wedding_info_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_info", false)
				// [ts2lua]wedding_info_cfg下标访问可能不正确
				this.tipsLabel.innerHTML = `${str}的${wedding_info_cfg[info.wedding_type].wedding_name}<br/>${timeStr}`;
				SetHtmlCenter(this.tipsLabel, { x: 0, w: this.tipsLabel.parent["width"] })
				this.tipsLabel.x = this.tipsLabel.x + 264 / 2;

			}
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				this.modelType = parms[0]
				if (parms[0] == 2) {
					ban_quet_model.Fire(local_BanqEvent.REQUET_PROTO, 17252)
				}
			}
			super.Open()
		}

		this.InitView = () => {
			this.tipsLabel.style.color = "#663915";
			this.tipsLabel.style.fontSize = 20;
			this.tipsLabel.style.leading = 6;
			this.tipsLabel.style.align = "center";

			if (this.modelType && this.is_loaded) {
				if (this.modelType == 1) {
					this.GuestModel()
				} else if (this.modelType == 2) {
					this.MasterModel()
				}
			}
		}


	}

	public Open(...new_args) {

		this.Local_Open(new_args)
	}





	_Image1: Laya.Image
	BG1: Laya.Image
	closeBtn: Laya.Image
	_Image2: Laya.Image
	head1Box: Laya.Box
	head2Box: Laya.Box
	name1: Laya.Label
	name2: Laya.Label
	_Image5: Laya.Image
	tipsLabel: Laya.HTMLDivElement
	effectGp: Laya.Box
	buyBtn: Laya.Image
	Text: Laya.Label
	gp: Laya.Box
	diam: Laya.Image
	price: Laya.Label
	enterBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	banqRed: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this.BG1,
			this.closeBtn,
			this._Image2,
			this.head1Box,
			this.head2Box,
			this.name1,
			this.name2,
			this._Image5,
			this.tipsLabel,
			this.effectGp,
			this.buyBtn,
			this.Text,
			this.gp,
			this.diam,
			this.price,
			this.enterBtn,
			this._Image11,
			this.labelDisplay,
			this.banqRed,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"BG1",
				"closeBtn",
				"_Image2",
				"head1Box",
				"head2Box",
				"name1",
				"name2",
				"_Image5",
				"tipsLabel",
				"effectGp",
				"buyBtn",
				"Text",
				"gp",
				"diam",
				"price",
				"enterBtn",
				"_Image11",
				"labelDisplay",
				"banqRed",
			])
	}
}
window["BanquetNoticeView"] = BanquetNoticeView