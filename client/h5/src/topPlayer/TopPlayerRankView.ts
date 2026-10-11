import { BaseView1 } from "../common/BaseView1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { TopPlayerView } from "./TopPlayerView"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { TopPlayerRankItem } from "./TopPlayerRankItem"
export class TopPlayerRankView extends BaseView1 {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_btn_close: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_lb_level_desc: Laya.Label
	_Label3: Laya.Label
	_lb_none: Laya.Label
	Content: Laya.List
	_Image4: Laya.Image
	_Group1: Laya.HBox
	_Label4: Laya.Label
	_lb_rank: Laya.Label
	_Label5: Laya.Label
	_lb_level: Laya.HTMLDivElement
	title_bg: Laya.Image
	GetDesc
	InitEvent
	LoadSuccess
	SetRankData
	UpdateView
	change_scene_close
	click_bg_toClose
	close_callback
	is_center
	loop_mgr
	open_callback
	show_open_movie
	use_background

	public constructor() {
		super()

		let local_TopPlayerView = TopPlayerView
		let rank_data_ = null
		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerRankView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.change_scene_close = true
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}
		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("topPlayer", "uijjsh_017"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIcon("topPlayer", "ui_activity_07"))
			//lua_resM:SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("topPlayer","uijjsh_017"))
			//this._scroll_con.verticalScrollBar.autoVisibility = false
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
		}

		this.UpdateView = () => {
			if (!rank_data_) {
				//LayoutRebuilder(this._Group1)
				return
			}
			let list = rank_data_.rank_list
			for (let _tmpi in list) {
				var obj = list[_tmpi]
				obj.rank_type = rank_data_.rank_type
			}
			let len = list.length
			let bool = len == 0
			this.Content.visible = !bool
			this._lb_none.visible = bool
			let str = local_TopPlayerView.GetValue2Desc(rank_data_.rank_type, rank_data_.sel_val, "#d15e00", true)
			this._lb_level.style.fontSize = 20
			this._lb_level.style.valign = "center"
			this._lb_level.style.color = "#d15e00"
			this._lb_level.width = 150
			this._lb_level.innerHTML = Util.StrToHTML(this.GetDesc(rank_data_.rank_type, str))
			let level_desc = null
			if (local_TopPlayerView.Type.Level == rank_data_.rank_type) {
				level_desc = "等级"
			} else if (local_TopPlayerView.Type.Mount == rank_data_.rank_type) {
				level_desc = "坐骑战力"
			} else if (local_TopPlayerView.Type.Parter == rank_data_.rank_type) {
				level_desc = "侍魂战力"
			} else if (local_TopPlayerView.Type.Pet == rank_data_.rank_type) {
				level_desc = "飞骑总阶数"
			} else if (local_TopPlayerView.Type.Suit == rank_data_.rank_type) {
				level_desc = "套装总等级"
			} else if (local_TopPlayerView.Type.Store == rank_data_.rank_type) {
				level_desc = "宝石总等级"
			} else if (local_TopPlayerView.Type.Lung == rank_data_.rank_type) {
				level_desc = "神纹等级"
			} else if (local_TopPlayerView.Type.Rune == rank_data_.rank_type) {
				level_desc = "御魂战力"
			}  else if (local_TopPlayerView.Type.Pay == rank_data_.rank_type) {
				level_desc = "充值总额"
			} else if (local_TopPlayerView.Type.Fight == rank_data_.rank_type) {
				level_desc = "战力"
			}
			this._lb_level_desc.text = level_desc
			this._lb_rank.text = (rank_data_.sel_rank && rank_data_.sel_rank != 0) && rank_data_.sel_rank || "未上榜"

			if (bool) {
				return
			}

			// 测试
			// let last_data = list[list.length - 1]
			// list.push({
			// 	rank:last_data.rank + 50,
			// 	rank_type:rank_data_.rank_type,
			// 	player_id:1,
			// 	first_value:0,
			// 	name:"SSS"
			// })
			// len++


			let index = 1,list_index = 0
			let show_list = []
			while(len > list_index){
				var rank_data = list[list_index]
				if(rank_data && rank_data.rank == index ){
					show_list.push(rank_data)
					list_index++
				}
				else{
					show_list.push({
						rank:index,
						rank_type:rank_data_.rank_type,
						player_id:0,
					})
				}
				index ++ 
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, TopPlayerRankItem, show_list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(show_list)
			}

		}

		this.SetRankData = (rank_data?) => {
			rank_data_ = rank_data
		}

		this.GetDesc = (rank_type?, str?) => {
			if (local_TopPlayerView.Type.Level == rank_type) {
				str = str + "级"
			} else if (local_TopPlayerView.Type.Store == rank_type) {
				str = str + "级"
			} else if (local_TopPlayerView.Type.Suit == rank_type) {
				str = str + "级"
			} else if (local_TopPlayerView.Type.Pet == rank_type) {
				str = str + "阶"
			} else if (local_TopPlayerView.Type.Soul == rank_type) {
				str = "战力:" + str
			}
			return str
		}
	}






	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._btn_close,
			this._Image2,
			this._Image3,
			this._Label1,
			this._Label2,
			this._lb_level_desc,
			this._Label3,
			this._lb_none,
			this.Content,
			this._Image4,
			this._Group1,
			this._Label4,
			this._lb_rank,
			this._Label5,
			this._lb_level,
			this.title_bg
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_btn_close",
				"_Image2",
				"_Image3",
				"_Label1",
				"_Label2",
				"_lb_level_desc",
				"_Label3",
				"_lb_none",
				"Content",
				"_Image4",
				"_Group1",
				"_Label4",
				"_lb_rank",
				"_Label5",
				"_lb_level",
				"title_bg"
			])
	}
}
window["TopPlayerRankView"] = TopPlayerRankView