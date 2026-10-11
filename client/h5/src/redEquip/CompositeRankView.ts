import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util, SetLocalPositionX, SetLocalPositionY } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { ColorUtil } from "../util/ColorUtil"

export class CompositeRankView extends BaseView1 {
	SetRank
	res_mgr

	public constructor() {
		super()
		this.base_file = "composite"
		this.layer_value = Enum_UILayer.Activity
		this.layout_file = "CompositeRankView"
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.preload_client_config = {
			"ClientCompositeRank": false
		}

		let rankCfg_ = null
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			/*
			if (PlatformMgr.GetInstance().IsEyouKrPlatform() ) {
				SetAnchoredPositionX(this._Label2,350)
				SetAnchoredPositionX(this._Label3,350)
			}
			*/
			rankCfg_ = this.res_mgr.GetGameConfigFromCache(this, "ClientCompositeRank", true)

			this.res_mgr.SetOutsideImageSprite(this, this.bg1, "resource/game/composite/other/ui_merge_16.png")
			this.res_mgr.SetOutsideImageSprite(this, this._Imagerole, "resource/game/composite/other/ui_merge_19.png")
			this.res_mgr.SetOutsideImageSprite(this, this.bline, "resource/game/composite/other/ui_merge_18.png")

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			if (rankCfg_) {
				this.SetRank()
			}

			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				let csf = this._Label2.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this._Label2, 121)
				SetAnchoredPositionX(this._Label2, 316)
				this._Label2.verticalAlign = "top"
				this._Label2.textAlign = "right"

				let csf2 = this._Label3.GetComponent("ContentSizeFitter")
				csf2.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this._Label3, 121)
				SetAnchoredPositionX(this._Label3, 316)
				this._Label3.verticalAlign = "top"
				this._Label3.textAlign = "right"

				let csf3 = this._Label6.GetComponent("ContentSizeFitter")
				csf3.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this._Label6, 250)
				this._Label6.size = 18

				this._Label1.size = 16
				SetAnchoredPositionX(this._Label1, 335)
			}
			*/
		}

		this.SetRank = () => {
			let rankKlist = rankCfg_.rank
			if (rankKlist) {
				let i = 0
				do {
					let info = rankKlist[i]
					let rankLb = new Laya.Label(this.display_obj.name)
					this.display_obj.addChild(rankLb)
					rankLb.fontSize = 18
					rankLb.color =  ColorUtil.GetColorDark(info[0],false)//info[0] == 5 && "#fe1a1a" || "#ff6519"
					/*
					if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
						textrankLb.text = "G" + info[2] + ColorUtil.GetColorName(info[1]) + info[3] + "Star"
					} else {
						textrankLb.text = info[2] + "阶" + ColorUtil.GetColorName(info[1]) + info[3] + "星"
					}
					*/
					rankLb.text = info[1] + "阶" + ColorUtil.GetColorName(info[0]) + info[2] + "星"

					if (6 == info[1]) {
						SetLocalPositionX(rankLb, 130)
					} else if (7 == info[1]) {
						SetLocalPositionX(rankLb, 250)
					} else if (8 == info[1]) {
						SetLocalPositionX(rankLb, 380)
					} else if (9 == info[1]) {
						SetLocalPositionX(rankLb, 500)
					}
					//302 
					SetLocalPositionY(rankLb, (275 + i * 27.5))
					i = i + 1
				} while ((i < rankKlist.length))
			}
		}
	}

	bg1: Laya.Image
	bline: Laya.Image
	_Imagerole: Laya.Image
	topimg: Laya.Image
	_Image1: Laya.Image
	closeBtn: Laya.Image
	_Image12: Laya.Image
	_Image13: Laya.Image
	_Image16: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	_Label6: Laya.Label
	_Label7: Laya.Label
	_Label8: Laya.Label
	_Label9: Laya.Label
	_Label10: Laya.Label
	lb_title: Laya.Label
	public GetComponents() {
		[
			this.bg1,
			this.bline,
			this._Imagerole,
			this.topimg,
			this._Image1,
			this.closeBtn,
			this._Image12,
			this._Image13,
			this._Image16,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Label5,
			this._Label6,
			this._Label7,
			this._Label8,
			this._Label9,
			this._Label10,
			this.lb_title,
		]
			= this.GetChildrenByNames([
				"bg1",
				"bline",
				"_Imagerole",
				"topimg",
				"_Image1",
				"closeBtn",
				"_Image12",
				"_Image13",
				"_Image16",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Label5",
				"_Label6",
				"_Label7",
				"_Label8",
				"_Label9",
				"_Label10",
				"lb_title",
			])
	}
}
window["CompositeRankView"] = CompositeRankView