import { GoodsModel } from "../commonModel/GoodsModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseAwardItem } from "./BaseAwardItem"
import { BaseItem1 } from "./BaseItem1"
import { BaseItemRenderer } from "./BaseItemRenderer"
import { EquipmentItem } from "./EquipmentItem"
import { EventName } from "./EventName"
import { ResManager } from "./ResManager"
import { UIToolTipMgr } from "./UIToolTipMgr"

// TypeScript file
export class CongratulationObtainItem2 extends BaseItem1 {
	public gp_item: Laya.Box
	public gp_effect: Laya.Box
	public gp_award: Laya.Box
	public award_item: EquipmentItem
	public is_show_animation

	ct_cache
	data
	need_fresh
	constructor(parent) {
		super(parent)
		let self = this
		this.need_fresh = false
		this.data = []
		self.base_file = "common";
		self.layout_file = "CongratulationObtainItem";
		this.is_show_animation = true //是否播放动画和特效
		this.load_callback = () => {
			this.BindEvent(GlobalEventSystem, EventName.GET_GOODS_VIEW_STOP_ANIMATION, () => {
				this.is_show_animation = false
			})

			if (this.need_fresh) {
				this.need_fresh = false
				this.dataChanged()
			}

			if(this.ct_cache!=null){
				this.ct_cache
				this.gp_item.anchorX=this.ct_cache
				this.gp_item.anchorY=this.ct_cache
			}
		}

	}

	public dataChanged() {


		// if (this.is_show_animation) {
		// 	if (this.data[4]) {//20个之后，重新调整item的延时
		// 		let temp_num = this.data[5]
		// 		if (this.data[5] > 20) {
		// 			temp_num = this.data[5] % 5 + 5
		// 			if (temp_num == 5) {
		// 				temp_num = 5 + 5
		// 			}
		// 		}
		// 		Laya.timer.once(this.data[6] * temp_num, this, () => {
		// 			this.AddUIEffect("UI_partner_skillicon_02", this.gp_effect, null, 10, false, undefined, undefined)
		// 			Laya.timer.clearAll(this)
		// 		})
		// 		this.gp_award.scaleX = 0
		// 		this.gp_award.scaleY = 0
		// 		this.gp_award.alpha = 0
		// 		Laya.Tween.to(this.gp_award, { scaleX: 1, scaleY: 1, alpha: 1 }, this.data[6], null, Laya.Handler.create(this, () => {
		// 			Laya.Tween.clearAll(this.gp_award)
		// 		}), this.data[6] * temp_num)
		// 		this.data[4] = false
		// 	}
		// 	if (!this.award_item) {
		// 		this.award_item = new EquipmentItem(this.gp_award)
		// 		this.award_item.Load()
		// 	}
		// 	//this.SetData(this.data[0], this.data[1], this.data[2], this.data[3], this.data[4])

		// } else {
		// 	//this.SetData(this.data[0], this.data[1], this.data[2], this.data[3], this.data[4])
		// }

		if (!this.award_item) {
			this.award_item = new EquipmentItem(this.gp_award)
			this.award_item.Load()
		}
		this.award_item.SetItemSize(this.data[4], this.data[4])
		this.award_item.SetData(this.data[0], this.data[1], this.data[2])


		if (this.data[0]) {
			let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(this.data[0])
			if (goodsVo) {
				/*
				this.award_item.SetClickCallBack(() => {
					if (goodsVo.type == 10) {
						UIToolTipMgr.GetInstance().AppendEquipTips(type_id, null, null, goodsVo, null, { 1})
					} else if (goodsVo.type == UnrealModel.goods_type) {
						UIToolTipMgr.GetInstance().AppendUnrealTips(type_id, goodsVo, null, { UnrealToolTips.Btn.close })
					} else if (goodsVo.type == HolySealModel.GOODS_TYPE) {
						UIToolTipMgr.GetInstance().AppendHolySealTips(type_id, null, null, { HolySealToolTips.Btn.close })
					} else if (goodsVo.type == 39) {
						UIToolTipMgr.GetInstance().AppendGodBeastTips(goodsVo.type_id, null, null, goodsVo)
					} else if (goodsVo.type == 65) {
						UIToolTipMgr.GetInstance().AddBabyEquipToolTips(goodsVo.type_id, null, null, goodsVo)
					} else if (goodsVo.type == GodBefallDefine.EQUIP_TYPE) {
						UIToolTipMgr.GetInstance().AppendGodEquipTips(goodsVo.type_id, goodsVo)
					} else if (goodsVo.type == RevelationModel.GOODS_TYPE) {
						UIToolTipMgr.GetInstance().AppendRevelationTooltips(goodsVo.type_id, goodsVo)
					} else if (goodsVo.type == longlangModel.GOODS_TYPE) {
						UIToolTipMgr.GetInstance().AppendLongLangToolTips(goodsVo.type_id, goodsVo, null, { LonglangToolTips.Btn.close })
					} else if (goodsVo.type == starEquipModel.GOODS_TYPE && goodsVo.subtype < 11) {
						UIToolTipMgr.GetInstance().AppendStarEquipToolTips(goodsVo.type_id, goodsVo, null, { StarEquipToolTip.Btn.close })
					} else if (goodsVo.type == GodCourtModel.GoodsType && goodsVo.subtype < 17) {
						UIToolTipMgr.GetInstance().AppendGodCourtTips(goodsVo.type_id, goodsVo, null, { GodCourtTooltip.Btn.close })
					} else {
						UIToolTipMgr.GetInstance().AppendGoodsTips(type_id, null, null, goodsVo, null, null, this)
					}
				}
				)
				if (goodsVo.type == 26 && goodsVo.sub_type != 99) {
					this.award_item.SetStrengthen(goodsVo.level)
				}
				if (goodsVo.type == 65) {
					this.award_item.SetSkillImg(goodsVo.skill_id > 0)
				}
				*/
			}
		}

	}

