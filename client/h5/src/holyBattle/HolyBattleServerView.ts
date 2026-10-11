import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { SetAnchoredPositionX, SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util"
import { HolyBattleServerItem } from "./HolyBattleServerItem"

//服务器分服信息
export class HolyBattleServerView extends BaseView1 {
	InitView
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	preload_server_config
	serArr
	show_open_movie
	use_background
	color_str = "'#0a953e'"
	color_str2 = "'#0a953e'"
	public constructor() {
		super()

		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleServerView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true

		this.serArr = null
		let local_HolyBattleModel_Instance = HolyBattleModel.GetInstance()

		this.load_callback = () => {
			SetHtmlStyle(this._html_desc, { f: 22, c: "#663915",a:"center",w:400,li:15,ww:false})
			SetHtmlStyle(this._html_desc2, { f: 20, c: "#663915", ww:false })
			this.InitView()
		}

		this.destroy_callback = () => {
			if (this.serArr) {
				this.serArr.DeleteMe()
				this.serArr = null
			}
		}

		this.preload_server_config = { "config_holy_spirit_battlefield_mod": false }

		this.InitView = () => {
			let server_list = local_HolyBattleModel_Instance.GetServerList()
			let mode = local_HolyBattleModel_Instance.GetMode()
			let avg_wlv = local_HolyBattleModel_Instance.GetAverageWorldLv()

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			if (!mode) {
				return
			}

			if (server_list) {
				this.serArr = new LoopScrowViewMgr()
				this.serArr.SetData(this._list_item, HolyBattleServerItem, server_list, LoopScrCon.Vertical)
				let tempIndex = [1, 2, 4, 8]
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_holy_spirit_battlefield_mod", false)//Config.Holyspiritbattlefieldmod
				let str = ""
				let next_cfg = null
				if (cfg) {
					for (let _ = 0; _ < tempIndex.length; _++) {
						var index = tempIndex[_]
						if (cfg[index].mod > mode) { //当前跨服服务器数量不足暂时无法开启下一阶段
							next_cfg = cfg[index]
							break
						}
					}
				}
				if (next_cfg) {
					let level = TransformLevel(next_cfg.min_world_lv)
					let level_world = TransformLevel(avg_wlv)
					str = "当跨服世界等级达到<font color='#0a953e'>" + level + "级</font>后开启<font color='#0a953e'>" + next_cfg.name + "</font><br>"
					str = str + "(" + (next_cfg.mod == 1 && "本" || next_cfg.mod) + "服跨服世界等级为<font color='#0a953e'>" + level_world + "级</font>)"
				} else {
					str = "暂未开放下一阶段跨服模式，敬请期待！<br>"
					let level =TransformLevel(avg_wlv)
					str = str + "(" + (mode == 1 && "本" || mode) + "服跨服世界等级为<font color='#0a953e'>" + level + "级</font>)"
				}

				this._html_desc.innerHTML = Util.StrToHTML(str)
				this._html_desc2.innerHTML = Util.StrToHTML("每日<font color='#0a953e'>4:00</font>刷新服务器分区状态模式")
			}
		}


	}

	public DeleteMe() {
		super.DeleteMe()
	}


_img_bg:Laya.Image
_img_close:Laya.Image
_img_tips:Laya.Image
_img_bg2:Laya.Image
_html_desc:Laya.HTMLDivElement
_html_desc2:Laya.HTMLDivElement
_list_item:Laya.List
public GetComponents() {
[
this._img_bg,
this._img_close,
this._img_tips,
this._img_bg2,
this._html_desc,
this._html_desc2,
this._list_item,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_close",
"_img_tips",
"_img_bg2",
"_html_desc",
"_html_desc2",
"_list_item",
])
}
}
 window["HolyBattleServerView"]= HolyBattleServerView