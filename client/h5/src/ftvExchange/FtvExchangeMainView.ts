import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { FtvExchangeGoodItem } from "./FtvExchangeGoodItem"
import { FtvExchangeItem } from "./FtvExchangeItem"

export class FtvExchangeMainView extends BaseItem1 {
	_img_titlebg: Laya.Image
	_img_timebg: Laya.Image
	_img_title: Laya.Image
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_gp_scroller: Laya.List
	_gp_goods: Laya.HBox
	_Label1: Laya.Label
	_gp_time: Laya.Box
	_lb_tips: Laya.Label
	_img_dec: Laya.Image
	_lb_dec: Laya.Label
	lb_des_2: Laya.HTMLDivElement
	CreateGoodsItem
	CreateItem
	CustomMehod
	InitEvent
	InitView
	LoadBg
	Local_DeleteMe
	Scr_Scroller1
	_Viewport1

	public constructor(parent?) {
		super(parent)


		this.base_file = "ftvExchange"
		this.layout_file = "FtvExchangeMainView"

		let model = CustomActivityModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine

		let info_ = null
		let data_ = null
		let item_list_ = []
		let goods_item_list_ = []
		let goods_info_list_ = null
		let exchange_list = null
		let timer_ = null
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {

			this.LoadBg()
			this.InitEvent()
			this.InitView()
		}

		this.LoadBg = () => {
			//this.RegisterMask(this._Viewport1)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_titlebg, GameResPath.GetIconJpg("ftvExchange", "uihd_czhl_001"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("ftvExchange", "uixxjb_012a"))

			if (!info_) {
				return
			}
			model.CloseACTRed(info_.base_type, info_.sub_type)
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			if (cfg && info_) {
				model.LoadCompontRes(this, cfg, "FtvExchangeMainView", info_.show_id)
			}
		}

		this.InitEvent = () => {
			if (!info_) {
				return
			}
			let base_type = info_.base_type
			let sub_type = info_.sub_type
			let updata_goods = (list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in list) {
					var v = list[_tmpi]
					for (let i in goods_info_list_) {

						if (v.type_id == Number(goods_info_list_[i][1])) {
							let count = goods_model.GetTypeGoodsNum(v.type_id)
							goods_item_list_[i].SetGoodsNum(count)
						}
					}
				}
			}
			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, updata_goods)

			let updata_view = (...new_args) => {
				let args = new_args
				if (args[0] == info_.base_type && args[1] == info_.sub_type) {
					this.InitView()
				}
			}
			this.BindEvent(model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, updata_view)

