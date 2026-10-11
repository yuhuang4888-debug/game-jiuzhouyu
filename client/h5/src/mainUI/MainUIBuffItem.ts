import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { SkillManager } from "../skill/SkillManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
export class MainUIBuffItem extends BaseItemRenderer {
	WIDTH = 328
	HEIGT = 95
	totle_time
	timer_id
	item_mask: Laya.Sprite

	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "MainUIBuffItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	LoadSuccess() {
		this.item_mask = new Laya.Sprite()
		this.item_mask.x = this._img_mask.width / 2
		this.item_mask.y = this._img_mask.height / 2
		this._img_mask.mask = this.item_mask

		this.InitEvent()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		this.totle_time = this.data.cfg.time || 0
		this._img_buff.skin = GameResPath.GetIcon("bufficon", this.data.cfg.icon)
		let name = this.data.cfg.name
		if (this.data.skill) {
			let skill_cfg = SkillManager.GetInstance().getSkillFromConfig(this.data.skill)
			name = skill_cfg.name
		}
		this._lb_name.text = name
		if (this.data.time != 0 && this.data.time != null) {
			if (typeof (this.data.time) == "string") {
				this._lb_time.text = this.data.time
			} else {
				if (!this.timer_id) {
					if (this.data.end_time == undefined)
						this.data.end_time = TimeUtil.getServerTime() + this.data.time
					this._lb_time.text = TimeUtil.convertTimeCN(this.data.end_time - TimeUtil.getServerTime())
					this.UpdateMask()
					this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
						if (this.data && this._lb_time) {
							if (this.data.end_time && this.data.end_time >= TimeUtil.getServerTime()) {
								this._lb_time.text = TimeUtil.convertTimeCN(this.data.end_time - TimeUtil.getServerTime())
								this.UpdateMask()
							} else {
								this._img_mask.visible = false
								this._lb_time2.text = ""
								this.CancelTimer()
								GoodsModel.GetInstance().Fire(GoodsModel.GET_GOODS_BUFF_LIST)
							}
						}
					}, 1)
				}
				this.data.end_time = TimeUtil.getServerTime() + this.data.time
				this._lb_time.text = TimeUtil.convertTimeCN(this.data.end_time - TimeUtil.getServerTime())
			}
		} else {
			this._lb_time.text = ""
			this._img_mask.visible = false
			this._lb_time2.text = ""
		}
		if (this.data.remain) {
			this._lb_time.text = "暂停"
		}
		if (this.data.desc || this.data.cfg.desc) {
			this._html_desc.style.color = "#7b5250"
			this._html_desc.style.fontSize = 16
			this._html_desc.style.width = 145
			this._html_desc.style.leading = 6
			this._html_desc.innerHTML = this.data.desc || this.data.cfg.desc
			if(PlatformManager.IsEyouPlatform()){
				this._html_desc.style.width = 170
			}
			this.CallLater(() => {
				this._html_desc.event("resize")
			})
		}

		//蒙面buff特殊处理
		if(this.data.cfg.icon == "mengmr"){
			this._gp_info.visible = true
			this._img_help.visible = true
			this._gp_des.centerY = 3
		}
		else{
			this._gp_info.visible = false
			this._img_help.visible = false
			this._gp_des.centerY = 13
		}
		
	}

	public SetData(data?) {
		this.data = data
		if (typeof (this.data.time) == "string") {
			this.data.end_time = 0
		} else {
			this.data.end_time = TimeUtil.getServerTime() + this.data.time
		}

		if (this.is_loaded) {

		}
	}

	private UpdateMask() {
		if (this.use_delete_method) {
			return
		}
		let time = this.data.end_time - TimeUtil.getServerTime()
		if (!this.totle_time || time < 0) {
			this._img_mask.visible = false
			this._lb_time2.text = ""
			return
		}
		if (time <= 99) {
			this._lb_time2.text = time.toString()
		} else {
			this._lb_time2.text = ""
		}
		this._img_mask.visible = true
		let angle = time / this.totle_time
		if (angle > 0 && angle < 1) {
			angle = 1 - angle
		}
		this.item_mask.graphics.clear()
		this.item_mask.graphics.drawPie(0, 0, 50, 360 - 90, 360 * angle - 90, 0x000000)
	}

	public CancelTimer() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = false
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_info, ()=>{
			if (!this.data) return
			if (this.data.cfg.icon == "mengmr") {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MaskInfoView")
			}
		}, this, true)

		Util.AddClickEvent(this._img_help, ()=>{
			if (!this.data) return
			if (this.data.cfg.icon == "mengmr") {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 511)
			}
		}, this, true)
	}

	public DeleteMe() {
		// this._img_mask.mask = null
		this.CancelTimer()
		super.DeleteMe()
	}

	_Group1: Laya.Box
	_Image1: Laya.Image
	_img_buff: Laya.Image
	_img_mask: Laya.Image
	_lb_time2: Laya.Label
	_img_help: Laya.Image
	_lb_name: Laya.Label
	_lb_time: Laya.Label
	_gp_info: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_lb_desc: Laya.Label
	_gp_des: Laya.VBox
	_html_desc: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this._img_buff,
			this._img_mask,
			this._lb_time2,
			this._img_help,
			this._lb_name,
			this._lb_time,
			this._gp_info,
			this._Image2,
			this._Label1,
			this._lb_desc,
			this._gp_des,
			this._html_desc,
		]
			= this.GetChildrenByNames([
				"_Group1",
				"_Image1",
				"_img_buff",
				"_img_mask",
				"_lb_time2",
				"_img_help",
				"_lb_name",
				"_lb_time",
				"_gp_info",
				"_Image2",
				"_Label1",
				"_lb_desc",
				"_gp_des",
				"_html_desc",
			])
	}
}
window["MainUIBuffItem"] = MainUIBuffItem