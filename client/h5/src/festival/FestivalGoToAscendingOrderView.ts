import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { FestivalModel, FestivalModelEvent, IS2CFestivalBasicInfo } from '../commonModel/FestivalModel';
import { GameResPath } from '../util/GameResPath';
import { SYTweenFunc } from '../util/SYTweenFunc';
import { SYTweenLite } from '../util/SYTweenLite';
import { Trim, Util } from '../util/Util';
import { EnumFestivalTabType, FestivalBaseView } from './FestivalBaseView';
import { FestivalInfoListItem } from './FestivalInfoListItem';

export class FestivalGoToAscendingOrderView extends BaseView1 {
	private gotoBtn: Laya.Box;
	private iconBox: Laya.Box;
	private effectBox: Laya.Box;
	private iconImg: Laya.Box;
	private descList: Laya.List;
	private bgImg: Laya.Image;

	private conf: any;
	private tween_id: number;
	private loop_mgr: LoopScrowViewMgr;

	private get FestivalModel() {
		return FestivalModel.GetInstance();
	}

	public constructor() {
		super();

		this.base_file = 'festival';
		this.layout_file = 'FestivalGoToAscendingOrderView';
		this.use_background = true;
		this.click_bg_toClose = true;
		this.is_center = true;
		this.layer_value = Enum_UILayer.Activity;
		this.destroy_imm = true;

		this.preload_client_config = {
			ClientConfigFiestaIntroduce: false,
		};

		this.load_callback = () => {
			this.LoadSuccess();
			this.InitEvent();
		};


		this.open_callback = () => {
			this.FestivalModel.SetFestivalFirstCheck();
		}
	}

	private LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(
			this,
			this.bgImg,
			GameResPath.GetIcon('festival', 'ui_annu_jd10'),
			true
		);

		let cfg = ResManager.GetInstance().GetGameConfigFromCache(
			this,
			'ClientConfigFiestaIntroduce',
			true
		);
		if (!cfg) return;

		this.conf = cfg;
		this.SetIcon();
		this.SetAwards();
	}

	public InitEvent() {
		// 前往进阶祭典
		Util.AddClickEvent(
			this.gotoBtn,
			() => {
				this.FestivalModel.Fire(
					FestivalModelEvent.OPEN_FESTIVAL_VIEW,
					FestivalBaseView._layout_file,
					EnumFestivalTabType.eFestival,
				);
				this.Close();
			},
			this,
			true
		);
	}

	/**
	 * 渲染icon
	 */
	private SetIcon() {
		let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
		// 默认拿content3的,因为content3的为这个弹窗的信息
		let confChild = this.conf[cmd.act_id.toString()]['content3'];

		// 根据类型现在不同的icon
		switch (confChild.icon_type) {
			case '1': // 图片
				this.iconImg.visible = true;
				this.iconBox.visible = false;
				this.effectBox.visible = false;
				ResManager.GetInstance().SetOutsideImageSprite(
					this,
					this.iconImg,
					GameResPath.GetIcon('festival', Trim(confChild.resource_id)),
					true
				);
				this.ImgModelAnimation();
				break;
			case '2': // 模型
				this.iconImg.visible = false;
				this.iconBox.visible = true;
				this.effectBox.visible = false;
				this.ShowModel(confChild.resource_id);
				break;
			case '3': // 特效
				this.iconImg.visible = false;
				this.iconBox.visible = false;
				this.effectBox.visible = true;
				this.effectBox.width = Laya.stage.width;
				this.effectBox.height = Laya.stage.height;
				this.AddUIEffect(
					Trim(confChild.resource_id),
					this.effectBox,
					null,
					null,
					true
				);
				break;
			default:
				break;
		}
	}

	/**
	 * 渲染奖励
	 */
	private SetAwards() {
		let cmd: IS2CFestivalBasicInfo = this.FestivalModel.GetFestivalBasicInfo();
		let confChild = this.conf[cmd.act_id.toString()]['content3'];
		let list: { item_id: string; desc: string }[] = confChild.award;
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr();
			this.loop_mgr.SetData(
				this.descList,
				FestivalInfoListItem,
				list,
				LoopScrCon.Vertical
			);
		} else {
			this.loop_mgr.replaceAll(list);
		}
	}

	private ShowModel(model_id: string) {
		model_id = JSON.parse(model_id);
		CustomActivityModel.GetInstance().ShowViewModel(
			this,
			this.layout_file,
			model_id,
			this.iconBox,
			null,
			null,
			null,
			null,
			false
		);
	}

	private ImgModelAnimation() {
		if (!this.tween_id) {
			this.tween_id = SYTweenLite.to(
				this,
				this.iconImg,
				SYTweenLite.UiAnimationType.POSY,
				this.iconImg.y - 30,
				2.2,
				null,
				SYTweenFunc.PINGPONG,
				true
			);
		}
	}

	private LocalDeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe();
			this.loop_mgr = null;
		}

		if (this.tween_id) {
			this.tween_id = null;
		}

		super.DeleteMe();
	}

	public DeleteMe() {
		this.LocalDeleteMe();
	}

	public GetComponents() {
		[
			this.gotoBtn,
			this.iconBox,
			this.descList,
			this.bgImg,
			this.effectBox,
			this.iconImg,
		] = this.GetChildrenByNames([
			'gotoBtn',
			'iconBox',
			'descList',
			'bgImg',
			'effectBox',
			'iconImg',
		]);
	}
}
window['FestivalGoToAscendingOrderView'] = FestivalGoToAscendingOrderView;
