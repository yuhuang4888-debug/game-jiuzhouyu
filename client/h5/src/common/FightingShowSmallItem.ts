import { PlatformManager } from "../PlatformManager";
import { RefBoxChildsLayout, SetSizeDeltaX } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BaseItem1 } from "./BaseItem1"
import { FightingUpItem } from "./FightingUpItem";
import { ResManager } from "./ResManager"
import { WithBtnHSlider } from "./WithBtnHSlider";

export class FightingShowSmallItem extends BaseItem1 {
	FontLoadSuccess
	UpdateView
	Updatefighting
	Font_name: string = "view_fight_normal"
	bitmapFont: Laya.BitmapFont
	onLoaded
	is_center_x
	is_center_y
	is_offset=true


	//战力提升
	UpdatefightingUp
	fight_item_up: FightingUpItem
	f_up_cache = 0
	f_need_fresh = false
	u_need_fresh = false
	gap = 5
	is_font_load=false
	_box_up_width = 0.1

	public constructor(parent) {
		super(parent)

		let _fighting = null
		let _load_state = false
		let _need_refresh = false
		this.base_file = "common"
		this.layout_file = "FightingShowSmallItem"
		this.load_callback = () => {	
			if(PlatformManager.IsEyouEnPlatform()){
				this._img_2.pos(0,1)
				this._img_2.width = 35
				this._img_2.height = 23
			}
			ResManager.GetInstance().LoadFont(this, this.Font_name, this._lb_fighting, null, false, () => {
				this.FontLoadSuccess()
			})
		}

		this.FontLoadSuccess = () => {
			_load_state = true
			this._box_up.width=this._box_up_width
			if (_need_refresh) {
				this.UpdateView(true)
			}

			if (this.f_need_fresh) {
				this.UpdatefightingUp(this.f_up_cache)
				this.f_need_fresh = false
			}

			if(this.u_need_fresh){
				this.u_need_fresh =false
				this.UpdateLayouts()
			}
			this.SetCenter()
		}

		/***需要在Updatefighting使用*/
		this.UpdatefightingUp = (fighting?) => {
			this.f_up_cache = fighting
			if (!this.is_loaded) {
				this.f_need_fresh = true
				return
			}
			this._box_up.visible = fighting > 0
			if (fighting > 0) {
				if (!this.fight_item_up) {
					this.fight_item_up = new FightingUpItem(this._box_up)
					this.fight_item_up.IsCenter(true, false)
					this.fight_item_up.Load()
					this.fight_item_up.SetLoadCallBack(()=>{
						this.UpdateLayouts()
					})
				}
				this.fight_item_up.Updatefighting(fighting)
				this.fight_item_up.SetCenter()
			}else{
				this._box_up.width=this._box_up_width
				this.UpdateLayouts()
			}
	
		}


		/**设置Updatefighting后需要重新设置UpdatefightingUp */
		this.Updatefighting = (fighting?) => {
			_fighting = fighting
			if (_load_state) {
				this.UpdateView()
			} else {
				_need_refresh = true
			}
		}


		this.UpdateView = (is_frist?) => {
			if (!_load_state) {
				return
			}
			
			//清空up数字
			if(!is_frist){
				this.UpdatefightingUp(0)
			}
		

			let fighting = _fighting
			this._lb_fighting.text = String(fighting)

			let t_w = this._img_2.width + this._lb_fighting.textField.width + this.gap
			this._Group1.width = t_w

			this.UpdateLayouts()
		}

	}

	public UpdateLayouts(){
		
		if(this.is_loaded){
		
			
			if(this.is_offset){
				//需要偏移
				if(this._box_up.width>=this._box_up_width){
					RefBoxChildsLayout(this._Group1, this.gap, null, false, "left")
					let p_x = (this.display_obj.width-(this._Group1.width + this.gap + this._box_up.width))/2
					this._Group1.x= p_x
					this._box_up.x = p_x + this._Group1.width + this.gap
				}else{
					RefBoxChildsLayout(this._Group1, this.gap, null, false, "center")
				}
			
			}else{
				this._Group1.width = 244
				RefBoxChildsLayout(this._Group1, this.gap, null, false, "center")
				this._box_up.x = this._lb_fighting.x + this._lb_fighting.textField.width + this.gap
			}
		
		}else{
			this.u_need_fresh = true
		}

	}

	public IsCenter(centerx?, centery?,is_offset?) {

		this.is_offset =is_offset==null?true:is_offset


		if (centerx) {
			this.is_center_x = true
		}
		if (centery) {
			this.is_center_y = true
		}
		this.SetCenter()
	}
	public SetCenter() {
		if (!this.display_obj) {
			return
		}
		if (this.is_center_x) {
			this.display_obj.centerX = 0
		}
		if (this.is_center_y) {
			this.display_obj.centerY = 0
		}
		// this._img.x = 0;
	}

	public DeleteMe(): void {
		if (this.fight_item_up) {
			this.fight_item_up.DeleteMe()
			this.fight_item_up = null
		}
		super.DeleteMe()
	}

	public SetPowerOffset(offset: number): void {
		// this.display_obj.centerX = -offset;
		// this._img.x = offset;
	}


	_gp_fire_effect: Laya.Box
	_img: Laya.Image
	_Group1: Laya.Box
	_img_2: Laya.Image
	_lb_fighting: Laya.Label
	_box_up: Laya.Box
	public GetComponents() {
		[
			this._gp_fire_effect,
			this._img,
			this._Group1,
			this._img_2,
			this._lb_fighting,
			this._box_up,
		]
			= this.GetChildrenByNames([

				"_gp_fire_effect",
				"_img",
				"_Group1",
				"_img_2",
				"_lb_fighting",
				"_box_up",
			])
	}
}
window["FightingShowSmallItem"] = FightingShowSmallItem