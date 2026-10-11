
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: AuthorName
// Date: 2020-04-18 10.56:55
////////////////////////////////////////////////////////////////////-

import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { GoodsModel } from "../commonModel/GoodsModel"
// import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class BanquetGoodsItem
export class BanquetGoodsItem extends BaseItem1 {
	// BG
	CheckFree
	InitInfo
	SetData
	cfg
	// freeBtn
	// freeImg
	// freeLabel
	gType
	// goodsIcon
	// goodsName
	// heatLabel
	itemList
	// moneyBtn
	// moneyLabel
	// priceIcon
	// priceLabel
	// rewardGp
	// rewardLabel

	public constructor(parent?) {
		super(parent)


		this.base_file = "marriage2"
		this.layout_file = "BanquetGoodsItem"

		let local_BanqEvent = BanqEvent
		let goods_model:GoodsModel = GoodsModel.GetInstance()
		let model = BanquetModel.GetInstance()
		this.load_callback = () => {
			this.heatLabel.style.fontSize = 18;
			this.heatLabel.style.color = "#663915";
			this.heatLabel.style.wordWrap = false;
			this.InitInfo();
			// if (PlatformManager.GetInstance().IsEyouEnPlatform() ) {
			// 	let csf = this.rewardLabel.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDeltaX(this.rewardLabel,95)
			// 	SetAnchoredPosition(this.rewardLabel,37,-177)

			// 	SetAnchoredPositionX(this.heatLabel,19)
			// 	this.heatLabel.size  =18

			// 	SetAnchoredPositionX(this.moneyLabel,8)
			// }
		}

		this.InitInfo = () => {

			Util.AddClickEvent(this.freeBtn, () => {
				if (this.gType == 1) {
					model.Fire(local_BanqEvent.REQUET_PROTO, 17266, "c", 1)
				} else if (this.gType == 2) {
					model.Fire(local_BanqEvent.REQUET_PROTO, 17267, "c", 1)
				}
			}
				, this, true)
			Util.AddClickEvent(this.moneyBtn, () => {
				if (!this.cfg) {
					return
				}
				let cost = JSON.parse(this.cfg.cost_list)
				let enough = goods_model.CheckCoinEnough(Number(cost[0][0]), Number(cost[0][2]), true, () => {
					if (this.gType == 1) {
						if (this.cfg.candies_id == 8002003) {
							model.Fire(local_BanqEvent.REQUET_PROTO, 17266, "c", 1)
						} else {
							model.Fire(local_BanqEvent.REQUET_PROTO, 17266, "c", 2)
						}
					} else if (this.gType == 2) {
						model.Fire(local_BanqEvent.REQUET_PROTO, 17267, "c", this.cfg.fires_id)
					}
				}
				)
			}
				, this, true)
			this.BindEvent(model, local_BanqEvent.UPDATE_GOODS_INFO, (scmd?) => {
				if (this.cfg && this.cfg.free_times > 0) {
					this.CheckFree(this.cfg)
				}
			}
			)
		}

		this.SetData = (type?, goodsData?) => {
			this.gType = type
			this.cfg = goodsData
			if (!goodsData) {
				return
			}
			this.heatLabel.innerHTML = `婚礼气氛:${Util.HtmlColorTxt(goodsData.aura, "'#b33553'")}`;
			if (!this.itemList) {
				this.itemList = []
			}
			let reward = JSON.parse(goodsData.reward_list)
			if (reward) {
				let i = 0
				do {
					let item = this.itemList[i]
					if (!item) {
						item = new BaseAwardItem(this.rewardGp)
						item.Load()
						item.SetScale(0.4)
						this.itemList[i] = item
					}
					let arr = goods_model.GetMappingTypeId(reward[i][0], reward[i][1]);
					let type_id = arr[0], lock = arr[1]
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						item.SetData(goods_vo.type_id, reward[i][2])
					}
					i = i + 1
				} while ((i < reward.length)
				)
			}
			this.CheckFree(goodsData)
			if (type == 1) {//喜糖
				this.rewardLabel.text = "发放奖励:"
				this.moneyLabel.text = "发放"

				ResManager.GetInstance().SetImageSprite(this, this.goodsIcon,"marriage2", "uijh_" + goodsData.candies_id + "i")
				this.goodsIcon.x = this._Image1.width - this.goodsIcon.width >> 1;
				this.goodsIcon.y = this._Image1.height - this.goodsIcon.height >> 1;
				ResManager.GetInstance().SetImageSprite(this, this.titImg,"marriage2", "uijh_" + goodsData.candies_id + "n")
			} else if (type == 2) {//烟花
				this.rewardLabel.text = "庆祝奖励:"
				this.moneyLabel.text = "庆祝"
				ResManager.GetInstance().SetImageSprite(this, this.goodsIcon,"marriage2", "uijh_" + goodsData.fires_id + "i")
				this.goodsIcon.x = this._Image1.width - this.goodsIcon.width >> 1;
				this.goodsIcon.y = this._Image1.height - this.goodsIcon.height >> 1;
				ResManager.GetInstance().SetImageSprite(this, this.titImg,"marriage2", "uijh_" + goodsData.fires_id + "n");
				// ResManager.GetInstance().SetImageSprite(this, this.goodsName, "marriage2_asset", "uijh_" + goodsData.fires_id + "n", true)
			}
		}

