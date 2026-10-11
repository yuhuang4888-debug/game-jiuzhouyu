import { BaseView1 } from "../common/BaseView1";

export class FunctionOpenTipView2 extends BaseView1 {
	// public bg: eui.Image;
	// public icon: eui.Image;
	// public tips: eui.Label;
	// public scroll_group: eui.Group;
	// public _btn: eui.Button;

	// LoadSuccess
	// Local_Open
	// InitEvent
	// SetFuncIcon
	// public constructor() {
	// 	super();
	// 	this.base_file = "functionopen";
	// 	this.layout_file = "FunctionOpenTipViewExml";
	// 	this.layer_value = Enum_UILayer.Activity;
	// 	let model = FunctionOpenModel.getInstance(),
	// 		local_Util = Util,
	// 		res_mgr = ResManager.getInstance(),
	// 		local_GameResPath = GameResPath,
	// 		data_,
	// 		item_list_
	// 	this.is_center = true
	// 	this.use_background = true
	// 	this.click_bg_toClose = true
	// 	this.not_show_main_msg = true
	// 	this.load_callback = function () {
	// 		this.LoadSuccess();
	// 		this.InitEvent();
	// 	}
	// 	this.open_callback = function () {
	// 		this.SetFuncIcon()
	// 	}
	// 	this.destroy_callback = function () {
	// 		for (let obj of item_list_) {
	// 			obj.DeleteMe()
	// 		}
	// 		item_list_ = null
	// 	}
	// 	this.LoadSuccess = () => {
	// 		item_list_ = []
	// 	}

	// 	this.Local_Open = (parms) => {
	// 		[data_] = parms
	// 		super.Open()
	// 	}

	// 	this.InitEvent = () => {
	// 		local_Util.AddClickEvent(this._btn, () => {
	// 			this.Close();
	// 		}, this, true);
	// 	}

	// 	this.SetFuncIcon = () => {
	// 		if (data_) {
	// 			// this._btn.visible = data_.Foreshow;
	// 			if (data_.Foreshow) {
	// 				res_mgr.SetTexture(this, this.icon, local_GameResPath.GetDailyIconPath(data_.ac_icon))
	// 				this.tips.textFlow = local_Util.StrToHTML(data_.about)
	// 			} else {
	// 				res_mgr.SetTexture(this, this.icon, local_GameResPath.GetFuncOpenIconPath(data_.icon))
	// 				this.tips.textFlow = local_Util.StrToHTML(data_.desc)
	// 				let goods_list = JSON.parse(data_.reward)
	// 				if (goods_list) {
	// 					let item: BaseAwardItem
	// 					for (let i = 0; i < goods_list.length; i++) {
	// 						item = item_list_[i]
	// 						if (!item) {
	// 							item = new BaseAwardItem(this.scroll_group)
	// 							item_list_[i] = item
	// 							item.Load()
	// 							item.SetScale(0.66)
	// 						}
	// 						let [type_id, lock] = GoodsModel.getInstance().GetMappingTypeId(goods_list[i][0], goods_list[i][1])
	// 						item.SetData(type_id, goods_list[i][2])
	// 					}
	// 				}
	// 			}
	// 		}
	// 	}
	// }

	// public Open(...parms) {
	// 	this.Local_Open(parms)
	// }
}
window["FunctionOpenTipView2"] = FunctionOpenTipView2