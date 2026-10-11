import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, SetAnchoredPosition, SetLocalScale, Util } from "../util/Util";
import { BaseItem1 } from "./BaseItem1";
import { EventName } from "./EventName";
import { ResManager } from "./ResManager";
import { UIToolTipMgr } from "./UIToolTipMgr";
import { WordManager } from "./WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { BagModel } from "../commonModel/BagModel";
import { PetEquipDefine } from "../commonModel/PetEquipDefine";
import { HolySealModel } from "../commonModel/HolySealModel";
import { MedalModel } from "../commonModel/MedalModel";
import { GodCourtModel } from "../commonModel/GodCourtModel";
import { RevelationModel } from "../commonModel/RevelationModel";
import { LungModel } from "../commonModel/LungModel";
import { GodBeastDefine } from "../commonModel/GodBeastModel";
import { Vector2 } from "../util/Vector2";
import { UnrealModel } from "../commonModel/UnrealModel";
import { GodBefallDefine } from "../commonModel/GodBefallModel"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipToolTip } from "./StarEquipToolTip";
import { Role } from "../scene/sceneobj/Role";
import { RoleManager } from "../commonModel/RoleManager";
import { longlangModel } from "../commonModel/longlangModel";
import { LonglangToolTips } from "./LonglangToolTips";
import { Config } from "../common/Config"
import { BabyModel } from "../commonModel/BabyModel";

export class BaseAwardItem extends BaseItem1 {
	icon_obj: Laya.Image
	num_text_obj: Laya.HTMLDivElement
	is_delay_callback
	need_refresh_gary
	show_item_effect
	have_click_event
	get_icon
	god_lv
	itemEffectCache
	is_gary_com
	show_getIcon
	type_id
	goods_id
	color_cache
	box_effect_group
	award_item_scale
	effect_callback
	loadcall
	level
	num_str
	goods_basic
	color
	is_gary
	showing_effect_id
	width_vlaue
	need_resize
	touchEnabled
	not_show_effect
	goods_num
	award_cache
	call_back
	use_mask
	need_refresh
	need_refresh_select
	effect_award
	show_tips_cache
	fontSizeCache
	select_state
	is_lock
	show_tips
	height_value
	bg_cache
	save_by_batch
	show_count
	cache_order
	need_set_icon_size
	icon_width
	icon_height

	effect_order_cache = []
	start_batch = false
	BATCH_DEPTH_INTERVAL = 10
	layer_value: string;

	_cache_icon_bool
	show_name

	public constructor(parent?, prefab_asset?, layer_value?, show_tips?, save_by_batch?) {
		super(parent)
		this.show_count = true;
		this.show_getIcon = false;
		this.width_vlaue = 0;
		this.height_value = 0;
		this.base_file = "common"
		this.layout_file = "BaseAwardItem"
		this.touchEnabled = false
		this.need_set_icon_size = false
		this.save_by_batch = save_by_batch
		if (show_tips == null) {
			show_tips = true
		}
		this.show_tips = show_tips
		this._cache_icon_bool = null

		this.load_callback = () => {
			// this.GetComponents()
			this.icon_obj = this.icon
			this.num_text_obj = this.num_text
			this.LoadSuccess()
			this.InitEvent()
		}

		this.preload_server_config = {
			config_gift_box: false
		}

		//this:once(egret.Event.REMOVED_FROM_STAGE,(event?) => {
		//this:DeleteMe()
		//}
		//, this)
	}

	public LoadSuccess() {
		this.num_text.width = 127
		this.num_text.style.fontSize = 30
		this.num_text.style.color = "#ffffff"
		this.num_text.style.wordWrap = false
		this.num_text.style.strokeColor = "#000000"
		this.num_text.style.stroke = 2
		this.num_text.style.valign = "bottom"
		this.num_text.style.bold = true

		if (this.need_refresh) {
			this.SetData(this.type_id, this.goods_num, this.is_lock, this.select_state, this.show_getIcon, this.not_show_effect, this.goods_basic && this.goods_basic.rating, this.goods_basic && this.goods_basic.equip_extra_attr, this.goods_id, this.level, this.god_lv, this.effect_callback, this.show_name)
			this.need_refresh = false
		}

		if(this.need_refresh_select){
			this.SetSelect(this.select_state)
			this.need_refresh_select = false
		}
	}

