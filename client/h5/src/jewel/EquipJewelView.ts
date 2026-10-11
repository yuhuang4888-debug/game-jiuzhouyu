import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipEvent, EquipDefine } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { Message } from "../sysInfo/SysInfoController"
import { PlayBigEffect, Util } from "../util/Util"
import { EquipJewelItem } from "./EquipJewelItem"
import { EquipJewelPosItem } from "./EquipJewelPosItem"

export class EquipJewelView extends BaseItem1 {
	CreateJewelItems
	EmpbtnStrAll
	GetPowerOnProto
	InitEvent
	InitView
	LoadSuccess
	SetGradeData
	SetSelectDefault
	SetTrueDynmaic
	UpdateCurEquipInfo
	UpdateEquipItems
	UpdateJewelItems
	UpdatePower
	UpdateRedDot
	UpdateShowData
	UpdateShowItem
	UpdateView
	UpGemLv

	// 0镶嵌 1升级
	private btnType: number = 0;

	LocalDeleteMe: () => void

	jewel_lv_cfg

	public constructor(parent?) {
		super(parent)
		let model = EquipModel.GetInstance()
		let local_Message = Message
		let res_mgr = ResManager.GetInstance()
		let local_Util = Util
		let local_EquipEvent = EquipEvent
		let red_dot_mgr = RedDotManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		//let function_icon_model = FunctionOpenModel.GetInstance()
		let cur_grade_ = -1
		let equip_pos_list_ = EquipDefine.EQUIP_POS
		let equip_icon_list_ = []
		let jewel_item_list_ = []
		let show_item_ = null
		let unlock_cfg_ = null
		let master_cfg_ = null
		let limit_cfg_ = null
		let attr_cfg_ = null
		let cur_equip_info_ = null
		let enough_goods_ = false
		let is_max_ = false
		let fightingShowBigItem
		this.base_file = "jewel"
		this.layout_file = "EquipJewelView"

		this.preload_server_config = {
			"config_equip_stone_pos_unlock": false,
			"config_equip_whole_reward": false,
			"config_equip_strengthen_max": false,
			"config_equip_stone_inlay": false
		}

		this.load_callback = () => {
			this.jewel_lv_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_stone_lv
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btnStrAll, () => {
				if (this.btnType) {
					if (model.isOneKeyUpgrade) {
						local_Message.show("一键升级中，请稍候")
						return
					}

					let [type_id_dic_1, goods_id_dic_1] = model.GetRedDic(true);
					let isUpAll_1: boolean = cur_equip_info_.stone_list.some((data) => {
						return Boolean(type_id_dic_1[data.type_id]);
					})

					if(isUpAll_1){
						model.isOneKeyUpgrade = true;
						this.UpGemLv();
					}else{
						local_Message.show("暂无可升级宝石")
					}
				
				} else {
					if (model.is_setting) {
						local_Message.show("一键镶嵌中，请稍候")
						return
					}
					model.is_setting = true
					let equip_stone_inlay_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_inlay", false)
					let equip_stone_pos_unlock_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_pos_unlock", false)
					let success = model.DoSetAll(equip_stone_inlay_cfg, this.jewel_lv_cfg, equip_stone_pos_unlock_cfg)
					if (!success) {
						local_Message.show("暂无可镶嵌宝石")
					}
				}


			}, this, true)

			Util.AddClickEvent(this.btnMaster, () => {
				model.Fire(local_EquipEvent.OPEN_VIEW, "EquipJewelMasterView")
			}, this, true)

			this.BindEvent(model, local_EquipEvent.SELECT_JEWEL_EQUIP, (info?) => {
				cur_equip_info_ = info
				this.UpdateShowData(info)
				this.UpdateRedDot()
			})

			this.BindEvent(model, local_EquipEvent.SET_JEWEL, (info?) => {
				this.SetTrueDynmaic(info.equip_type, true)
				model.Fire(local_EquipEvent.SELECT_JEWEL_EQUIP, cur_equip_info_)
				this.img_redMaster.visible = model.CheckMasterRed(3)
				if (model.CheckMasterRed(3)) {
					model.CheckJewelRedAll()
				}
				this.UpdateRedDot();
				this.SetGradeData();
				this.GetPowerOnProto();
				if (!model.isOneKeyUpgrade) {
					selectUpRedPos: {
						let [type_id_dic, goods_id_dic] = model.GetRedDic(true);
						let equip_stone_inlay_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_inlay", false);
						let equip_stone_pos_unlock_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_pos_unlock", false);
						// 一键镶嵌红点
						let isStrAll: boolean = model.CheckEquipJewelRedAllChange(equip_stone_inlay_cfg, this.jewel_lv_cfg, equip_stone_pos_unlock_cfg);
						// 一键升级红点
						let equipInfos = model.GetWearEquipDynamics();
						let isUpAll: boolean = equipInfos.some((equip) => {
							return equip.stone_list.some((data) => {
								return Boolean(type_id_dic[data.type_id]);
							});
						})

						if (!isStrAll && isUpAll) {
							this.SetSelectDefault();
						}
					}
				}

			})

			this.BindEvent(model, local_EquipEvent.OFF_JEWEL, (info?) => {
				this.SetTrueDynmaic(info.equip_type)
				this.UpdateView()
			})

			this.BindEvent(model, local_EquipEvent.UPGRADE_JEWEL, (info?) => {
				this.SetTrueDynmaic(info.equip_type)
				this.UpdateView()
				this.UpGemLv();
			})

			this.BindEvent(model, local_EquipEvent.COMPOSE_JEWEL, (info?) => {
				this.UpdateView()
			})

			Util.AddClickEvent(this._img_crave, () => {
				model.Fire(local_EquipEvent.OPEN_VIEW, "EquipJewelCraveEnterView")
			}, this, true)

			this.BindEvent(model, local_EquipEvent.UPDATE_JEWEL_CARVE_RED, (bool?) => {
				this.crave_red.visible = red_dot_mgr.CheckRedStatus(ModuleType.JEWEL_CRAVE_RED)
			})

			this.BindEvent(goods_model, GoodsModel.CHANGE_EQUIPLIST, () => {
				if (!this.is_loaded || !unlock_cfg_
					|| !master_cfg_ || !limit_cfg_
					|| !attr_cfg_ || !this.jewel_lv_cfg) {
					return
				}
				this.UpdateCurEquipInfo()
				this.UpdateEquipItems()
				this.UpdateView()
				this.UpdateRedDot()
			})

			this.BindEvent(model, local_EquipEvent.UPDATE_JEWEL_RED, () => {
				this.UpdateRedDot()
				this.UpdateJewelItems()
			})

			this.BindEvent(model, local_EquipEvent.SUBTYPE_POWER, (scmd?) => {
				if (scmd.sub_mod != 1) {
					return
				}
				fightingShowBigItem.Updatefighting(scmd.power)
				fightingShowBigItem.horizontalCenter = 0
			})

			this.BindEvent(model, local_EquipEvent.UPDATE_MASTER_RED, () => {
				this.img_redMaster.visible = model.CheckMasterRed(3)
				this.SetGradeData()
			})
		}

