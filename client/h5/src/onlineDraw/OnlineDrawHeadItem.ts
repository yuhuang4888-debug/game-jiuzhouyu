import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"

export class OnlineDrawHeadItem extends BaseItem1 {
	_playerhead: Laya.Box
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_img_nothing: Laya.Image
	_img_nothing1: Laya.Image

	private index
	private data
	head
	//func
	SetData
	SetHead

	public constructor(parent) {
		super(parent)
		this.base_file = "onlineDraw"
		this.layout_file = "OnlineDrawHeadItem"

		this.SetHead = () => {
			let career = this.data && this.data.career ? this.data.career : "s"
			let picture = this.data && this.data.picture ? this.data.picture : undefined
			if (this.head == null) {
				this.head = new CustomHeadItem(this._playerhead)
				this.head.Load()
			}
			this.head.SetData(undefined, career, picture)
			this.head.ExcuteCallback(() => {
				//this.head.SetScale(0.99)
			})
			//this._playerhead.setData(undefined, career, picture, undefined, undefined, 99)
			if (this.data) {
				this._img_nothing1.visible = false
				this._img_nothing.visible = false
				this._playerhead.visible = true
				this._lb_name.visible = true
				this._lb_name.text = this.data.name

			} else {
				this._img_nothing1.visible = true
				this._img_nothing.visible = true
				this._playerhead.visible = false
				this._lb_name.visible = false
			}
		}

		this.SetData = (index, data) => {
			this.index = index
			this.data = data
			this.SetHead()
		}

		this.DeleteMe = () => {
			if (this.head) {
				this.head.DeleteMe()
				this.head = null
			}
			super.DeleteMe()
		}
	}

	public GetComponents() {
		[
			this._playerhead,
			this._Image1,
			this._lb_name,
			this._img_nothing,
			this._img_nothing1
		]
			= this.GetChildrenByNames([

				"_playerhead",
				"_Image1",
				"_lb_name",
				"_img_nothing",
				"_img_nothing1"
			])
	}
}
window["OnlineDrawHeadItem"] = OnlineDrawHeadItem