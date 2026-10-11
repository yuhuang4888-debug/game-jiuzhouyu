import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { MaterialsTool } from "../common/MaterialsTool"
import { OpenFun } from "../common/OpenFun"
import { ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EnumMedalCostType, MedalCostParam, MedalModel } from "../commonModel/MedalModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, Util, SetLocalPositionX, GlobalTimerQuest } from "../util/Util"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MedalCostItem } from "./MedalCostItem"

export class MedalView extends BaseItem1 {
	InitEvent
	LoadSuccess
	_Group1
	_Group3
	_Group5
	_Group6
	_Image1
	_Label2
	_bottom_left
	_btn_dungeon
	_gp
	_gp_cur
	_gp_dungeon
	_gp_fight
	_gp_goods
	_gp_icon
	_gp_medal_bg2_effect
	_gp_medal_effect
	_gp_needGoods
	_gp_next
	_gp_star
	_gp_star_change_effect
	_gp_star_up_effect
	_gp_txt_effect
	_img_dungeon_full
	_img_fight_full
	_img_full
	_img_medal_icon
	_img_medal_question
	_img_txt
	_img_txt_cur
	_img_txt_next
	_lb_cur_Name
	_lb_cur_attr: Laya.HTMLDivElement
	_lb_cur_next: Laya.HTMLDivElement
	_lb_cur_attr1: Laya.HTMLDivElement
	_lb_cur_next1: Laya.HTMLDivElement
	_lb_dungeon
	_lb_fight
	_lb_next_Name
	_lb_num
	_red_dot
	_satr0
	_satr1
	_satr2
	_satr3
	_satr4
	_satr5
	_satr6
	_satr7
	_satr8
	_satref0
	_satref1
	_satref2
	_satref3
	_satref4
	_satref5
	_satref6
	_satref7
	_satref8
	_str_red
	btnUp
	can_gp_cur
	can_gp_next
	clean_star_effect
	// createChildren
	goodsItem
	labelDisplay
	medalImage
	medalName
	medalNullGroup
	nullLabel
	removeTimer
	showMedalStrBtn
	story_obj_list
	successUpEffect
	successUpStarEffect
	updateCur
	updateNext
	updateStart
	updateStrRed
	updateView
	successUpMaxEffect
	_img_666
	_img_777
	medal_star_bg
	medal_bg

	txt_bg_group: Laya.Box
	txt_bg_img: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_Image666: Laya.Box
	_Scroller2: Laya.Panel
	Content1: Laya.Box
	_Image2: Laya.Box
	_Image3: Laya.Image
	_Label1: Laya.Label
	medal_title1: Laya.Image
	_gp_star_bg: Laya.Box
	_gp_title: Laya.Box
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Label3: Laya.Label
	_Image7: Laya.Image
	_Label4: Laya.Label
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	_Image8: Laya.Image
	_Label5: Laya.Label
	_icon: Laya.Image
	_gp_max: Laya.Box
	giftIcon: Laya.Box
	LocalDeleteMe: any
	costList: Laya.List;


	private costs: MedalCostParam[];
	private giftItem: GiftPushIcon;
	private loop_mgr: LoopScrowViewMgr;
	private isJump: boolean = false;