		this.LoadSuccess = () => {
			unlock_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_pos_unlock", false)
			master_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_whole_reward", false)
			limit_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_strengthen_max", false)
			attr_cfg_ = res_mgr.GetGameConfigFromCache(this, "config_equip_attr", false)

			res_mgr.SetOutsideImageSprite(this, this.img_bg, "resource/game/jewel/other/uidz_004c.png")

			if (!this.use_delete_method) {
				// res_mgr.SetUIEffect2(this, "ui_arrary_gemstone", this._group_eff, null, null, true)
				fightingShowBigItem = new FightingShowSmallItem(this._fight_power)
				fightingShowBigItem.Load()

				for (let i = 0; i < equip_pos_list_.length; i++) {
					let pos = equip_pos_list_[i]
					let con = (i % 2 == 0 && (this.left_groupEquip) || (this.right_groupEquip))
					let item = new EquipJewelPosItem(con)
					item.SetEquipPos(pos)
					item.Load()
					equip_icon_list_[i] = item
				}
				this._img_crave.visible = CommonManager.GetInstance().CheckFuncOpenState("EquipJewelCraveEnterView", true)
				this.crave_red.visible = red_dot_mgr.CheckRedStatus(ModuleType.JEWEL_CRAVE_RED)
				this.InitEvent()
				this.InitView()
			}
		}

