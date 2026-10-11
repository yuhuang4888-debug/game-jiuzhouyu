import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { BaseController } from "./BaseController"
import { EquipToolTips } from "./EquipToolTips"
import { GoodsTooltips } from "./GoodsTooltips"
import { DragonBallTooltips } from "./DragonBallTooltips"
import { HolySealToolTips } from "./HolySealToolTips"
import { HolySealModel } from "../commonModel/HolySealModel"
import { RevelationToolTips } from "./RevelationToolTips"
import { RevelationModel } from "../commonModel/RevelationModel"
import { PetEquipDefine } from "../commonModel/PetEquipDefine"
import { LungToolTips } from "./LungToolTips"
import { LungStoneToolTips } from "./LungStoneToolTips"
import { BeastToolTips } from "./BeastToolTips"
import { UnrealToolTips } from "./UnrealToolTips"
import { UnrealModel } from "../commonModel/UnrealModel"
import { IllusionTips } from "./IllusionTips"
import { GuildExchangeTips } from "./GuildExchangeTips"
import { PetEquipToolTips } from "./PetEquipToolTips"
import { ExchangeToolTips } from "./ExchangeToolTips"
import { GodBefallToolTips } from "./GodBefallToolTips"
import { StarEquipToolTip } from "./StarEquipToolTip"
import { GodCourtTooltip } from "./GodCourtTooltip"
import { LonglangToolTips } from "./LonglangToolTips"
import { longlangModel } from "../commonModel/longlangModel"
import { ItemInfoTips } from "./ItemInfoTips"
import { ResManager } from "./ResManager"
import { Config } from "../common/Config"
import { ChatEquipToolTips } from "./ChatEquipToolTips"
import { LungModel } from "../commonModel/LungModel"

export class UIToolTipMgr extends BaseController {
	AppendChatHolySealToolTips
	_dragonBallTips
	AppendLungTips
	AppendChatEquipTips
	AppendExchangeTips
	AppendDragonBallTips
	AppendRevelationTooltips
	DefaultAppendTips
	AppendLongLangToolTips
	AppendGodCourtTips
	AppendItemInfoTips
	equipTool1
	AppendGodEquipTips
	AppendIllusionTips
	AppendLungStoneTips
	equipTool2
	AddendFragmentTips
	AppendPetEquipTips
	AppendLonglangChatToolTips
	AppendEquipTips
	AppendGuildExchangeTips
	AddBabyEquipToolTips
	AppendStarEquipToolTips
	_equipToolTips
	AppendUnrealTips
	AppendHolySealTips
	AppendGodBeastTips
	AppendGoodsTips
	_goodsTooltips: GoodsTooltips;
	static Instance: UIToolTipMgr

