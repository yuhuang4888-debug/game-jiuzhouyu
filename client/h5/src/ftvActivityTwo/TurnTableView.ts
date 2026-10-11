import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { TurnTableModel, TurnTableModelEvent } from "../commonModel/TurnTableModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { TurnTableRecordItem } from "./TurnTableRecordItem"
import { TurnTableRewardItem } from "./TurnTableRewardItem"

export class TurnTableView extends BaseItem1 {
	Content
	CustomMehod
	Emp_btn
	Emp_btn_pay
	Out_Label2
	Out_Label3
	Out_lb_cost
	OutlabelDisplay
	OutlabelDisplay1
	Scr_scroller
	_img
	_list
	loop_mgr
	updateMsg

	private _type_ = null;
	private _sub_type_ = null;
	private show_id_ = null;
	private timer_ = null;
	private ani_list = [];
	private click_time_: number = 0;
	private endTime_: number = 0;
	private running_: boolean = false;
	private skip_: boolean = false;
	private rewarditemlist_ = [];
	private time_id: number = 0


	public constructor(parent?) {
		super(parent)
		this.base_file = "turntable";
		this.layout_file = "TurnTableView";
		this.layer_value = Enum_UILayer.Activity;
		let _model = TurnTableModel.GetInstance();
		this.load_callback = () => {
			// if (PlatformMgr.GetInstance().IsEyouPlatform()) {
			// 	this.Text2.lineSpacing = 1
			// }
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	SetSizeDelta(this.Text, 10, 100)
			// 	this._Label1.size = 18
			// 	SetAnchoredPositionX(this._Label1, -13)
			// }
			this.InitEvent();
			this.LoadSuccess();
		};

		this.CustomMehod = (index?, args?) => {
			if (this._type_ == null) {
				this._type_ = args.base_type;
				this._sub_type_ = args.sub_type;
				this.show_id_ = args.show_id;
			}
		}

		this.updateMsg = () => {
			let data = _model.getTurnTableData(this._type_, this._sub_type_);
			if (data) {
				let bool = data.ticket_num > 0;
				this._btn.visible = bool;
				this._red_dot.visible = bool;
				this._btn_pay.visible = !bool;
				this._lb_times.text = data.total_left_tickets + '次';
				this._lb_times1.text = data.ticket_num;
				// [ts2lua]lua中0和空字符串也是true，此处data.total_left_tickets > 0需要确认
				let str = data.total_left_tickets > 0 && "当天剩余可抽奖次数<font color='0xc4ff37'>" + data.total_left_tickets + "次</font>" || "已达抽奖上限";
				// [ts2lua]lua中0和空字符串也是true，此处data.total_left_tickets == 0需要确认
				this.labelDisplay1.text = data.total_left_tickets == 0 && "已完成" || "充点小钱";
				this._gp_cost.visible = data.need_gold != 0;
				if (this._gp_cost.visible) {
					this._lb_cost.text = (data.need_gold / 10) + '元';
				}

				if (!bool) {
					CustomActivityModel.GetInstance().CloseACTRed(this._type_, this._sub_type_);
				}
			}
			// LayoutRebuilder(this._gp_cost)
			//LayoutRebuilder(this._Group8)
		}
	}


	private InitEvent() {
		Util.AddClickEvent(this._btn, () => {
			if (this.running_) {
				return
			}
			if (this.click_time_ && TimeUtil.getServerTimeMs() - this.click_time_ < 500) {
				return
			}
			this.click_time_ = TimeUtil.getServerTimeMs();
			CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33131, this._type_, this._sub_type_);
		}, this, true);

		Util.AddClickEvent(this.check, () => {
			this.skip_ = !this.skip_
			this.select.visible = this.skip_
			//let source = skip_ && "com_ui_gx1" || "com_ui_gx"
			//lua_resM:SetImageSprite(this,this.check,"common_asset", source)
		}, this, false);

		Util.AddClickEvent(this._btn_pay, () => {
			let data = TurnTableModel.GetInstance().getTurnTableData(this._type_, this._sub_type_);
			if (data && data.total_left_tickets <= 0) {
				Message.show("已达今日上限");
			} else {
				OpenFun.OpenFunHandler(21);
			}
		}, this, true);

		this.BindEvent(TurnTableModel.GetInstance(), TurnTableModelEvent.START_RETURN, (bigIndex?, smallIndex?) => {
			this.running_ = true
			this.showRatation(bigIndex, smallIndex);
			this.updateMsg();
		});

