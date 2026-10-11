import { attributePotionModel } from "../commonModel/attributePotionModel"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { attributePotionProgressBar } from "./attributePotionProgressBar"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UIEffect } from "../common/UIEffect"
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager"
import { EventName } from "../common/EventName"
import { Message } from "../sysInfo/SysInfoController"
import { SpecialCharKey } from "../common/SpecialCharKey"

export class attributePotionItem extends BaseItemRenderer {
	public _Image11: Laya.Image;
	public _gp_reward: Laya.Box;
	public effBox: Laya.Box;
	public _lb_name: Laya.Label;
	public _Scroller1: Laya.Box;
	public _Group1: Laya.Image;
	public _lb_attr: Laya.Label;
	public _btn_use: Laya.Box;
	public _Image1: Laya.Image;
	public labelDisplay1: Laya.Label;
	public pbox: Laya.Box;
	public _red_dot: Laya.Image;



	_Image2
	_Width
	_item
	_model: attributePotionModel
	_nowData
	canUseNum
	click_time
	full
	labelDisplay
	num
	thumb
	timeConfig
	pb
	//zcs
	layer_value
	mask_id
	//zcs
	public WIDTH = 613
	public HEIGT = 130

	private effect: UIEffect;

	public constructor(parent) {
		super()


		this._Width = 0;
		this.num = 0;
		this.canUseNum = 0;
		this.timeConfig = 0;
		this.full = false;
		this.base_file = "attributePotion"
		this.layout_file = "attributePotionItem"
		this._model = attributePotionModel.GetInstance()
		this.click_time = 0
		this.effect = new UIEffect();
		this.Load()


		//lua_resM:SetOutsideImageSprite(this, this._line, GameResPath.GetIcon("attributePotion","uity_064"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, GameResPath.GetIcon("attributePotion", "uimb_am_017"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.thumb, GameResPath.GetIcon("attributePotion", "uimb_am_018"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("attributePotion", "uitc_007"))

	}

	public createChildren() {
		super.createChildren()
	}


	public load_callback() {
		this.initEvents();
	}

	private initEvents() {

		// 点击使用
		Util.AddClickEvent(this._btn_use, () => {
			// if (this.click_time == 0 || TimeUtil.getServerTime() - this.click_time > 0.3) {
			// 	this.FuncFirstOpenClick()
			// 	this._model.useAttribute(this.data.good_id)
			// 	this.click_time = TimeUtil.getServerTime()
			// }
			if(this.num==0){
				Message.show("道具不足")
				return
			}
			this.click_time = TimeUtil.getServerTime()
			this.FuncFirstOpenClick()
			this._model.useAttribute(this.data.good_id)
		}, this, true);

		// 使用
		this.BindEvent(this._model, attributePotionModel.REQUEST_USE, (good_id?, num?, lv?) => {
			if (good_id == this.data?.good_id) {
				this.effBox.visible = true;
				this.effect.AddUIEffect("QiangHua", this.effBox, { x: -1, y: -1 }, 7, false, 0.5, () => {
					this.effBox.visible = false;
				});
			} else {
				if (this.effect) {
					this.effect.ClearUIEffect(this.effBox)
				}
			}
		})
	}

	public dataChanged() {
		/////GlobalEventSystem.Fire(ServerTimeModel.DAY_CHANGE)
		if (super.dataChanged()) {
			this.UpdateFuncFirstState()
			let good_id = this.data.good_id
			this._lb_name.text = GoodsModel.GetGoodsName(good_id)
			if (!this._item) {
				this._item = new BaseAwardItem(this._gp_reward, null, this.layer_value)
				//this._item.SetMaskId(this.mask_id || 1)
				this._item.Load()
				this._item.SetScale(0.8)
			}
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(good_id)
			this.num = GoodsModel.GetInstance().GetTypeGoodsNum(good_id)
			if (goods_vo) {
				this._item.SetData(good_id, this.num)
				let color = ColorUtil.GetColorDark(goods_vo.color).toString()
				color = color.replace(SpecialCharKey.attributePotionItem1, "")
				color = color.replace(SpecialCharKey.attributePotionItem1, "")
				this._lb_name.color = color
			}
			this.updateProgressBar()
		}
	}

