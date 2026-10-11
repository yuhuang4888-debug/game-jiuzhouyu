import "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import "../common/OpenFun"
import { Alert, Alert_Type } from "../alert/Alert"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Sprite } from "../scene/sceneobj/Sprite"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, NotEnougnDiamond } from "../util/Util"
import { OpenFun } from "../common/OpenFun"

export class PushGiftItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_Scroller1: Laya.Panel
	_gp_reward: Laya.HBox
	_gp_old: Laya.HBox
	_Text1: Laya.Label
	_lb_old: Laya.Label
	_cost_old: Laya.Image
	_Image1: Laya.Image
	_btn_buy: Laya.Image
	_lb_pass: Laya.Label
	_gp_new: Laya.HBox
	_lb_new: Laya.Label
	_cost_new: Laya.Image
	_img_null: Laya.Image
	_img_dis: Laya.Image
	_Image2: Laya.Image
	_gp_time: Laya.Box
	_lb_count: Laya.HTMLDivElement
	point_gp: Laya.Box
	big_num: Laya.Image
	small_num: Laya.Image
	Out_lb_new
	Out_lb_pass
	VHS_Scroller1
	_Viewport1

	act_model
	buy_all
	cost_type
	discount
	erlang
	goods_model
	is_show_sp
	limit_count
	model
	new_num
	old_num
	reward_list
	role_mgr
	sp_cond
	sp_list
	timer_


	needRefresh

	public WIDTH = 705
	public HEIGT = 242

	public constructor(parent) {
		super()

		this.base_file = "pushGift"
		this.layout_file = "PushGiftItem"
		// this.layer_value = Enum_UILayer.UI

		this.cost_type = null
		this.old_num = null
		this.new_num = null
		this.discount = 10
		this.limit_count = 1	//后台配置不填则默认为只能买一次
		this.buy_all = false
		this.reward_list = null
		this.timer_ = null
		this.needRefresh = false
		//this.sp_list = []
		//this.sp_cond = null
		//this.is_show_sp = null

		this.model = PushGiftModel.GetInstance()
		this.erlang = ErlangParser.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.act_model = CustomActivityModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		this.LoadSuccess()
	}

	public LoadSuccess() {
		let line = new Laya.Sprite()
		line.graphics.drawLine(0, 0, 130, 0, "#ff0000", 3)
		this._Image1.addChild(line)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("pushGift", "uizstg_00"), true)

		// this.RegisterMask(this._Viewport1, 2)
		// this.VHS_Scroller1.parentScroll = this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect))

		this.InitEvent()
		if (this.needRefresh) {
			this.dataChanged()
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_buy, () => {
			if (this.data) {
				//if (this.sp_cond && this.sp_cond == "currency" ) {
				//if (this.is_show_sp ) {
				//Message.show("未达到购买要求")
				//return
				//}
				//}

				if (!this.buy_all) {
					let tips_open = this.model.buy_tip_open
					let buy_request = () => {
						this.model.buy_tip_open = tips_open
						this.model.Fire(PushGiftModel.SCMD_REQUEST, 19103, this.data.gift_id, this.data.sub_id, this.data.grade_id)
					}

					let check_fun = () => {
						tips_open = !tips_open
					}

					let role_vo = this.role_mgr.mainRoleInfo
					let have_money = this.cost_type == 1 && role_vo.jin || role_vo.jinLock
					if (have_money >= this.new_num) {
						if (tips_open) {
							let cost_str = this.cost_type == 1 && "勾玉" || "绑定勾玉"
							Alert.Show("是否消耗<font color='#639c12'>" + this.new_num + cost_str + "</font>购买？", Alert_Type.AlertTypeCheckBox, buy_request, null, null, null, null, null, check_fun)
						} else {
							buy_request()
						}
					} else {
						if (this.cost_type == 1) {
							this.NotEnougnDiamond()
							return
						} else if (this.cost_type == 2) {
							let str = "绑定勾玉不足，是否消耗<font color='#639c12'>" + (this.new_num - role_vo.jinLock) + "勾玉</font>继续购买?"
							Alert.Show(str, Alert_Type.Two, buy_request)
							Alert.SetIsCharge(true)
						}
					}
				}


			}
		}, this, true)
	}

	public dataChanged() {

		if (!this.data) {
			return
		}

		if (!this.is_loaded) {
			this.needRefresh = true
			return
		}

		if (super.dataChanged) {
			//解析
			let cond = this.data.rewards_conditions
			let list = this.data.rewards
			if (typeof (cond) == "string") {
				cond = this.erlang.Parse(cond)
			}
			if (typeof (list) == "string") {
				list = this.erlang.Parse(list)
			}

			//获取信息
			for (let _tmpi in cond) {
				var sub_cond = cond[_tmpi]
				if (sub_cond[0] == "cost") {
					for (let k in sub_cond[1]) {
						var v = sub_cond[1][k]
						this.cost_type = Number(v[0])
						this.old_num = Number(v[2])
						break
					}
				} else if (sub_cond[0] == "cost_now") {
					for (let k in sub_cond[1]) {
						var v = sub_cond[1][k]
						this.new_num = Number(v[2])
						break
					}

				} else if (sub_cond[0] == "discount") {
					this.discount = Number(sub_cond[1])

				} else if (sub_cond[0] == "buy_cnt") {
					this.limit_count = Number(sub_cond[1])

					//} else if (sub_cond[1] == "buy_lim" ) {
					//if (sub_cond[2] == "currency" ) {
					//this.sp_cond = sub_cond[2]
					//let sp_cond_id = sub_cond[3][1]
					//this.sp_list[sp_cond_id] = this.sp_list[sp_cond_id] || {}
					//this.sp_list[sp_cond_id][1] = Number(sub_cond[3][2])
					//}
					//} else if (sub_cond[1] == "static_val" ) {
					//for (let _tmpi in sub_cond[2]) {
					var value = sub_cond[1][_tmpi]
					//let sp_cond_id = value[1]
					//this.sp_list[sp_cond_id] = this.sp_list[sp_cond_id] || {}
					//this.sp_list[sp_cond_id][2] = Number(value[2])
					//}

				}
			}

			//价格信息
			let [num, num_point] = CustomActivityModel.GetInstance().GetActDis(this.discount)
			this._img_dis.visible = num_point == 0
			this.point_gp.visible = num_point != 0
			if (num_point == 0) {
				ResManager.GetInstance().SetImageSprite(this, this._img_dis, "pushGift_asset", "uizstg_0" + this.discount)
			}
			else {
				ResManager.GetInstance().SetImageSprite(this, this.big_num, "pushGift_asset", "big0" + num)
				ResManager.GetInstance().SetImageSprite(this, this.small_num, "pushGift_asset", "small0" + num_point)
			}
			let img_icon = this.cost_type == 1 && "com_diamond" || "com_bind_diamond"
			ResManager.GetInstance().SetImageSprite(this, this._cost_old, "common_asset", img_icon)
			ResManager.GetInstance().SetImageSprite(this, this._cost_new, "common_asset", img_icon)
			this._lb_old.text = this.old_num
			this._lb_new.text = this.new_num

			//是否已购买
			this._lb_count.style.fontSize = 22
			this._lb_count.style.color = "#41342d"
			this._lb_count.innerHTML = Util.StrToHTML("<font color='#85512E'>限购：</font> " + "<font color='#00a22e'>" + this.data.buy_cnt + "/" + this.limit_count + "</font> ")
			this._lb_count.width = 200
			this.buy_all = this.data.buy_cnt >= this.limit_count
			Util.SetImageGray(this._btn_buy, this.buy_all)
			this._Image1.visible = !this.buy_all
			this._gp_time.visible = !this.buy_all
			this._gp_old.visible = !this.buy_all
			this._img_null.visible = this.buy_all
			this._btn_buy.visible = !this.buy_all

			// LayoutRebuilder(this._gp_old)
			// LayoutRebuilder(this._gp_new)

			//特殊条件检测
			//let cfg = Config.ConfigNotNormalGoods
			//let sp_name = ""
			//this.is_show_sp = false
			//this._lb_sp.text = ""
			//if (this.sp_cond ) {
			//for (let _i in this.sp_list) {
			// var _v = this.sp_list[_i]
			//if (_v[2] < _v[1] ) {
			//this.is_show_sp = true
			//sp_name = cfg[Number(_i)].desc
			//this._lb_sp.textFlow = Util.StrToHTML(sp_name + "（<font color=0xff4f50>" + _v[2] + "</font>/" + _v[1] + "）"

			//}
			//break
			//}
			//}

			//this._btn_buy.visible = ! this.is_show_sp 
			//this._gp_lock.visible = this.is_show_sp 

			//奖励列表
			if (!this.reward_list) {
				this.reward_list = []
			}
			if (this.reward_list && this.reward_list.length > 0) {
				for (let k in this.reward_list) {
					var item = this.reward_list[k]
					item.DeleteMe()
				}
				this.reward_list = []
			}
			for (let i = 0; i < list.length; i++) {
				var vo = list[i]
				let item = this.reward_list[i]
				if (!item) {
					item = new EquipmentItem(this._gp_reward, null, "UI")
					item.SetScale(0.65)
					// item.SetMaskId(2)
					// item.SetMaskRect(this.data.parent_mask)
					// item.SetPosition(i*127,0)
					item.Load()
					table.insert(this.reward_list, item)
				}
				let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
				let basic = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					item.ChangeCountVisible(true)
					item.SetData(type_id, vo[2])
					item.SetVisible(true)
				}
			}

			for (let i = list.length; i < this.reward_list.length; i++) {
				let item = this.reward_list[i]
				item.SetVisible(false)
			}
			console.log(this)
			//礼包时间
			if (!this.timer_) {
				this.timer_ = this.act_model.LoadActTimer(this._gp_time, this.data.end_time, 18, "#00a22e", null, null, "")
			}
		}


	}

	//清除界面
	public DeleteMe() {

		if (this.reward_list && this.reward_list.length > 0) {
			for (let k in this.reward_list) {
				var item = this.reward_list[k]
				item.DeleteMe()
			}
			this.reward_list = null
		}

		if (this.timer_) {
			this.timer_.DeleteMe()
			this.timer_ = null
		}
		super.DeleteMe()
	}

	public NotEnougnDiamond(text?, call_fun?) {
		if (PlatformManager.GetInstance().is_alpha) {
			let close_fun = () => { };
			let str = `您的绑定勾玉或勾玉不足`;
			Alert.Show(str, Alert_Type.One, close_fun, undefined, "确定");
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





	public GetComponents() {
		[
			this._img_bg,
			this._Scroller1,
			this._gp_reward,
			this._gp_old,
			this._Text1,
			this._lb_old,
			this._cost_old,
			this._Image1,
			this._btn_buy,
			this._lb_pass,
			this._gp_new,
			this._lb_new,
			this._cost_new,
			this._img_null,
			this._img_dis,
			this._Image2,
			this._gp_time,
			this._lb_count,
			this.point_gp,
			this.big_num,
			this.small_num,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Scroller1",
				"_gp_reward",
				"_gp_old",
				"_Text1",
				"_lb_old",
				"_cost_old",
				"_Image1",
				"_btn_buy",
				"_lb_pass",
				"_gp_new",
				"_lb_new",
				"_cost_new",
				"_img_null",
				"_img_dis",
				"_Image2",
				"_gp_time",
				"_lb_count",
				"point_gp",
				"big_num",
				"small_num",
			])
	}
}
window["PushGiftItem"] = PushGiftItem