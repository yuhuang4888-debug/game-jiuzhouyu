import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ModuleType } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungDotSubType, LungEvent, LungModel } from "../commonModel/LungModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";

export class LungGridItem extends BaseItem1 {


	public model: LungModel
	public data
	public needRefresh
	state = 0 						 //状态  0 未解锁  1 未镶嵌  2 已经镶嵌
	item: BaseAwardItem
	select_cache
	init_pos
	not_show_red_dot = false
	effect

	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungGridItem"
		this.layer_value = Enum_UILayer.UI;
		this.model = LungModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}
	}
	public DeleteMe() {
		if (this.insert_group)
			Laya.Tween.clearAll(this.insert_group)
		this.not_show_red_dot = false
		this.effect = null
		this.ClearUIEffect(this.effect_con)
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		this.clearBoxUIEffect()
		super.DeleteMe()

	}
	public LoadSuccess() {
		this.init_pos = this.insert_group.y
	}

	public InitEvents() {
		let click_fun = () => {
			if (this.data) {
				if (this.state == 0) {
					Message.show(`神纹总等级${this.data.need_lv}级解锁`)
				} else {
					this.model.Fire(LungEvent.LUNG_CLICK_GRID_ITEM, this.data.pos)
					if (this.state == 1) {
						this.model.Fire(LungEvent.LUNG_OPEN_VIEW, "LungSelectView", 1, this.data.pos)
					}
				}
			}
		}
		Util.AddClickEvent(this.con, click_fun, this, true)

		let grid_fun = (pos) => {
			this.SetSelectBg(this.data && this.data.pos == pos && this.state != 1 && !this.not_show_red_dot)
		}
		this.BindEvent(this.model, LungEvent.LUNG_CLICK_GRID_ITEM, grid_fun)

		let dot_fun = (mType, rType) => {
			if (mType == ModuleType.LUNG_DOT && (rType == LungDotSubType.Insert || rType == LungDotSubType.Upgrade)
				&& !this.not_show_red_dot) {
				this.ShowRedDot()
			}
		}
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, dot_fun)

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_BAG_LIST, () => {
			if (this.use_delete_method) return
			if (this.data && !this.not_show_red_dot) {
				this.ShowRedDot()
			}
		})

		if (this.needRefresh) {
			this.SetData(this.data, this.not_show_red_dot)
			this.needRefresh = null
		}
	}

	public SetData(data, not_show_red_dot?) {
		this.data = data
		this.not_show_red_dot = not_show_red_dot
		if (this.is_loaded) {
			if (!data) return
			let star = 0
			if (!this.model.ThisGridPosIsOpen(this.data.pos)) {	//未开放
				this.state = 0
				this.lv_limit.text = `${this.data.need_lv}级解锁`
				this.clearBoxUIEffect()
			} else {
				let wear = GoodsModel.GetInstance().wear_lung_list[this.data.pos - 1]
				this.state = wear != undefined ? 2 : 1
				if (wear) {
					if (!this.item) {
						this.item = new BaseAwardItem(this.item_con)
						this.item.Load()
						this.item.SetItembgVisible(false)
						this.item.SetItemSize(93, 93)
						this.item.SetShowTips(false)
					}
					this.item.SetData(wear.type_id)
					let [lv, star_num] = this.model.GetLungRealLvAndStar(wear.level)
					star = star_num
					this.lv_label.text = `Lv.${lv}`
					this.star_con.visible = star_num > 0
					this.star_bg.visible = star_num > 0
					this.star_num.text = String(star_num)
					if (star_num > 0) {
						let source = this.model.GetStarBgSource(wear.color)
						if (source) {
							this.star_bg.skin = AtlasUrl("lung", `${source}`)
						}
					}
					let effect = null
					if (wear.color == 3) {
						effect = "UI_1609_02"
					} else if (wear.color == 4) {
						effect = "UI_1609_01"
					} else if (wear.color == 5) {
						effect = "UI_1609_03"
					} else if (wear.color == 2) {
						effect = "UI_1609_04"
					} else if (wear.color == 7) {
						effect = "UI_1609_05"
					}
					if(effect){
						if(effect && this.effect != effect){
							this.ClearUIEffect(this._box_eff)
							this.effect = effect
							this.AddUIEffect(effect, this._box_eff,null,5, true)
						}
					}else{
						this.clearBoxUIEffect()
					}
					
				}else{
					this.clearBoxUIEffect()
				}
			}

			if (this.select_cache != undefined) {
				this.SetSelectBg(this.select_cache)
				this.select_cache = null
			}

			this.lv_limit.visible = this.state == 0
			this.lock_tag.visible = this.state == 0
			this.lv_label.visible = this.state == 2
			this.star_con.visible = this.state == 2 && star > 0
			this.star_bg.visible = this.state == 2 && star > 0
			this.item_con.visible = this.state == 2
			if (!this.not_show_red_dot) {
				this.ShowRedDot()
			}
		} else {
			this.needRefresh = true
		}
	}

	public SetSelectBg(bool) {
		if (this.is_loaded) {
			this.select_bg.visible = bool
		} else {
			this.select_cache = bool
		}
	}

	private clearBoxUIEffect(){
		this.ClearUIEffect(this._box_eff)
		this.effect = null
	}

	//红点
	public ShowRedDot() {
		if (this.is_loaded && this.data.pos && this.state != 0) {
			let dragon_pos_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dragon_pos", false)
			this.red_dot.visible = this.model.CanInsertDot(dragon_pos_cfg, this.data.pos) || this.model.LungCanUpgrade(this.data.pos)
			Laya.Tween.clearAll(this.insert_group)
			this.insert_group.visible = false
			if (this.red_dot.visible && this.state == 1) {
				this.insert_group.y = this.init_pos
				this.insert_group.visible = true
				this.ShowAnimation()
			}
		}
	}

	public ShowAnimation(){
		Laya.Tween.to(this.insert_group, { y: this.init_pos - 20 }, 800, undefined, Laya.Handler.create(this, ()=>{
			this.ShowAnimation2()
		}))
	}

	public ShowAnimation2(){
		Laya.Tween.to(this.insert_group, { y: this.init_pos }, 800, undefined, Laya.Handler.create(this, ()=>{
			this.ShowAnimation()
		}))

	}


con:Laya.Box
_Image1:Laya.Image
goods:Laya.Box
select_bg:Laya.Image
lock_tag:Laya.Image
effect_con:Laya.Box
item_con:Laya.Box
star_bg:Laya.Image
star_con:Laya.HBox
star_num:Laya.Label
_Image2:Laya.Image
lv_label:Laya.Label
lv_limit:Laya.Label
red_dot:Laya.Image
insert_group:Laya.Box
_Label1:Laya.Label
effect_gp:Laya.Box
_box_eff:Laya.Box
public GetComponents() {
[
this.con,
this._Image1,
this.goods,
this.select_bg,
this.lock_tag,
this.effect_con,
this.item_con,
this.star_bg,
this.star_con,
this.star_num,
this._Image2,
this.lv_label,
this.lv_limit,
this.red_dot,
this.insert_group,
this._Label1,
this.effect_gp,
this._box_eff,
]
 = this.GetChildrenByNames([

"con",
"_Image1",
"goods",
"select_bg",
"lock_tag",
"effect_con",
"item_con",
"star_bg",
"star_con",
"star_num",
"_Image2",
"lv_label",
"lv_limit",
"red_dot",
"insert_group",
"_Label1",
"effect_gp",
"_box_eff",
])
}
}
 window["LungGridItem"]= LungGridItem