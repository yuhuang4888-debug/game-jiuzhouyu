import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { Enum_UILayer } from "../common/LayerManager"
import { HtmlColorTxt } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { OutLineModel } from "../commonModel/OutLineModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Mathf } from "../util/Mathf"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { Alert, Alert_Type } from "../alert/Alert"
import { OpenFun } from "../common/OpenFun"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { OutLineRewardItemRenderer } from "./OutLineRewardItemRenderer"
import { OutLineTipsView } from "./OutLineTipsView"
import { WordManager } from "../common/WordManager"
import { EnumViewOrder, ViewOrderModel } from "../commonModel/ViewOrderModel"

export class OutLineView extends BaseView1 {
	CloseFunc
	InitEvent
	InitView
	SetRedemptionData
	UpdateExpGoodsNum

	loop_mgr

	public constructor() {
		super()
		this.base_file = "outline"
		this.layout_file = "OutLineView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = false
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.append_to_ctl_queue = true;
		this.not_show_item_use = true;

		let model = OutLineModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_OutLineModel = OutLineModel
		let local_GoodsModel = GoodsModel
		let role_mgr = RoleManager.GetInstance()

		//let sourceArr_ = null
		let expItem_ = null
		let hasShowTips_ = false
		model.show_view = true

		this.load_callback = () => {
			/*
			this.RegisterMask(this.rewardGp)
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.lvLb.size = 20
				this.curLvLb.size = 20
				this.timeLb.size = 20
				this.expLb.size = 20
				this.coinLb.size = 20
				this._Label1.size = 18
				this.tipsLb.size = 18
				this._Label2.size = 20
				SetSizeDelta(this._Label2, 100, 50)
			}
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.lvLb.size = 20
				this.curLvLb.size = 20
				this.timeLb.size = 20
				this.expLb.size = 20
				this.coinLb.size = 20
				this._Label1.size = 18
				this.tipsLb.size = 18
				this._Label2.size = 20
				SetSizeDelta(this._Label2, 100, 50)
				this.labelDisplay11.size = 15
				this.labelDisplay.size = 15
				let csf = this.bagLb.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this.bagLb, 450)
				this.bagLb.size = 18
				this.bagLb.lineSpacing = 0.7
			}
			if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
				this._Label2.size = 18
			}
			if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
				this.labelDisplay.size = 18
				this.tipsLb.size = 18
			}
			*/
			
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("outline", "ui_content_bg2"))
			this._gp_goods.scrollBar.visible = false

			this._lb_time.style.fontSize = 22
			this._lb_time.style.color = "#663915"
			this._lb_time.style.wordWrap = false

			this._lb_tips.style.fontSize = 22
			this._lb_tips.style.color = "#ff9015"
			this._lb_tips.style.wordWrap = false

			this._lb_predict.style.fontSize = 22
			this._lb_predict.style.color = "#663915"
			this._lb_predict.style.wordWrap = false

			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.CloseFunc()
		}

		this.close_callback = () => {
			model.show_view = false
			/* ViewOrderModel.GetInstance().OpenNextTypeView(EnumViewOrder.eOutLine); */
		}

		this.InitEvent = () => {
			let CloseView = () => {
				this.Close()
			}
			Util.AddClickEvent(this._btn_confirm, CloseView, this, true)
			Util.AddClickEvent(this._btn_close, CloseView, this, true)

			let Retrieve = (count?) => {
				if (model.ol_award_dic && model.ol_award_dic.back_count > 0) {
					let needBuyCount = count - goods_model.GetTypeGoodsNum(model.exp_goods_type)
					if (needBuyCount <= 0) {
						model.Fire(local_OutLineModel.REQUEST_PROTO, 13213, "i", count)
					} else {
						let priceCfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price[model.exp_goods_type]
						if (priceCfg) {
							let size = 22
							// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
							// 	size = 18
							// }
							let view = new OutLineTipsView(Util.StrToHTML("需要消耗" + local_GoodsModel.GetGoodsNameWithColorDark(model.exp_goods_type) + "*" + needBuyCount + "<br>可消耗" + needBuyCount * priceCfg.price + "勾玉或绑定勾玉补齐，优先消耗绑定勾玉。"), Alert_Type.Two, () => {
								let jin_lock = role_mgr.GetMainRoleVo().jinLock
								let jin = role_mgr.GetMainRoleVo().jin
								let cost_count = needBuyCount * priceCfg.price
								if (jin + jin_lock < cost_count) {
									Alert.Show("勾玉数量不足，是否进行充值？", Alert_Type.Two, () => {
										OpenFun.OpenFunHandler(21)
									})
								} else {
									model.Fire(local_OutLineModel.REQUEST_PROTO, 13213, "i", count)
								}
							}, null, null, null, null, null, null, null, null, null, null, null, model.exp_goods_type)
							view.Open()
						}
					}
				}
			}
			Util.AddClickEvent(this._btn_one, () => {
				Retrieve(1)
			}, this, true)

			Util.AddClickEvent(this._btn_all, () => {
				if (model.ol_award_dic.back_count && model.ol_award_dic.back_count > 0) {
					Retrieve(model.ol_award_dic.back_count)
				}
			}, this, true)

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_BAG_LIST, () => {
				if (this.use_delete_method) {
					return
				}
				this.UpdateExpGoodsNum()
			})

