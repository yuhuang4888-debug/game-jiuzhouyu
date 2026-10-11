import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { IllusionTips } from "../common/IllusionTips"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BagModel } from "../commonModel/BagModel"
import { EquipModel } from "../commonModel/EquipModel"
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { AtlasUrl, Util } from "../util/Util"

export class BagItemRenderer extends BaseItemRenderer {
	WIDTH = 88.9
	HEIGT = 88.9

	public conta: Laya.Box;
	public defaultImg: Laya.Image;
	public up: Laya.Image;
	public down: Laya.Image;
	public ban: Laya.Image;
	public grade: Laya.Label;
	public star_group: Laya.Box;
	public star_1: Laya.Image;
	public star_2: Laya.Image;
	public star_3: Laya.Image;
	public star_4: Laya.Image;
	public time_limit: Laya.Image;
	public lock: Laya.Image;
	public redMask: Laya.Image;
	public _bad_icon: Laya.Image;
	public group_eff: Laya.Box;


	resMgr: ResManager
	need_refresh
	ClickCallBack
	red_img: Laya.Image
	is_batch
	item
	binId
	data_cache

	public constructor() {
		super()
		this.base_file = "bag"
		this.layout_file = "bagItemRenderer"
		this.binId = null
		this.is_batch = false
		this.resMgr = ResManager.GetInstance()

		this.ClickCallBack = () => {
			this.ClickFunc()
		}

		this.Load()
	}

	public load_callback() {
		this.display_obj.scaleX = 0.7
		this.display_obj.scaleY = 0.7

		this.item = new BaseAwardItem(this.conta)
		this.item.Load()

		this.binId = GoodsModel.GetInstance().Bind(GoodsModel.REFRESH_COOLING_REDDOT, (goods_id?) => {
			if (goods_id == this.data.goods_id) {
				this.dataChanged()
			}
		}
		)
		Util.AddClickEvent(this.defaultImg, () => {
			if ((this.data && this.item) && this.data.color == -1) {
				this.ClickCallBack()
			}
		}, this, false)
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (this.data_cache && this.data_cache.type_id && this.data_cache.type_id == this.data.type_id && this.data_cache.goods_num == this.data.goods_num && this.data.bind == this.data_cache.bind) {
			this.RefreshEquipState()
			return
		} else {
			this.data_cache = { type_id: this.data.type_id, goods_num: this.data.goods_num, bind: this.data.bind }
		}
		this.item.SetData(this.data.type_id, this.data.goods_num, this.data.bind)
		if (this.data.color < 0) {
			this.item.SetVisible(false)
			this.defaultImg.visible = true
		} else {
			this.item.SetVisible(true)
			this.defaultImg.visible = false
		}
		this.item.ExcuteCallback(() => {
			if (this.use_delete_method) { return }
			this.lock.visible = this.data.color == -1
			this.RefreshEquipState()
			let red_state = false
			let global_event = GlobalEventSystem
			let goods_cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_goods", false)
			let equip_attr_cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
			let equip_fusion_cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_equip_fusion", false)
			let bagModel = BagModel.GetInstance()
			if ((this.data.type == 33 || this.data.type == 35) && !bagModel.has_show_red[this.data.goods_id]) {
				red_state = (this.data.type == 35 && (GoodsModel.GetInstance().coolingGoodsCanUse(this.data.goods_id)) || (true))
				this.item.SetClickCallBack(() => {
					if (this.data.call_back) {
						this.data.call_back()
					} else {
						this.ClickCallBack()
					}
					bagModel.has_show_red[this.data.goods_id] = true
					this.SetRedDot(false)
					let red = bagModel.ShowBagRed(goods_cfgs, equip_attr_cfgs, equip_fusion_cfgs)
					global_event.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BagView", BagModel.Index.Goods, red)
					// global_event.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
				}
				)
			} else {
				if (this.data.call_back) {
					this.item.SetClickCallBack(this.data.call_back)
				} else {
					this.item.SetClickCallBack(this.ClickCallBack)
				}
			}
			// if (this.data.fragment_id) {
			// red_state = false
			// if (bagModel.total_exchange_list) {
			// 	let fragment_cfg = bagModel.config_goods_exchange_rule[this.data.fragment_id]
			// 	if (fragment_cfg) {
			// 		let cost_cfg = ErlangParser.GetInstance().parse(fragment_cfg.cost_list)
			// 		if (this.data.goods_num >= cost_cfg[0][2]) {
			// 			red_state = true
			// 		}
			// 	}
			// }
			// }
			this.SetRedDot(red_state)
			this.time_limit.visible = this.data.expire_time && this.data.expire_time > 0
		})

	}

