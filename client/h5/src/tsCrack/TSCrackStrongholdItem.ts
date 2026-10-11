import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY, SetLocalScale, Util } from "../util/Util"

export class TSCrackStrongholdItem extends BaseItem1 {
	_gp_server: Laya.Box
	_Image1: Laya.Image
	_lb_server: Laya.Label
	_gp_name: Laya.Box
	_Image2: Laya.Image
	_lb_name: Laya.HTMLDivElement
	_gp_con: Laya.Box
	_img_stronghold: Laya.Image
	_gp_con1: Laya.Box
	_img_cirle: Laya.Image
	_gp_cirle: Laya.Box
	_cirle: Laya.Box
	cirle1: Laya.Box
	cirle2: Laya.Box
	cirle3: Laya.Box
	cirle4: Laya.Box
	cirle5: Laya.Box
	cirle6: Laya.Box
	cirle7: Laya.Box
	cirle8: Laya.Box
	_lb_schedule: Laya.Label
	_gp_tips: Laya.Box
	_img_tips: Laya.Image
	_lb_tips: Laya.Label
	progress: Laya.Image
	speed : Laya.Box
	Circirle1
	Circirle2
	Circirle3
	Circirle4
	Circirle5
	Circirle6
	Circirle7
	Circirle8
	Out_lb_schedule
	data
	need_refresh_cfg
	need_refresh_data
	res_mgr
	stronghold_cfg
	ts_crack_model






	public constructor(parent?) {
		super(parent)

		this.base_file = "tsCrack"
		this.layout_file = "TSCrackStrongholdItem"
		this.ts_crack_model = TSCrackModel.GetInstance()
		this.res_mgr = RoleManager.GetInstance()
		this.data = null
		this.stronghold_cfg = null
		this.need_refresh_data = null
		this.need_refresh_cfg = null


		this.load_callback = () => {
			this.LoadSuccess()
		}
	}





	public LoadSuccess() {


		this.InitEvent()
	}



