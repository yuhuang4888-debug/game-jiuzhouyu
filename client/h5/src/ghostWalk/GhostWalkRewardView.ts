import { Util } from '../util/Util';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { BaseView1 } from '../common/BaseView1';
import { GhostWalkRewardItem } from './GhostWalkRewardItem';
import { GhostWalkModel } from '../commonModel/GhostWalkModel';
import { ResManager } from '../common/ResManager';
import { GameResPath } from '../util/GameResPath';

export class GhostWalkRewardView extends BaseView1 {
    loop_mgr: LoopScrowViewMgr;
    cfg;
    model: GhostWalkModel;
    public constructor() {
        super();
        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkRewardView';
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true;
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        this.change_scene_close = true;
        this.model = GhostWalkModel.ins;
        this.load_callback = () => {
            this.initView();
            this.initEvent();
        };
    }

    private initView() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.img_line, GameResPath.GetIconOtherPath('ghostWalk', 'ui_activity_02'));
        this.loop_mgr = new LoopScrowViewMgr();
        let rewardList = this.model.getRewardList(78);
        this.loop_mgr.SetData(this.listReward, GhostWalkRewardItem, rewardList, LoopScrCon.Vertical);
    }

    private initEvent() {
        Util.AddClickEvent(this.btnClose, this.Close.bind(this), this, true);
        Util.AddClickEvent(this.btnReturn, this.Close.bind(this), this, true);
    }

    public DeleteMe() {
        super.DeleteMe();
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
    }
    img_line: Laya.Image;
    btnClose: Laya.Image;
    btnReturn: Laya.Image;
    listReward: Laya.List;
    lblReturn: Laya.Label;
    lblDesc: Laya.Label;
    public GetComponents() {
        [this.img_line, this.btnClose, this.btnReturn, this.listReward, this.lblReturn, this.lblDesc] = this.GetChildrenByNames(['img_line', 'btnClose', 'btnReturn', 'listReward', 'lblReturn', 'lblDesc']);
    }
}
window['GhostWalkRewardView'] = GhostWalkRewardView;
