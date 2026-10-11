import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"
import "./NineSkyServerItem"

export class NineSkyServerView extends BaseView1 {

	tab_loop_mgr:LoopScrowViewMgr
	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkyServerView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.preload_server_config = {
			"config_nine_partition": false,
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {

		this._html_desc.style.color = "#663915"
		this._html_desc.style.fontSize = 22
		this._html_desc.style.wordWrap = false
		this._html_desc.style.align = "center"
		this._html_desc.style.leading = 15


		this._html_desc2.style.color = "#663915"
		this._html_desc2.style.fontSize = 20
		this._html_desc2.style.wordWrap = false
		this._html_desc2.innerHTML = `每日<font color='#0a953e'>4:00</font>刷新服务器分区状态模式`


		Util.AddClickEvent(this._img_close, () => {
				this.Close()
			},this,true)

		this.UpdateView()
	}

	public Remove() {
		if (this.tab_loop_mgr) {
			this.tab_loop_mgr.DeleteMe()
			this.tab_loop_mgr = undefined
		}
	}

	public UpdateView() {

		let data = NineSkyModel.GetInstance().GetStateInfo()
		if (data && data.server_list) {

			let item_class = window["NineSkyServerItem"]
			if (this.tab_loop_mgr) {
				this.tab_loop_mgr.replaceAll(data.server_list)
			} else {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this._list_item, item_class, data.server_list, LoopScrCon.Vertical)
			}

			let now_world_lv = RoleManager.GetInstance().GetMainRoleVo().worldLv
			let modelNum = data.mod
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine_partition", false)
			let str = ""
			if (modelNum == 8) {
				str = str + "暂未开放下一阶段跨服模式，敬请期待！<br>"
			} else if (cfg) {
				for (let key = 0; key < cfg.length; key++) {
					if (cfg[key].mod_num > modelNum) {
						if (now_world_lv > Number(cfg[key].world_lv)) {
							str = str + "暂未开放下一阶段跨服模式，敬请期待！<br>"
						} else {
							let lv = cfg[key].world_lv > 370 && "神创" + (cfg[key].world_lv - 370) || cfg[key].world_lv
							str = str + "当跨服世界等级达到<font color='#0a953e'>" + lv + "级</font>后开启<font color='#0a953e'>" + cfg[key].mod_name + "</font><br>"
						}
						break
					}
				}
			}
			let level = Number(data.avg_lv) > 370 && "神创" + ((Number(data.avg_lv) - 370)) || data.avg_lv
			str = str + "(当前" + (modelNum == 1 && "本" || modelNum) + "服跨服世界等级为<font color='#0a953e'>" + level + "级</font>)\n"
			this._html_desc.innerHTML = str
		}
	}

	_img_bg: Laya.Image
	_img_close: Laya.Image
	_img_tips: Laya.Image
	_img_bg2: Laya.Image
	_html_desc: Laya.HTMLDivElement
	_html_desc2: Laya.HTMLDivElement
	_list_item: Laya.List
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

window["NineSkyServerView"] = NineSkyServerView