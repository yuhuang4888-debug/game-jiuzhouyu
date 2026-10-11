import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, Util } from "../util/Util"

export class ArenaBattleRecordItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_Image2: Laya.Image
	_img_head: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_lb_level: Laya.Label
	_lb_fighting: Laya.Label
	_Group1: Laya.HBox
	_lb_name: Laya.Label
	_img_vip: Laya.Image
	_lb_result: Laya.HTMLDivElement
	_Group2: Laya.Box
	_img_arrow: Laya.Image
	_lb_change_rank: Laya.Label

	head
	model
	need_refresh_data
	vo

	public static width = 613
	public static height = 145

	public constructor(parent?) {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaBattleRecordItem"
		this.model = ArenaModel.GetInstance()
		this.vo = null
		this.need_refresh_data = false
		this.head = null
		this.WIDTH=613
		this.HEIGT=120
		// this.load_callback = () => {

		// 	this.LoadSuccess()
		// 	// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	// 	SetSizeDeltaX(this._lb_result,376)
		// 	// }
		// }
		this.Load()
	}

	public load_callback() {

		//lua_resM:SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("arena","uitc_007"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("arena", "uijj_018"))
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		this.vo = this.data
		this.UpdateView()
	}

	public UpdateView() {


		if (this.head == null) {
			this.head = new CustomHeadItem(this._img_head)
			this.head.Load()
		}
		this.head.SetRoleVoData(this.vo, null, null, this.vo.lv)
		this.head.ExcuteCallback(()=>{
			this.head._lev_.color="#ffffff"
			this.head._lev_.strokeColor="#371d10"
		})
		this._lb_name.text = this.vo.name
		// LayoutRebuilder(this._Group1)

		this._lb_result.innerHTML = Util.StrToHTML(this.vo.result == 1 && "<font color='#0a953e'>胜</font>" || "<font color='#fa1e1e'>负</font>")
		this._lb_fighting.text =  this.vo.combat_power
		this._lb_level.text = this.vo.lv
		ResManager.GetInstance().SetImageSprite(this, this._img_vip, "mainUI_asset", "uivip_zjm_" + this.vo.vip_lv)
		if (this.vo.state == 0) {
			this._img_arrow.visible = false
			this._lb_change_rank.text = "--"
		} else {
			this._img_arrow.visible = true
			if (this.vo.state == 1) {
				ResManager.GetInstance().SetImageSprite(this, this._img_arrow, "arena", "com_uparrow", true)
			} else if (this.vo.state == 2) {
				ResManager.GetInstance().SetImageSprite(this, this._img_arrow, "common_asset", "com_up_arrow_down", true)
				// this._img_arrow.visible=false
				// this._lb_change_rank.text = "--"
			}
			this._lb_change_rank.text = this.vo.rank_range
		}
	}

	public DeleteMe() {

		if (this.head) {
			this.head.DeleteMe()
			this.head = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._Image2,
			this._img_head,
			this._Image3,
			this._Image4,
			this._lb_level,
			this._lb_fighting,
			this._Group1,
			this._lb_name,
			this._img_vip,
			this._lb_result,
			this._Group2,
			this._img_arrow,
			this._lb_change_rank,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image2",
				"_img_head",
				"_Image3",
				"_Image4",
				"_lb_level",
				"_lb_fighting",
				"_Group1",
				"_lb_name",
				"_img_vip",
				"_lb_result",
				"_Group2",
				"_img_arrow",
				"_lb_change_rank",
			])
		this._lb_result.style.fontSize=20
		this._lb_result.style.color="#ff4f50"
	}
}
window["ArenaBattleRecordItem"]=ArenaBattleRecordItem