	public InitEvent() {

		if (this.show_tips && !this.have_click_event) {
			let OnClick = () => {
				if (this.show_tips) {
					if (this.call_back) {
						this.call_back()
					} else {
						this.DefaultCallFun()
					}
				}
			}
			Util.AddClickEvent(this.click_group, OnClick, this, true)
			this.have_click_event = true
		}
	}

	public DefaultCallFun() {
		if (this.goods_basic) {
			let type = this.goods_basic.type
			let subType = this.goods_basic.subtype
			let toolMgr = UIToolTipMgr.GetInstance();
			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gift_box", false)
			let gift_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, this.goods_basic.type_id, false, config)

			
			if (type == 10) {//装备
				if (this.goods_basic.equip_extra_attr) {
					toolMgr.AppendEquipTips(this.goods_basic.type_id, null, null, this.goods_basic, null, null, this.god_lv)
				} else {
					toolMgr.AppendEquipTips(this.goods_basic.type_id, null, null, null, null, null, this.god_lv)
				}
			}
			else if (type == 26) { // 御魂
				if (subType == 99) { // 御魂精华不一样特殊处理
					toolMgr.AppendGoodsTips(this.goods_basic.type_id, null, null, null, this.goods_num, null, this)
				} else {
					toolMgr.AppendIllusionTips(this.goods_basic.type_id);
				}
			} else if (type == 83) { // 古宝
				UIToolTipMgr.GetInstance().AppendIllusionTips(this.goods_basic.type_id);
			} else if (type == 84) {
				toolMgr.AppendItemInfoTips(this.goods_basic.type_id, this.goods_basic, this.goods_num);
			} else if (type == 75 && subType == 2) { // 藏宝图
				toolMgr.AppendItemInfoTips(this.goods_basic.type_id, this.goods_basic, this.goods_num);
			} else if ((type == 32 || type == 34 || type == 33) && gift_cfg?.show_new == 1) {//礼包
				toolMgr.AppendItemInfoTips(this.goods_basic.type_id, this.goods_basic, this.goods_num);
			} else if (type == 39) {//蜃妖
				toolMgr.AppendGodBeastTips(this.goods_basic.type_id)
			} else if (type == HolySealModel.GOODS_TYPE) {
				toolMgr.AppendHolySealTips(this.goods_basic.type_id, null, null, [3])
			} else if (type == UnrealModel.goods_type) {
				toolMgr.AppendUnrealTips(this.goods_basic.type_id, null, null, [0])
			} else if (type == 12 || BagModel.IlluType[type] == subType) {//时装或者其他培养的幻化
				toolMgr.AppendIllusionTips(this.goods_basic.type_id)
			} else if ((type == PetEquipDefine.HORSE_TYPE_ID || type == PetEquipDefine.PARTNER_TYPE_ID)
				&& this.goods_basic.subtype <= PetEquipDefine.EQUIP_POS_COUNT) {
				toolMgr.AppendPetEquipTips(this.goods_basic.type_id, null, null, [0])
			} else if (type == LungModel.LungGoodsType) {
				toolMgr.AppendLungTips(this.goods_basic.type_id, this.level)
			} else if (type == LungModel.LungMaterialGoodsType) {
				toolMgr.AppendLungStoneTips(this.goods_basic.type_id, null, this, this.goods_num)
			} else if (type == GodBefallDefine.EQUIP_TYPE) {
				toolMgr.AppendGodEquipTips(this.goods_basic.type_id)
			} else if (type == BabyModel.GOODS_TYPE ) {
				toolMgr.AddBabyEquipToolTips(this.goods_basic.type_id)
			} else if (type == GodBefallDefine.GOOD_TYPE && this.goods_basic.subtype == GodBefallDefine.STAGE_SUBTYPE) {
				toolMgr.AppendIllusionTips(this.goods_basic.type_id, null, null, null, this)
			} else if (type == RevelationModel.GOODS_TYPE) {
				toolMgr.AppendRevelationTooltips(this.goods_basic.type_id)
			} else if (type == 74) {//背饰
				toolMgr.AppendIllusionTips(this.goods_basic.type_id)
			} else if (type == MedalModel.GOODS_TYPE) {
				toolMgr.AppendIllusionTips(this.goods_basic.type_id)
			} else if (type == longlangModel.GOODS_TYPE) {
				toolMgr.AppendLongLangToolTips(this.goods_basic.type_id, null, null, [LonglangToolTips.Btn.close])
			} else if (type == StarEquipModel.GOODS_TYPE && subType < 11) {
				toolMgr.AppendStarEquipToolTips(this.goods_basic.type_id, null, null, [StarEquipToolTip.Btn.close])
			} else if (type == GodCourtModel.GoodsType && subType < 17) {
				toolMgr.AppendGodCourtTips(this.goods_basic.type_id, null, null, [0])
			} else {
				toolMgr.AppendGoodsTips(this.goods_basic.type_id, null, null, null, this.goods_num, null, this)
			}
			GlobalEventSystem.Fire(EventName.OPEN_TIPS_VIEW)
		}
	}


	public SetLoadCall(loadcall?) {

		this.loadcall = loadcall
		if (this.is_loaded) {
			if (this.loadcall) {
				this.loadcall()
			}
		}
	}

	public Clear() {
		this.ClearItemEffect()
	}

	public DeleteMe() {
		this.ClearItemEffect()
		this.ClearBoxEffect()
		this.ClearAwardEffect()
		super.DeleteMe()
	}

	public SetData(type_id?, goods_num?, is_lock?, select?, show_getIcon?, not_show_effect?, rating?, equip_extra_attr?, goods_id?, lv?, god_lv?, effect_callback?, show_name?) {

		if (this.use_delete_method) {
			return
		}
		this.goods_num = Number(goods_num) || 0
		this.is_lock = is_lock
		this.type_id = Number(type_id)
		this.god_lv = god_lv
		this.show_getIcon = (show_getIcon == null && this.show_getIcon || show_getIcon)
		this.goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.type_id)
		this.effect_callback = effect_callback
		this.show_name = show_name
		if (this.goods_basic) {
			this.goods_basic["rating"] = rating
			this.goods_basic["equip_extra_attr"] = equip_extra_attr
			this.goods_basic["is_lock"] = is_lock
		}
		this.level = lv
		this.color = (this.goods_basic && (this.goods_basic.color) || (0))
		if(type_id == 26270005 || type_id == 26260005) this.color = 7
		this.not_show_effect = (not_show_effect == null && (this.not_show_effect) || (not_show_effect))
		this.goods_id = goods_id
		this.Clear()
		if (this.is_loaded) {
			this.item_bg.skin = AtlasUrl("common", "com_goods_plate_" + this.color)
			if (this.goods_basic) {
				this.icon_obj.visible = true
				if (this.goods_basic.type == 10 ||
					this.goods_basic.type == 26 && this.goods_basic.subtype != 99 ||
					this.goods_basic.type == 28 && this.goods_basic.subtype != 99 ||
					this.goods_basic.type == UnrealModel.goods_type ||
					this.goods_basic.type == GodBeastDefine.GOODS_TYPE && this.goods_basic.subtype != 51 ||
					this.goods_basic.type == GodBefallDefine.EQUIP_TYPE
				) {
					this.goods_num = this.goods_num > 1 && this.goods_num || 0
				} else {
					this.Clear()
				}
				if (this.lock) {
					if (this.is_lock == 1) {
						this.lock.visible = true
					} else {
						this.lock.visible = false
					}
				}
				//限时标志
				if (this.time_limit) {
					this.time_limit.visible = this.goods_basic.expire_time && this.goods_basic.expire_time > 0
				}
				if (!this.not_show_effect) {
					// if (this.goods_id && EquipModel.GetInstance().checkGodEquip(this.goods_id) || god_lv && god_lv > 0) {
					// 	this.SetItemEffect(1007)
					// } else 
					if (this.goods_basic && this.goods_basic.effect_id) {
						this.SetItemEffect(this.itemEffectCache || this.goods_basic.effect_id)
					}
				} else {
					this.ClearItemEffect()
				}
			} else {
				this.Clear()
				this.icon_obj.visible = false
				this.lock.visible = false
				this.time_limit.visible=false
			}
			// if(select != null){
			this.SetSelect(select)
			// }
			if (this.need_resize) {
				this.SetItemSize()
				this.need_resize = false
			}
			if (this.show_getIcon) {
				if (!this.get_icon) {
					this.get_icon = new Laya.Image();
					this.click_group.addChild(this.get_icon)
					ResManager.GetInstance().SetImageSprite(this, this.get_icon, "common", "com_get_icon")
					SetAnchoredPosition(this.get_icon, 20, 20)

				} else {
					this.get_icon.visible = true
				}
			} else {
				if (this.get_icon) {
					this.get_icon.visible = false
				}
			}
			if (this.num_text) {
				this.num_text.innerHTML = String(WordManager.FormatNumber2(this.goods_num))
				this.num_text.width = 100
			}
			this.ChangeCountVisible(this.show_count, this.goods_num)
			if (this.num_str) {
				this.ForceSetNumberInFlow(this.num_str)
			}
			if (this.show_tips_cache != null) {
				this.SetShowTips(this.show_tips_cache)
				this.show_tips_cache = null
			}
			if (this.color_cache != null) {
				this.SetBoxEffect(this.color_cache)
				this.color_cache = null
			}
			if (this.award_cache != null) {
				this.SetAwardEffect(this.award_cache[1], this.award_cache[2], this.award_cache[3])
				this.award_cache = null
			}
			if (this.need_refresh_gary != null) {
				this.SetGary(this.is_gary)
				this.need_refresh_gary = null
			}
			if (this.is_gary_com != null) {
				this.SetIconGaryCom(this.is_gary_com)
				this.is_gary_com = null
			}

			if (this._cache_icon_bool != null) {
				this.SetItemVisible(this._cache_icon_bool)
				this._cache_icon_bool = null
			}
			if (this.bg_cache != null) {
				this.SetItembgVisible(this.bg_cache)
				this.bg_cache = null
			}
			if (this.award_item_scale) {
				this.SetScale(this.award_item_scale)
				this.award_item_scale = null
			}
			if (this.goods_basic) {
				let goods_icon = this.goods_basic.goods_icon
				let career = 0 //RoleManager.GetInstance().GetMainRoleCareer()
				if (this.goods_basic.type == 20 && this.goods_basic.subtype == 3) { //神兵 幻化材料
					// let icon: string = this.goods_basic.goods_icon
					// goods_icon = icon.substr(1, 4) + career + icon.substr(6, 3)  //string.sub(icon, 1, 4) + career + string.sub(icon, 6, 8)
					ResManager.GetInstance().LoadGameConfig(this, "ConfigIllusionModel", true, null, (cfg) => {
						let info = cfg[this.goods_basic.goods_icon]
						if(info)
							ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetGoodsIconPath(info.picture[RoleManager.GetInstance().GetMainRoleVo().career]))
					})
				} else if (this.goods_basic.type == 59 && this.goods_basic.subtype == 5) { //头像
					let career =  RoleManager.GetInstance().GetMainRoleCareer();
					let iconStr: string = this.goods_basic.type_id +  career * 100;
					ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetGoodsIconPath(iconStr))
				}else {
					ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetGoodsIconPath(goods_icon))
				}
				if (this.need_set_icon_size) {
					this.SetIconSize(this.icon_width, this.icon_height)
				}
			}
			if (this.fontSizeCache) {
				this.SetFontSize(this.fontSizeCache)
				this.fontSizeCache = null
			}
		} else {
			this.need_refresh = true
		}
	}

	public ResConfig() {
	}

	// public static StartBatchLoad() {
	// 	start_batch = true
	// 	BaseAwardItem.sharedMatDict = []
	// 	effect_order_cache = []
	// }

	// public static EndBatchLoad() {
	// 	start_batch = false
	// 	effect_order_cache = []
	// }	

	public SetItemEffect(effect_id?) {

		if (!this.is_loaded) {
			this.itemEffectCache = effect_id
			return
		}
		if (this.showing_effect_id != effect_id) {
			this.ClearItemEffect()
			if (!this.effect_con) {
				this.effect_con = new Laya.Box()
				this.effect_con.name = "effect_con"
				this.click_group.addChild(this.effect_con)
				this.effect_con.anchorX = 0.5
				this.effect_con.anchorY = 0.5
				// this.effect_con.anchoredPosition = new Vector2(0, 0)
				// this.effect_con.touchEnabled = false
				SetLocalScale(this.effect_con, 0.7)
				this.effect_con.x = 120
				this.effect_con.y = 120
				this.effect_con.width = this.display_obj.width
				this.effect_con.height = this.display_obj.height

				if (this.show_item_effect != null) {
					this.effect_con.visible = this.show_item_effect
				}
			}
			let effect_str
			if (effect_id == 1004) {
				effect_str = "ui_goods_orange"
			} else if (effect_id == 1005) {
				effect_str = "ui_goods_red"
			} else if (effect_id == 1006) {
				effect_str = "ui_goods_gold"
			} else if (effect_id == 1007) {
				effect_str = "ui_goods_pink"
			} else if (effect_id == 1008) {
				effect_str = "UI_1309"
			} else if (effect_id == 1009) {
				effect_str = "UI_1310"
			}
			if (effect_str) {
				this.showing_effect_id = effect_id
				// let base_order
				// if (start_batch && this.save_by_batch) {
				// 	if (!effect_order_cache[effect_id]) {
				// 		base_order = (this.AddCurrLayerSortingOrder(this.layer_value, BATCH_DEPTH_INTERVAL) - BATCH_DEPTH_INTERVAL)
				// 		effect_order_cache[effect_id] = base_order
				// 	} else {
				// 		base_order = effect_order_cache[effect_id]
				// 	}
				// } else {
				// 	if (!this.cache_order) {
				// 		this.cache_order = this.AddCurrLayerSortingOrder(this.layer_value)
				// 	}
				// }
				//this.AddUIEffect(effect_str, this.layer_value || "UI", this.effect_con, null, null, true, { mask_id = this.mask_id, mask_corners = this.mask_corners, load_call_back = this.effect_callback, custom_sorting_order = this.cache_order, base_order = base_order, save_by_batch = this.save_by_batch })
				this.AddUIEffect(effect_str, this.effect_con, null, 14, true)
			}
		}
	}

	public SetBoxEffect(color?) {

		if (this.is_loaded) {
			this.ClearBoxEffect()
			if (!this.box_effect_group) {
				// this.box_effect_group = UiFactory.CreateChild(this.click_group.transform, UIType.EmptyObject, "box_effect_group").transform
				// this.box_effect_group.pivot = Vector2(0.5, 0.5)
				// this.box_effect_group.anchorMax = Vector2(0.5, 0.5)
				// this.box_effect_group.anchorMin = Vector2(0.5, 0.5)
				// this.box_effect_group.anchoredPosition = Vector2(0, 0)
			}
			// let effect_str = "ui_activityboxes_yellow"
			// if (color == 4) {
			// 	effect_str = "ui_activityboxes_yellow"
			// } else if (color == 5) {
			// 	effect_str = "ui_activityboxes_red"
			// } else if (color == 6) {
			// 	effect_str = "ui_activityboxes_pink"
			// }
			// if (typeof (color) == "string") {
			// 	effect_str = color
			// }
			// this.AddUIEffect(effect_str, this.box_effect_group, null, null, true, { mask_id = this.mask_id, mask_corners = this.mask_corners })
		} else {
			this.color_cache = color
		}
	}

	public SetAwardEffect(effect_res?, effect_pos?, effect_scale?) {

		if (this.is_loaded) {
			this.ClearAwardEffect()
			if (!this.effect_award) {
				// this.effect_award = UiFactory.CreateChild(this.click_group.transform, UIType.EmptyObject, "effect_award").transform
				// this.effect_award.pivot = Vector2(0.5, 0.5)
				// this.effect_award.anchorMax = Vector2(0.5, 0.5)
				// this.effect_award.anchorMin = Vector2(0.5, 0.5)
				// this.effect_award.anchoredPosition = Vector2(0, 0)
			}
			this.AddUIEffect(effect_res, this.effect_award, effect_pos, effect_scale, true)
		} else {
			this.award_cache = [effect_res, effect_pos, effect_scale]
		}
	}

	public ClearItemEffect() {

		if (this.is_loaded && this.effect_con) {
			this.ClearUIEffect(this.effect_con)
		}
		this.showing_effect_id = null
	}

	public ClearBoxEffect() {

		if (this.is_loaded && this.box_effect_group) {
			//this:ClearUIEffect(this.box_effect_group)
		}
	}

	public ClearAwardEffect() {

		if (this.is_loaded && this.effect_award) {
			this.ClearUIEffect(this.effect_award)
		}
	}

	public ChangeCountVisible(bool?, num?) {

		this.show_count = bool
		let goods_num = Number(num) || 0
		if (this.is_loaded) {
			if (!this.show_count || goods_num < 1) {
				this.num_text_obj.visible = false
			} else {
				this.num_text_obj.visible = true
				this.num_text.innerHTML = String(WordManager.FormatNumber2(goods_num))
				this.num_text.width = 100
			}
		}
	}

	public ForceSetNumber(number?) {

		this.goods_num = number
		if (this.is_loaded) {
			this.num_text_obj.visible = true
			this.num_text.innerHTML = String(WordManager.FormatNumber2(number))
			this.num_text.width = 100
		}
	}

	public ForceSetNumberInFlow(str) {
		if (this.is_loaded) {
			this.num_text_obj.visible = true
			this.num_text.innerHTML = str
			this.num_text.width = 100
		} else {
			this.num_str = str
		}
	}

	public SetGary(bool?) {

		this.is_gary = bool
		if (this.is_loaded) {
			this.need_refresh_gary=null
			if (bool) {
				// Util.SetImageGray(this.item_bg, true)
				this.item_bg.gray = true
				this.icon.gray = true
				this.not_show_effect = true
				this.ClearItemEffect()
			} else {
				this.item_bg.gray = false
				this.icon.gray = false
				this.not_show_effect = false
				if ((!this.not_show_effect && this.goods_basic) && this.goods_basic.effect_id) {
					this.SetItemEffect(this.goods_basic.effect_id)
				}
			}
		} else {
			this.need_refresh_gary = true
		}
	}

	public SetIconGaryCom(bool?) {

		if (this.is_loaded) {
			if (bool) {
				this.icon.gray = true
				this.not_show_effect = true
				this.ClearItemEffect()
			} else {
				this.icon.gray = false
				this.not_show_effect = false
				if ((!this.not_show_effect && this.goods_basic) && this.goods_basic.effect_id) {
					this.SetItemEffect(this.goods_basic.effect_id)
				}
			}
			this.is_gary_com = null
		} else {
			this.is_gary_com = bool
		}
	}

	public SetItemVisible(bool?) {
		if (this.is_loaded) {
			if (bool) {
				this.icon_obj.visible = true
			} else {
				this.icon_obj.visible = false
			}
			this._cache_icon_bool = false
		} else {
			this._cache_icon_bool = bool
		}
	}

	public SetItembgVisible(bool?) {

		if (this.is_loaded) {
			if (bool) {
				this.item_bg.visible = true
				this.not_show_effect = false
				if ((!this.not_show_effect && this.goods_basic) && this.goods_basic.effect_id) {
					this.SetItemEffect(this.goods_basic.effect_id)
				}
			} else {
				this.not_show_effect = true
				this.item_bg.visible = false
				this.ClearItemEffect()
			}
		} else {
			this.bg_cache = bool
		}


	}

	public SetFontSize(size?) {

		if (this.is_loaded) {
			this.num_text.style.fontSize = size
		} else {
			this.fontSizeCache = size
		}
	}

	public SetSelect(bool?) {
		this.select_state = bool ? true : false
		if (this.is_loaded) {
			if (bool) {
				this.select_image.visible = true
			} else {
				this.select_image.visible = false
			}
		} else {
			this.need_refresh_select = true
		}
	}

	public GetSelectState(){
		return this.select_state
	}
	public SetClickCallBack(callback?) {

		this.show_tips = true
		this.call_back = callback
	}

	//只设置scale
	public SetScaleOnly(scale?) {

		// super.SetScale(this, scale)
	}

	//和下面的函数一样作用
	public SetItemSize(width?, height?) {

		width = width || this.width_vlaue
		// height = height || this.height_value
		this.SetScale(width / 127)
	}

	//同时缩放scale和size（适应布局组件，组件只会单纯算size，不会计算scale
	public SetScale(scale?) {

		if (this.is_loaded) {
			// let scale_width = 127 * scale
			// let scale_height = 127 * scale
			SetLocalScale(this.display_obj, scale)
			// SetSizeDelta(this.form, scale_width, scale_height)
		} else {
			this.award_item_scale = scale
		}
	}

	public SetShowTips(bool?) {

		if (this.is_loaded) {
			if (this.show_tips != bool) {
				this.show_tips = bool
				if (this.click_group) {
					this.click_group.mouseEnabled = this.show_tips
					if (!bool) {
						this.have_click_event = null
						// LuaClickListener.Remove(this.click_group)
						// LuaEventListener.Remove(this.click_group)
					} else {
						this.InitEvent()
					}
				}
			}
			this.show_tips_cache = null
		} else {
			this.show_tips_cache = bool
		}
	}

	public SetUseMask(bool?) {

		// this.use_mask = bool
		// if (bool) {
		// 	this.SetMaskId(1)
		// }
	}

	public SetShowEffect(bool?) {

		this.show_item_effect = bool
		if (this.is_loaded && this.effect_con) {
			this.effect_con.visible = bool
		}
	}

	//当item在界面加载完的时候不用 过了一段时间再设置数据 可能会因为又打开了新的界面
	//导致sortingodrder不对特效层级显示有问题 所以需要在界面打开的时候缓存下界面的SortingOrder
	public SetCacheSortOrder(cache_order?) {

		this.cache_order = cache_order
	}
	public CoverEffectOutside(transform?) {

		// this.CoverEffect(transform, this.layer_value || "UI", this.cache_order + 1)
	}

	public SetIconSize(width?, height?) {
		this.icon.width = width
		this.icon.height = height
	}

	public SetIconSizeData(need_set_icon_size?, width?, height?) {
		this.need_set_icon_size = need_set_icon_size
		this.icon_width = width
		this.icon_height = height
	}




	click_group: Laya.Box
	item_bg: Laya.Image
	icon: Laya.Image
	num_text: Laya.HTMLDivElement
	lock: Laya.Image
	select_image: Laya.Image
	effect_con: Laya.Box
	time_limit: Laya.Image
	public GetComponents() {
		[
			this.click_group,
			this.item_bg,
			this.icon,
			this.num_text,
			this.lock,
			this.select_image,
			this.effect_con,
			this.time_limit,
		]
			= this.GetChildrenByNames([
				"click_group",
				"item_bg",
				"icon",
				"num_text",
				"lock",
				"select_image",
				"effect_con",
				"time_limit",
			])
	}
}
window["BaseAwardItem"] = BaseAwardItem