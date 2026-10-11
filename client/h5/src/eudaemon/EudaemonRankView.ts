import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ArenaModel } from "../commonModel/ArenaModel"
import { BossModel } from "../commonModel/BossModel"
import { DsgtModel } from "../commonModel/DsgtModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { EudaemonRankItem } from "./EudaemonRankItem"
import { EudaemonRankTabItem } from "./EudaemonRankTabItem"

export class EudaemonRankView extends BaseItem1 {

	tabInfo
	tab_item_list
	vo
	res_mgr: ResManager
	role_mgr: RoleManager
	select_index
	model
	rankInfo
	indexToType
	rankStrList
	No1Id
	rankArr
	public constructor(parent?) {
		super(parent)
		this.base_file = "eudaemon"
		this.layout_file = "EudaemonRankView"
		this.layer_value = Enum_UILayer.Activity

		this.model = BossModel.GetInstance();
		this.rankInfo = [];
		this.indexToType = [3, 2, 1];
		this.tabInfo = [{ name: "总积分榜" }, { name: "大妖榜" }, { name: "击杀榜" }];
		this.rankStrList = ["a", "b", "c"];

		this.res_mgr = ResManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.load_callback = () => {
			this.InitView()
		}
	}

	public InitView() {

		//resource/game/eudaemon/texture/ui_kdb_11.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg5, GameResPath.GetIconOtherPath("eudaemon", "ui_kdb_11"))

		if (!this.tab_item_list) {
			this.tab_item_list = []
		}

		let select_func = (index) =>{
			this.SelectItem(index)
		}
		for (let i = 0; i < 3; i++) {
			let item = new EudaemonRankTabItem(this._box_tab)
			item.Load()
			item.SetData(this.tabInfo[i], select_func, i)
			this.tab_item_list[i] = item
			item.SetPosition(161 * Number(i), 0)
		}

		this.BindEvent(this.model, BossModel.UPDATE_EUDAEMON_RANK, (scmd?) => {
			this.rankInfo = scmd.player_list
			this.SelectItem(this.select_index || 0)
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.GET_ROLE_FIGURE_INFO_RETURN, (scmd?) => {
			if (scmd.player_id == this.No1Id) {
				this.CreateModel(scmd)
			}
		}
		)

		this.SelectItem(0)

		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("eudaemon", "ui_kf_dgxs0105"))

		this.model.Fire(BossModel.SCMD_REQUEST, 47021)
	}

	public SelectItem(index?) {

		let config_eudemons_boss_rank_reward = this.res_mgr.GetGameConfigFromCache(this, "config_eudemons_boss_rank_reward", false)
		// let Cfg = Config.Eudemonsbossrankreward
		if (!config_eudemons_boss_rank_reward) {
			return
		}

		if (index == 0) {
			table.sort(this.rankInfo, (a?, b?) => {
				if (a && b) {
					if (a.total_score != b.total_score) {
						return b.total_score < a.total_score
					} else {
						return a.sort_key3 < b.sort_key3
					}
				}
			})

			this._lb_title3.text = "总积分"
		} else if (index == 1) {
			table.sort(this.rankInfo, (a?, b?) => {
				if (a && b) {
					if (a.score != b.score) {
						return b.score < a.score
					} else {
						return a.sort_key1 < b.sort_key1
					}
				}
			})
			this._lb_title3.text = "大妖积分"
		} else {
			table.sort(this.rankInfo, (a?, b?) => {
				if (a && b) {
					if (a.kill_num != b.kill_num) {
						return b.kill_num < a.kill_num
					} else {
						return a.sort_key2 < b.sort_key2
					}
				}
			})
			this._lb_title3.text = "击杀积分"
		}

		let rankInfo = this.rankInfo
		let No1Info = null
		let arrList = []
		for (let key in config_eudemons_boss_rank_reward) {
			let rankCfg = config_eudemons_boss_rank_reward[key]
			if (rankCfg.rank_type == this.indexToType[index]) {
				let i = rankCfg.rank1
				if (i <= rankCfg.rank2) {
					do {
						let obj = { rank: i, Cfg: rankCfg }
						if (rankInfo[i - 1] && !(((index == 0 && rankInfo[i - 1].total_score == 0) || (index == 1 && rankInfo[i - 1].score == 0)) || (index == 2 && rankInfo[i - 1].kill_num == 0))) {
							obj["data"] = rankInfo[i - 1]
						} else {
							obj["data"] = null
						}
						arrList[i - 1] = obj
						i = i + 1
					} while ((i <= rankCfg.rank2))
				}
			}
		}
		let roleId = this.role_mgr.GetMainRoleId()
		this._lb_self_name.text = this.role_mgr.GetMainRoleVo().name
		let find = false
		let i = 1
		if (i <= rankInfo.length) {
			do {
				let vo = rankInfo[i - 1]
				vo["index"] = index
				vo["rank"] = i
				if (vo.role_id == roleId) {
					find = true
					if (vo["rank"] > 3) {
						this._img_self_rank.visible = false
						this._lb_self_rank.text = vo["rank"]
					} else {
						this._lb_self_rank.text = ""
						this._img_self_rank.visible = true
						this.res_mgr.SetImageSprite(this, this._img_self_rank, "eudaemon", EudaemonRankItem.rankStrList[vo["rank"] - 1])
					}
					if (index == 0) {
						find = vo.total_score != 0
						this._lb_self_score.text = vo.total_score
					} else if (index == 1) {
						find = vo.score != 0
						this._lb_self_score.text = vo.score
					} else if (index == 2) {
						find = vo.kill_num != 0
						this._lb_self_score.text = vo.kill_num
					}
				}
				i = i + 1
			} while ((i <= rankInfo.length))
		}

		if (!this.rankArr) {
			this.rankArr = new LoopScrowViewMgr()
			this.rankArr.SetData(this._list_item, EudaemonRankItem, arrList, LoopScrCon.Vertical)
		} else {
			this.rankArr.replaceAll(arrList)
		}

		this.ShowNo1(arrList[0])
		if (!find) {
			this._img_self_rank.visible = false
			this._lb_self_rank.text = "未上榜"
			this._lb_self_score.text = "0"
		}

		let tab_item = this.tab_item_list[this.select_index]
		if (tab_item) {
			tab_item.SetSelect(false)
		}

		tab_item = this.tab_item_list[index]
		if (tab_item) {
			tab_item.SetSelect(true)
		}
		this.select_index = index
	}

