import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TimeUtil } from "../util/TimeUtil"
import { Trim, SetAnchoredPositionY, GlobalTimerQuest, HtmlColorTxt, TransformLevel, SetHtmlStyle, SetHtmlCenter } from "../util/Util"
import { Config } from "../common/Config"
import { GameResPath } from "../util/GameResPath"

export class BossDomainItem extends BaseItemRenderer {

	_model
	_time
	is_can_challenge
	is_enough_lv
	is_enough_equip
	_labelTimer
	_boss_data
	color

	time_x=85
	time_w=171

	public WIDTH = 264
	public HEIGT = 98
	public constructor(parent) {
		super()

		this._time = 0
		this.is_can_challenge = true
		this.is_enough_lv = true
		this.is_enough_equip = true
		this.base_file = "bossdomain"
		this.layout_file = "BossDomainItem"
		this.color = "'#fe1a1a'"
		this.load_callback = () => {
			SetHtmlStyle(this.text_scene, { c: "#5a1c20", f: 20, ww: false, w: 100 })
			SetHtmlStyle(this._lb_time, { c: "#fe1a1a", f: 16, ww: false, w: this.time_w })
			SetHtmlStyle(this._lb_equip, { c: "#fe1a1a", f: 16, ww: false, w: this.time_w })
			this._model = BossModel.GetInstance()

		}

		this.Load()
	}