			this.BindEvent(model, local_OutLineModel.UPDATE_REDEMPTION_INFO, () => {
				this.SetRedemptionData()
			})
		}

		this.InitView = () => {
			//经验 绑钻 其他物品（品质排序） 装备（品质排序）
			let originalData = model.ol_award_dic["goods_list"]
			let data = []
			let equip_data = []
			let total_data = []
			let i = 0
			if (i < originalData.length) {
				do {
					let [type_id, lock] = goods_model.GetMappingTypeId(originalData[i].type, originalData[i].goods_id)
					let goodInfo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goodInfo && goodInfo.type == 10) {
						let j = 0
						if (j < originalData[i].num) {
							do {
								table.insert(equip_data, { type: originalData[i].type, goods_id: originalData[i].goods_id, num: 1, color: goodInfo.color })
								j = j + 1
							} while ((j < originalData[i].num))
						}
						//} else if ((goodInfo && goodInfo.type == 38) && goodInfo.subtype == 11 ) {
						//table.insert(total_data, originalData[i])
					} else if ((originalData[i].type == 5)) {
						originalData[i].index = 1
						table.unshift(total_data, originalData[i])
					} else if (goodInfo && goodInfo.type == 36 && goodInfo.subtype == 2) {
						originalData[i].index = 2
						table.insert(total_data, originalData[i])
					} else if ((originalData[i].type == 3 || originalData[i].type == 2)) {
						originalData[i].index = 3
						table.insert(total_data, originalData[i])
					} else if (goodInfo) {
						originalData[i].color = goodInfo.color
						table.insert(data, originalData[i])
					}
					i = i + 1
				} while ((i < originalData.length))
			}
			table.sort(total_data, (a, b) => {
				return a.index < b.index
			})
			table.sort(equip_data, (v2?, v1?) => {
				return v1.color < v2.color
			})
			table.sort(data, (v2?, v1?) => {
				return v1.color < v2.color
			})
			total_data = total_data.concat(data.concat(equip_data))
			//sourceArr_ = eui. new ArrayCollection()
			//sourceArr_.source = total_data
			//this.rewardGp.itemRenderer = OutLineRewardItemRenderer
			//this.rewardGp.dataProvider = sourceArr_
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._gp_goods, OutLineRewardItemRenderer, total_data, LoopScrCon.Horizontal, 1)
			this.noLabel.visible = total_data.length == 0
			let lv = model.ol_award_dic["off_lv"]
			let level = (lv > 370 && ("神创" + ((lv - 370))) || ("Lv." + lv))
			this._lb_lv.text = "角色等级：" + level
			if (role_mgr.GetMainRoleVo().level > model.ol_award_dic["off_lv"]) {
				let lv = role_mgr.GetMainRoleVo().level > 370 ? ("神创" + (role_mgr.GetMainRoleVo().level - 370)) : ("Lv." + role_mgr.GetMainRoleVo().level)
				this._lb_curlv.text = lv
			} else {
				this._lb_curlv.visible = false
				this._img_arrow.visible = false
			}

			let time = model.ol_award_dic["cost_afk_time"]
			let day = Mathf.Floor(time / 86400)
			time = time % 86400
			let hour = Mathf.Floor(time / 3600)
			time = time % 3600
			let minute = Mathf.Floor(time / 60)
			let second = time % 60
			let str = "离线挂机时间：<font color='#0a953e'>"
			if (day != 0) {
				str = str + day + "天"
			}
			if (hour != 0) {
				str = str + hour + "小时"
			}
			if (minute != 0) {
				str = str + minute + "分"
			}
			if (second != 0) {
				str = str + second + "秒"
			}
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	str = str + "</font>"
			// } else {
			str = str + "(剩余" + TimeUtil.timeConvert(model.ol_award_dic["afk_time"], "dd-hh/hh-mm/mm-ss") + ")</font>"
			// }
			this._lb_time.innerHTML = Util.StrToHTML(str)
			if (GoodsModel.GetInstance().bag_goods_max_cell - GoodsModel.GetInstance().GetGoodsBagCount() > 0) {
				this._lb_bag.text = ""
			} else {
				this._lb_bag.text = "消耗神秘包裹可扩展背包容量"
			}
			model.ol_award_dic["exp"] = 0
			model.ol_award_dic["coin"] = 0
			for (let k in model.ol_award_dic.goods_list) {
				var v = model.ol_award_dic.goods_list[k]
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(v.type, v.goods_id)
				if (type == 32) {
					model.ol_award_dic["exp"] = WordManager.ConvertNum(v.num)
				} else if (type == 31) {
					model.ol_award_dic["coin"] = v.num
				}
			}
			this._lb_exp.text = "获得经验：" + model.ol_award_dic["exp"]
			this._lb_coin.text = "获得铜币：" + model.ol_award_dic["coin"]
			this.SetRedemptionData()
			//this:AddUIEffect2("ui_aperture", this.effectGp, null, null, true)
		}

		this.UpdateExpGoodsNum = () => {
			if (model.ol_award_dic) {
				let goodsNum = goods_model.GetTypeGoodsNum(model.exp_goods_type)
				if (model.ol_award_dic.back_count > 0) {
					this._lb_costnum.text = goodsNum + "/" + model.ol_award_dic.back_count
					this._lb_costnum.color = goodsNum >= model.ol_award_dic.back_count ? ("#aaff71") : ("#ff4949")
				} else {
					this._lb_costnum.text = ""
				}
			}
		}

		this.SetRedemptionData = () => {
			//hasShowTips_ = false
			//model.ol_award_dic.back_count = 0
			if (model.ol_award_dic && (model.ol_award_dic.back_count > 0 || model.ol_award_dic.back_count == 0 && hasShowTips_)) {
				this.display_obj.height = 721
				// SetSizeDeltaY(this.BGImg, 781)
				// SetSizeDeltaX(this.BGImg, 629)
				// SetAnchoredPosition(this.confirmBtn, this.confirmBtn.anchoredPosition.x, -670)
				// SetSizeDeltaY(this.form, 822)
				//this.BGImg.height = 606
				//this.confirmBtn.y = 625
				//this.form.height = 712
				this._gp_tips.visible = true
				this._lb_tips.innerHTML = Util.StrToHTML("tips：您有<font color='#0a953e'>" + model.ol_award_dic.back_count + "</font>小时离线挂机未享受经验符加成。")
				let exp1 = "已全部找回"
				if (model.ol_award_dic.back_exp > 0) {
					exp1 = model.ol_award_dic.back_exp
				}
				this._lb_predict.innerHTML = Util.StrToHTML("预计额外经验：<font color='#0a953e'>" + exp1 + "</font>")
				let outline = model.GetOutlineFindData()
				let exp = 0
				if (outline && outline.get_exp) {
					exp = outline.get_exp
				}
				this._lb_extra.text = "额外找回经验：" + exp
				if (!expItem_) {
					expItem_ = new BaseAwardItem(this._gp_cost)
					expItem_.Load()
					expItem_.SetItemSize(80, 80)
					expItem_.SetData(model.exp_goods_type)
				}
				//SetLocalPositionZ(this.costLb,1)
				this.UpdateExpGoodsNum()
				hasShowTips_ = true
				if (model.ol_award_dic.back_count == 0) {
					// Util.SetImageGray(this._Image1, true)
					// Util.SetImageGray(this._Image1111, true)
					// this.OutlabelDisplay11.effectColor = Color(144 / 255, 144 / 255, 144 / 255, 128 / 255)
				}
				//ResManager.GetInstance().SetOutsideImageSprite(this, this.BGImg, GameResPath.GetIcon("outline", "uixrw_001a"))
			} else if (!hasShowTips_) {
				this._gp_tips.visible = false
				this.display_obj.height = 500
				//this.BGImg.height = 372
				//this.confirmBtn.y = 390
				//this.form.height = 712
				// SetAnchoredPosition(this.confirmBtn, this.confirmBtn.anchoredPosition.x, -429)
				// SetSizeDeltaY(this.form, 782)
				// ResManager.GetInstance().SetOutsideImageSprite(this, this.BGImg, GameResPath.GetIcon("outline", "uixrw_001b"))
				// SetSizeDeltaY(this.BGImg, 555)
				// SetSizeDeltaX(this.BGImg, 636)
				// SetAnchoredPosition(this._Scroller1, this._Scroller1.anchoredPosition.x, 58)
				// SetAnchoredPosition(this._Image6, this._Image6.anchoredPosition.x, 260)
			}
		}

		this.CloseFunc = () => {
			if (expItem_) {
				expItem_.DeleteMe()
				expItem_ = null
			}
		}
	}

	_img_bg1: Laya.Image
	_img_title: Laya.Image
	_btn_close: Laya.Image
	_gp_up: Laya.Box
	_img_bg2: Laya.Image
	_lb_time: Laya.HTMLDivElement
	_gp_lv: Laya.HBox
	_lb_lv: Laya.Label
	_img_arrow: Laya.Image
	_lb_curlv: Laya.Label
	_lb_exp: Laya.Label
	_lb_coin: Laya.Label
	_lb_goods: Laya.Label
	_gp_goods: Laya.List
	_lb_bag: Laya.Label
	_gp_tips: Laya.Box
	_img_bg3: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_lb_predict: Laya.HTMLDivElement
	_lb_extra: Laya.Label
	_gp_cost: Laya.Box
	_lb_costnum: Laya.Label
	_btn_one: Laya.Box
	_img_one: Laya.Image
	_lb_one: Laya.Label
	_btn_all: Laya.Box
	_img_all: Laya.Image
	_lb_all: Laya.Label
	_lb_cost: Laya.Label
	_btn_confirm: Laya.Box
	_img_confirm: Laya.Image
	_lb_confirm: Laya.Label
	noLabel: Laya.Label
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._img_bg1,
			this._img_title,
			this._btn_close,
			this._gp_up,
			this._img_bg2,
			this._lb_time,
			this._gp_lv,
			this._lb_lv,
			this._img_arrow,
			this._lb_curlv,
			this._lb_exp,
			this._lb_coin,
			this._lb_goods,
			this._gp_goods,
			this._lb_bag,
			this._gp_tips,
			this._img_bg3,
			this._lb_tips,
			this._lb_predict,
			this._lb_extra,
			this._gp_cost,
			this._lb_costnum,
			this._btn_one,
			this._img_one,
			this._lb_one,
			this._btn_all,
			this._img_all,
			this._lb_all,
			this._lb_cost,
			this._btn_confirm,
			this._img_confirm,
			this._lb_confirm,
			this.noLabel,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_img_bg1",
				"_img_title",
				"_btn_close",
				"_gp_up",
				"_img_bg2",
				"_lb_time",
				"_gp_lv",
				"_lb_lv",
				"_img_arrow",
				"_lb_curlv",
				"_lb_exp",
				"_lb_coin",
				"_lb_goods",
				"_gp_goods",
				"_lb_bag",
				"_gp_tips",
				"_img_bg3",
				"_lb_tips",
				"_lb_predict",
				"_lb_extra",
				"_gp_cost",
				"_lb_costnum",
				"_btn_one",
				"_img_one",
				"_lb_one",
				"_btn_all",
				"_img_all",
				"_lb_all",
				"_lb_cost",
				"_btn_confirm",
				"_img_confirm",
				"_lb_confirm",
				"noLabel",
				"_gp_effect",
			])
	}
}
window["OutLineView"] = OutLineView