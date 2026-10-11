import { ViewManager } from "./../common/ViewManager"
import { BaseItem1 } from '../common/BaseItem1';
import { CommonManager } from '../common/CommonManager';
import { Config } from '../common/Config';
import { EventName } from '../common/EventName';
import { OpenFun } from '../common/OpenFun';
import { RedDotManager, ModuleType } from '../common/RedDotManager';
import { ResManager } from '../common/ResManager';
import { LungModel } from '../commonModel/LungModel';
import { StoryModel } from '../commonModel/StoryModel';
import { LoginModel } from '../login/LoginModel';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { TimeUtil } from '../util/TimeUtil';
import { Util, GlobalTimerQuest, Split, SetLocalScale, SetAnchoredPosition } from '../util/Util';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { VipModel } from '../commonModel/VipModel';
import { PushGiftModel } from '../commonModel/PushGiftModel';
import { FirstRechargeModel } from '../commonModel/FirstRechargeModel';
import { ShopModel } from '../commonModel/ShopModel';
import { MarketModel, MarketEvent } from '../commonModel/MarketModel';
import { BaseDungeonModel, DungeonEnterViewIndex } from '../commonModel/BaseDungeonModel';
import { RuneTreasureEvent, RuneTreasureModel } from '../commonModel/RuneTreasureModel';
import { KaifuActivityModel, KaifuActivityModelEvent } from '../commonModel/KaifuActivityModel';
import { HolyTerritoryModel, HTEvent } from '../commonModel/HolyTerritoryModel';
import { BossModel } from '../commonModel/BossModel';
import { MarriageRedList } from '../commonModel/MarriageModel';
import { KfHolyAreaModel } from '../commonModel/KfHolyAreaModel';
import { SuitActivityModel } from '../commonModel/SuitActivityModel';
import { ArenaModel } from '../commonModel/ArenaModel';
import { BabyModel } from '../commonModel/BabyModel';
import { NineSkyModel } from '../commonModel/NineSkyModel';
import { GuildFightModel } from '../commonModel/GuildFightModel';
import { ActivityForeshowManager } from '../commonModel/ActivityForeshowManager';
import { CustomActivityDefine } from '../commonModel/CustomActivityDefine';
import { DungeonPartnerModel } from '../commonModel/DungeonPartnerModel';
import { DailyModel } from '../commonModel/DailyModel';
import { DailyEvent } from '../daily/DailyEvent';
import { HolyBattleModel } from '../commonModel/HolyBattleModel';
import { NoonPartyModel, NoonPEvent } from '../commonModel/NoonPartyModel';
import { WelfareModel } from '../commonModel/WelfareModel';
import { DiamondFightModel } from '../commonModel/DiamondFightModel';
import { ActivityIconManager } from '../commonModel/ActivityIconManager';
import { kfSingleRankModel } from '../commonModel/kfSingleRankModel';
import { FriendInviteModel } from '../commonModel/FriendInviteModel';
import { SurpriseGiftModel } from '../commonModel/SurpriseGiftModel';
import { TopPkModel } from '../commonModel/TopPkModel';
import { Kf1vnModel } from '../commonModel/Kf1vnModel';
import { AttentionEvent, AttentionModel } from '../commonModel/AttentionModel';
import { FestivalModel, FestivalModelEvent } from '../commonModel/FestivalModel';
import { EnumFestivalTabType, FestivalBaseView } from '../festival/FestivalBaseView';
import { LimitLevelShopModel } from '../commonModel/LimitLevelShopModel';
import { GuildActEvent, GuildActivityModel } from '../commonModel/GuildActivityModel';
import { SeaHegemonyModel } from '../commonModel/SeaHegemonyModel';
import { FirstRechargeQiPaoItem } from '../recharge/FirstRechargeQiPaoItem';
import { TopPlayerTipItem } from './TopPlayerTipItem';
import { MainUIModel } from '../commonModel/MainUIModel';
import { FuncBoardView } from './FuncBoardView';
import { TaskModel } from '../commonModel/TaskModel';
import { AdventureModel } from '../commonModel/AdventureModel';
import { EnumGrowthForceViewType, GrowthForceModel, GrowthForceModelEvent } from '../commonModel/GrowthForceModel';
import { GrowthForceView } from '../growthForce/GrowthForceView';
import { GrowthBenefitsModel } from './../commonModel/GrowthBenefitsModel';
import { RoleManager } from '../commonModel/RoleManager';
import { ReincarnationModel } from '../commonModel/ReincarnationModel';
import { DragonWhisperModel } from '../commonModel/DragonWhisperModel';
import { TSCrackModel } from '../commonModel/TSCrackModel';
import { EternityModel } from '../commonModel/EternityModel';
import { CookieWrapper } from '../common/CookieWrapper';
import { AddVipServiceEvent, AddVipServiceModel } from '../commonModel/AddVipServiceModel';
import { MainStrongerEvent, MainStrongerModel } from "./../commonModel/MainStrongerModel"
import { RedDotController } from "./../common/RedDotController"
import { RedKey } from "./../common/RedDotDefine"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel";
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel";
import { ViewGiftPopModel, ViewGiftPopModelEvent } from './../commonModel/ViewGiftPopModel';
import { MainUIStrongerTalkBoard } from "./MainUIStrongerTalkBoard";
import { SentientActModel } from "../commonModel/SentientActModel";
import { GhostWalkModel } from "../commonModel/GhostWalkModel";
import { PlatformManager } from "../PlatformManager";
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel";
import { ErlangParser } from "../util/ErlangParser";
import { WeekCardModel } from "../commonModel/WeekCardModel";
import { EyouManager } from "../commonController/EyouManager";
import { DragonBallModel } from "../commonModel/DragonBallModel";

export enum ActivityIconLayer {
	Effect = 1,
	Icon,
	// 特殊显示的顶层
	TOP,
	Red,
	RedNum,
	DescBg,
	DescLbl,
	RedNumLbl,
	Effect2
}
let local_EventName = EventName
let local_GlobalEventSystem = GlobalEventSystem
let local_ActivityIconManager
let local_CustomActivityModel = CustomActivityModel
let local_GlobalTimerQuest = GlobalTimerQuest
export class ActivityIcon extends BaseItem1 {
	first_recharge_qipaoitem
	func_board_item: FuncBoardView;
	public to_delete: boolean;
	public to_add: boolean;
	public icon_type;
	public icon_info;
	public cfg;
	private close_tip_time
	private tip_item: TopPlayerTipItem
	suit_arrow = false

	public static WIDTH = 72;
	public static HEIGHT = 72;
	need_refresh_data = false;
	dot_cache
	update_timer_id
	next_add_time
	foreshow_msg
	foreshow_show
	foreshow_icon
	icon_type_timer_dic = []
	// _gp_icon_effect
	icon_scale_cache
	is_clicked = false
	alpha_cache
	count_time = 0
	foreshow_ing
	set_first_cache;
	constructor(parent?) {
		super(parent);
		local_ActivityIconManager = ActivityIconManager
		this.base_file = 'mainUI';
		this.layout_file = 'ActivityIcon';
		this.dependent_res = ['icon'];
		this.is_delay_callback = false;
		this.not_cache_display_obj = true

		this.to_delete = false;
		this.to_add = false;
		this.icon_type;

		this.load_callback = () => {
			this.SetLayer();
			this.LoadSuccess();
		}
	}
	DeleteMe() {
		this.CancelTimer();
		this.CancelTipTimer()
		if (this.first_recharge_qipaoitem) {
			this.first_recharge_qipaoitem.DeleteMe()
		}
		this.first_recharge_qipaoitem = null
		Laya.timer.clearAll(this)
		this.ClearUIEffect(this._box_effect)
		this.ClearUIEffect(this._box_effect2)
		if (this.tip_item) {
			this.tip_item.DeleteMe()
			this.tip_item = null
		}

		if (this.func_board_item) {
			this.func_board_item.DeleteMe()
			this.func_board_item = null
		}
		this.ResetLayer()
		super.DeleteMe();
	}

	LoadSuccess() {
		this._lb_desc.leading = 1

		this._lb_desc.fontSize = 2 * this._lb_desc.fontSize
		this._lb_desc.scale(0.5, 0.5)
		// this._lb_desc.width = 2 * this._lb_desc.width

		this.InitEvents();

		if (this.need_refresh_data) {
			this.SetIconType(this.icon_type);
			this.need_refresh_data = false;
		}

		if (this.alpha_cache) {
			this.SetAlpha(this.alpha_cache);
		}

		if (this.icon_scale_cache) {
			this.SetIconScale(this.icon_scale_cache);
		}
		if (this.set_first_cache) {
			this._parent.setChildIndex(this.display_obj, 0);
			// this.SetAsFirstSibling()
			this.set_first_cache = false;
		}
	}

