import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Status } from "../util/Status"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, SetHtmlStyle } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { Config } from "../common/Config"
import { RoleManager } from "../commonModel/RoleManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

//1vn主界面
export class Kf1vnEnterView extends BaseItem1 {

	count_time_id_
	end_time_
	is_last_str_
	king_role_data
	last_click_time
	model
	now_str_
	time_style_
	role_model_
	public constructor(parent?) {
		super(parent)

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnEnterView"
		this.model = Kf1vnModel.GetInstance()
		this.count_time_id_ = null
		this.now_str_ = null
		this.end_time_ = null
		this.time_style_ = null
		this.is_last_str_ = null
		this.role_model_ = null
		this.last_click_time = null

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public DeleteMe() {

		this.CancelTimer()
		if (this.role_model_) {
			this.role_model_.DeleteMe()
			this.role_model_ = null
		}
		this.ClearUIEffect(this.btn_effect)
		this.last_click_time = null
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
		super.DeleteMe()
	}

	public LoadSuccess() {
		SetHtmlStyle(this.open_state, { f: 20, c: "#00fa64", w: 461, ww: false })
		SetHtmlStyle(this.rules, { f: 20, c: "#ffffff", w: 655, lh: 35 })
		this._Scroller1.vScrollBarSkin = ""
		ResManager.GetInstance().SetOutsideImageSprite(this, this.title_icon, GameResPath.GetIcon("kf1vn", "uikf1vn_004"))
		ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("kf1vn", "uikf1vn_005"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.empty_tag, GameResPath.GetIcon("kf1vn", "uikf1vn_003"))
		this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62136, "c", 0)
		this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62101)
		this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62133)
	}

	public InitEvents() {

		let shop_fun = () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnShopView",0)
		}
		Util.AddClickEvent(this.shopBtn, shop_fun, this, true)

		let rank_fun = () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnRankView")
		}
		Util.AddClickEvent(this.rankBtn, rank_fun, this, true)

		let rewardBtn_fun = () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "Kf1vnRewardView")
		}
		Util.AddClickEvent(this.rewardBtn, rewardBtn_fun, this, true)

		let enterBtn_fun = () => {
			if (!this.last_click_time || Status.NowTime - this.last_click_time > 0.5) {
				if (this.model.stage_info) {
					if (this.model.stage_info.stage == 1) {
						if (!this.model.page_info || this.model.page_info.is_sign == 0) {
							this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62102)
						} else {
							Message.show("已报名")
						}
					} else if (this.model.stage_info.stage >= 2 && this.model.stage_info.stage < 6) {
						this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62103)
					} else {
						Message.show("不在报名时间内")
					}
				}
				this.last_click_time = Status.NowTime
			}
		}
		Util.AddClickEvent(this.enterBtnGroup, enterBtn_fun, this, true)

		let stage_change_fun = (key?, value?) => {
			this.SetActivityState()
		}
		this.BindVar(this.model, "rank_info_in_waiting_scene", stage_change_fun)

		let page_change_fun = (key?, value?) => {
			this.SetEnterBtnState()
		}
		this.BindVar(this.model, "page_info", page_change_fun)

		let stage_info_change_fun = (key?, value?) => {
			this.SetActivityState()
		}
		this.BindVar(this.model, "stage_info", stage_info_change_fun)

		let figure_fun = (scmd13013?) => {
			if (scmd13013.module_id == 621) {
				this.SetKingData(scmd13013)
			}
		}
		this.BindEvent(GlobalEventSystem, EventName.GET_ROLE_FIGURE_INFO_RETURN, figure_fun)

		let update_shop_red_dot = () => {
			this.ShowShopBtnDot()
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, update_shop_red_dot)
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, update_shop_red_dot)
		this.BindVar(this.model, "quiz_history", update_shop_red_dot)

		this.SetData()
	}

	//设置数据
	public SetData() {

		if (!this.is_loaded) {
			return
		}
		this.SetInstruction()
		this.SetActivityState()
		this.SetEnterBtnState()
		this.SetDefaultView()
		this.ShowShopBtnDot()
	}

	public SetInstruction() {

		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigInstruction
		let str = ""
		if (cfg && cfg[621]) {
			let tmp = cfg[621]
			if (tmp && tmp[0]) {
				let list = tmp[0].content["item_List"]
				let str_list = list[0].item_content
				if (str_list) {
					let i = 0
					do {
						str = str + str_list[i] + "<br>"
						i = i + 1
					} while ((i < str_list.length))
				}
			}
		}
		this.rules.innerHTML = Util.StrToHTML(str)
		this.rules.style.width = 655
	}

	//按钮状态
	public SetActivityState() {


		if (this.model.stage_info) {
			if (this.model.stage_info.stage == 0) {
				let timeCfg = Config.PRELOAD_SERVER_CONFIG.config_kf_1vn_time[1].open_week
				let day_index = Number(timeCfg.slice(3, timeCfg.length - 2))//Number(string.sub(timeCfg, 3, timeCfg.length - 2))
				let server_time = TimeUtil.GetZoneTime()
				let date = new Date(server_time * 1000)
				let weekday = date.getDay()
				if (weekday == 0) {
					weekday = 7
				}
				//let day = 7 + day_index - weekday % 7
				let day = day_index - weekday % 7
				if (day < 0) {
					day = day + 7
				}
				let rTime = day * 86400 + 86400 - date.getHours() * 3600 - date.getMinutes() * 60 - date.getSeconds()
				this.StartTimer("休战倒计时：", rTime + server_time, "dd-hh-mm")
			} else if (this.model.stage_info.stage == 1) {
				this.StartTimer("剩余报名时间：", this.model.stage_info.edtime, "hh:MM:ss")
			} else if (this.model.stage_info.stage == 2) {
				this.StartTimer("后开启资格赛", this.model.stage_info.edtime, "hh:MM:ss", true)
			} else if (this.model.stage_info.stage == 3) {
				this.StartTimer("当前阶段：资格赛进行中 ", this.model.stage_info.edtime, "hh:MM:ss")
			} else if (this.model.stage_info.stage == 4) {
				this.StartTimer("后开启擂台赛", this.model.stage_info.edtime, "hh:MM:ss", true)
			} else if (this.model.stage_info.stage == 5) {
				this.StartTimer("当前阶段：擂台赛进行中 ", this.model.stage_info.edtime, "hh:MM:ss")
			} else if (this.model.stage_info.stage == 6) {
				this.CancelTimer()
				this.open_state.innerHTML = "活动已结束"
			}
		}
	}

	public SetEnterBtnState() {

		if (!this.is_loaded) {
			return
		}
		this.ClearUIEffect(this.btn_effect)
		this._reddot.visible=false
		if (this.model.stage_info && this.model.page_info) {
			if (this.model.stage_info.stage == 0) {
				this.btn_text.text = "报名参加"
				Util.SetImageGray(this.enterBtnGroup, true)
			} else if (this.model.stage_info.stage == 1) {
				this._reddot.visible=this.model.page_info.is_sign != 1
				this.btn_text.text = (this.model.page_info.is_sign == 1 && ("已报名") || ("报名参加"))
				Util.SetImageGray(this.enterBtnGroup, (this.model.page_info.is_sign == 1))
			} else if (this.model.stage_info.stage >= 2 && this.model.stage_info.stage < 6) {
				this.btn_text.text = "进入战场"
				Util.SetImageGray(this.enterBtnGroup, false)

				//this.AddUIEffect("ui_button1_1", this.btn_effect, { x: 0, y: 0 }, 1, true)
			}
		}
	}

	public StartTimer(str?, end_time?, time_style?, is_last_str?) {

		this.CancelTimer()
		this.now_str_ = str
		this.end_time_ = end_time
		this.time_style_ = time_style
		this.is_last_str_ = is_last_str

		let time_fun = () => {
			this.OnTime()
		}
		this.count_time_id_ = GlobalTimerQuest.AddPeriodQuest(time_fun, 1, -1)
		this.OnTime()
	}

	public OnTime() {

		if (this.end_time_) {
			let left_time = this.end_time_ - TimeUtil.getServerTime()
			if (left_time <= 0) {
				this.CancelTimer()
				this.open_state.innerHTML = ""
			} else {
				if (!this.is_last_str_) {
					this.open_state.innerHTML = Util.StrToHTML(this.now_str_ + "<font color='#00fa64'>" + TimeUtil.timeConvert(left_time, this.time_style_) + "</font>")
				} else {
					this.open_state.innerHTML = Util.StrToHTML("<font color='#00fa64'>" + TimeUtil.timeConvert(left_time, this.time_style_) + "</font>" + this.now_str_)
				}
			}
		} else {
			this.CancelTimer()
		}
	}

	public CancelTimer() {

		if (this.count_time_id_) {
			GlobalTimerQuest.CancelQuest(this.count_time_id_)
			this.count_time_id_ = null
		}
	}

	public SetDefaultView() {

		this.role_name.visible = this._sever_name.visible = false
		this.empty_tag.visible = true
		this.roleCon.visible = false
		this.empty_tag3.visible = true
	}

	public SetKingData(role_data?) {

		if (!this.is_loaded) {
			return
		}
		this.king_role_data = role_data
		if (role_data) {
			this.empty_tag3.visible = false
			this.role_name.visible = this._sever_name.visible = true
			this._sever_name.text = `S${role_data.player_num}`
			this.role_name.text = role_data.name
			this.empty_tag.visible = false
			this.roleCon.visible = true
			this.CreateModel(role_data)
		}
	}

	//最强王者模型数据
	public CreateModel(vo?) {
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
		// let mainVo = RoleManager.GetInstance().GetMainRoleVo()
		// let [role_res, role_color] = mainVo.GetRoleClotheTextureId(vo)
		// let cloth_res_id = Util.GetRoleClotheId(vo)
		// let weapon_model_id, weapon_texture_id = Util.GetWeaponClotheId(vo)
		// let wing_res = mainVo.GetFigureId(vo.figure_list, FigureProtoVo.FigureType.Wing)
		// let horse_res = mainVo.GetFigureId(vo.figure_list, FigureProtoVo.FigureType.Horse)

		let mainvo=RoleManager.GetInstance().GetMainRoleVo()
		let [head_id, head_texture_id] = Util.GetRoleHeadId(vo)
		// let head_res =Util.GetRoleHeadId(vo)
		let [role_res, role_color] = Util. GetRoleClotheId(vo)
		let weapon_res = Util.GetWeaponClotheId(vo)
		let wing_res = Util.GetWingClotheId(vo)//mainvo.GetFigureId(this.vo.figure_list, FigureProtoVo.FigureType.Wing)
		let horse_res = mainvo.GetFigureId(FigureProtoVo.FigureType.Horse)
		let back_ornament_res = Util.GetBackOrnamentId(vo);

		let data = {
			career: vo.career,
			sex: vo.sex,
			type: UI_MODEL_TYPE.MAINROLE,
			layer_value: Enum_UILayer.UI,
			clothe_res_id: role_res,
			fashion_model_id: role_res,
			texture_id: role_color,
			head_wear_id: head_id,
			head_clothe_id: head_texture_id,
			weapon_res_id: weapon_res,
			weapon_clothe_id: 0,
			wing_id: wing_res,
			horse_id: horse_res,
			position: new Vector3(0, 0, 0),
			scale: 1,
			back_ornament_id : back_ornament_res,
		}
		ResManager.GetInstance().SetRoleModel(this, this.roleCon, data)
		let offY = 0
		//SetLocalPositionY(this.roleCon, this.modelY_ + offY)
	}

	//商店红点
	public ShowShopBtnDot() {

		this.shop_dot.visible = this.model.HaveQuizRewardCanGet() || this.model.ShopRedDot()
	}



