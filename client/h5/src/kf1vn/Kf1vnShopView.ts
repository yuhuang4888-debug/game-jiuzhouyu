import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { HolyBattleRewardTabItem } from "../holyBattle/HolyBattleRewardTabItem"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Kf1vnQuizHistoryView } from "./Kf1vnQuizHistoryView"
import { Kf1vnShopExchangeView } from "./Kf1vnShopExchangeView"
import { Kf1vnTabItem } from "./Kf1vnTabItem"


export class Kf1vnShopView extends BaseView1 {

	InitEvent
	LoadSuccess
	Local_Open
	OpenCallback
	SwtichView
	back_login_close
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	open_callback
	use_background
	InitTab
	UpdateRedState
	select_index = 0
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnShopView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.change_scene_close = true
		let model = Kf1vnModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let cfg_finish_ = false
		let cur_index_ = -1
		let view_list_ = []
		let viewclass_list_ = [Kf1vnShopExchangeView, Kf1vnQuizHistoryView]
		this.preload_server_config={"config_kf_1vn_match":false,"config_kf_1vn_bet":false}
		let _tab_name_list = ["战印商店", "竞猜记录"]
		let _tab_data_list = null
		let _tab_arr = null
        let _default_index=0

		this.load_callback = () => {
			this.InitTab()
			this.LoadSuccess()
			this.InitEvent()

			if(_tab_arr){
				_tab_arr.SetSelectIndex(this.select_index)
			}
			//this.SwtichView(this.select_index, true)
			this.UpdateRedState()

		}

		this.open_callback = () => {
			//this.OpenCallback()
		}


		this.InitTab = () => {
			if (!_tab_data_list) {
				_tab_data_list = []
			}
			for (let key in _tab_name_list) {

				let obj = _tab_name_list[key]
				table.insert(_tab_data_list, {
					name: obj,
					red_state: false
				})
			}
			if (!_tab_arr) {
				_tab_arr = new LoopScrowViewMgr()
				_tab_arr.SetData(this._list_tab_con, Kf1vnTabItem, _tab_data_list, LoopScrCon.Horizontal, 1, (item?) => {
					this.SwtichView(item)
				})
			} else {
				_tab_arr.replaceAll(_tab_data_list)
			}

			_tab_arr.SetSelectIndex(cur_index_)

		}

		this.UpdateRedState=()=>{
			if(!_tab_data_list)return
			if(_tab_data_list!=null){
				for(let i=0;i<_tab_data_list.length;i++){
					if(i==0){
						//商店
						_tab_data_list[i].red_state=model.ShopRedDot()
					}else{
						//竞猜记录
						_tab_data_list[i].red_state=model.HaveQuizRewardCanGet()
					}
				}
			}

			if(_tab_arr)_tab_arr.replaceAll(_tab_data_list)
		}


		this.destroy_callback = () => {
			let len = viewclass_list_.length
			let i = 0
			do {
				let view = view_list_[i]
				if (view) {
					view.DeleteMe()
				}
				i = i + 1
			} while ((i < len))
			view_list_ = []
			cur_index_ = 0


			if (_tab_arr) {
				_tab_arr.DeleteMe()
				_tab_arr = null
			}
			_tab_data_list = null
		}

		this.LoadSuccess = () => {

		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true)
			this.BindVar(model, "quiz_history", (key?, value?) => {
				this.UpdateRedState()
			}
			)
			let update_shop_data = () => {
				this.UpdateRedState()
			}

			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, update_shop_data)
			this.BindEvent(goods_model, local_GoodsModel.UPDATE_SPECIAL_SCORE, update_shop_data)
		}


		this.Local_Open = (parms?) => {
			if (parms && parms.length > 0) {
				this.select_index = parms[0]
			}
		}

		this.OpenCallback = () => {
			// this.SwtichView(cur_index_, true)
			// this.UpdateRedState()
		}

		this.SwtichView = (index?) => {
			if (cur_index_ == index) {
				return
			}
			cur_index_ = index
			this.lb_title.text=_tab_name_list[index]
			if (cur_index_ == 0) {
				model.has_show_shop_dot = true
				model.Fire(Kf1vnEvent.KF1VN_UPDATE_RED_DOT)
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820)
			}

			let sub_view = view_list_[index]
			if (!sub_view) {
				let sub_view_class = viewclass_list_[index]
				if (sub_view_class) {
					sub_view = new sub_view_class(this.sub_conta)
					view_list_[index] = sub_view
				}
				if (sub_view) {
					sub_view.Load()
				}
			}
			if (sub_view) {
				this.PopUpChild(sub_view)
				sub_view.SetData()
			}
		}

	
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
		super.Open()
	}

	public DeleteMe() {
		super.DeleteMe()
	}


_Group3:Laya.Box
bg_img:Laya.Image
img_title:Laya.Image
lb_title:Laya.Label
sub_conta:Laya.Box
_list_tab_con:Laya.List
closeBtn:Laya.Box
btn_img:Laya.Image
public GetComponents() {
[
this._Group3,
this.bg_img,
this.img_title,
this.lb_title,
this.sub_conta,
this._list_tab_con,
this.closeBtn,
this.btn_img,
]
 = this.GetChildrenByNames([

"_Group3",
"bg_img",
"img_title",
"lb_title",
"sub_conta",
"_list_tab_con",
"closeBtn",
"btn_img",
])
}
}
 window["Kf1vnShopView"]= Kf1vnShopView