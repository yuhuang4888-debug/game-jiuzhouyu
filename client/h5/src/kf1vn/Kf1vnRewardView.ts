import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DsgtModel } from "../commonModel/DsgtModel"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Kf1vnPlatformRewardItem } from "./Kf1vnPlatformRewardItem"
import { Kf1vnTabItem } from "./Kf1vnTabItem"
import { Kf1vnTicketRewardItem } from "./Kf1vnTicketRewardItem"

export class Kf1vnRewardView extends BaseView1 {

	GetLeaderRankList
	GetPlatformReward
	GetScoreRankList
	InitEvent
	LoadSuccess
	OpenCallback
	SetItemRender
	SetPlatformItemRender
	SwtichView
	back_login_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	loop_loop_mgr
	open_callback
	setTopThree
	use_background
	platform_loop_mgr
	InitTab
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		let model = Kf1vnModel.GetInstance()
		let local_Erlang = ErlangParser.GetInstance()
		let cur_index_ = 0
		this.is_center = true
		this.preload_server_config =
		{
			"config_kf_1vn_score_reward": false,
			"config_kf_1vn_match": false,
			"config_kf_1vn_race_2_award": false
		}

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
			cur_index_ = 0
			if (this.loop_loop_mgr) {
				this.loop_loop_mgr.DeleteMe()
				this.loop_loop_mgr = null
			}
			if (this.platform_loop_mgr) {
				this.platform_loop_mgr.DeleteMe()
				this.platform_loop_mgr = null
			}

