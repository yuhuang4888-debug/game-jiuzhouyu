import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { SetSizeDeltaX, Util, HtmlColorTxt, SetSizeDelta } from "../util/Util";
import { DemonShopItem } from "./DemonShopItem";

export class DemonShopView extends BaseItem1 {
	_list
	click_btn
	demon_model: DemonModel
	role_mgr
	round_times
	ac_item
	list_loop_mgr

	public constructor(parent?) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonShopView"

		this.demon_model = DemonModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()

		this.preload_server_config = {
			"config_demons_skill_add": false
		}

		this.load_callback = () => {
			this.lb_desc.style.fontSize = 20
			this.lb_desc.style.color = "#663915"
			this.lb_desc2.style.fontSize = 20
			this.lb_desc2.style.color = "#663915"
			this._lb_cost.style.fontSize = 20
			this._lb_cost.style.color = "#663915"
			this._lb_cost.style.wordWrap = false
			this.LoadSuccess()
		}

		this.round_times = 10
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn, () => {
			if (this.click_btn) {
				return
			}

			let send = () => {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18313)
				this.click_btn = true
			}
			if (!this.demon_model._talenShopData) {
				return
			}
			let change_cost = this.demon_model._talenShopData.cost[0]
			if (change_cost) {
				let cost_count = change_cost.count
				if (this.role_mgr.mainRoleInfo.jin < cost_count) {
					Alert.Show("勾玉数量不足，是否进行充值", Alert_Type.Two, () => {
						OpenFun.OpenFunHandler(21)
					})
				} else {
					if (!this.demon_model.not_show_talent_shop_tips) {
						let demons_skill_add_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons_skill_add", false)
						let flag = this.demon_model.CheckShopRare(demons_skill_add_cfgs)
						if (flag) {
							Alert.Show("当前黑市中存在珍稀的天赋技能书，是否继续刷新？", Alert_Type.AlertTypeCheckBox, send, null, "确定", "取消", null, false, () => {
								this.demon_model.not_show_talent_shop_tips = true
							}, "本次登录不再提示")
						} else {
							send()
						}
					} else {
						send()
					}
				}
			}

		}, this, true)

		this.BindEvent(this.demon_model, DemonEvent.TALENT_SHOP_DATA_RETURN, () => {
			this.initItem()
			this.click_btn = false
		})
	}

	public DeleteMe() {
		this.click_btn = false
		super.DeleteMe()
	}

	public LoadSuccess() {
		this.lb_desc.width = 300
		ResManager.GetInstance().SetTexture(this, this.top_title, GameResPath.GetIcon("demon", "ui_servant_title1"))
		this.lb_desc.innerHTML = Util.StrToHTML("每天" + HtmlColorTxt("0", "'#0a953e'") + "点自动刷新商品")
		this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18311)

		if (!this.demon_model.talent_shop_first_open_tips) {
			this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18315)
		}

		this.InitEvent()
	}

	public initItem() {
		let data = this.demon_model._talenShopData
		let time = this.round_times - data.refresh_num
		this.lb_desc2.width = 400
		if (time <= 0) {
			this.lb_desc2.innerHTML = Util.StrToHTML("当前" + HtmlColorTxt("S", "'#0a953e'") + "级及以上技能书出现概率大大提高")
		} else {
			this.lb_desc2.innerHTML = Util.StrToHTML("再刷新" + HtmlColorTxt(time, "'#0a953e'") + "次" + HtmlColorTxt("S", "'#0a953e'") + "级技能书出现概率大大提高")
		}

		let data_list = data && this.demon_model._talenShopData.shop || []

		if (!this.list_loop_mgr) {
			// this.ac_item = new Laya.ArrayCollection(data_list);
			// this.Content.dataProvider = this.ac_item;
			// this.Content.itemRenderer = DemonShopItem;
			this.list_loop_mgr = new LoopScrowViewMgr()
			this.list_loop_mgr.SetData(this._Scroller1, DemonShopItem, data_list, LoopScrCon.Vertical,)
		} else {
			// this.ac_item.replaceAll(data_list);
			this.list_loop_mgr.replaceAll(data_list)
		}
		// this.Content.validateNow();

		let my = this.role_mgr.GetMainRoleVo().jin
		let need = data.cost[0] && data.cost[0].count
		if (!need) {
			need = 0
		}
		let color = my >= need ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.RED
		// this._lb_cost.width=200
		if (my > 9999) {
			// this._Group1.x-=38
		}
		this._lb_cost.innerHTML = Util.StrToHTML(HtmlColorTxt(my, color) + "/" + need)
	}



	top_title: Laya.Image
	line_1: Laya.Image
	line_2: Laya.Image
	_Scroller1: Laya.List
	_Image1: Laya.Image
	temp2: Laya.HBox
	_Image2: Laya.Image
	_lb_cost: Laya.HTMLDivElement
	_Group1: Laya.Box
	temp: Laya.Image
	_btn: Laya.Box
	_Image11: Laya.Image
	lb_desc: Laya.HTMLDivElement
	lb_desc2: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.top_title,
			this.line_1,
			this.line_2,
			this._Scroller1,
			this._Image1,
			this.temp2,
			this._Image2,
			this._lb_cost,
			this._Group1,
			this.temp,
			this._btn,
			this._Image11,
			this.lb_desc,
			this.lb_desc2,
		]
			= this.GetChildrenByNames([

				"top_title",
				"line_1",
				"line_2",
				"_Scroller1",
				"_Image1",
				"temp2",
				"_Image2",
				"_lb_cost",
				"_Group1",
				"temp",
				"_btn",
				"_Image11",
				"lb_desc",
				"lb_desc2",
			])
	}
}
window["DemonShopView"] = DemonShopView