	SetLayer() {
		let layerIconArr = [
			this._box_effect, 
			this._img_icon, 
			this._img_red, 
			this._img_red_num, 
			this._img_desc_bg, 
			this._lb_desc, 
			this._lb_num,
			this._box_effect2
		];
		layerIconArr.forEach(icon => {
			icon['_ox_'] = icon.x;
			icon['_oy_'] = icon.y;
			icon['_old_visible_'] = icon.visible;
			// 单独给layer设置visible的时候也要考虑到displayobj的visible
			icon['_old_set_visible'] = icon['set_visible'];
			icon['set_visible'] = (value) => {
				icon["_old_visible_"] = value
				value = value && this.display_obj.visible;
				icon['_old_set_visible'](value);
			};
			icon.removeSelf();
			this._parent.addChild(icon);
		})
		this._box_effect.zOrder = ActivityIconLayer.Effect;
		this._img_icon.zOrder = ActivityIconLayer.Icon;
		this._img_red.zOrder = ActivityIconLayer.Red;
		this._img_red_num.zOrder = ActivityIconLayer.RedNum;
		this._img_desc_bg.zOrder = ActivityIconLayer.DescBg;
		this._lb_desc.zOrder = ActivityIconLayer.DescLbl;
		this._lb_num.zOrder = ActivityIconLayer.RedNumLbl;
		this._box_effect2.zOrder = ActivityIconLayer.Effect2

		if (!this.display_obj) return;
		this.display_obj.mouseThrough = true;
		this.display_obj["_oSetX"] = this.display_obj["_setX"];
		this.display_obj["_setX"] = (x) => {
			if (this.display_obj)
				this.display_obj["_x"] = x;
			layerIconArr.forEach(icon => icon && (icon.x = x + icon['_ox_']))
			this._img_icon && (this._img_icon.x = x + this._img_icon['_ox_'] + this._img_icon.pivotX)
		}
		this.display_obj["_oSetY"] = this.display_obj["_setY"];
		this.display_obj["_setY"] = (y) => {
			if (this.display_obj)
				this.display_obj["_y"] = y;
			layerIconArr.forEach(icon => icon && (icon.y = y + icon['_oy_']))
			this._img_icon && (this._img_icon.y = y + this._img_icon['_oy_'] + this._img_icon.pivotY)
		}
		Object.defineProperty(this.display_obj, "alpha", {
			get: () => {
				if (this.display_obj) {
					return this.display_obj["_getAlpha"]();
				}
				return 0
			},
			set: (value) => {
				if (this.display_obj) {
					value = value < 0 ? 0 : (value > 1 ? 1 : value);
					this.display_obj["_setAlpha"](value);
				}
				layerIconArr.forEach(icon => icon && (icon.alpha = value))
			},
			configurable: true
		});
		Object.defineProperty(this.display_obj, 'visible', {
			get: () => {
				if (this.display_obj) {
					return this.display_obj.get_visible();
				}
				return 0;
			},
			set: (value) => {
				if (this.display_obj) {
					if (this.display_obj.get_visible() === value) {
						return;
					}
					this.display_obj.set_visible(value);
				}
				if (!value) {
					layerIconArr.forEach(icon => {
						if (icon) {
							var temp_visible = icon.visible;
							icon.visible = false;
							icon['_old_visible_'] = temp_visible
						}
					})
				} else {
					layerIconArr.forEach(icon => icon && (icon.visible = value && icon['_old_visible_']))
				}
			},
			configurable: true
		});
	}
	ResetLayer() {
		if (this.display_obj) {
			this.display_obj["_setX"] = this.display_obj["_oSetX"];
			this.display_obj["_setY"] = this.display_obj["_oSetY"];
		}
		if (this._box_effect) {
			let layerIconArr = [this._box_effect, 
				this._img_icon, 
				this._img_red, 
				this._img_red_num, 
				this._img_desc_bg, 
				this._lb_desc, 
				this._lb_num,
				this._box_effect2
			];
			layerIconArr.forEach(icon => {
				icon['set_visible'] = icon['_old_set_visible']
				icon.removeSelf();
				this.display_obj.addChild(icon);
			})
		}
	}

	talk_board: MainUIStrongerTalkBoard
	InitEvents() {
		let key;
		let comp = this._img_red
		let txtComp;
		// 将 icon_type 和 RedKey对应上
		this._img_red_num.visible =
			this._lb_num.visible = false;
		switch (this.icon_type) {
			case "158": key = RedKey.MAIN_STRONGER; comp = this._img_red_num; txtComp = this._lb_num; break;
		}
		if (key)
			RedDotController.ins.bind(key, comp, txtComp);
		let mainStrongerModel = MainStrongerModel.ins;
		if (this.icon_type == '158') {

			this.talk_board = new MainUIStrongerTalkBoard(this._img_icon);
			this.talk_board.Load();
			this.talk_board.InitData(null, '', 30, null, null);
			this.talk_board.ExcuteCallback(() => {
				this.talk_board.display_obj.scale(1, 1);
				this.talk_board.SetVisible(false);
				this.talk_board.content_bg.width = 215;
				this._img_icon.zOrder = ActivityIconLayer.TOP;


				// 更改scale会触发resetLayout，会重设x坐标
				this.CallLater(() => {
					if (!ViewManager.GetInstance().GetViewOpenState('MainUIStrongerView')) {
						if (mainStrongerModel.isBubbleOpen) return;
						//绝世名铠 有箭头时不显示变强气泡
						if(RoleManager.GetInstance().GetMainRoleLevel() > SuitActivityModel.ShowArrowLv && SuitActivityModel.GetInstance().showRed){
							this.talk_board.SetVisible(false);
							return
						} 
						this.talk_board.SetContent(mainStrongerModel.getBubbleContent());
						this.talk_board.SetVisible(mainStrongerModel.strongerNum >= 3);
						this.talk_board.display_obj.x = -145;
					}
				});
				this.BindEvent(local_GlobalEventSystem, MainStrongerEvent.UPDATE, (num) => {
					// 变强按钮更新红点数量
					// this._img_red;
					// 变强气泡
					if (!ViewManager.GetInstance().GetViewOpenState('MainUIStrongerView')) {
						if (mainStrongerModel.isBubbleOpen) return;
						//绝世名铠 有箭头时不显示变强气泡
						if(RoleManager.GetInstance().GetMainRoleLevel() > SuitActivityModel.ShowArrowLv && SuitActivityModel.GetInstance().showRed){
							this.talk_board.SetVisible(false);
							return
						}
						this.talk_board.SetContent(mainStrongerModel.getBubbleContent());
						this.talk_board.SetVisible(!mainStrongerModel.isHideBoard && num >= 3);
						this.talk_board.display_obj.x = -145;
					}
				});
			});



			this.BindEvent(local_GlobalEventSystem, MainStrongerEvent.AUTO_BRUSH_SHOW_ARROW, () => {
				let step_cfg = {
					direction: 6,
					text: "先让自己变得更强，再重新开始挑战吧!",
					effect_scaleX: 0.5,
					effect_scaleY: 0.7,
				}
				local_GlobalEventSystem.Fire(local_EventName.SHOW_FINGER, this, this._box_arrow, "Main", null, null, null, null, step_cfg, true)
				mainStrongerModel.isHideBoard = true
				if (this.talk_board) {
					this.talk_board.SetVisible(false);
				}
			});
		}
		if (this.icon_type == '331@14') {
			let cus_model = local_CustomActivityModel.GetInstance()
			if (cus_model.redpacket_rain_subtype) {
				let sub_type = cus_model.redpacket_rain_subtype
				cus_model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33155, sub_type)
			}
		}

