import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionY, Util, NotEnougnDiamond, SetSizeDeltaX } from "../util/Util"

export class PushGiftTips extends BaseView1 {
	Scr_Scroller1
	_Scroller1
	_Text1
	_Viewport1
	_btn_close
	_btn_go
	_gp_cost
	_gp_reward
	_gp_time
	_img_bg
	_img_go
	_img_zk
	_lb_desc
	_lb_go
	_lb_have
	act_model
	background_alpha
	change_scene_close
	click_bg_toClose
	cost_type
	data
	destroy_callback
	destroy_imm
	gift_id
	have_buy
	infos
	model
	new_num
	open_callback
	reward_list
	sub_id
	sub_info
	timer
	use_background
	cfg
	_img_null: Laya.Image


	public constructor() {
		super()

		this.base_file = "pushGift"
		this.layout_file = "PushGiftTips"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.background_alpha = 0.8
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.change_scene_close = false
		this.append_to_ctl_queue = true;
		this.gift_id = null
		this.sub_id = null
		this.data = null
		this.timer = null
		this.reward_list = null
		this.cost_type = null
		this.new_num = null
		this.have_buy = false

		this.model = PushGiftModel.GetInstance()
		this.act_model = CustomActivityModel.GetInstance()

		this.load_callback = () => {
			// ResManager.GetInstance().LoadGameConfig(this, "config_push_gift",false,undefined,(cfgs)=>{
			// 	this.cfg=cfgs
			// });
			this._lb_desc.lineSpacing = 1
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) { 
			// 	this._lb_desc.size  = 16	
			// 	this._lb_desc.lineSpacing = 0.8
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_desc.size  = 14
			// 	this._lb_desc.lineSpacing = 0.7
			// 	SetAnchoredPositionY(this._lb_desc,-347.5)
			// }
			this.InitView()
			this.InitEvent()
		}

		this.open_callback = () => {
			// this.RegisterMask(this._Viewport1)
			// this.InitView()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public InitView() {

		//背景图
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("pushGift", "uitslb_007"), true)

		this.data = this.model.GetGiftList(this.gift_id, this.sub_id)
		if (!this.data) {
			this.Close()
			return
		}

		//超时的直接关掉
		if (this.data.end_time <= TimeUtil.getServerTime()) {
			this.Close()
			return
		}

		//this.infos = this.data.infos
		//if (typeof(this.infos) == "string" ) {
		//this.infos = ErlangParser.GetInstance().Parse(this.infos)
		//}

		//礼包说明
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this._lb_desc.text = "Selamat! Anda telah menjadi lebih kuat. Berikut adalah hadiah dengan harga diskon yang dipersiapkan khusus untuk Anda! Ayo beli dan tingkatkan lagi CPmu dengan cepat!"
		// }else{
		// let cfg1 =ResManager.GetInstance().GetGameConfigFromCache(this, "config_push_gift", false)
		// let desc = cfg1[this.gift_id]
		// if (desc ) {
		// 	desc = desc.replace( "a", this.data.title_name)
		// 	desc = desc.replace( "b", this.data.gift_name)
		// 	this._lb_desc.text = desc
		// }

		// ResManager.GetInstance().LoadGameConfig(this, "config_push_gift", false, undefined, (cfgs) => {
		// 	this.cfg = cfgs
		// 	let desc = this.cfg[this.gift_id]
		// 	if (desc ) {
		// 		desc = desc.replace( "a", this.data.title_name)
		// 		desc = desc.replace( "b", this.data.gift_name)
		// 		this._lb_desc.text = desc
		// 	}
		// });

		// this._lb_desc.text="恭喜勇者等级突破，我们为你准备了等级礼包，帮助你快速提升战力"
		this.model.Fire(PushGiftModel.SCMD_REQUEST, 19102, this.gift_id, this.sub_id)
		// this:ShowReward()
		let str = "<font color='#663915'>礼包剩余时间：</font>"
		this.timer = this.act_model.LoadActTimer(this._gp_time, this.data.end_time, null, "#00a22e", null, null, str, 478)

	}