	public constructor(parent?) {
		super(parent)

		this.base_file = "medal"
		this.layout_file = "MedalView"
		let _model: MedalModel = MedalModel.GetInstance()
		let _value = 0
		let _max = 0
		let _need_id = 0
		let fightMax = 0
		let _touchTime = 0
		let lastMedal = 0
		let lastStar = null
		let full_floor = true
		let _conf = null
		let gp_cur_alpha = false
		let gp_next_move = false
		let gp_next_alpha = false
		let cost_cfg = null
		let line_add_Pos = [{ x: 130, y: 88 }, { x: 162, y: 35 }, { x: 140, y: -25 }, { x: 85, y: -80 }, { x: 32, y: -90 }, { x: -30, y: -75 }, { x: -65, y: -25 }, { x: -90, y: 29 }, { x: -80, y: 90 }]
		//let _local_MedalEvent = MedalEvent
		let _local_RoleManager = RoleManager.GetInstance()
		let _local_ResManager = ResManager.GetInstance()
		let _local_GoodsModel = GoodsModel.GetInstance()
		let _local_ErlangParser = ErlangParser.GetInstance()
		let timerId = null
		let time = 0
		let tween_list = []
		//
		this.preload_server_config = { "config_medal": false, "config_medal_stren_cost": false, "config_medal_stren_lv": false }

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label2.size = 20
			}
			if (PlatformManager.IsEyouEnPlatform()) {
				this.nullLabel.size = 18
				SetAnchoredPositionX(this._Group3, -21)
				SetAnchoredPositionX(this._Group1, -23)
				this.medalName.size = 18
			}
			// ResManager.GetInstance().SetImageSprite(this,this._img_666,"medal","uixz_003")
			// ResManager.GetInstance().SetImageSprite(this,this._img_777,"medal","uixz_003")
			ResManager.GetInstance().SetOutsideImageSprite(this, this.medal_star_bg, "resource/game/medal/texture/uixz_bg1.png")
			ResManager.GetInstance().SetImageSpriteTrans(this, this.medal_bg, "resource/game/medal/texture/medalbg.png")
		}



		this.InitEvent = () => {

			this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
				this.ShowGiftIcon();
			})

			let clickUpHandler = () => {
				if (this.isJump) {
					OpenFun.OpenFunHandler(6);
					return
				}
				let severTime = TimeUtil.getServerTimeMs()
				if (severTime - _touchTime < 1000) {
					return
				}
				if (_value < _max) {
					MaterialsTool.GetInstance().materialsTips(_need_id, null)
					MaterialsTool.GetInstance().
						return
				}
				let fight = _local_RoleManager.GetMainRoleVo().fighting
				if (fight < fightMax) {
					Message.show("战力不足")
					return
				}
				if (!full_floor) {
					Message.show("未通关指定副本")
					return
				}
				_touchTime = severTime
				_model.Fire(MedalModel.MedalUP)
				this.FuncFirstOpenClick()
			}
			Util.AddClickEvent(this.btnUp, clickUpHandler, this, true)
			this.BindEvent(_model, MedalModel.UpdateInfo, () => {
				if (gp_cur_alpha || gp_next_move || gp_next_alpha) {
					this.updateCur()
					this.updateNext()
				}
				this.updateView()
			}
			)
			Util.AddClickEvent(this._btn_dungeon, () => {
				OpenFun.OpenFunHandler(6)
			}
				, this)
			Util.AddClickEvent(this._gp_icon, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MedalStrengthenView")
			}
				, this, true)
			this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType?, rType?) => {
				if ((this._gp_icon.visible && mType == ModuleType.MEDAL_STRENGTHEN) && rType == 1) {
					this.updateStrRed()
				}
			}
			)
			this.BindEvent(MedalModel.GetInstance(), MedalModel.CHANGE_RED_DOT, () => {
				if (!this.use_delete_method) {
					this.updateView(true)
					// LayoutRebuilder(this._gp_needGoods)
				}
			}
			)
		}

		this.LoadSuccess = () => {
			_local_ResManager.SetImageSpriteTrans(this, this._img_medal_icon, GameResPath.GetIcon("medal", "uixunzhang_010"))
			_local_ResManager.SetImageSpriteTrans(this, this._img_medal_question, GameResPath.GetIcon("medal", "uixunzhang_008"))
			// _local_ResManager.SetOutsideImageSprite(this, this._bottom_left, GameResPath.GetIcon("medal","uixunzhang_011"))
			cost_cfg = _local_ResManager.GetGameConfigFromCache(this, "config_medal_stren_cost", false)
			this.updateCur()
			this.updateNext()
			this.updateView()
			this.ShowGiftIcon()
			// LayoutRebuilder(this._Group6)
			this.UpdateFuncFirstState()
		}


		this.updateStrRed = () => {
			this._str_red.visible = _model.CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1)
		}

		this.showMedalStrBtn = () => {
			let medalLevId = _model.medalLevId()
			if (!this._gp_icon.visible) {
				for (let key in cost_cfg) {

					let element = cost_cfg[key]
					this._gp_icon.visible = medalLevId >= element.medal_lv
					this.updateStrRed()
					break
				}
			}
		}


		this.updateView = (ChangeGood?) => {
			let config_medal = _local_ResManager.GetGameConfigFromCache(this, "config_medal", false)
			let nextConf = _model.medalNextConfig(config_medal)
			if (config_medal) {
				_conf = _model.medalConfig(config_medal)
				if (_model.successUp) {
					if (nextConf) {
						this.successUpEffect()
					} else {
						this.successUpMaxEffect()
					}
					this.successUpStarEffect()
					return
				}
				let medalStar = _conf && _conf.medal_start || 0
				if (!ChangeGood) {
					if (_conf.id == 131) {
						this.updateStart(9)
					} else {
						this.updateStart(medalStar)
					}
				}
				lastMedal = _conf && _conf.large_image_id || 0

				this._red_dot.visible = _model.CheckRedStatus(ModuleType.MEDAL, 1)
				this.medalNullGroup.visible = _conf.id == 1
				this.medalImage.visible = _conf.id != 1
				if (medalStar >= this._gp_star.numChildren) {
					//ResManager.GetInstance().SetImageSprite(this,this._Image1,"common_asset","com_rect_btn11")
					//this.labelDisplay.strokeColor = "#2f999f"
					this.labelDisplay.text = "晋升"
				} else {
					//ResManager.GetInstance().SetImageSprite(this,this._Image1,"common_asset","com_rect_btn5")
					//this.labelDisplay.strokeColor = "#dd6b36"
					this.labelDisplay.text = _conf.id == 1 ? "激活" : "升级";
				}
				if (this.medalImage.visible) {
					ResManager.GetInstance().SetImageSprite(this, this.medalImage, "medal", _conf.large_image_id)
				}
				// this.medalImage.visible=false
				this.medalName.text = _conf.id == 1 ? _conf.medal_name : _local_RoleManager.GetMainRoleVo().name;
				//this._img_txt.SetActive( _conf.large_image_id != 0);
				this._img_txt.visible = _conf.large_image_id != 0
				// this._img_txt.includeInLayout = this._img_txt.visible
				if (this._img_txt.visible) {
					ResManager.GetInstance().SetImageSprite(this, this._img_txt, "mainUI", "tx_" + _conf.title)
					this.medalName.x = 81;
				} else {
					this.medalName.x = 41;
				}
				//LayoutRebuilder(this._Group5)
				//this._gp_needGoods.SetActive ( this._gp_needGoods)
				this._gp_needGoods.visible = _conf.cost != "[]";
				if ((this._gp_needGoods.visible && _conf) && JSON.parse(_conf.cost).length > 0) {
					_max = Number(JSON.parse(_conf.cost)[0][2])
					_need_id = Number(JSON.parse(_conf.cost)[0][1])
				} else {
					_max = 0
					_value = 0
				}
				this._img_full.visible = false
				if (this._gp_needGoods.visible) {
					_value = _local_GoodsModel.GetTypeGoodsNum(_need_id)
					if (!this.goodsItem) {
						this.goodsItem = new EquipmentItem(this._gp_goods)
						this.goodsItem.SetScale(0.4);
						this.goodsItem.Load()
					}
					let goods_vo = _local_GoodsModel.GetGoodsBasicByTypeId(_need_id)
					if (goods_vo) {
						this.goodsItem.SetData(goods_vo.type_id)
						// this._lb_num.text = _value + "/" + _max
						// let color = _value < _max && ColorUtil.GetColorDark(ColorType.RED) || ColorUtil.GetColorDark(ColorType.GREEN)
						// this._lb_num.color = color
						//////
						this._lb_num.style.fontSize = 20
						this._lb_num.style.color = "#0a953e"
						let str = (_value >= _max && ("<font color='#0a953e'>" + _value + "</font>" + "/" + _max) || ("<font color='#ff4f50'>" + _value + "</font>" + "/" + _max))
						this._lb_num.innerHTML = Util.StrToHTML(str)
						this._lb_num.width = 200;
						//this._img_full.SetActive (_value >= _max)
						this._img_full.visible = _value >= _max
						this._img_full.x = this._lb_num.x + this._lb_num.contextWidth
					}
					//LayoutRebuilder(this._gp_needGoods)
				}
				fightMax = Number(_conf.upgrade_power)
				this._gp_fight.visible = fightMax > 0
				this._gp_dungeon.visible = _conf.other_condition != "[]"
				if (this._gp_fight.visible) {
					let fight = _local_RoleManager.GetMainRoleVo().fighting
					let str2 = (fight >= fightMax && ("<font color='#0a953e'>" + fight + "</font>" + "/" + fightMax) || ("<font color='#ff4f50'>" + fight + "</font>" + "/" + fightMax));
					this._lb_fight.style.fontSize = 20
					this._lb_fight.style.color = "#0a953e"
					this._lb_fight.innerHTML = Util.StrToHTML(str2)
					this._lb_fight.width = 1200;
					this._img_fight_full.visible = fight >= fightMax
					// this._gp_fight.height=50;
					this._img_fight_full.x = this._lb_fight.x + this._lb_fight.contextWidth
					//LayoutRebuilder(this._gp_fight)
				} else {
					// this._gp_fight.height=0;
				}
				if (this._gp_dungeon.visible) {
					let otherCondition = JSON.parse(_conf.other_condition);
					let costNum: number = otherCondition[0][1];
					//let layer = dun_id - BaseDungeonModel.Rune_Floor_Modulus
					// let layer
					// let cur_floor = 0
					// //let dun_list = BaseDungeonModel.GetInstance().GetDungeonInfo(DUN_TYPE.Rune)
					// let dun_list
					//if (dun_list ) {
					//for (let key in dun_list) {

					//if (dun_list[key].permanent_count > 0 ) {
					//cur_floor = Number(key) + 1
					//}
					//}
					//}
					//cur_floor =  BaseDungeonModel.GetRuneCurFloor()
					full_floor = _model.passLayers >= costNum;
					// let color = full_floor && ColorUtil.GetColorDark(ColorType.GREEN) || ColorUtil.GetColorDark(ColorType.RED)
					// this._lb_dungeon.text = "符文高塔" + layer + "层"
					// this._lb_dungeon.color = color
					// //this._btn_dungeon.SetActive (! full_floor)
					// this._btn_dungeon.visible = !full_floor
					// //this._img_dungeon_full.SetActive (full_floor)
					// this._img_dungeon_full.visible = full_floor;
					// LayoutRebuilder(this._gp_dungeon)
				}

				// 消耗数据
				this.costs = [];

				// 先判断战力
				if (fightMax > 0) {
					this.costs.push({ type: EnumMedalCostType.ePower, con: fightMax, layerNum: _model.passLayers });
				}

				// 判断层数
				if (_conf.other_condition != "[]") {
					this.costs.push({ type: EnumMedalCostType.eLayerNum, con: _conf.other_condition, layerNum: _model.passLayers });
				}

				// 判断道具消耗
				if (_conf.cost != "[]") {
					this.costs.push({ type: EnumMedalCostType.eItem, con: _conf.cost, layerNum: _model.passLayers });
				}

				// 判断是否需要跳转

				let find: MedalCostParam = this.costs.find((data: MedalCostParam) => {
					return data.type == EnumMedalCostType.eLayerNum;
				});

				if (find) {
					let otherCondition = JSON.parse(String(find.con));
					let costNum: number = otherCondition[0][1];
					this.isJump = _model.passLayers < costNum;
				}

				if (this.isJump) {
					this.labelDisplay.text = '前往挑战';
				}

				this.renderCost();

			}
			// LayoutRebuilder(this._gp)
			this.showMedalStrBtn()
		}

		this.updateCur = () => {
			let config_medal = ResManager.GetInstance().GetGameConfigFromCache(this, "config_medal", false)
			let _conf = null
			let nextConf
			if (config_medal) {
				_conf = _model.medalConfig(config_medal)
				nextConf = _model.medalNextConfig(config_medal)
			}
			this._lb_cur_Name.text = "未获得"
			this._img_txt_cur.visible = _conf.large_image_id != 0
			// this._img_txt_cur.includeInLayout=this._img_txt_cur.visible
			if (this._img_txt_cur.visible) {
				ResManager.GetInstance().SetImageSprite(this, this._img_txt_cur, "mainUI", "tx_" + _conf.title)
			}
			if (_conf) {
				// [ts2lua]lua中0和空字符串也是true，此处_conf需要确认
				let medalStar = (_conf && (_conf.medal_start) || (0))
				this.nullLabel.visible = _conf.id == 1
				this._lb_cur_Name.text = _conf.medal_name
				let cur_list = JSON.parse(_conf.add_attr)

				this._lb_cur_attr.x = cur_list?.length > 2 ? 0 : 20;

				this._lb_cur_attr.width = 227
				this._lb_cur_attr.style.color = "#FFFFFF";
				this._lb_cur_attr.style.fontSize = 20;
				this._lb_cur_attr.style.align = "center";
				this._lb_cur_attr.innerHTML = Util.StrToHTML(_model.medalAttrList(cur_list, "'#663915'", "'#c85a37'"));
				this._lb_cur_attr.style.leading = 8;
				this._lb_cur_attr.style.padding = [(180 - this._lb_cur_attr.contextHeight) * 0.25, 0, 0, 0];

				this._lb_cur_attr1.width = 227
				this._lb_cur_attr1.style.color = "#FFFFFF";
				this._lb_cur_attr1.style.fontSize = 20;
				this._lb_cur_attr1.style.align = "center";
				this._lb_cur_attr1.innerHTML = Util.StrToHTML(_model.medalAttrListValue(cur_list, "'#663915'", "'#c85a37'"));
				this._lb_cur_attr1.style.leading = 8;
				this._lb_cur_attr1.style.padding = [(180 - this._lb_cur_attr.contextHeight) * 0.25, 0, 0, 0];
			}
			if (this._lb_cur_Name.text == "未获得") {
				this._lb_cur_Name.left = 20
			} else {
				this._lb_cur_Name.left = NaN
			}
			if (!nextConf) {
				this._gp_cur.x = 250
				this._Image5.visible = false
			}
		}

		this.updateNext = () => {
			let config_medal = _local_ResManager.GetGameConfigFromCache(this, "config_medal", false)
			let nextConf = null
			if (config_medal) {
				nextConf = _model.medalNextConfig(config_medal)
			}
			this._gp_max.visible = !nextConf
			this._img_txt_next.visible = nextConf != null
			if (nextConf && nextConf.title != 0) {
				ResManager.GetInstance().SetImageSprite(this, this._img_txt_next, "mainUI", "tx_" + nextConf.title)
			}
			if (nextConf) {
				this._lb_next_Name.text = nextConf.medal_name
				// [ts2lua]lua中0和空字符串也是true，此处not nextConf需要确认
				let next_list = !nextConf && {} || JSON.parse(nextConf.add_attr)

				if(PlatformManager.IsEyouEnPlatform()){
					this._lb_cur_next.x = next_list?.length > 2 ? -40 : 20;
					this._lb_cur_next1.x = 145
				}else{
				this._lb_cur_next.x = next_list?.length > 2 ? 0 : 20;
				}

				this._lb_cur_next.width = 227
				this._lb_cur_next.style.color = "#FFFFFF";
				this._lb_cur_next.style.fontSize = 20;
				this._lb_cur_next.style.align = "center";
				this._lb_cur_next.innerHTML = Util.StrToHTML(_model.medalAttrList(next_list, "'#663915'", "'#0a953e'"))
				this._lb_cur_next.style.leading = 8;
				this._lb_cur_next.style.padding = [(180 - this._lb_cur_next.contextHeight) * 0.25, 0, 0, 0];

				this._lb_cur_next1.width = 227
				this._lb_cur_next1.style.color = "#FFFFFF";
				this._lb_cur_next1.style.fontSize = 20;
				this._lb_cur_next1.style.align = "center";
				this._lb_cur_next1.innerHTML = Util.StrToHTML(_model.medalAttrListValue(next_list, "'#663915'", "'#0a953e'"))
				this._lb_cur_next1.style.leading = 8;
				this._lb_cur_next1.style.padding = [(180 - this._lb_cur_next.contextHeight) * 0.25, 0, 0, 0];
				// this._lb_cur_next.x=24
				// this._lb_cur_next.y=59
			} else {
				this._gp_next.visible = false
				this._lb_next_Name.text = '已满阶'
				this._lb_next_Name.centerX = -10
				this._lb_cur_next.innerHTML = ''
			}
			// LayoutRebuilder(this._Group3)
		}

		this.updateStart = (medalStar?) => {
			let init = false
			if (!lastStar) {
				init = true
			}

			if (init) {

				for (let i = 0; i <= this._gp_star.numChildren - 1; i += 1) {
					let _img = this["_satr" + i]
					let trans_gp = this["_satref" + i]
					if (i < medalStar) {
						ResManager.GetInstance().SetImageSprite(this, _img, "medal", "uixz_010")
						// let load_call_back=()=>{
						// 	//this.CoverEffect(this._gp_star,"UI")
						// }
						// this.AddUIEffect("UI_1202","UI",trans_gp, {x :33 , y:-38},0.8 , true, load_call_back)
					}
				}
			} else {
				if (_conf && _conf.id == 131) {
					for (let i = 0; i <= this._gp_star.numChildren - 1; i += 1) {
						let _img = this["_satr" + i]
						ResManager.GetInstance().SetImageSprite(this, _img, "medal", "uixz_010")
					}
				}
				else if (lastStar == this._gp_star.numChildren) {
					this.clean_star_effect()

					for (let i = 0; i <= this._gp_star.numChildren - 1; i += 1) {
						let _img = this["_satr" + i]
						ResManager.GetInstance().SetImageSprite(this, _img, "medal", "uixz_009b")
					}
				} else {
					let _medalStar = _conf && _conf.medal_start || 1
					let index = Math.max(_medalStar - 1, 0)
					let trans_gp = this["_satref" + index]
					let _img = this["_satr" + index]
					ResManager.GetInstance().SetImageSprite(this, _img, "medal", "uixz_010")
					this.ClearUIEffect(trans_gp)
					// let load_call_back=()=>{
					// 	//this.CoverEffect(this._gp_star,"UI")
					// }
					// this.AddUIEffect("UI_1202","UI",trans_gp, {x :33 , y :-38},0.8 , true, load_call_back)
				}
			}
			lastStar = medalStar
		}

		this.successUpEffect = () => {
			if (!gp_cur_alpha) {
				let cur_alpha_fun = () => {
					this.updateCur()
					gp_cur_alpha = true
					this.successUpEffect()
				}
				let tweenId = SYTweenLite.to(this, this._gp_cur, SYTweenLite.UiAnimationType.ALPHA, 0, 0.1, cur_alpha_fun)
				table.insert(tween_list, tweenId)
				return
			}
			if (!gp_next_move) {
				let next_move_fun = () => {
					this._gp_next.alpha = 0
					this._gp_cur.alpha = 1
					this.updateNext()
					SetLocalPositionX(this._gp_next, 418)
					gp_next_move = true
					this.successUpEffect()
				}
				let tweenId = SYTweenLite.to(this, this._gp_next, SYTweenLite.UiAnimationType.POSX, 124, 0.3, next_move_fun)
				table.insert(tween_list, tweenId)
				return
			}
			if (!gp_next_alpha) {
				let next_alpha_fun = () => {
					gp_next_alpha = true
					this.successUpEffect()
				}
				let tweenId = SYTweenLite.to(this, this._gp_next, SYTweenLite.UiAnimationType.ALPHA, 1, 0.1, next_alpha_fun)
				table.insert(tween_list, tweenId)
				return
			}
			gp_cur_alpha = false
			gp_next_move = false
			gp_next_alpha = false
		}
		this.successUpMaxEffect = () => {
			if (!gp_cur_alpha) {
				let cur_alpha_fun = () => {
					this.updateCur()
					gp_cur_alpha = true
					this.successUpMaxEffect()
				}
				let tweenId = SYTweenLite.to(this, this._gp_cur, SYTweenLite.UiAnimationType.ALPHA, 0, 0.1, cur_alpha_fun)
				table.insert(tween_list, tweenId)
				return
			}
			if (!gp_next_move) {
				let next_move_fun = () => {
					this._gp_next.alpha = 0
					this._gp_cur.alpha = 1
					this.updateNext()
					SetLocalPositionX(this._gp_cur, 250)
					// gp_next_move = true
					this.successUpMaxEffect()
				}
				let tweenId = SYTweenLite.to(this, this._gp_next, SYTweenLite.UiAnimationType.POSX, 250, 0.3, next_move_fun)
				table.insert(tween_list, tweenId)
				return
			}
			// if (! gp_next_alpha ) {
			// 	let  next_alpha_fun= ()=>{
			// 		gp_next_alpha = true
			// 		this.successUpMaxEffect()
			// 	}
			// 	let tweenId = SYTweenLite.to(this,this._gp_next,SYTweenLite.UiAnimationType.ALPHA,1,0.1,next_alpha_fun)
			// 	table.insert(tween_list,tweenId)
			// 	return
			// }
			gp_cur_alpha = false
			gp_next_move = false
			gp_next_alpha = false
		}
		this.successUpStarEffect = () => {
			_model.successUp = false
			if (lastStar == this._gp_star.numChildren) {
				this.updateView()
				this.removeTimer()
				let timerFun = () => {
					if (time == 5) {
						//
						for (let i = 0; i <= this._gp_star.numChildren - 1; i += 1) {
							//let trans_img = this["trans_satr" + i]
							//lua_resM:SetUIEffect2(this,"ui_medal_UIiconglow2", this._gp_star_up_effect, {x=trans_img.anchoredPosition.x + 25, y=trans_img.anchoredPosition.y + 30}, null, false)
							//let rotation = 30 - i * 30
							//let addPos = line_add_Pos[0]
							//lua_resM:SetUIEffect2(this,"ui_medal_lineglow", this._gp_star_change_effect, {x=trans_img.anchoredPosition.x + addPos.x, y=trans_img.anchoredPosition.y + addPos.y}, null, false, null, null, null, null, null, null, null, null, null, rotation)
							//}
						}
					}
					else if (time == 15) {
						// this.AddUIEffect("UI_1203", "UI",this._gp_medal_bg2_effect , {x:3, y:-10}, 1)
						// this.updateView()
					}
					else if (time == 25) {
						//lua_resM:SetUIEffect2(this,"ui_medal_glow" + _conf.large_image_id, this._gp_medal_effect, null, null, false)
					}
					else if (time == 95) {
						//lua_resM:SetUIEffect2(this,"ui_Textgrading_glow", this._gp_txt_effect, {x=0, y=38}, 0.5,false)
						this.removeTimer()
					}
					time = time + 1
				}
				timerId = GlobalTimerQuest.AddPeriodQuest(timerFun, 0.01)
			} else {
				let medalStar = _conf && _conf.medal_start || 1
				let index = Math.max(medalStar - 1, 0)
				let trans_img = this["trans_satr" + index]
				this.ClearUIEffect(this._gp_star_up_effect)
				this.updateView()
				// let load_call_back=()=>{
				// 	this.updateView()
				// }
				// this.AddUIEffect("ui_medal_activate", "UI", this._gp_star_up_effect, {x:trans_img.anchoredPosition.x + 27, y:trans_img.anchoredPosition.y - 35}, null, false,load_call_back)
			}
		}

		this.removeTimer = () => {
			if ((timerId != null)) {
				GlobalTimerQuest.CancelQuest(timerId)
				timerId = null
			}
			time = 0
		}

		this.clean_star_effect = () => {
			if (!this._gp_star) {
				return
			}

			for (let i = 0; i <= this._gp_star.numChildren - 1; i += 1) {
				let trans_gp = this["trans_satref" + i]
				this.ClearUIEffect(trans_gp)
			}
		}

		this.LocalDeleteMe = () => {
			this.removeTimer()
			this.clean_star_effect()
			if (tween_list != []) {
				for (let i in tween_list) {
					var v = tween_list[i]
					SYTweenLite.Stop(v);
				}
				tween_list = []
			}

			this.ClearUIEffect(this._gp_star_up_effect)
			this.ClearUIEffect(this._gp_star_change_effect)
			this.ClearUIEffect(this._gp_medal_bg2_effect)
			this.ClearUIEffect(this._gp_medal_effect)
			this.use_delete_method = false;
			if (this.giftItem) {
				this.giftItem.DeleteMe();
				this.giftItem = null;
			}
			this.ClearFuncFirst()
			super.DeleteMe()
		}
	}

	private renderCost() {
		let costs: MedalCostParam[] = this.costs;
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.costList, MedalCostItem, this.costs);
		} else {
			this.loop_mgr.replaceAll(this.costs);
		}

		// 计算高度
		let len: number = costs.length > 3 ? 3 : costs.length;
		let spaceNum: number = len > 1 ? len - 1 : 0;
		let h: number = len * 38 + spaceNum * this.costList.spaceX;
		this.costList.height = h;

	}

	private ShowGiftIcon() {
		let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eJingJie));
		if (bool) {
			if (!this.giftItem) {
				this.giftItem = new GiftPushIcon(this.giftIcon);
				this.giftItem.Load();
			}
			this.giftItem.ExcuteCallback(() => {
				this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eJingJie);
			});

		}
		this.giftIcon.visible = bool;
	}


	public FuncFirstOpenClick() {
		if (this.has_set_func_first_state) {
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.AddStep(FuncFirstOpenKey.Medal)
			this.ClearFuncFirst()
		}
	}


	has_set_func_first_state
	public UpdateFuncFirstState() {
		let func_first_mgr = FuncFirstOpenManager.GetInstance()
		if (this.CheckFuncFirstValue() && !func_first_mgr.CheckFuncFirstOpenState(FuncFirstOpenKey.Medal)) {
			func_first_mgr.AddStepSprite(FuncFirstOpenKey.Medal, 1, this.btnUp)
			func_first_mgr.UpdateStepState(FuncFirstOpenKey.Medal)
			this.has_set_func_first_state = true
		}
		else {
			this.ClearFuncFirst()
		}
	}

	//当前数据源是否是需要引导的那条数据
	public CheckFuncFirstValue() {
		return true
	}

	public ClearFuncFirst() {
		if (this.has_set_func_first_state) {
			this.has_set_func_first_state = false
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.ClearStepSprite(FuncFirstOpenKey.Medal, 1)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.btnUp)
		}
	}


	public DeleteMe() {
		this.LocalDeleteMe()
	}

	public createChildren() {
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.UpgradeMedal] = ["", this.btnUp]
		super.createChildren()
	}
	public GetComponents() {
		[
			this.txt_bg_group,
			this.txt_bg_img,
			this._gp_cur,
			this._Scroller1,
			this.Content,
			this._Image666,
			this._img_666,
			this._Group1,
			this._img_txt_cur,
			this._lb_cur_Name,
			this._lb_cur_attr,
			this.nullLabel,
			this._gp_next,
			this._Scroller2,
			this.Content1,
			this._Image2,
			this._img_777,
			this._Group3,
			this._img_txt_next,
			this._lb_next_Name,
			this._lb_cur_next,
			this._Image3,
			this._Label1,
			this._gp_medal_bg2_effect,
			this.medal_bg,
			this.medalNullGroup,
			this._img_medal_icon,
			this._img_medal_question,
			this.medalImage,
			this.medal_title1,
			this._Group5,
			this._img_txt,
			this.medalName,
			this._gp_txt_effect,
			this._gp_medal_effect,
			this._satref0,
			this._satref1,
			this._satref2,
			this._satref3,
			this._satref4,
			this._satref5,
			this._satref6,
			this._satref7,
			this._satref8,
			this._gp_star,
			this._satr0,
			this._satr1,
			this._satr2,
			this._satr3,
			this._satr4,
			this._satr5,
			this._satr6,
			this._satr7,
			this._satr8,
			this._gp_star_bg,
			this.medal_star_bg,
			this._gp_star_up_effect,
			this._gp_star_change_effect,
			this._gp_title,
			this._Image4,
			this._Image5,
			this._Group6,
			this._bottom_left,
			this._Label2,
			this._gp,
			this._gp_fight,
			this._Image6,
			this._Label3,
			this._lb_fight,
			this._img_fight_full,
			this._gp_dungeon,
			this._Image7,
			this._Label4,
			this._lb_dungeon,
			this._btn_dungeon,
			this._Image111,
			this.labelDisplay1,
			this._img_dungeon_full,
			this._gp_needGoods,
			this._Image8,
			this._Label5,
			this._gp_goods,
			this._lb_num,
			this._img_full,
			this.btnUp,
			this._Image1,
			this.labelDisplay,
			this._red_dot,
			this._gp_icon,
			this._icon,
			this._str_red,
			this._gp_max,
			this.giftIcon,
			this.costList,
			this._lb_cur_attr1,
			this._lb_cur_next1,
		]
			= this.GetChildrenByNames([

				"txt_bg_group",
				"txt_bg_img",
				"_gp_cur",
				"_Scroller1",
				"Content",
				"_Image666",
				"_img_666",
				"_Group1",
				"_img_txt_cur",
				"_lb_cur_Name",
				"_lb_cur_attr",
				"nullLabel",
				"_gp_next",
				"_Scroller2",
				"Content1",
				"_Image2",
				"_img_777",
				"_Group3",
				"_img_txt_next",
				"_lb_next_Name",
				"_lb_cur_next",
				"_Image3",
				"_Label1",
				"_gp_medal_bg2_effect",
				"medal_bg",
				"medalNullGroup",
				"_img_medal_icon",
				"_img_medal_question",
				"medalImage",
				"medal_title1",
				"_Group5",
				"_img_txt",
				"medalName",
				"_gp_txt_effect",
				"_gp_medal_effect",
				"_satref0",
				"_satref1",
				"_satref2",
				"_satref3",
				"_satref4",
				"_satref5",
				"_satref6",
				"_satref7",
				"_satref8",
				"_gp_star",
				"_satr0",
				"_satr1",
				"_satr2",
				"_satr3",
				"_satr4",
				"_satr5",
				"_satr6",
				"_satr7",
				"_satr8",
				"_gp_star_bg",
				"medal_star_bg",
				"_gp_star_up_effect",
				"_gp_star_change_effect",
				"_gp_title",
				"_Image4",
				"_Image5",
				"_Group6",
				"_bottom_left",
				"_Label2",
				"_gp",
				"_gp_fight",
				"_Image6",
				"_Label3",
				"_lb_fight",
				"_img_fight_full",
				"_gp_dungeon",
				"_Image7",
				"_Label4",
				"_lb_dungeon",
				"_btn_dungeon",
				"_Image111",
				"labelDisplay1",
				"_img_dungeon_full",
				"_gp_needGoods",
				"_Image8",
				"_Label5",
				"_gp_goods",
				"_lb_num",
				"_img_full",
				"btnUp",
				"_Image1",
				"labelDisplay",
				"_red_dot",
				"_gp_icon",
				"_icon",
				"_str_red",
				"_gp_max",
				"giftIcon",
				"costList",
				"_lb_cur_attr1",
				"_lb_cur_next1",
			])
	}

}

window["MedalView"] = MedalView