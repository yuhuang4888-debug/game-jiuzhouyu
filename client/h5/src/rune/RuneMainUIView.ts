import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MainFunc } from "../commonModel/MainUIModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { StoryModel } from "../commonModel/StoryModel";
import { TaskModel, TaskTipType } from "../commonModel/TaskModel";
import { PlatformManager } from "../PlatformManager";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { SYTweenLite } from "../util/SYTweenLite";
import { PlayBigEffect, SetAnchoredPosition, Util } from "../util/Util";
import { RuneAwakenView } from "./RuneAwakenView";
import { RuneBagView } from "./RuneBagView";
import { RuneConvertView } from "./RuneConvertView";
import { RuneDecMainView } from "./RuneDecMainView";
import { RuneIcon } from "./RuneIcon";
import { RunePropertyView } from "./RunePropertyView";
import { RuneSkillView } from "./RuneSkillView";
import { CompositeModel } from "../commonModel/CompositeModel";
import { OpenFun } from "../common/OpenFun";
import { RuneSpIcon } from "./RuneSpIcon";
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel";
import { SkillManager } from "../skill/SkillManager";
import { SkillVo } from "../skill/SkillVo";
import { SpecialCharKey } from "../common/SpecialCharKey";

export class RuneMainUIView extends BaseItem1 {
	conta_list_
	cost_item_
	cur_pos_id_
	cur_rune_data_
	data_
	goods_model
	model: RuneModel
	rune_item_list_
	story_obj_list
	tween_id

	LoadSuccess
	InitEvents
	SetData
	ShowRedDot
	SetRuneList
	SetDefaultSelect
	SetBottomView
	SetUpgradeMsg
	SetFightValue
	SetAnimation
	fight_num: FightingShowSmallItem
	SetSkillShowIcon
	SetSpSkillInfoShow