		this.InitView = () => {
			this.UpdateEquipItems()
			this.UpdateView()
			this.SetSelectDefault()
		}

		this.UpdateEquipItems = () => {
			let equipInfos = model.GetWearEquipDynamics()
			for (let key in equipInfos) {

				let info = equipInfos[key]
				let item: EquipJewelPosItem = equip_icon_list_[info.equip_type - 1]
				if (item) {
					//let attr_cfg = attr_cfg_[info.type_id]
					let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false)
					if (attr_cfg) {
						item.ExcuteCallback(() => {
							let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
							item.SetCfgs(limit_cfg, attr_cfg)
							item.SetData(info)
						}
						)
					}
				}
			}
		}

		this.UpdateView = () => {
			this.img_redMaster.visible = model.CheckMasterRed(3)
			this.SetGradeData()
			this.GetPowerOnProto()
			this.UpdateShowData(cur_equip_info_)
		}

		this.UpdateRedDot = () => {
			let equip_stone_inlay_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_inlay", false);
			let equip_stone_pos_unlock_cfg = res_mgr.GetGameConfigFromCache(this, "config_equip_stone_pos_unlock", false);
			let [type_id_dic, goods_id_dic] = model.GetRedDic();
			// 一键镶嵌红点
			let isStrAll: boolean = model.CheckEquipJewelRedAllChange(equip_stone_inlay_cfg, this.jewel_lv_cfg, equip_stone_pos_unlock_cfg);
			// 一键升级红点
			let isUpAll: boolean = cur_equip_info_.stone_list.some((data) => {
				return Boolean(type_id_dic[data.type_id]);
			})
			//  model.CheckEquipJewelRedOneUpgrade(cur_equip_info_, this.jewel_lv_cfg);

			//直升卡处理  一键升级这里不显示直升卡的红点
			let [type_id_dic_1, goods_id_dic_1] = model.GetRedDic(true);
			let isUpAll_1: boolean = cur_equip_info_.stone_list.some((data) => {
				return Boolean(type_id_dic_1[data.type_id]);
			})
			this.red_dot.visible = (isStrAll || isUpAll_1);

			this.lb_strAll.text = isStrAll ? '一键镶嵌' : isUpAll ? '一键升级' : '一键镶嵌';
			this.btnType = isStrAll ? 0 : isUpAll ? 1 : 0;
			let list = model.GetWearEquipDynamics()
			for (let _tmpi in list) {
				let info = list[_tmpi]
				let red = goods_id_dic[info.goods_id]
				let item = equip_icon_list_[info.equip_type - 1]
				item.ExcuteCallback(() => {
					item.SetRedStatus(Boolean(red))
				})
			}
		}


		this.SetSelectDefault = (curInfo) => {
			let list = model.GetWearEquipDynamics()
			if (list.length < 1) {
				return
			}
			let [type_id_dic, goods_id_dic] = model.GetRedDic(true);
			let info = list[0];

			let findInfo = list.find((data) => {
				return goods_id_dic[data.goods_id];
			});

			info = findInfo || (curInfo || info);

			let item: EquipJewelPosItem = equip_icon_list_[info.equip_type - 1]
			item.ExcuteCallback(() => {
				cur_equip_info_ = info
				this.UpdateShowData(info)
				model.Fire(local_EquipEvent.SELECT_JEWEL_EQUIP, info)
			}
			)
		}

		this.UpdateShowData = (info?) => {
			if (!info) {
				return
			}
			this.UpdateShowItem()
			this.UpdateJewelItems()
		}

		this.UpdateShowItem = () => {
			if (!cur_equip_info_) {
				return
			}
			let info = cur_equip_info_
			if (!show_item_) {
				show_item_ = new EquipJewelPosItem(this._gp_pos)
				//show_item_.x = 296.5
				//show_item_.y = 374.5
				show_item_.Load()
			}
			//let attr_cfg = attr_cfg_[info.type_id]
			show_item_.ExcuteCallback(() => {
				let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false)
				if (attr_cfg) {
					let limit_cfg = limit_cfg_[attr_cfg.stage + "@" + info.color + "@" + info.equip_type]
					show_item_.SetCfgs(limit_cfg, attr_cfg)
					show_item_.SetData(info)
				}

			})
		}

		this.CreateJewelItems = () => {
			if (jewel_item_list_.length > 0) {
				return
			}
			for (let pos of EquipDefine.JEWEL_POS) {
				let item: EquipJewelItem = new EquipJewelItem(this["pos_" + pos])
				item.SetJewelPos(pos)
				item.Load()
				jewel_item_list_[pos - 1] = item
			}
		}

		this.UpdateJewelItems = () => {
			this.CreateJewelItems()
			let open_list = []
			let info = cur_equip_info_
			if (!info || !info.stone_list) {
				return
			}
			let [type_id_dic, goods_id_dic] = model.GetRedDic();
			for (let i = 0; i < info.stone_list.length; i++) {
				let stdata = info.stone_list[i]
				let item: EquipJewelItem = jewel_item_list_[stdata.pos - 1]
				let lv_cfg = this.jewel_lv_cfg[stdata.type_id]
				item.SetCfgs(lv_cfg)
				item.SetInfos(info)
				item.ExcuteCallback(() => {
					item.SetRedStatus(type_id_dic[stdata.type_id])
					item.SetData(stdata)
				}
				)
				open_list[stdata.pos] = stdata.pos
				//table.insert(open_list, stdata.pos)
			}
			for (let pos of EquipDefine.JEWEL_POS) {
				let is_open = open_list[pos] != null
				if (!is_open) {
					let item: EquipJewelItem = jewel_item_list_[pos - 1]
					let unlock_cfg = unlock_cfg_[info.equip_type + "@" + pos]
					let attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, info.type_id, false)
					item.ExcuteCallback(() => {
						item.SetLockEmptyStatus(unlock_cfg, attr_cfg)
					}
					)
					item.SetInfos(info)
				}
			}
		}

		this.UpdatePower = () => {
			let equip_stone_refine_cfg = res_mgr.GetGameConfigFromCache(this, "Equipstonerefine", false)
			let power = model.GetWearEquipsJewelPower(this.jewel_lv_cfg, equip_stone_refine_cfg)
			//this._fight_power.Updatefighting(power)
		}

		this.GetPowerOnProto = () => {
			model.Fire(local_EquipEvent.REQUEST_PROTO, 15254, "c", 1)
		}

		this.SetGradeData = () => {
			let lv = model.GetMasterLv(3)
			let [_, _1, grade] = model.GetWholeAwardCfg(EquipDefine.JEWEL_WHOLE_TYPE, lv)
			this.grade.text = grade + "阶"
		}

		this.LocalDeleteMe = () => {
			//BaseAwardItem.EndBatchLoad()
			model.is_setting = false
			for (let key in equip_icon_list_) {

				equip_icon_list_[key].DeleteMe()
			}
			equip_icon_list_ = []
			for (let key in jewel_item_list_) {

				jewel_item_list_[key].DeleteMe()
			}
			jewel_item_list_ = []
			if (show_item_) {
				show_item_.DeleteMe()
				show_item_ = null
			}
			attr_cfg_ = null
			limit_cfg_ = null
			this.jewel_lv_cfg = null
			unlock_cfg_ = null
			master_cfg_ = null

			if (fightingShowBigItem != null) {
				fightingShowBigItem.DeleteMe()
			}
			fightingShowBigItem = null
			this.ClearUIEffect(this._group_eff)
			super.DeleteMe()
		}

		this.SetTrueDynmaic = (equip_type?, force?) => {
			if (force == null) {
				force = false
			}
			if (cur_equip_info_ && (force || cur_equip_info_.equip_type == equip_type)) {
				let wear_info = model.GetWearEquipInfo(equip_type)
				if (!wear_info) {
					return
				}
				let dynamic = goods_model.GetDynamic(wear_info.goods_id, null, false, true)
				cur_equip_info_ = dynamic
			}
		}

		this.UpdateCurEquipInfo = () => {
			if (!cur_equip_info_) {
				return
			}
			let equipInfos = model.GetWearEquipDynamics()
			for (let key in equipInfos) {

				let info = equipInfos[key]
				if (info.equip_type != cur_equip_info_.equip_type) {
					break
				}
				this.SetTrueDynmaic(info.equip_type)
			}
		}

		/**
		 *  宝石是否可以升级
		 */
		this.UpGemLv = () => {
			if (!model.isOneKeyUpgrade) {
				// 播放升级完成特效
				PlayBigEffect("ui_shengjitexiao");
				return;
			}

			let gems: { pos: number, type_id: number }[] = Util.DeepCopy(cur_equip_info_.stone_list);
			gems.sort((a, b) => {
				let aConf = this.jewel_lv_cfg[a.type_id];
				let bConf = this.jewel_lv_cfg[b.type_id];
				if (aConf.lv != bConf.lv) { // 等级低的在前面
					return aConf.lv - bConf.lv;
				}

				if (a.pos != b.pos) { // 位置低的在前面
					return a.pos - b.pos;
				}

				return 0;
			});

			let [type_id_dic, goods_id_dic] = model.GetRedDic(true);
			let stone: { pos: number, type_id: number } = gems.find((data, index) => {
				return Boolean(type_id_dic[data.type_id]);
			});

			if (stone) {
				// 继续循环调用
				model.Fire(EquipEvent.REQUEST_PROTO, 15215, "ccc", cur_equip_info_.equip_type, stone.pos, 0)
			} else {
				model.isOneKeyUpgrade = false;
				// 播放升级完成特效
				PlayBigEffect("ui_shengjitexiao");
				// 选中下一个可合成的部位
				this.SetSelectDefault(cur_equip_info_);
			}
		}

	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_model.curr_view_story_step = 1
		this.story_obj_list[TaskTipType.EquipStoneNum] = [null, this.btnStrAll, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]
		super.createChildren()
	}


	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	img_bg: Laya.Image
	_fight_power: Laya.Box
	left_groupEquip: Laya.VBox
	right_groupEquip: Laya.VBox
	_group_eff: Laya.Box
	pos_6: Laya.Box
	pos_1: Laya.Box
	pos_2: Laya.Box
	pos_5: Laya.Box
	pos_4: Laya.Box
	pos_3: Laya.Box
	btnStrAll: Laya.Image
	lb_strAll: Laya.Label
	red_dot: Laya.Image
	_Group1: Laya.Box
	btnMaster: Laya.Image
	grade: Laya.Label
	img_redMaster: Laya.Image
	_img_crave: Laya.Image
	crave_red: Laya.Image
	_gp_pos: Laya.Box
	public GetComponents() {
		[
			this.img_bg,
			this._fight_power,
			this.left_groupEquip,
			this.right_groupEquip,
			this._group_eff,
			this.pos_6,
			this.pos_1,
			this.pos_2,
			this.pos_5,
			this.pos_4,
			this.pos_3,
			this.btnStrAll,
			this.lb_strAll,
			this.red_dot,
			this._Group1,
			this.btnMaster,
			this.grade,
			this.img_redMaster,
			this._img_crave,
			this.crave_red,
			this._gp_pos,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"_fight_power",
				"left_groupEquip",
				"right_groupEquip",
				"_group_eff",
				"pos_6",
				"pos_1",
				"pos_2",
				"pos_5",
				"pos_4",
				"pos_3",
				"btnStrAll",
				"lb_strAll",
				"red_dot",
				"_Group1",
				"btnMaster",
				"grade",
				"img_redMaster",
				"_img_crave",
				"crave_red",
				"_gp_pos",
			])
	}
}
window["EquipJewelView"] = EquipJewelView