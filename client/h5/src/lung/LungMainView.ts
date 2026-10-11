import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { CommonManager } from "../common/CommonManager";
import { EventName } from "../common/EventName";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { OpenFun } from "../common/OpenFun";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungDotSubType, LungEvent, LungModel } from "../commonModel/LungModel";
import { MainUIModel } from "../commonModel/MainUIModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SkillManager } from "../skill/SkillManager";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, PlayBigEffect, RefBoxChildsLayout, SetAnchoredPosition, SetHtmlCenter, Util } from "../util/Util";
import { LungGridItem } from "./LungGridItem";
import { LungGridList } from "./LungGridList";
import { LungMainProItem } from "./LungMainProItem";
import { LungUpgradeProItem } from "./LungUpgradeProItem";
import { LungSkillItem } from "./LungSkillItem";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { BossMysteryRadioButton } from "../bossMystery/BossMysteryRadioButton";
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr";

export class LungMainView extends BaseItem1 {

	LoadSuccess
	InitEvents
	ClearSelect
	SetData
	SetGridList
	ShowAllMsg
	GetSkillDesc
	FormatPro
	ShowSelectPosView
	SetSelectPosPro
	SetSelectPosSkill
	SetSelctPosOperateView
	SetCost
	ShowOrHideDetail
	ShowBagDot
	ShowStoveDot
	ShowUpgradeDot
	ShowReplaceDot
	SetStoveBtnImg
	DeleteList
	UpdateStoveIcon
	SetAllProArrow
	SetAllSkillArrow
	SetDetailProArrow
	FormatUpgradeAttrs
	ChangeCallFunc

	skill_loop_mgr

	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungMainView"
		let model = LungModel.GetInstance(),
			// local_egret = egret,
			res_mgr = ResManager.GetInstance(),
			local_LungEvent = LungEvent,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			local_Util = Util,
			LUNG_DOT = ModuleType.LUNG_DOT,
			local_LungDotSubType = LungDotSubType,
			local_String = String,
			style_item_list_,
			now_select_pos_,
			now_select_data_,
			pro_item_list_: Array<LungMainProItem>,
			inital_pos_y_,
			hide_pos_y_,
			tween_end_ = true,
			time_id_,
			grid_pro_item_list_: Array<LungUpgradeProItem>,
			lung_item_: LungGridItem,
			cost_item_: BaseAwardItem,
			detain_is_show_ = false,
			fight_num,
			goods_fight

		this.load_callback = ()=> {
			this.LoadSuccess()
			this.InitEvents()
			this.UpdateStoveIcon()
			// let list = GoodsModel.GetInstance().lungbag_goods_dic_
			// console.warn("size--------:", Util.TableSize(list))
		}
		this.preload_server_config = {
			"config_dragon_pos": false
		}

		this.DeleteMe = () => {
			this.DeleteList(style_item_list_)
			this.DeleteList(pro_item_list_)
			this.DeleteList(grid_pro_item_list_)
			if (time_id_) {
				clearTimeout(time_id_)
				time_id_ = undefined
			}
			if (lung_item_) {
				lung_item_.DeleteMe()
				lung_item_ = null
			}
			if (cost_item_) {
				cost_item_.DeleteMe()
				cost_item_ = null
			}
			now_select_pos_ = null
			detain_is_show_ = false
			this.ClearUIEffect(this.effect_group)
			this.ClearUIEffect(this.stove_effect)
			if (fight_num) {
				fight_num.DeleteMe()
				fight_num = null
			}
			if (goods_fight) {
				goods_fight.DeleteMe()
				goods_fight = null
			}
			super.DeleteMe()
		}

		this.DeleteList = (list?) => {
			if (list && list.length > 0) {
				for (let i = 0; i < list.length; i++) {
					list[i].DeleteMe()
				}
				list = null
			}
		}

