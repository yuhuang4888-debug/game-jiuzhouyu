import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { Util } from "../util/Util";

export class FtvCollectionGoodItem extends BaseItem1 {
	public _group: Laya.Box;
	public _gp_good: Laya.Box;
	public _lb_count

	private type
	private index
	good_item
	info
	parent_mask

	public constructor(parent?) {
		super(parent)

		this.type = null
		this.index = null
		this.info = null  //1：type_id；2：拥有数量；3：条件个数；4：item类型；5：item_index
		this.good_item = null

		this.base_file = "ftvCollectionExchange"
		this.layout_file = "FtvCollectionGoodItem"
	}

	public InitView() {

		this.InitGoodsItem()
	}

	public RefreshCount(have_num?) {
		this._lb_count.style.fontSize = 18
		this._lb_count.style.color = "#FFFFFF"
		this._lb_count.style.stroke = 4
		this._lb_count.style.strokeColor = "#402e24"
		let color = null
		if(have_num!=null){
			if (have_num >= 0) {
				this.info[1]=have_num
				color = (have_num >= this.info[2] ? ("#00fa64") : ("#fe1a1a"))
				this._lb_count.innerHTML=Util.StrToHTML("<font color='" + color + "'>" + have_num + "</font>" + "<font color='#FFFFFF'>/"+this.info[2]+ "</font>" )
			}
				// this.good_item.ForceSetNumberInFlow(Util.StrToHTML("<font color='" + color + "'>" + have_num + "</font>" + "<font color='#663915'>/"+this.info[2]+ "</font>" ))
			// } else {
			// 	color = (this.info[1] >= this.info[2] ? ("#b3ff48") : ("#ff4f50"))
			// 	this._lb_count.innerHTML=Util.StrToHTML("<font color='" + color + "'>" + this.info[1] + "</font>" +"<font color='#663915'>/"+ this.info[2]+ "</font>" )
			// 	// this.good_item.ForceSetNumberInFlow(Util.StrToHTML("<font color='" + color + "'>" + this.info[1] + "</font>" +"<font color='#663915'>/"+ this.info[2]+ "</font>" ))
			// }
		}else{
			color = (this.info[1] >= this.info[2] ? ("#00fa64") : ("#fe1a1a"))
			this._lb_count.innerHTML=Util.StrToHTML("<font color='" + color + "'>" + this.info[1] + "</font>" +"<font color='#FFFFFF'>/"+ this.info[2]+ "</font>" )
		}
		this._lb_count.width=500
	}

	public InitGoodsItem() {
		if (!this.good_item) {
			this.good_item = new BaseAwardItem(this._gp_good)
			let num = (this.info[3] == "reward" ? (this.info[2]) : (0))
			// this.good_item.SetIconSizeData(true,50,76)
			this.good_item.SetItemSize(87, 87)
			this.good_item.SetData(this.info[0], num)
			this.good_item.Load()
		}
		this.good_item.ExcuteCallback(() => {
			// this._gp_good.addChildAt(this.good_item, 0)
			// let num = (this.info[3] == "reward" ? (this.info[2]) : (0))
			// this.good_item.SetData(this.info[0], num)
			this.RefreshCount()
		}
		)
	}

	public SetData(...new_args) {
		let pram = new_args
		this.info = pram
		if (!this.info) {
			return
		}
		this.InitView()
	}

	public DeleteMe() {
		if (this.good_item) {
			this.good_item.DeleteMe()
			this.good_item = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._group,
			this._gp_good,
			this._lb_count,
		]
			= this.GetChildrenByNames([

				"_group",
				"_gp_good",
				"_lb_count",
			])
	}
}

window["FtvCollectionGoodItem"]=FtvCollectionGoodItem