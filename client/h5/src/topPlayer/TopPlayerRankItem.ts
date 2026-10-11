
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { TopPlayerView } from "./TopPlayerView"
import { Util } from "../util/Util"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"

export class TopPlayerRankItem extends BaseItemRenderer {


	static GetCondDesc(rush_rank_cfg, rush_rank_reward_cfg, rank_type, rank, kay_val_cfg) {
		if (!rush_rank_cfg || !rush_rank_reward_cfg || !rank_type || !rank) {
			return
		}
		let limit_val
		let reward_id = 1
		let openTime:number = ServerTimeModel.GetInstance().GetOpenServerTime();
		let limitOpenTIme = kay_val_cfg[16].value;
		let _day = Math.ceil((Number(limitOpenTIme) - openTime)/ 3600 / 24);
		while (true) {
			var cfg = rush_rank_reward_cfg[`${rank_type}@${reward_id}`]
			if (!cfg) {
				break
			}
			if (cfg.rank_min <= rank && cfg.rank_max >= rank) {
				limit_val = cfg.limit_val
				let open_day_list = JSON.parse(rush_rank_cfg[rank_type].open_day_list);
				if(_day  <= 0 || open_day_list.indexOf(_day) == -1){
					limit_val = cfg.new_limit_val
				}
				break
			}
			reward_id++
		}

		if (limit_val) {
			// let rank_cfg = rush_rank_cfg[rank_type]
			// let limit_cond_str = rank_cfg.limit
			// let limit_cond_key = JSON.parse(limit_cond_str)[0][0]
			// let str
			// switch (limit_cond_key) {
			// 	case "combat":
			// 		str = "战力"
			// 		break
			// 	case "lv":
			// 		str = "等级"
			// 		break
			// 	default:
			// 		str = ""
			// 		break

			// }
			// str += limit_val
			// return str
			return String(limit_val)
			
		}
	}

	WIDTH = 552
	HEIGT = 48
	cache_level_x

	public constructor() {
		super()
		this.base_file = "topPlayer"
		this.layout_file = "TopPlayerRankItem"
		this.load_callback = () => {
			this._lb_level.style.fontSize = 20
			this._lb_level.style.wordWrap = false
			this._lb_level.style.color = "#d15e00"
			this._lb_level.width = 200
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let rank = this.data.rank
			let bool = rank < 4
			this._img_rank.visible = bool
			this._lb_rank.visible = !bool
			let url1 = "ui_activity_11"
			if (bool) {
				let url = ""

				if (1 == rank) {
					url = "rank_icon_1"
					url1 = "ui_activity_08"
				} else if (2 == rank) {
					url = "rank_icon_2"
					url1 = "ui_activity_09"
				} else if (3 == rank) {
					url = "rank_icon_3"
					url1 = "ui_activity_10"
				}
				ResManager.GetInstance().SetImageSprite(this, this._img_rank, "topPlayer_asset", url)
			} else {
				this._lb_rank.text = rank
			}
			ResManager.GetInstance().SetImageSprite(this, this._img_rank1, "topPlayer_asset", url1)


			//设置名字
			let name
			if (this.data.player_id > 0) {
				name = this.data.name
			}
			else {
				name = "暂无"
			}
			this._lb_name.text = name


			//设置值

			let value

			if (this.data.player_id > 0) {
				if (bool && TopPlayerView.Type.Pay == this.data.rank_type) {
					value = "******"
				}
				else {
					value = this.data.first_value
				}
			}
			else {
				let config_rush_rank = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_rank", false)
				let config_rush_rank_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rush_rank_reward", false)
				let _key_val_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_key_value",false)
				value = TopPlayerRankItem.GetCondDesc(config_rush_rank, config_rush_rank_reward, this.data.rank_type, this.data.rank, _key_val_cfg)
				
			}

			if (this.data.player_id > 0) {
				if (bool && TopPlayerView.Type.Pay == this.data.rank_type) {
					value = `<font color='#d15e00'>${value}</font>`
				}
				else {
					value = Util.StrToHTML(TopPlayerView.GetValue2Desc(this.data.rank_type, value, "#d15e00", true))
				}
			} else {
				let fight_value = Util.StrToHTML(TopPlayerView.GetValue2Desc(this.data.rank_type, value, "#d15e00", true))
				value = `${fight_value}<font color='#d15e00'>可上榜</font>`
			}
			this._lb_level.innerHTML = value
			this._hbox_level_con.callLater(()=>{
				if(this.use_delete_method) return
				this._hbox_level_con["changeItems"]()
			})
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_img_rank1: Laya.Image
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_hbox_level_con: Laya.HBox
	_lb_level: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_rank1,
			this._img_rank,
			this._lb_rank,
			this._lb_name,
			this._hbox_level_con,
			this._lb_level,
		]
			= this.GetChildrenByNames([

				"_img_rank1",
				"_img_rank",
				"_lb_rank",
				"_lb_name",
				"_hbox_level_con",
				"_lb_level",
			])
	}
}
window["TopPlayerRankItem"] = TopPlayerRankItem