	public InitEvent() {

		let role_mgr = RoleManager.GetInstance()
		let gift_id = this.gift_id
		let sub_id = this.sub_id
		let check_can_buy = (r_data?) => {
			let limit_count = 1
			let cond = r_data.rewards_conditions
			if (typeof (cond) == "string") {
				cond = ErlangParser.GetInstance().Parse(cond)
			}
			for (let _tmpi in cond) {
				var sub_cond = cond[_tmpi]
				if (sub_cond[0] == "buy_cnt") {
					limit_count = Number(sub_cond[1])
				}
			}
			return r_data.buy_cnt < limit_count
		}


		Util.AddClickEvent(this._btn_go, () => {
			if (this.use_delete_method) { return }
			if (this.have_buy) {
				return
			}
			//没有超出购买时间
			if (this.data && this.data.end_time > TimeUtil.getServerTime()) {
				//确保model中已经拿到礼包的data数据
				let gift_data = this.model.GetGiftData(gift_id, sub_id)
				if (gift_data && gift_data.reward_list[0]) {
					let grade_data = gift_data.reward_list[0]
					let can_buy = check_can_buy(grade_data)
					if (grade_data && can_buy) {
						let buy_request = () => {
							this.model.Fire(PushGiftModel.SCMD_REQUEST, 19103, gift_id, sub_id, 1)
						}

						let role_vo = role_mgr.mainRoleInfo
						let have_money = this.cost_type == 1 && role_vo.jin || role_vo.jinLock
						if (have_money && this.new_num && have_money >= this.new_num) {
							let cost_str = this.cost_type == 1 && "勾玉" || "绑定勾玉"
							Alert.Show("是否消耗<font color='#639c12'>" + this.new_num + cost_str + "</font>购买？", Alert_Type.Two, buy_request)
						} else {
							if (this.cost_type == 1) {
								this.NotEnougnDiamond()
								return
							} else if (this.cost_type == 2) {
								let str = "绑定勾玉不足，是否消耗<font color='#639c12'>" + (this.new_num - role_vo.jinLock) + "勾玉</font>继续购买?"
								Alert.Show(str, Alert_Type.Two, buy_request)
							}
						}
					}

				}
			}
		}, this, true)

		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)


		this.BindEvent(this.model, PushGiftModel.BUY_SUCCESS, (...new_args) => {
			let args = new_args
			if (args[0] == gift_id && args[1] == sub_id) {
				let gift_data = this.model.GetGiftData(gift_id, sub_id)
				for (let i in gift_data.reward_list) {
					var v = gift_data.reward_list[i]
					if (v.grade_id == 1 && !check_can_buy(v)) {
						this._Text1.visible = false
						this._gp_cost.visible = false
						this._btn_go.visible = false
						this._img_null.visible = true
						this.have_buy = true
					}
				}

				let rewards = args[2]
				if (typeof (args[2]) == "string") {
					rewards = ErlangParser.GetInstance().Parse(args[2])
				}
				if (rewards) {
					new CongratulationObtainView(rewards, 10).Open()
				}
			}
		})

