import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util, SetLocalPositionX } from "../util/Util"
import { Kf1vnRankItem } from "./Kf1vnRankItem"
import { Kf1vnTabItem } from "./Kf1vnTabItem"

export class Kf1vnRankView extends BaseView1 {
	InitEvent
	LoadSuccess
	Local_Open
	OpenCallback
	SetItemRender
	SwtichView
	back_login_close
	change_scene_close
	click_bg_toClose
	loop_loop_mgr
	open_callback
	InitTab
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnRankView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.change_scene_close = true
		let model = Kf1vnModel.GetInstance()
		let cfg_finish_ = false
		let item_list_ = null
		let array_collection_ = null
		let cur_index_ = 0
		let init_x_ = 0
		this.is_center = true

		this.preload_server_config={"config_kf_1vn_match":false}
		let _tab_name_list = ["资格赛", "擂台赛"]
		let _tab_data_list = null
		let _tab_arr = null
		let _default_index = 0


		this.load_callback = () => {
			
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			if (item_list_) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = null
			}
			cur_index_ = 0
			if (this.loop_loop_mgr) {
				this.loop_loop_mgr.DeleteMe()
				this.loop_loop_mgr = null
			}


			if (_tab_arr) {
				_tab_arr.DeleteMe()
				_tab_arr = null
			}
			_tab_data_list = null
		}

		this.LoadSuccess = () => {
			item_list_ = []
			init_x_ = this.label1.x
			this.InitTab()
			model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62110, "c", 0)
			model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62116, "c", 0)
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true)


			let vo_fun = (key?, value?) => {
				if (cur_index_ == 0) {
					this.SwtichView(0)
				}
			}
			this.BindVar(model, "ticket_rank_data", vo_fun)

			let leader_vo_fun = (key?, value?) => {
				if (cur_index_ == 1) {
					this.SwtichView(1)
				}
			}
			this.BindVar(model, "leader_rank_data", leader_vo_fun)


		}


		this.Local_Open = (parms?) => {
			if (parms && parms.length > 0) {
				cur_index_ = parms[0]
			}
			super.Open()
		}

		this.OpenCallback = () => {
			this.SwtichView(cur_index_)
		}

		this.SwtichView = (index?) => {
			cur_index_ = index
			this.label1.text = (index == 0 && ("积分") || ("战绩"))
			this.label0.visible = index == 0
			SetLocalPositionX(this.label1, index == 0 && init_x_ || (init_x_ - 40))
			if (model.page_info) {
				this.tips.text = "前" + model.page_info.def_num + "名玩家成为擂主人选"
			}
			this.tips.visible = (index == 0 && model.page_info && model.page_info.def_num > 0)
			let data = []
			if (index == 0) {
				data = model.ticket_rank_data && model.ticket_rank_data.rank_1_list || []
			} else {
				data = model.GetLeaderRankDara()
			}
			this.SetItemRender(data)
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

		this.SetItemRender = (list?) => {
			this.none_conta.visible = !(list.length > 0)
			if (!this.loop_loop_mgr) {
				this.loop_loop_mgr = new LoopScrowViewMgr()
				this.loop_loop_mgr.SetData(this.Content, Kf1vnRankItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_loop_mgr.replaceAll(list)
			}
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}



bg_img:Laya.Image
img_title:Laya.Image
lb_title:Laya.Label
closeBtn:Laya.Box
btn_img:Laya.Image
bg:Laya.Image
_bg_222:Laya.Image
_Group1:Laya.Box
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
label0:Laya.Label
label1:Laya.Label
Content:Laya.List
_list_tab_con:Laya.List
tips:Laya.Label
none_conta:Laya.Box
tips_icon0:Laya.Image
tips0:Laya.Label
public GetComponents() {
[
this.bg_img,
this.img_title,
this.lb_title,
this.closeBtn,
this.btn_img,
this.bg,
this._bg_222,
this._Group1,
this._Label1,
this._Label2,
this._Label3,
this.label0,
this.label1,
this.Content,
this._list_tab_con,
this.tips,
this.none_conta,
this.tips_icon0,
this.tips0,
]
 = this.GetChildrenByNames([

"bg_img",
"img_title",
"lb_title",
"closeBtn",
"btn_img",
"bg",
"_bg_222",
"_Group1",
"_Label1",
"_Label2",
"_Label3",
"label0",
"label1",
"Content",
"_list_tab_con",
"tips",
"none_conta",
"tips_icon0",
"tips0",
])
}
}
 window["Kf1vnRankView"]= Kf1vnRankView