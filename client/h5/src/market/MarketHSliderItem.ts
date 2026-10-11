import { WithBtnHSlider } from "../common/WithBtnHSlider"
export class MarketHSliderItem extends WithBtnHSlider {
	public constructor(parent?, default_value?, step?, min?, max?, show_num?, call_back?, num_in_center?) {
		super(parent)


		this.base_file = "market"
		this.layout_file = "MarketHSliderItem"
	}
}

window["MarketHSliderItem"] = MarketHSliderItem