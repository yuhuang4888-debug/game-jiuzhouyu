import { Alert, Alert_Type } from "../alert/Alert";
import { BaseView1, OpenMode } from "../common/BaseView1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SkillVo } from "../skill/SkillVo";
import { TopVipShopItem } from "../topVip/TopVipShopItem";
import { Enum_ColorUtil_Light } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { Status } from "../util/Status";
import { SYTweenLite } from "../util/SYTweenLite";
import { Util, SetAnchoredPositionY, HtmlColorTxt } from "../util/Util";
import { DemonSecondView } from "./DemonSecondView";
import { DemonTalentItem } from "./DemonTalentItem";
import { DemonTalentSelectItem } from "./DemonTalentSelectItem";
import { DemonTalentSelectShow } from "./DemonTalentSelectShow";

export class DemonTalentSelectView extends BaseView1 {
	demon_data
	demon_id
	demon_model: DemonModel
	has_learned
	item_data_list
	item_loop_mgr
	now_index
	open_mode
	select_center
	select_data
	select_skill_id
	show_bottom_item
	show_ceneter
	show_level
	show_top_item
	slot
	talent_item
	tween_list
	res_mgr
	ac_list
	list_loop_mgr
	fight_item:FightingShowSmallItem
	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonTalentSelectView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.show_top_item = null
		this.show_bottom_item = null
		this.talent_item = null
		this.select_skill_id = null
		this.now_index = null
		this.show_level = 1
		this.has_learned = false
		this.select_center = 180
		this.show_ceneter = -177

		this.load_callback = () => {
			this._lb_link.style.fontSize=20
			this._lb_link.style.color="#0a953e"
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public InitEvent() {
		let last_click_time = 0
		Util.AddClickEvent(this._btn_study, () => {
			if (Status.NowTime - last_click_time > 1) {
				last_click_time = Status.NowTime
				let send = () => {
					this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18310, this.demon_data.demon_id, this.slot, this.select_data.type_id)
				}

				let data = this.demon_model.GetTalentData(this.slot, this.demon_data.talent_dic)
				if (data) {
					if (this.select_skill_id != data.sk_id && !this.demon_model.not_show_talent_replace_skill_tips) {
						Alert.Show("学习新的天赋技能书将会替代旧的技能，是否继续？", Alert_Type.AlertTypeCheckBox, send, null, "确定", "取消", null, false, () => {
							this.demon_model.not_show_talent_replace_skill_tips = true
						}, "本次登录不再提示")
					} else {
						send()
					}
				} else {
					send()
				}
			}
		}, this, true)

		Util.AddClickEvent(this._lb_link_click, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonSecondView", DemonSecondView.Index.Shop)
			this.Close()
		}, this)

