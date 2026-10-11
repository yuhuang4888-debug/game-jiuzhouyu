import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalTimerQuest, Util, GetLocalPositionY, GetSizeDeltaY, SetLocalPositionY, NotEnougnDiamond, HtmlColorTxt } from "../util/Util"

export class MoneyTreeRewardView extends CongratulationObtainView {
	// _gp_view: Laya.Image
	_gp_borderglow_effect: Laya.Box
	click_bg: Laya.Image
	mainGp: Laya.Box
	_gp_blackline_effect: Laya.Box
	_gp_got_img: Laya.Box
	light: Laya.Image
	_img_item_bg_left: Laya.Image
	_img_item_bg_right: Laya.Image
	effect_group: Laya.Box
	right_bg: Laya.Image
	left_bg: Laya.Image
	_Image11: Laya.Image
	goods_scroller: Laya.Panel
	Content: Laya.VBox
	_gp_effect: Laya.Box
	_img_point: Laya.Image
	_gp_hit: Laya.VBox
	gp_gift: Laya.Box
	gp_gift_award: Laya.Box
	bt_use: Laya.Box
	// _Image1: Laya.Box
	labelDisplay: Laya.Label
	bt_use_ten: Laya.Box
	_Image111: Laya.Box
	labelDisplay1: Laya.Label
	// _Group1: Laya.Box
	bottom_label: Laya.Label
	stone_num: Laya.Label
	btn_group: Laya.HBox
	_Group2: Laya.Box
	oneBtn: Laya.Box
	oneBtnBg: Laya.Image
	free_conta: Laya.Label
	cost_conta: Laya.Box
	one_txt: Laya.Label
	one_cost: Laya.Label
	one_icon: Laya.Box
	_Group3: Laya.Box
	tenBtn: Laya.Box
	tenBtnBg: Laya.Image
	ten_txt: Laya.Label
	ten_cost: Laya.Label
	ten_icon: Laya.Box
	tenImg: Laya.Image
	fif_group: Laya.Box
	fifBtn: Laya.Box
	fifBtnBg: Laya.Image
	fif_text: Laya.Label
	fif_cost: Laya.Label
	fif_icon: Laya.Box
	fifImg: Laya.Image
	title: Laya.Image
	goods_list: Laya.List
	BtnClickFun
	CalculateItemNUM
	Empclick_bg
	EmponeBtn
	EmptenBtn
	InitEvent
	LoadCallback
	OpenCallback
	Scrgoods_scroller
	SetBtnState
	bag_list
	click_bg_toClose
	destroy_callback
	destroy_imm
	end_time
	goods_group
	open_callback
	total_count
	use_background

