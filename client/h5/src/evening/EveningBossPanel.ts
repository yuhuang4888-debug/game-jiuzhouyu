import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { MainUIModel } from "../commonModel/MainUIModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { EveningBossDamageItem } from "./EveningBossDamageItem"

export class EveningBossPanel extends BaseItem1 {
	boss_damage_dic
	boss_ins_id
	left_List
	left_arrayCollection
	panel_state
	panel_touch
	preload_client_config
	tween_ids1
	tween_ids2
	item_list
	public constructor(parent?) {
		super(parent)
		this.tween_ids1=[]
		this.tween_ids2=[]
		// this.left_List = eui. new List();
		this.panel_touch = false;
		this.panel_state = true;
		this.base_file = "evening"
		this.layout_file = "EveningBossPanel"
		this.load_callback = () => {
			this._panel_gp.visible=false
			this.LoadSuccess()
			this.InitEvent()
			this.display_obj.pos(0, 0)//-120
		}
		this.preload_client_config ={"ClientBossInstruction":false,"ClientBossNeedFight":false}// [ClientBossInstruction=false, ClientBossNeedFight=false]
	}


	public StopAnimate1() {

        if (this.tween_ids1) {
            for (let _ in this.tween_ids1) {
                var key = this.tween_ids1[_]
                SYTweenLite.Stop(key)
            }
            this.tween_ids1 = []
        }
    }

	public StopAnimate2() {

        if (this.tween_ids2) {
            for (let _ in this.tween_ids2) {
                var key = this.tween_ids2[_]
                SYTweenLite.Stop(key)
            }
            this.tween_ids2 = []
        }
    }

	public DeleteMe() {

		// if (this.left_arrayCollection) {
		// 	this.left_arrayCollection.DeleteMe()
		// 	this.left_arrayCollection = null
		// }
		for (let i = 0; i < this.item_list.length; i++) {
			this.item_list[i].DeleteMe()
			this.item_list[i] = null
		}
		this.item_list = []

		if (this.boss_damage_dic) {
			this.boss_damage_dic = null
		}
		this.StopAnimate1()
		this.StopAnimate2()
		super.DeleteMe()
	}