		this.BindEvent(this.demon_model, DemonEvent.TALENT_FIGHT_RETURN, (sign?, sk_id?, sk_lv?) => {
			if (!this.select_data) {
				return
			}
			if (sign == 0 && sk_id == this.select_skill_id && this.show_level == sk_lv) {
				this.UpdateFight()
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.TALENT_UP_RETURN, (demons_id?, slot?) => {
			if (this.slot == slot && this.demon_data.demon_id == demons_id) {
				this.demon_data = this.demon_model.GetDemonData(demons_id)
				this.UpEffect()
			}
		})
	}

	public Remove() {
		if (this.show_top_item) {
			this.show_top_item.DeleteMe()
			this.show_top_item = null
		}
		if (this.show_bottom_item) {
			this.show_bottom_item.DeleteMe()
			this.show_bottom_item = null
		}
		if (this.talent_item) {
			this.talent_item.DeleteMe()
			this.talent_item = null
		}

		// if (this._list) {
		// 	this._list.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchItem, this);
		// }

		Laya.Tween.clearAll(this._gp_select);
		Laya.Tween.clearAll(this._gp_show);
		Laya.Tween.clearAll(this._gp_bottom);
		Laya.Tween.clearAll(this._gp_top);

		// this.ClearUIEffect(this._gp_arrow_effect);

		this.select_data = null
		this.slot = null
		this.demon_data = null

		this.now_index = null
		this.demon_model.select_demon_data = null
		this.demon_model.select_slot = null
	}

	public LoadSuccess() {
		this.fight_item = new FightingShowSmallItem(this._gp_fight)
		this.fight_item.Load()
		this.fight_item.IsCenter(true, false)
		
		this._lb_link.width=300
		this._lb_link.innerHTML = Util.StrToHTML(`<a href='event:142@1'>前往获取</a>`)

		this.demon_data = this.demon_model.GetDemonData(this.demon_id)

		this.demon_model.select_demon_data = this.demon_data

		this.demon_model.select_slot = this.slot
		this.has_learned = false
		let talent_data = this.demon_data.GetTalentData(this.slot)
		if (talent_data) {
			this.has_learned = true
			this.UpdateTopShow(talent_data.sk_id)
		}
		if (!this.talent_item) {
			this.talent_item = new DemonTalentItem(this._gp_select_item)
			this.talent_item.Load()
		}
		this.UpdateTalentBag()
		this.InitEvent()
	}

	public UpdateTopShow(skill_id?, is_pre_view?) {
		if (!this.show_top_item) {
			this.show_top_item = new DemonTalentSelectShow(this._gp_top)
			this.show_top_item.Load()
		}
		this.show_top_item.SetData(this.demon_data, this.slot, skill_id, is_pre_view)

		if (this._gp_show.centerX != this.show_ceneter) {
			// this.show_top_item.ExcuteCallback(()=>{
				this.OpenEffect() 
			// })
		}
	}

	public UpdateBottomShow(skill_id?, is_pre_view?) {
		if (this.select_data) {
			this._img_arrow.visible=this._gp_bottom.visible = true
			if (!this.show_bottom_item) {
				this.show_bottom_item = new DemonTalentSelectShow(this._gp_bottom)
				this.show_bottom_item.Load()
			}
			this.show_bottom_item.SetData(this.demon_data, this.slot, skill_id, is_pre_view)
			this.SelectEffect()
		} else {
			this._img_arrow.visible=this._gp_bottom.visible = false
		}
	}

	public UpdateTalentBag() {
		let list = GoodsModel.GetInstance().demontalent_bag_list

		let talent_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false);
		list.sort((a, b) => {
			let acfg = this.demon_model.GetTalentCfgByTypeId(a.type_id, talent_cfgs)
			let bcfg = this.demon_model.GetTalentCfgByTypeId(b.type_id, talent_cfgs)
			if (acfg.quality == bcfg.quality) {
				return acfg.skill_id - bcfg.skill_id
			} else {
				return bcfg.quality - acfg.quality
			}
		})

		this._gp_null.visible = list.length == 0

		if (!this.list_loop_mgr) {
			// this.ac_list = new Laya.ArrayCollection(list)
			// this._list.dataProvider = this.ac_list
			// this._list.itemRenderer = DemonTalentSelectItem
			// this._list.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SwitchItem, this);
			this.list_loop_mgr=new LoopScrowViewMgr()
			this.list_loop_mgr.SetData(this._Scroller1,DemonTalentSelectItem,list,LoopScrCon.Vertical,undefined,(index?)=>{
				this.SwitchItem(index)
			})
			this._Scroller1.selectedIndex=0
			this.SwitchItem(0)
		} else {
			// if (list.length <= 0)
			// 	this.ac_list.source = list;
			// else
				// this.ac_list.replaceAll(list);
				this.list_loop_mgr.replaceAll(list)
		}

		this.item_data_list = list
	}

	public SwitchItem(e?) {
		let index = e
		if (this.now_index == index || !this.list_loop_mgr.parent.array) {
			return
		}
		// let data = this.item_data_list && this.item_data_list[index]
		let data = this.list_loop_mgr.parent.array[e]
		if (!data) {
			this.fight_item.SetVisible(false)
			return
		}
		let talent_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false)
		let cfg = this.demon_model.GetTalentCfgByTypeId(data.type_id, talent_cfgs)
		let talent_data = this.demon_data.GetTalentData(this.slot)
		if (cfg && talent_data) {
			if (cfg.skill_id == talent_data.sk_id) {
				if (new SkillVo(cfg.skill_id).GetTotalLevel() == talent_data.sk_lv) {
					let last_index = this.now_index != null && this.now_index >= 0 ? this.now_index : -1
					this._Scroller1.selectedIndex = last_index
					return
				}
			}
		}

		this.now_index = index

		this.select_data = data
		this.UpdateView()

