import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { PetEquipType, PetEquipDefine, PetEquipEvent, PetEquipData } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RefBoxChildsLayout, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { PetEquipHorseBagItem } from "./PetEquipHorseBagItem"
import { PetEquipItem } from "./PetEquipItem"
import { PetEquipPartnerBagItem } from "./PetEquipPartnerBagItem"

export class PetEquipBagView extends BaseItem1 {
	LoadSuccess
	InitEvent
	CustomMehod
	UpdateView
	UpdateBagItems
	UpdateEquipItems
	UpdateUM
	ClearUM
	_list_loop_mgr
	fight_item
	public _res_id_
	public bag_loop_mgr
	public _equip_list_

	public constructor(parent?) {
		super(parent)

		this.base_file = "petEquip"
		this.layout_file = "PetEquipBagView"
		this.layer_value = Enum_UILayer.UI

		let _model = PetEquipModel.GetInstance(),
			local_Util = Util,
			local_PetEquipType = PetEquipType,
			local_GlobalEventSystem = GlobalEventSystem,
			OPEN_VIEW = EventName.OPEN_VIEW,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			local_PetEquipDefine = PetEquipDefine,
			out_ward_model = OutWardBaseModel.GetInstance(),
			_ac_list_,
			_equip_list_: Array<PetEquipItem>,
			_um_,
			_res_id_,
			_pos_cfg_,
			_action_cfg_,
			_type_,
			_pos_list_ = [[18, 0], [18, 322 - 150], [600, 0], [600, 322 - 150]]


		this.load_callback = () => {
			this.LoadSuccess()
		}

		// this.ReOpen_callback = () => {
		// 	this.UpdateUM(true)
		// }

		this.LoadSuccess = () => {
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)
			_pos_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOutWardPos", true)
			_action_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOutWardModel", true)
			if (this.use_delete_method) {
				//lua_resM:DestroyAllReferenceRes(this.hashCode)
				return
			}

			_equip_list_ = []
			this._equip_list_ = _equip_list_
			this.InitEvent()
			this.UpdateUM()
			this.UpdateView()
		}

		this.InitEvent = () => {
			this.BindEvent(_model, PetEquipEvent.UPDATE_INFO, (type?) => {
				if (_type_ != type) {
					return
				}
				this.UpdateView()
			})

			Util.AddClickEvent(this._btn_stren, () => {
				local_GlobalEventSystem.Fire(OPEN_VIEW, "PetEquipStrenMasterView", _type_)
			}, this, true)

			Util.AddClickEvent(this._btn_star, () => {
				local_GlobalEventSystem.Fire(OPEN_VIEW, "PetEquipStarMasterView", _type_)
			}, this, true)

			Util.AddClickEvent(this._btn_stage, () => {
				local_GlobalEventSystem.Fire(OPEN_VIEW, "PetEquipStageMasterView", _type_)
			}, this, true)

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_HORSE_BAG_LIST, () => {
				if (_type_ != local_PetEquipType.HORSE) {
					return
				}
				this.UpdateBagItems()
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_PARTNER_BAG_LIST, () => {
				if (_type_ != local_PetEquipType.PARTNER) {
					return
				}
				this.UpdateBagItems()
			})

		}

		this.CustomMehod = (index?, parms?) => {
			_type_ = parms[0]
		}

		this.UpdateView = () => {
			let pinfo = _model.GetPetEquipInfo(_type_)
			if (!pinfo) {
				return
			}
			this.UpdateBagItems()
			this.UpdateEquipItems()
			if(this.fight_item)this.fight_item.Updatefighting(pinfo.combat_power)
		}

		this.UpdateBagItems = () => {
			let list = _model.GetBagGoods(_type_)
			list = _model.AddEmptyToList(list, local_PetEquipDefine.BAG_DEFAULT_COUNT)
			// this._list.dataSource = list
			if (!this._list_loop_mgr) {
				this._list_loop_mgr = new LoopScrowViewMgr()
				let itemRenderer = _type_ == local_PetEquipType.HORSE ? PetEquipHorseBagItem : PetEquipPartnerBagItem
				this._list_loop_mgr.SetData(this._list, itemRenderer, list, LoopScrCon.Vertical)
			} else {
				this._list_loop_mgr.replaceAll(list)
			}

		}

		this.UpdateEquipItems = () => {
			let list = _model.GetWearEquipInfos(_type_)
			for (let i = 0; i < local_PetEquipDefine.EQUIP_POS_COUNT; i++) {
				let info = list[i]
				let item = _equip_list_[i]
				if (!item) {
					item = new PetEquipItem(this._group_equip, i + 1, _type_)
					item.Load()
					_equip_list_[i] = item
				}
				item.ExcuteCallback(() => {
					let pos = _pos_list_[i]
					item.display_obj.x = pos[0]
					item.display_obj.y = pos[1]
					item.SetData(info)
				})
			}
		}

