import { GoodsAliveState } from "../sysInfo/GoodsItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseItem1 } from "./BaseItem1"
import { SliderEvent } from "./WithBtnHSlider"

export class CHSlider extends BaseItem1 {
	private default_width: number

	public track: Laya.Image
	public trackHighlight: Laya.Image
	public thumb: Laya.Image
	public value_bg: Laya.Image
	public value_text: Laya.Label

	public value: number
	public minimum: number
	public maximum: number
	public snapInterval: number

	protected _maxMove: number
	protected _tx: number
	protected _ty: number

	private offset1 = 13
	private offset2 = 8

	public constructor(parent?) {
		super(parent)
		this.base_file = "common"
		this.layout_file = "GreenHSlider"

		this.load_callback = () => {
			this.LoadSucess()
		}
	}

	private LoadSucess() {
		this.value = 0
		this.minimum = 0
		this.maximum = 100
		this._maxMove = this.display_obj.width - this.thumb.width + this.offset1
		this._tx = 0
		this._ty = 100

		this.thumb.on(Laya.Event.MOUSE_DOWN, this, this.OnMouseDown)
		GlobalEventSystem.Fire(SliderEvent.LOAD_CONPLETE)
	}

	public OnMouseDown() {
		this._maxMove = this.display_obj.width - this.thumb.width + this.offset1
		this._tx = Laya.stage.mouseX;
		this._ty = Laya.stage.mouseY;
		Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
		Laya.stage.once(Laya.Event.MOUSE_UP, this, this.mouseUp);
		Laya.stage.once(Laya.Event.MOUSE_OUT, this, this.mouseUp);
		// this.value_text.text=this.value.toString()
	}

	private mouseMove(e: Event): void {
		if (this.minimum >= this.maximum) return;//如果最小值大于或者等于最大值了，说明不能滑动选择了
		let stage = Laya.stage;
		this.thumb.x += stage.mouseX - this._tx
		if (this.thumb.x > this._maxMove) {
			this.thumb.x = this._maxMove;
		} else if (this.thumb.x <= this.offset1) {
			this.thumb.x = this.offset1;
		}
		this.changeValuePos()
		this.value = (this.thumb.x - this.offset1) / (this._maxMove - this.offset1) * (this.maximum - this.minimum) + this.minimum;
		this._tx = stage.mouseX;
		this._ty = stage.mouseY;
		this.trackHighlight.width = this.thumb.x - this.offset2
		this.value_text.text = this.value.toFixed(0)
		GlobalEventSystem.Fire(SliderEvent.CHANGE_SLIDER_VALUE)
	}

	private mouseUp(e: Event): void {
		let stage = Laya.stage;
		stage.off(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
		stage.off(Laya.Event.MOUSE_UP, this, this.mouseUp);
		stage.off(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	}

	private changeValuePos() {
		this.value_bg.x = this.thumb.x + 20
		this.value_text.x = this.thumb.x - 38
	}

	public changeValue() {
		if (!this.is_loaded) return
		if (this.value > this.maximum) {
			this.value = this.maximum
		} else if (this.value <= this.minimum) {
			this.value = this.minimum
		}
		let v: number = (this.value - this.minimum) / (this.maximum - this.minimum);
		v = isNaN(v) ? 1 : v;
		this.thumb.x = v * (this._maxMove - this.offset1) + this.offset1
		if (this.thumb.x > this._maxMove) {
			this.thumb.x = this._maxMove;
		} else if (this.thumb.x <= this.offset1) {
			this.thumb.x = this.offset1;
		}
		this.changeValuePos()
		this.trackHighlight.width = this.thumb.x - this.offset2
		this.value_text.text = this.value.toFixed(0)

	}

	public createChildren() {
		super.createChildren()
		// this.default_width = this.trackHighlight.width - this.thumb.width * 0.5;
	}

	public SetCustomWidth(width) {
		this.track.width = width
		this.trackHighlight.width = width - 4
		this.default_width = this.trackHighlight.width - this.thumb.width * 0.5
		this.changeValue()
	}

	public SetDefaultWidth(width) {
		this.default_width = width
	}

	public GetComponents() {
		[
			this.track,
			this.trackHighlight,
			this.thumb,
			this.value_bg,
			this.value_text
		]
			= this.GetChildrenByNames([
				"track",
				"trackHighlight",
				"thumb",
				"value_bg",
				"value_text"
			])
	}

	protected getCThumbRange(): number {
		// let bounds = egret.$TempRectangle;
		// this.track.getLayoutBounds(bounds);
		// let thumbRange = bounds.width;
		// this.thumb.getLayoutBounds(bounds);
		// return thumbRange - 10; // - bounds.width;
		// return this.thumb.x-43
		return 0
	}

	protected updateSkinDisplayList(): void {
		// let self = this;
		// if (!self.thumb || !self.track)
		//     return;
		// // let values = self.$Range;
		// let thumbRange = self.getCThumbRange();
		// let maximum = values[0];
		// let minimum = values[2];
		// let range = maximum - minimum;
		// let thumbPosTrackX = (range > 0) ? ((self.pendingValue - minimum) / range) * thumbRange : 0;
		// thumbPosTrackX = maximum >= 0 && minimum >= 0 && maximum == minimum ? self.default_width : thumbPosTrackX;
		// let thumbPos = self.track.localToGlobal(thumbPosTrackX, 0, egret.$TempPoint);
		// let thumbPosX = thumbPos.x;
		// let thumbPosY = thumbPos.y;
		// let thumbPosParentX = self.thumb.$parent.globalToLocal(thumbPosX, thumbPosY, egret.$TempPoint).x;
		// let bounds = egret.$TempRectangle;
		// self.thumb.getLayoutBounds(bounds);
		// self.thumb.x = Math.round(thumbPosParentX);
		// // self.thumb.y =  bounds.y);
		// if (self.trackHighlight && self.trackHighlight.$parent) {
		//     let trackHighlightX = self.trackHighlight.$parent.globalToLocal(thumbPosX, thumbPosY, egret.$TempPoint).x - thumbPosTrackX;
		//     self.trackHighlight.x = thumbPosTrackX > 0 ? Math.round(trackHighlightX) : 0;
		//     self.trackHighlight.width = thumbPosTrackX > 0 ? Math.round(thumbPosTrackX) : 0;
		// }
	}
}

window["CHSlider"] = CHSlider