		if (this.has_learned) {
			this.UpdateBottomShow(cfg.skill_id, true)
		} else {
			this.UpdateTopShow(cfg.skill_id, true)
		}
		return true

	}

	public UpdateView() {
		if (this.select_data) {
			let select_data = this.select_data

			this.fight_item.SetVisible(true)
			this._btn_study.visible = true
			this._gp_name.y = 33
			let talent_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false)
			let talent_data = this.demon_data.GetTalentData(this.slot)
			let cfg = this.demon_model.GetTalentCfgByTypeId(select_data.type_id, talent_cfgs)

			this.select_skill_id = cfg.skill_id

			let skill_vo = new SkillVo(this.select_skill_id)

			let now_level, next_level
			let show_level
			let quality_cond = true

			if (talent_data && talent_data.sk_id == cfg.skill_id) {
				now_level = talent_data.sk_lv
				show_level = now_level
			} else {
				if (talent_data) {
					quality_cond = talent_cfgs[cfg.skill_id].quality >= talent_cfgs[talent_data.sk_id].quality
				}
				now_level = 0
				show_level = 1
			}

			this.show_level = show_level

			next_level = now_level + 1
			let is_max_level = skill_vo.GetTotalLevel() == now_level

			let is_learned = (!is_max_level && now_level!=0)

			this.labelDisplay.text = is_learned && "升级" || "学习"
			this.talent_item.SetData(this.demon_data, this.slot, select_data.type_id)
			let can_level_up = false
			if (!is_max_level) {
				let lv_data = skill_vo.getLevelVo(next_level)
				if (lv_data) {

					let conf = ErlangParser.GetInstance().parse(lv_data.condition)
					let arr = conf && conf[0] || [0, 0, 0]
					let need_count = Number(arr[2])
					let my_count = this.demon_model.GetTalenGoodsNum(select_data.type_id)
					can_level_up = my_count >= need_count
					this.talent_item.ShowNum(HtmlColorTxt(" " + my_count + "/" + need_count, can_level_up && Enum_ColorUtil_Light.GREEN || Enum_ColorUtil_Light.RED))
				}
			} else {
				this.talent_item.ShowNum("")
			}

			this._red_dot.visible =this.demon_model.TalentSelectRedDot(select_data.type_id,this.slot,this.demon_data.demon_id,talent_cfgs,true)
			// this._red_dot.visible = !is_learned?(!is_max_level && can_level_up && quality_cond):true

			this._lb_name.text = "LV" + show_level + "." + skill_vo.getName() + " "
			this.UpdateFight()
		} else {
			this.fight_item.SetVisible(false)
			this._btn_study.visible = false
			this._red_dot.visible = false
			this._gp_name.y = 33
			this._lb_name.text = "选择需要学习的技能"
			this.talent_item.ExcuteCallback(() => {
				this.talent_item.ResetItem()
			})

			this.talent_item.ShowNum(" ")
		}
	}

	public UpdateFight() {
		let data = this.demon_model.GetTalentData(this.slot, this.demon_data.talent_dic)
		let talent_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false)
		let cfg = this.demon_model.GetTalentCfgByTypeId(this.select_data.type_id, talent_cfgs)
		let fight_data = this.demon_model.GetTalentFight(this.demon_data.demon_id, 0, cfg.skill_id, this.show_level, this.select_data.type_id)
		if (fight_data) {
			this.fight_item.Updatefighting(fight_data.power)
		}
	}

	public OpenEffect() {
		// Laya.Tween.get(this._gp_select).to({ horizontalCenter: this.select_center }, 300);
		Laya.Tween.to(this._gp_select,{ centerX: this.select_center },300)
		// Laya.Tween.get(this._gp_show).to({ horizontalCenter: this.show_ceneter }, 300);
		Laya.Tween.to(this._gp_show,{ centerX: this.show_ceneter },300)
	}

	public SelectEffect() {
		// this.AddUIEffect("ui_Pokemon_frame_arrows", this._gp_arrow_effect, { x: 50, y: 17 }, null, true);
	}

	public UpEffect() {
		// this.ClearUIEffect(this._gp_arrow_effect)

		// Laya.Tween.get(this._gp_bottom).to({ y: 0 }, 200).call(() => {
		// 	this._gp_bottom.visible = false;
		// 	this._gp_bottom.y = 227;
		// });
		Laya.Tween.to(this._gp_bottom,{ y: 0 },200,undefined,Laya.Handler.create(this,()=>{
			this._gp_bottom.visible = false;
			this._gp_bottom.y = 227;
		}))
		// Laya.Tween.get(this._gp_top).to({ y: -193, alpha: 0 }, 200).call(() => {
		// 	this.UpdateTalentBag()
		// 	this._gp_top.y = 0;
		// 	this._gp_top.alpha = 1;

		// 	if (!this.select_data) { return }
		// 	let my_count = this.demon_model.GetTalenGoodsNum(this.select_data.type_id)

		// 	this.select_data = null

		// 	if (my_count > 0) {
		// 		let index = this.now_index
		// 		this.now_index = null
		// 		if (!this.SwitchItem(index)) {
		// 			this.UpdateView()
		// 		}
		// 	} else {
		// 		this.now_index = -1
		// 		this._list.selectedIndex = -1
		// 		this.UpdateView()
		// 	}

		// 	let talent_data = this.demon_data.GetTalentData(this.slot)
		// 	if (talent_data) {
		// 		this.has_learned = true
		// 		this.UpdateTopShow(talent_data.sk_id)
		// 		if (this.select_skill_id == talent_data.sk_id) {
		// 			this.UpdateBottomShow(talent_data.sk_id, true)
		// 		}
		// 	}
		// })
		Laya.Tween.to(this._gp_top,{ y: -193, alpha: 0 },200,undefined,Laya.Handler.create(this,()=>{
			this.UpdateTalentBag()
			this._gp_top.y = 0;
			this._gp_top.alpha = 1;

			if (!this.select_data) { return }
			let my_count = this.demon_model.GetTalenGoodsNum(this.select_data.type_id)

			this.select_data = null

			if (my_count > 0) {
				let index = this.now_index
				this.now_index = null
				if (!this.SwitchItem(index)) {
					this.UpdateView()
				}
			} else {
				this.now_index = -1
				this._Scroller1.selectedIndex = -1
				this.UpdateView()
			}

			let talent_data = this.demon_data.GetTalentData(this.slot)
			if (talent_data) {
				this.has_learned = true
				this.UpdateTopShow(talent_data.sk_id)
				if (this.select_skill_id == talent_data.sk_id) {
					this.UpdateBottomShow(talent_data.sk_id, true)
				}
			}
		}))
	}

	public Open(...parms) {
		this.slot = parms[0]
		this.demon_id = parms[1]
		super.Open()
	}