	public constructor() {
		super()


		// let local_Message = Message
		let _exchangeTooltips = null
		let _guildExchangeTips = null
		let _godBeastTips = null
		let _unrealBeastTips = null
		// let _fragmentTips = null
		let _illusionltips = null
		let _holy_seal_tips = null
		// let _chat_holy_seal_tips = null
		let _pet_equip_tips = null
		// let _chatequipToolTips = null
		let _lung_tips = null
		let _lung_stone_tips = null
		let _god_tips = null
		// let _baby_equip_tips = null
		let _revelationTips = null
		let _longlangtips = null
		// let _longlangchattips = null
		let starEquipTip = null
		let godCourtTips = null
		let itemInfoTips: ItemInfoTips = null;

		this.AppendGoodsTips = (type_id?, x?, y?, goods_vo?, goods_num?, overdue_time?, closeObj?) => {
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (!basic) {
				return
			}
			// if (!this._goodsTooltips) {
			// 	this._goodsTooltips = new GoodsTooltips()
			// }

			this._goodsTooltips = new GoodsTooltips();

			if (this._goodsTooltips.HasOpen()) {
				this._goodsTooltips.Close();
			}
			this._goodsTooltips.closeObj = closeObj
			this._goodsTooltips.SetData(type_id, x, y, goods_vo, goods_num, overdue_time);
			this._goodsTooltips.Open();
			this._goodsTooltips = null;
		}

		this.AppendEquipTips = (type_id?, x?, y?, goods_vo?, role_id?, show_btn_list?, god_lv?) => {
			if (!this._equipToolTips) {
				this._equipToolTips = new EquipToolTips()
			}
			if (type_id != 0) {
				this._equipToolTips.SetData(type_id, x, y, goods_vo, role_id, show_btn_list, god_lv)
				this._equipToolTips.Open()
			} else {
				Message.show("没有物品数据")
			}
		}

		this.AppendDragonBallTips = (type_id?, act_num?, dragon_list?, red_state?) => {
			if (!this._dragonBallTips) {
				this._dragonBallTips = new DragonBallTooltips()
			}
			this._dragonBallTips.SetData(type_id, act_num, dragon_list, red_state)
			this._dragonBallTips.Open()
		}

		this.AppendChatEquipTips = (type_id?, x?, y?, goods_vo?, role_id?, show_btn_list?) => {
			// if (!_chatequipToolTips) {
			// 	_chatequipToolTips = new ChatEquipToolTips()
			// }
			// if (type_id != 0) {
			// 	_chatequipToolTips.SetData(type_id, x, y, goods_vo, role_id, show_btn_list)
			// 	_chatequipToolTips.Open()
			// } else {
			// 	local_Message.show("没有物品数据")
			// }
			this.AppendEquipTips(type_id, x, y, goods_vo, role_id, show_btn_list)
		}

		this.AppendExchangeTips = (type_id?, def?, min?, max?, score?, x?, y?, goods_vo?) => {
			if (def == null) {
				def = 1
			}
			if (min == null) {
				min = 1
			}
			if (!_exchangeTooltips) {
				_exchangeTooltips = new ExchangeToolTips()
			}
			_exchangeTooltips.SetCountData(def, min, max, score)
			_exchangeTooltips.SetData(type_id, x, y, goods_vo)
			_exchangeTooltips.Open()
		}

		this.AppendGuildExchangeTips = (type_id?, x?, y?, goods_vo?, role_id?, show_btn_list?) => {
			if (!_guildExchangeTips) {
				_guildExchangeTips = new GuildExchangeTips()
			}
			_guildExchangeTips.SetData(type_id, x, y, goods_vo, role_id, show_btn_list)
			_guildExchangeTips.Open()
		}

		this.AppendGodBeastTips = (type_id?, x?, y?, goods_vo?, role_id?, show_btn_list?) => {
			if (!_godBeastTips) {
				_godBeastTips = new BeastToolTips()
			}
			_godBeastTips.SetData(type_id, x, y, goods_vo, role_id, show_btn_list)
			_godBeastTips.Open()
		}

		this.AppendUnrealTips = (type_id?, goods_vo?, role_id?, show_btn_list?, decompose_id?) => {
			if (!_unrealBeastTips) {
				_unrealBeastTips = new UnrealToolTips()
			}
			_unrealBeastTips.SetData(type_id, goods_vo, role_id, show_btn_list, decompose_id)
			_unrealBeastTips.Open()
		}

		// this.AddendFragmentTips = ( type_id?, x?, y?, goods_num?, fragment_vo?, fragment_rule_id?) => {
		// 	if (! _fragmentTips ) {
		// 		_fragmentTips =  new FragmentExchangeView()
		// 	}
		// 	_fragmentTips.SetData(type_id, x, y, goods_num, fragment_vo, fragment_rule_id)
		// 	_fragmentTips.Open()
		// }

		this.AppendIllusionTips = (type_id?, x?, y?, goods_vo?, closeObj?, show_btn_list?) => {
			if (!_illusionltips) {
				_illusionltips = new IllusionTips()
			}
			_illusionltips.closeObj = closeObj
			_illusionltips.SetData(type_id, x, y, goods_vo, show_btn_list)
			_illusionltips.Open()
		}

		this.AppendHolySealTips = (type_id?, goods_vo?, role_id?, show_btn_list?) => {
			if (!_holy_seal_tips) {
				_holy_seal_tips = new HolySealToolTips()
			}
			_holy_seal_tips.SetData(type_id, goods_vo, role_id, show_btn_list)
			_holy_seal_tips.Open()
		}

		// this.AppendChatHolySealToolTips = ( type_id?, goods_vo?, role_id?, show_btn_list?) => {
		// 	if (! _chat_holy_seal_tips ) {
		// 		_chat_holy_seal_tips =  new ChatHolySealToolTips()
		// 	}
		// 	_chat_holy_seal_tips.SetData(type_id, goods_vo, role_id, show_btn_list)
		// 	_chat_holy_seal_tips.Open()
		// }

		this.AppendPetEquipTips = (type_id?, goods_vo?, role_id?, show_btn_list?) => {
			if (!_pet_equip_tips) {
				_pet_equip_tips = new PetEquipToolTips()
			}
			_pet_equip_tips.SetData(type_id, goods_vo, role_id, show_btn_list)
			_pet_equip_tips.Open()
		}

		this.AppendLungTips = (type_id?, level?, show_btn_list?) => {
			if (!_lung_tips) {
				_lung_tips = new LungToolTips()
			}
			_lung_tips.SetData(type_id, level, show_btn_list)
			_lung_tips.Open()
		}

		this.AppendLungStoneTips = (type_id?, goods_vo?, closeObj?, goods_num?) => {
			if (!_lung_stone_tips) {
				_lung_stone_tips = new LungStoneToolTips()
			}
			_lung_stone_tips.closeObj = closeObj
			_lung_stone_tips.SetData(type_id, goods_vo, goods_num)
			_lung_stone_tips.Open()
		}

		this.AppendGodEquipTips = (type_id?, goods_vo?, btn_list?) => {
			if (!_god_tips) {
				_god_tips = new GodBefallToolTips()
			}
			_god_tips.SetData(type_id, goods_vo, btn_list)
			_god_tips.Open()
		}

		// this.AddBabyEquipToolTips = ( type_id?, x?, y?, goods_vo?, role_id?, show_btn_list?) => {
		// 	if (! _baby_equip_tips ) {
		// 		_baby_equip_tips =  new BabyEquipToolTips()
		// 	}
		// 	_baby_equip_tips.SetData(type_id, x, y, goods_vo, role_id, show_btn_list)
		// 	_baby_equip_tips.Open()
		// }

		this.AppendRevelationTooltips = (type_id?, goods_vo?, role_id?, show_btn_list?, suitNum?) => {
			if (!_revelationTips) {
				_revelationTips = new RevelationToolTips()
			}
			_revelationTips.SetData(type_id, goods_vo, role_id, show_btn_list, suitNum)
			_revelationTips.Open()
		}

		this.AppendLongLangToolTips = (type_id?, goods_vo?, role_id?, show_btn_list?) => {
			if (!_longlangtips) {
				_longlangtips = new LonglangToolTips()
			}
			_longlangtips.SetData(type_id, goods_vo, role_id, show_btn_list)
			_longlangtips.Open()
		}

		// this.AppendLonglangChatToolTips = ( type_id?, goods_vo?, role_id?, show_btn_list?) => {
		// 	if (! _longlangchattips ) {
		// 		_longlangchattips =  new LonglangChatToolTips()
		// 	}
		// 	_longlangchattips.SetData(type_id, goods_vo, role_id, show_btn_list)
		// 	_longlangchattips.Open()
		// }

		this.AppendStarEquipToolTips = (type_id?, goods_vo?, role_id?, show_btn_list?, x?, y?, only_goods_id?) => {
			if (!starEquipTip) {
				starEquipTip = new StarEquipToolTip()
			}
			starEquipTip.SetData(type_id, goods_vo, role_id, show_btn_list, x, y, only_goods_id)
			starEquipTip.Open()
		}

		this.AppendGodCourtTips = (type_id?, goods_vo?, godcourtId?, show_btn_list?) => {
			if (!godCourtTips) {
				godCourtTips = new GodCourtTooltip()
			}
			godCourtTips.SetData(type_id, goods_vo, godcourtId, show_btn_list)
			godCourtTips.Open()
		}

		this.AppendItemInfoTips = (type_id: number, goods_vo: any, data?: any, isUseBtn: boolean = false, num: number = 1) => {
			if (!itemInfoTips) {
				itemInfoTips = new ItemInfoTips()
			}

			if (itemInfoTips.HasOpen()) {
				itemInfoTips.Close();
			}
			itemInfoTips.Open(type_id, goods_vo, data, isUseBtn, num)
		}

		this.DefaultAppendTips = async (type_id?, goods_num?) => {
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			let config = await ResManager.GetInstance().LoadGameConfig(this, "config_gift_box", false);
			let gift_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, basic.type_id, false, config)
			if (basic) {
				let type = basic.type
				let subType = basic.subtype
				if (type == 10) {
					if (basic.equip_extra_attr) {
						this.AppendEquipTips(basic.type_id, null, null, basic)
					} else {
						this.AppendEquipTips(basic.type_id)
					}
				} else if (type == 75 && subType == 2) { // 藏宝图
					this.AppendItemInfoTips(basic.type_id, basic, goods_num);
				} else if ((type == 32 || type == 34 || type == 33) && gift_cfg?.show_new == 1) {
					this.AppendItemInfoTips(basic.type_id, basic, goods_num);
				} else if (type == 39) {
					this.AppendGodBeastTips(basic.type_id)
				} else if (type == HolySealModel.GOODS_TYPE) {
					this.AppendHolySealTips(basic.type_id, null, null, [HolySealToolTips.Btn.close])
				} else if (type == UnrealModel.goods_type) {
					this.AppendUnrealTips(basic.type_id, null, null, [0])
					//// [ts2lua]BagModel.IlluType下标访问可能不正确
				} else if (type == 12 || BagModel.IlluType[type] == subType) {
					this.AppendIllusionTips(basic.type_id)
				} else if ((type == PetEquipDefine.HORSE_TYPE_ID || type == PetEquipDefine.PARTNER_TYPE_ID) && subType <= PetEquipDefine.EQUIP_POS_COUNT) {
					this.AppendPetEquipTips(basic.type_id)
					// } else if (type == GodBefallDefine.GOOD_TYPE && subType == GodBefallDefine.STAGE_SUBTYPE) {
					// 	this.AppendIllusionTips(basic.type_id)
				} else if (type == RevelationModel.GOODS_TYPE) {
					this.AppendRevelationTooltips(basic.type_id)
				} else if (type == longlangModel.GOODS_TYPE) {
					this.AppendLongLangToolTips(basic.type_id, null, null, [LonglangToolTips.Btn.close])
				} else if (type == LungModel.LungMaterialGoodsType) {
					this.AppendLungStoneTips(basic.type_id, null, this, goods_num)
				} else {
					this.AppendGoodsTips(basic.type_id, null, null, null, goods_num)
				}
			}
		}
	}

	public static GetInstance() {

		if (!UIToolTipMgr.Instance) {
			UIToolTipMgr.Instance = new UIToolTipMgr()
		}
		return UIToolTipMgr.Instance
	}


	public ContrastEquipByGoodVo(goodsVo?) {

		// let wear_equip_info = EquipModel.GetInstance().GetWearEquipInfo(goodsVo.equip_type)
		// let liuhai = GetLiuhaiHeight() || 0
		// let gap = (ScreenWidth > 720 && (ScreenWidth - 720) / 2 || 0)
		// if (wear_equip_info) {
		// 	let callback = (dynamic?) => {
		// 		var callback1 = () => {
		// 			if (!this.equipTool1) {
		// 				this.equipTool1 = new EquipToolTipItem()
		// 				//this.equipTool1.y = 0
		// 				//this.equipTool1.x = this.equipTool1.y
		// 			}
		// 			this.equipTool1.SetData(wear_equip_info.type_id, -125, 80 + liuhai, dynamic, 1, { 1})
		// 			this.equipTool1.Open()
		// 			this.equipTool1.closeflag = false


		// 			if (!this.equipTool2) {
		// 				this.equipTool2 = new EquipToolTipItem()
		// 				this.equipTool2.use_background = false
		// 			}
		// 			this.equipTool2.SetData(goodsVo.type_id, 150, -105 + liuhai, goodsVo, 1, { 1})
		// 			this.equipTool2.Open()
		// 			this.equipTool2.closeflag = false
		// 		}
		// 		LoadLuaClassAB("EquipToolTipItem", callback1)
		// 	}

		// 	GoodsModel.GetInstance().GetDynamic(wear_equip_info.goods_id, callback)
		// }
	}

	public ContrastEquipByTypeId(typeId?) {

		// let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(typeId)
		// if (goodsBasic) {
		// 	this.ContrastEquipByGoodVo(goodsBasic)
		// }
	}
}

window["UIToolTipMgr"] = UIToolTipMgr