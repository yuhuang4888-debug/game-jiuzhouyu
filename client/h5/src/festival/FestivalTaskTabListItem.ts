import { ResManager } from '../common/ResManager';
import { FestivalModel, FestivalModelEvent } from '../commonModel/FestivalModel';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { Util } from '../util/Util';

export class FestivalTaskTabListItem extends BaseItemRenderer {

	WIDTH = 150;
	HEIGT = 177;

	private conf: any;

	private get FestivalModel() {
		return FestivalModel.GetInstance();
	}

	public constructor() {
		super();

		this.base_file = 'festival';
		this.layout_file = 'FestivalTaskTabListItem';

		this.load_callback = () => {
			this.InitEvents();
		};

		this.Load();
	}

	private InitEvents() {
		// 点击页签
		let ClickTab = () => {
			if (this.data) {
				this.FestivalModel.Fire(FestivalModelEvent.FESTIVAL_TASK_TAB_SELECT, this.data, this.index);
			}
		}
		Util.AddClickEvent(this.itemBox, ClickTab, this, true);
	}


	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data;
			let name = this.FestivalModel.GetTaskName(data)
			if(!name) return
			this.descLab.text = name['tab_name'];
			this.descLab.leading = 2;
			ResManager.GetInstance().SetImageSprite(
				this,
				this.iconImg,
				'festival',
				this.selected ? 'ui_yq_jd021' : 'ui_yq_jd01'
			);
			this.descLab.color = this.selected ? '#000000' : '#6F4264';

			this.redImg.visible = this.FestivalModel.GetTaskTabRedDot(+data);
		}
	}

	// public DeleteMe(): void {
	// 	super.DeleteMe();
	// }

	itemBox: Laya.Box
	iconImg: Laya.Image
	descLab: Laya.Label
	redImg: Laya.Image
	public GetComponents() {
		[
			this.itemBox,
			this.iconImg,
			this.descLab,
			this.redImg,
		]
			= this.GetChildrenByNames([

				"itemBox",
				"iconImg",
				"descLab",
				"redImg",
			])
	}
}
window["FestivalTaskTabListItem"] = FestivalTaskTabListItem