	public DeleteMe() {



		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.binId) {
			GoodsModel.GetInstance().UnBind(this.binId)
		}
		super.DeleteMe()
		//this:ClearUIEffect(this.group_eff)
	}

	public RefreshEquipState() {
		this.up.visible = false
		this.down.visible = false
		let banVisible = false
		this.grade.text = ""
		this.star_group.visible = false
		this._bad_icon.visible = false
		if (this.data) {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
			if (goods_basic && goods_basic.type == 10) {
				let cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_goods", false)
				banVisible = EquipModel.GetInstance().CantWearEquip(this.data.type_id, cfgs)
				if (!banVisible) {
					let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(this.data.equip_type)
					this.up.visible = !wear_equip_info || wear_equip_info.rating < this.data.rating
					this.down.visible = wear_equip_info && wear_equip_info.rating > this.data.rating
				}
				let equip_attr_cfg = this.resMgr.GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
				if (equip_attr_cfg) {

					let equip_attr = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, this.data.type_id, false, equip_attr_cfg)
					if (equip_attr) {
						if(PlatformManager.IsEyouEnPlatform()){
							this.grade.text = "G"+equip_attr.stage
						}else{
							this.grade.text = equip_attr.stage + "阶"
						}
						this.star_group.visible = true
						let i = 1
						do {
							this["star_" + i].visible = i <= equip_attr.star && true || false
							i = i + 1
						} while ((i <= 4))
						this._bad_icon.visible = equip_attr.class_type == 1
					}
				}
			}
		}
		this.ban.visible = banVisible
	}

	public async ClickFunc() {
		if (this.data && this.data.type_id) {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id);
			let cfg = await ResManager.GetInstance().LoadGameConfig(this, "config_gift_box", false);
			if(this.use_delete_method) return
			let gift_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, goods_basic.type_id, false, cfg);
			if (goods_basic) {
				let type = goods_basic.type
				let subType = goods_basic.subtype
				let toolMgr = UIToolTipMgr.GetInstance()
				if (type == 35) {
					if (!BagModel.GetInstance().has_show_red[this.data.goods_id]) {
						BagModel.GetInstance().has_show_red[this.data.goods_id] = true
						let goods_cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_goods", false)
						let equip_attr_cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
						let equip_fusion_cfgs = this.resMgr.GetGameConfigFromCache(this.base_item, "config_equip_fusion", false)
						let bool = BagModel.GetInstance().ShowBagRed(goods_cfgs, equip_attr_cfgs, equip_fusion_cfgs)
						GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BagView", BagModel.Index.Goods, bool)
					}
				}
				if (type == 10) {//装备
					let show_btn_list = [1]
					if (goods_basic.sell == 1) {
						table.insert(show_btn_list, 9)
					}
					toolMgr.AppendEquipTips(goods_basic.type_id, null, null, this.data, null, show_btn_list)
				} else if (type == 39) {//蜃妖
					toolMgr.AppendGodBeastTips(goods_basic.type_id)
				} else if (type == UnrealModel.goods_type) {//灵饰
					toolMgr.AppendUnrealTips(goods_basic.type_id, null, null, [0])
				} else if (type == 12 || BagModel.IlluType[type] == subType) {
					toolMgr.AppendIllusionTips(goods_basic.type_id, null, null, this.data, null, [IllusionTips.Btn.Use])
				} else if (type == 33) {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DiamondGiftView", this.data)
				} else if (type == 74) { //背饰
					toolMgr.AppendIllusionTips(goods_basic.type_id, null, null, this.data, null, [IllusionTips.Btn.Use])
				} else if (type == 76) { //神谕
					toolMgr.AppendIllusionTips(goods_basic.type_id, null, null, this.data, null, [IllusionTips.Btn.Use])
				} else if (type == 83) { // 古宝
					toolMgr.AppendIllusionTips(goods_basic.type_id, null, null, this.data, null, [IllusionTips.Btn.Use])
				} else if (type == 75 && subType == 2) { // 藏宝图
					toolMgr.AppendItemInfoTips(goods_basic.type_id, goods_basic, this.data, true, this.data.goods_num);
				} else if ((type == 32 || type == 34) && gift_cfg?.show_new == 1) {
					toolMgr.AppendItemInfoTips(goods_basic.type_id, goods_basic, this.data, true, this.data.goods_num);
				}else if (type == GodBefallDefine.GOOD_TYPE && subType == GodBefallDefine.STAGE_SUBTYPE) {
					toolMgr.AppendIllusionTips(goods_basic.type_id, null, null, this.data, null, [IllusionTips.Btn.Use])
				}
				else {
					toolMgr.AppendGoodsTips(goods_basic.type_id, null, null, this.data)
				}
			}
		}
	}

	public SetRedDot(bool?) {


		if (bool) {
			if (!this.red_img) {
				this.red_img = new Laya.Image()
				this.red_img.skin = AtlasUrl("common", "com_red_point")
				this.red_img.x = 70
				this.red_img.y = 2
				this.red_img.mouseEnabled = false
				this.addChild(this.red_img)
				// this.red_img = UiFactory.CreateChild(this.form,UIType.Image)
				// ResManager.GetInstance().SetImageSprite(this,this.red_img.GetComponent("Image"),"common_asset","com_red_point")
				// SetAnchoredPosition(this.red_img ,100,-2)
			}
			this.red_img.visible = true
		} else if (this.red_img) {
			this.red_img.visible = false
		}
	}

	public UpdateEffect() {

		// this.AddUIEffect("ui_Strengthen_glow", this.group_eff)
	}

	public GetComponents() {
		[
			this.conta,
			this.defaultImg,
			this.up,
			this.down,
			this.ban,
			this.grade,
			this.star_group,
			this.star_1,
			this.star_2,
			this.star_3,
			this.star_4,
			this.time_limit,
			this.lock,
			this.redMask,
			this._bad_icon,
			this.group_eff
		] = this.GetChildrenByNames([
			"conta",
			"defaultImg",
			"up",
			"down",
			"ban",
			"grade",
			"star_group",
			"star_1",
			"star_2",
			"star_3",
			"star_4",
			"time_limit",
			"lock",
			"redMask",
			"_bad_icon",
			"group_eff"
		])
	}

}
window["BagItemRenderer"] = BagItemRenderer