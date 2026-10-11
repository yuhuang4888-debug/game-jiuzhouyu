import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { Util } from "../util/Util";
import { RuneResolutionItem } from "./RuneResolutionItem";

export class RuneResolutionView extends BaseItem1 {
	private _ac_item: Laya.List;

	InitEvent
	LoadSuccess
	initView
	UpdateSelectGoodsDic
	UpdateView
	UpdateItems
	updateMat

	bag_loop_mgr: LoopScrowViewMgr
	public constructor(parent) {
		super(parent);
		this.base_file = "rune";
		this.layout_file = "RuneResolutionView";
		let _model = RuneModel.GetInstance(),
			local_Util = Util,
			local_RuneEvent = RuneEvent,
			goods_model = GoodsModel.GetInstance(),
			_goods_dic_: { [key: number]: any },
			_bag_rune_: Array<any>,
			matItemList_ = []
		this.load_callback = function () {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label1.pos(26,3)
				this._Label1.width = 513
				this._Label1.height = 29
				this._Label1.leading = 0.1
				this._Label1.wordWrap = true
				this._Group2.centerX = -41
				this._Group2.y = 770
				this._Label2.wordWrap = true
				this._Label2.leading = 0.1
				this.labelDisplay.fontSize = 18
			}
			this.InitEvent();
			this.LoadSuccess();
		}

		this.InitEvent = () => {
			local_Util.AddClickEvent(this._btn, () => {
				if (!local_Util.IsTableEmpty(_model._resolutionDic)) {
					let list = []
					for (let key in _model._resolutionDic) {
						if (_model._resolutionDic[key] && _model._resolutionDic[key].goods_id) {
							list.push(_model._resolutionDic[key].goods_id)
						}
					}
					_model.Fire(local_RuneEvent.RUNE_RESOLUTION, list);
				} else {
					Message.show(`未选择拆解道具`)
				}
			}, this, true);

			this.BindEvent(_model, local_RuneEvent.RUNE_RESOLUTION_SELECT, () => {
				let list = []
				if (!local_Util.IsTableEmpty(_model._resolutionDic)) {
					for (let key in _model._resolutionDic) {
						let vo = _model._resolutionDic[key]
						if (vo && vo.goods_id) {
							list.push(vo.goods_id)
						}
					}
					_model.Fire(local_RuneEvent.RESOLUTION_PREVIEW, list)
				} else {
					this.updateMat([])
				}
			})

			this.BindEvent(_model, local_RuneEvent.RUNE_RESOLUTION_RETURN, (data) => {
				if (_model.RuneDecSelectTab != _model.RESOLUTION) return;
				let now_index = {}
				let len = this._list_item.numChildren
				for (let i = 0; i < len; i++) {
					let item = <RuneResolutionItem>this._list_item.getChildAt(i)
					now_index[item["index"]] = { x: item.x, y: item.y - this._list_item.scrollBar.value }
				}

				for (let index in _model._resolutionDic) {
					// let vo = _model._resolutionDic[index]
					let pos = now_index[index]
					if (pos) {
						let group = new Laya.Box()
						group.x = pos.x + 20 + 175 / 2
						group.y = pos.y + 75 + 17 + 119 / 2
						this._gp_effect.addChild(group)
						this.AddUIEffect("ui_achievementglow1", group, null, null, false, null);
					}
				}
				for (let i = this._gp_effect.numChildren - 1; i >= 0; i--) {
					let gp = this._gp_effect.getChildAt(i);
					this._gp_effect.removeChild(gp);
				}
				// SoulModel.GetInstance().showReward(data.goods_id_list);
				_goods_dic_ = {}
				_model.reSetResolutionDic();
				this.UpdateView()
			})

			this.BindEvent(_model, local_RuneEvent.RESOLUTION_PREVIEW_RETURN, (list) => {
				this.updateMat(list)
			})
		}

