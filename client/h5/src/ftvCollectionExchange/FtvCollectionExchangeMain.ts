import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { SetSizeDeltaX, SetAnchoredPositionY, Util } from "../util/Util";
import { FtvCollectionExchangeItem } from "./FtvCollectionExchangeItem";
import "./FtvBulkPurchaseView"
import { PlatformManager } from "../PlatformManager";

export class FtvCollectionExchangeMain extends BaseItem1 {
	public _img_titlebg: Laya.Image;
	public title_img: Laya.Image;
	public time_bg: Laya.Image;
	public _gp_time: Laya.Box;
	public _img_bg: Laya.Image;
	public _Scroller1
	public _gp_scroller: Laya.Box;
	public _lb_dec: Laya.Label;

	CreateItem
	CustomMehod
	InitView
	LoadSuccess
	Local_DeleteMe
	parent_mask_corner

	public constructor(parent?) {
		super(parent)

		this.base_file = "ftvCollectionExchange"
		this.layout_file = "FtvCollectionExchangeMain"
		let model = CustomActivityModel.GetInstance()
		let erlang_parser = ErlangParser.GetInstance()
		let info_ = null
		let grade_item_list_ = []
		let timer_ = null

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetImageSprite(this, this.title_img,"ftvCollectionExchange", "uihd_mrlc_004a")
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_titlebg,GameResPath.GetIcon("ftvCollectionExchange","uijzdh_001"))
			if (model.isCBPlatform()) {
				//lua_resM:SetTexture(this, this._img_titlebg, GameResPath.GetIconJpg("ftvCollectionExchange","uijzdh_001fc"))
			} else {
				// ResManager.GetInstance().SetTexture(this, this._img_titlebg, GameResPath.GetIconJpg("ftvCollectionExchange", "uijzdh_001"))
			}

			//let is_cb = (model.isCBPlatform() && ( true ) || ( false ) )
			//this.time_bg.visible = is_cb  
			//this.title_img.visible = is_cb  
			if (!info_) {
				return
			}
			model.CloseACTRed(info_.base_type, info_.sub_type)
			if (info_.desc) {
				this._lb_dec.text = info_.desc
			}
			this.InitView()
		}

		this.InitView = () => {
			let data = model.GetActData(info_.base_type, info_.sub_type)
			if (data && data.reward_list) {
				let sort_func = (a?, b?) => {
					return a.grade < b.grade
				}
				table.sort(data.reward_list, sort_func)
				this.CreateItem(data.reward_list)
			}
			timer_ = model.LoadActTimer(this._gp_time, info_.etime, 22, "#00fa64", null, "#00fa64", "",false,false)
		}

		this.CreateItem = (reward_list?) => {
			if (grade_item_list_.length > 0) {
				for (let _tmpi in grade_item_list_) {
					let item = grade_item_list_[_tmpi]
					item.visible = item.includeInLayout = false
				}
			}
			for (let i in reward_list) {
				if (typeof (reward_list[i].condition) == "string") {
					reward_list[i].condition = erlang_parser.Parse(reward_list[i].condition)
				}
				if (typeof (reward_list[i].reward) == "string") {
					reward_list[i].reward = erlang_parser.Parse(reward_list[i].reward)
				}
				let item = grade_item_list_[i]
				if (!item) {
					item = new FtvCollectionExchangeItem(this._gp_scroller)
					item.SetParentMask(this.parent_mask_corner)
					item.Load()
					table.insert(grade_item_list_, item)
				}
				item.ExcuteCallback(() => {
					item.SetData(info_.base_type, info_.sub_type, reward_list[i])
					// item.visible = item.includeInLayout = true
				}
				)
			}
		}

		this.CustomMehod = (index?, info?) => {
			info_ = info
		}

		this.Local_DeleteMe = () => {
			if (timer_) {
				timer_.DeleteMe()
			}
			if (grade_item_list_.length > 0) {
				for (let _tmpi in grade_item_list_) {
					let item = grade_item_list_[_tmpi]
					item.DeleteMe()
				}
				grade_item_list_ = []
			}
			super.DeleteMe()
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
	}

	public GetComponents() {
		[
			this._img_titlebg,
			this.title_img,
			this.time_bg,
			this._gp_time,
			this._img_bg,
			this._Scroller1,
			this._gp_scroller,
			this._lb_dec,
		]
			= this.GetChildrenByNames([

				"_img_titlebg",
				"title_img",
				"time_bg",
				"_gp_time",
				"_img_bg",
				"_Scroller1",
				"_gp_scroller",
				"_lb_dec",
			])

			this._Scroller1.vScrollBarSkin = ""
	}
}


window["FtvCollectionExchangeMain"]=FtvCollectionExchangeMain