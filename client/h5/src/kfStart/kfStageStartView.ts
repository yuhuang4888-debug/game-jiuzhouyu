import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { Util } from "../util/Util"
import { kfStageStartItem } from "./kfStageStartItem"

export class kfStageStartView extends BaseView1 {
	model: kfStageModel
	data
	cfg_server_mod
	sever_list_loop: LoopScrowViewMgr

	public constructor() {
		super()
		this.base_file = "kfStart"
		this.layout_file = "kfStageStartView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_sever_mod": false
		}

		this.model = kfStageModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			if (this.sever_list_loop) {
				this.sever_list_loop.DeleteMe()
				this.sever_list_loop = null
			}
		}
	}

	private LoadSuccess() {
		this.cfg_server_mod = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sever_mod", false)

		this._gp_con.vScrollBarSkin = ""

		this._lb_tips.style.fontSize = 18
		this._lb_tips.style.color = "#663915"
		this._lb_tips.style.wordWrap = false
		this._lb_tips.innerHTML = "每日<font color='#0a953e'>04:00</font>自动变更服务器模式"
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)

		this.BindEvent(this.model, kfStageModel.CLOSE_VIEW, () => {
			this.Close()
		})
	}

	public Open(...new_args) {
		this.data = new_args[0]
		super.Open()
	}

	private InitView() {
		if (!this.data) {
			return
		}

		let cur_mod = this.data.mod
		let next_mod = this.model.GetNextMod(cur_mod)
		ResManager.GetInstance().SetImageSprite(this, this._img_curNum, "kfStart", "mod_" + cur_mod)
		if (next_mod) {
			this._img_none.visible = false
			this._img_tips2.visible = true
			this._img_nextNum.visible = true
			if (this.data.module_id == 204) {
				next_mod = 8
			}
			ResManager.GetInstance().SetImageSprite(this, this._img_nextNum, "kfStart", "mod_" + next_mod)
		} else {
			this._img_none.visible = true
			this._img_tips2.visible = false
			this._img_nextNum.visible = false
		}
		this.UpdateStage(next_mod)


		let add_obj={}
		let list_cur = this.DealList(this.data.server_ids,add_obj,true)
		let list_add = this.DealList(this.data.next_server_ids,add_obj,false)
		let server_list = list_cur.concat(list_add)

		if (!this.sever_list_loop) {
			this.sever_list_loop = new LoopScrowViewMgr()
			this.sever_list_loop.SetData(this._gp_con, kfStageStartItem, server_list, LoopScrCon.Vertical)
		} else {
			this.sever_list_loop.replaceAll(server_list)
		}

	}


	private DealList(list, add_obj,is_check) {
		let list_ = []
		let server_info = null
		for (let i = 0; i < list.length; i++) {
			server_info = this.model.GetServerInfoBySid(list[i].server_id)
			if(!server_info)continue
			if(is_check){
				add_obj[list[i].server_id]=1
			}else{
				if(add_obj[list[i].server_id]){
					continue
				}
			}

			list_.push({
				server_name: server_info.server_name,
				server_id: server_info.server_num,
				is_next_add: !is_check,
				world_lv: server_info.world_lv
			})
		}

		if(list_&&list_.length>0){
			list_.sort((a,b)=>{
				return a.server_id - b.server_id
			})
		}

		return list_
	}

	private UpdateStage(next_mod) {
		if (!next_mod) {
			this._gp_condition.visible = false
			this._lb_none.visible = true
			return
		}
		this._gp_condition.visible = true
		this._lb_none.visible = false

		let key = this.data.module_id + "@" + next_mod
		let cfg = this.cfg_server_mod[key]
		if (cfg) {
			let lv = Number(cfg.min_world_lv)
			let open = Number(cfg.open_day)
			let color1 = this.data.avg_lv >= lv ? "#0a953e" : "#ff4f50"
			let color2 = this.model.open_day >= open ? "#0a953e" : "#ff4f50"
			this._lb_stage1.color = color1
			this._lb_stage2.color = color2
			this._img_done1.visible = this.data.avg_lv >= lv
			this._img_done2.visible = this.model.open_day > open
			this._lb_con1.text = "跨服世界等级达到" + lv + "级"
			this._lb_stage1.text = "(" + this.data.avg_lv + "/" + lv + ")"
			this._lb_con2.text = "本服开服天数大于等于" + open + "天"
			this._lb_stage2.text = "(" + this.model.open_day + "/" + open + ")"
		}
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_img_arrow: Laya.Image
	_img_cur: Laya.Image
	_img_tips1: Laya.Image
	_img_curNum: Laya.Image
	_img_next: Laya.Image
	_img_tips2: Laya.Image
	_img_none: Laya.Image
	_img_nextNum: Laya.Image
	_img_title2: Laya.Image
	_lb_title2: Laya.Label
	_gp_con: Laya.List
	_img_tips: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_gp_condition: Laya.Box
	_gp_one: Laya.HBox
	_lb_con1: Laya.Label
	_lb_stage1: Laya.Label
	_img_done1: Laya.Image
	_gp_two: Laya.HBox
	_lb_con2: Laya.Label
	_lb_stage2: Laya.Label
	_img_done2: Laya.Image
	_lb_none: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_title,
			this._lb_title,
			this._btn_close,
			this._img_arrow,
			this._img_cur,
			this._img_tips1,
			this._img_curNum,
			this._img_next,
			this._img_tips2,
			this._img_none,
			this._img_nextNum,
			this._img_title2,
			this._lb_title2,
			this._gp_con,
			this._img_tips,
			this._lb_tips,
			this._gp_condition,
			this._gp_one,
			this._lb_con1,
			this._lb_stage1,
			this._img_done1,
			this._gp_two,
			this._lb_con2,
			this._lb_stage2,
			this._img_done2,
			this._lb_none,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_title",
				"_lb_title",
				"_btn_close",
				"_img_arrow",
				"_img_cur",
				"_img_tips1",
				"_img_curNum",
				"_img_next",
				"_img_tips2",
				"_img_none",
				"_img_nextNum",
				"_img_title2",
				"_lb_title2",
				"_gp_con",
				"_img_tips",
				"_lb_tips",
				"_gp_condition",
				"_gp_one",
				"_lb_con1",
				"_lb_stage1",
				"_img_done1",
				"_gp_two",
				"_lb_con2",
				"_lb_stage2",
				"_img_done2",
				"_lb_none",
			])
	}
}
window["kfStageStartView"] = kfStageStartView