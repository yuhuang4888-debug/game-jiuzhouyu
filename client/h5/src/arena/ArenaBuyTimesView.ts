import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { VipModel } from "../commonModel/VipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { HtmlColorTxt, Util } from "../util/Util"
import { GameResPath } from "../util/GameResPath"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { PlatformManager } from "../PlatformManager"

export class ArenaBuyTimesView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_msg: Laya.HTMLDivElement
	_Image9: Laya.Image
	_Label1: Laya.Label
	_btn_cancal: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_btn_ok: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	_Group1: Laya.HBox
	_group_left: Laya.Box
	_Image4: Laya.Image
	_img_lvip: Laya.Image
	_lb_lcount: Laya.HTMLDivElement
	_Image5: Laya.Image
	_img_arrow: Laya.Image
	_group_right: Laya.Box
	_Image6: Laya.Image
	_img_rvip: Laya.Image
	_lb_rcount: Laya.HTMLDivElement
	_Group2: Laya.Box
	_Image7: Laya.Image
	_Label2: Laya.Label
	_Image8: Laya.Image
	_btn_close:Laya.Image
	_Image10:Laya.Image
	Emp_btn_cancal
	Emp_btn_ok
	InitEvent
	Open
	UpdateView
	_lb_ok

	can_buy_times
	click_bg_toClose
	destroy_imm
	is_center
	is_vip_over
	moudle_id
	open_callback
	use_background

	public constructor() {
		super()


		this.base_file = "arena"
		this.layout_file = "ArenaBuyTimesView"
		//this.dependent_res = ["dungeonCommon"]
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.can_buy_times = null
		this.moudle_id = null
		this.is_vip_over = false

		let model = ArenaModel.GetInstance()
		let local_ArenaModel = ArenaModel
		let vip_model = VipModel.GetInstance()
		this.preload_server_config={
			"config_jjc_buy_num":false
		}

		this.load_callback = () => {

			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_lcount.size  = 18
			// 	this._lb_rcount.size  = 18
			// 	this._lb_msg.size  = 18
			// }
			ResManager.GetInstance().SetTexture(this,this._Image10,GameResPath.GetIcon("arena","com_tips"),null,null,true)
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_cancal, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_ok, () => {
				if (this.moudle_id == local_ArenaModel.MOUDLE_ID.Arena) {
					if (this.is_vip_over) {
						OpenFun.OpenFunHandler(23)
						this.Close()
					} else {
						model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 28005, 1)
					}
				} else if (this.moudle_id == local_ArenaModel.MOUDLE_ID.DuelArena) {
					model.Fire(local_ArenaModel.REQUEST_CCMD_EVENT, 65308, 1)
				}
			}, this, true)

			this.BindVar(model, "times_info", (event_name?, value?, old_value?) => {
				if (this.moudle_id == local_ArenaModel.MOUDLE_ID.Arena) {
					this.can_buy_times = value.can_buy_num
					this.UpdateView()
				}
			}
			)
		}

		this.UpdateView = () => {
			let vip_card = vip_model.GetNobleCardState()
			let vip_flag = RoleManager.GetInstance().GetMainRoleVo().vip_flag
			this.is_vip_over = false
			//vip过期的处理
			if (vip_card == 0 ) {
				vip_card = 99
				this.is_vip_over = true
			}

			let now_total_count = vip_model.GetVipPrivilegeValue(this.moudle_id, 1, vip_card, vip_flag, true)

			let next_stage_vip = null
			let next_total_count = null

			for (let i = vip_flag + 1; i <= vip_model.max_vip_lv; i++) {
				next_total_count = vip_model.GetVipPrivilegeValue(this.moudle_id, 1, 99, i, true)
				if (next_total_count && next_total_count > now_total_count) {
					next_stage_vip = i
					break
				}
			}

			if (next_stage_vip) {
				this._group_left.x=-22
				this._img_arrow.visible = true
				this._group_right.visible = true
				this._lb_rcount.innerHTML = "每天能购买" +"<font color='#00b515'>"+ next_total_count + "</font>"+"次"
				ResManager.GetInstance().SetImageSprite(this, this._img_rvip, "arena_asset", "ui_vip_" + next_stage_vip, true)
			} else {
				this._group_left.x=70
				this._img_arrow.visible = false
				this._group_right.visible = false
			}

			ResManager.GetInstance().SetImageSprite(this, this._img_lvip, "arena_asset", "ui_vip_" + vip_flag, true)
			if(this.can_buy_times == 0){
				this._lb_lcount.innerHTML = "每天能购买" + `${HtmlColorTxt(this.can_buy_times, Enum_ColorUtil_Light.RED)}`  +"<font color='#00b515'>" + "/" + now_total_count +"</font>"+ "次"
			}else{
				this._lb_lcount.innerHTML = "每天能购买" +"<font color='#00b515'>" +this.can_buy_times + "/" + now_total_count +"</font>"+ "次"
			}


			let jjc_buy_num_cfg =this.preload_server_config["config_jjc_buy_num"]// ResManager.GetInstance().GetGameConfigFromCache(this, "Jjcbuynum", false)
			let price = null
			if (this.moudle_id == local_ArenaModel.MOUDLE_ID.Arena) {
				//购买价格索引 = 已购买次数 + 1
				let next_buy_index = now_total_count - this.can_buy_times + 1
				let cfg = jjc_buy_num_cfg[next_buy_index]
				price = cfg && cfg.price
			}
			if (this.is_vip_over) {
				this._lb_msg.innerHTML = "激活特权卡后即可消耗勾玉购买挑战次数"
				// this._lb_ok.text = "前往"
			} else if (price) {
				this._lb_msg.innerHTML = Util.StrToHTML("是否消耗<font color='#d15e00'>"+ price +"勾玉</font>购买<font color='#d15e00'> 1次</font>挑战次数（优先消耗绑玉）")// Util.StrToHTML("是否消耗<font color='#d15e00'>" + price + "钻石</font>购买<font color='#d15e00'> 1次</font>挑战次数（优先消耗绑钻）")
			} else {
				this._lb_msg.innerHTML = "已达到购买上限"
			}
			if(PlatformManager.IsEyouPlatform()){
				this._lb_msg.x = 53
				this._lb_msg.style.wordWrap = true
				this._lb_msg.style.width = 477
			}else{
			this._lb_msg.x=18+this._Image3.width/2-this._lb_msg.contextWidth/2
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				this.can_buy_times = parms[0]//可购买次数
				this.moudle_id = parms[1]//对应模块ID
			}
			super.Open()
		}


	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._lb_msg,
			this._Image9,
			this._Label1,
			this._btn_cancal,
			this._Image111,
			this.labelDisplay,
			this._btn_ok,
			this._Image11,
			this.labelDisplay1,
			this._Group1,
			this._group_left,
			this._Image4,
			this._img_lvip,
			this._lb_lcount,
			this._Image5,
			this._img_arrow,
			this._group_right,
			this._Image6,
			this._img_rvip,
			this._lb_rcount,
			this._Group2,
			this._Image7,
			this._Label2,
			this._Image8,
			this._btn_close,
			this._Image10
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_lb_msg",
				"_Image9",
				"_Label1",
				"_btn_cancal",
				"_Image111",
				"labelDisplay",
				"_btn_ok",
				"_Image11",
				"labelDisplay1",
				"_Group1",
				"_group_left",
				"_Image4",
				"_img_lvip",
				"_lb_lcount",
				"_Image5",
				"_img_arrow",
				"_group_right",
				"_Image6",
				"_img_rvip",
				"_lb_rcount",
				"_Group2",
				"_Image7",
				"_Label2",
				"_Image8",
				"_btn_close",
				"_Image10"
			])
		this._lb_msg.style.fontSize=20
		this._lb_msg.style.color="#663915"
		this._lb_msg.style.wordWrap=false
		this._lb_lcount.style.fontSize=18
		this._lb_lcount.style.color="#5e6382"
		this._lb_lcount.style.wordWrap=false
		this._lb_rcount.style.fontSize=18
		this._lb_rcount.style.color="#5e6382"
		this._lb_rcount.style.wordWrap=false
	}
}
window["ArenaBuyTimesView"]=ArenaBuyTimesView