	public constructor(goods_data?, count_down?, effect_str?, award_type?, use_goods_id?, sohw_goods_effect?, specail_type?, point?, not_allow_anim?, data?, b?, s?, _cost?) {
		super(goods_data, count_down, effect_str, award_type, use_goods_id, sohw_goods_effect, specail_type, point, not_allow_anim)

		this.total_count = 0
		this.end_time = 0
		this.bag_list = []
		this.base_file = "moneyTree"
		this.layout_file = "MoneyTreeRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		// this.is_center=true
		let is_requesting = false
		let timeout_id_list = []



		let one_item_ = null
		let ten_item_ = null
		this.preload_server_config = {
			"config_goods_price": false
		}
		this.load_callback = () => {
			this.LoadCallback()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			if (timeout_id_list.length > 0) {
				for (let _tmpi in timeout_id_list) {
					var id = timeout_id_list[_tmpi]
					clearTimeout(id)
				}
				timeout_id_list = []
			}

			if (one_item_) {
				one_item_.DeleteMe()
				one_item_ = null
			}

			if (ten_item_) {
				ten_item_.DeleteMe()
				ten_item_ = null
			}
			// super.DeleteMe()
		}

		this.LoadCallback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this.one_txt.size = 22
			// 	this.ten_txt.size = 22
			// }
			ResManager.GetInstance().SetTexture(this, this.left_bg, "resource/game/common4/texture/uijs_062.png",null,this)
			this.btn_group.x=210
			super.LoadCallback()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.oneBtn, () => {
				this.BtnClickFun(1)
			}
				, this, true)
			Util.AddClickEvent(this.tenBtn, () => {
				this.BtnClickFun(10)
			}
				, this, true)
		}

		this.OpenCallback = () => {
			super.OpenCallback()
			if (!_cost) {
				return
			}
			this.SetBtnState()
		}

		this.CalculateItemNUM = () => {
			super.CalculateItemNUM()
			// let posy = GetLocalPositionY(this.right_bg) - GetSizeDeltaY(this.right_bg)
			// SetLocalPositionY(this.stone_num, posy - 3)
			// SetLocalPositionY(this.btn_group, posy - 27)
			// SetLocalPositionY(this._gp_hit, posy - 147)
		}

		this.SetBtnState = () => {
			let cost = _cost
			let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
			let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(type)
			if (!one_item_) {
				one_item_ = new BaseAwardItem(this.one_icon)
				one_item_.SetItemSize(40, 40)
				one_item_.Load()
				one_item_.SetItembgVisible(false)
				one_item_.SetShowTips(false)
			}
			one_item_.SetData(type)
			this.one_cost.text = my_have + "/1"
			if (!ten_item_) {
				ten_item_ = new BaseAwardItem(this.ten_icon)
				ten_item_.SetItemSize(40, 40)
				ten_item_.Load()
				ten_item_.SetItembgVisible(false)
				ten_item_.SetShowTips(false)
			}
			ten_item_.SetData(type)
			this.ten_cost.text = my_have + "/10"
			if(goods_data.length>1){
				this.btn_group.y=600
				this.bottom_label.y=650
			}else
			{
				this.btn_group.y=420
				this.bottom_label.y=470
			}
		}

		this.BtnClickFun = (count?) => {
			if (is_requesting) {
				Message.show("操作过快")
				return
			}
			let request = (is_auto_buy?) => {
				if (b != null) {
					let id = setTimeout(() => {
						is_requesting = false
					}
						, 1)
					table.insert(timeout_id_list, id)
					is_requesting = true
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33191, b, s, count, is_auto_buy)
					this.Close()
				}
			}

			let cost = _cost
			let c_model = CustomActivityModel.GetInstance()
			let goods_model = GoodsModel.GetInstance()
			let [type, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
			let have_num = goods_model.GetTypeGoodsNum(type)
			if (have_num < count) {
				let is_check = false
				let price_info = this.preload_server_config["config_goods_price"][Number(type)]
				if (!price_info) {
					return
				}
				let price = price_info.price
				let all_cost = (count - have_num) * price
				let openAlert = false
				let cost_func = () => {
					if (all_cost > RoleManager.GetInstance().mainRoleInfo.jin) {
						NotEnougnDiamond()
					} else {
						request(1)
					}
				}

				let is_openAlert = c_model.getKeyDicValue(b, s, "openAlert")
				if (!is_openAlert) {
					let ok_callback = () => {
						if (is_check) {
							c_model.setKeyDicValue(b, s, "openAlert", true)
						}
						cost_func()
					}

					let check_callback = () => {
						is_check = is_check && false || true
					}

					let basic = goods_model.GetGoodsBasicByTypeId(type)
					if (!basic) {
						return
					}
					let str = HtmlColorTxt(basic.goods_name, "'#639c12'") + "数量不足" + HtmlColorTxt(count + '个', "'#639c12'") + "<br/>是否消耗" + HtmlColorTxt(all_cost + '勾玉', "'#639c12'") + "自动购买"
					Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, check_callback)
				} else {
					cost_func()
				}
			}
		}
	}


	public GetComponents() {
		[
			this._gp_view,
			this._gp_borderglow_effect,
			this.click_bg,
			this.mainGp,
			this._gp_blackline_effect,
			this._gp_got_img,
			this.light,
			this._img_item_bg_left,
			this._img_item_bg_right,
			this.effect_group,
			this.right_bg,
			this.left_bg,
			this._Image11,
			this.goods_scroller,
			this.Content,
			this._gp_effect,
			this._img_point,
			this._gp_hit,
			this.gp_gift,
			this.gp_gift_award,
			this.bt_use,
			this._Image1,
			this.labelDisplay,
			this.bt_use_ten,
			this._Image111,
			this.labelDisplay1,
			this._Group1,
			this.bottom_label,
			this.stone_num,
			this.btn_group,
			this._Group2,
			this.oneBtn,
			this.oneBtnBg,
			this.free_conta,
			this.cost_conta,
			this.one_txt,
			this.one_cost,
			this.one_icon,
			this._Group3,
			this.tenBtn,
			this.tenBtnBg,
			this.ten_txt,
			this.ten_cost,
			this.ten_icon,
			this.tenImg,
			this.fif_group,
			this.fifBtn,
			this.fifBtnBg,
			this.fif_text,
			this.fif_cost,
			this.fif_icon,
			this.fifImg,
			this.title,
			this.goods_list
		]
			= this.GetChildrenByNames([

				"_gp_view",
				"_gp_borderglow_effect",
				"click_bg",
				"mainGp",
				"_gp_blackline_effect",
				"_gp_got_img",
				"light",
				"_img_item_bg_left",
				"_img_item_bg_right",
				"effect_group",
				"right_bg",
				"left_bg",
				"_Image11",
				"goods_scroller",
				"Content",
				"_gp_effect",
				"_img_point",
				"_gp_hit",
				"gp_gift",
				"gp_gift_award",
				"bt_use",
				"_Image1",
				"labelDisplay",
				"bt_use_ten",
				"_Image111",
				"labelDisplay1",
				"_Group1",
				"bottom_label",
				"stone_num",
				"btn_group",
				"_Group2",
				"oneBtn",
				"oneBtnBg",
				"free_conta",
				"cost_conta",
				"one_txt",
				"one_cost",
				"one_icon",
				"_Group3",
				"tenBtn",
				"tenBtnBg",
				"ten_txt",
				"ten_cost",
				"ten_icon",
				"tenImg",
				"fif_group",
				"fifBtn",
				"fifBtnBg",
				"fif_text",
				"fif_cost",
				"fif_icon",
				"fifImg",
				"title",
				"goods_list"
			])
		this.goods_list.scrollBar.visible=false
	}
}
window["MoneyTreeRewardView"]=MoneyTreeRewardView