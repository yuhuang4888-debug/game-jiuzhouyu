import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RuneTreasureController } from "../commonController/RuneTreasureController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { TopVipActivityDetailItem } from "./TopVipActivityDetailItem"

export class TopVipActivityDetailView extends BaseView1 {
	_Group1: Laya.Box
	bg_img: Laya.Image
	ber_img: Laya.Image
	vip_type_img: Laya.Image
	_congratulation_img: Laya.Image
	_congratulation_text: Laya.Label
	look_detail_gp: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	scroll_bg: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	close_img: Laya.Image

	InitEvent
	InitView
	LoadSuccess
	Scr_Scroller1
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	not_show_item_use
	open_callback
	show_open_movie
	text_gp
	use_background

	public constructor() {
		super()



		let item_list_ = null
		let vip_type_ = null
		let need_refresh_ = false
		this.base_file = "topVip"
		this.layout_file = "TopVipActivityDetailView"
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.not_show_item_use = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.layer_value = Enum_UILayer.Activity
		this.preload_client_config={
			"ClientTopVipActivationConfig":false
		}
		this.load_callback = () => {

		}

		this.open_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
			if (need_refresh_) {
				this.InitView(vip_type_)
			}
		}

		this.close_callback = () => {
			if (item_list_ && item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = null
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.ber_img, GameResPath.GetIcon("topVip", "uizz_015"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("topVip", "uizz_022"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.scroll_bg, GameResPath.GetIcon("topVip", "uizz_022a"), true)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_img, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.look_detail_gp, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.SUPREME_VIP)
				this.Close()
			}
				, this, true)
		}

		this.InitView = (vip_type?) => {
			vip_type_ = vip_type
			if (!this.is_loaded) {
				need_refresh_ = true
				return
			}
			if (vip_type_ == 0) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this.vip_type_img, GameResPath.GetIcon("topVip", "uizz_012"), true)
				//lua_resM:SetOutsideImageSprite(this, this._congratulation_img, GameResPath.GetIcon("topVip","uizz_013"),true)
				this._congratulation_text.text = "恭喜您激活体验至尊贵族成长快人一步"
			} else {
				ResManager.GetInstance().SetOutsideImageSprite(this, this.vip_type_img, GameResPath.GetIcon("topVip", "uizz_017a"), true)
				//lua_resM:SetOutsideImageSprite(this, this._congratulation_img, GameResPath.GetIcon("topVip","uizz_013a"),true)
				this._congratulation_text.text = "恭喜您激活永久至尊贵族成长快人一步"
			}
			let ClientTopVipActivationConfig = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientTopVipActivationConfig", true)
			if (!item_list_) {
				item_list_ = []
			}
			let index = 0
			for (let key in ClientTopVipActivationConfig) {
				if(index>=7) break
				// [ts2lua]item_list_下标访问可能不正确
				let item = item_list_[index]
				// [ts2lua]ClientTopVipActivationConfig下标访问可能不正确
				let vo = ClientTopVipActivationConfig[key]
				if (!item) {
					item = new TopVipActivityDetailItem(this.Content)
					item.Load()
					table.insert(item_list_, item)
				}
				item.Setdata(vo)
				index = index + 1
			}
		}


	}

	public Open(...new_args) {

		let parm = new_args
		if (parm && parm.length > 0) {
			this.InitView(parm[0])
		}
		super.Open()
	}

	public GetComponents() {
		[
			this._Group1,
			this.bg_img,
			this.ber_img,
			this.vip_type_img,
			this._congratulation_img,
			this._congratulation_text,
			this.look_detail_gp,
			this._Image1,
			this._Label1,
			this.scroll_bg,
			this._Scroller1,
			this.Content,
			this.close_img,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"bg_img",
				"ber_img",
				"vip_type_img",
				"_congratulation_img",
				"_congratulation_text",
				"look_detail_gp",
				"_Image1",
				"_Label1",
				"scroll_bg",
				"_Scroller1",
				"Content",
				"close_img",
			])
		this._Scroller1.vScrollBar.visible=false
	}
}
window["TopVipActivityDetailView"] = TopVipActivityDetailView