import { BaseItem1 } from "../common/BaseItem1"
import { Vector3 } from "../util/Vector3"
import { RefBoxChildsLayout, SetHtmlStyle, Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { SceneBaseType } from "../scene/SceneConfig"
import { Enum_UILayer } from "../common/LayerManager"
import { MarriageModel } from "../commonModel/MarriageModel"
import { GuildFightEvent } from "../commonModel/GuildFightModel"
import { GuildFightModel } from "../commonModel/GuildFightModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class CountryInfoView extends BaseItem1 {
	CancelTimer
	CreateModel
	Dispose
	InitEvent
	InitView
	SetTimer
	StartTimer
	TimerFunc
	UpdateView
	curType
	figure
	role_loaded_vo
	cfg_seacraft
	endTime
	timerId
	cur_days
	font_isload
	ClearModel
	cur_model_name
	public constructor(parent?) {
		super(parent)
		this.base_file = "country"
		this.layout_file = "CountryInfoView"
		this.preload_server_config = {
			"config_seacraft_camp": false
		}

		let rewardList = null
		let local_model = SeaHegemonyModel
		let local_modelIns = local_model.GetInstance()
		//let roleMgr = RoleManager.GetInstance()
		let marModel = MarriageModel.GetInstance()
		//let local_UI_MODEL_TYPE = UIModelClass.UI_MODEL_TYPE

		this.load_callback = () => {
			this.cur_model_name = ""
			let size=18
			SetHtmlStyle(this.seaLb, { c: "#663915", f: size, ww: false, w: 235 })
			SetHtmlStyle(this.kingLb, { c: "#663915", f: size, ww: false, w: 235 })
			SetHtmlStyle(this.guildLb, { c: "#663915", f: size, ww: false, w: 235 })
			SetHtmlStyle(this.fightLb, { c: "#663915", f: size, ww: false, w: 235 })
			SetHtmlStyle(this.peopleLb, { c: "#663915", f: size, ww: false, w: 235 })

			this.cur_days = null
			this.font_isload = false
			ResManager.GetInstance().LoadFont(this, "sea_day", this.timeLb3, 32, false, () => {
				this.font_isload = true
				this.SetTimer()
			});
			this.timeLb2.text = "0时0分0秒"
			this.cfg_seacraft = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_camp", false)
			this.InitView()
			this.InitEvent()
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("country", "ui_shzb_034"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIconOtherPath("country", "ui_shzb_035"), true)
			ResManager.GetInstance().SetImageSprite(this,this._bg_lable,"country","ui_shzb_013")
			ResManager.GetInstance().SetImageSprite(this,this._Image2,"country","ui_role_title_bg1")

			local_modelIns.Fire(local_model.REQUEST_PROTO, 18600)
			local_modelIns.Fire(local_model.REQUEST_PROTO, 18624)
			local_modelIns.Fire(local_model.REQUEST_PROTO, 18607)
		}

		this.InitView = () => {
			let data = local_modelIns.seaHegemonyData
			if (data) {
				this.CreateModel()
				if (!rewardList) {
					rewardList = []
				}
				this.UpdateView()
			}
			if (local_modelIns.hasJoinSea && (local_modelIns.StartTime != 0 || local_modelIns.hasFight)) {
				this.UnStartGp.visible = false
				this.StartGp.visible = true
				if (this.curType != 1) {
					local_modelIns.Fire(local_model.CHANGE_BG)
					this.curType = 1
				}
			} else {
				if (local_modelIns.IsOpenFight()) {
					this.timeLb2.text = "0时0分0秒"
				}
				this.UnStartGp.visible = true
				this.StartGp.visible = false
				if (local_modelIns.seaHegemonyData && local_modelIns.seaHegemonyData.camp != 0) {
					this.labelDisplay.text = "查看详情"
				} else {
					this.labelDisplay.text = "立即加入"
				}
				if (this.curType != 2) {
					local_modelIns.Fire(local_model.CHANGE_BG)
					this.curType = 2
				}
			}
			this.SetTimer()
		}

		this.UpdateView = () => {
			let data = local_modelIns.seaHegemonyData
			if (!data) {
				return
			}
			let campCfg = this.cfg_seacraft
			if (campCfg && campCfg[data.camp]) {
				this.seaLb.innerHTML = Util.StrToHTML("所在海域: <font color='#d15e00'>" + campCfg[data.camp].name + "</font>")
			}
			let kingStr = ((data.king_name && data.king_name != "") && ("S" + data.server_num + "." + data.king_name) || ("虚位以待"))
			this.kingLb.innerHTML = Util.StrToHTML("海域之王: <font color='#d15e00'>" + kingStr + "</font>")
			kingStr = ((data.guild_name && data.guild_name != "") && ("S" + data.server_num + "." + data.guild_name) || ("虚位以待"))
			this.guildLb.innerHTML = Util.StrToHTML("统治结社: <font color='#d15e00'>" + kingStr + "</font>")
			this.fightLb.innerHTML = Util.StrToHTML("海域战力: <font color='#d15e00'>" + data.fight + "</font>")
			this.peopleLb.innerHTML = Util.StrToHTML("海域人数: <font color='#d15e00'>" + data.count + "</font>")
			let camp = data.camp != 0 && data.camp || 1
			ResManager.GetInstance().SetImageSprite(this, this.seaIcon, "country", "ui_shzb_0" + (36 + camp))
			this.getRed.visible = data.reward_status == 0
			if (data && data.king_name && data.king_name != "") {
				GuildFightModel.GetInstance().Fire(GuildFightEvent.GUILDFIGHT_REQUEST_PROTO, 13014, "hlh", data.server_id, data.guild_id, 1862)
				this.noImg.visible = false
			} else {
				this.noImg.visible = true
				this.nameLb.text = "虚位以待"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.noImg, GameResPath.GetIconOtherPath("country", "uikf1vn_003"))
				ResManager.GetInstance().SetOutsideImageSprite(this, this.no_2, GameResPath.GetIconOtherPath("country", "ui_shzb_021"))
			}

		}


		this.CreateModel = (role_vo?) => {

			if (!role_vo) {
				return
			}
			if (this.role_loaded_vo && this.role_loaded_vo.name == role_vo.name) {
				return
			}
			this.role_loaded_vo = role_vo
			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
			let weapon_model_id = Util.GetWeaponClotheId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			let wing_id = Util.GetWingClotheId(role_vo)
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)
			let liveness_id = Util.GetLivenessId(role_vo)

			this.ClearModel()

			let data = {
				career: role_vo.career,
				sex: role_vo.sex,
				layer_value: this.layer_value,
				scale: 0.55,
				position: new Vector3(0, 1.2, 0),
				type: UI_MODEL_TYPE.MAINROLE,

				clothe_res_id: model_id,
				fashion_model_id: model_id,
				texture_id: texture_id,

				head_wear_id: head_id,
				head_clothe_id: head_texture_id,

				weapon_res_id: weapon_model_id,
				weapon_clothe_id: 0,
				
				wing_id: wing_id,
				back_ornament_id: back_ornament_id,
				liveness_id: liveness_id

			}
			ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
		}

		this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this.addBtn, () => {
					local_modelIns.Fire(local_model.OPEN_VIEW, "SeaListView")
				},
				this,
				true
			)
			Util.AddClickEvent(this.dsgtBtn, () => {
				local_modelIns.Fire(local_model.OPEN_VIEW, "SeaDsgtPreview")
			}
				, this, true)
			this.BindEvent(
				local_modelIns,
				local_model.START_DATA, () => {
					this.InitView()
				}
			)
			this.BindEvent(
				local_modelIns,
				local_model.UPDATE_SEA_INFO, () => {
					this.InitView()
				}
			)
			this.BindEvent(
				local_modelIns,
				local_model.UPDATE_SEA_INFO, () => {
					this.UpdateView()
				}
			)
			Util.AddClickEvent(
				this.privilegeBtn, () => {
					local_modelIns.Fire(local_model.OPEN_VIEW, "CountryPrivilegeView")
				},
				this,
				true
			)
			Util.AddClickEvent(
				this.payBtn, () => {
					local_modelIns.Fire(local_model.OPEN_VIEW, "CountryPayView")
				},
				this,
				true
			)
			Util.AddClickEvent(
				this.meritBtn, () => {
					local_modelIns.Fire(local_model.OPEN_VIEW, "CountryMeritView")
				},
				this,
				true
			)
			this.BindEvent(
				GuildFightModel.GetInstance(),
				GuildFightEvent.UPDATE_REQUEST_FIGURE, (scmd?) => {
					if (scmd.model_id != 1862) {
						return
					}
					this.figure = scmd.figure
					this.CreateModel(scmd.figure)
					this.nameLb.text = scmd.figure.name
				}
			)
		}

		this.Dispose = () => {
			this.ClearModel()
			this.CancelTimer()
			if (rewardList) {
				for (let _tmpi in rewardList) {
					var vo = rewardList[_tmpi]
					vo.DeleteMe()
				}
				rewardList = null
			}
			this.curType = null
			this.role_loaded_vo = null
		}

		this.SetTimer = () => {
			// start_time == 0 表示不是当天  TimeUtil.getServerTime() >= local_modelIns.StartInfo.end_time
			//console.log("__________________settimer", local_modelIns.StartInfo.start_time, local_modelIns.hasJoinSea, local_modelIns.hasFight)
			if ((local_modelIns.StartInfo.start_time == 0 || !local_modelIns.hasJoinSea) && !local_modelIns.hasFight) {
				let vo = local_modelIns.activeStartTime[1]
				//console.log("____________vo", vo, (vo && vo.start_time || -1))
				if (vo && vo.start_time && vo.start_time > TimeUtil.getServerTime()) {
					this.endTime = vo && vo.start_time || 0
					if (this.endTime > 0) {
						this.CancelTimer()
						this.StartTimer()
					}
				}
			}
		}

		this.StartTimer = () => {
			this.timerId = GlobalTimerQuest.AddPeriodQuest(() => {
				this.TimerFunc()
			}, 1)
			this.TimerFunc()
		}

		this.CancelTimer = () => {
			if (this.timerId) {
				GlobalTimerQuest.CancelQuest(this.timerId)
				this.timerId = null
			}
		}

		this.TimerFunc = () => {
			let time = this.endTime - TimeUtil.getServerTime()
			if (time > 0 && this.timeLb2) {
				let D = Math.floor(time / 60 / 60 / 24)
				let h = Math.floor(time / 60 / 60) % 24
				let m = Math.floor(time / 60) % 60
				let s = time % 60
				this.timeLb2.text = `${h}时${m}分${s}秒`

				if (this.font_isload && D != this.cur_days) {
					this.timeLb3.text = D + ""
					RefBoxChildsLayout(this._box_day, -5)
					this.cur_days = D
				}

				return true
			} else {
				this.UnStartGp.visible = false
				this.StartGp.visible = true
				this.CancelTimer()
			}
			return false
		}
	}

	public DeleteMe() {
		this.Dispose()
		super.DeleteMe()
	}



	UnStartGp: Laya.Box
	bg1: Laya.Image
	bg2: Laya.Image
	_bg_lable: Laya.Image
	_bg_lable2: Laya.Image
	_Image11: Laya.Image
	_Label1: Laya.Label
	addBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_start_tips: Laya.Image
	timeLb2: Laya.Label
	_box_day: Laya.Box
	timeLb3: Laya.Label
	_img_day: Laya.Image
	StartGp: Laya.Box
	modelGp: Laya.Box
	seaIcon: Laya.Image
	_Image2: Laya.Image
	_img_title: Laya.Image
	noImg: Laya.Image
	no_2: Laya.Image
	seaLb: Laya.HTMLDivElement
	kingLb: Laya.HTMLDivElement
	guildLb: Laya.HTMLDivElement
	fightLb: Laya.HTMLDivElement
	peopleLb: Laya.HTMLDivElement
	nameLb: Laya.Label
	_bg_btn: Laya.Image
	dsgtBtn: Laya.Image
	privilegeBtn: Laya.Image
	payBtn: Laya.Image
	meritBtn: Laya.Image
	getRed: Laya.Image
	public GetComponents() {
		[
			this.UnStartGp,
			this.bg1,
			this.bg2,
			this._bg_lable,
			this._bg_lable2,
			this._Image11,
			this._Label1,
			this.addBtn,
			this._Image111,
			this.labelDisplay,
			this._start_tips,
			this.timeLb2,
			this._box_day,
			this.timeLb3,
			this._img_day,
			this.StartGp,
			this.modelGp,
			this.seaIcon,
			this._Image2,
			this._img_title,
			this.noImg,
			this.no_2,
			this.seaLb,
			this.kingLb,
			this.guildLb,
			this.fightLb,
			this.peopleLb,
			this.nameLb,
			this._bg_btn,
			this.dsgtBtn,
			this.privilegeBtn,
			this.payBtn,
			this.meritBtn,
			this.getRed,
		]
			= this.GetChildrenByNames([

				"UnStartGp",
				"bg1",
				"bg2",
				"_bg_lable",
				"_bg_lable2",
				"_Image11",
				"_Label1",
				"addBtn",
				"_Image111",
				"labelDisplay",
				"_start_tips",
				"timeLb2",
				"_box_day",
				"timeLb3",
				"_img_day",
				"StartGp",
				"modelGp",
				"seaIcon",
				"_Image2",
				"_img_title",
				"noImg",
				"no_2",
				"seaLb",
				"kingLb",
				"guildLb",
				"fightLb",
				"peopleLb",
				"nameLb",
				"_bg_btn",
				"dsgtBtn",
				"privilegeBtn",
				"payBtn",
				"meritBtn",
				"getRed",
			])
	}
}
window["CountryInfoView"] = CountryInfoView