_gp_show:Laya.Box
_gp_top:Laya.Box
_gp_bottom:Laya.Box
_img_arrow:Laya.Image
_gp_arrow_effect:Laya.Box
_gp_select:Laya.Box
_Image1:Laya.Image
_gp_select_item:Laya.Box
_Image2:Laya.Image
_gp_name:Laya.Box
_Image3:Laya.Image
_lb_name:Laya.Label
_gp_fight:Laya.Box
_gp_btn:Laya.Box
_btn_study:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
_red_dot:Laya.Image
_Scroller1:Laya.List
_Label1:Laya.Label
_Label2:Laya.Label
_gp_null:Laya.Box
_Image4:Laya.Image
_Label3:Laya.Label
_lb_link_click:Laya.Box
_lb_link:Laya.HTMLDivElement
public GetComponents() {
[
this._gp_show,
this._gp_top,
this._gp_bottom,
this._img_arrow,
this._gp_arrow_effect,
this._gp_select,
this._Image1,
this._gp_select_item,
this._Image2,
this._gp_name,
this._Image3,
this._lb_name,
this._gp_fight,
this._gp_btn,
this._btn_study,
this._Image11,
this.labelDisplay,
this._red_dot,
this._Scroller1,
this._Label1,
this._Label2,
this._gp_null,
this._Image4,
this._Label3,
this._lb_link_click,
this._lb_link,
]
 = this.GetChildrenByNames([

"_gp_show",
"_gp_top",
"_gp_bottom",
"_img_arrow",
"_gp_arrow_effect",
"_gp_select",
"_Image1",
"_gp_select_item",
"_Image2",
"_gp_name",
"_Image3",
"_lb_name",
"_gp_fight",
"_gp_btn",
"_btn_study",
"_Image11",
"labelDisplay",
"_red_dot",
"_Scroller1",
"_Label1",
"_Label2",
"_gp_null",
"_Image4",
"_Label3",
"_lb_link_click",
"_lb_link",
])
}
}
 window["DemonTalentSelectView"]= DemonTalentSelectView