	public DeleteMe() {

		this.removeLabelTimer()
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this._img_select.visible = this.selected
		this._lb_time.y=56
		if (this._model.do_main_data.act_status == 1) {
			this.removeLabelTimer()
			this._lb_time.innerHTML = HtmlColorTxt('调整跨服分区中稍后再试....', this.color)
			SetHtmlCenter(this._lb_time, { x: this.time_x, w: this.time_w })
		} else {
			this._boss_data = this._model.DoMainBossInfo(this.data.boss_id)
			ResManager.GetInstance().SetImageSprite(this, this._img_equip, "bossdomain_asset", this.data.boss_type == 1 && "uihyb_003" || "uihyb_004", true)
			let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.boss_id, false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._head_img, GameResPath.GetMonsterHeadPath(mon_cfg.icon))


			let arr = this._model.DomainBossCfgInfo(this.data)
			this.is_can_challenge = arr[0]
			this.is_enough_lv = arr[1]
			this.is_enough_equip = arr[2]
			let need_sorce = arr[3]
			let need_lv = arr[4]
			let need_eq_type = arr[5]
			let need_eq_num = arr[6]
			
			
			this._img_icon.visible = false
			let equip_desc = ''
			if (need_eq_type > 0 && need_eq_num > 0) {
				let page_cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_page
				let info = page_cfg[need_eq_type]
				equip_desc = Trim(info.normal_name) + "套装" + need_eq_num + "件"
				let num = GoodsModel.GetInstance().GetStarEquipPageNum(need_eq_type, true)
				this._lb_equip.innerHTML = HtmlColorTxt("需" + equip_desc, this.color)
				SetHtmlCenter(this._lb_equip, { x: this.time_x, w: this.time_w })
				this._lb_time.y=50
				this.showEquipLb(true)
			} else {
				this.showEquipLb(false)
			}
			let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.boss_id, false)
			if (bossVo) {
				this._lb_name.text = bossVo.name
				this.lv.text = "lv." + bossVo.lv
			}
			let tsvar_not = !this.is_can_challenge || !this.is_enough_lv || !this.is_enough_equip
			if (tsvar_not) {
				this._lb_time.visible = true
				this.gp_scene.visible = false
				this.removeLabelTimer()
				if (!this.is_can_challenge || (this.is_can_challenge && !this.is_enough_equip)) {
					this._lb_time.innerHTML = HtmlColorTxt("需灵饰达到" + WordManager.FormatNumber2(need_sorce, true) + "评分", this.color)
					SetHtmlCenter(this._lb_time, { x: this.time_x, w: this.time_w })
				} else if (!this.is_enough_lv) {
					let lv_str = TransformLevel(need_lv)
					this._lb_time.innerHTML = HtmlColorTxt("需等级达到" + lv_str + "级", this.color)
					SetHtmlCenter(this._lb_time, { x: this.time_x, w: this.time_w })
				} else {
					this._lb_time.visible = false
				}


			} else {
				this.showEquipLb(false)
				this.updateLabel()
			}
			//SetImageGray(this._bg, tsvar_not)
		}
	}

	public showEquipLb(bool?) {

		this._lb_equip.visible = bool

		// if (bool ) {
		// 	SetAnchoredPositionY(this._lb_time,-53.5)
		// 	SetAnchoredPositionY(this.gp_scene,-53.5)
		// }else{
		// 	SetAnchoredPositionY(this._lb_time,-65)
		// 	SetAnchoredPositionY(this.gp_scene,-65)
		// }
	}

	public initTimer() {

		if (!this._labelTimer) {
			this._labelTimer = GlobalTimerQuest.AddPeriodQuest(() => { this.onTimer() }, 1, -1)
		}
	}

	public onTimer() {

		if (this._time <= 0) {
			this.removeLabelTimer()
		}
		this.updateLabel()
		this._time = this._time - 1
	}

	public removeLabelTimer() {

		if (this._labelTimer) {
			GlobalTimerQuest.CancelQuest(this._labelTimer)
			this._labelTimer = null
		}
	}

	public canChallenge() {

		return this.is_can_challenge
	}

	public fullLevel() {

		return this.is_enough_lv
	}

	public fullEquip() {

		return this.is_enough_equip
	}

	public updateLabel() {

		// let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_boss_kv", false)//Config.Decorationbosskv
		let role_num = (this._boss_data && this._boss_data.role_num) && this._boss_data.role_num || 0
		let num = Math.min(role_num, this.data.role_num)
		if (this._boss_data) {
			this._time = this._boss_data.reborn_time - TimeUtil.getServerTime()
			if (this._time <= 0) {
				this.text_scene.innerHTML = `场景：${HtmlColorTxt(num + "", "'#089f41'")}人`
			} else {
				this._lb_time.innerHTML = `复活时间：${HtmlColorTxt(TimeUtil.convertTime(this._time) + "", "'#089f41'")}`
				SetHtmlCenter(this._lb_time, { x: this.time_x, w: this.time_w })
				this.initTimer()
			}
			this._img_icon.visible = this._time > 0
			this.gp_scene.visible = this._time <= 0
			this._lb_time.visible = this._time > 0
		} else {
			this._img_icon.visible = false
			this.gp_scene.visible = true
			this._lb_time.visible = false
			this.removeLabelTimer()
			this.text_scene.innerHTML = `场景：${HtmlColorTxt(num + "", "'#089f41'")}人`
		}
	}



	_item_ng: Laya.Image
	_head_bg: Laya.Image
	_head_img: Laya.Image
	_gp: Laya.Box
	_lb_name: Laya.Label
	lv: Laya.Label
	_lb_time: Laya.HTMLDivElement
	gp_scene: Laya.Box
	text_scene: Laya.HTMLDivElement
	_img_relive1: Laya.Image
	_lb_equip: Laya.HTMLDivElement
	_img_equip: Laya.Image
	_img_select: Laya.Image
	_img_icon: Laya.Image
	public GetComponents() {
		[
			this._item_ng,
			this._head_bg,
			this._head_img,
			this._gp,
			this._lb_name,
			this.lv,
			this._lb_time,
			this.gp_scene,
			this.text_scene,
			this._img_relive1,
			this._lb_equip,
			this._img_equip,
			this._img_select,
			this._img_icon,
		]
			= this.GetChildrenByNames([

				"_item_ng",
				"_head_bg",
				"_head_img",
				"_gp",
				"_lb_name",
				"lv",
				"_lb_time",
				"gp_scene",
				"text_scene",
				"_img_relive1",
				"_lb_equip",
				"_img_equip",
				"_img_select",
				"_img_icon",
			])
	}
}
window["BossDomainItem"] = BossDomainItem