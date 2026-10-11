import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"

export class FirstBloodRewardView extends BaseView1 {
	Content
	InitEvent
	InitView
	click_bg_toClose
	close
	close_callback
	is_center
	item_list
	open_callback
	reward
	title
	title_text
	use_background
	image: Laya.Image
	close_img: Laya.Image
	ScrollView: Laya.Panel

	public constructor() {
		super()


		this.base_file = "firstBlood"
		this.layout_file = "FirstBloodRewardView"
		this.is_center = true
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm=true
		this.item_list = []
		this.load_callback = () => {

			this.InitEvent()
			this.InitView()
		}
		this.open_callback = () => {
			// let mask = this.GetChild("ScrollView/Viewport").GetComponent("Image")
			// this.RegisterMask(mask)
		}
		this.close_callback = () => {
			if (this.item_list) {
				for (let _tmpi in this.item_list) {
					var obj = this.item_list[_tmpi]
					obj.DeleteMe()
					obj=null
				}
				this.item_list = []
			}
		}


		this.InitEvent = () => {
			Util.AddClickEvent(this.close_img, () => {
				this.Close()
			}
				, this, true)
		}

		this.InitView = () => {
			this.title_text.text = this.title
			let i = 0
			for (let _ in this.reward) {
				var v = this.reward[_]
				let item = this.item_list[i] && this.item_list[i] || new EquipmentItem(this.Content, null, this.layer_value)
				this.item_list[i] = item
				item.SetScale(87/127)
				// item.SetMaskId(1)
				item.Load()
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, v[2], lock)
				}
				let src
				if(v[4]!=null){
					if(v[4]==0){
						// src="全服首杀"
						src="uiss_003a"
					}else{
						// src="全服归属"
						src="uiss_003b"
					}
				}
				let image=new Laya.Image()
				image.skin="resource/game/firstBlood/texture/"+src+".png"
				image.width=55
				image.height=55
				image.left=10
				image.top=10
				item.ExcuteCallback(() => {
					item.display_obj.addChild(image)
				})
				i = i + 1
			}
		}



	}
	public Open(...new_args) {

		let args = new_args
		this.title = args[0]
		this.reward = args[1]
		super.Open()
	}

	public GetComponents() {
		[
			this.image,
			this.close_img,
			this.title_text,
			this.image,
			this.ScrollView,
			this.Content,
		]
			= this.GetChildrenByNames([

				"image",
				"close_img",
				"title_text",
				"image",
				"ScrollView",
				"Content",
			])
		this.ScrollView.hScrollBar.visible=false
	}
}
window["FirstBloodRewardView"] = FirstBloodRewardView