	public updateProgressBar() {

		let timeData = this._model.getTimeDataById(this.data.lv, this.data.good_id)
		if (!timeData) {
			return
		}

		if (this._nowData && this._nowData != this.data) {
			this.pb.setWidth(0);
		} else {
			this.pb.setWidth(300);
		}

		this._nowData = this.data
		let timeConfig = this._model.getTimeConfig(this.data.good_id)
		if (timeConfig) {
			// this.thumb.fillAmount = timeData.current_count / timeConfig.all_times
			this.pb.setMax(timeConfig.all_times);
			// this._progressBar.maximum = 20;
			this.pb.setValue(timeData.current_count);
			// this.labelDisplay.text = String(timeData.current_count) + "/" + String(timeConfig.all_times)
			let lessTime = timeConfig.all_times - timeData.current_count
			this.full = lessTime == 0
			if (lessTime > 0) {
				this.canUseNum = timeConfig.day_times - timeData.current_day_count
				// [ts2lua]lua中0和空字符串也是true，此处this.canUseNum > lessTime需要确认
				this.canUseNum = this.canUseNum > lessTime && lessTime || this.canUseNum
			}
		}


		let Properties = ""
		let attr_list = JSON.parse(this.data.attr_list);
		for (let key in attr_list) {

			if (attr_list[key]) {
				// [ts2lua]attr_list下标访问可能不正确
				let attr = attr_list[key]
				//Properties = Properties + WordManager.GetProperties(attr[0]) + (" + ") + Number(attr[1]) * timeData.current_count + " "
				Properties = Properties + WordManager.GetProperties(attr[0]) + (" + ") + Number(attr[1]) * timeData.current_count + " "
			}
		}
		this._lb_attr.text = Properties
		this._red_dot.visible = this._model.itemRedDot(this.data.lv, this.data.good_id)

	}

	public FuncFirstOpenClick() {
		if (this.has_set_func_first_state) {
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.AddStep(FuncFirstOpenKey.Potion)
			this.ClearFuncFirst()
		}
	}


	has_set_func_first_state
	public UpdateFuncFirstState() {
		let func_first_mgr = FuncFirstOpenManager.GetInstance()
		if (this.CheckFuncFirstValue() && !func_first_mgr.CheckFuncFirstOpenState(FuncFirstOpenKey.Potion)) {
			func_first_mgr.AddStepSprite(FuncFirstOpenKey.Potion, 1, this._btn_use)
			func_first_mgr.UpdateStepState(FuncFirstOpenKey.Potion)
			this.has_set_func_first_state = true
		}
		else {
			this.ClearFuncFirst()
		}
	}

	//当前数据源是否是需要引导的那条数据
	public CheckFuncFirstValue() {
		return this.index == 0
	}

	public ClearFuncFirst() {
		if (this.has_set_func_first_state) {
			this.has_set_func_first_state = false
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.ClearStepSprite(FuncFirstOpenKey.Potion, 1)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._btn_use)
		}
	}

	public DeleteMe() {
		this.ClearFuncFirst()
		if (this.pb) {
			this.pb.DeleteMe()
		}
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		this.click_time = 0;
		this.effect.ClearUIEffect(this.effBox);
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._Image11,
			this._gp_reward,
			this.effBox,
			this._lb_name,
			this._Scroller1,
			this._Group1,
			this._lb_attr,
			this._btn_use,
			this._Image1,
			this.labelDisplay1,
			this._red_dot,
			this.pbox
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_gp_reward",
				"effBox",
				"_lb_name",
				"_Scroller1",
				"_Group1",
				"_lb_attr",
				"_btn_use",
				"_Image1",
				"labelDisplay1",
				"_red_dot",
				"pbox"
			])



		this.pb = new attributePotionProgressBar(this.pbox)
		this.pb.Load()

	}
}
window["attributePotionItem"] = attributePotionItem