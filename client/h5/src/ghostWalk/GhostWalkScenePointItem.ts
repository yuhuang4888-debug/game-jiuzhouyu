import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { GhostWalkEvent, GhostWalkModel, IGhostWalkPointInfo } from '../commonModel/GhostWalkModel';
import { Util } from '../util/Util';

export class GhostWalkScenePointItem extends BaseItemRenderer {
    WIDTH = 220; //86 + 13
    HEIGT = 36;
    public constructor() {
        super();

        this.base_file = 'ghostWalk';
        this.layout_file = 'GhostWalkScenePointItem';
        this.load_callback = () => {
            Util.AddClickEvent(
                this.selectBox,
                () => {
                    if (!this.data) return;
                    GhostWalkModel.ins.Fire(GhostWalkEvent.GO_POINT, this.data);
                },
                this,
                false
            );
        };
        this.Load();
    }

    public dataChanged() {
        if (!super.dataChanged()) return;
        this.selectBox.visible = this.selected;
        this.lblPointName.text = this.data[1];
    }

    public DeleteMe() {
        super.DeleteMe();
    }
    lblPointName: Laya.Label;
    _img_line: Laya.Image;
    selectBox: Laya.Image;
    public GetComponents() {
        [this.lblPointName, this._img_line, this.selectBox] = this.GetChildrenByNames(['lblPointName', '_img_line', 'selectBox']);
    }
}
window['GhostWalkScenePointItem'] = GhostWalkScenePointItem;
