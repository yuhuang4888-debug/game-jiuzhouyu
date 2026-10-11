import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, Color, SetHtmlStyle } from "../util/Util"
import { HolyBattleRecordItem } from "./HolyBattleRecordItem"
import { HolyBattleRewardTabItem } from "./HolyBattleRewardTabItem"

export class HolyBattleRecordView extends BaseView1 {
	InitEvent
	InitTab
	LoadSuccess
	Remove
	Scr_item_scr
	Scr_tab_scr
	SwitchTab
	UpdateRecordData
	UpdateView
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	preload_server_config
	show_open_movie
	use_background
	GetColor

	public constructor() {
		super()


		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleRecordView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true

		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()
		let local_HolyBattleModel = HolyBattleModel
		let local_RoleManager_Instance = RoleManager.GetInstance()
		let _tab_name_list = ["海尊", "天尊", "夜尊"]//["奥法", "幻异", "诡秘"]
		let _tab_data_list = null
		let _tab_arr = null
		let _item_array = null
		let _default_index = 0
		let _now_index_ = null

		this.preload_server_config = { "config_role_holy_spirit_battlefield_group": false }

		this.load_callback = () => {
			SetHtmlStyle(this._lb_score1,{f:20,c:"#663915",ww:false,w:143})
			SetHtmlStyle(this._lb_score2,{f:20,c:"#663915",ww:false,w:143})
			SetHtmlStyle(this._lb_score3,{f:20,c:"#663915",ww:false,w:143})
			SetHtmlStyle(this._lb_group_rank,{f:20,c:"#663915",ww:false,w:210})
			SetHtmlStyle(this._lb_group_score,{f:20,c:"#663915",ww:false,w:210})
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			this.InitTab()
			this.UpdateRecordData()
			this.InitEvent()
			local_HolyBattleModel_Instance.Fire(local_HolyBattleModel.REQUEST_PROTO, 21808)
		}

		this.InitTab = () => {
			if (!_tab_data_list) {
				_tab_data_list = []
			}
			for (let key in _tab_name_list) {

				let obj = _tab_name_list[key]
				table.insert(_tab_data_list, { name: obj, red_state: false })
			}

			
			if(!_tab_arr){
				_tab_arr = new LoopScrowViewMgr()
				_tab_arr.SetData(this._list_tab_con, HolyBattleRewardTabItem, _tab_data_list, LoopScrCon.Horizontal, 1, (item?) => {
					this.SwitchTab(item)
				})
			}else{
				_tab_arr.replaceAll(_tab_data_list)
			}

			_default_index = local_RoleManager_Instance.GetMainRoleVo().warGroup-1
			_tab_arr.SetSelectIndex(_default_index)
		}

		this.InitEvent = () => {
			//this._list_tab_con.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchTab, this)

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			this.BindEvent(local_HolyBattleModel_Instance, local_HolyBattleModel.UPDATE_RECORD_DATA, () => {
				this.UpdateRecordData()
				this.UpdateView()
			}
			)
		}

		this.SwitchTab = (index) => {

			if (_now_index_ == index) {
				return
			}
			_tab_arr.SetSelectIndex(index)
			_now_index_ = index
			this.UpdateView()
		}

		this.UpdateView = () => {
			let data = local_HolyBattleModel_Instance.GetRecordData()
			if (data) {
				let group_vo = null
				for (let _tmpi in data.group_list) {
					var vo = data.group_list[_tmpi]
					if ((vo.group_id-1) == Number(_now_index_)) {
						group_vo = vo
						break
					}
				}
				if (group_vo) {
					let list = []
					for (let _tmpi in group_vo.role_list) {
						var vo = group_vo.role_list[_tmpi]
						table.insert(list, vo)
					}

					this._list_item_con.visible=true
					if(!_item_array){
						_item_array = new LoopScrowViewMgr()
						_item_array.SetData(this._list_item_con, HolyBattleRecordItem, list, LoopScrCon.Vertical)
					}else{
						_item_array.replaceAll(list)
					}
					
		

					this._lb_none.visible = group_vo.role_list.length == 0

					let my_rank = null
					let my_vo = null
					for (let _tmpi in group_vo.role_list) {
						var vo = group_vo.role_list[_tmpi]
						if (vo.role_id == local_RoleManager_Instance.GetMainRoleId()) {
							my_rank = _tmpi
							my_vo = vo
						}
					}
					let color1 = "'#d15e00'"
					if (my_vo) {
						this._lb_group_rank.innerHTML = "当前个人排名：" + HtmlColorTxt(my_vo.rank, color1)
						this._lb_group_score.innerHTML = "当前个人积分：" + HtmlColorTxt(my_vo.point, color1)
					} else {
						this._lb_group_score.innerHTML = `当前个人积分：${HtmlColorTxt("无", color1)}`
						this._lb_group_rank.innerHTML = `当前个人排名：${HtmlColorTxt("无", color1)}`
					}
				}else{
					this._lb_none.visible=true
					this._list_item_con.visible=false
				}
			}
		}

		this.UpdateRecordData = () => {
			let data = local_HolyBattleModel_Instance.GetRecordData()
			if (data) {
				let role_holy_spirit_battlefield_group = ResManager.GetInstance().GetGameConfigFromCache(this, "config_role_holy_spirit_battlefield_group", false)//Config.Roleholyspiritbattlefieldgroup
				let group_cfg = null
				for (let _tmpi in data.group_list) {
					var vo = data.group_list[_tmpi]
					group_cfg = role_holy_spirit_battlefield_group[vo.group_id]
					if (group_cfg) {
						this["_lb_name" + vo.group_id].text = group_cfg.name
						let textcolor = vo.group_id == local_RoleManager_Instance.GetMainRoleVo().warGroup ?"#00ed2d":this.GetColor(vo.group_id)
						this["_lb_name" + vo.group_id].color = textcolor
					}
					this["_lb_count" + vo.group_id].text = `x${vo.tower_num}`
					this["_lb_score" + vo.group_id].innerHTML = `积分:${HtmlColorTxt(vo.point, "'#ff6a2b'")}`
				}
			}
		}

		this.GetColor = (c) => {
			let str="#008fd1"
			switch (c) {
				case 1:
					str="#008fd1"
					break;
				case 2:
					str="#ea1015"
					break
				case 3:
					str="#d16700"
					break;
			}
			return str
		}

		this.Remove = () => {
			if (_tab_arr) {
				_tab_arr.DeleteMe()
				_tab_arr = null
			}

			if (_item_array) {
				_item_array.DeleteMe()
				_item_array = null
			}
			_tab_data_list = null
		}

	}