		this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.CREAT_FIRST_QIPAO, (request_award_success?) => {
			if (this.icon_type == 159 && FirstRechargeModel.GetInstance().GetFirstRechargeQiPaoInfo(request_award_success).str != "") {
				this.CreateQipao()
			}
		})

		Util.AddClickEvent(this._img_icon,(e?) => {
				this._box_arrow.event(Laya.Event.CLICK)
			},
			this,
			true
		);

		this._box_arrow["_mouseState"] = 1
		this._box_arrow.on(Laya.Event.CLICK, this, () => {
			// 	// this._img_icon.event(Laya.Event.CLICK)
			this.ClickEvent();
		})

		this.BindEvent(local_GlobalEventSystem,local_ActivityIconManager.UPDATE_SINGLE_ICON,
			(icon_type?) => {
				if (this.icon_type == icon_type) {
					this.SetCountTimer();
					this.SetIconImg();
				}
			}
		);

		this.BindEvent(local_GlobalEventSystem,local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT,
			(icon_type?, bool?) => {
				if (this.icon_type == String(icon_type)) {
					this.ShowRedDot(bool);
				}
			}
		);

		this.BindEvent(local_GlobalEventSystem,local_ActivityIconManager.SET_ICON_TEXT,
			(icon_type?, text?, color?) => {
				if (this.icon_type == String(icon_type)) {
					this.SetIconText(text, color);
				}
			}
		);

		this.BindEvent(local_GlobalEventSystem,local_ActivityIconManager.UPDATE_EFFECT,
			(icon_type?, effect_name?, bool?, effect_need_delete?, pos?, scale?) => {
				if (this.icon_type == String(icon_type)) {
					if (scale) {
						this.SetIconEffect(effect_name, bool, pos, scale);
					} else {
						this.SetIconEffect(effect_name, bool, pos);
					}
					this.cfg.effect_name = effect_name;
					this.cfg.effect_pos = pos;
					this.cfg.effect_need_delete = effect_need_delete;
				}
			});

		this.BindEvent(local_CustomActivityModel.GetInstance(),CustomActivityDefine.EVENT.REFRESHCOUNTDOWN, (icon_type?, end_time?, bool?, color?) => {
				if (this.icon_type == String(icon_type)) {
					this.icon_type_timer_dic[String(icon_type)] = end_time
					this._lb_desc.color = color || "#88ff43"
					if (bool) {
						this.StartTimer(end_time)
					} else {
						this.CancelTimer()
						this._lb_desc.visible =
							this._img_desc_bg.visible = false
					}
				}
			}
		)

		this.BindEvent(local_CustomActivityModel.GetInstance(),CustomActivityDefine.EVENT.ADD_GIFT_TIP, (des: string) => {
				if (this.icon_type == "191") {
					ViewGiftPopModel.GetInstance().isPopIng = true;
					if (!this.tip_item) {
						this.display_obj.zOrder = 999;
						this.tip_item = new TopPlayerTipItem(this.display_obj)
						this.tip_item.SetDes(des)
						this.tip_item.Load()
						this.tip_item.ExcuteCallback(() => {
							SetAnchoredPosition(this.tip_item.display_obj, 50, -15)
						}
						)
					}
					if (this.close_tip_time) {
						this.CancelTipTimer()
						this.tip_item.SetDes(des)
					}
					if (!this.close_tip_time) {
						this.close_tip_time = local_GlobalTimerQuest.AddPeriodQuest(() => {
							if (this.tip_item) {
								this.tip_item.DeleteMe()
								this.tip_item = null
							}
							this.CancelTipTimer();
							// 延迟
							Laya.timer.once(10000, this, () => {
								ViewGiftPopModel.GetInstance().isPopIng = false;
								ViewGiftPopModel.GetInstance().Fire(ViewGiftPopModelEvent.NEXT_OPEN_TIPS);
							});
						}, 10)
					}

				}
			}
		)

		// this.BindEvent(local_GlobalEventSystem,local_EventName.SET_TREASURE_ICON_EFFECT,(icon_type?, res_name?, show?, pos?, scale?, loop?) => {
		// 		if (icon_type == this.icon_type) {
		// 			this.SetEffect(res_name, show, pos, scale, loop);
		// 		}
		// 	}
		// );

		this.BindEvent(local_GlobalEventSystem,local_EventName.ACTIVITY_ICON_FINGER,(show?, icon_type?, step_cfg?) => {
				if (
					icon_type &&
					Number(this.icon_type) == icon_type &&
					this._box_arrow
				) {
					if (show) {
						local_GlobalEventSystem.Fire(
							local_EventName.SHOW_FINGER,
							this,
							this._box_arrow,
							'Main',
							null,
							null,
							true,
							null,
							step_cfg,
							true
						);
					} else {
						local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this._box_arrow);
					}
				}
			}
		);
		if (this.icon_type == "331@10@0") {
			local_CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33251)
		}


		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.SHOW_FUNC_BOARD_VIEW, (scmd, mod_id) => {
			if (this.icon_type == "1525" && mod_id == 1525 && SuitActivityModel.GetInstance().showRed) {
				let lv = RoleManager.GetInstance().GetMainRoleLevel()
				if (lv < SuitActivityModel.ShowArrowLv) {
					return
				}
				let pos = new Laya.Point(-200, 0)
				if (!this.func_board_item || this.func_board_item.use_delete_method) {
					this.func_board_item = null
					this.func_board_item = new FuncBoardView(this._img_icon)
					this._img_icon.zOrder = ActivityIconLayer.TOP;
					this.func_board_item.SetData(scmd, pos, FuncBoardView.DIR_RIGHT)
					this.func_board_item.Load()
				} else {
					this.func_board_item.SetData(scmd, pos, FuncBoardView.DIR_RIGHT)
				}
				this.suit_arrow = true
				this._img_red.visible = false
			}
		})

		this.BindEvent(TaskModel.GetInstance(), TaskModel.UPDATE_MAIN_LINE_TASK_VO, () => {
			if (this.icon_type == "1525") {
				this.ShowRedDot()
			}
		})

		this.BindEvent(CycleimpActlistModel.GetInstance(), CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIT_RED, () => {
			if (this.icon_type == "331@110") {
				this.ShowRedDot()
			}
		})
	}
	CancelTipTimer() {

		if (this.close_tip_time) {
			local_GlobalTimerQuest.CancelQuest(this.close_tip_time)
			this.close_tip_time = null
		}
	}

	SetIconText(text?, color?) {
		if (text && text != '' && this.icon_type && this._lb_desc) {
			if (this.icon_info && this.icon_info.data) {
				if (color) {
					this._lb_desc.color = color
				}
				this.icon_info.data.count_down_time = false;
				this.icon_info.icon_txt = text;
				this._lb_desc.text = text
				this.CancelTimer();
				this._lb_desc.visible = this._img_desc_bg.visible = true
				this.UpdateDescX();
			}
		}
		else {
			this._lb_desc.visible = this._img_desc_bg.visible = false
		}
	}


	CreateQipao() {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge
		Laya.timer.once(Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge.tips_show_delay_time * 1000, this, () => {
			if (!this.first_recharge_qipaoitem) {
				this.first_recharge_qipaoitem = new FirstRechargeQiPaoItem(this._img_icon)
				this.first_recharge_qipaoitem.Load()
				FirstRechargeModel.GetInstance().is_show_qipao = true
				this.first_recharge_qipaoitem.ExcuteCallback(() => {
					this._img_icon.zOrder = ActivityIconLayer.TOP;
					if(PlatformManager.IsEyouEnPlatform()){
						this.first_recharge_qipaoitem.SetPosition(75,-20)
					}
					let time = FirstRechargeModel.GetInstance().GetFirstRechargeQiPaoInfo().time
					if (time) {
						let destroy_item = () => {
							time = time
							time = time - 1
							if (Number(time) <= 0) {
								FirstRechargeModel.GetInstance().is_show_qipao = false
								this.first_recharge_qipaoitem.DeleteMe()
								this.first_recharge_qipaoitem = null
								Laya.timer.clear(this, destroy_item)

							}
						}

						Laya.timer.loop(1000, this, destroy_item)
					}
				})
			}
		})
	}
	//图标存在时，刷新倒计时
	RefTimer() {
		let icon_info = local_ActivityIconManager.GetInstance().getIconInfo(
			this.icon_type
		);
		if (icon_info && icon_info.time) {
			this.icon_info.time = icon_info.time;
		}
	}

	SetIconImg() {
		if (this.is_loaded && this.icon_type) {
			if (this.cfg) {
				let iconName = this.icon_info?.icon_img || this.cfg.icon_name;

				//爱微游svip图标
				if (this.icon_type == '160') {
					//iconName 这里是图标的全地址
					if(this.icon_info&&this.icon_info.icon_img){
						ResManager.GetInstance().SetTexture(this,this._img_icon,iconName);
					}else
					{
						ResManager.GetInstance().SetImageSpriteTrans(this,this._img_icon,iconName);
					}
					return
				}

				if (this.icon_type == '416') {
					let type = RuneTreasureModel.GetInstance().GetLuckValue();
					if (type == 0) {
						iconName = '416';
						// this.SetEffect("", false)
					} else if (type == 1) {
						iconName = '416_1';
						// this.SetEffect("", false)
					} else if (type == 2) {
						iconName = '416_2';
						// this.SetEffect("uifx_mainicon03", true, { x=0, y=3 }, 0.9, true)
					}
				}
				else if (this.icon_type == '331@99@1') {
					let destiny_info = local_CustomActivityModel.GetInstance().GetDesTinyInfo()
					if (destiny_info && destiny_info.show_index) {
						let label = destiny_info.show_index
						iconName = label == 0 ? "33240" : `33240_${label}`
					}


				}
				else if (this.icon_type == '283') {
					let server_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					if (server_day == 1)
						iconName = "283_1"
					else if (server_day == 2 && HolyTerritoryModel.GetInstance().CanInto()) {
						iconName = "283_2"
					}
					else
						iconName = "283"


				}
				else if (this.icon_type == "179") {
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					if (open_day <= 7) {
						iconName = "3318_2"
					}
				}
				else if (this.icon_type == "143") {
					//state为true时表示雕像激活，反之为false
					let dragon_model = DragonBallModel.GetInstance()
					let state = dragon_model.GetStatueActiveState()
					if(state){
						if(dragon_model.dragon_gift_data){
							iconName = `143_${dragon_model.dragon_gift_data.id}`
						}
					}else{
						iconName = "143_0"
					}
				}
				ResManager.GetInstance().SetImageSprite(
					this,
					this._img_icon,
					'icon',
					iconName
				);
				// ResManager.GetInstance().SetImageSprite(
				// 	this,
				// 	this._img_red,
				// 	'icon',
				// 	'com_red_point'
				// );
			}
		}
	}

	SetIconEffect(effect_name?, bool?, pos?, scale?) {
		if(effect_name != null && bool != null){
			if (bool != null) {
				this.ClearUIEffect(this._box_effect2)
				if (bool) {
					this.AddUIEffect(effect_name, this._box_effect2, pos, scale)	
				}
			}
		}
		else{
			if (this.cfg && this.cfg.effect_name != "" && !this.is_clicked) {
				this.ClearUIEffect(this._box_effect2)
				// if(this.cfg.effect_name == "ui_zhujiemiantubiao_01"){
				// 	scale = 12.8
				// }
				let scale = 12.8
				if(this.cfg.effect_scale){
					scale*=this.cfg.effect_scale
				}
				this.AddUIEffect(this.cfg.effect_name, this._box_effect2, pos, scale)
			}
		}
	}

	SetCountTimer() {
		if (
			!Util.IsTableEmpty(this.icon_type_timer_dic) &&
			this.icon_type_timer_dic[this.icon_type]
		) {
			return;
		}
		if (!this.is_loaded || !this.icon_type || !this.icon_info) {
			return;
		}
		this.CancelTimer();
		let show = false;
		this.foreshow_ing = this.icon_info.data.foreshow_ing;
		this.foreshow_show = this.icon_info.data.foreshow_show;
		this.foreshow_msg = this.icon_info.data.foreshow_msg;
		this.foreshow_icon = this.icon_info.data.foreshow_icon;
		if (this.icon_info.data.count_down_time) {
			show = true;
			this.StartTimer(this.icon_info.time);
		}
		if (this.icon_info.icon_txt != '') {
			show = true;
		}
		this._lb_desc.visible =
			this._img_desc_bg.visible = show;
	}

	StartTimer(time?) {
		this.CancelTimer();
		this.count_time = time;
		if (!this.icon_type || time == null || !this.cfg) {
			return;
		}
		this.update_timer_id = local_GlobalTimerQuest.AddPeriodQuest(
			() => {
				this.OnTimer();
			},
			1,
			-1
		);
		this.OnTimer(true);
	}

	CancelTimer() {
		if (this.update_timer_id) {
			local_GlobalTimerQuest.CancelQuest(this.update_timer_id);
			this.update_timer_id = null;
		}
		this.count_time = 0;
	}

	OnTimer(is_first?) {
		let time = this.count_time - TimeUtil.getServerTime();
		this._lb_desc.visible =
			this._img_desc_bg.visible = false
			if(this.icon_type == "51"){
				console.log("foreshow_show:", this.foreshow_show,"this.foreshow_ing", this.foreshow_ing, ";foreshow_icon:",this.foreshow_icon, ";time:", time);
				
			}
		if (time > 0) {
			if (this.foreshow_icon) {
				if (this.foreshow_show) {
					this._lb_desc.visible =
						this._img_desc_bg.visible = true
					this._lb_desc.text = this.foreshow_msg
					this._lb_desc.color = '#fe1a1a'
				} else if (this.foreshow_ing) {
					this._lb_desc.visible =
						this._img_desc_bg.visible = true
					if (is_first) {
						this._lb_desc.text = TimeUtil.convertTimeColor(time)
					}
					else {
						this._lb_desc.changeText(TimeUtil.convertTimeColor(time))
					}

					// this._lb_desc.text = '即将开启'
					this._lb_desc.color = '#fe1a1a';
				} else {
					this._lb_desc.visible =
						this._img_desc_bg.visible = true
					if (is_first) {
						this._lb_desc.text = TimeUtil.convertTimeColor(time)
					} else {
						this._lb_desc.changeText(TimeUtil.convertTimeColor(time))
					}

					// this._lb_desc.text = '进行中'
					this._lb_desc.color = '#88ff43';
				}
			} else {
				this._lb_desc.visible =
					this._img_desc_bg.visible = true
				if (is_first) {
					this._lb_desc.text = TimeUtil.convertTimeColor(time)
				} else {
					this._lb_desc.changeText(TimeUtil.convertTimeColor(time))
				}
				this._lb_desc.color = '#88ff43';
			}
		} else {
			this.CancelTimer();
			if (this.foreshow_ing && this.icon_info) {
				//预告中
				this.icon_info.data.foreshow_ing = false
				// this.icon_info.data.effect_name = 'UI_1001'
				// this.SetIconEffect('UI_1001', true);
				this.foreshow_ing = null;
				let time = ActivityForeshowManager.GetInstance().ActivityEndTime(this.icon_type);
				ActivityForeshowManager.GetInstance().SetLimitActivityOpen(this.icon_type);
				let activity = ActivityForeshowManager.GetInstance().GetActivity(this.icon_type);
				if (activity) {
					ActivityForeshowManager.GetInstance().ShowTips(activity, true, 1);
				}
				this.icon_info.time = time;
				this.StartTimer(time);
				return;
			}
			if (this.cfg.count_down_time) {
				this._lb_desc.visible =
					this._img_desc_bg.visible = true
				this._lb_desc.text = '已结束'
				this._lb_desc.color = '#fe1a1a';
				if (this.foreshow_icon) {
					ActivityForeshowManager.GetInstance().CloseForeshowicon(this.icon_type);
				}
			} else {
				this._lb_desc.visible =
					this._img_desc_bg.visible = false
			}
			if (!this.cfg.not_delete) {
				local_ActivityIconManager.GetInstance().deleteIcon(this.icon_type);
			}
			let dic = CustomActivityDefine.AdvanceType;
			if (dic[this.icon_type]) {
				BossModel.GetInstance().NeedDeleteFeastBossIcon(dic[this.icon_type]);
			}
			this.UpdateDescX();
			// this._html_desc.x = 85 / 2 - this._html_desc.contextWidth / 2;
		}
	}

	// 红点
	ShowRedDot(bool?) {
		if (this.is_loaded && this.icon_type) {
			this.dot_cache = null;
			let icon_type = String(this.icon_type);
			if (icon_type == '6210') {
				bool = BossModel.GetInstance().GetEudaemonRed() || BossModel.GetInstance().GetEduBossRed() || BossModel.GetInstance().GetEduLoginRed()
					|| BossModel.GetInstance().GetDomainBossRed()
					|| EternityModel.GetInstance().GetAllRedStatus()
					|| TSCrackModel.GetInstance().GetRedState()
					|| SentientActModel.GetInstance().HaveSentientActCount()
					|| GhostWalkModel.ins.getRed()
			} else if (icon_type == '2820') {
				bool =
					DiamondFightModel.GetInstance().GetRecordRedState()
					|| DiamondFightModel.GetInstance().GetRedforDiamond()
					// 	// CSPVPModel.GetInstance().GetAllRedStatus() ||
					|| TopPkModel.GetInstance().GetRedState(true)
					|| Kf1vnModel.GetInstance().HaveQuizRewardCanGet()
					|| Kf1vnModel.GetInstance().CheckSignRed()
			} else if (icon_type == '610') {
				bool = BaseDungeonModel.GetInstance().CheckNewMatrialRed(0)
					|| BaseDungeonModel.GetInstance().GetRuneRedState()
					|| BaseDungeonModel.GetInstance().GetExpRedState()
					|| BaseDungeonModel.GetInstance().GetEquipRedState()
					|| BaseDungeonModel.GetInstance().GetDragonRedState()
					|| DungeonPartnerModel.GetInstance().GetRedState()
					|| kfSingleRankModel.GetInstance().GetRedStatus(ModuleType.SINGLE_RANK)
			} else if (icon_type == '4601') {
				bool = BossModel.GetInstance().GetFieldBossRedState()
					|| BaseDungeonModel.GetInstance().GetVipPersonRed()
					|| BossModel.GetInstance().GetSuitRed()
					|| BossModel.GetInstance().GetMysteryBossRed()
					|| DragonWhisperModel.GetInstance().GetRedStatus()
					|| BossModel.GetInstance().GetBossAbyssRed()
			} else if (icon_type == '280') {
				bool = ArenaModel.GetInstance().GetRedState()
					|| NineSkyModel.GetInstance().GetRedState()
					|| GuildFightModel.GetInstance().IsShowRed()
					|| TopPkModel.GetInstance().GetRedState()
					|| HolyBattleModel.GetInstance().GetRedState();
			} else if (icon_type == '153') {

				let shop_model = ShopModel.GetInstance()
				let daly_first_login = local_CustomActivityModel.GetInstance().GetDayFirstLoginStatus()

				//限购商店红点
				let plat_form_mgr = PlatformManager.GetInstance()
				let limit_red = shop_model.limit_red_status&&!plat_form_mgr.is_alpha && !plat_form_mgr.need_alpha_open_charge

				//跨服异域
				let honer_red = shop_model.Honer_red_status && KfHolyAreaModel.GetInstance().GetOpenState()[0]

				let day_red = (
					(limit_red || honer_red) && daly_first_login)
					|| shop_model.diamond_red_status
					|| RedDotController.ins.get(RedKey.GUILD_SHOP1)
					|| RedDotController.ins.get(RedKey.GUILD_SHOP2)
				// let every_red = false
				// //let every_red = ShopModel.GetInstance().vie_red_stutus
				// let day_red = (ShopModel.GetInstance().limit_red_status || ShopModel.GetInstance().Honer_red_status)
				// 	&& local_CustomActivityModel.GetInstance().GetDayFirstLoginStatus()
				// bool = every_red || day_red
				// //目前暂时测试钻石商城红点
				// // let day_red = ShopModel.GetInstance().diamond_red_status;
				bool = day_red;
			} else if (icon_type == '417') {
				bool =
					false ||
					WelfareModel.GetInstance().online_red
					|| WelfareModel.GetInstance().dailysign_red
					// || WelfareModel.GetInstance().GetSuperVipRed()
					|| WelfareModel.GetInstance().GetDailySupplyRed()
					|| LoginModel.GetInstance().GetNoticeRed()
				// (AttentionModel && AttentionModel.GetInstance():ShouldInToWefareIcon() && AttentionModel.GetInstance().ShowAttentionRedDot())
			} else if (icon_type == '500@1@2') {
				bool = false;
				// EscortModel.GetInstance().HasEscortTimes()
			} else if (icon_type == '175') {
				// bool = SevenDayModel.GetInstance().GetSevenDayRed(SevenDayModel.iconToType[icon_type])
			} else if (icon_type == '175_1') {
				// bool = SevenDayModel.GetInstance().GetSevenDayRed(SevenDayModel.iconToType[icon_type])
			} else if (icon_type == '175@8') {
				// bool = SevenDayModel.GetInstance().GetSevenDayRed(SevenDayModel.iconToType[icon_type])
			} else if (icon_type == '284') {
				bool = KfHolyAreaModel.GetInstance().GetRedState()
			} else if (icon_type == '100') {
				bool = this.GetIconBoxRedDot(icon_type);
			} else if (icon_type == '331@3') {
				// bool = local_CustomActivityModel.GetInstance().GetKaiFuActivityRedDot("331@3")
			} else if (icon_type == '331@3_8') {
				bool = this.GetIconBoxRedDot(icon_type);
			} else if (icon_type == '182') {
				bool = BabyModel.GetInstance().GetIconRed();
			} else if (icon_type == '1721') {
				bool =
					RedDotManager.GetInstance().CheckRedStatusMultModule(
						MarriageRedList
					);
			} else if (icon_type == '416') {
				bool = RuneTreasureModel.GetInstance().GetAllRed()
			} else if (icon_type == '11111') {
				// bool = AttentionModel.GetInstance().ShowAttentionRedDot()
			} else if (icon_type == '101') {
				bool =
					local_ActivityIconManager.GetInstance().GetIconRedDot('42701') ||
					false ||
					local_ActivityIconManager.GetInstance().GetIconRedDot('42702') ||
					false ||
					local_ActivityIconManager.GetInstance().GetIconRedDot('331@58@0') ||
					false;
			} else if (icon_type == '151') {
				bool = false;
				RedDotManager.GetInstance().CheckRedStatus(ModuleType.AUCTON, 1);
			} else if (icon_type == '159') {
				let fitst_rech_model = FirstRechargeModel.GetInstance();
				let no_recharge =
					fitst_rech_model.IsNoFirstRecharge() && fitst_rech_model.loginfirst;
				if (no_recharge == null) {
					no_recharge = false;
				}
				bool = fitst_rech_model.iconRed || no_recharge;
			} else if (icon_type == '41719') {
				bool = false;
				// WelfareModel.GetInstance().xinYue_Data.gift_st == 0
			} else if (icon_type == '1861') {
				bool = SeaHegemonyModel.GetInstance().GetReddot()
			} else if (icon_type == '1525') {
				let lv = RoleManager.GetInstance().GetMainRoleLevel()
				if (lv < SuitActivityModel.ShowArrowLv) {
					bool = SuitActivityModel.GetInstance().showRed
					this.suit_arrow = false
				} else {
					bool = false
					if (!SuitActivityModel.GetInstance().showRed) {
						local_GlobalEventSystem.Fire(local_EventName.CLOSE_FUNCBOARD, 1525)
						this.suit_arrow = false
					} else {
						if (this.suit_arrow) {
							return
						}
						this.suit_arrow = true
						local_GlobalTimerQuest.AddDelayQuest(() => {
							let scmd = {
								uid: 1525
							}
							MainUIModel.GetInstance().Fire(MainUIModel.SHOW_FUNC_BOARD_VIEW, scmd, 1525)
						}, 1)
					}
				}
			} else if (icon_type == '223') {
				bool = FestivalModel.GetInstance().GetFestivalEntranceReDot();

			} else if (icon_type == '41720') { // 成长福利
				bool = GrowthBenefitsModel.GetInstance().GetDayRedDotStateAll() || GrowthForceModel.GetInstance().CheckFightWelfareRed()
			} else if (icon_type == '130') {
				bool = ReincarnationModel.GetInstance().GetRedDot()
			} else if (icon_type == '331@97') {
				bool = BaseDungeonModel.GetInstance().CheckTowerRed()
			} else if (icon_type == "331@110") {
				bool = CycleimpActlistModel.GetInstance().CheckActData()
			} else if (icon_type == '621') {
				bool = Kf1vnModel.GetInstance().CheckSignRed()
			} else if (icon_type == '241') {
				bool = SentientActModel.GetInstance().HaveSentientActCount()|| 
					GhostWalkModel.ins.getRed()
			} else if (icon_type == "137") {
				bool = DiamondFightModel.GetInstance().GetRedforDiamond()
			}
			else if (icon_type == '113113') {
				bool = AttentionModel.GetInstance().GetSdkAttentionRedState()
			}
			else if (icon_type == '241@1@0') {
				bool = /**GhostWalkModel.ins.GetActiveIconRed() || */
				SentientActModel.GetInstance().GetActiveIconRed()
			}
			else {
				if (this.icon_type.toString().substring(0, 3) == "612") {
					let [type, subtype] = LimitLevelShopModel.GetInstance().IconType2Type(icon_type)
					bool = LimitLevelShopModel.GetInstance().GetRedState(type, subtype)
				}
			}
			if (bool == null) {
				bool = local_ActivityIconManager.GetInstance().GetIconRedDot(
					this.icon_type
				);
			} else {
				local_ActivityIconManager.GetInstance().SetIconRedDot(this.icon_type, bool);
			}
			this._img_red.visible = bool;
		} else {
			this.dot_cache = bool;
		}
	}

	GetIconBoxRedDot(icon_type?) {
		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigBoxIcon;
		let vo = null;
		let can_add = null;
		let box_icon_cfg = null;
		let bool = null;
		for (let key in cfg) {
			vo = cfg[key];
			if (vo.attach_icon_type == icon_type) {
				box_icon_cfg = CommonManager.GetInstance().GetBoxIconCfg(
					vo.icon_type
				);
				let info = local_ActivityIconManager.GetInstance().getBoxIconInfo(
					vo.icon_type
				);
				if (info) {
					bool = local_ActivityIconManager.GetInstance().GetIconRedDot(
						vo.icon_type
					);
					if (bool == null) {
						bool = false;
					}
					if (key == '417') {
						bool =
							false ||
							WelfareModel.GetInstance().online_red
							|| WelfareModel.GetInstance().dailysign_red
							|| WelfareModel.GetInstance().GetDailySupplyRed()
						// or (AttentionModel.GetInstance():ShouldInToWefareIcon() && AttentionModel.GetInstance().ShowAttentionRedDot())
					} else if (key == '1112') {
					} else if (key == '331@6@0') {
					} else if (key == '331@3') {
					} else if (key == "452"){
						bool = false || WeekCardModel.GetInstance().CanReceive() || WeekCardModel.GetInstance().spacial_red
					} 
				}
				if (bool) {
					break;
				}
			}
		}
		return bool;
	}

	// 点击icon
	ClickEvent() {
		if (!this.is_loaded || !this.icon_type || !this.cfg) {
			return;
		}
		if (this.cfg.effect_need_delete && this.cfg.effect_name != "") {
			this.is_clicked = true
			this.ClearUIEffect(this._box_effect2)
		}
		if (this.foreshow_show || this.foreshow_ing) {
			ActivityForeshowManager.GetInstance().OpenFunctionOpen(this.icon_type);
			return;
		}
		if (this.cfg.is_box) {
			let pos = new Laya.Point(this.display_obj.x, this.display_obj.y);

			let global_pos = this._parent.localToGlobal(pos);
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, 'MainUIIconBoxView');
			local_GlobalEventSystem.Fire(
				local_EventName.OPEN_VIEW,
				'MainUIIconBoxView',
				this.icon_type,
				global_pos
			);
			return;
		}

		//注意 this.icon_type 可能会是numble类型
		let icon_type_str = String(this.icon_type)
		switch (icon_type_str) {
			case '415':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_PRAY_VIEW);
				break;
			case '221':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_RANK_VIEW, 0, 0);
				break;
			case '153':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW);
				break;
			case '151':
			case '151@1':
				MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, 'MarketBaseView');
				break;
			case '157':
				if (DailyModel.GetInstance().need_tuo_guan_guide) {
					DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, 'DailyView', 4);
				} else {
					DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, 'DailyView');
				}
				break;
			case '158':
				let pos = new Laya.Point(this.display_obj.x, this.display_obj.y + this._img_icon.height);
				let global_pos = this._parent.localToGlobal(pos);
				this.talk_board.SetVisible(false)
				MainStrongerModel.ins.isBubbleOpen = true
				MainStrongerModel.ins.isHideBoard = false
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MainUIStrongerView", global_pos);
				local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this._box_arrow)
				// DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, '', 6);
				break;
			case '610':

				let task = TaskModel.GetInstance().GetMainLineTaskVo()
				if (task && (task.task_id == 101160 || task.task_id == 101270) && task.has_finish != 1) {
					let index = task.task_id == 101160 ? DungeonEnterViewIndex.Exp : DungeonEnterViewIndex.Equip
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", index)
				}
				else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'DungeonEnterView');
				}
				break;
			case '4601':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'BossEnterView');
				break;
			case '280':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'BattleFieldEnterView');
				break;
			case '2820':
				local_GlobalEventSystem.Fire(
					local_EventName.OPEN_VIEW,
					'WorldBattleEnterView',
					TopPkModel.GetInstance().WorldBattleIndex.Diamond_Fight
				);
				break;
			case '340':
				FriendInviteModel.GetInstance().Fire(
					FriendInviteModel.OPEN_FRIEND_INVITE_VIEW
				);
				// } else if (
				// 	this.icon_type == '158@0' ||
				// 	this.icon_type == '158@3' ||
				// 	this.icon_type == '158@0@2' ||
				// 	this.icon_type == '158@3@2'
				// :
				// 	VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, 'RechargeView');
				break;
			case '416':
				RuneTreasureModel.GetInstance().Fire(
					RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW,
					'RuneTreasureBaseView'
				);
				break;
			case '1112':
				KaifuActivityModel.GetInstance().Fire(
					KaifuActivityModelEvent.OPEN_KAIFUACTIVITYVIEW
				);
				break
			case '175':
			case '175@8':
			case '175_1':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SEVENDAY_VIEW, icon_type_str);
				break;
			case '159':
				FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.CLOSE_NEW_TIPS_VIEW)
				// FirstRechargeModel.GetInstance().Fire(
				// 	FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW
				// );
				ViewPopLevelModel.GetInstance().SetViewPop('FirstRechargeView');
				break;
			case '331@7@1':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@3', 7, 1);
				break;
			case '331@7@0':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@3', 7, 0);
				break;
			case '331@71@0':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@71@0');
				break;
			case '331@4@0':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@3', 4, 0);
				break;
			case '331@10@0':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, '331@100', '10', '0');
				break;
			case "331@62@1":	
			case '331@67_0':
			case '331@67_1':
			case '331@67_2':
			case '331@67_3':
			case '331@67_4':
				let list = Split(icon_type_str, '@');
				let list2 = Split(list[2], '_');
				local_GlobalEventSystem.Fire(
					local_EventName.OPEN_ACT_VIEW,
					icon_type_str,
					list2[1],
					list2[2]
				);
				break;
			case '331@77@0':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'TestActBaseView');
				// local_CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33216)
				break;
			case '331@94@0':
				let local_list = Split(icon_type_str, '@');
				let local_info = local_CustomActivityModel.GetInstance().GetActInfoByShowID(local_list[1], local_list[2])
				if (local_info){
					EyouManager.GetInstance().FreeGift(local_info.base_type, local_info.sub_type)
				}
				break;
			case '417':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_WELFARE_VIEW);
				// } else if (CompeteListModel.IsBillboardAct(this.icon_type):
				// 	let iconinfo = CompeteListModel.GetInstance().GetActInfo(this.icon_type)
				// 	if (!iconinfo:
				// 		return
				// 	}
				// 	let config = CompeteListModel.GetInstance().config_atList[iconinfo.type + "@" + iconinfo.subtype]
				// 	if (config && config.act_type != 1:
				// 		local_GlobalEventSystem.Fire(
				// 			local_EventName.OPEN_ACT_VIEW,
				// 			config.icon,
				// 			Config.ConfigCustomActivity.SPECIAL_ID.COMPETELIST + "@" + iconinfo.type + "@" + iconinfo.subtype
				// 		)
				// 	} else {
				// 		local_GlobalEventSystem.Fire(local_EventName.OPEN_COMPETELIST_ENTER_VIEW, iconinfo.type, iconinfo.subtype)
				// 	}
				break;
			case '6210':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'CrossServerEnterView');
				// Kf1vnModel.GetInstance().Fire(Kf1vnEvent.KF1VN_OPEN_VIEW, "CrossServerEnterView")
				break;
			case '137':
				local_GlobalEventSystem.Fire(
					local_EventName.OPEN_VIEW,
					'WorldBattleEnterView',
					DiamondFightModel.MODULE_ID
				);
				break;
			case "51":
				let info = local_CustomActivityModel.GetInstance().GetActInfoByType(51)
				if (info) {
					let icon_type = local_CustomActivityModel.GetInstance().GetFeastBossIconType()
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type, 51, info.show_id)
				}
				break;
			case "402@2@1":
				GuildActivityModel.GetInstance().Fire(GuildActEvent.REQUEST_PROTO, 40212)
				//break;case "135@0@1" || this.icon_type == "135@0@2":
				// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BattleFieldEnterView", BaseEnterDefine.GetBattleFieldIndex().NineSky)
				// 	// break;case "281@0@1" :
				// 	// 	TopPkModel.GetInstance().OpenTopView()
				break;
			case '450@1':
				VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, 'VipActiveView');
				break;
			case '283':
				this.ClearUIEffect(this._box_effect)

				let is_login = CookieWrapper.GetInstance().GetCookie(CookieWrapper.HT_LOGIN_STATE, true)
				if (HolyTerritoryModel.GetInstance().IsRealOpen()) {
					if(is_login){
						HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW,'holyTerritoryMainView',1);
					}else{
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'HolyTerritoryOpenView');
					}
				}else{
					HolyTerritoryModel.GetInstance().Fire(HTEvent.OPEN_VIEW,'holyTerritoryMainView',0);
				}

				break;
			case '284':
				KfHolyAreaModel.GetInstance().Fire(
					KfHolyAreaModel.OPEN_VIEW,
					'KfHolyAreaEnterView'
				);
				break;
			case "331@563"://1.15倍
			case "331@561"://双倍
				OpenFun.OpenFunHandler(53)
				break;
			case "331@562":
				OpenFun.OpenFunHandler(7)
				break;
			case '172@1':
				// BanquetModel.GetInstance().Fire(BanqEvent.OPEN_VIEW, "BanquetNoticeView", 1)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'BanquetNoticeView', 1);
				break;
			case '172@2':
				// BanquetModel.GetInstance().Fire(BanqEvent.OPEN_VIEW, "BanquetNoticeView", 2)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'BanquetNoticeView', 2);
				break;
			case '130':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_REINCARNATION_ENTER_VIEW);
				break;
			case '285@1@1':
				NoonPartyModel.GetInstance().Fire(NoonPEvent.ENTER_SCENE);
				// break;case MondaysAwardModel.GetInstance().icon_type:
				// 	MondaysAwardModel.GetInstance().Fire(MondaysAwardEvent.OPEN_VIEW, "MondaysAwardEntView")
				break;
			case '490':
				SurpriseGiftModel.GetInstance().Fire(
					SurpriseGiftModel.OPEN_VIEW,
					'SurpriseGiftBaseView'
				);
				break;
			case '4205':
				KaifuActivityModel.GetInstance().Fire(
					KaifuActivityModelEvent.OPEN_TOP_IVITY_VIEW
				);
				// break;case "424" || this.icon_type == "424@1" || this.icon_type == "424@2":
				// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, "331@3", "424")
				break;
			case '182':
				OpenFun.OpenFunHandler(122);
				BabyModel.GetInstance().CheckLvRed();
				break;
			case '1721':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'MarriageBaseView');
				break;
			case AdventureModel.GetInstance().cur_icon_type:
				OpenFun.OpenFunHandler(131)
				// break;case "11111":
				// 	AttentionModel.GetInstance().SetHasShowTag()
				// 	let sdk_name = PlatformMgr.GetInstance().GetSDKName()
				// 	if (sdk_name:
				// 		//let enable_params = table2json( {apiType='askShow'})
				// 		//httpManager:CurrencyFunc("Subscribe",(parms_?) => {
				// 		AttentionModel.GetInstance().Fire(AttentionEvent.ATTENTION_OPEN_VIEW, "AttentionView")
				// 		//console.log('吊起关注界面++++++++', parms_)
				// 		//let data = luaJson.json2table( parms_)
				// 		//if (data && data.cpStatus == 1 :
				// 		//console.log('关注成功++++++++', parms_)
				// 		//this:SetHasShowTag()
				// 		//}else{
				// 		//}
				// 		//}
				// 		//,sdk_name + (" | ") + enable_params
				// 		//)
				// 	}
				break;
			case LungModel.LUNG_TOP_ICON:
				OpenFun.OpenFunHandler(118);
				// 	// break;case "279" :
				// 	// 	OpenFun.OpenFunHandler(136)
				break;
			case '451':
				OpenFun.OpenFunHandler(451);
				// break;case "452":
				// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_SUPER_VIP)
				// break;case "402":
				// 	GuildActivityModel.GetInstance().Fire(GuildActEvent.REQUEST_PROTO, 40212)
				// 	// break;case "471" :
				// 	// 	BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 47110)
				break;
			case '113':
				AttentionModel.GetInstance().Fire(AttentionEvent.ATTENTION_OPEN_VIEW, 'AttentionViewLaya');
				// 	// break;case "512" :
				// 	// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_KF_CLOUD_PURCHASE_BASE_VIEW)
					break;
			case "90@331" :
				local_GlobalEventSystem.Fire(local_EventName.OPEN_QUESTIONNAIRE_VIEW)
				// 	// break;case "99999" :
				// 	// 	AttentionModel.GetInstance().Fire(AttentionEvent.ATTENTION_OPEN_VIEW, "GuideCodeView")
				// 	// break;case "331@92@0" :
				// 	// 	OpenFun.OpenFunHandler(179)
				break;
			case '113113':
				AttentionModel.GetInstance().Fire(AttentionEvent.ATTENTION_OPEN_VIEW, 'AttentionView');
				break
			case "186":
			case "18601":
				SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView")
				break;
			case "1861":
				SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "CountryBaseView")
				// break;case "41719" :
				// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "XinYueGiftMainView")
				// break;case "331_wb_qqlive" :
				// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "QQLiveGDJCView")
				// 	local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, this._img_icon)
				break;
			case '191':
				PushGiftModel.GetInstance().Fire(
					PushGiftModel.OPEN_VIEW,
					'PushGiftEntView'
				);
				// break;case "142":
				// 	local_GlobalEventSystem.Fire(local_EventName.CLOSE_MOUNTPET_VIEW)
				// 	OpenFun.OpenFunHandler(16)
				break;
			case '1525':
				OpenFun.OpenFunHandler(196);
				break;
			case "666":// Facebook活动界面
				if (PlatformManager.IsEyouPlatform()){
					PlatformManager.GetInstance().JumpToFaceBook()
				}
				break;
			case "777":// Facebook活动界面
				PlatformManager.GetInstance().ShowTheBlockUserAccountViewBlock()
				break;
			case '179':
				OpenFun.OpenFunHandler(111);
				break;
			case '621':
				OpenFun.OpenFunHandler(621);
				break;
			case '223': // 祭典
				FestivalModel.GetInstance().Fire(
					FestivalModelEvent.OPEN_FESTIVAL_VIEW,
					FestivalBaseView._layout_file,
					EnumFestivalTabType.eAward
				);
				break;
			case '41720': // 成长福利
				GrowthForceModel.GetInstance().Fire(
					GrowthForceModelEvent.OPEN_VIEW,
					GrowthForceView._layout_file,
					EnumGrowthForceViewType.eGrowingUp
				);
				break;
			case '331@58@0':
				let ids: string[] = icon_type_str.split('@');
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type_str, ids[1], ids[2]);
				break;
			case '241':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'WorldBattleEnterViewTwo');
				break;
			case '331@117@0':
				let ids_117: string[] = icon_type_str.split('@');
				local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type_str, ids_117[1], ids_117[2]);
				break;
			case "331@97":
				OpenFun.OpenFunHandler(237)
				break;
			case "114":
				AddVipServiceModel.GetInstance().Fire(AddVipServiceEvent.ADDVIPSERVICE_OPEN_VIEW, "AddVipServiceView")
				break;
			case "452":
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'WeekCardEnterView');
				break;
			case "160":
				var param = { func: "AWY_SVIP", status: 1 };
				parent.postMessage(JSON.stringify(param), "*")
				break;
			case '45120':
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SVIP_MAIN_VIEW);
				break;
			case "331@129@0":
				let ids_129: string[] = icon_type_str.split('@');
				let act_info_129 = local_CustomActivityModel.GetInstance().GetActInfoByShowID(ids_129[1], ids_129[2])
				if(act_info_129){
					local_CustomActivityModel.GetInstance().CloseACTRed(act_info_129.base_type, act_info_129.sub_type)
					let condition = ErlangParser.GetInstance().parse(act_info_129.condition)
					FairyWishModel.GetInstance().Fire(FairyWishEvent.REQUEST_PROTO, 51300, Number(condition[2][1]))
					FairyWishModel.GetInstance().Fire(FairyWishEvent.OPEN_VIEW, "FairyWishView", Number(condition[2][1]))
				}
				break
			case `113113113`:
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "KSAPKShortcutTipsView")
				break
			case '143':
				let dragon_model = DragonBallModel.GetInstance()
				let state = dragon_model.GetStatueActiveState()
				if(state){
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'DragonBallGiftView');
				}else{
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, 'DragonBallView');
				}
				dragon_model.first_show_red_dot = false
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "143", false)
				break;
			default:
				//一些特殊的情况
				if (local_CustomActivityModel.GetInstance().IsActIcon(icon_type_str) && local_CustomActivityModel.GetInstance().GetOpenState(icon_type_str)) {
					let icon_type = icon_type_str;
					//if (icon_type == "331@103" :
					//	icon_type = "331@103@1"
					//}
					let id
					if (icon_type == "331@98@0" || icon_type == "331@98@1" || icon_type == "331@100@0") {
						id = icon_type.replace("331@", "")
						id = id.replace("@0", "")
						id = id.replace("@1", "")
						icon_type = "331@100"
						let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
						if (open_day > 5 && id == 100) {
							id = "101"
						}
						if (open_day > 7) {
							icon_type = "331@110"

						}
					}
					if (icon_type == "331@4" || icon_type == "331@4_1" || icon_type == "331@81@12" || icon_type == "331@81@13") {
						local_CustomActivityModel.GetInstance().online_draw_back_id = icon_type
					}
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ACT_VIEW, icon_type, id);
				} else if (icon_type_str.substring(0, 3) == "612") {
					LimitLevelShopModel.GetInstance().Fire(LimitLevelShopModel.OPEN_VIEW, icon_type_str)
				} else if (icon_type_str.substring(0, 3) == '338') {// 竞榜
					let ids: string[] = icon_type_str.split('@');
					local_GlobalEventSystem.Fire(local_EventName.OPEN_COMPETELIST_ENTER_VIEW, ids[1], ids[2]);
				} else if (this.foreshow_icon) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_FORESHOW_ICON_VIEW, icon_type_str);
					// break;case 176 :
					// 	ShopPurchaseModel.GetInstance().Fire(ShopPurchaseModel.OPEN_VIEW)
					// break;case Kf1vnModel.ICON_TYPE:
					// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "WorldBattleEnterView", Kf1vnModel.MODULE_ID)
				}
				break;
		}


		local_GlobalEventSystem.Fire(local_EventName.CLOSE_ICON_BOX_VIEW);
	}

	SetEffect(effect_name?, bool?, pos?, scale?, loop?) {
		if(!effect_name){
			return
		}

		if (bool == null) {
			bool = true
		}
		if (bool) {
			this.AddUIEffect(effect_name, this._box_effect2, pos, scale)
		} else {
			this.ClearUIEffect(this._box_effect2)
		}
	}

	public SetVisible(bool) {
		super.SetVisible(bool);
	}

	RefreshPos() {
		// if (! Util.IsTableEmpty(this.story_target_name_dic) && this._gp_static.numChildren >= 3 ) {
		// 	let i = 2
		// 	do {
		// 		let obj = this._gp_static.getChildAt(i)
		// 		if (obj.instanceof(ArrowComponent) ) {
		// 			obj.SetPosition({x = this._img_icon.x, y = this._img_icon.y}, true, null, null, true)
		// 		}
		// 		i = i + 1
		// 	} while ((i < this._gp_static.numChildren)
		// )
		// }
	}

	SetAlpha(alpha?) {
		if (this.is_loaded) {
			this.display_obj.alpha = alpha;
		} else {
			this.alpha_cache = alpha;
		}
	}

	SetIconScale(scale?) {
		if (this.is_loaded) {
			SetLocalScale(this.display_obj, scale);
		} else {
			this.icon_scale_cache = scale;
		}
	}

	SetAsLastSibling(not_need_sorting_order?) {
		if (this.is_loaded) {
			this._parent.setChildIndex(
				this.display_obj,
				this._parent.numChildren - 1
			);
			if (!not_need_sorting_order) {
				// let finger = this.story_model.GetFinger(this, this._img_icon)
				// if (finger && finger.gameObject) {
				// 	finger.SetCoverMode()
				// }
			}
		} else {
			this.set_first_cache = true;
		}
	}

	UpdateDescX() {
		// this._html_desc.callLater(() => {
		// 	this._html_desc.x = (this._gp_static.width - this._html_desc.width) / 2
		// })
	}

	createChildren() {
		if (this['GetComponents']) {
			this['GetComponents']();
			this.is_get = true;
		}
		this.story_target_name_dic = {}
		if (this.icon_type == '610') {
			this.story_target_name_dic[StoryModel.StoryTargetName.SingleDungeon] =
				this._box_arrow;
		} else if (this.icon_type == '4601') {
			this.story_target_name_dic[StoryModel.StoryTargetName.BossDungeon] =
				this._box_arrow;
		} else if (this.icon_type == '280') {
			this.story_target_name_dic[StoryModel.StoryTargetName.ArenaBtn] =
				this._box_arrow;
		} else if (this.icon_type == '331@3' || this.icon_type == '331@3_1') {
			this.story_target_name_dic[StoryModel.StoryTargetName.KaiFuBtn] =
				this._box_arrow;
		} else if (this.icon_type == '416') {
			this.story_target_name_dic[StoryModel.StoryTargetName.RuneTreasureBtn] =
				this._box_arrow;
		} else if (this.icon_type == '417') {
			this.story_target_name_dic[StoryModel.StoryTargetName.WefareBtn] =
				this._box_arrow;
		} else if (this.icon_type == '1525') {
			this.story_target_name_dic[StoryModel.StoryTargetName.SuitActivityBtn] =
				this._box_arrow;
		} else if (this.icon_type == WelfareModel.WBQQLive) {
			if (LoginModel.GetInstance().is_new_career) {
				let step_cfg = { direction: 4, text: '更多精彩活动' }
				local_GlobalEventSystem.Fire(
					local_EventName.SHOW_FINGER,
					this,
					this._box_arrow,
					'Main',
					null,
					null,
					false,
					false,
					step_cfg,
					true,
					1
				);
			}
		}
		super.createChildren();
	}

	SetIconType(icon_type) {
		this.icon_type = icon_type || this.icon_type;
		if (!this.is_loaded) {
			this.need_refresh_data = true;
			return;
		}
		this.cfg = CommonManager.GetInstance().GetFunctionIconCfg(this.icon_type);
		this.icon_info = local_ActivityIconManager.GetInstance().getIconInfo(
			this.icon_type
		);
		if (!this.icon_info) {
			let info = local_ActivityIconManager.GetInstance().getBoxIconInfo(
				this.icon_type
			);
			if (info) {
				this.icon_info = info;
			}
		}
		if (!this.cfg) {
			return;
		}
		this.SetIconImg();
		this.SetCountTimer();
		this.SetIconEffect();
		this.ShowRedDot(this.dot_cache);
		if (this.icon_info && this.icon_info.icon_txt) {
			this.SetIconText(this.icon_info.icon_txt);
		}
		if (icon_type == 159 && FirstRechargeModel.GetInstance().GetFirstRechargeQiPaoInfo().str != "" && !FirstRechargeModel.GetInstance().no_show_qipao) {
			this.CreateQipao()
		} else if (icon_type == 159) {
			FirstRechargeModel.GetInstance().no_show_qipao = false
		}
		if (icon_type == 283 && ServerTimeModel.GetInstance().GetOpenServerDay() == 2) {// && !CookieWrapper.GetInstance().GetCookie(CookieWrapper.HT_LOGIN_STATE, true)
			this._box_effect.width = 720
			this._box_effect.height = 1280
			this._box_effect.mouseThrough = true
			this._box_effect.mouseEnabled = false
			SetAnchoredPosition(this._box_effect, -325, -605)
			this.AddUIEffect("UI_1303c", this._box_effect, null, 0.8)
		}

		if (icon_type == 191) {
			ViewGiftPopModel.GetInstance().Fire(ViewGiftPopModelEvent.NEXT_OPEN_TIPS);
		}

	}
	_box_effect: Laya.Box
	_img_icon: Laya.Image
	_box_arrow: Laya.Image
	_img_red: Laya.Image
	_img_desc_bg: Laya.Image
	_img_red_num: Laya.Image
	_lb_num: Laya.Text
	_lb_desc: Laya.Text
	_box_effect2: Laya.Box
	public GetComponents() {
		[
			this._box_effect,
			this._img_icon,
			this._box_arrow,
			this._img_red,
			this._img_desc_bg,
			this._img_red_num,
			this._lb_num,
			this._lb_desc,
			this._box_effect2
		]
			= this.GetChildrenByNames([

				"_box_effect",
				"_img_icon",
				"_box_arrow",
				"_img_red",
				"_img_desc_bg",
				"_img_red_num",
				"_lb_num",
				"_lb_desc",
				"_box_effect2"
			])
	}
}
window["ActivityIcon"] = ActivityIcon