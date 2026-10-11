import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DsgtModel } from "../commonModel/DsgtModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPositionY, GlobalTimerQuest, Trim, SetLocalScale, SetSizeDeltaX, GetSizeDeltaX } from "../util/Util"

export class GetDsgtView extends BaseView1 {
	CloseTimer
	InitEvent
	Local_Close
	Local_Open
	OnTimerFunc
	PlayAnimation
	SetShowView
	_gp_anime
	_gp_dsgt
	_gp_line_effect
	_img_item_bg_left
	_img_item_bg_right
	_lb_title
	alpha_id
	click_bg_toClose
	curr_sorting_order
	destroy_imm
	dsgt_bg_1_image
	dsgt_bg_2_image
	dsgt_dec_label
	dsgt_geticon_image
	dsgt_icon_image
	dsgt_timer_label
	is_center
	open_callback
	posy_id1
	posy_id2
	use_background
	light: Laya.Image
	_gp_effect: Laya.Box

	public constructor() {
		super()


		this.base_file = "dsgt"
		this.layout_file = "GetDsgtView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true

		let dsgt_id_ = null
		let timer_ = null
		let time_ = 10
		this.load_callback = () => {

			// this._gp_anime.GetComponent("CanvasGroup").alpha = 0
			// SetAnchoredPositionY(this._gp_anime, 40)
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.dsgt_dec_label.size  = 18
			// 	this.dsgt_dec_label.lineSpacing = 0.9
			// }
		}

		this.open_callback = () => {
			// this.curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			this.InitEvent()
			this.SetShowView()
			this.OnTimerFunc()
			this.PlayAnimation()
		}

		this.Local_Open = (id?) => {
			if (id) {
				dsgt_id_ = id
				super.Open()
			}
		}

		this.InitEvent = () => {
			if (!timer_) {
				timer_ = GlobalTimerQuest.AddPeriodQuest(this.OnTimerFunc, 1, -1)
			}
		}

		this.PlayAnimation = () => {
			if (this._gp_anime) {
				// this.alpha_id = SYTweenLite.to(this, this._gp_anime.GetComponent("CanvasGroup"), SYTweenLite.UiAnimationType.ALPHA, 1, 0.4, null, null, false)
				// let func = () => {
				// 	this.posy_id2 = SYTweenLite.to(this, this._gp_anime, SYTweenLite.UiAnimationType.POSY, 0, 0.1, null, null, false)
				// }
				// this.posy_id1 = SYTweenLite.to(this, this._gp_anime, SYTweenLite.UiAnimationType.POSY, -10, 0.3, null, null, false)

			}
		}

		this.OnTimerFunc = () => {
			this.dsgt_timer_label.text = "点击任意区域继续(" + time_ + "s)"
			if (time_ < 0) {
				this.Close()
			}
			time_ = time_ - 1
		}



		this.SetShowView = () => {
			let dsgt = DsgtModel.GetInstance().getDsgtCfgByID(dsgt_id_)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_item_bg_left, GameResPath.GetIcon("common4", "uijs_064"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_item_bg_right, GameResPath.GetIcon("common4", "uijs_064"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgt_bg_2_image, GameResPath.GetIcon("common4", "uijs_062"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgt_bg_1_image, GameResPath.GetIcon("common4", "uijs_062"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this.dsgt_geticon_image, GameResPath.GetIcon("dsgt", "uijs_061b"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgt_icon_image, "resource/game/dsgtIcon/" + dsgt.resource_id + ".png", true, () => {

			// })

			//this:AddUIEffect("ui_aperture1", this._gp_line_effect, null, null, true)
			//this:ClearUIEffect(this._gp_dsgt)
			if (!dsgt) {
				return
			}
			if (dsgt.type == 1) {
				this.dsgt_icon_image.visible = false
				let data = {
					custom_sorting_order: this.curr_sorting_order
				}
				ResManager.GetInstance().LoadGameConfig(this,"ClientEffDsgtShow",true,null,(ClientEffDsgtShow)=>{
					if ( ClientEffDsgtShow) {
						this.ClearUIEffect(this._gp_dsgt)
						this._gp_dsgt.width = 237
						this._gp_dsgt.height = 120
						let cfg = ClientEffDsgtShow["GetDsgtView"][dsgt.id]
						if(!cfg){
							cfg = ClientEffDsgtShow["GetDsgtView"]["def"]
						}
						this.AddUIEffect(Trim(dsgt.resource_id), this._gp_dsgt, { x: cfg.x, y: cfg.y }, cfg.scale, true, null, null, null, null, null, null, null, false)
					}
				})

			} else {
				this.dsgt_icon_image.visible = true
				

				if (dsgt.main_type == 7) { //伴侣动态称号
					this.dsgt_icon_image.sizeGrid = "0,61,0,68"
				} else {

					this.dsgt_icon_image.sizeGrid = null
				}


				ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgt_icon_image, "resource/game/dsgtIcon/" + dsgt.resource_id + ".png", true, () => {
					if (this.use_delete_method) {
						return
					}
					SetLocalScale(this.dsgt_icon_image, 1.5, 1.5, 1)
					if (dsgt.main_type == 7) {
						let name = RoleManager.GetInstance().GetMainRoleVo().marriage_name
						let title = name + "的伴侣"
						this._lb_title.text = title
						this.dsgt_icon_image.width = this._lb_title.width + 60;
						// SetSizeDeltaX(this.dsgt_icon_image, GetSizeDeltaX(this._lb_title) + 70)
					} else {
						this._lb_title.text = ''
						// SetSizeDeltaX(this.dsgt_icon_image, 0)
					}
				})

			}
			this.dsgt_dec_label.text = dsgt.description
		}

		this.CloseTimer = () => {
			if (timer_) {
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null
			}
		}

		this.Local_Close = () => {
			if (this.alpha_id) {
				SYTweenLite.Stop(this.alpha_id)
				this.alpha_id = null
			}
			if (this.posy_id1) {
				SYTweenLite.Stop(this.posy_id1)
				this.posy_id1 = null
			}
			if (this.posy_id2) {
				SYTweenLite.Stop(this.posy_id2)
				this.posy_id2 = null
			}
			this.CloseTimer()
			super.Close()
		}
	}

	public Open(id?) {

		this.Local_Open(id)
	}

	public Close() {

		this.Local_Close()
	}


	public GetComponents() {
		[
			this._gp_anime,
			this._gp_line_effect,
			this.dsgt_bg_1_image,
			this.dsgt_bg_2_image,
			this._img_item_bg_left,
			this._img_item_bg_right,
			this.light,
			this.dsgt_geticon_image,
			this.dsgt_icon_image,
			this._lb_title,
			this.dsgt_dec_label,
			this.dsgt_timer_label,
			this._gp_effect,
			this._gp_dsgt,
		]
			= this.GetChildrenByNames([

				"_gp_anime",
				"_gp_line_effect",
				"dsgt_bg_1_image",
				"dsgt_bg_2_image",
				"_img_item_bg_left",
				"_img_item_bg_right",
				"light",
				"dsgt_geticon_image",
				"dsgt_icon_image",
				"_lb_title",
				"dsgt_dec_label",
				"dsgt_timer_label",
				"_gp_effect",
				"_gp_dsgt",
			])
	}
}

window["GetDsgtView"] = GetDsgtView