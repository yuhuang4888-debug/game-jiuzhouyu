import { __values } from "../../node_modules/tslib/tslib";
import { RefBoxChildsLayout, SetSizeDeltaX } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BaseItem1 } from "./BaseItem1"
import { ResManager } from "./ResManager"
import { WithBtnHSlider } from "./WithBtnHSlider";

export class FightingUpItem extends BaseItem1 {
	LoadSuccess
	UpdateView
	Updatefighting
	bitmapFont: Laya.BitmapFont
	onLoaded
	style_
	is_center_x
	is_center_y
	call_back
	gap
	public constructor(parent) {
		super(parent)

		let _fighting = null
		let _load_state = false
		let _need_refresh = false
		this.base_file = "common"
		this.layout_file = "FightingUpItem"
		this.style_=1
		this.gap = 0
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			_load_state = true
			if (_need_refresh) {
				this.UpdateView()
			}

			switch(	this.style_ ){
				case 1:
					this._img_2.width=20
					this._img_2.height=23
					this._img_2.pos(0,1)
					ResManager.GetInstance().SetImageSprite(this,this._img_2,"common","ui_jzl_jt")

					ResManager.GetInstance().LoadFont(this,"view_fight_up_2", this._lb_fighting, null, false, () => {
						if (_fighting) {
							this.Updatefighting(_fighting)
						}
					})
					break;
				case 2:
					this._img_2.pos(0,-3)
					this._img_2.width=26
					this._img_2.height=30
					ResManager.GetInstance().SetImageSprite(this,this._img_2,"common","com_uparrow")


					ResManager.GetInstance().LoadFont(this,"view_fight_up", this._lb_fighting, null, false, () => {
						if (_fighting) {
							this.Updatefighting(_fighting)
						}
					})
					break;
			}

			this.SetCenter()
		}

		this.Updatefighting = (fighting?) => {
			_fighting = fighting
			if (_load_state) {
				this.UpdateView()
			} else {
				_need_refresh = true
			}
		
		}


		this.UpdateView = () => {
			if (!_load_state) {
				return
			}
			let fighting = _fighting

			this._lb_fighting.text = String(fighting)
			RefBoxChildsLayout(this._Group1, this.gap, null, true, "left")

			if(Number(_fighting)>0){
				this._parent.set_width(this._img_2.width+this._lb_fighting.textField.textWidth+this.gap)
			}else{
				this._parent.set_width(0.1)
			}
		
			if(this.call_back)this.call_back()
		}

	}

	public SetLoadCallBack(call_back){
		this.call_back = call_back
	}

	/**更改箭头款式 */
	public SetArrowStype(value){
		this.style_ = value
	}


	public IsCenter(centerx?, centery?) {
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
			this.display_obj.width = this._img_2.width + this._lb_fighting.textField.width +this.gap
			this._parent.width = this.display_obj.width
		}
		if (this.is_center_y) {
			this.display_obj.centerY = 0
		}
	}


	public DeleteMe(): void {
		this.call_back=null
		super.DeleteMe()
	}



	_Group1: Laya.Box
	_img_2: Laya.Image
	_lb_fighting: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._img_2,
			this._lb_fighting,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_img_2",
				"_lb_fighting",
			])
	}
}
window["FightingUpItem"] = FightingUpItem