		this.DeleteMe = () => {
			this._ac_item = undefined;
			_bag_rune_ = [];
			matItemList_ = [];
			_model.reSetResolutionDic();
			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.DeleteMe()
				this.bag_loop_mgr = undefined
			}
			super.DeleteMe();
		}

		this.LoadSuccess = () => {
			this._list_item.scrollBar.visible = false
			this.reward_panel.hScrollBar.visible = false

			this.initView();
		}

		this.initView = () => {
			// this._ac_item = new Laya.ArrayCollection();
			// this._list_item.dataProvider = this._ac_item;
			// this._list_item.itemRenderer = RuneResolutionItem;

			_goods_dic_ = {};
			this.UpdateView()
			this.UpdateSelectGoodsDic()
		}

		this.UpdateSelectGoodsDic = () => {
			if (_bag_rune_) {
				for (let info of _bag_rune_) {
					if (info.is_selected) {
						_goods_dic_[info.goods_id] = info
					}
				}
			}
		}

		this.UpdateView = () => {
			// let rune_arr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_attr_coefficient", false)
			_bag_rune_ = _model.GetRunesResolutionInBag();
			this.UpdateItems(_bag_rune_);
		}

		this.UpdateItems = (list) => {
			if (!this.bag_loop_mgr) {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this._list_item, RuneResolutionItem, list, LoopScrCon.Vertical, 3)
			} else {
				this.bag_loop_mgr.replaceAll(list)
			}

			_model.addResolutionDic(list[0], 0)
			_model.disSelectNum = 0
			if (list[0]) {
				_model.disSelectNum++
				_model.Fire(local_RuneEvent.RESOLUTION_PREVIEW, [list[0].goods_id])
			}
			this.none_conta.visible = (!(list && Util.TableSize(list) > 0))
		}

		this.updateMat = (matList) => {
			let item
			for (let i = 0; i < matItemList_.length; i++) {
				item = matItemList_[i]
				item.DeleteMe()
				item = null
			}
			matItemList_ = []
			let i = 0;
			for (let vo of matList) {
				let [type_id, lock] = goods_model.GetMappingTypeId(vo.style, vo.typeId);
				let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id);
				if (goods_vo) {
					vo.type_id = goods_vo.type_id
					vo.color = goods_vo.color
				}
			}
			matList.sort((a, b) => {
				return b.color - a.color
			})
			for (let key in matList) {
				let info = matList[key];
				let item = matItemList_[i];
				if (!item) {
					item = new EquipmentItem(this._gp_item);
					item.Load();
					item.SetItemSize(80, 80);
					matItemList_.push(item);
				}
				item.SetVisible(true)
				item.ExcuteCallback(() => {
					// let [type_id, lock] = goods_model.GetMappingTypeId(info.style, info.typeId);
					// let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id);
					// if (goods_vo) {
					item.SetData(info.type_id);
					item.ForceSetNumber(info.count);
					// }
				})
				i++;
			}
			for (let j = i; j < matItemList_.length; j++) {
				let item = matItemList_[j];
				if (item)
					item.SetVisible(false)
			}
			this._gp_item.width = matItemList_.length * 90
			if (matItemList_.length >=5){
				this._gp_item.centerX = (this._gp_item.width / 2 - this.reward_panel.width / 2)
				// Laya.timer.callLater(this, () => {
				// 	if (!this.use_delete_method){
						
				// 	}
                // });
				
			}
			this._gp_null.visible = i == 0;
			this._btn.visible = !this._gp_null.visible;
		}
	}
	
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_img_title: Laya.Label
	_Image3: Laya.Image
	_list_item: Laya.List
	reward_panel: Laya.Panel
	_gp_item: Laya.HBox
	_Group2: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_gp_effect: Laya.Box
	_gp_null: Laya.Box
	_Image6: Laya.Image
	_Label2: Laya.Label
	none_conta: Laya.Box
	tips: Laya.Label
	tips_icon: Laya.Image
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Group1,
			this._img_title,
			this._Image3,
			this._list_item,
			this.reward_panel,
			this._gp_item,
			this._Group2,
			this._Image5,
			this._Label1,
			this._btn,
			this._Image1,
			this.labelDisplay,
			this._gp_effect,
			this._gp_null,
			this._Image6,
			this._Label2,
			this.none_conta,
			this.tips,
			this.tips_icon,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Group1",
				"_img_title",
				"_Image3",
				"_list_item",
				"reward_panel",
				"_gp_item",
				"_Group2",
				"_Image5",
				"_Label1",
				"_btn",
				"_Image1",
				"labelDisplay",
				"_gp_effect",
				"_gp_null",
				"_Image6",
				"_Label2",
				"none_conta",
				"tips",
				"tips_icon",
			])
	}
}
window["RuneResolutionView"] = RuneResolutionView