		this.BindEvent(this.model, PushGiftModel.UPDATE_VIEW, (...new_args) => {
			let args = new_args
			if (args[0] == gift_id && args[1] == sub_id) {
				this.sub_info = this.model.GetGiftData(gift_id, sub_id)
				if (this.sub_info) {
					let list = this.sub_info.reward_list
					for (let k in list) {
						var v = list[k]
						this.infos = v
						break
					}
					if (this.infos) {
						this.ShowPrice()
						this.ShowReward()
					}
				}
			}
		})

	}

	public NotEnougnDiamond(text?, call_fun?) {
		if (PlatformManager.GetInstance().is_alpha) {
			let close_fun = () => { };
			let str = `您的绑定勾玉或勾玉不足`;
			Alert.Show(str, Alert_Type.One, close_fun, undefined, "确定");
			Alert.SetIsCharge(true)
		}
		else {
			let ok_callback = () => {
				if (call_fun) {
					call_fun();
				}
				else {
					OpenFun.OpenFunHandler(21);
				}
			};
			let str = "";
			if (text) {
				str = text;
			}
			else {
				str = `勾玉不足，是否前往充值`;
			}
			Alert.Show(str, Alert_Type.Two, ok_callback);
		}
	}

	public ShowPrice() {

		let cond = this.infos.rewards_conditions
		if (typeof (cond) == "string") {
			cond = ErlangParser.GetInstance().Parse(cond)
		}
		for (let _tmpi in cond) {
			var sub_cond = cond[_tmpi]
			if (sub_cond[0] == "discount") {
				//折扣图片
				ResManager.GetInstance().SetImageSprite(this, this._img_zk, "pushGift_asset", "uitslb_002a" + sub_cond[1], true)
			} else if (sub_cond[0] == "cost_now") {
				//价格
				for (let k in sub_cond[1]) {
					var v = sub_cond[1][k]
					//图
					this.cost_type = Number(v[0])
					let img_icon = this.cost_type == 1 && "com_diamond" || "com_bind_diamond"
					ResManager.GetInstance().SetImageSprite(this, this._img_go, "common_asset", img_icon)
					//数
					this.new_num = Number(v[2])
					this._lb_go.text = v[2]
					break
				}
				// LayoutRebuilder(this._gp_cost)
			}
		}
	}

	public ShowReward() {

		if (!this.reward_list) {
			this.reward_list = []
		}

		let list = this.infos.rewards
		if (typeof (list) == "string") {
			list = ErlangParser.GetInstance().Parse(list)
		}
		// Laya.timer.frameOnce(1,this,()=>{
		if (list.length > 0) {
			let len = list.length
			let scr_width = Math.min(379, 82 * len + 10 * (len - 1))
			SetSizeDeltaX(this._Scroller1, scr_width)
			// this._Scroller1.centerX=80
			// this._Scroller1.callLater(()=>{
			// this._Scroller1.refresh()
			// })
		}
		// })

		for (let i = 0; i < list.length; i++) {
			var vo = list[i]
			let item = this.reward_list[i]
			if (!item) {
				item = new EquipmentItem(this._gp_reward, null, "Activity")
				item.SetScale(0.65)
				// item.SetMaskId(1)
				item.Load()
				table.insert(this.reward_list, item)
			}
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(vo[1])
			if (basic) {
				item.SetData(vo[1], vo[2])
			}
		}
	}

	public SetData(gift_id?, sub_id?) {

		this.gift_id = Number(gift_id)
		this.sub_id = Number(sub_id)
	}

	public Open(gift_id?, sub_id?) {
		this.gift_id = Number(gift_id)
		this.sub_id = Number(sub_id)
		super.Open()
	}

	public Remove() {

		this.have_buy = false
		if (this.timer) {
			this.timer.DeleteMe()
		}

		if (this.reward_list && this.reward_list.length > 0) {
			for (let i in this.reward_list) {
				var item = this.reward_list[i]
				item.DeleteMe()
			}
			this.reward_list = null
		}
	}


	_Image1: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._btn_close,
			this._img_zk,
			this._Image1,
			this._lb_desc,
			this._Scroller1,
			this._gp_reward,
			this._btn_go,
			this._Text1,
			this._gp_cost,
			this._lb_go,
			this._img_go,
			this._lb_have,
			this._gp_time,
			this._img_null
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_btn_close",
				"_img_zk",
				"_Image1",
				"_lb_desc",
				"_Scroller1",
				"_gp_reward",
				"_btn_go",
				"_Text1",
				"_gp_cost",
				"_lb_go",
				"_img_go",
				"_lb_have",
				"_gp_time",
				"_img_null"
			])
		this._Scroller1.hScrollBarSkin = ""
	}
}

window["PushGiftTips"] = PushGiftTips