			if (_tab_arr) {
				_tab_arr.DeleteMe()
				_tab_arr = null
			}
			_tab_data_list = null
		}

		this.LoadSuccess = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this.platform_bg, GameResPath.GetIcon("kf1vn", "uikf1vn_019"))
			this.InitTab()
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true)

		}


		this.OpenCallback = () => {
			this.SwtichView(cur_index_)
		}

		this.SwtichView = (index?) => {
			cur_index_ = index
			let data = []
			this.ticket_conta.visible = index == 0
			this.platform_conta.visible = !(index == 0)

			if (index == 0) {
				data = this.GetScoreRankList(1)
				this.SetItemRender(data)
			} else {
				data = this.GetPlatformReward()
				this.SetPlatformItemRender(data)
				this.setTopThree()
			}
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


		this.GetPlatformReward = () => {
			let leader_list = this.GetLeaderRankList(1)
			let challenger_list = this.GetLeaderRankList(2)
			let vo = null
			let i = 0
			do {
				vo = challenger_list[i]
				table.insert(leader_list, vo)
				i = i + 1
			} while ((i < 2))
			return leader_list
		}

		this.SetItemRender = (list?) => {
			if (!this.loop_loop_mgr) {
				this.loop_loop_mgr = new LoopScrowViewMgr()
				this.loop_loop_mgr.SetData(this.Content1, Kf1vnTicketRewardItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_loop_mgr.replaceAll(list)
			}
		}

		this.SetPlatformItemRender = (list?) => {
			if (!this.platform_loop_mgr) {
				this.platform_loop_mgr = new LoopScrowViewMgr()
				this.platform_loop_mgr.SetData(this.Content, Kf1vnPlatformRewardItem, list, LoopScrCon.Vertical)
			} else {
				this.platform_loop_mgr.replaceAll(list)
			}
		}

		this.GetScoreRankList = (_type?) => {
			let list = []
			let cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_kf_1vn_score_reward", false)
			if (cfg1) {
				let cfg = null
				for (let key in cfg1) {

					cfg = cfg1[key]
					if (cfg.race_type == _type) {
						table.insert(list, cfg)
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return a.rank_min < b.rank_min
			}
			table.sort(list, sort_fun)
			return list
		}

		this.GetLeaderRankList = (_type?) => {
			let list = []
			let cfg1 =ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_race_2_award",false)
			if (cfg1) {
				let cfg = null
				for (let key in cfg1) {

					cfg = cfg1[key]
					if (cfg.type == _type) {
						table.insert(list, cfg)
					}
				}
			}
			let sort_fun = (a?, b?) => {
				return b.turn < a.turn
			}
			table.sort(list, sort_fun)

			let result = []
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				let obj = {}//[is_win=0, turn=0, reward=[]]
				obj["is_win"] = 1
				obj["turn"] = vo.turn
				obj["type"] = vo.type
				obj["reward"] = JSON.parse(vo.win_award) || []
				table.insert(result, obj)
				let obj2 = {}//[is_win=0, turn=0, reward=[]]
				obj2["is_win"] = 2
				obj2["turn"] = vo.turn
				obj2["type"] = vo.type
				obj2["reward"] = JSON.parse(vo.lose_award) || []
				table.insert(result, obj2)
			}
			return result
		}

		this.setTopThree = () => {
			let list = this.GetScoreRankList(2)
			if (list) {
				let vo = null
				let goods_list = null
				let dsgt_cfg = null
				let i = 0
				do {
					vo = list[i]
					if (vo) {
						goods_list = JSON.parse(vo.rewards)
						if (goods_list && goods_list[0]) {
							dsgt_cfg = DsgtModel.GetInstance().GetDsgtCfgByActiveGoods(goods_list[0][1])
							if (dsgt_cfg) {
								if (dsgt_cfg.type == 1) {
									this["resource_image" + i].visible = false
									this["_gp_dsgt_effect" + i].visible = true
									this.AddUIEffect(dsgt_cfg.resource_id, this["_gp_dsgt_effect" + i], null, 1, true)
								} else {
									this["resource_image" + i].visible = true
									this["_gp_dsgt_effect" + i].visible = false
									let call_back = (texture?) => {
										//this["resource_image" + i].anchorOffsetX = this["resource_image" + i].width * 0.5
										//this["resource_image" + i].anchorOffsetY = this["resource_image" + i].height * 0.5
									}
									ResManager.GetInstance().SetOutsideImageSprite(this, this["resource_image" + i], GameResPath.GetDesignImage(dsgt_cfg.resource_id+""), true, call_back)
								}
							}
						}
					}
					i = i + 1
				} while ((i < 3))
			}
		}
	}


	public DeleteMe() {
		super.DeleteMe()
	}


bg_img:Laya.Image
img_title:Laya.Image
lb_title:Laya.Label
closeBtn:Laya.Box
btn_img:Laya.Image
ticket_conta:Laya.Box
_Image11:Laya.Image
_Image1111:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
Content1:Laya.List
platform_conta:Laya.Box
platform_bg:Laya.Image
_Image111:Laya.Image
resource_image0:Laya.Image
_gp_dsgt_effect0:Laya.Box
resource_image2:Laya.Image
_gp_dsgt_effect2:Laya.Box
resource_image1:Laya.Image
_gp_dsgt_effect1:Laya.Box
Content:Laya.List
tips_conta:Laya.HBox
_Image9:Laya.Image
tips:Laya.Label
_list_tab_con:Laya.List
public GetComponents() {
[
this.bg_img,
this.img_title,
this.lb_title,
this.closeBtn,
this.btn_img,
this.ticket_conta,
this._Image11,
this._Image1111,
this._Label1,
this._Label2,
this.Content1,
this.platform_conta,
this.platform_bg,
this._Image111,
this.resource_image0,
this._gp_dsgt_effect0,
this.resource_image2,
this._gp_dsgt_effect2,
this.resource_image1,
this._gp_dsgt_effect1,
this.Content,
this.tips_conta,
this._Image9,
this.tips,
this._list_tab_con,
]
 = this.GetChildrenByNames([

"bg_img",
"img_title",
"lb_title",
"closeBtn",
"btn_img",
"ticket_conta",
"_Image11",
"_Image1111",
"_Label1",
"_Label2",
"Content1",
"platform_conta",
"platform_bg",
"_Image111",
"resource_image0",
"_gp_dsgt_effect0",
"resource_image2",
"_gp_dsgt_effect2",
"resource_image1",
"_gp_dsgt_effect1",
"Content",
"tips_conta",
"_Image9",
"tips",
"_list_tab_con",
])
}
}
 window["Kf1vnRewardView"]= Kf1vnRewardView