stone:Laya.Image
empty_tag:Laya.Image
empty_tag2:Laya.Image
roleCon:Laya.Box
_Image1:Laya.Image
_Image1_1:Laya.Image
nane_conta:Laya.Box
_Image2:Laya.Image
role_name:Laya.Label
_sever_name:Laya.Label
empty_tag3:Laya.Image
title_icon:Laya.Image
shopBtn:Laya.Box
_Image3:Laya.Image
_Image4:Laya.Image
_Label1:Laya.Label
shop_dot:Laya.Image
rankBtn:Laya.Box
_Image5:Laya.Image
_Image6:Laya.Image
_Label2:Laya.Label
rewardBtn:Laya.Box
_Image7:Laya.Image
_Image8:Laya.Image
_Label3:Laya.Label
_Image9:Laya.Image
_Label4:Laya.Label
open_state:Laya.HTMLDivElement
_Scroller1:Laya.Panel
rules:Laya.HTMLDivElement
_Image10:Laya.Image
enterBtnGroup:Laya.Box
_Image1_btn:Laya.Image
btn_text:Laya.Label
btn_effect:Laya.Box
_reddot:Laya.Image
public GetComponents() {
[
this.stone,
this.empty_tag,
this.empty_tag2,
this.roleCon,
this._Image1,
this._Image1_1,
this.nane_conta,
this._Image2,
this.role_name,
this._sever_name,
this.empty_tag3,
this.title_icon,
this.shopBtn,
this._Image3,
this._Image4,
this._Label1,
this.shop_dot,
this.rankBtn,
this._Image5,
this._Image6,
this._Label2,
this.rewardBtn,
this._Image7,
this._Image8,
this._Label3,
this._Image9,
this._Label4,
this.open_state,
this._Scroller1,
this.rules,
this._Image10,
this.enterBtnGroup,
this._Image1_btn,
this.btn_text,
this.btn_effect,
this._reddot,
]
 = this.GetChildrenByNames([

"stone",
"empty_tag",
"empty_tag2",
"roleCon",
"_Image1",
"_Image1_1",
"nane_conta",
"_Image2",
"role_name",
"_sever_name",
"empty_tag3",
"title_icon",
"shopBtn",
"_Image3",
"_Image4",
"_Label1",
"shop_dot",
"rankBtn",
"_Image5",
"_Image6",
"_Label2",
"rewardBtn",
"_Image7",
"_Image8",
"_Label3",
"_Image9",
"_Label4",
"open_state",
"_Scroller1",
"rules",
"_Image10",
"enterBtnGroup",
"_Image1_btn",
"btn_text",
"btn_effect",
"_reddot",
])
}
}
 window["Kf1vnEnterView"]= Kf1vnEnterView