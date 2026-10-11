import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { CommonRewardItem } from '../common/CommonRewardItem';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { GhostWalkModel } from '../commonModel/GhostWalkModel';
import { GameResPath } from '../util/GameResPath';

export class GhostWalkRewardItem extends BaseItemRenderer {
    need_refresh = false;
    argv;
    WIDTH = 608;
    HEIGT = 120;
    loop_mgr: LoopScrowViewMgr;
    public constructor() {
        super();

        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkRewardItem';
        this.load_callback = () => {
            if (this.need_refresh) {
                this.need_refresh = false;
                this.updateItem.call(this, this.argv);
            }
            ResManager.GetInstance().SetOutsideImageSprite(this, this.imgBg, GameResPath.GetIconOtherPath('ghostWalk', 'ui_activity_02'));
        };
        this.Load();
    }

    public async updateItem(data: ArrayElement<ReturnType<GhostWalkModel['getRewardList']>>) {
        if (!this.is_loaded) {
            this.need_refresh = true;
            this.argv = data;
            return;
        }
        this.data = data;
        this.htmlLastName.style.color = '#663915';
        this.htmlLastName.style.fontSize = 24;
        this.htmlLastName.style.wordWrap = false;
        let nextRank = data.nextRank ? `${data.nextRank == Infinity ? '' : '~' + data.nextRank}` : '';
        this.htmlLastName.innerHTML = data.type == 2 ? '最后一刀' : `第<font color="#0a953e">${data.rank}${nextRank}</font>名${data.nextRank == Infinity ? '之后' : ''}`;
        this.htmlLastName.x = 65 - this.htmlLastName.contextWidth / 2;
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this.listReward, CommonRewardItem, data.reward, LoopScrCon.Horizontal);
        } else {
            this.loop_mgr.replaceAll(data.reward);
        }
    }

    public DeleteMe() {
        super.DeleteMe();
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
    }
    imgBg: Laya.Image;
    htmlLastName: Laya.HTMLDivElement;
    listReward: Laya.List;
    public GetComponents() {
        [this.imgBg, this.htmlLastName, this.listReward] = this.GetChildrenByNames(['imgBg', 'htmlLastName', 'listReward']);
    }
}
window['GhostWalkRewardItem'] = GhostWalkRewardItem;