	public SetData(type_id, goods_num, lock, goods_id?, item_size?) {
		this.data = [type_id, goods_num, lock, goods_id, item_size || 95]
		if (!this.is_loaded) {
			this.need_fresh = true
			return
		} else {
			this.need_fresh = false
			this.dataChanged()
		}
	}

	public PlayAnimation(scale, time_add) {
		// if (!this.gp_award) return
		// // this.gp_award_tween=Laya.Tween.to(this.gp_award,{ scaleX: scale, scaleY: scale, alpha: 0 }, 0).wait(time_add / 3).to({ scaleX: 1, scaleY: 1, alpha: 1 }, time_add / 2).call(() => {

		// // })
		// this.base_item.AddUIEffect("UI_partner_skillicon_02", this.gp_effect, null, 10, false, undefined, undefined)
		// Laya.Tween.to(this.gp_award, { scaleX: scale, scaleY: scale, alpha: 0 }, 0).to(this.gp_award, { scaleX: 1, scaleY: 1, alpha: 1 }, time_add / 2, null, null, time_add / 3)
		// // egret.Tween.get(this.gp_award).to({ alpha: 0 }, 0).wait(time_add / 3).to({ alpha: 1 }, time_add / 2).call(() => {/* egret.Tween.removeTweens(this.gp_award)*/ })
	}

	public AddEffect(scale) {
		this.AddUIEffect("ui_exposure_glow", this.gp_effect, null, scale, false)

	}

	public SetAlpha(num) {
		// this.gp_award.alpha = num
	}
	public DeleteMe() {
		if (this.gp_award)
			Laya.Tween.clearAll(this.gp_award)
		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		super.DeleteMe()
	}

	//添加额外图标
	public AddAdditionalImg() {
		let img = new Laya.Image()
		// img.source = "common2_json.additional_png"
		ResManager.GetInstance().SetTexture(this, img, `resource/game/common2/texture/additional.png`)
		this.award_item.ExcuteCallback(() => {
			this.award_item.click_group.addChild(img)
		})
		img.x = img.y = 7
	}


	public PlayAnimtion(timeMs?) {
		if (!this.gp_item) return
		Laya.Tween.clearAll(this.gp_item)
		this.gp_item.scale(0, 0)
		Laya.Tween.to(this.gp_item, { scaleX: 1, scaleY: 1 }, timeMs, Laya.Ease.sineInOut)
	}

	public StopAnimation() {
		if (!this.gp_item) return
		Laya.Tween.clearAll(this.gp_item)
		this.gp_item.scale(1, 1)
	}


	public SetAnchorXY(value?) {
		if(!this.is_loaded){
			this.ct_cache = value==null?0:value
			return
		}
		this.gp_item.anchorX=value
		this.gp_item.anchorY=value
	}


	public GetComponents() {
		[
			this.gp_item,
			this.gp_award,
			this.gp_effect,
		]
			= this.GetChildrenByNames([

				"gp_item",
				"gp_award",
				"gp_effect",
			])
	}
}
window["CongratulationObtainItem2"] = CongratulationObtainItem2