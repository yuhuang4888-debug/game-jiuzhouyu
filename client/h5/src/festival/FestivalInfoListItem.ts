import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { PlatformManager } from '../PlatformManager';
export class FestivalInfoListItem extends BaseItemRenderer {

	WIDTH = 200
	HEIGT = 42

	private iconBox: Laya.Box;
	private descHtml: Laya.HTMLDivElement;
	private itenInfo: BaseAwardItem;

	public constructor() {
		super();
		this.base_file = 'festival';
		this.layout_file = 'FestivalInfoListItem';
		this.load_callback = () => {
			if (!this.itenInfo) {
				this.itenInfo = new BaseAwardItem(this.iconBox)
				this.itenInfo.Load()
				this.itenInfo.SetItemSize(52, 52);
				this.itenInfo.SetItembgVisible(false);
			}
		};
		this.Load();

	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data;
			if(PlatformManager.IsEyouPlatform()){
				this.descHtml.style.bold = true;
				this.descHtml.style.wordWrap = true;
			this.descHtml.style.fontSize = 20;
			this.descHtml.style.color = '#663915';
				this.descHtml.innerHTML = data.desc;
				this.descHtml.style.lineHeight = 10
				this.descHtml.style.leading = 0.1
				this.descHtml.style.width = 260
				this.descHtml.y = (42-this.descHtml.contextHeight)/2
			}else{
				this.descHtml.style.fontSize = 20;
				this.descHtml.style.color = '#663915';
			this.descHtml.width = 250;
			this.descHtml.style.wordWrap = true;
			this.descHtml.style.lineHeight = 22;
			this.descHtml.style.bold = true;
			this.descHtml.innerHTML = data.desc;
			}
			if (!this.itenInfo) {
				this.itenInfo = new BaseAwardItem(this.iconBox);
				this.itenInfo.Load();
			}
			this.itenInfo.SetItemSize(52, 52);
			this.itenInfo.SetItembgVisible(false);
			this.itenInfo.SetData(data.item_id);
			this.itenInfo.SetShowEffect(false)
		}
	}

	public DeleteMe() {

		if (this.itenInfo) {
			this.itenInfo.DeleteMe()
			this.itenInfo = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[this.iconBox, this.descHtml] = this.GetChildrenByNames([
			'iconBox',
			'descHtml',
		]);
	}
}

window['FestivalInfoListItem'] = FestivalInfoListItem;
