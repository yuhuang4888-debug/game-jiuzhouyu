import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"

export class TopVipActivityDetailItem extends BaseItem1 {
	_Image1: Laya.Image
	introduce_lb: Laya.HTMLDivElement
	need_refresh_data
	vo

	public constructor(parent?) {
		super(parent)


		this.need_refresh_data = false
		this.base_file = "topVip"
		this.layout_file = "TopVipActivityDetailItem"
		this.load_callback = () => {

			this.LoadSuccess()
		}


	}

	public LoadSuccess() {

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdataView()
		}
	}

	public Setdata(vo?) {

		this.vo = vo
		if (this.is_loaded) {
			this.UpdataView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdataView() {

		this.introduce_lb.innerHTML = Util.StrToHTML(this.vo)
		this.display_obj.height=this.introduce_lb.contextHeight+5
	}


	public GetComponents() {
		[
			this._Image1,
			this.introduce_lb,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"introduce_lb",
			])
		this.introduce_lb.style.fontSize=18
		this.introduce_lb.style.color="#663915"
		this.introduce_lb.style.leading=5
		this.introduce_lb.width=330
	}
}
window["TopVipActivityDetailItem"]=TopVipActivityDetailItem