			let get_reward = (...new_args) => {
				let args = new_args
				if (args[0] == info_.base_type && args[1] == info_.sub_type) {
					let grade_info
					for ( let key  in data_.reward_list){
						if(data_.reward_list[key].grade == args[2].grade){
							grade_info = data_.reward_list[key]
							break
						}
					}
					let rewards = model.GetActReward(info_.base_type, info_.sub_type, grade_info.form_type, grade_info.reward)
					let cond = model.GetActCondition(base_type, sub_type, "data", grade_info.grade)
					if (cond && rewards.length > 0) {
						if (cond.rare && Number(cond.rare) >= 1) {
							if(args[2] && args[2].num){
								rewards[0][2] = args[2].num
							}
							let view = new CongratulationObtainView(rewards, 10)
							view.Open()
						} else {
							let [typeId, lock] = goods_model.GetMappingTypeId(rewards[0][0], rewards[0][1])
							let basic = goods_model.GetGoodsBasicByTypeId(typeId)
							if (basic) {
								Message.show("获得<font color='#b3ff48'>" + basic.goods_name + "x" + rewards[0][2] + "</font>")
							}
						}
					}
					this.InitView()
				}
			}
			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, get_reward)

		}

		this.InitView = () => {
			data_ = model.GetActData(info_.base_type, info_.sub_type)
			if (!data_) {
				return
			}
			if (typeof (info_.condition) == "string") {
				info_.condition = ErlangParser.GetInstance().Parse(info_.condition)
			}
			let sortfunc = (a?, b?) => {
				return a.grade < b.grade
			}
			table.sort(data_.reward_list, sortfunc)

			this.CreateItem()
			this.CreateGoodsItem()
			let [type_id, lock] = goods_model.GetMappingTypeId(goods_info_list_[0][0], goods_info_list_[0][1])
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			if (basic) {
				// this._lb_dec.text = "挂机、击败大妖均有机会掉落“" + basic.goods_name + "”,最后一天仅供兑换，不会掉落道具"
			}
			if(basic){
				let str = info_.desc.replace("@",basic.goods_name)
				this.lb_des_2.innerHTML = str
				if(PlatformManager.IsEyouPlatform()){
					this.lb_des_2.style.wordWrap= true
					this.lb_des_2.style.leading = 0.1
					this.lb_des_2.style.width = 600
				}
			}
			if (!timer_) {
				timer_ = model.LoadActTimer(this._gp_time, info_.etime,18,"#bffd7d",null,"#ffffff","活动剩余时间：")
			}
		}

		this.CreateGoodsItem = () => {
			if (goods_item_list_.length > 0) {
				for (let _tmpi in goods_item_list_) {
					var item = goods_item_list_[_tmpi]
					item.SetVisible(false)
				}
			}
			for (let _tmpi in info_.condition) {
				var v = info_.condition[_tmpi]
				if (v[0] == "goods_type") {
					goods_info_list_ = v[1]
				}
			}
			for (let index in goods_info_list_) {

				let item = goods_item_list_[index]
				if (!item) {
					item = new FtvExchangeGoodItem(this._gp_goods)
					item.Load()
					table.insert(goods_item_list_, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(goods_info_list_[index])
					item.SetSize(37, 37)
					let count = goods_model.GetTypeGoodsNum(goods_info_list_[index][1])
					item.SetGoodsNum(count)
					item.SetVisible(true)
					//LayoutRebuilder(this._gp_goods)
				}
				)
			}
		}

		this.CreateItem = () => {
			let data_list = data_.reward_list
			for (let i = 0; i < data_list.length; i++) {
				let v = data_list[i]
				v.base_type = info_.base_type
				v.sub_type = info_.sub_type
				v.show_id = info_.show_id
			}
			table.sort(data_list,(a?,b?)=>{
				if(a.status < b.status){
					return true
				}
				return false
			})
			if (!exchange_list) {
				exchange_list = new LoopScrowViewMgr()
				exchange_list.SetData(this._gp_scroller, FtvExchangeItem, data_list, LoopScrCon.Vertical)
			} else {
				exchange_list.replaceAll(data_list)
			}

		}

		this.CustomMehod = (index?, info?) => {
			info_ = info
		}

		this.Local_DeleteMe = () => {
			if (timer_) {
				timer_.DeleteMe()
			}
			if (goods_item_list_.length > 0) {
				for (let _tmpi in goods_item_list_) {
					var item = goods_item_list_[_tmpi]
					item.DeleteMe()
				}
				goods_item_list_ = []
			}
			if (exchange_list) {
				exchange_list.DeleteMe()
				exchange_list = null
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_titlebg,
			this._img_timebg,
			this._img_title,
			this._img_bg,
			this._Image1,
			this._gp_scroller,
			this._gp_goods,
			this._Label1,
			this._gp_time,
			this._lb_tips,
			this._img_dec,
			this._lb_dec,
			this.lb_des_2
		]
			= this.GetChildrenByNames([

				"_img_titlebg",
				"_img_timebg",
				"_img_title",
				"_img_bg",
				"_Image1",
				"_gp_scroller",
				"_gp_goods",
				"_Label1",
				"_gp_time",
				"_lb_tips",
				"_img_dec",
				"_lb_dec",
				"lb_des_2"
			])
		this.lb_des_2.style.fontSize = 18
		this.lb_des_2.style.color = "#bffd7d"
		this.lb_des_2.style.wordWrap = false
	}
}
window["FtvExchangeMainView"] = FtvExchangeMainView