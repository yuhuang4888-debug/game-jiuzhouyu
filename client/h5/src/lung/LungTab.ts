import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { LungDotSubType, LungModel } from "../commonModel/LungModel";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";

export class LungTab extends BaseItemRenderer {
	public WIDTH = 150
	public HEIGT = 52

	private model: LungModel
	public constructor() {
		super()
		this.base_file = "lung"
		this.layout_file = "LungTab"
		this.model = LungModel.GetInstance();
		this.Load()
	}

	public load_callback() {
		this.InitEvent();
	}

	public InitEvent() {
		let dot_fun = (mType, rType) => {
			if (mType == ModuleType.LUNG_DOT && (rType == LungDotSubType.StoneExchenge || rType == LungDotSubType.Shop)) {
				this.SetRedDot()
			}
		}
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, dot_fun)
	}

	protected dataChanged(): void {
		if (super.dataChanged() && this.data) {
			this._lb.text = this.data.name
			this.SetRedDot()
			this._Image1.visible = !this.selected
			this._Image2.visible = this.selected
			if (this.selected) {
				this._lb.color = "#9b572f"
				// this._lb.strokeColor = "#E1743A"
				// this._lb.stroke = 1
				// ResManager.GetInstance().SetImageSprite(this, this._Image1, "common2_asset", "uian_003a")
			} else {
				this._lb.color = "#FFFFFF"
				// this._lb.strokeColor = "#B38270"
				// this._lb.stroke = 1
				// ResManager.GetInstance().SetImageSprite(this, this._Image1, "common2_asset", "uian_003c")
			}
		}
	}

	public SetRedDot() {
		if (this.data) {
			if (this.data.index == 0) {
				let show = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT, LungDotSubType.StoneExchenge)
				this.redDisplay.visible = show
			} else if (this.data.index == 1) {
				let show = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT, LungDotSubType.Shop)
				this.redDisplay.visible = show
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe();
	}
	

	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb: Laya.Label
	redDisplay: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb,
			this.redDisplay,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb",
				"redDisplay",
			])
	}
}
window["LungTab"] = LungTab