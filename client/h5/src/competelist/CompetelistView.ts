
import { Alert, Alert_Type } from '../alert/Alert';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { OpenFun } from '../common/OpenFun';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { CompeteListEvent, CompeteListModel } from '../commonModel/CompeteListModel';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { RoleManager } from '../commonModel/RoleManager';
import { Message } from '../sysInfo/SysInfoController';
import { Enum_ColorUtil_Light } from '../util/ColorUtil';
import { GameResPath } from '../util/GameResPath';
import { SYTweenFunc } from '../util/SYTweenFunc';
import { SYTweenLite } from '../util/SYTweenLite';
import { TimeUtil } from '../util/TimeUtil';
import { Color, GlobalTimerQuest, Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
import { CompetelistIntegralItem } from './CompetelistIntegralItem';
import { CompetelistRankItem } from './CompetelistRankItem';
export class CompetelistView extends BaseItem1 {
	ClearModel
	CreateModel
	CustomMehod
	InitEvent
	LoadSuccess
	Local_DeleteMe
	Out_Label6
	Scr_Scroller1
	Scr_Scroller2
	_Viewport1
	_Viewport2
	_Width
	_arrayCollection
	_first
	_lb_end
	_max
	_model: CompeteListModel
	_reward_show_dic
	_show_id
	_sub_type
	_timer
	_type
	config_integral
	config_rank
	config_reward
	config_skill
	cur_sorting_order
	end_time
	initIntegral
	initRank
	initView
	item_list
	mask_item_mat
	onTimer
	parent_mask
	preWidth
	preload_client_config
	preload_server_config
	removeTimer
	res_id
	role_model
	show_id
	tween_id
	updateBar
	updateView

	// 配置
	private confShow: any;

	public constructor(parent?) {
		super(parent)


		this._timer = null
		this.end_time = 0
		this._type = null
		this._sub_type = null
		this.show_id = null
		this.config_integral = null
		this.config_rank = null
		this.config_reward = null
		this.config_skill = null
		this.item_list = []
		this._Width = 0
		this._max = 0
		this._show_id = null
		this.res_id = 0
		this.role_model = null
		this._reward_show_dic = null
		this._first = true
		this.tween_id = null
		this._arrayCollection = null

		this.base_file = "competelist";
		this.layout_file = "CompetelistView";
		this.layer_value = Enum_UILayer.UI;
		this._model = CompeteListModel.GetInstance();

		let local_CompeteListEvent = CompeteListEvent;
		let role_mgr = RoleManager.GetInstance();
		let goods_model = GoodsModel.GetInstance();
		let local_Message = Message;
		let local_OpenFun = OpenFun;
		let local_Alert = Alert;

		this.load_callback = () => {
			this.InitEvent();
			this.LoadSuccess();

			// if (PlatformManager.IsEyouEnPlatform()) {
			// 	SetAnchoredPositionY(this._lb_skill_name, -203)

			// 	// let csf = this._lb_end_time.GetComponent("ContentSizeFitter")
			// 	// csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	// csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDelta(this._lb_end_time, 330, 46);
			// 	// this._lb_end_time.lineSpacing = 0.6

			// 	// csf = this._Label7.GetComponent("ContentSizeFitter")
			// 	// csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	// csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDelta(this._Label7, 80, 50)
			// 	SetAnchoredPositionY(this._Label7, 14)

			// 	// SetSizeDeltaX(this._Label6, 95)
			// 	// SetAnchoredPositionX(this._Label6, 16)
			// 	// this._Label6.verticalAlign = "middle"
			// 	// this._Label6.textAlign = "center"
			// }
		}

		//this.preload_server_config = {
		//Raceactstagereward=false,
		//Raceactrankreward=false,
		//Raceactreward=false
		//}

		this.preload_client_config = {
			ClientCompetelistSkill: false,
			ClientConfigRaceActRewardShow: false
		}

		this.CustomMehod = (index?, args?) => {
			if (this._type == null) {
				if (!args.base_type) {
					args = args[0];
				}
				this._type = args.base_type;
				this._sub_type = args.sub_type;
				this.show_id = args.show_id;
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_one, () => {
				let buy_fun = () => {
					this._model.Fire(local_CompeteListEvent.REQUEST_PROTO, 33803, "hhc", this._type, this._sub_type, 1)
				}

				let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type]
				if (!viewData) {
					return
				}
				let type_id = viewData.cost[0].typeId;
				let all = 0;
				let allJin = role_mgr.GetMainRoleVo().jin;
				let jin = viewData.cost[0].style == 1;
				if (jin) {
					all = allJin;
				} else {
					all = goods_model.GetTypeGoodsNum(type_id);
				}

				if (all < viewData.cost[0].count) {
					if (jin) {
						local_Message.show("勾玉不足");
						local_OpenFun.OpenFunHandler(21);
					} else {
						if (!this._model.cost_alert) {
							let cost = viewData.cost[0].count;
							let str =
								`是否花费
							<font color='#639c12'>${cost}</font>
							勾玉购买
							<font color='#639c12'>${viewData.cost[0].count}</font>
							个
							<font color='#639c12'>幸运币</font>`;
							local_Alert.Show(str, Alert_Type.AlertTypeCheckBox, () => {
								if (allJin < cost) {
									let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
									if(state){
										local_OpenFun.OpenFunHandler(21);
									}else{
										local_OpenFun.OpenFunHandler(249);
									}
									// local_OpenFun.OpenFunHandler(21);
								} else {
									buy_fun();
								}
							}
								, null, "确定", "取消", null, false, (bool?) => {
									this._model.cost_alert = bool;
								}
								, "本次登录不再提示")
						} else {
							buy_fun();
						}
					}
				} else {
					buy_fun();
				}
			}, this, true);

			Util.AddClickEvent(this._btn_ten, () => {
				let buy_fun = () => {
					this._model.Fire(local_CompeteListEvent.REQUEST_PROTO, 33803, "hhc", this._type, this._sub_type, 10)
				};

				let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type];

				if (!viewData) {
					return;
				}

				let type_id = viewData.ten_cost[0].typeId;
				let all = 0;
				let allJin = role_mgr.GetMainRoleVo().jin;
				let jin = viewData.ten_cost[0].style == 1;

				if (jin) {
					all = allJin;
				} else {
					all = goods_model.GetTypeGoodsNum(type_id);
				}

				if (all < viewData.ten_cost[0].count) {
					if (jin) {
						local_Message.show("勾玉不足");
						local_OpenFun.OpenFunHandler(21);
					} else {
						if (!this._model.cost_alert) {
							let cost = viewData.ten_cost[0].count - all;

							let str =
								`是否花费
							<font color='#639c12'>${cost}</font>
							勾玉购买
							<font color='#639c12'>${cost}</font>
							个
							<font color='#639c12'>幸运币</font>`;

							local_Alert.Show(str, Alert_Type.AlertTypeCheckBox, () => {
								if (allJin < cost) {
									local_OpenFun.OpenFunHandler(21)
								} else {
									buy_fun()
								}
							}, null, "确定", "取消", null, false, (bool?) => {
								this._model.cost_alert = bool
							}
								, "本次登录不再提示");

						} else {
							buy_fun();
						}
					}
				} else {
					buy_fun();
				}

			}, this, true);


			Util.AddClickEvent(this._img_all, () => {
				this._model.Fire(local_CompeteListEvent.OPEN_VIEW, "CompetelistRewardView", this._type, this._sub_type)
			}, this, true);

			this.BindEvent(this._model, local_CompeteListEvent.UPDATE_RANK_DATA, () => {
				this.initRank();
			});

			this.BindEvent(this._model, local_CompeteListEvent.UPDATE_VIEW_DATA, () => {
				let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type]
				if (viewData) {
					//积分
					this._lb_integral.text = viewData.today_score;
					//一次
					let one_text = ''
					if (viewData.cost[0].style == 1) {
						one_text = viewData.cost[0].count + '';
						this.oneRedImg.visible = false;

					} else {
						let num = goods_model.GetTypeGoodsNum(viewData.cost[0].typeId)
						one_text = num + '/' + viewData.cost[0].count;
						this.oneRedImg.visible = num >= viewData.cost[0].count;
					}
					this._lb_one.text = one_text;
					//十次
					let ten_text = ''
					if (viewData.ten_cost[0].style == 1) {
						ten_text = viewData.ten_cost[0].count + '';
						this.tenRedImg.visible = false;
					} else {
						let num = goods_model.GetTypeGoodsNum(viewData.ten_cost[0].typeId)
						ten_text = num + '/' + viewData.ten_cost[0].count
						this.tenRedImg.visible = num >= viewData.ten_cost[0].count;
					}
					this._lb_ten.text = ten_text
					// 进度条
					this.updateBar();

				}
				if (this._first) {
					this.updateView();
					this._first = false;
				}
			}
			);

			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type]
				if (viewData) {
					let cost = viewData.cost[0];
					let ten_cost = viewData.ten_cost[0];
					let type_id = cost.typeId
					for (let _tmpi in goods_list) {
						var goods = goods_list[_tmpi]
						if (goods.type_id == type_id) {
							let num = goods_model.GetTypeGoodsNum(type_id)
							let one_text = num + '/' + cost.count;
							this._lb_one.text = one_text;
							let ten_text = num + '/' + ten_cost.count;
							this._lb_ten.text = ten_text;
							this.tenRedImg.visible = num >= ten_cost.count;
							this.oneRedImg.visible = num >= cost.count;
						}
					}

				}
			}
			);
		}

		this.Local_DeleteMe = () => {
			this.removeTimer();

			if (this._arrayCollection) {
				this._arrayCollection.DeleteMe();
				this._arrayCollection = null;
			}

			for (let key in this.item_list) {
				let item = this.item_list[key];
				item.DeleteMe();
			}
			this.item_list = [];

			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id);
				this.tween_id = null;
			}

			this._first = true;
			super.DeleteMe();
		}

		this.LoadSuccess = () => {
			// this._Label6.lineSpacing = 1
			// if (PlatformManager.IsEyouEnPlatform()) {
			// 	this._Label6.lineSpacing = 0.8
			// }
			// this.cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
			// this.RegisterMask(this._Viewport1)
			// this.parent_mask = GetWorldCorners(this._Viewport1)
			// this.mask_item_mat = new Material(ShaderTools.GetShader("UI-Default_mask"))
			ResManager.GetInstance().SetOutsideImageSprite(
				this,
				this._Image11,
				GameResPath.GetIconOtherPath('competelist', 'ui_phb_17')
			);
			ResManager.GetInstance().SetOutsideImageSprite(
				this,
				this.barImg,
				GameResPath.GetIconOtherPath('competelist', 'ui_sm_021')
			);
			ResManager.GetInstance().SetOutsideImageSprite(
				this,
				this._progress_bg,
				GameResPath.GetIconOtherPath('competelist', 'ui_sm_021')
			);
			ResManager.GetInstance().SetOutsideImageSprite(
				this,
				this._progress,
				GameResPath.GetIconOtherPath('competelist', 'ui_sm_021_1')
			);

			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientCompetelistSkill", true);
			let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientConfigRaceActRewardShow", true);

			if (!cfg || !cfg1) {
				return;
			}

			this.config_skill = cfg;
			this.confShow = cfg1;
			this._model.Fire(local_CompeteListEvent.REQUEST_PROTO, 33801, "hh", this._type, this._sub_type);
		}

		this.updateView = () => {
			this._Width = this._progress.width;
			if (this._type == 1) {	   //坐骑竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_004"), true)
			} else if (this._type == 2) {//伙伴竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_006"), true)
			} else if (this._type == 3) {//套装竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_006_1"), true)
			} else if (this._type == 4) {//宝宝竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_005"), true)
			} else if (this._type == 9) {//降神竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_003"), true)
			} else if (this._type == 10) {//翅膀竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_002"), true)
			} else if (this._type == 11) {//使魔竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "ui_sm_001"), true)
			} else if (this._type == 12) {//背饰竞榜
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("competelist", "uijb_t12"), true)
			}

			if (this.use_delete_method) {
				ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode);
				return;
			}

			this._model.initIntegral();
			this._model.initRank();
			this._model.initReward();
			this._model.Fire(local_CompeteListEvent.REQUEST_PROTO, 33802, "hh", this._type, this._sub_type)
			this.initView();
			this.initIntegral();
		}

		this.initView = () => {
			let openData = this._model.CompeteOpenActive && this._model.CompeteOpenActive[this._type + "@" + this._sub_type]
			if (openData) {
				this._lb_end_time.text = Util.StrToHTML("竞榜活动将于最后一天<font color=" + Enum_ColorUtil_Light.GREEN + ">" + this._model.timeFormat(openData.buy_end_time) + "</font>进行结算"
				);
				this.end_time = openData.buy_end_time;
			}
			if (!this._timer) {
				this._timer = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer();
				}, 1, -1);
			}
			this.onTimer();

			let conf: any = this.confShow[this._type + "@" + this._sub_type];
			this._model_group.visible = conf.icon_type == 2;
			this._img.visible = conf.icon_type == 1;
			switch (conf.icon_type) {
				case '1': // 图片
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetIcon('competelist', conf.resource_id));

					// if (reward_show[3]) {
					// 	let scale_x = Number(reward_show[3]) / 100
					// 	SetLocalScaleX(this._img, scale_x)
					// }
					// if (reward_show[4]) {
					// 	let scale_y = Number(reward_show[4]) / 100
					// 	SetLocalScaleY(this._img, scale_y)
					// }

					if (!this.tween_id) {
						this.tween_id = SYTweenLite.to(this, this._img, SYTweenLite.UiAnimationType.ANCHORED_POSY, this._img.y - 30, 2, null, SYTweenFunc.PINGPONG, true)
					}
					break;
				case '2': // 模型
					this.res_id = conf.resource_id;
					this.CreateModel(this.res_id);
					break;
				// case '3': // 特效
				// 	break;
				default:
					break;
			}

			let skillid = this.GetRewardShowDic()["skill"];
			let info = this.config_skill[Number(skillid)];
			if (info) {
				this._lb_skill_desc.style.fontSize = this._lb_skill_desc2.style.fontSize = 20;
				this._lb_skill_desc.style.color = this._lb_skill_desc2.style.color = '#663915';
				this._lb_skill_desc.style.align = this._lb_skill_desc2.style.align = "center";
				this._lb_skill_desc.width = this._lb_skill_desc2.width = 220;

				if (info?.desc2) {
					this._lb_skill_name.text = info.name;
					this._lb_skill_desc.innerHTML = info.desc1;
					this._lb_skill_desc2.innerHTML = info.desc2;
				} else {
					this._lb_skill_name.text = info.name;
					this._lb_skill_desc.innerHTML = info.desc1;
				}
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill, "resource/game/skillIcon/" + skillid + ".png")
			}

			let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type];
			if (info && viewData) {
				this._lb_integral.text = viewData.today_score;
				this.updateBar();
			}

			// this._img_discount.visible = this._type == 4 && this._sub_type == 1   //宝宝竞榜
		}

		this.onTimer = () => {
			if (this.end_time >= TimeUtil.getServerTime()) {
				this._lb_time.text = TimeUtil.timeConvert(this.end_time - TimeUtil.getServerTime(), 'hh-mm-ss');
			} else {
				this._lb_time.color = Color(255 / 255, 79 / 255, 80 / 255, 1)
				this._lb_time.text = "已结束"
				this.removeTimer();
			}
		}

		this.removeTimer = () => {
			if (this._timer) {
				GlobalTimerQuest.CancelQuest(this._timer)
				this._timer = null
				this.end_time = 0
			}
		}

		this.initRank = () => {
			let rankdata = this._model.CompeteRankData[this._type + "@" + this._sub_type];
			let score = rankdata && rankdata.score && rankdata.score || 0;

			this._lb_rank.style.fontSize = 20;
			this._lb_rank.style.color = '#5A1C20';
			this._lb_rank.style.align = "center";
			this._lb_rank.width = 145;
			if (rankdata && rankdata.rank != 0) {
				this._lb_rank.innerHTML = Util.StrToHTML("第" + rankdata.rank + "名(<font color='#00BF00'>" + score + "</font>积分)")
			} else {
				this._lb_rank.innerHTML = Util.StrToHTML("未上榜(<font color='#00BF00'>" + score + "</font>积分)")
			}
			let data = this._model.getRankList(this._type, this._sub_type);
			if (data) {
				if (!this._arrayCollection) {
					this._arrayCollection = new LoopScrowViewMgr()
					this._arrayCollection.SetData(this._Scroller1, CompetelistRankItem, data, LoopScrCon.Vertical);
				} else {
					this._arrayCollection.replaceAll(data)
				}
			}
		}

		this.initIntegral = () => {
			let list = this._model.getIntegralList(this._type, this._sub_type);
			let index = this._model.IntegralIndex(this._type, this._sub_type);
			if (list) {
				table.sort(list, (a?, b?) => {
					return a.reward_id < b.reward_id;
				})

				let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type];
				for (let i = 0; i < list.length; i++) {
					let data = list[i];
					let _item = this.item_list[i];
					if (!_item) {
						_item = new CompetelistIntegralItem(this._gp_reward);
						_item.Load();
						table.insert(this.item_list, _item);
						_item.setIndex(i);
					}
					_item.setData(data, this._type, this._sub_type);
				}

				// this._max = list[this.item_list].need_val
				if (viewData) {
					{
						//一次抽奖
						let one_text = ''
						let cost = viewData.cost[0];
						if (cost.style == 1) {
							one_text = cost.count + '';
							this.oneRedImg.visible = false;
						} else {
							let num = goods_model.GetTypeGoodsNum(cost.typeId);
							one_text = num + '/' + cost.count;
							this.oneRedImg.visible = num >= cost.count;
						}
						this._lb_one.text = one_text
						let goods_vo = goods_model.GetGoodsBasicByTypeId(cost.typeId);
						if (goods_vo) {
							ResManager.GetInstance().SetOutsideImageSprite(this, this._img_one, "resource/game/goodsIcon/" + goods_vo.goods_icon + ".png");
						}
					};
					// LayoutRebuilder(this._Group5)

					{
						//十次抽奖
						let ten_text = ''
						let cost = viewData.ten_cost[0];
						if (cost.style == 1) {
							ten_text = cost.count + '';
							this.tenRedImg.visible = false;
						} else {
							let num = goods_model.GetTypeGoodsNum(cost.typeId)
							ten_text = num + '/' + cost.count;
							this.tenRedImg.visible = num >= cost.count;
						}
						this._lb_ten.text = ten_text;
						let goods_vo = goods_model.GetGoodsBasicByTypeId(cost.typeId);
						if (goods_vo) {
							ResManager.GetInstance().SetOutsideImageSprite(this, this._img_ten, "resource/game/goodsIcon/" + goods_vo.goods_icon + ".png");
						}
					};

					// LayoutRebuilder(this._Group6)
				}

				//积分奖励定位
				// let layer = this._gp_reward;
				// let itemWidth = (this._gp_reward.co - (this._gp_reward.numElements - 1) * layer.spacing) / this._gp_reward.numElements;
				// let itemWidth = CompetelistIntegralItem.width
				// let preWidth = itemWidth + layer.spacing
				// this.preWidth = preWidth
				// let scrWidth = this._Viewport2.rect.width
				// let contentWidth = preWidth * list.length - layer.spacing
				// let maxWidth = contentWidth - scrWidth

				// SetSizeDeltaX(this._Content2, contentWidth);
				// SetSizeDeltaX(this._progress_bg, contentWidth);

				// if (index != null) {
				// 	let scrollH = Mathf.Min(preWidth * local_Number(index), maxWidth)
				// 	this.Scr_Scroller2.horizontalNormalizedPosition = scrollH / maxWidth
				// }

				this.updateBar();
			}
		}

		this.updateBar = () => {

			// 因为进度不规则所以写死
			let barWs: number[] = [30, 140, 250, 355, 465, 575, 685, 795, 900, 980];
			let viewData = this._model.CompeteViewData[this._type + "@" + this._sub_type];
			let list = this._model.getIntegralList(this._type, this._sub_type);
			let index = -1;

			if (list) {
				for (let i = list.length - 1; i >= 0; i--) {
					const element = list[i];
					if (viewData.today_score >= element.need_val) {
						index = i;
						break;
					}
				}
				this._progress.width = index > 0 ? barWs[index] : 0;
			} else {
				this._progress.width = 0;
			}

		}

		this.CreateModel = (res_id?) => {
			this.ClearModel();
			CustomActivityModel.GetInstance().ShowViewModel(this, this.layout_file, JSON.parse(res_id), this._model_group, null, null, this.cur_sorting_order, null, null, true)
		}


		this.ClearModel = () => {
			ResManager.GetInstance().ClearRoleMode(this.$hashCode);
		}

	}

	public DeleteMe() {
		this.Local_DeleteMe()
	}

	public GetRewardShowDic() {
		if (!this._reward_show_dic) {
			this._reward_show_dic = [];
			let act = this._model.confRaceActInfo[this._type + "@" + this._sub_type];
			let reward_show_list = JSON.parse(act.others);
			for (let key in reward_show_list) {
				let reward_show = reward_show_list[key];
				this._reward_show_dic[reward_show[0]] = reward_show[1];
			}
		}
		return this._reward_show_dic
	}


	_Image1: Laya.Image
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_lb_time: Laya.Label
	_img_title: Laya.Image
	_gp_skill: Laya.Box
	_img_skill: Laya.Image
	_lb_skill_name: Laya.Label
	_lb_skill_desc: Laya.HTMLDivElement
	_lb_skill_desc2: Laya.HTMLDivElement
	_model_group: Laya.Box
	_gp_fight: Laya.HBox
	_img: Laya.Image
	_Image2: Laya.Image
	_Group2: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	_Image4: Laya.Image
	_Label3: Laya.Label
	_Image5: Laya.Image
	_Label4: Laya.Label
	_Image6: Laya.Image
	_Label5: Laya.Label
	_Scroller1: Laya.List
	_Group3: Laya.Box
	_Image7: Laya.Image
	_Image8: Laya.Image
	_lb_rank: Laya.HTMLDivElement
	_Group4: Laya.Box
	_Image9: Laya.Image
	_Image10: Laya.Image
	_lb_integral: Laya.Label
	_Group7: Laya.Box
	_Label7: Laya.Label
	_Label8: Laya.Label
	_btn_one: Laya.Box
	oneRedImg: Laya.Image
	_btn_ten: Laya.Box
	tenRedImg: Laya.Image
	_Group5: Laya.HBox
	_img_one: Laya.Image
	_lb_one: Laya.Label
	_Group6: Laya.HBox
	_img_ten: Laya.Image
	_lb_ten: Laya.Label
	_Image11: Laya.Image
	barImg: Laya.Image
	_Scroller2: Laya.Panel
	_Content2: Laya.Box
	_progress_bg: Laya.Image
	_progress: Laya.Image
	_gp_reward: Laya.HBox
	_img_discount: Laya.Image
	_lb_end_time: Laya.Label
	awardBox: Laya.Box
	_img_all: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this._Label1,
			this._lb_time,
			this._img_title,
			this._gp_skill,
			this._img_skill,
			this._lb_skill_name,
			this._lb_skill_desc,
			this._lb_skill_desc2,
			this._model_group,
			this._gp_fight,
			this._img,
			this._Image2,
			this._Group2,
			this._Image3,
			this._Label2,
			this._Image4,
			this._Label3,
			this._Image5,
			this._Label4,
			this._Image6,
			this._Label5,
			this._Scroller1,
			this._Group3,
			this._Image7,
			this._Image8,
			this._lb_rank,
			this._Group4,
			this._Image9,
			this._Image10,
			this._lb_integral,
			this._Group7,
			this._Label7,
			this._Label8,
			this._btn_one,
			this.oneRedImg,
			this._btn_ten,
			this.tenRedImg,
			this._Group5,
			this._img_one,
			this._lb_one,
			this._Group6,
			this._img_ten,
			this._lb_ten,
			this._Image11,
			this.barImg,
			this._Scroller2,
			this._Content2,
			this._progress_bg,
			this._progress,
			this._gp_reward,
			this._img_discount,
			this._lb_end_time,
			this.awardBox,
			this._img_all,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"_Label1",
				"_lb_time",
				"_img_title",
				"_gp_skill",
				"_img_skill",
				"_lb_skill_name",
				"_lb_skill_desc",
				"_lb_skill_desc2",
				"_model_group",
				"_gp_fight",
				"_img",
				"_Image2",
				"_Group2",
				"_Image3",
				"_Label2",
				"_Image4",
				"_Label3",
				"_Image5",
				"_Label4",
				"_Image6",
				"_Label5",
				"_Scroller1",
				"_Group3",
				"_Image7",
				"_Image8",
				"_lb_rank",
				"_Group4",
				"_Image9",
				"_Image10",
				"_lb_integral",
				"_Group7",
				"_Label7",
				"_Label8",
				"_btn_one",
				"oneRedImg",
				"_btn_ten",
				"tenRedImg",
				"_Group5",
				"_img_one",
				"_lb_one",
				"_Group6",
				"_img_ten",
				"_lb_ten",
				"_Image11",
				"barImg",
				"_Scroller2",
				"_Content2",
				"_progress_bg",
				"_progress",
				"_gp_reward",
				"_img_discount",
				"_lb_end_time",
				"awardBox",
				"_img_all",
			])
		this._Scroller2.hScrollBar.visible = false;

	}
}
window["CompetelistView"] = CompetelistView