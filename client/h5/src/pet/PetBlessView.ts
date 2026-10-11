import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { Util, SetSizeDeltaX, GetSizeDeltaX, GlobalTimerQuest, GetSizeDeltaY, LoadLuaConfigAB } from "../util/Util";

export class PetBlessView extends BaseView1 {

	bg: Laya.Image
	bg2: Laya.Image
	bg3: Laya.Image
	bg4: Laya.Image
	closeBtn: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	expImg: Laya.Image
	effectGp: Laya.Box
	_Label1: Laya.Label
	expLb: Laya.Label
	timeLb: Laya.HTMLDivElement
	_Label2: Laya.Label
	_Label3: Laya.Label
	cancelBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	enterBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	_Scroller1: Laya.Panel
	tipsGp: Laya.Box

	InitText
	SetLabel
	ClearTimer
	StartTimer
	LoadSuccess

	_Open

	public constructor() {
		super()

		this.base_file = "pet"
		this.layout_file = "PetBlessView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true

		let local_resMgr = ResManager.GetInstance()
		let local_util = Util
		let local_laya = Laya
		let local_timeUtil = TimeUtil,
			blessTimer_,
			data_,
			endTime_

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			data_ = null
			this.ClearTimer()
		}

		this.preload_client_config = {
			"ConfigInstruction": false
		}
		this.preload_server_config = {
			"config_mount_star": false
		}

		this.LoadSuccess = () => {
			if (data_) {
				this.StartTimer()
			}
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this.enterBtn, () => {
				GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.cancelBtn, () => {
				this.Close()
			}, this, true)

			local_resMgr.SetImageSprite(this, this.bg,"pet", "uisy_023")
			local_resMgr.SetTexture(this, this.bg2, GameResPath.GetIconJpg("pet", "uizfz_004"))
			local_resMgr.SetTexture(this, this.bg3, GameResPath.GetIcon("pet", "uizfz_002"))
			local_resMgr.SetTexture(this, this.bg4, GameResPath.GetIcon("pet", "uizfz_002"))
		}

		this._Open = (...parms) => {
			data_ = parms[0]
			if (data_) {
				if (this.is_loaded) {
					this.StartTimer()
				}
			}

		}

		this.StartTimer = () => {
			endTime_ = data_.etime
			let MaxCfg = local_resMgr.GetGameConfigFromCache(this, "config_mount_star", false)
			if (MaxCfg) {
				let CurCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mount_star.name, data_.type_id + "@" + data_.stage + "@" + data_.star, false, MaxCfg)
				if (CurCfg) {
					let maxBless = CurCfg.max_blessing
					this.expImg.width = 552 * (data_.blessing / maxBless)
					this.expLb.text = data_.blessing + "/" + maxBless
					// this.AddUIEffect("ui_progressbar_glow", this.effectGp, { x: 0, y: 12 }, 0.75, true)
					this.effectGp.x = this.expImg.x + this.expImg.width
				}
			}
			this.ClearTimer()
			blessTimer_ = GlobalTimerQuest.AddPeriodQuest(this.SetLabel, 1)
			this.SetLabel()
			this.InitText()
		}

		this.ClearTimer = () => {
			if (blessTimer_) {
				GlobalTimerQuest.CancelQuest(blessTimer_)
				blessTimer_ = null
			}
		}

		this.SetLabel = () => {
			if (this.timeLb) {
				if (endTime_ >= local_timeUtil.getServerTime()) {
					this.timeLb.innerHTML = local_util.StrToHTML(`祝福值清空倒计时:<font color='#67be0a'>${local_timeUtil.timeConvert(endTime_ - local_timeUtil.getServerTime(), "hh-mm-ss2")}</font>`)
				} else {
					this.Close()
				}
			}
		}

		this.InitText = () => {
			let Cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigInstruction
			if (Cfg && Cfg["16023"]) {
				let yIndex = 5
				let itemList = Cfg["16023"][0].content.item_List
				for (let vo of itemList) {
					let Lb = new Laya.HTMLDivElement()
					Lb.style.fontSize = 22
					Lb.style.color = "#955959"
					Lb.y = yIndex
					Lb.x = 0
					Lb.style.bold = true
					this.tipsGp.addChild(Lb)
					Lb.innerHTML = local_util.StrToHTML(vo.item_title)
					yIndex = yIndex + 30
					for (let text of vo.item_content) {
						let Lb1 = new Laya.HTMLDivElement()
						Lb1.style.fontSize = 22
						Lb1.style.color = "#955959"
						Lb1.width = 530
						Lb1.style.leading = 4
						Lb1.innerHTML = local_util.StrToHTML(text)
						this.tipsGp.addChild(Lb1)
						Lb1.x = 25
						// Lb1.validateNow()
						Lb1.y = yIndex
						yIndex += Lb1.height + 18
					}
				}
			}
		}

	}

	public Open(...parms) {
		this._Open(...parms)
		super.Open()
	}


	public GetComponents() {
		[
			this.bg,
			this.bg2,
			this.bg3,
			this.bg4,
			this.closeBtn,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this.expImg,
			this.effectGp,
			this._Label1,
			this.expLb,
			this.timeLb,
			this._Label2,
			this._Label3,
			this.cancelBtn,
			this._Image111,
			this.labelDisplay,
			this.enterBtn,
			this._Image11,
			this.labelDisplay1,
			this._Scroller1,
			this.tipsGp,
		]
			= this.GetChildrenByNames([

				"bg",
				"bg2",
				"bg3",
				"bg4",
				"closeBtn",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"expImg",
				"effectGp",
				"_Label1",
				"expLb",
				"timeLb",
				"_Label2",
				"_Label3",
				"cancelBtn",
				"_Image111",
				"labelDisplay",
				"enterBtn",
				"_Image11",
				"labelDisplay1",
				"_Scroller1",
				"tipsGp",
			])
		this.timeLb.style.fontSize=24
		this.timeLb.style.color="#955959"
	}
}
window["PetBlessView"] = PetBlessView