	public InitEvent() {

		Util.AddClickEvent(this._panel_btn, () => {
			this.showpanel(! this.panel_state)
			this.showpanel(false)
		}
			, this, true)

		Util.AddClickEvent(this._box_rank,() => {
				this.ShowRankBtn(false)
			}
			, this, true)

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			this.UpdateBossDamage(monster_id, list)
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.ADD_BOSS_DAMAGE_DATA, (vo?) => {
			this.AddBossDamage(vo)
		}
		)
		this.BindEvent(GlobalEventSystem, EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			this.RemoveDamage(monster_id, list)
		}
		)

		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
			if(!this._panel_gp.visible){
				this._box_rank.visible = ! bool 
			}
			
		})
	}

	public LoadSuccess() {
		this._scroller.vScrollBarSkin=""
		this.initItem()
		this.showpanel(false)
	
	}

	public UpdateBossDamage(monster_id?, list?) {

		if (!this.boss_damage_dic) {
			this.boss_damage_dic = []
		}
		let dic = []
		for (let _tmpi in list) {
			var vo = list[_tmpi]
			dic[vo.player_id] = vo
		}
		this.boss_damage_dic[monster_id] = dic
		this.initItem()
	}

	public AddBossDamage(vo?) {

		let dic = this.boss_damage_dic && this.boss_damage_dic[vo.monster_id]
		if (dic) {
			// [ts2lua]dic下标访问可能不正确
			let data = dic[vo.player_id]
			if (data) {
				data.damage = data.damage + vo.damage
			} else {
				// [ts2lua]dic下标访问可能不正确
				dic[vo.player_id] = vo
			}
			this.initItem()
		}
	}

	public RemoveDamage(monster_id?, list?, all?) {

		if (all == null) {
			all = false
		}
		let dic = this.boss_damage_dic && this.boss_damage_dic[monster_id]
		if (dic) {
			if (all) {
				this.boss_damage_dic[monster_id] = null
			} else {
				for (let _tmpi in list) {
					var data = list[_tmpi]
					if (dic[data.player_id]) {
						dic[data.player_id] = null
					}
				}
			}
			this.initItem()
		}
	}

	public GetDamageList() {

		let list = []
		if (!this.boss_ins_id) {
			return list
		}
		if (this.boss_damage_dic && this.boss_damage_dic[this.boss_ins_id]) {
			let dic = this.boss_damage_dic[this.boss_ins_id]
			let total_damage = 0
			for (let key in dic) {

				// [ts2lua]dic下标访问可能不正确
				let vo = dic[key]
				total_damage = total_damage + vo.damage
				table.insert(list, vo)
			}
			table.sort(list, (a?, b?) => {
				return b.damage < a.damage
			}
			)
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (!vo.damage) {
					vo.modulus = 0
				} else {
					// vo.modulus = (vo.damage * 100 / total_damage):toFixed(2)
					vo.modulus = (vo.damage * 100 / total_damage)
				}
			}
		}
		return list
	}

	public initItem() {

		let dataList =this.GetDamageList()//this.TestData()
		if(!this.item_list)this.item_list=[]

		for (let i = 0; i < dataList.length; i++) {
			let item: EveningBossDamageItem = this.item_list[i]
			if (!item) {
				item = new EveningBossDamageItem(this.Content)
				item.Load()
				this.item_list[i] = item
			}
			item.SetVisible(true)
			item.SetData(dataList[i],i)
		}


		for (let p = this.item_list.length - 1; p >= dataList.length; p--) {
			this.item_list[p].SetVisible(false)
		}


	}

	public TestData(){
		let list=[]
		for(let i=0;i<10;i++){
			let scmd={
				player_name:"Nidadsad",
				modulus:51.22
			}
			list.push(scmd)
		}
		return list
	}

	public showpanel(bool?) {
		this.StopAnimate1()
		this.changePanel(false)
		let id
		if (!bool) {
			this.panel_state = false
			id=SYTweenLite.to(this, this._panel_gp, SYTweenLite.UiAnimationType.ANCHORED_POSX, -this._panel_gp.x - 240, 0.2, () => {
				this.changePanel(true)
				this._box_rank.visible = ! this.panel_state 
				this.ShowRankBtn(true)
				this._panel_gp.visible=false
			})
		} else {
			this.panel_state = true
			this._panel_gp.visible=true
			id=SYTweenLite.to(this, this._panel_gp, SYTweenLite.UiAnimationType.ANCHORED_POSX, 3, MainUIModel.Move_Time_Interval, () => {
				this.changePanel(true)
				this._box_rank.visible = ! this.panel_state 
				
			})
		}
		table.insert(this.tween_ids1,id)
	}

	public ShowRankBtn(is_show?) {
		this.StopAnimate2()
		let id
		if (is_show) {
			id=SYTweenLite.to(this, this._box_rank, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, MainUIModel.Move_Time_Interval, () => {

			})
		} else {
			id=SYTweenLite.to(this, this._box_rank, SYTweenLite.UiAnimationType.ANCHORED_POSX, -this._box_rank.x - this._box_rank.width-8, MainUIModel.Move_Time_Interval, () => {
				this.showpanel(true)
			})
		}
		table.insert(this.tween_ids2,id)
	}

	public changePanel(bool?) {

		if (bool) {
			this.panel_touch = false
		} else {
			this.panel_touch = true
		}
	}

	public SetBossID(id?) {

		this.boss_ins_id = id
	}



_Group3:Laya.Box
_panel_gp:Laya.Box
_Group2:Laya.Box
Image:Laya.Image
_scroller:Laya.Panel
Content:Laya.VBox
_panel_img:Laya.Image
_panel_btn:Laya.Image
Text:Laya.Label
_box_rank:Laya.Box
img_rank:Laya.Image
public GetComponents() {
[
this._Group3,
this._panel_gp,
this._Group2,
this.Image,
this._scroller,
this.Content,
this._panel_img,
this._panel_btn,
this.Text,
this._box_rank,
this.img_rank,
]
 = this.GetChildrenByNames([

"_Group3",
"_panel_gp",
"_Group2",
"Image",
"_scroller",
"Content",
"_panel_img",
"_panel_btn",
"Text",
"_box_rank",
"img_rank",
])
}
}
 window["EveningBossPanel"]= EveningBossPanel