	public InitEvent() {


		Util.AddClickEvent(this._gp_con, () => {
			if (this.data) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackStrongholdMsgView", this.data.stronghold_id)
			}
		}, this, true)



		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_OWNER_ID, () => {
			this.UpdateOwnerTips()
		})



		if (this.need_refresh_cfg) {
			this.InitView()
			this.need_refresh_cfg = false
		}

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}

	}



	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}



	public SetCfg(cfg?) {

		this.stronghold_cfg = cfg
		if (this.is_loaded) {
			this.InitView()
		} else {
			this.need_refresh_cfg = true
		}
	}



	public InitView() {

		if (this.stronghold_cfg) {
			let size = 20
			if (this.stronghold_cfg.lv == 1) {
				this._gp_server.y = -75
				// this._gp_name.y = 48
				this._gp_tips.x = -75
				SetLocalScale(this._gp_con1, 0.52, 0.52, 1)
				SetLocalScale(this._gp_name, 0.7, 0.7, 1)
				SetAnchoredPosition(this._gp_name, -40, 25)
				this.speed.y = 60
				this.speed.x = -45
				//size = 16
				// SetAnchoredPositionY(this._gp_server, 75)
				// SetAnchoredPositionY(this._gp_name, -48) 
				// SetAnchoredPositionX(this._gp_tips, 50)
			} else if (this.stronghold_cfg.lv == 2) {
				//this._gp_con1.scaleY = 0.62
				//this._gp_con1.scaleX = this._gp_con1.scaleY
				this._gp_server.y = -84
				//this._gp_name.y = 56
				this._gp_tips.x = -50
				SetLocalScale(this._gp_con1, 0.62, 0.62, 1)
				SetLocalScale(this._gp_name, 0.8, 0.8, 1)
				SetAnchoredPosition(this._gp_name, -40, 25)
				SetAnchoredPosition(this.speed,-40,65)
				// SetAnchoredPositionY(this._gp_server, 84)
				// SetAnchoredPositionY(this._gp_name, -56)
				// SetAnchoredPositionX(this._gp_tips, 58)
			} else if (this.stronghold_cfg.lv == 3 || this.stronghold_cfg.lv == 4 || this.stronghold_cfg.lv == 5) {
				//this._gp_con1.scaleY = 0.72
				//this._gp_con1.scaleX = this._gp_con1.scaleY
				this._gp_server.y = -93
				//this._gp_name.y = 66
				this._gp_tips.x = -70
				SetLocalScale(this._gp_con1, 0.72, 0.72, 1)
				SetLocalScale(this._gp_name, 1, 1, 1)
				SetAnchoredPosition(this._gp_name, -55, 35)
				SetAnchoredPosition(this.speed,-40,80)
				if (this.stronghold_cfg.lv == 5){
					this._gp_name.y = 70
					this._gp_tips.x = -120
					SetAnchoredPosition(this.speed,-40,120)
				}
				// SetAnchoredPositionY(this._gp_server, 93)
				// SetAnchoredPositionY(this._gp_name, -66)
				// SetAnchoredPositionX(this._gp_tips, 68)
			}
			this._lb_name.style.fontSize = size
			this._lb_name.style.color = "#661c1c"
			this._lb_name.style.bold = true
			this._lb_name.style.wordWrap = false
			this._lb_name.innerHTML = Util.StrToHTML(this.stronghold_cfg.name)
			let a: Laya.HBox = <Laya.HBox>this._lb_name.parent
			if (a)
				a.refresh()
		}
		this._gp_server.visible = false
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_stronghold, GameResPath.GetTsPath("build", this.stronghold_cfg.icon + "0"), true)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetTsPath("floor", "floor_" + "0"))
	}



	public UpdateView() {

		if (this.data) {
			let a: Laya.HBox = <Laya.HBox>this._lb_name.parent
			if (a)
				a.refresh()
			//底板颜色区分索引
			let index = this.ts_crack_model.GetIndexByServerNum(this.data.server_num)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_stronghold, GameResPath.GetTsPath("build", this.data.icon + "0"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetTsPath("floor", "floor_" + index), true)
			if (this.data.server_num > 0) {
				this._gp_server.visible = true
				this._lb_server.text = "s" + this.data.server_num + "." + this.data.server_name
				this._lb_server.color = this.data.server_num == this.res_mgr.GetMainRoleVo().server_id && "#fff950" || "#ff4f50"
			} else {
				this._gp_server.visible = false
			}
			let server_list = this.data.server_list
			let total_value = 0
			if (this.ts_crack_model.HasOwnership(this.data.stronghold_id)) {
				if (server_list.length <= 1) {
					this.speed.visible = true
					this._lb_schedule.visible = true
					this._lb_schedule.text = "100%"
					this.progress.width = 108
					//this._lb_schedule.color = ColorUtil.TryParseHtmlString("#a2ed2d")
				} else {
					let max_value_vo = null
					for (let _tmpi in server_list) {
						var vo = server_list[_tmpi]
						if (!max_value_vo || max_value_vo.value < vo.value) {
							max_value_vo = vo
						}
					}
					if (max_value_vo && max_value_vo.server_num != this.res_mgr.GetMainRoleVo().server_id) {
						this._lb_schedule.visible = true
						this.speed.visible = true
						this._lb_schedule.text = Math.floor(max_value_vo.value / this.data.need_value * 10000) / 100 + "%"
						this.progress.width = 108 * max_value_vo.value / this.data.need_value
					//	this._lb_schedule.color = ColorUtil.TryParseHtmlString("#ff4f50")
					} else {
						this._lb_schedule.visible = false
						this.speed.visible = false
					}
				}
			} else {
				let my_vo = null
				for (let _tmpi in server_list) {
					var vo = server_list[_tmpi]
					if (vo.server_num == RoleManager.GetInstance().GetMainRoleVo().server_id) {
						my_vo = vo
						break
					}
				}
				if (my_vo) {
					this._lb_schedule.visible = true
					this.speed.visible = true
					this._lb_schedule.text = Math.floor(my_vo.value / this.data.need_value * 10000) / 100 + "%"
					this.progress.width = 108 * my_vo.value / this.data.need_value
					//this._lb_schedule.color = ColorUtil.TryParseHtmlString("#a2ed2d")
				} else {
					this._lb_schedule.visible = false
					this.speed.visible = false
				}
			}
			this.UpdateOwnerTips()





			let show_cirle_list = []
			if (server_list.length > 0) {
				for (let _tmpi in server_list) {
					var vo = server_list[_tmpi]
					total_value = total_value + vo.value
				}
				let now_angle = 0
				let angle = null
				let index
				for (let _tmpi in server_list) {
					var vo = server_list[_tmpi]
					angle = Math.round(vo.value / total_value * 360)
					index = this.ts_crack_model.GetIndexByServerNum(vo.server_num)
					this.DrawCirle(index, now_angle, angle)
					show_cirle_list[index] = true
					now_angle = now_angle + angle
				}
			} else {
				if (this.ts_crack_model.HasOwnership(this.data.stronghold_id)) {
					index = this.ts_crack_model.GetIndexByServerNum(this.data.server_num)
					this.DrawCirle(index, 0, 360)
					show_cirle_list[index] = true
				}
			}





			for (let i = 1; i <= 8; i++) {
				if (!show_cirle_list[i] && this["cirle" + i]) {
					this["cirle" + i].visible = false
				}
			}

			// _shape.graphics.endFill()

		}

	}



	public DrawCirle(index?, now_angle?, angle?) {




		//let cirle_color = null

		//


		//if (0 == index ) {

		//cirle_color = "#cbc1c1"

		//},

		//if (1 == index ) {

		//cirle_color = "#508cff"

		//},

		//if (2 == index ) {

		//cirle_color = "#25fefe"

		//},

		//if (3 == index ) {

		//cirle_color = "#ce55fd"

		//},

		//if (4 == index ) {

		//cirle_color = "#ff62a1"

		//},

		//if (5 == index ) {

		//cirle_color = "#ff1f1f"

		//},

		//if (6 == index ) {

		//cirle_color = "#ffa748"

		//},

		//if (7 == index ) {

		//cirle_color = "#5eff30"

		//},

		//if (8 == index ) {

		//cirle_color = "#2effb2"

		//}

		//}

		//


		///遮罩
		let cir_com = this["Circirle" + index]

		// if (cir_com ) {

		// 	this["objcirle" + index].visible = true 

		// 	this["transcirle" + index].localRotation = Quaternion.Euler(0,0,now_angle)

		// 	let v = Math.floor(angle / 360 * 100) / 100

		// 	cir_com.fillPercent =  v

		// }





		// _shape.graphics.lineStyle(6, cirle_color)

		// _shape.graphics.drawArc(90, 90, 80, Mathf.PI / 180 * now_angle, Mathf.PI / 180 * Math.min(now_angle + angle); 360, false)

	}



	public UpdateOwnerTips() {


		if (!this.data) {

			return

		}

		if (this.data.stronghold_id == this.ts_crack_model.GetOwnerPosId()) {

			this._lb_tips.text = "当前"

			ResManager.GetInstance().SetImageSprite(this, this._img_tips, "tsCrack_asset", "uisksh_005", true)

			this._gp_tips.visible = true

		} else if (this.data.base_server_num == this.res_mgr.GetMainRoleVo().server_id) {

			this._lb_tips.text = "易夺回"

			ResManager.GetInstance().SetImageSprite(this, this._img_tips, "tsCrack_asset", "uisksh_006", true)

			this._gp_tips.visible = true

		} else {
			this._gp_tips.visible = false

		}

	}



	public DeleteMe() {
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._gp_server,
			this._Image1,
			this._lb_server,
			this._gp_name,
			this._Image2,
			this._lb_name,
			this._gp_con,
			this._img_stronghold,
			this._gp_con1,
			this._img_cirle,
			this._gp_cirle,
			this._cirle,
			this.cirle1,
			this.cirle2,
			this.cirle3,
			this.cirle4,
			this.cirle5,
			this.cirle6,
			this.cirle7,
			this.cirle8,
			this._lb_schedule,
			this._gp_tips,
			this._img_tips,
			this._lb_tips,
			this.speed,
			this.progress
		]
			= this.GetChildrenByNames([

				"_gp_server",
				"_Image1",
				"_lb_server",
				"_gp_name",
				"_Image2",
				"_lb_name",
				"_gp_con",
				"_img_stronghold",
				"_gp_con1",
				"_img_cirle",
				"_gp_cirle",
				"_cirle",
				"cirle1",
				"cirle2",
				"cirle3",
				"cirle4",
				"cirle5",
				"cirle6",
				"cirle7",
				"cirle8",
				"_lb_schedule",
				"_gp_tips",
				"_img_tips",
				"_lb_tips",
				"speed",
				"progress"
			])
	}
}
window["TSCrackStrongholdItem"] = TSCrackStrongholdItem