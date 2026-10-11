import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PetCrystalView } from "../pet/PetCrystalView"
import { GameResPath } from "../util/GameResPath"
import { Util, SetAnchoredPositionY } from "../util/Util"
import { PartnerModel } from "../commonModel/PartnerModel"
import { FightingUpItem } from "../common/FightingUpItem"


export class PartnerNucleusItem extends BaseItem1 {
	_bg: Laya.Image
	effect: Laya.Box
	icon: Laya.Image
	num: Laya.Label
	gp_up: Laya.HBox
	up_num: Laya.Label
	image: Laya.Image

	cache_posy
	can_use
	crystal_view
	model
	need_refresh
	pet_type
	data
	fight_item_up: FightingUpItem

	public constructor(parent?) {
		super(parent)

		this.base_file = "partner"
		this.layout_file = "PartnerNucleusItem"
		this.layer_value = Enum_UILayer.UI
		this.model = PartnerModel.GetInstance()
		this.load_callback = () => {
			this.Load_callback()
		}
	}

	public Load_callback() {
		this.image.visible = false
		this.up_num.visible = false
		this.cache_posy = this.gp_up.y
		this.InitEvent()
		if (this.need_refresh) {
			this.InitView()
			this.need_refresh = false
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.icon, () => {
			if (this.can_use) {
				this.model.Fire(PartnerModel.REQUSET_SCMD, 14206, this.pet_type)
			} else {
				let data = this.data
				if (data) {
					if (!this.crystal_view) {
						this.crystal_view = new PetCrystalView()
					}
					let goods_count = this.num.text + "/" + data.train_limit
					this.crystal_view.SetData(Number(data.train_goods_id))
					this.crystal_view.SetSmeltStr(goods_count)
					this.crystal_view.Open()
				}

			}
		}, this, true)

		this.BindEvent(this.model, PartnerModel.UPDATE_NUCLEUS, (pet_type?) => {
			if (this.pet_type == pet_type) {
				this.AddUIEffect("UI_1404", this.effect)
			}
		})

	}

	public SetCanUseCount (parent?, num?) {
		if (!this.fight_item_up) {
			this.fight_item_up = new FightingUpItem(parent)
			this.fight_item_up.IsCenter(true, false)
			this.fight_item_up.Load()
		}

		if (num) {
			this.fight_item_up.Updatefighting(num)
			this.fight_item_up.SetCenter()
		} else {
			this.fight_item_up.Updatefighting(0)
		}
	}

	public RefNum() {
		let data = this.data
		if (data) {
			let info = this.model.GetInfoByID(this.data.id)
			this.num.text = info.train_num
			let num = 0
			if (info.is_active == 1) {
				num = GoodsModel.GetInstance().GetTypeGoodsNum(data.train_goods_id)
				this.can_use = num > 0 && info.train_num < data.train_limit
			} else {
				this.can_use = false
			}
			this.gp_up.visible = this.can_use
			Laya.Tween.clearAll(this.gp_up)

			this.gp_up.y = this.cache_posy
			if (this.can_use) {
				this.SetCanUseCount(this.gp_up, num)
				// this.up_num.text = "+" + num
				// Laya.Tween.get(this.gp_up, { loop: true }).to({ y: -13 }, 750).to({ y: 3 }, 750)
				Laya.Tween.to(this.gp_up,{},1,undefined,Laya.Handler.create(this,()=>{
					this.Tween_1()
				}))
			}
		}
	}
	public Tween_1(){
		Laya.Tween.to(this.gp_up, { y: -13 }, 750, undefined, Laya.Handler.create(this, () => {
			Laya.Tween.clearAll(this.gp_up)
			this.Tween_2()
		}))
	}

	public Tween_2(){
		Laya.Tween.to(this.gp_up, { y: 3 }, 750,undefined,Laya.Handler.create(this,()=>{
			Laya.Tween.clearAll(this.gp_up)
			this.Tween_1()
		}))
	}
	public InitView() {
		if (this.pet_type == null || this.data == null) {
			return
		}
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.train_goods_id)
		if (basic) {
			ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetGoodsIconPath(basic.goods_icon))
			this.RefNum()
		}

	}

	public SetData(...parms) {
		this.data = parms[0]
		this.pet_type = this.data.id
		if (this.is_loaded) {
			this.InitView()
		} else {
			this.need_refresh = true
		}
	}

	public DeleteMe() {
		if (this.crystal_view) {
			this.crystal_view.DeleteMe()
			this.crystal_view = undefined
		}

		
		if(this.fight_item_up){
			this.fight_item_up.DeleteMe()
			this.fight_item_up = null
		}

		Laya.Tween.clearAll(this.gp_up)

		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._bg,
			this.effect,
			this.icon,
			this.num,
			this.gp_up,
			this.up_num,
			this.image,
		]
			= this.GetChildrenByNames([

				"_bg",
				"effect",
				"icon",
				"num",
				"gp_up",
				"up_num",
				"image",
			])
		ResManager.GetInstance().LoadFont(this,"figth_big_green_fnt",this.up_num,null,false)
	}
}
window["PartnerNucleusItem"] = PartnerNucleusItem