		this.UpdateUM = (bool?) => {
			let _data = out_ward_model.outward_data_list[_type_]
			if (!_data) {
				return
			}
			let career = RoleManager.GetInstance().GetMainRoleVo().career
			let key = `${_type_}@${_data.stage}@${career}`
			let cfg = out_ward_model.outward_stage_cfg[key]
			if (!cfg) {
				return
			}
			let res_id = cfg.ride_figure
			if (this._res_id_ == res_id && !bool) {
				return
			}
			this._lb_name.text = cfg.name
			this._lb_stage.text = `${_data.stage}阶`
			RefBoxChildsLayout(this._Group3,6,null,true,"center")
			this.ClearUM()
			this._res_id_ = res_id
			let mType = PetEquipData[_type_].mType
			let action_list
			if (_action_cfg_ && _action_cfg_[`${_type_}@0`]) {
				action_list = _action_cfg_[`${_type_}@0`].action_list// JSON.parse(_action_cfg_[`${_type_}@0`].action_list)
			}
			let pre_x = ""
			let default_str = ""
			let type = 1
			if (_type_ == enum_OutWardType.Horse) {
				type = UI_MODEL_TYPE.HORSE
				pre_x = "h"
				default_str = "default_horse"
			} else if (_type_ == enum_OutWardType.Wings) {
				type = UI_MODEL_TYPE.WING
				pre_x = "w"
				default_str = "default_role"
			} else if (_type_ == enum_OutWardType.Partner) {
				type = UI_MODEL_TYPE.SPRITE
				pre_x = "s"
				default_str = "default_sprite"
			} else if (_type_ == enum_OutWardType.HolyDevice) {
				type = UI_MODEL_TYPE.WEAPON
				pre_x = "d"
				default_str = "default_role"
			} else if (_type_ == enum_OutWardType.Artifact) {
				type = UI_MODEL_TYPE.ARTIFACT
				pre_x = "a"
				default_str = "default_role"
			} else if (_type_ == enum_OutWardType.BackOrnament) {
				type = UI_MODEL_TYPE.BACKORNAMENT
				pre_x = "b"
				default_str = "default_back_ornament"
			}

			let pos_cfg = _pos_cfg_[`${pre_x}_${res_id}`]
			if (!pos_cfg) {
				pos_cfg = _pos_cfg_[default_str]
			}
			let data = null
			data = {
				clothe_res_id: res_id,
				type: type,
				can_rotate: true,
				layer_value: this.layer_value,
				scale: pos_cfg && pos_cfg.scale,
				position: pos_cfg && pos_cfg.position,
				rotate: pos_cfg && pos_cfg.rotate,
				texture_size: new Vector2(567, 415),
				action_name_list: action_list
			}
			if (data) {
				ResManager.GetInstance().SetRoleModel(this, this._group_um, data)
			}
		}

		this.ClearUM = () => {
			if (_um_) {
				_um_.DeleteMe()
				_um_ = undefined
			}
		}


	}

	public DeleteMe() {
		if(this.fight_item){
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		if (this._equip_list_) {
			for (let item of this._equip_list_) {
				item.DeleteMe()
			}
			this._equip_list_ = undefined
		}
		this._res_id_ = undefined
		super.DeleteMe()
	}


	_group_um: Laya.Box
	_gp_fight: Laya.Box
	_Group2: Laya.HBox
	_Group1: Laya.Box
	_img_look: Laya.Image
	_group_equip: Laya.Box
	_btn_stren: Laya.Image
	_btn_star: Laya.Image
	_btn_stage: Laya.Image
	_Image1: Laya.Image
	_list: Laya.List
	_Image2: Laya.Image
	_Group3: Laya.Box
	_lb_name: Laya.Label
	_lb_stage: Laya.Label
	public GetComponents() {
		[
			this._group_um,
			this._gp_fight,
			this._Group2,
			this._Group1,
			this._img_look,
			this._group_equip,
			this._btn_stren,
			this._btn_star,
			this._btn_stage,
			this._Image1,
			this._list,
			this._Image2,
			this._Group3,
			this._lb_name,
			this._lb_stage,
		]
			= this.GetChildrenByNames([

				"_group_um",
				"_gp_fight",
				"_Group2",
				"_Group1",
				"_img_look",
				"_group_equip",
				"_btn_stren",
				"_btn_star",
				"_btn_stage",
				"_Image1",
				"_list",
				"_Image2",
				"_Group3",
				"_lb_name",
				"_lb_stage",
			])
		this._list.scrollBar.visible = false
	}
}
window["PetEquipBagView"] = PetEquipBagView