import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { GameResPath } from "../util/GameResPath"
import { RefBoxChildsLayout, RefBoxVLayout, RefGridLayout } from "../util/Util"
import { GuildIdolRuneSmallItem } from "./GuildIdolRuneSmallItem"

export class GuildIdolRuneMasterItem extends BaseItemRenderer {
	_model
	item_list

	public WIDTH = 155
	public HEIGT = 210
	layer_value: any
	select_status: any

	is_set
	is_wait
	num_cell=0
	num_sum=0
	public constructor(parent) {
		super()
		this.is_set = false
		this.is_wait=false
		this.item_list = []
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneMasterItem"
		this.layer_value = Enum_UILayer.Activity
		this._model = GuildModel.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
			if(this.is_wait){
				this.is_wait=false
				this.updateRed()
			}

		}
		this.Load()
	}

	public LoadSuccess() {

		this.BindEvent(this._model, GuildEvent.IDOL_CHANGE_COMBO_ID, () => {
			if(!this.is_loaded){
				this.is_wait=true
				return
			}
			this.updateRed()
		}
		)

		if (!this.is_set) {
			this.SetData()
			this.is_set = true
		}
	}

	public DeleteMe() {

		for (let key in this.item_list) {

			let item = this.item_list[key]
			item.DeleteMe()
		}
		this.item_list = []
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		if (this.is_loaded) {
			this.is_set = true
			this.SetData()
		} else {
			this.is_set = false
		}

	}

	SetData() {
		if (!this.data) return
		this._lb_name.text = this.data.name
		this._select.visible = this.selected
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetSkillIconPath(this.data.icon))
		let condition_list = JSON.parse(this.data.condition)
		let index = 0
		this.num_sum=0
		for (let key in condition_list) {

			let condition = condition_list[key]
			let color = Number(condition[0])
			let num = Number(condition[1])
			let cfg = this._model.IdolRune_Master_Goods[color]

			this.num_sum+=num
			if (cfg) {
				let type_id = cfg.type_id
				for (let i = index; i < index + num; i++) {
					let item = this.item_list[i]
					if (!item) {
						item = new GuildIdolRuneSmallItem(this._gp_item)
						item.Load()
						item.SetScale(0.55)

						item.ExcuteCallback(() => {
							this.num_cell++
							if(this.num_cell>=this.num_sum){
								RefGridLayout(this._gp_item, {
									column: 3,
									h_gap: 0,
									v_gap: 5,
									item_w: 40,
									item_h: 25,
									frist_item_space:1
								})
							}
													
						})


						table.insert(this.item_list, item)
					}
					item.setData(type_id, false,false,true)
				}
				index = num 
			}
		}

		RefBoxVLayout


		this.updateRed()
	}

	public updateRed() {
		if(!this.data){
			this._red.visible=false
			return
		}
		let combo_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_combo
		let god_id = this._model.RunePos.god_id
		let runeData = this._model.IdolRune[god_id]
		if (runeData) {
			let better = this.data.combo_id > runeData.combo_id
			let red_bool = better && this._model.runeMasterBetterByComId(this.data.god_id, this.data.combo_id, combo_cfg)
			this._red.visible = red_bool
		}
	}


_Image1:Laya.Image
_img_22:Laya.Image
_lb_name:Laya.Label
_img:Laya.Image
_select:Laya.Image
_gp_item:Laya.Box
_red:Laya.Image
public GetComponents() {
[
this._Image1,
this._img_22,
this._lb_name,
this._img,
this._select,
this._gp_item,
this._red,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_22",
"_lb_name",
"_img",
"_select",
"_gp_item",
"_red",
])
}
}
 window["GuildIdolRuneMasterItem"]= GuildIdolRuneMasterItem