		this.CheckFree = (goodsData?) => {
			if (Number(goodsData.free_times) > 0 && model.CheckFree(this.gType)) {
				this.freeBtn.visible = true
				this.moneyBtn.visible = false
				this.freeImg.visible = true
				this.freeLabel.text = "免费" + model.GetFreeCount(this.gType) + "次"
			} else {
				this.freeBtn.visible = false
				this.moneyBtn.visible = true
				this.freeImg.visible = false
				this.freeLabel.text = ""
				let cost = JSON.parse(goodsData.cost_list)
				if (cost && cost[0]) {
					let arr = goods_model.GetMappingTypeId(cost[0][0], cost[0][1]);
					let type_id = arr[0];
					let lock = arr[1];  
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						ResManager.GetInstance().SetOutsideImageSprite(this, this.priceIcon, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
					}
					this.priceLabel.text = cost[0][2]
				}
			}
		}
	}

	public DeleteMe() {

		if (this.itemList) {
			for (let _tmpi in this.itemList) {
				var vo = this.itemList[_tmpi]
				vo.DeleteMe()
				vo = null
			}
			this.itemList = null
		}
		this.UnBindEvents();
		super.DeleteMe();
	}



	BG: Laya.Image
	titImg: Laya.Image
	_Image1: Laya.Image
	goodsIcon: Laya.Image
	rewardLabel: Laya.Label
	heatLabel: Laya.HTMLDivElement
	rewardGp: Laya.Box
	freeBtn: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	moneyBtn: Laya.Box
	_Image3: Laya.Image
	moneyLabel: Laya.Label
	priceIcon: Laya.Image
	priceLabel: Laya.Label
	freeImg: Laya.Image
	freeLabel: Laya.Label
	public GetComponents() {
		[
			this.BG,
			this.titImg,
			this._Image1,
			this.goodsIcon,
			this.rewardLabel,
			this.heatLabel,
			this.rewardGp,
			this.freeBtn,
			this._Image2,
			this._Label1,
			this.moneyBtn,
			this._Image3,
			this.moneyLabel,
			this.priceIcon,
			this.priceLabel,
			this.freeImg,
			this.freeLabel,
		]
			= this.GetChildrenByNames([

				"BG",
				"titImg",
				"_Image1",
				"goodsIcon",
				"rewardLabel",
				"heatLabel",
				"rewardGp",
				"freeBtn",
				"_Image2",
				"_Label1",
				"moneyBtn",
				"_Image3",
				"moneyLabel",
				"priceIcon",
				"priceLabel",
				"freeImg",
				"freeLabel",
			])
	}
}
window["BanquetGoodsItem"] = BanquetGoodsItem