		this.BindEvent(TurnTableModel.GetInstance(), TurnTableModelEvent.DATA_RETURN, () => {
			this.updateMsg();
		});
	}

	private LoadSuccess() {
		// this.Text.lineSpacing = 1
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
		// 	this.Text.lineSpacing = 0.7
		// }

		ResManager.GetInstance().SetOutsideImageSprite(
			this,
			this._table_bg,
			GameResPath.GetIcon('turntable', 'uibz_018'), false
		);
		ResManager.GetInstance().SetOutsideImageSprite(
			this,
			this.bgImg2,
			GameResPath.GetIcon('turntable', 'uibz_021'), false
		);
		ResManager.GetInstance().SetOutsideImageSprite(
			this,
			this._Image16,
			GameResPath.GetIcon('turntable', 'uibz_019'), false
		);
		ResManager.GetInstance().SetOutsideImageSprite(
			this,
			this.bgImg3,
			GameResPath.GetIcon('turntable', 'uibz_020'), false
		);
		ResManager.GetInstance().SetOutsideImageSprite(
			this,
			this.bgImg1,
			GameResPath.GetIcon('turntable', 'uibz_025'), false
		);

		// let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
		// if (cfg) {
		// 	// custom_activity_model.LoadCompontRes(this, cfg, "TurnTableView", show_id_)
		// }
		this.initRecord();
		this.initRewardItem();
	}


	private LocalDeleteMe() {
		if (this.timer_) {
			this.timer_.DeleteMe();
		}
		if (this.rewarditemlist_) {
			for (let key in this.rewarditemlist_) {
				// [ts2lua]rewarditemlist_下标访问可能不正确
				let _item = this.rewarditemlist_[key];
				_item.DeleteMe();
			}
			this.rewarditemlist_ = [];
		}
		if (this.ani_list && this.ani_list.length > 0) {
			for (let i = 0; i < this.ani_list.length; i++) {
				var v = this.ani_list[i]
				SYTweenLite.Stop(v);
			}
			this.ani_list = [];
		}
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe();
			this.loop_mgr = null;
		}
		this.StopTimer();
		super.DeleteMe();
	}


	private initRecord() {
		let data = TurnTableModel.GetInstance().getRecordData(this._type_, this._sub_type_);
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr();
			this.loop_mgr.SetData(this._scroller, TurnTableRecordItem, data, LoopScrCon.Vertical);
		} else {
			this.loop_mgr.replaceAll(data);
		}
	}

	private initRewardItem() {
		let data = TurnTableModel.GetInstance().getTurnTableData(this._type_, this._sub_type_);
		if (data) {
			let i = 0;
			do {
				let _gp = this._gp_item.getChildAt(i);
				let info = data.reward_list[i];
				let _item: TurnTableRewardItem = this.rewarditemlist_[i];
				if (!_item) {
					_item = new TurnTableRewardItem(_gp);
					_item.Load();
					table.insert(this.rewarditemlist_, _item);
				}
				// _item.setRotation((360 * i + 180) / this._gp_item.numChildren);
				_item.setData(info.goods_id, info.goods_num);
				i = i + 1
			} while (i < data.reward_list.length);

			// let j = 0;
			// do {
			// 	let num_img = this._gp_num.getChildAt(j);
			// 	let times = data.n_times_list[j].n_times;
			// 	ResManager.GetInstance().SetImageSprite(this, num_img, "turntable", "uibz_" + times, true);
			// 	j = j + 1
			// } while (j < data.n_times_list.length);
		}
		let act = CustomActivityModel.GetInstance().GetActInfo(this._type_, this._sub_type_)
		if (act) {
			// this.timer_ = CustomActivityModel.GetInstance().LoadActTimer(this._gp_time, act.etime, 20, '#5FF641', null, '#FFFFFF', "活动剩余时间：")
			this.StartTimer();
			this.updateMsg();
		}
	}

	/**
	 * 倒计时
	 */
	public StartTimer() {
		let act = CustomActivityModel.GetInstance().GetActInfo(this._type_, this._sub_type_)
		this.StopTimer();
		let loop_func = () => {
			let left_time = act.etime - TimeUtil.getServerTime()
			if (left_time <= 0) {
				this.StopTimer();
				this._gp_time.text = '已结束';
			} else {
				let time: string = TimeUtil.timeConvert(left_time, 'hh-mm-ss')
				this._gp_time.text = time;
			}
		}

		this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
		loop_func();
	}

	public StopTimer() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public showRatation(bigIndex: number, smallIndex: number) {
		if (this.skip_) {
			this.running_ = false;
			TurnTableModel.GetInstance().showReward();
			CustomActivityModel.GetInstance().ShowActFlyReward(TurnTableModel.GetInstance().fly_list,this._Image24)
			this.initRecord();
		} else {
			let bigRatation = Util.getRotationLong2(6, 0, 4, 6, bigIndex, 0);
			bigRatation = bigRatation - 30;
			let smallRatation = Util.getRotationLong2(6, 0, 6, 8, smallIndex - 3, -2);
			smallRatation = smallRatation - 30;
			TurnTableModel.GetInstance().Fire(TurnTableModelEvent.TURN_BIG_DOWN, bigRatation);

			// table.insert(this.ani_list, SYTweenLite.to(this, this._gp_big, SYTweenLite.UiAnimationType.ROTATION, bigRatation, 3, () => {
			// 	table.insert(this.ani_list, SYTweenLite.to(this, this._gp_small, SYTweenLite.UiAnimationType.ROTATION, smallRatation, 1.5, () => {
			// 		this.running_ = false;
			// 		TurnTableModel.GetInstance().showReward();
			// 		this.initRecord();
			// 	}, SYTweenFunc.EASE_OUT, false))
			// }, SYTweenFunc.EASE_OUT, false))


			let imgRotation = this._gp_big.rotation;
			let imgRotation2 = this._gp_small.rotation;
			this._gp_big.rotation = imgRotation % 360;
			this._gp_small.rotation = imgRotation2 % 360;
			Laya.Tween.to(this._gp_big, { rotation: bigRatation }, 3000, Laya.Ease.circOut, Laya.Handler.create(this, () => {
			}, null, true));
			Laya.Tween.to(this._gp_small, { rotation: smallRatation }, 4500, Laya.Ease.circOut, Laya.Handler.create(this, () => {
				this.running_ = false;
				TurnTableModel.GetInstance().showReward();
				CustomActivityModel.GetInstance().ShowActFlyReward(TurnTableModel.GetInstance().fly_list,this._Image24)
				this.initRecord();
			}, null, true));


		}
	}





	public DeleteMe() {
		this.LocalDeleteMe();
	}


	_gp_time: Laya.Label
	_lb_times: Laya.Label
	_gp_big: Laya.Box
	_table_bg: Laya.Image
	_table_bg1: Laya.Image
	_gp_item: Laya.Box
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Group4: Laya.Box
	_Group5: Laya.Box
	_Group6: Laya.Box
	_Group7: Laya.Box
	_gp_small: Laya.Box
	_Image16: Laya.Image
	_gp_num: Laya.Box
	_Image17: Laya.Image
	_Image18: Laya.Image
	_Image19: Laya.Image
	_Image20: Laya.Image
	_Image21: Laya.Image
	_Image22: Laya.Image
	_Image23: Laya.Image
	_Image24: Laya.Image
	_gp_cost: Laya.HBox
	_Label2: Laya.Label
	_lb_cost: Laya.Label
	_Label3: Laya.Label
	_btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_btn_pay: Laya.Box
	_Image1: Laya.Image
	_red_dot: Laya.Image
	labelDisplay1: Laya.Label
	_Label1: Laya.Label
	_lb_times1: Laya.Label
	check: Laya.Image
	select: Laya.Image
	bgImg2: Laya.Image
	bgImg3: Laya.Image
	bgImg1: Laya.Image
	_scroller: Laya.List
	public GetComponents() {
		[
			this._gp_time,
			this._lb_times,
			this._gp_big,
			this._table_bg,
			this._table_bg1,
			this._gp_item,
			this._Group2,
			this._Group3,
			this._Group4,
			this._Group5,
			this._Group6,
			this._Group7,
			this._gp_small,
			this._Image16,
			this._gp_num,
			this._Image17,
			this._Image18,
			this._Image19,
			this._Image20,
			this._Image21,
			this._Image22,
			this._Image23,
			this._Image24,
			this._gp_cost,
			this._Label2,
			this._lb_cost,
			this._Label3,
			this._btn,
			this._Image11,
			this.labelDisplay,
			this._btn_pay,
			this._Image1,
			this._red_dot,
			this.labelDisplay1,
			this._Label1,
			this._lb_times1,
			this.check,
			this.select,
			this.bgImg2,
			this.bgImg3,
			this.bgImg1,
			this._scroller,
		]
			= this.GetChildrenByNames([

				"_gp_time",
				"_lb_times",
				"_gp_big",
				"_table_bg",
				"_table_bg1",
				"_gp_item",
				"_Group2",
				"_Group3",
				"_Group4",
				"_Group5",
				"_Group6",
				"_Group7",
				"_gp_small",
				"_Image16",
				"_gp_num",
				"_Image17",
				"_Image18",
				"_Image19",
				"_Image20",
				"_Image21",
				"_Image22",
				"_Image23",
				"_Image24",
				"_gp_cost",
				"_Label2",
				"_lb_cost",
				"_Label3",
				"_btn",
				"_Image11",
				"labelDisplay",
				"_btn_pay",
				"_Image1",
				"_red_dot",
				"labelDisplay1",
				"_Label1",
				"_lb_times1",
				"check",
				"select",
				"bgImg2",
				"bgImg3",
				"bgImg1",
				"_scroller",
			])
	}
}
window["TurnTableView"] = TurnTableView