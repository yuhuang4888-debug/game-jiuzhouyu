import { BaseItem1 } from "../common/BaseItem1"
import { CommonManager } from "../common/CommonManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RuneSelectMatView } from "../composite/RuneSelectMatView"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, Util, GlobalTimerQuest } from "../util/Util"

export class DungeonShowView extends BaseItem1 {
	_img_title: Laya.Image
	_gp_time: Laya.Box
	_img_font: Laya.Image
	_lb_time: Laya.Label
	_img_bg: Laya.Image
	_gp_desc: Laya.Box
	_lb_desc: Laya.HTMLDivElement
	_Group1: Laya.HBox
	_Image111: Laya.Image
	_lb_desc2: Laya.HTMLDivElement
	gp: Laya.HBox
	_btn_partner: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_1:Laya.Image
	_img_2:Laya.Image
	CustomMehod
	InitEvent
	LoadSuccess
	LocalDeleteMe
	SetBtn
	SetBtnList
	onTime
	removeTimer
	showTime
	updateView

	public constructor(parent?) {
		super(parent)


		this.base_file = "dungeonShow"
		this.layout_file = "DungeonShowView"
		let _model = BaseDungeonModel.GetInstance()
		let local_BaseDungeonModel = BaseDungeonModel
		let local_OpenFun = OpenFun

		let custom_activity_model = CustomActivityModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let _type_ = null
		let _sub_type_ = null
		let show_id_ = null
		let timer_ = null
		let time_ = 0
		let show_metiral = false
		let show_partner = false
		let condition = null
		let str_ = ""
		this.preload_client_config={
			"ConfigCustomActivityView":false,
			"ConfigDungeonTime":false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_desc.size  = 18
			// 	this._lb_desc.lineSpacing = 0.8
			// 	SetAnchoredPositionX(this._lb_time,112)
			// }
		}

		this.CustomMehod = (index?, args?) => {
			if (_type_ == null) {
				_type_ = args.base_type
				_sub_type_ = args.sub_type
				show_id_ = args.show_id
				condition = args.condition

			}
		}

		this.SetBtnList = (condition?) => {
			let list = ErlangParser.GetInstance().Parse(condition)[0]
			if (list[0] == "types") {
				for (let key in list[1]) {

					// [ts2lua]list[1]下标访问可能不正确
					let info = list[1][key]
					if (37 == Number(info[0])) {
						show_partner = true
					} else if (2 == Number(info[0]) || 18 == Number(info[0])) {
						show_metiral = true
					}
				}
			}
			this.SetBtn()
		}
		this.SetBtn = () => {
			this._btn_partner.visible = show_partner
			this._btn.visible = show_metiral
			if (show_metiral) {
				this.labelDisplay.text = "立即前往"
			}
			// LayoutRebuilder(this.gp)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn, () => {
				if (_type_ == local_BaseDungeonModel.MORE_ACTIVITY) {
					local_OpenFun.OpenFunHandler(53)
				} else {
					let open = CommonManager.GetInstance().CheckFuncOpenState("DungeonExpEnterView", false)
					if (open) {
						local_OpenFun.OpenFunHandler(7)
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_partner, () => {
				if (CommonManager.GetInstance().CheckFuncOpenState("DungeonPartnerView", true)) {
					local_OpenFun.OpenFunHandler(190)
				} else {
					Message.show("请先唤醒神巫开启神巫副本")
				}
			}
				, this, true)
			this.BindEvent(_model, local_BaseDungeonModel.DUNGON_ACTIVITY_UPDATE, (base_type?) => {
				if (base_type == _type_) {
					this.showTime()
				}
			}
			)
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this,this._img_bg,GameResPath.GetIcon("dungeonShow","uisbcl_001"))
			let cfg = this.preload_client_config["ConfigCustomActivityView"] //ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg) {
				let view_name = "DungeonShowView"
				if (_type_ == local_BaseDungeonModel.MORE_ACTIVITY) {
					view_name = "DungeonShowView1"

					// ResManager.GetInstance().SetImageSprite(this, this._Image1, "dungeonshow_asset", "uisbjy_02")
				}
				//custom_activity_model:LoadCompontRes(this, cfg, view_name, show_id_)
			}

			if (_type_ == local_BaseDungeonModel.MORE_ACTIVITY) {
				this.SetBtnList(condition)
			}

			// if(_type_==16){
				this._img_1.visible=true
				this._img_2.visible=true
			// }

			custom_activity_model.CloseACTRed(_type_, _sub_type_)
			this.showTime()
			this.updateView()
		}