		this.LoadSuccess = () => {
			this.detail_pro_scroll.vScrollBar.visible = false
			this.pro_scroll.vScrollBar.visible = false;
			// this.skill_scroll.vScrollBar.visible = false;
			// res_mgr.SetTexture(this, this.bg1, "resource/game/lung/texture/uilwmb_011.png", undefined, this, true)
			// res_mgr.SetTexture(this, this.bg2, "resource/game/lung/texture/uilwmb_011.png", undefined, this, true)
			// res_mgr.SetTexture(this, this.upgrade_bg, "resource/game/lung/texture/uilwmb_033.png", undefined, this, true)
			inital_pos_y_ = this.detail_con.y
			this.detail_con.y = this.detail_con.y + this.detail_con.height
			this.detail_con.alpha = 0
			hide_pos_y_ = this.detail_con.y

			if (!fight_num) {
				fight_num = new FightingShowSmallItem(this.fight_num_con)
				fight_num.SetCenter(true,true)
				fight_num.Load()
				fight_num.ExcuteCallback(() => {
					// SetAnchoredPosition(fight_num, 0.5, 0.5)
				})
			}
			if (!goods_fight) {
				goods_fight = new FightingShowSmallItem(this.goods_fight_con)
				goods_fight.SetCenter(true,true)
				goods_fight.Load()
				goods_fight.ExcuteCallback(() => {
					// SetAnchoredPosition(fight_num, 0.5, 0.5)
				})
			}

			model.SetLungTotalLevel()
		}
		this.ChangeCallFunc = () =>{
			GoodsModel.GetInstance().Fire(GoodsModel.FIGURE_ASK_LUNGEQUIP)
			model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18100)
		}

		this.InitEvents = () => {
			let click_grid_fun = (pos) => {
				if (pos) {
					this.ShowSelectPosView(pos)
				}
			}
			this.BindEvent(model, local_LungEvent.LUNG_CLICK_GRID_ITEM, click_grid_fun)

			let update_fun = () => {
				this.SetData()
				// if (detain_is_show_ && now_select_pos_){
				if (now_select_pos_) {
					click_grid_fun(now_select_pos_)
				}
				// else{
				// 	this.ClearSelect()
				// }
			}
			this.BindVar(model, "lung_data", update_fun)
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_LUNG_LIST, update_fun)
			this.BindEvent(goods_model, local_GoodsModel.CHANGE_LUNG_BAG_LIST, update_fun)

			let off_fun = () => {
				this.ClearSelect()
			}
			this.BindEvent(model, local_LungEvent.LUNG_WEAR_OFF_SUCCESS, off_fun)

			let bagBtnFun = () => {
				model.Fire(local_LungEvent.LUNG_OPEN_VIEW, "LungBagView")
			}
			local_Util.AddClickEvent(this.bagBtn, bagBtnFun, this, true)

			let stoveBtnFun = () => {
				model.Fire(local_LungEvent.LUNG_OPEN_VIEW, "LungStoveMainView")
			}
			local_Util.AddClickEvent(this.stoveBtn, stoveBtnFun, this, true)

			let return_fun = () => {
				this.ShowOrHideDetail(false)
			}
			local_Util.AddClickEvent(this.returnBtn, return_fun, this, true)

			let offBtn_fun = () => {
				if (now_select_data_) {
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18103, "l", now_select_data_.goods_id)
				}
			}
			local_Util.AddClickEvent(this.offBtn, offBtn_fun, this, true)

			let replaceBtn_fun = () => {
				if (now_select_pos_) {
					model.Fire(local_LungEvent.LUNG_OPEN_VIEW, "LungSelectView", 2, now_select_pos_)
				}
			}
			local_Util.AddClickEvent(this.replaceBtn, replaceBtn_fun, this, true)

			let upgradeBtn_fun = () => {
				if (now_select_data_) {
					model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18101, "l", now_select_data_.goods_id)
				}
			}
			local_Util.AddClickEvent(this.upgradeBtn, upgradeBtn_fun, this, true)

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_BAG_LIST, () => {
				if (this.use_delete_method) return
				if (now_select_data_) {
					this.SetCost(now_select_data_.type_id, now_select_data_.level)
					this.ShowBagDot()
					this.ShowUpgradeDot()
				}
			})

			let dot_fun = (mType, rType) => {
				if (mType == LUNG_DOT) {
					if (rType == local_LungDotSubType.StoneExchenge || rType == local_LungDotSubType.Shop) {
						this.ShowBagDot()
					} else if (rType == local_LungDotSubType.StoveFreeTimes || rType == local_LungDotSubType.StoveReward) {
						this.ShowStoveDot()
					} else if (rType == local_LungDotSubType.Upgrade) {
						this.ShowUpgradeDot()
					} else if (rType == local_LungDotSubType.Insert) {
						this.ShowReplaceDot()
					}

				}
			}
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, dot_fun)

			let upgrade_return = (is_up_star) => {
				let str = "ui_shengjitexiao"
				if (is_up_star) {
					str = "ui_tupochenggong_glow"
				}
				PlayBigEffect(str)
				// this.ClearUIEffect(this.effect_group)
				// this.AddUIEffect(str, this.effect_group, null, 1)
			}
			this.BindEvent(model, local_LungEvent.LUNG_UPGRADE_SUCCESS, upgrade_return)

			let stove_fun = () => {
				this.SetStoveBtnImg()
			}
			this.BindVar(model, "stove_data", stove_fun)

			/* let setFirstStoveDot = (firstStoveDot)=>{
				this.showLungIcon(firstStoveDot)
			}
			this.BindEvent(model,local_LungEvent.LUNG_SHOW_STOVE_ICON,setFirstStoveDot) */
			// this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, (lv?) => {
			// 	this.UpdateStoveIcon()
			// })
			this.pro_scroll.vScrollBar.on(Laya.UIEvent.CHANGE, this, () => {
				this.SetAllProArrow();
			});

			// this.skill_scroll.scrollBar.changeHandler = new Laya.Handler(this, ()=>{
			// 	this.SetAllSkillArrow()
			// }, null, false);

			this.detail_pro_scroll.vScrollBar.on(Laya.UIEvent.CHANGE, this, () => {
				this.SetDetailProArrow();
			});

			this.SetData()
			this.ShowBagDot()
			this.ShowStoveDot()
		}

		this.ClearSelect = () => {
			now_select_data_ = null
			now_select_pos_ = null
			model.Fire(local_LungEvent.LUNG_CLICK_GRID_ITEM, 0)
			this.ShowOrHideDetail(false)
		}

		this.SetData = () => {

			this.SetGridList()
			this.ShowAllMsg()
			this.SetStoveBtnImg()
		}

		this.SetGridList = () => {
			let dragon_pos_cfg = res_mgr.GetGameConfigFromCache(this, "config_dragon_pos", false)
			// let dragon_pos_cfg = model.GetPosCfg()
			let all_grid_list = model.GetAllGridList(dragon_pos_cfg)
			if (all_grid_list && all_grid_list.length > 0) {
				if (!style_item_list_) {
					style_item_list_ = []
				}
				let item: LungGridList
				for (let i = 0, length = all_grid_list.length; i < length; i++) {
					item = style_item_list_[i]
					if (!item) {
						item = new LungGridList(this.grid_con)
						item.Load()
						style_item_list_[i] = item
					}
					item.SetData(all_grid_list[i], i)
				}
			}
		}

		this.ShowAllMsg = () => {
			if (model.lung_data) {
				// this.overview_con.visible = true
				fight_num.Updatefighting(local_String(model.lung_data.combat_power))
				this.all_level.text = local_String(model.GetLungTotalLv())
				// this.all_level.text = "100"

				let pro_list = this.FormatPro(model.lung_data.attr_list)
				if (pro_list) {
					if (!pro_item_list_) {
						pro_item_list_ = []
					}
					let item: LungMainProItem
					let length_ = pro_list.length
					if (pro_item_list_.length > 0 && pro_item_list_.length > length_) {
						for (let i = 0; i < pro_item_list_.length; i++) {
							pro_item_list_[i].SetVisible(false)
						}
					}
					for (let i = 0; i < length_; i++) {
						item = pro_item_list_[i]
						if (!item) {
							item = new LungMainProItem(this.pro_con)
							item.Load()
							pro_item_list_[i] = item
						}
						item.SetData(pro_list[i])
						pro_item_list_[i].SetVisible(true)
					}
					let height = this.pro_con.y + pro_list.length * LungMainProItem.Height + (pro_list.length - 1) * 4
					this.pro_group.height = height + 10
				}
				let skill_list = model.GetSkillList();
				if (skill_list.length == 0) {
					this.none_effect.visible = true;
					this.skill_scroll.visible = false;
				} else {
					this.none_effect.visible = false;
					this.skill_scroll.visible = true;
					let skill_datas = [];
					for (let i = 0; i < skill_list.length; i++) {
						const skill = skill_list[i];
						
						let skill_id = skill.skill_id
						// let skill_vo = SkillManager.GetInstance().getSkill(skill_id);
						table.insert(skill_datas, {skill_id: skill_id, lv: skill.lv, skill_desc: skill.skill_desc})
						// let show_icon = (skill_vo && skill.lv == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon(skill.lv);
						// let source_str = `resource/game/skillIcon/${show_icon}.png`;
						// let skill_item = skill_item_list[i];
                        // if (!skill_item) {
                        //     skill_item = new LungSkillItem(this.skill_group);
                        //     skill_item.Load();
						// 	skill_item_list.push(skill_item);
                        // }
						// skill_item.SetVisible(true);
						// skill_item.SetData(source_str);
						// skill_item.SetClickCallBack(() => {
						// 	OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "PetSkillView", skill_id, 1);
						// });
					}
					if (!this.skill_loop_mgr) {
						this.skill_loop_mgr = new LoopScrowViewMgr()
						this.skill_loop_mgr.SetData(this.skill_scroll, LungSkillItem, skill_datas, LoopScrCon.Vertical, 1)
						this.skill_scroll.scrollBar.changeHandler = new Laya.Handler(this, (value)=>{
							this.SetAllSkillArrow()
						});
					}else{
						this.skill_loop_mgr.replaceAll(skill_datas)
					}
					if(skill_datas.length < 5){
						this.skill_scroll.scrollBar.touchScrollEnable = false
					}else{
						this.skill_scroll.scrollBar.touchScrollEnable = true
					}
					// if (skill_item_list.length > skill_list.length) {
					// 	for (let i = skill_list.length; i < skill_item_list.length; i++) {
					// 		const skill_item = skill_item_list[i];
					// 		skill_item.SetVisible(false);
					// 	}
					// }
				}
				this.CallLater(() => {
					if (!this.use_delete_method) {
						this.SetAllProArrow();
						this.SetAllSkillArrow();
						this.SetDetailProArrow();
					}
				});
			}
		}

		this.SetAllProArrow = () => {
			if (this.pro_scroll) {
				if (this.pro_con.height >= 143 && this.pro_scroll.displayHeight >= this.pro_con.height - this.pro_scroll.vScrollBar.value - 3) {
					this.pro_down_arrow.visible = false;
				} else {
					this.pro_down_arrow.visible = true;
				}
				if (this.pro_scroll.vScrollBar.value <= 3) {
					this.pro_up_arrow.visible = false;
				} else {
					this.pro_up_arrow.visible = true;
				}
			}
		}

		this.SetDetailProArrow = () => {
			if (this.detail_pro_scroll) {
				if(this.detail_pro_con.height <= 74){
					this.detail_pro_down_arrow.visible = this.detail_pro_up_arrow.visible = false;
				}else{
					if (this.detail_pro_scroll.displayHeight >= this.detail_pro_con.height - this.detail_pro_scroll.vScrollBar.value - 3) {
						this.detail_pro_down_arrow.visible = false;
					} else {
						this.detail_pro_down_arrow.visible = true;
					}
					if (this.detail_pro_scroll.vScrollBar.value <= 3) {
						this.detail_pro_up_arrow.visible = false;
					} else {
						this.detail_pro_up_arrow.visible = true;
					}
				}
			}
		}

		this.SetAllSkillArrow = (value?) => {
			if (this.skill_scroll) {
				let _data = this.skill_scroll.array
				if(_data && _data.length > 4){
					let len = _data.length;
					let maxVal = (Math.ceil(len / 4) - 1) * 72;
					if (this.skill_scroll.scrollBar.value >= maxVal -3) {
						this.skill_down_arrow.visible = false;
					} else {
						this.skill_down_arrow.visible = true;
					}
					if (this.skill_scroll.scrollBar.value <= 3) {
						this.skill_up_arrow.visible = false;
					} else {
						this.skill_up_arrow.visible = true;
					}
				}else{
					this.skill_up_arrow.visible = this.skill_down_arrow.visible = false;
				}
				// if (!this.skill_scroll.visible) {
				// 	this.skill_down_arrow.visible = false;
				// 	this.skill_up_arrow.visible = false;
				// } else {
				// 	if (this.skill_scroll.contentHeight >= 85 && this.skill_scroll.displayHeight >= this.skill_scroll.contentHeight - this.skill_scroll.vScrollBar.value - 3) {
				// 		this.skill_down_arrow.visible = false;
				// 	} else {
				// 		this.skill_down_arrow.visible = true;
				// 	}
				// 	if (this.skill_scroll.vScrollBar.value <= 3) {
				// 		this.skill_up_arrow.visible = false;
				// 	} else {
				// 		this.skill_up_arrow.visible = true;
				// 	}
				// }
			}
		}

		this.GetSkillDesc = (skill_list) => {
			let str = ""
			if (skill_list) {
				let count = 0
				let skill_name
				let skill_desc
				let power
				for (let vo of skill_list) {
					count++
					[skill_desc, skill_name, power] = SkillManager.GetInstance().GetSkillFromConfigByIdAndLevelAndPower(vo.skill_id, vo.lv)
					if (count == 1) {
						str = `${skill_name}:${skill_desc}`
					} else {
						str = `${str}\n${skill_name}:${skill_desc}`
					}
				}
			}
			return str
		}

		this.FormatPro = (pro_list) => {
			let result = [];
			let baseAttrs = [
				{ "attr_id": 1, "attr_value": 0},
				{ "attr_id": 2, "attr_value": 0},
				{ "attr_id": 3, "attr_value": 0},
				{ "attr_id": 4, "attr_value": 0},
				{ "attr_id": 5, "attr_value": 0},
				{ "attr_id": 6, "attr_value": 0},
				{ "attr_id": 7, "attr_value": 0},
				{ "attr_id": 8, "attr_value": 0}
			];
			let spAttrs = [];
			if (pro_list) {
				for (let vo of pro_list) {
					if(vo.attr_id <= 8){
						for (let i = 0, len = baseAttrs.length; i < len; i++) {
							if(baseAttrs[i].attr_id == vo.attr_id){
								baseAttrs[i].attr_value += vo.attr_value
							}
						}
					}else{
						table.insert(spAttrs, { "attr_id": vo.attr_id, "attr_value": vo.attr_value})
					}
				}
			}
			let list = spAttrs.concat(baseAttrs)
			let num = Math.ceil(list.length / 2)
			for (let i = 0; i < num; i++) {
				let obj = []
				obj.push(list[i * 2])
				obj.push(list[i * 2 + 1])
				result.push(obj)
			}
			return result
		}

		//设置选中的格子的视图
		this.ShowSelectPosView = (pos) => {
			now_select_data_ = goods_model.wear_lung_list[pos - 1]
			now_select_pos_ = pos
			if (now_select_data_) {
				if (!this.detail_con.visible) {
					this.detail_con.visible = true
				}
				if (!detain_is_show_) {
					this.ShowOrHideDetail(true)
				}
				this.SetSelectPosPro(now_select_data_)
				this.SetSelctPosOperateView(now_select_data_, pos)
				this.SetSelectPosSkill(now_select_data_)
				this.ShowUpgradeDot()
				this.ShowReplaceDot()
				this.SetDetailProArrow()
			} else {
				this.ShowOrHideDetail(false)
				// model.Fire(local_LungEvent.LUNG_OPEN_VIEW, "LungSelectView", 1, pos)
			}
		}

		this.SetSelectPosPro = (data) => {
			if (data) {
				let now_pro = model.GetProList(data.type_id, data.level)
				if (now_pro) {
					let next_pro = model.GetProList(data.type_id, data.level + 1)
					if (now_pro.length > 0) {
						let _attrs = this.FormatUpgradeAttrs(now_pro, next_pro)
						if (!grid_pro_item_list_) {
							grid_pro_item_list_ = []
						}
						if (grid_pro_item_list_ && grid_pro_item_list_.length > 0) {
							for (let i = 0; i < grid_pro_item_list_.length; i++) {
								grid_pro_item_list_[i].SetVisible(false)
							}
						}
						let item: LungUpgradeProItem
						for (let i = 0, length = _attrs.length; i < length; i++) {
							item = grid_pro_item_list_[i]
							if (!item) {
								item = new LungUpgradeProItem(this.detail_pro_con)
								item.Load()
								grid_pro_item_list_[i] = item
							}
							item.SetVisible(true)
							item.SetData(_attrs[i][0], _attrs[i][1])
						}
						this.detail_pro_group.height = now_pro.length > 2 ? 115: 75 + (now_pro.length -1) * 30
						// let height = this.detail_pro_con.y + now_pro.length * LungUpgradeProItem.Height + (now_pro.length - 1) * 6
						// this.detail_pro_group.height = height

						// if (grid_pro_item_list_.length > now_pro.length) {
						// 	for (let i = now_pro.length, length = grid_pro_item_list_.length; i < length; i++) {
						// 		if (grid_pro_item_list_[i]) {
						// 			grid_pro_item_list_[i].visible = false
						// 		}
						// 	}
						// }
						this.CallLater(() => {
							if (!this.use_delete_method) {
								this.detail_pro_con.refresh()
								this.detail_pro_group.refresh()
								this.detail_scroll_group.refresh()
								// this.detail_scroll.refresh()
							}
						});
					}
				}
			}
		}

		this.FormatUpgradeAttrs = (attrs, next_attrs) => {
			let baseAttrs = [];
			let spAttrs = [];
			for (let i = 0, length = attrs.length; i < length; i++) {
				if(attrs[i][0] <= 8){
					table.insert(baseAttrs, [attrs[i], next_attrs[i]])
				}else{
					table.insert(spAttrs, [attrs[i], next_attrs[i]])
				}
			}
			table.sort(baseAttrs, (a, b) => {
				return a[0][0] < b[0][0]
			})
			let list = spAttrs.concat(baseAttrs)
			return list
		}

		this.SetSelectPosSkill = (data) => {
			if (data) {
				let need_up_star = model.IsNeedUpStar(now_select_data_.level, now_select_data_.level + 1)
				let skill_desc = model.GetLungSkillDesc(now_select_data_.type_id, now_select_data_.level, need_up_star)
				// skill_desc = skill_desc.replace(/<color=#0a953e>/g, "")
				// skill_desc = skill_desc.replace(/<\/color>/g, "")
				// skill_desc = skill_desc.replace(/</g, "")
				// skill_desc = skill_desc.replace(/>/g, "")
				let have_skill = local_String(skill_desc).trim() != ""
				this.detail_none_effect.visible = !have_skill
				this.special_str.visible = have_skill
				if (!have_skill) {
					this.skill_content.visible = false;
				} else {
					this.skill_content.visible = true;
					let skill_list = model.GetLungSkill(now_select_data_.type_id, now_select_data_.level);
					let skill_cfg = skill_list[0];
					let skill_id = skill_cfg.skill_id;
					let skill_lv = skill_cfg.lv;
					let skill_vo = SkillManager.GetInstance().getSkill(skill_id);
                	let show_icon = (skill_vo && skill_lv == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon(skill_lv);
					let source_str = `resource/game/skillIcon/${show_icon}.png`;
					ResManager.GetInstance().SetTexture(this, this.icon, source_str);

					this.special_str.style.color = "#4a3a32";
					this.special_str.style.fontSize = 18;
					this.special_str.width = 224;
					this.special_str.height = 66;
					this.special_str.style.leading = 6;

					this.special_str.innerHTML = local_Util.StrToHTML(skill_desc);
					this.special_str.style.padding = [(this.special_str.height - this.special_str.contextHeight) / 2, 0, 0, 0]; 
					// let height = this.special_str.height + this.special_str.y;
					// this.special_con.height = height;
					// this.detail_scroll.refresh();
				}
			}
		}

		this.SetSelctPosOperateView = (data, pos) => {
			if (data) {
				if (!lung_item_) {
					lung_item_ = new LungGridItem(this.item_con)
					lung_item_.Load()
					lung_item_.SetScale(0.78)
				}
				let dragon_pos_cfg = res_mgr.GetGameConfigFromCache(this, "config_dragon_pos", false)
				let cfg = model.GetPosCfgByPos(dragon_pos_cfg, pos)
				if (cfg) {
					lung_item_.SetData(cfg, true)
				}
				let color_str = ColorUtil.GetColorDark(data.color, false)
				this.goods_name.color = color_str
				this.goods_name.text = local_Util.StrToHTML(`${(data.goods_name).trim()}`);
				this.style_icon.skin = AtlasUrl("lung", `${model.GetLungStyleSource(data.subtype)}`)
				let next_power = model.GetPosNextPower(pos);
				goods_fight.Updatefighting(data.combat_power);
				if (next_power == 0) {
					goods_fight.UpdatefightingUp(0);
					// goods_fight.IsCenter(true, false);
				} else {
					goods_fight.UpdatefightingUp(next_power - data.combat_power);
					// goods_fight.SetPowerOffset(goods_fight.display_obj.width / 4);
				}
				// this.goods_fight.Updatefighting(local_String(model.GetLungPower(data.type_id, data.level)))
				this.SetCost(data.type_id, data.level)
			}
		}

		this.SetCost = (type_id, lv) => {
			let need_up_star = model.IsNeedUpStar(lv, lv + 1)
			let cost_list = model.GetPraticeCost(need_up_star, type_id, lv)
			let max_lv = model.LungIsTopLevel(type_id, lv)
			if (cost_list && !max_lv) {
				this.max_conta.visible = false
				this.upgrade_con.visible = true
				this.con_label.text = need_up_star ? "觉醒消耗" : "升级消耗"
				this.upgrade_label.text = need_up_star ? "觉醒" : "升级"
				let my_have = goods_model.GetTypeGoodsNum(Number(cost_list[1])) || 0
				let color_str = my_have >= Number(cost_list[2]) ? "'#0a953e'" : "'#ff4f50'"
				this.own.style.fontSize = 24
				this.own.width = 200
				this.own.style.color = "#4a3a2a"
				this.own.innerHTML = local_Util.StrToHTML(`消耗:<font color=${color_str}>${my_have}</font>/${cost_list[2]}`)
				if (!cost_item_) {
					cost_item_ = new BaseAwardItem(this.cost_con)
					cost_item_.Load()
					cost_item_.SetItemSize(90, 90)
				}
				cost_item_.SetData(Number(cost_list[1]))
			} else {
				this.upgrade_con.visible = false
				this.max_conta.visible = true
			}
		}

		this.ShowOrHideDetail = (show) => {
			if (tween_end_) {
				tween_end_ = false
				Laya.Tween.clearAll(this.detail_con)
				if (show) {
					detain_is_show_ = true
					this.detail_con.visible = true

					Laya.Tween.to(this.detail_con, { y: inital_pos_y_, alpha: 1 }, 200, undefined, Laya.Handler.create(this, () => {
						tween_end_ = true
						if (this.overview_con) {
							this.overview_con.visible = false
						}
					}))
				} else {
					detain_is_show_ = false
					this.ClearSelect()
					this.overview_con.visible = true
					Laya.Tween.to(this.detail_con, { y: hide_pos_y_, alpha: 1 }, 200, undefined, Laya.Handler.create(this, () => {
						tween_end_ = true
						if (this.detail_con)
							this.detail_con.visible = false
					}))
					this.max_conta.visible = false
				}
			}
		}

		this.ShowBagDot = () => {
			let mgr = RedDotManager.GetInstance()
			let show = mgr.CheckRedStatus(LUNG_DOT, local_LungDotSubType.StoneExchenge)
				|| mgr.CheckRedStatus(LUNG_DOT, local_LungDotSubType.Shop)
			this.bag_dot.visible = show
		}

		this.ShowStoveDot = () => {
			let mgr = RedDotManager.GetInstance()
			let show = mgr.CheckRedStatus(LUNG_DOT, local_LungDotSubType.StoveFreeTimes)
				|| mgr.CheckRedStatus(LUNG_DOT, local_LungDotSubType.StoveReward)
				|| mgr.CheckRedStatus(LUNG_DOT, local_LungDotSubType.StoveGoods)
			this.stove_dot.visible = show
		}

		this.ShowUpgradeDot = () => {
			if (now_select_pos_) {
				let show = model.LungCanUpgrade(now_select_pos_)
				this.upgrade_dot.visible = show
			}
		}

		this.ShowReplaceDot = () => {
			if (now_select_pos_) {
				let dragon_pos_cfg = res_mgr.GetGameConfigFromCache(this, "config_dragon_pos", false)
				// let dragon_pos_cfg = model.GetPosCfg()
				let show = model.CanInsertDot(dragon_pos_cfg, now_select_pos_, true)
				this.replace_dot.visible = show
			}
		}

		this.SetStoveBtnImg = () => {
			let open = model.StoveOpenState(true)
			if (open) {
				this.AddUIEffect("ui_zhujiemianzhuanquan", this.stove_effect, null, 12.8, true)
			} else {
				this.ClearUIEffect(this.stove_effect)
			}
			this.CallLater(() => {
				RefBoxChildsLayout(this.iconBox, 8, 75);
			});
		}

		this.UpdateStoveIcon = () => {
			// if (CommonManager.GetInstance().CheckFunctionOpenStatus(181)) {
			// 	this.AddUIEffect("ui_zhujiemianzhuanquan", this.stove_effect, null, 12.8, true);
			// } else {
			// 	this.ClearUIEffect(this.stove_effect);
			// }
			RefBoxChildsLayout(this.iconBox,16)
		}
	}
	
	grid_con: Laya.HBox
	overview_con: Laya.Box
	bg1: Laya.Image
	fight_effect: Laya.Box
	fight_num_con: Laya.Box
	scroll_group: Laya.Box
	pro_group: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	pro_up_arrow: Laya.Image
	pro_scroll: Laya.Panel
	pro_con: Laya.VBox
	pro_down_arrow: Laya.Image
	effect_con: Laya.Box
	_Image2: Laya.Image
	_Label2: Laya.Label
	skill_up_arrow: Laya.Image
	skill_scroll: Laya.List
	// skill_group: Laya.VBox
	none_effect: Laya.Label
	skill_down_arrow: Laya.Image
	_Image0: Laya.Image
	all_level: Laya.Label
	iconBox: Laya.Box
	stoveBtn: Laya.Image
	stove_dot: Laya.Image
	stove_effect: Laya.Box
	bagBtn: Laya.Image
	bag_dot: Laya.Image
	detail_con: Laya.Box
	bg2: Laya.Image
	detail_scroll: Laya.Box
	detail_scroll_group: Laya.VBox
	detail_pro_group: Laya.VBox
	_Image3: Laya.Image
	_Label3: Laya.Label
	detail_pro_down_arrow: Laya.Image
	detail_pro_up_arrow: Laya.Image
	detail_pro_scroll: Laya.Panel
	detail_pro_con: Laya.VBox
	special_con: Laya.Box
	_Image4: Laya.Image
	_Image12: Laya.Image
	_Label4: Laya.Label
	special_str: Laya.HTMLDivElement
	detail_none_effect: Laya.Label
	skill_content: Laya.Box
	icon_bg: Laya.Image
	icon_bg_mask: Laya.Image
	icon: Laya.Image
	item_con: Laya.Box
	goods_lv: Laya.Label
	goods_fight_con: Laya.Box
	_Group1: Laya.HBox
	goods_name: Laya.Label
	style_icon: Laya.Image
	offBtn: Laya.Box
	_Image5: Laya.Image
	_Label5: Laya.Label
	replaceBtn: Laya.Box
	_Image6: Laya.Image
	_Label6: Laya.Label
	replace_dot: Laya.Image
	_Image7: Laya.Image
	upgrade_con: Laya.Box
	upgrade_bg: Laya.Image
	_Image8: Laya.Image
	con_label: Laya.Label
	cost_con: Laya.Box
	own: Laya.HTMLDivElement
	upgradeBtn: Laya.Box
	_Image9: Laya.Image
	upgrade_label: Laya.Label
	upgrade_dot: Laya.Image
	returnBtn: Laya.Image
	effect_group: Laya.Box
	max_conta: Laya.Box
	_Image11: Laya.Image
	_Label7: Laya.Label
	public GetComponents() {
		[
			this.grid_con,
			this.overview_con,
			this.bg1,
			this.fight_effect,
			this.fight_num_con,
			this.scroll_group,
			this.pro_group,
			this._Image1,
			this._Label1,
			this.pro_up_arrow,
			this.pro_scroll,
			this.pro_con,
			this.pro_down_arrow,
			this.effect_con,
			this._Image2,
			this._Label2,
			this.skill_up_arrow,
			this.skill_scroll,
			// this.skill_group,
			this.none_effect,
			this.skill_down_arrow,
			this._Image0,
			this.all_level,
			this.iconBox,
			this.stoveBtn,
			this.stove_dot,
			this.stove_effect,
			this.bagBtn,
			this.bag_dot,
			this.detail_con,
			this.bg2,
			this.detail_scroll,
			this.detail_scroll_group,
			this.detail_pro_group,
			this._Image3,
			this._Label3,
			this.detail_pro_down_arrow,
			this.detail_pro_up_arrow,
			this.detail_pro_scroll,
			this.detail_pro_con,
			this.special_con,
			this._Image4,
			this._Image12,
			this._Label4,
			this.special_str,
			this.detail_none_effect,
			this.skill_content,
			this.icon_bg,
			this.icon_bg_mask,
			this.icon,
			this.item_con,
			this.goods_lv,
			this.goods_fight_con,
			this._Group1,
			this.goods_name,
			this.style_icon,
			this.offBtn,
			this._Image5,
			this._Label5,
			this.replaceBtn,
			this._Image6,
			this._Label6,
			this.replace_dot,
			this._Image7,
			this.upgrade_con,
			this.upgrade_bg,
			this._Image8,
			this.con_label,
			this.cost_con,
			this.own,
			this.upgradeBtn,
			this._Image9,
			this.upgrade_label,
			this.upgrade_dot,
			this.returnBtn,
			this.effect_group,
			this.max_conta,
			this._Image11,
			this._Label7,
		]
			= this.GetChildrenByNames([

				"grid_con",
				"overview_con",
				"bg1",
				"fight_effect",
				"fight_num_con",
				"scroll_group",
				"pro_group",
				"_Image1",
				"_Label1",
				"pro_up_arrow",
				"pro_scroll",
				"pro_con",
				"pro_down_arrow",
				"effect_con",
				"_Image2",
				"_Label2",
				"skill_up_arrow",
				"skill_scroll",
				// "skill_group",
				"none_effect",
				"skill_down_arrow",
				"_Image0",
				"all_level",
				"iconBox",
				"stoveBtn",
				"stove_dot",
				"stove_effect",
				"bagBtn",
				"bag_dot",
				"detail_con",
				"bg2",
				"detail_scroll",
				"detail_scroll_group",
				"detail_pro_group",
				"_Image3",
				"_Label3",
				"detail_pro_down_arrow",
				"detail_pro_up_arrow",
				"detail_pro_scroll",
				"detail_pro_con",
				"special_con",
				"_Image4",
				"_Image12",
				"_Label4",
				"special_str",
				"detail_none_effect",
				"skill_content",
				"icon_bg",
				"icon_bg_mask",
				"icon",
				"item_con",
				"goods_lv",
				"goods_fight_con",
				"_Group1",
				"goods_name",
				"style_icon",
				"offBtn",
				"_Image5",
				"_Label5",
				"replaceBtn",
				"_Image6",
				"_Label6",
				"replace_dot",
				"_Image7",
				"upgrade_con",
				"upgrade_bg",
				"_Image8",
				"con_label",
				"cost_con",
				"own",
				"upgradeBtn",
				"_Image9",
				"upgrade_label",
				"upgrade_dot",
				"returnBtn",
				"effect_group",
				"max_conta",
				"_Image11",
				"_Label7",
			])
	}
}
 window["LungMainView"]= LungMainView