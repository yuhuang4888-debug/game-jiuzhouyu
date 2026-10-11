import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Enum_ColorUtil_Light } from "../util/ColorUtil";
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util";
import { DungeonPolarRwRenderItem } from "./DungeonPolarRwRenderItem";

export class DungeonPolarBalanceItem extends BaseItem1 {

	//_reward_list
	loop_mgr
	data
	need_fresh
	public WIDTH = 580
	public HEIGT = 150
	public constructor(parent) {
		super(parent)
		this.need_fresh = false
		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarBalanceItem"
		this.load_callback = () => {
			SetHtmlStyle(this._lb_name, { c: "#ffffff", f: 22, ww: false, w: 500 })

			if (this.need_fresh) {
				this.need_fresh = false
				this.dataChanged()
			}
		}

	}

	public DeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}

		super.DeleteMe()
	}

	public SetData(data) {
		this.data = data

		if (this.is_loaded) {
			this.dataChanged()
		} else {
			this.need_fresh = true
		}
	}

	public dataChanged() {
		let list = []
		
		if (this.data.type) {
			if (this.data.type == 1) {
				this._lb_name.innerHTML = "通关奖励"
			} else if (this.data.type == 2) {
				this._lb_name.innerHTML = "助战奖励"
			}
			list = this.data.dun_rewards_list
		} else {
			let boss_name = ""
			let vo = null
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_week_dungeon_boss", false)
			for (let key in cfgs) {

				let cfg = cfgs[key]
				if (cfg.boss_id == this.data.boss_id) {
					vo = cfg
					break
				}
			}
			if (vo) {
				boss_name = vo.boss_name
			}
			let get = this.data.reward_st == 1
			let content = get && "本周首次击杀" + HtmlColorTxt(boss_name, Enum_ColorUtil_Light.GREEN) + "奖励已领取!" || "本周首次击杀" + HtmlColorTxt(boss_name, Enum_ColorUtil_Light.GREEN) + "奖励:"
			this._lb_name.innerHTML = Util.StrToHTML(content)
			list = get && [] || this.data.reward_list
			this.Content.visible = !get
		}

		
		if (list&&list.length>0) {
			//未领取
			//转化格式
			let list_new = []
			for (let p = 0; p < list.length; p++) {
				let obj = list[p]
				//{style: 0, typeId: 7305001, count: 2}
				table.insert(list_new, [obj.style, obj.typeId, obj.count])
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, DungeonPolarRwRenderItem, list_new, LoopScrCon.Horizontal)
			} else {
				this.loop_mgr.replaceAll(list_new)
			}

			this.display_obj.height=150
		}else{
			//已领取
			this.display_obj.height=65
		}



	}


	_Image1: Laya.Image
	_lb_name: Laya.HTMLDivElement
	_Image2: Laya.Image
	Content: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._Image2,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_Image2",
				"Content",
			])
	}
}
window["DungeonPolarBalanceItem"] = DungeonPolarBalanceItem