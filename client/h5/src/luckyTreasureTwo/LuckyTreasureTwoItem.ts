import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"

export class LuckyTreasureTwoItem extends BaseItem1 {

	need_refresh_data
	model
	item
	data
	type_id


	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false;
		this.base_file = "luckyTreasureTwo"
		this.layout_file = "LuckyTreasureTwoItem"
		this.item = null
		this.model = CustomActivityModel.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
		}

	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
		this.BindEvent(this.model, CustomActivityDefine.EVENT.STOP_AUTO, (base_type?, sub_type?, type_id?) => {
			if (base_type == 102 && this.model.lucky_sub_type == sub_type && this.type_id == type_id) {
				this.grade_img.visible = true
			}
		})
	}

	public Setdata?(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {

		if (!this.item) {
			this.item = new EquipmentItem(this.item_gp)
			this.item.SetItemSize(88, 88)
			this.item.Load()
			// this.item.ExcuteCallback(() => {
			// 	this.item.ReplaceUIShader(this.grade_img)
			// })
		}
		let reward = ErlangParser.GetInstance().parse(this.data.reward)
		let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
		let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		this.type_id = type_id
		if (goods_vo) {
			this.item.SetData(goods_vo.type_id, reward[0][2], lock)
		}
		this.name_text.text = this.data.name
		this.grade_img.visible = this.data.is_grade
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}





	Image: Laya.Image
	item_gp: Laya.Box
	name_text: Laya.Label
	grade_img: Laya.Image
	public GetComponents() {
		[
			this.Image,
			this.item_gp,
			this.name_text,
			this.grade_img,
		]
			= this.GetChildrenByNames([

				"Image",
				"item_gp",
				"name_text",
				"grade_img",
			])
	}
}
window["LuckyTreasureTwoItem"] = LuckyTreasureTwoItem