	public DeleteMe() {
		super.DeleteMe()
	}

_img_bg:Laya.Image
_img_bg2:Laya.Image
_img_title_bg:Laya.Image
_img_close:Laya.Image
_box_img:Laya.Box
_img1:Laya.Image
_img2:Laya.Image
_img3:Laya.Image
_Image_title:Laya.Image
_lb_win_name:Laya.Label
_list_tab_con:Laya.List
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_lb_name1:Laya.Label
_lb_name2:Laya.Label
_lb_name3:Laya.Label
_lb_count1:Laya.Label
_lb_count2:Laya.Label
_lb_count3:Laya.Label
_lb_score1:Laya.HTMLDivElement
_lb_score2:Laya.HTMLDivElement
_lb_score3:Laya.HTMLDivElement
_lb_group_rank:Laya.HTMLDivElement
_lb_group_score:Laya.HTMLDivElement
_list_item_con:Laya.List
_lb_none:Laya.Label
_lb_t1:Laya.Label
_lb_t2:Laya.Label
_lb_t3:Laya.Label
_lb_t4:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_bg2,
this._img_title_bg,
this._img_close,
this._box_img,
this._img1,
this._img2,
this._img3,
this._Image_title,
this._lb_win_name,
this._list_tab_con,
this._Image1,
this._Image2,
this._Image3,
this._lb_name1,
this._lb_name2,
this._lb_name3,
this._lb_count1,
this._lb_count2,
this._lb_count3,
this._lb_score1,
this._lb_score2,
this._lb_score3,
this._lb_group_rank,
this._lb_group_score,
this._list_item_con,
this._lb_none,
this._lb_t1,
this._lb_t2,
this._lb_t3,
this._lb_t4,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_bg2",
"_img_title_bg",
"_img_close",
"_box_img",
"_img1",
"_img2",
"_img3",
"_Image_title",
"_lb_win_name",
"_list_tab_con",
"_Image1",
"_Image2",
"_Image3",
"_lb_name1",
"_lb_name2",
"_lb_name3",
"_lb_count1",
"_lb_count2",
"_lb_count3",
"_lb_score1",
"_lb_score2",
"_lb_score3",
"_lb_group_rank",
"_lb_group_score",
"_list_item_con",
"_lb_none",
"_lb_t1",
"_lb_t2",
"_lb_t3",
"_lb_t4",
])
}
}
 window["HolyBattleRecordView"]= HolyBattleRecordView