	public ShowNo1(data?) {
		let info = data && data.data

		this.res_mgr.ClearRoleMode(this.hashCode)
		if (info) {
			this._lb_name.text = "S" + info.server_num + "." + info.role_name
			this.No1Id = info.role_id
			GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13013, "hlh", info.server_id, info.role_id, 470)
			this._box_dsgt.visible = true
			this._img_default_role.visible = false
			this._img_default.visible = false
		} else {
			this._lb_name.text = "虚位以待"
			this.No1Id = null
			this._box_dsgt.visible = false
			this._img_default_role.visible = true
			this._img_default.visible = true
			this.SetDsgt(null)
		}
	}

	public CreateModel(vo?) {
		if (!vo) {
			return
		}
		this.vo = vo
		this.SetDsgt(vo.dsgt_id, vo.marriage_name)
		let [head_id, head_texture_id] = Util.GetRoleHeadId(vo)
		// let head_res =  Util.GetRoleHeadId(vo)
		// let role_res, role_color = GetRoleClotheTextureId(vo)
		let [model_id, texture_id] = Util.GetRoleClotheId(vo)
		let weapon_res = Util.GetWeaponClotheId(vo)
		let wing_res = Util.GetWingClotheId(vo)
		let horse_res = Util.GetHorseClotheId(vo)
		let back_ornament_res = Util.GetBackOrnamentId(vo)

		let data = {
			career: vo.career,
			sex: vo.sex,
			type: UI_MODEL_TYPE.ROLE,
			layer_value: Enum_UILayer.Activity,
			clothe_res_id: model_id,
			fashion_model_id: model_id,
			texture_id : texture_id,
			head_wear_id: head_id,
			head_clothe_id :head_texture_id,
			weapon_res_id: weapon_res,
			wing_id: wing_res,
			horse_id: horse_res,
			back_ornament_id: back_ornament_res
		}
		this.res_mgr.SetRoleModel(this, this._box_role, data)
	}

	public SetDsgt(id?, name?) {
		let dsgt = DsgtModel.GetInstance().getDsgtCfgByID(id)
		this.ClearUIEffect(this._box_role)
		if (!dsgt) {
			this._img_dsgt.visible = false
			return
		}
		if (dsgt.type == 1) {
			this._img_dsgt.visible = false
		} else {
			this._img_dsgt.visible = true
			this.res_mgr.SetOutsideImageSprite(this, this._img_dsgt, GameResPath.GetDesignImage(dsgt.resource_id), true, () => {
				if (dsgt.type == 7) {
					this._lb_dsgt.text = name + "的伴侣"
				} else {
					this._lb_dsgt.text = ""
				}
			})
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this._box_dsgt)
		if (this.tab_item_list) {
			for (let _ in this.tab_item_list) {
				var v = this.tab_item_list[_]
				v.DeleteMe()
			}
			this.tab_item_list = null
		}
		if (this.rankArr) {
			this.rankArr.DeleteMe()
			this.rankArr = null
		}
		super.DeleteMe()
	}
	_img_bg: Laya.Image
	_box_dsgt: Laya.Box
	_box_role: Laya.Box
	_img_dsgt: Laya.Image
	_lb_dsgt: Laya.Label
	_img_default_role: Laya.Image
	_img_default: Laya.Image
	_img_bg2: Laya.Image
	_lb_name: Laya.Label
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_lb_title: Laya.Label
	_lb_title2: Laya.Label
	_lb_title3: Laya.Label
	_lb_title4: Laya.Label
	_img_bg5: Laya.Image
	_lb_self_rank: Laya.Label
	_lb_self_name: Laya.Label
	_lb_self_score: Laya.Label
	_img_self_rank: Laya.Image
	_html_tips: Laya.HTMLDivElement
	_box_tab: Laya.Box
	_list_item: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._box_dsgt,
			this._box_role,
			this._img_dsgt,
			this._lb_dsgt,
			this._img_default_role,
			this._img_default,
			this._img_bg2,
			this._lb_name,
			this._img_bg3,
			this._img_bg4,
			this._lb_title,
			this._lb_title2,
			this._lb_title3,
			this._lb_title4,
			this._img_bg5,
			this._lb_self_rank,
			this._lb_self_name,
			this._lb_self_score,
			this._img_self_rank,
			this._html_tips,
			this._box_tab,
			this._list_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_dsgt",
				"_box_role",
				"_img_dsgt",
				"_lb_dsgt",
				"_img_default_role",
				"_img_default",
				"_img_bg2",
				"_lb_name",
				"_img_bg3",
				"_img_bg4",
				"_lb_title",
				"_lb_title2",
				"_lb_title3",
				"_lb_title4",
				"_img_bg5",
				"_lb_self_rank",
				"_lb_self_name",
				"_lb_self_score",
				"_img_self_rank",
				"_html_tips",
				"_box_tab",
				"_list_item",
			])
	}
}
window["EudaemonRankView"] = EudaemonRankView