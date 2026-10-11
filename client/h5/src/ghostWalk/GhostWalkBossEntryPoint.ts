import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { GhostWalkEvent, GhostWalkModel, IGhostWalkPointInfo } from '../commonModel/GhostWalkModel';
import { Util } from '../util/Util';

export class GhostWalkBossEntryPoint extends BaseItemRenderer {
    need_refresh = false;
    argv: IGhostWalkPointInfo;
    WIDTH = 138;
    HEIGT = 38;
    public constructor() {
        super();

        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkBossEntryPoint';
        this.load_callback = () => {
            if (this.need_refresh) {
                this.need_refresh = false;
                this.updateItem.call(this, this.argv);
            }
            this.initEvent();
        };
        this.Load();
    }

    public updateItem(data: IGhostWalkPointInfo) {
        if (!this.is_loaded) {
            this.need_refresh = true;
            this.argv = data;
            return;
        }
        this.argv = data || this.argv;
        this.lblPoint.text = this.argv[1];
    }

    private initEvent() {
        Util.AddClickEvent(
            this.clickArea,
            () => {
                if (!this.argv) return;
                GhostWalkModel.ins.Fire(GhostWalkEvent.GO_POINT, this.argv, true);
            },
            this,
            false
        );
    }

    public DeleteMe() {
        super.DeleteMe();
        this.argv = null;
    }
    clickArea: Laya.Box;
    lblPoint: Laya.Label;
    public GetComponents() {
        [this.clickArea, this.lblPoint] = this.GetChildrenByNames(['clickArea', 'lblPoint']);
    }
}
window['GhostWalkBossEntryPoint'] = GhostWalkBossEntryPoint;