		this.updateView = () => {
			if(_type_==16){
				this._lb_desc.width=360
			}else{
				this._lb_desc.width=340
			}

			let dungeon_time_cfg = this.preload_client_config["ConfigDungeonTime"]// ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigDungeonTime", true)
			let activity = _model.activity_Config(_type_, show_id_, dungeon_time_cfg)
			if (activity) {
				this._lb_desc.innerHTML = Util.StrToHTML(activity.desc)
				this._lb_desc2.innerHTML = Util.StrToHTML(activity.desc2)
			}
			this._lb_desc.x=205-this._lb_desc.contextWidth/2
			this._lb_desc.y=this._gp_desc.height/2-this._lb_desc.contextHeight/2
			// LayoutRebuilder(this._Group1)
		}

		this.showTime = () => {
			let activity = custom_activity_model.GetActInfo(_type_, _sub_type_)
			let act_info = custom_activity_model.GetActInfoByType(_type_)
			if (act_info) {
				activity = custom_activity_model.GetActInfo(_type_, act_info.sub_type)
			}
			if (!activity) {
				return
			}
			let [time, state] = _model.showActivityTime(activity)
			// [ts2lua]lua中0和空字符串也是true，此处state == 1需要确认
			// let source = state == 1 && "uisbjy_03" || "uisbjy_07"

			// ResManager.GetInstance().SetImageSprite(this, this._img_font, "dungeonShow_asset", source, true)
			time_ = time + local_TimeUtil.getServerTime()
			if (!timer_) {

				timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTime()
				}, 1)
			}
			this.onTime()
		}

		this.onTime = () => {
			let ltime = time_ - local_TimeUtil.getServerTime()
			let str = _model.convertTime(ltime)
			this._lb_time.text = str
			if (ltime <= 0) {
				this.removeTimer()
			}
		}

		this.removeTimer = () => {
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null
			}

		}

		this.LocalDeleteMe = () => {
			this.removeTimer()
			_type_ = null
		}


	}


	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_title,
			this._gp_time,
			this._img_font,
			this._lb_time,
			this._img_bg,
			this._gp_desc,
			this._lb_desc,
			this._Group1,
			this._Image111,
			this._lb_desc2,
			this.gp,
			this._btn_partner,
			this._Image11,
			this.labelDisplay1,
			this._btn,
			this._Image1,
			this.labelDisplay,
			this._img_1,
			this._img_2
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_gp_time",
				"_img_font",
				"_lb_time",
				"_img_bg",
				"_gp_desc",
				"_lb_desc",
				"_Group1",
				"_Image111",
				"_lb_desc2",
				"gp",
				"_btn_partner",
				"_Image11",
				"labelDisplay1",
				"_btn",
				"_Image1",
				"labelDisplay",
				"_img_1",
				"_img_2"
			])
		this._lb_desc.style.fontSize=20
		this._lb_desc.style.color="#ffffff"
		this._lb_desc.style.valign="middle"
		this._lb_desc.style.align="center"
		this._lb_desc.style.leading=10
		this._lb_desc2.style.fontSize=20
		this._lb_desc2.style.color="##b3ff48"
	}
}
window["DungeonShowView"] = DungeonShowView