	public constructor(parent?) {
		super(parent)
		this.base_file = "rune"
		this.layout_file = "RuneMainUIView"
		this.dependent_res = ["icon"]
		this.model = RuneModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.data_ = null
		this.conta_list_ = null
		this.rune_item_list_ = null
		this.cur_pos_id_ = -1
		this.cost_item_ = null
		this.cur_rune_data_ = null
		let _Image1_gray = false

		this.preload_server_config = {
            "config_rune_skill": false,
        }

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
			GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.MallIcon, false)
		}

		this.createChildren = () => {
			if (this["GetComponents"]) {
				this["GetComponents"]()
				this.is_get = true
			}
			this.story_obj_list = this.story_obj_list || {}
			this.story_obj_list[TaskTipType.RuneNum] = [this.insertBtn]
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneLvSum)) {
				this.story_model.curr_view_story_step=1
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
			}
			this.story_obj_list[TaskTipType.RuneLvSum] = [null,this.upgradeBtn]
			super.createChildren()
		}

		this.DeleteMe = () => {
			if (this.cost_item_) {
				this.cost_item_.DeleteMe()
				this.cost_item_ = null
			}
			// if (this.center1) {
			// 	Laya.Tween.clearAll(this.center1)
			// }
			if (this.rune_item_list_) {
				for (let _tmpi in this.rune_item_list_) {
					var item = this.rune_item_list_[_tmpi]
					item.DeleteMe()
					item = null
				}
				this.rune_item_list_ = null
			}
			if (this.fight_num) {
				this.fight_num.DeleteMe()
				this.fight_num = null
			}
			// this.ClearUIEffect(this.center_effect)
			this.ClearUIEffect(this.skill_effect_gp)
			super.DeleteMe();
		}

		this.LoadSuccess = () => {
			this.model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16704)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.center2, GameResPath.GetIcon("rune", "uifu_005"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.center, GameResPath.GetIcon("rune", "uifu_006"))
			this.num.style.color = "#663915"
			this.num.style.fontSize = 20
			this.num.style.wordWrap = false
			this.conta_list_ = []
			for (let i = 1; i <= 10; i++) {
				this.conta_list_.push(this["conta" + i])
			}
			let goods_id = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[10].goods_id
			this.cost_item_ = new BaseAwardItem(this.item_conta)
			this.cost_item_.Load()
			this.cost_item_.SetData(goods_id)
			this.cost_item_.SetItemSize(70, 70)
			let goods_basic = this.goods_model.GetGoodsBasicByTypeId(goods_id)
			if (goods_basic) {
				this._cost_name.text = goods_basic.goods_name
				this._cost_name.color = ColorUtil.GetColorDark(goods_basic.color, false)
			}

			// this.cost_item_.SetItembgVisible(false)
			this.AddUIEffect("ui_yuhuntaozhuang", this.skill_effect_gp, null, 3, true)
			this.SetAnimation()
			this.rune_item_list_ = [] 
		}

		this.InitEvents = () => {
			let rune_fun = (pos_id?) => {
				this.SetBottomView(pos_id)
				this.ShowRedDot()
			}
			this.BindEvent(this.model, RuneEvent.CLICK_RUNE_ICON, rune_fun)

			let update_fun = () => {
				this.SetData()
				this.SetSkillShowIcon()
			}
			this.BindEvent(this.model, RuneEvent.UPDATE_RUNE_DATA, update_fun)
			this.BindEvent(this.goods_model, GoodsModel.CHANGE_RUNE_BAG_LIST, update_fun)

			Util.AddClickEvent(this.lookBtn, () => {
				this.model.Fire(RuneEvent.OPEN_VIEW, "RunePropertyView")
			}, this, true)

			Util.AddClickEvent(this.resolveBtn, () => {
				this.model.Fire(RuneEvent.OPEN_VIEW, "RuneDecMainView")
				let i = 0
			}, this, true)

			// 前往挑战
			Util.AddClickEvent(this.jumpBox, () => {
				OpenFun.OpenFunHandler(6);
			}, this, true)

			Util.AddClickEvent(this._btn_fb, () => {
				OpenFun.OpenFunHandler(6);
			}, this, true)

			Util.AddClickEvent(this._btn_xb, () => {
				RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView", 1)
			}, this, true)

			Util.AddClickEvent(this.composeBtn, () => {
				if (RoleManager.GetInstance().mainRoleInfo.level >= RuneModel.ComposeBtnShowLv) {
					//GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Composite, CompositeModel.Index.Rune)
					CompositeModel.GetInstance().Fire(CompositeModel.OPEN_COMPOSITE_VIEW, CompositeModel.Index.Rune,110)
				} else {
					Message.show("等级达到" + RuneModel.ComposeBtnShowLv + "级开放")
				}
			}, this, true)

			Util.AddClickEvent(this.convertBtn, () => {
				this.model.Fire(RuneEvent.OPEN_VIEW, "RuneConvertView")
			}
				, this, true)
			Util.AddClickEvent(this.insertBtn, () => {
				this.model.Fire(RuneEvent.OPEN_VIEW, "RuneBagView", 1, this.cur_pos_id_)
			}
				, this, true)
			Util.AddClickEvent(this.replaceBtn, () => {
				this.model.Fire(RuneEvent.OPEN_VIEW, "RuneBagView", 2, this.cur_pos_id_)
			}
				, this, true)
			Util.AddClickEvent(this.goBtn, () => {
				//Message.show("敬请期待")
				OpenFun.OpenFunHandler(6)
			}
				, this, true)
			Util.AddClickEvent(this.upgradeBtn, () => {
				if (_Image1_gray == true) {
					return
				}
				if (this.cur_rune_data_) {
					this.model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16702, "l", this.cur_rune_data_.goods_id)
				}
			}, this, true)

			this.BindEvent(this.model, RuneEvent.UPDTE_RUNE_CONVERT_VIEW, () => {
				this.ShowRedDot()
			})
			
			this.BindEvent(this.model, RuneEvent.UPGRADE_SUCCESS, () => {
				PlayBigEffect("ui_shengjitexiao", { x: 0, y: 0.5 })
				//this.AddUIEffect("ui_shengjichenggong_glow", this.effect_group, null, 1)
			}
			)

			let update_task = (task_id?, task_tips_list?) => {
				if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneLvSum)) {
					if(this.task_model.IsCurrMainTaskHasFinish()){
						if(!this.story_model.GetFinger(this,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)){
							this.story_model.curr_view_story_step=3
							if(this.story_model.GetFinger(this,this.upgradeBtn)){
								GlobalEventSystem.Fire(EventName.HIDE_FINGER,this.upgradeBtn)
							}
							GlobalEventSystem.Fire(EventName.SHOW_FINGER,this,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
						}
					}else{
						if(!this.story_model.GetFinger(this,this.upgradeBtn)){
							this.story_model.curr_view_story_step=2
							GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.upgradeBtn)
						}
					}
				
				}
			}
			this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, update_task)


			this.BindEvent(this.model, RuneEvent.UPGRADE_SUCCESS, () => {
				update_task()
				PlayBigEffect("ui_shengjitexiao", { x: 0, y: 0.5 })
				//this.AddUIEffect("ui_shengjichenggong_glow", this.effect_group, null, 1)
			}
			)

			
			Util.AddClickEvent(this.awakeBtn, () => {
				let list = this.model.GetRunesAwakenInBag()
				if (list.length <= 0) {
					Message.show("当前暂无可觉醒御魂")
					return
				}
				this.model.Fire(RuneEvent.OPEN_VIEW, "RuneAwakenView")
			}, this, true)

			Util.AddClickEvent(this.skillBtn, () => {
				this.model.Fire(RuneEvent.OPEN_VIEW, "RuneSkillView")
			}, this, true)

			this.BindEvent(this.model, RuneEvent.UPDATE_RUNE_RED_DOT, () => {
				if (this.skillRed) {
					this.skillRed.visible = this.model.skillRed
				}
			})

			this.BindEvent(this.model, RuneEvent.INSERT_SUCCESS, () => {
				if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneNum)) {
					this.story_model.curr_view_story_step = 2
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
				}
			})

			this.model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16700)
			this.SetData()
		}

		this.SetData = () => {
			this.data_ = this.model.rune_info
			if (!this.data_) {
				return
			}

			// // 空位是否全部解锁
			// let isOpenAll: boolean = this.data_.rune_list.every((data: any) => {
			// 	return data.if_open >= 1;
			// });
			// this.tipsBox.visible = !isOpenAll;

			this.composeBtn.visible = true
			this.SetRuneList(this.data_.rune_list)
			this.SetFightValue()
			this.SetSkillShowIcon();
			this.ShowRedDot()
		}

		this.ShowRedDot = () => {
			this.convertDot.visible = this.model.CanExchange()
			this.resolveDot.visible = this.model.CanResolve()
			let config_rune_wake_up_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up_lv", false)
			let config_rune_wake_up_exp = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up_exp", false)
			let config_rune_wake_up = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up", false)

			this.awakeRed.visible = this.model.CanAwake(config_rune_wake_up, config_rune_wake_up_exp, config_rune_wake_up_lv)
			this.skillRed.visible = this.model.skillRed
			if (this.insert_conta.visible) {
				this.insertDot.visible = this.model.CanInsert(this.cur_pos_id_)
			} else {
				this.insertDot.visible = false
			}
			if (this.pro_conta.visible) {
				this.upgradeDot.visible = this.model.CanUpgrade(this.cur_pos_id_)
				this.replaceDot.visible = this.model.CanInsert(this.cur_pos_id_)
			} else {
				this.upgradeDot.visible = false
				this.replaceDot.visible = false
			}
		}

		this.SetRuneList = (rune_list?) => {
			if (rune_list) {
				let item = null
				let i = 0
				do {
					item = this.rune_item_list_[i]
					if (!item) {
						if(i == 8 || i == 9){
							item = new RuneSpIcon(this.conta_list_[i])
						}else{
							item = new RuneIcon(this.conta_list_[i])
						}
						
						this.rune_item_list_.push(item)
						item.Load()
					}

					item.SetData(rune_list[i])
					i = i + 1
				} while ((i < rune_list.length))
				if(this.cur_pos_id_ == -1){
					this.SetDefaultSelect(rune_list)
				}
				if (this.rune_item_list_[this.cur_pos_id_ - 1]) {
					this.rune_item_list_[this.cur_pos_id_ - 1].SetSelected(true)
				}
			}
		}

		this.SetDefaultSelect = (rune_list) => {
			this.cur_pos_id_  = 1
			if(rune_list){
				for (let i = 0, len = rune_list.length; i < len; i++) {
					let _itemData = rune_list[i];
					if(this.model.CanInsert(_itemData.pos_id) || this.model.CanUpgrade(_itemData.pos_id)){
						this.cur_pos_id_ = _itemData.pos_id;
						break
					}
				}
			}		
		}

		this.SetBottomView = (pos_id?) => {
			this.cur_pos_id_ = pos_id
			this.cur_rune_data_ = this.model.GetRuneDataByPosId(pos_id)
			this.gp_sp_skill.visible = false
			if (this.cur_rune_data_) {
				if (this.cur_rune_data_.if_open > 0) {
					if (this.cur_rune_data_.goods_type_id > 0) {
						this.active_conta.visible = false
						this.pro_conta.visible = true
						this.insert_conta.visible = false
						this.SetUpgradeMsg(this.cur_rune_data_)
						this.SetSpSkillInfoShow()
					} else {
						this.active_conta.visible = false
						this.pro_conta.visible = false
						this.insert_conta.visible = true
					}
				} else {
					this.active_conta.visible = true
					this.pro_conta.visible = false
					this.insert_conta.visible = false
					// this.condition.textFlow = Util.StrToHTML(this.model.GetOpenCondition(this.cur_pos_id_))
					let config_rune_pos = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_pos", false)
					this.condition.text = Util.StrToHTML(this.model.GetOpenCondition(this.cur_pos_id_, config_rune_pos))

				}
			}
		}

		this.SetUpgradeMsg = (rune_data?) => {
			if (rune_data) {
				let goodsvo = this.goods_model.GetGoodsBasicByTypeId(rune_data.goods_type_id)
				if (goodsvo) {
					let iconColor = (rune_data.pos_id == 9 || rune_data.pos_id == 10) && rune_data.color == 5? 6: rune_data.color
					ResManager.GetInstance().SetImageSprite(this, this._img_color, "rune", "color_" + iconColor)
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cardbg, "resource/game/runeCard/icon_kpbg_0" + iconColor + ".png")
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_kuang, "resource/game/runeCard/icon_kp_0" + iconColor + ".png")
					ResManager.GetInstance().SetImageSprite(this, this._img_lv_bg, "rune", "rune_lv_bg_00" + iconColor)
					this._lb_card.text = " Lv." + rune_data.lv;
					this._lb_name.text = goodsvo.goods_name;
					let txtColor = iconColor == 6? 7: iconColor
					let color = ColorUtil.GetColorDark(txtColor, false);
					this._lb_card.strokeColor = this._lb_name.strokeColor = color;
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_card, "resource/game/runeCard/" + rune_data.goods_type_id + ".png")

					let awakeattrList = []
					let pro_list = this.model.GetRuneProList(goodsvo.subtype, rune_data.lv, goodsvo.color)
					if (pro_list) {
						let cfg_wp = this.model.GetWakeUpCfg()
						if (cfg_wp) {
							// let erl_mgr = ErlangParser.GetInstance()
							for (let key in pro_list) {
								var vo = pro_list[key]
								for (let _tmpi in rune_data.attr_list) {
									var awakeInfo = rune_data.attr_list[_tmpi]
									if (vo[0] == awakeInfo.attr_id) {
										let cfg = cfg_wp[rune_data.color + "@" + vo[0] + "@" + awakeInfo.awake_lv]
										if (cfg) {
											let add = JSON.parse(cfg.attr)[0][1]
											vo[1] = vo[1] + add
											awakeattrList.push(add)
										} else {
											awakeattrList.push(0)
										}
									}
								}
							}
						}

						this.left_pro.style.fontSize = 20
						this.left_pro.style.leading = 12
						this.left_pro.width = 214
						this.left_pro.height = 75
						this.left_pro.style.color = "#663915"
						this.left_pro.innerHTML = this.model.GetProStr(pro_list, "'#d15e00'")
						// this.left_pro.style.padding = [(this.left_pro.height - this.left_pro.contextHeight) / 2, 0, 0, 0];     //垂直居中
					}

					let length = pro_list.length
					this.arrow1.visible = length >= 1
					this.arrow2.visible = length >= 2

					let next_pro_list = this.model.GetRuneProList(goodsvo.subtype, rune_data.lv + 1, goodsvo.color)
					if (next_pro_list && next_pro_list.length > 0) {
						let i = 0
						do {
							next_pro_list[i][1] = next_pro_list[i][1] + (awakeattrList[i] || 0)
							i = i + 1
						} while ((i < next_pro_list.length && i < awakeattrList.length))
						Util.SetImageGray(this._Image1, false)
						_Image1_gray = false
						this.top_level.visible = false
						this.right_pro.style.fontSize = 20
						this.right_pro.style.leading = 12
						this.right_pro.width = 214
						this.right_pro.height = 75
						this.right_pro.style.color = "#663915"
						this.right_pro.innerHTML = this.model.GetProStr(next_pro_list, ColorUtil.GetColorDark(1), null, null, true)
						// this.right_pro.style.padding = [(this.right_pro.height - this.right_pro.contextHeight) / 2, 0, 0, 0];     //垂直居中
						this.cost_conta.visible = true
						let cost_num = this.model.GetUpgradeCostNum(goodsvo.subtype, rune_data.lv + 1, goodsvo.color)
						let my_have = (this.model.rune_info && (this.model.rune_info.rune_point) || (0))
						let color = Enum_ColorUtil_Dark.GREEN
						if (my_have < cost_num) {
							color = Enum_ColorUtil_Dark.RED
						}
						let str = "拥有：<font color=" + color + ">" + WordManager.FormatNumber2(my_have) + "</font><font color='#19ae4a'>/" + cost_num + "</font>"
						this.num.innerHTML = str
					} else {
						this.top_level.visible = true
						this.right_pro.innerHTML = ""
						Util.SetImageGray(this._Image1, true)
						_Image1_gray = true
						this.cost_conta.visible = false
					}
					let show = false
					if (pro_list) {
						let i = 0
						do {
							let j = 0
							let attList = rune_data.attr_list[i]
							do {
								if (attList && pro_list[j] && Number(pro_list[j][0]) == attList.attr_id) {
									if (rune_data.attr_list.length == 1) {
										// this["nextawake" + j].y = 0 * (j + 1)
										this["awake" + j].y = 0 * (j + 1)
									} else {
										if (j == 0) {
											// this["nextawake" + j].y = 0
											this["awake" + j].y = 0
										}
									}
								}
								j = j + 1
							} while ((j < pro_list.length))
							show = attList && attList.awake_lv > 0
							// this["nextawake" + i].visible = show && !this.top_level.visible
							this["awake" + i].visible = show
							i = i + 1
						} while ((i < 2))
					}
				}
			}
		}

		this.SetFightValue = () => {
			if (!this.fight_num) {
				this.fight_num = new FightingShowSmallItem(this._fight_con)
				this.fight_num.Load()
				this.fight_num.ExcuteCallback(() => {
					SetAnchoredPosition(this.fight_num, 0.5, 0.5)
					// this.CoverMode(this.fight_num)
				})
			}
			let result = this.model.rune_info && this.model.rune_info.rune_sum_power ? this.model.rune_info.rune_sum_power : 0;
			this.fight_num.Updatefighting(result)
		}

		this.SetAnimation = () => {

			//this.center.anchorOffsetX = this.center.width / 2
			//this.center.anchorOffsetY = this.center.height / 2
			//this.center.x = this.center.x + this.center.width / 2
			//this.center.y = this.center.y + this.center.height / 2

			let load_finish_fun = () => {
				//this.center1.anchorOffsetX = this.center1.width / 2
				//this.center1.anchorOffsetY = this.center1.height / 2
				//this.center1.x = this.center1.x + this.center1.width / 2
				//this.center1.y = this.center1.y + this.center1.height / 2
			}

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.center1, GameResPath.GetIcon("rune", "uifu_004"), load_finish_fun)

			// Laya.Tween.get(this.center1, {loop:true}).to({rotation:this.center1.rotation - 360}, 15000)
			// this.tween_id = SYTweenLite.to(this, this.center1, SYTweenLite.UiAnimationType.ROTATION, -360, 15, null, null, true)
			// SYTweenLite.to(this, this.center1, SYTweenLite.UiAnimationType.SCALE, { x:0.8, y:0.8, z:0.8 }, 1.5, null, SYTweenFunc.PINGPONG, true)
		}

		this.SetSkillShowIcon = () => {
			let skillVo_ = SkillManager.GetInstance().getSkill(RuneModel.SkillId);
			let skillLv = this.model.rune_info[`skill_lv`];
			let skillInfo = skillVo_.getLevelVo(skillLv)
			this.skillImg.gray = skillLv == 0;
			this._img_skill_lock.visible = skillLv == 0;
			if (skillInfo) {
                ResManager.GetInstance().SetOutsideImageSprite(this, this.skillImg, GameResPath.GetSkillIconPath(skillInfo.icon))
            }
		}

		this.SetSpSkillInfoShow = () => {
			let subtype:number = 0
			let goodsvo = this.goods_model.GetGoodsBasicByTypeId(this.cur_rune_data_.goods_type_id)
			if (goodsvo) {
				subtype = goodsvo.subtype
			}
			let config_rune_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_skill", false);
			let skillCfg = config_rune_skill[`${subtype}`];
			if(!skillCfg) return;
			let skillId:number = skillCfg.skill_id;
			let skillVo_:SkillVo = SkillManager.GetInstance().getSkill(skillId);
			if(skillVo_){
				let awakenLv:number = this.model.GetAwakenLvByVo(this.cur_rune_data_);
				let sp_skill_info = skillVo_.getLevelVo(awakenLv + 1)
				if (sp_skill_info) {
					this.gp_sp_skill.visible = true;
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_sp_skillIIcon, GameResPath.GetSkillIconPath(sp_skill_info.icon))
					this.lockLb.style.fontSize = 18
					this.lockLb.width = 300
					this.lockLb.style.leading = 8
					this.lockLb.style.color = "#d15e00"
					let desc:string = String(sp_skill_info.desc).replace(SpecialCharKey.RuneMainUIView2, SpecialCharKey.RuneMainUIView1)
					if(window["ChatModel"]){
						desc = window["ChatModel"].GetInstance().FormatColorTag(desc, false);
					}
					this.lockLb.innerHTML = Util.StrToHTML(`${desc}`)
				}
			}else{
				this.gp_sp_skill.visible = false;
			}
		}
	}
	_Image111: Laya.Image
	skill_effect_gp: Laya.Box
	_img_bgl: Laya.Image
	_img_bgr: Laya.Image
	convertBtn: Laya.Image
	convertDot: Laya.Image
	lookBtn: Laya.Image
	skillBtn: Laya.Image
	skillImg: Laya.Image
	_img_skill_lock: Laya.Image
	skillRed: Laya.Image
	awakeBtn: Laya.Image
	awakeRed: Laya.Image
	composeBtn: Laya.Image
	composeDot: Laya.Image
	resolveBtn: Laya.Image
	resolveDot: Laya.Image
	pro_conta: Laya.Box
	_img_line: Laya.Image
	_gp_title1: Laya.Image
	_lb_title1: Laya.Label
	_gp_title2: Laya.Image
	_lb_title2: Laya.Label
	left_pro: Laya.HTMLDivElement
	right_pro: Laya.HTMLDivElement
	top_level: Laya.Label
	arrow1: Laya.Image
	arrow2: Laya.Image
	replaceBtn: Laya.Box
	_Image1111: Laya.Image
	labelDisplay111: Laya.Label
	replaceDot: Laya.Image
	upgradeBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	upgradeDot: Laya.Image
	cost_conta: Laya.Box
	item_conta: Laya.Box
	_cost_name: Laya.Label
	num: Laya.HTMLDivElement
	_Group4: Laya.Box
	awake0: Laya.Image
	awake1: Laya.Image
	_gp_card: Laya.Box
	_img_cardbg: Laya.Image
	_img_card: Laya.Image
	_img_kuang: Laya.Image
	_img_color: Laya.Image
	_lb_card: Laya.Label
	_lb_name: Laya.Label
	_img_lv_bg: Laya.Image
	//特殊噬魂显示
	gp_sp_skill: Laya.Box
	_img_sp_skillIIcon: Laya.Image
	lockLb: Laya.HTMLDivElement

	active_conta: Laya.Box
	qw: Laya.Image
	goBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	condition: Laya.Label
	_Label1: Laya.Label
	insert_conta: Laya.Box
	_btn_xb: Laya.Image
	_btn_fb: Laya.Image
	asd: Laya.Image
	bottom_title1: Laya.Label
	insertBtn: Laya.Box
	_Image11111: Laya.Image
	insertDot: Laya.Image
	labelDisplay11: Laya.Label
	tips: Laya.Label
	conta1: Laya.Box
	conta9: Laya.Box
	conta10: Laya.Box
	conta2: Laya.Box
	conta3: Laya.Box
	conta4: Laya.Box
	conta5: Laya.Box
	conta6: Laya.Box
	conta7: Laya.Box
	conta8: Laya.Box
	effect_group: Laya.Box
	tipsBox: Laya.Box
	jumpBox: Laya.Box
	_fight_con: Laya.HBox

	public GetComponents() {
		[
			this._Image111,
			this.skill_effect_gp,
			this._img_bgl,
			this._img_bgr,
			this.convertBtn,
			this.convertDot,
			this.lookBtn,
			this.skillBtn,
			this.skillImg,
			this._img_skill_lock,
			this.skillRed,
			this.awakeBtn,
			this.awakeRed,
			this.composeBtn,
			this.composeDot,
			this.resolveBtn,
			this.resolveDot,
			this.pro_conta,
			this._img_line,
			this._gp_title1,
			this._lb_title1,
			this._gp_title2,
			this._lb_title2,
			this.left_pro,
			this.right_pro,
			this.top_level,
			this.arrow1,
			this.arrow2,
			this.replaceBtn,
			this._Image1111,
			this.labelDisplay111,
			this.replaceDot,
			this.upgradeBtn,
			this._Image1,
			this.labelDisplay,
			this.upgradeDot,
			this.cost_conta,
			this.item_conta,
			this._cost_name,
			this.num,
			this._Group4,
			this.awake0,
			this.awake1,
			this._gp_card,
			this._img_cardbg,
			this._img_card,
			this._img_kuang,
			this._img_color,
			this._lb_card,
			this._lb_name,
			this.gp_sp_skill,
			this._img_sp_skillIIcon,
			this.lockLb,
			this.active_conta,
			this.qw,
			this.goBtn,
			this._Image11,
			this.labelDisplay1,
			this.condition,
			this._Label1,
			this.insert_conta,
			this._btn_xb,
			this._btn_fb,
			this.asd,
			this.bottom_title1,
			this.insertBtn,
			this._Image11111,
			this.insertDot,
			this.labelDisplay11,
			this.tips,
			this.conta1,
			this.conta9,
			this.conta10,
			this.conta2,
			this.conta3,
			this.conta4,
			this.conta5,
			this.conta6,
			this.conta7,
			this.conta8,
			this.effect_group,
			this.tipsBox,
			this.jumpBox,
			this._fight_con,
			this._img_lv_bg
		]
			= this.GetChildrenByNames([

				"_Image111",
				"skill_effect_gp",
				"_img_bgl",
				"_img_bgr",
				"convertBtn",
				"convertDot",
				"lookBtn",
				"skillBtn",
				"skillImg",
				"_img_skill_lock",
				"skillRed",
				"awakeBtn",
				"awakeRed",
				"composeBtn",
				"composeDot",
				"resolveBtn",
				"resolveDot",
				"pro_conta",
				"_img_line",
				"_gp_title1",
				"_lb_title1",
				"_gp_title2",
				"_lb_title2",
				"left_pro",
				"right_pro",
				"top_level",
				"arrow1",
				"arrow2",
				"replaceBtn",
				"_Image1111",
				"labelDisplay111",
				"replaceDot",
				"upgradeBtn",
				"_Image1",
				"labelDisplay",
				"upgradeDot",
				"cost_conta",
				"item_conta",
				"_cost_name",
				"num",
				"_Group4",
				"awake0",
				"awake1",
				"_gp_card",
				"_img_cardbg",
				"_img_card",
				"_img_kuang",
				"_img_color",
				"_lb_card",
				"_lb_name",
				"gp_sp_skill",
				"_img_sp_skillIIcon",
				"lockLb",
				"active_conta",
				"qw",
				"goBtn",
				"_Image11",
				"labelDisplay1",
				"condition",
				"_Label1",
				"insert_conta",
				"_btn_xb",
				"_btn_fb",
				"asd",
				"bottom_title1",
				"insertBtn",
				"_Image11111",
				"insertDot",
				"labelDisplay11",
				"tips",
				"conta1",
				"conta9",
				"conta10",
				"conta2",
				"conta3",
				"conta4",
				"conta5",
				"conta6",
				"conta7",
				"conta8",
				"effect_group",
				"tipsBox",
				"jumpBox",
				"_fight_con",
				"_img_lv_bg"
			])
	}
}
 window["RuneMainUIView"]= RuneMainUIView