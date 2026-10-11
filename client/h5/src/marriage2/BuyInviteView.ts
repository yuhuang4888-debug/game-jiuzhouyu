import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { WithBtnHSlider } from "../common/WithBtnHSlider"
import { BanquetController } from "../commonController/BanquetController"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { WithBtnBanSlider } from "./WithBtnBanSlider"

export class BuyInviteView extends BaseView1 {
	// BG1
	InitInfo
	SetCount
	SetInfo
	// _Image3
	// _Image4
	// _Image5
	// canbuyLabel
	// cancelBtn
	change_scene_close
	// closeBtn
	count
	destroy_callback
	// enterBtn
	is_center
	// lessLabel
	onePrice
	preLoad_list
	preload_server_config
	// priceLabel
	show_open_movie
	slider: WithBtnBanSlider
	// sliderGp
	type
	use_background

	public constructor() {
		super()
		this.count = 1;
		this.onePrice = 20;
		this.base_file = "marriage2"
		//this.preLoad_list = ["marriage"]
		this.layout_file = "BuyInviteView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.show_open_movie = true
		this.is_center = true
		this.change_scene_close = true
		let local_BanqEvent = BanqEvent

		//this.preload_server_config = [config_wedding_info=false]
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("marriage2", "uijh_118"))
			this.InitInfo()
		}

		this.destroy_callback = () => {
			if (this.slider) {
				this.slider.DeleteMe()
				this.slider = null
			}
		}

		this.InitInfo = () => {

			let banqModel = BanquetModel.GetInstance()

			let price = MarriageModel.GetInstance().GetConstantData(21)
			price = price && JSON.parse(price)
			this.onePrice = price && price[0] ? price[0] : [1, 0, 50]

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.enterBtn, () => {
				if (!this.onePrice) { return }
				let price = this.count * Number(this.onePrice[2])
				let enough = GoodsModel.GetInstance().CheckCoinEnough(Number(this.onePrice[0]), price, true, () => {
					// banqModel.Fire(local_BanqEvent.REQUET_PROTO, 17259, "c", this.count)
					BanquetController.GetInstance().SendFmtToGame(17259, "c", this.count);
				}
				)
			}
				, this, true)
			Util.AddClickEvent(this.cancelBtn, () => {
				this.Close()
			}
				, this, true)
			this.BindEvent(banqModel, local_BanqEvent.BUY_MAX, (scmd?) => {
				if (scmd) {
					this.SetInfo(scmd)
				}
			}
			)
			this.BindEvent(banqModel, local_BanqEvent.INVITE_VIEW_DATA, (scmd?) => {
				if (scmd) {
					this.type = scmd.wedding_type
					this.SetInfo(scmd)
				}
			}
			)


			let info = banqModel.InviteViewData
			if (info) {
				this.type = info.wedding_type
				this.SetInfo(info)
			}

			this.SetCount(1)
			ResManager.GetInstance().SetTexture(this, this._Image2, GameResPath.GetIcon("marriage2", "uijh_118"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("marriage", "uijh_077"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image4, GameResPath.GetIcon("marriage2", "uijh_160"), true)
			let res = this.onePrice && this.onePrice[0] == "2" && "com_bind_diamond" || "com_diamond"
			ResManager.GetInstance().SetImageSprite(this, this._Image5, "common_asset", res, true)
		}

		this.SetInfo = (info?) => {
			if (info) {
				this.lessLabel.text = Util.StrToHTML("剩余邀请函数量:" + info.less_invite_num)
				let wedding_info_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_info", false)
				// [ts2lua]wedding_info_cfg下标访问可能不正确
				let cfg = wedding_info_cfg[this.type]
				if (cfg) {
					this.canbuyLabel.text = Util.StrToHTML("可购买邀请函数:" + (cfg.guest_num_max - info.guest_num))
					if (!this.slider) {
						this.slider = new WithBtnBanSlider(this.sliderGp, 1, 1, 1, cfg.guest_num_max - info.guest_num, true, (value?) => {
							this.SetCount(value)
						}
						)
						this.slider.Load()
					} else {
						this.slider.ExcuteCallback(() => {
							let num = cfg.guest_num_max - info.guest_num
							this.slider.SetData(1, 1, 1, num > 0 && num || 1, true, (value?) => {
								this.SetCount(value)
							}
							)
						}
						)
					}
				}
			}
		}

		this.SetCount = (count?) => {
			if (count < 0 || !this.onePrice) {
				return
			}
			this.count = Math.ceil(count);
			this.priceLabel.text = this.count * Number(this.onePrice[2]) + "";
		}
	}

	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	BG1: Laya.Image
	closeBtn: Laya.Image
	cancelBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	enterBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	lessLabel: Laya.Label
	canbuyLabel: Laya.Label
	_Label1: Laya.Label
	_Label2: Laya.Label
	priceLabel: Laya.Label
	sliderGp: Laya.Box
	_Image5: Laya.Image
	public GetComponents() {
		[
			this._Image2,
			this._Image3,
			this._Image4,
			this.BG1,
			this.closeBtn,
			this.cancelBtn,
			this._Image1,
			this.labelDisplay,
			this.enterBtn,
			this._Image111,
			this.labelDisplay1,
			this.lessLabel,
			this.canbuyLabel,
			this._Label1,
			this._Label2,
			this.priceLabel,
			this.sliderGp,
			this._Image5,
		]
			= this.GetChildrenByNames([

				"_Image2",
				"_Image3",
				"_Image4",
				"BG1",
				"closeBtn",
				"cancelBtn",
				"_Image1",
				"labelDisplay",
				"enterBtn",
				"_Image111",
				"labelDisplay1",
				"lessLabel",
				"canbuyLabel",
				"_Label1",
				"_Label2",
				"priceLabel",
				"sliderGp",
				"_Image5",
			])
	}
}
window["BuyInviteView"] = BuyInviteView